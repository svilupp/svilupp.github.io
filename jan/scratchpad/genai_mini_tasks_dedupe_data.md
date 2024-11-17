@def title = "Duplicate No More: Clean up the Contact Data in Minutes with LLMs"
@def published = "18 January 2024"
@def drafted = "18 January 2024"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Discover how to transform the once daunting task of contact data deduplication into a swift, simple process using Julia and the FEBRL 1 dataset, all within five minutes with PromptingTools.jl

\toc 

## Introduction: The Evolution of Data Deduplication
In the world of data management, deduplication stands as a crucial, yet often challenging task, vital for maintaining the integrity and quality of contact datasets. Traditionally, this process required extensive labor and time. 

With LLMs, you can now deduplicate your data in a matter of minutes (only the first pass though! You need strong data governance and supporting processes to reach the gold quality and maintain it!)


## Understanding the Challenge

Data deduplication can be conceptualized similarly to traditional search engines and Retrieval-Augmented Generation (RAG) models. Here's a brief breakdown:

- **Preprocessing:** Clean and enrich data for consistency and accuracy.
- **Retriever:** Identify similar records, akin to a search engine finding relevant documents.
- **Ranker:** Use machine learning to prioritize and confirm duplicates, similar to ranking search results.
- **Output:** Deliver clean, deduplicated data ready for database use, so it can verified further or acted upon.

## Setting Up the Environment

We'll be using FEBRL 1 dataset from the [recordlinkage](https://recordlinkage.readthedocs.io/en/latest/ref-datasets.html#recordlinkage.datasets.load_febrl1) package. It contains a collection of 1000 records, half of which are duplicates. This dataset serves as an excellent starting point for our deduplication adventure.

```julia
using DataFramesMeta, CSV, Downloads
using LinearAlgebra: normalize, dot
using PromptingTools
const PT = PromptingTools

# Download the dataset
Downloads.download("# https://github.com/J535D165/recordlinkage/tree/master/recordlinkage/datasets/febrl",
    "febrl-dataset1.csv");

# process the data
df = @chain begin
    CSV.File("febrl-dataset1.csv")
    DataFrame
    rename(_, strip.(names(_)))
    transform(_, names(_, AbstractString) .=> ByRow(strip), renamecols=false)
    # Create more descriptive text blurb -- play with the format
    @rtransform :text_blob = "Contact details: $(:given_name) $(:surname), living at $(:street_number) $(:address_1), $(:address_2), $(:suburb), Postcode: $(:postcode), State: $(:state)"
end;
```


## Retrieving Duplicates with Embeddings
We use embeddings to convert contact details into numerical formats, making it easier to identify similar records, such as those sharing a ZIP code.

```julia
embeddings = aiembed(df.text_blob, normalize).content
# [ Info: Tokens: 35386 @ Cost: $0.0035 in 5.5 seconds
# PromptingTools.DataMessage(Matrix{Float64} of size (1536, 1000))

# pairwise distances -- you could do it much faster with Distances.jl package
dists = let embeddings = embeddings
    dists = zeros(Float32, size(embeddings, 2), size(embeddings, 2))
    @inbounds for i in axes(embeddings, 2)
        for j in 1:i
            dists[i, j] = sum(@view(embeddings[:, i]) .* @view(embeddings[:, j]))
            dists[j, i] = dists[i, j]
        end
    end
    dists
end
```

Voila! A few seconds and less than a cent later, we have our retriever.

Let's explore candidate duplicates for item 3:

```julia
let i = 3
    dupe_idxs = sortperm(dists[i, :], rev=true) |> x -> first(x, 10)
    @chain begin
        df[dupe_idxs, :]
        @transform :dists = dists[i, dupe_idxs]
        select(_, :dists, :given_name, :surname, :street_number, :address_1, :address_2, :suburb, :postcode, :state)
    end
end
```
```plaintext
10×9 DataFrame
 Row │ dists     given_name  surname     street_number  address_1           address_2               suburb          postcode  state   
     │ Float32   String31    String31    String7        SubStrin…           SubStrin…               String31        Int64     String7 
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 1.0       deakin      sondergeld  48             goldfinch circuit   kooltuo                 canterbury          2776  vic
   2 │ 0.99449   deakin      sondergeld  231            goldfinch circuit   kooltuo                 canterbury          2509  vic
   3 │ 0.866091  timothy     zaluski     94             fraser court        coolibah                mount melville      3095  vic
   4 │ 0.865136  timothy     coffey      23             bacchus circuit     frankston caravan park  werrington          2450  vic
   5 │ 0.863814  eriaz       keacny      6              nicklin cre scent   char lstown             longeach            2706  vic
   6 │ 0.862886  mathilde    delvendiep  66             giliruk crescent                            ivanhoe east        3011  qld
   7 │ 0.860956  jayde       van keulen  4              macgregor street    glendower               cremorne            3566  vic
   8 │ 0.860592  jayde       grosser     41             gundaroo road                               baringhup           3173  vic
   9 │ 0.860432  finley      haeusler    27             noarlunga crescent  sprin g ridge           namnour             3180  vic
  10 │ 0.85976   jayde       grosser     55             gundaroo road                               baringhup           3173  vic
```
Nice! Clearly, there is a sharp drop-off in the distance, so we could probably set a threshold to filter out the non-duplicates.

You can experiment with different address permutations to check how the distance behaves:
```julia
# "Contact details:  deakin  sondergeld, living at  48  goldfinch circuit,  kooltuo,  canterbury, Postcode: 2776, State:  vic"
e1 = aiembed("Contact details:  deakin  sondergeld, kooltuo,  canterbury, Postcode: 2776, State:  vic", normalize).content
dot(embeddings[:, 3], e1) # 0.9738679742013003
e2 = aiembed("Contact details:  deakin  sondergeld, living at goldfinch,  kooltuo,  canterbury, Postcode: 2776, State:  vic", normalize).content
dot(embeddings[:, 3], e2) # 0.9935216848792419
e3 = aiembed("Contact details:  d. m. p. sondergeld, living at goldfinch circuit,  kooltuo,  canterbury, Postcode: , State:  vic", normalize).content
dot(embeddings[:, 3], e3) # 0.9525012240822797
e4 = aiembed("Contact details:  deakin  sondergeld, living at  231  goldfinch,  kooltuo,  canterbury, Postcode: 2509, State:  ny", normalize).content
dot(embeddings[:, 3], e4) # 0.9830825248399336
```

## Ranking with Machine Learning
Now let's proceed to the ranking model. A ranking model then evaluates these potential duplicates, efficiently identifying the true matches.

Let's define our prompt template. Notice the use of `{{record1}}` and `{{record2}}` placeholders. These will be replaced with the actual records during the ranking process.

```julia
# Simple PromptingTools.jl template. Save it with `PT.save_template`
dedupe_template = [
    PT.SystemMessage(
        """
        You're a world-class record linkage engineer. 

        Your task is to compare two records and determine whether they refer to the same person.

        **Instructions**
        - You're given two records, each of which contains a name and address.
        - You must return a judgement on whether they are duplicates or not.
        - You must also return a confidence score, which is a number between 0 and 100 that indicates how confident you are that the two records refer to the same person. 
            If you're not confident, you must return a confidence score of 0. If you're very confident, you must return a confidence score of 100.
        - Consider that people can move house and change an address, so you should not assume that the addresses must match exactly for the records to be duplicates.
        - Output format: `Rationale: <provide your reasoning>\nDuplicate: true/false\nConfidence: 0-100`
        """), PT.UserMessage("""
            # Record 1

            {{record1}}

            # Record 2

            {{record2}}

            Think it through step by step.
            """)]

dupe_idxs = sortperm(dists[3, :], rev=true) |> x -> first(x, 10)
msg = aigenerate(dedupe_template; record1=df[3, :text_blob], record2=df[dupe_idxs[2], :text_blob], model="gpt4t")
```

```plaintext
[ Info: Tokens: 573 @ Cost: \$0.012 in 10.9 seconds
AIMessage("Rationale: The records indicate that the individual has the same unique name, "deakin sondergeld." 
This increases the likelihood that the records refer to the same individual because the name is uncommon. However, the addresses listed have different house numbers and postcodes, which suggests a discrepancy in the details provided. 
Given that "Goldfinch Circuit" is a part of both addresses and the locations, "Kooltuo, Canterbury" and the state "Vic" match, it's possible that one of the records has a typo or outdated information. Human error in data entry or changes in residence without updating all records could explain the difference in house number and postcode.

Despite the similarities in name, location, and the unusual circumstance that two individuals with an uncommon name would live on the same street, we must account for the possibility of a data entry error or an outdated address in one of the records. 
An update to a person's address may lead to slight discrepancies in databases that are not synchronized. The difference in postcodes also suggests the potential for such an error as the entire street is unlikely to have multiple postcodes unless it is extremely long and the municipality has assigned different postcodes to different segments.~

Duplicate: true
Confidence: 75

Given the information, we have a reasonably high level of confidence that these records refer to the same person. The confidence is not at 100 due to the variations in house number and postcode which introduce some uncertainty. It's worth investigating further to reconcile the discrepancies and confirm the records' accuracy.")
```

Thanks to PromptingTools.jl, we can try several different models:

```julia
msg = aigenerate(dedupe_template; record1=df[3, :text_blob], record2=df[dupe_idxs[2], :text_blob], model="gpt3t")
```

```plaintext
[ Info: Tokens: 411 @ Cost: \$0.0006 in 5.8 seconds
AIMessage("First, let's compare the names in both records. The name "deakin sondergeld" is an exact match in both records.

Next, we can compare the addresses. The street names in the addresses are different; one is "48 goldfinch circuit" and the other is "231 goldfinch circuit." However, the suburb and state are the same.

Based on the differences in the street numbers, there is a low confidence that these two records refer to the same person. 

Rationale: The names match, but the street numbers in the addresses are different. While the suburb and state are the same, the difference in street numbers reduces the confidence that these records are duplicates.
Duplicate: false
Confidence: 20")
```

That's clearly a miss! But technically, we have been very vague in our criteria for duplicates. Could the records be from different years? Could the person have moved? We need to be more specific in our criteria for duplicates. A few-shot prompt would improve the results.

Even better, we could run 1000 examples through GPT-4 and then fine-tune GPT-3.5 or some open-source model on the generated examples to get the best of both worlds.

## Structured Extraction for Databases
We often need to work with the data we get from the LLM. Let's use structured extraction for easy integration into your databases, enhancing overall data management.

```julia
# Give some tips to the model (because the field names differ from the template we provide)
"""
Walk through your reasoning step by step in `rationale` field. 
`duplicate` is a boolean indicating whether the records are duplicates. 
`confidence` is an integer between 0 and 100 indicating how confident you are that the records are duplicates.
"""
@kwdef struct DedupeDecision
    rationale::String
    duplicate::Bool
    confidence::Int
end
decision = aiextract(dedupe_template; record1=df[3, :text_blob], record2=df[dupe_idxs[2], :text_blob], return_type=DedupeDecision, model="gpt3t")
decision.content
```

```plaintext
[ Info: Tokens: 497 @ Cost: \$0.0005 in 2.1 seconds
DedupeDecision("The names and addresses are similar, but the postcodes are different. The confidence is low because the names are common and the addresses are similar, but the postcodes differ significantly.", false, 20)
```

The result is now in our custom Struct, so we can easily integrate it into our database or a data processing pipeline.

## Wrapping Up: Data Deduplication Reimagined

Deduplication is now a breeze, not a chore. Clean, compare, rank, and voila - your data is crisp and duplicate-free (ish). Keep playing with these tools and watch your data worries vanish - like a magician with a data wand! 🪄✨

---

Looking for a bigger challenge? Try this approach on the [Medicare Hospital dataset](https://github.com/chris1610/pbpython/blob/master/data/hospital_account_info.csv) from Practical Business Python [blog](https://pbpython.com/record-linking.html).