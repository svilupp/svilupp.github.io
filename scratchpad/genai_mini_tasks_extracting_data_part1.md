@def title = "GenAI Mini-Tasks: Extracting Data from (.*)? Look No Further!"
@def published = "3 December 2023"
@def drafted = "3 December 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
`aiextract` in PromptingTools.jl is a game-changer for data analysts, offering a quick and efficient way to extract structured data from various text sources, making tedious data extraction tasks a breeze while ensuring security in AI applications.

\toc 

## Say Goodbye to Tedious Data Extraction!

As a data analyst, you're no stranger to the Herculean task of sifting through heaps of documents, emails, and web pages to find those few precious nuggets of information. It's like finding a needle in a haystack, right? But what if I told you that there's a magic wand in the Julia universe that can turn this tedious task into a piece of cake? Enter `aiextract` from PromptingTools.jl and say goodbye to the old days of wrestling with complex regex patterns!

## Example 1: The Contact Information from a Conference

Picture this: You have a blob of notes from a conference mentioning several contacts from different companies that you met and you want to ping them. Traditional methods would have you manually searching each name, company, and contact detail and using some crazy Regex rules. But with `aiextract`, it's a breeze! 

We want to extract the name, company (optional), and email (optional) of the people we met. Let's see how we can do this with `aiextract`:

```julia
using PromptingTools
const PT = PromptingTools

# Extract name, company (optional), email (optional)
struct ContactInfo
    name::String
    company::Union{Nothing,String}
    email::Union{Nothing,String}
end

# Our meeting notes 
str1 = "James, sales rep in Apple, likes to drink tea. He even has an email teadrinker@apple.com. That is still less crazy than crazy.jane@samsung.com. That’s what Jane had on her business card - I couldn’t believe my eyes. You should probably just call her phone instead."

# Let's pick some "detail-oriented" template (optional)
# aitemplates("Detail") 

# we use template :DetailOrientedTask with placeholders task, data. 
# return_type is for the custom struct we defined above
msg = aiextract(:DetailOrientedTask; task="Extract ContactInfo for processing.", data=str1, return_type=ContactInfo)
msg.content
```

```plaintext
[ Info: Tokens: 187 @ Cost: \$0.0003 in 2.0 seconds
PromptingTools.DataMessage(ContactInfo)

ContactInfo("James", "Apple", "teadrinker@apple.com")
```

Great! A few seconds later we have one contact extracted. But what if we want to have all contacts extracted at once? No problem! Just define another struct `ManyContactInfo` that holds a vector of `ContactInfo`:

```julia
struct ManyContactInfo
    contacts::Vector{ContactInfo}
end

msg = aiextract(:DetailOrientedTask; task="Extract all ContactInfo for processing.", data=str1, return_type=ManyContactInfo)

msg.content
```

```plaintext
[ Info: Tokens: 248 @ Cost: \$0.0004 in 2.8 seconds
PromptingTools.DataMessage(ManyContactInfo)

ManyContactInfo(ContactInfo[ContactInfo("James", "Apple", "teadrinker@apple.com"), ContactInfo("Jane", "Samsung", "crazy.jane@samsung.com")])
```

Just a few lines of code, and voilà! You have the names, companies, and optional contact details neatly extracted.

Note that we're using the simplest OpenAI model (GPT 3.5 Turbo), so there is potential to improve for harder tasks.

## Example 2: Measurements in Different Units

Another scenario: You need to extract ages and weights from a narrative, but the weights are in different units (pounds, kilograms). With Julia Enums (see `?@enum`), handling these variations is as easy as pie.

```julia
# Our little story
str2 = """
With 80kg, Joe is a pretty average size. No wonder, he is still too young, having celebrated his 18th birthday last year. 
He always loses in wrestling to Sarah who is much older and heavier. I think she’s around 250 pounds. 
Joe went to her 30th birthday earlier this year.
"""

# Define a special variable WeightUnits that can have only 2 options
@enum WeightUnits Pounds Kilograms

struct BioMeasurement
    name::String
    age::Union{Nothing,Int}
    weight::Union{Nothing,Int}
    weight_units::Union{Nothing,WeightUnits}
end

struct ManyBioMeasurement
    measurements::Vector{BioMeasurement}
end

msg = aiextract(:DetailOrientedTask; task="Extract biomeasurements", data=str2, return_type=ManyBioMeasurement)
msg.content
```

```plaintext
[ Info: Tokens: 265 @ Cost: \$0.0004 in 2.5 seconds
PromptingTools.DataMessage(ManyBioMeasurement)

ManyBioMeasurement(BioMeasurement[BioMeasurement("Joe", 18, 80, Kilograms), BioMeasurement("Sarah", 30, 250, Pounds)])
```

Works like a charm! Except for the age of Joe who celebrated his 18th birthday last year, so he is likely 19 years at this point. We could probably improve the instructions, but let's try a better model first ("gpt4t" is alias for GPT-4 Turbo):

```julia
# we added model="gpt4t" to use a better model
msg = aiextract(:DetailOrientedTask; task="Extract biomeasurements", data=str2, return_type=ManyBioMeasurement, model="gpt4t")
```

```plaintext
[ Info: Tokens: 262 @ Cost: \$0.0042 in 3.5 seconds
PromptingTools.DataMessage(ManyBioMeasurement)

ManyBioMeasurement(BioMeasurement[BioMeasurement("Joe", 19, 80, Kilograms), BioMeasurement("Sarah", 30, 250, Pounds)])
```
It worked! We got Joe's age right and still paid less than half a cent.

A few words of caution before you start extracting the whole internet.

## LLM Security: The Risk of Prompt Injection

When using any Language Model (LLM), like in PromptingTools.jl, it's crucial to be aware of **prompt injection** risks, especially when scanning unknown data sources. For a more detailed introduction to prompt injections, check out [this article](https://www.redsentry.com/blog/what-is-prompt-injection).

Prompt injection occurs when malicious content is embedded in the data being analyzed. This is particularly risky when your LLM accesses private information. For instance, while OpenAI's models present less risk, tools like Microsoft Copilot, which might access sensitive data, can be more vulnerable.

Imagine using an extractor to find an email on a website, but stumbling upon a hidden, malicious prompt—like white text on a white background. This could hijack your LLM, leading it to output incorrect, potentially harmful information, or even compromise your private data.

While these scenarios are not meant to scare you, they highlight the importance of being vigilant. Always consider the potential risks of running LLMs on data you don’t control, and assess whether these risks are acceptable for your project.

## Wrap-Up: Embrace the Future of Data Extraction

So, there you have it! `aiextract` from PromptingTools.jl should become your go-to solution for small to medium data extraction jobs from any text source. It's fast, efficient, and, honestly, a bit magical. Dive into the world of `aiextract` and watch your productivity soar! 🚀👩‍💻👨