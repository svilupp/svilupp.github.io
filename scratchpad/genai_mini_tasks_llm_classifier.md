@def title = "Fast-Track Data Science: Classification with LLMs"
@def published = "19 January 2024"
@def drafted = "19 January 2024"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Explore innovative classification methods using Large Language Models in Julia, offering a quick & dirty alternative to traditional machine learning.

\toc 

## Introduction

Welcome to the latest installment in our "GenAI Mini-Tasks" series! Today's topic: harnessing the power of Large Language Models for quick and effective classification, using the well-known Titanic dataset.

While this approach offers a fun and insightful perspective, we strongly encourage dedicating the effort to build proper machine learning models for serious, real-world applications.

## The Challenge of Quick Classification

Traditional machine learning models excel in structured, tabular data analysis but often require significant time and resources. What if you need a faster, more flexible solution? This is where LLMs shine.

## The Titanic Dataset

Let's prepare our data first. We'll use the well-known Titanic dataset, which contains information about the passengers on the Titanic, including whether they survived or not.

```julia
using Downloads, DataFramesMeta, CSV
using PromptingTools
const PT = PromptingTools

# Download titanic dataset
Downloads.download("https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv", "titanic.csv");

# Preprocessing
clean_column(s::AbstractString) = strip(s) |> x -> replace(x, r"\s+" => "_") |> lowercase
df = @chain CSV.File("titanic.csv") begin
    DataFrame
    rename(_, clean_column.(names(_)))
    ## Create a text blob that captures our features
    @rtransform :text_blob = """Passenger details:
    - Sex: $(:sex)\n- Age: $(:age)\n- Number of sibblings/spouses aboard: $(:sibsp)\n- Number of parents/children aboard: $(:parch)\n- Class: $(:pclass)\n- Fare: $(:fare)\n- Cabin: $(ismissing(:cabin) ? "-" : :cabin) \n- Embarked: $(:embarked)
    """
end

# Show case an example of our text blob
df.text_blob[1] |> print
# Output:
# Passenger details:
# - Sex: male
# - Age: 22.0
# - Number of siblings/spouses aboard: 1
# - Number of parents/children aboard: 0
# - Class: 3
# - Fare: 7.25
# - Cabin: - 
# - Embarked: S
```

LLMs work on text, so we have combined the relevant features in a text blob that we will be sending to the LLM.

## Method 1: Standard Chat Completion

First up is standard chat completion. This method involves directly prompting the LLM for a classification based on text inputs.

One of my favorite things is that prompt engineering with Julia is so easy. 
I can just write the string and leave placeholders in double handlebars (eg, `{{placeholder}}`) to be interpolated on every call.

```julia
tpl = """
You're a world-class expert on the Titanic voyage.

Your task is to predict whether a passenger would have survived or not based on their details.

Response format: `Reasoning: <provide your reasoning here>, Survived: true/false`

### Passenger details

{{passenger_details}}

Think through your prediction step by step and explain your reasoning.
"""
passenger_details= df.text_blob[1]
msg = aigenerate(tpl; passenger_details, model="gpt3t")
```

```plaintext
[ Info: Tokens: 243 @ Cost: \$0.0003 in 4.9 seconds
AIMessage("Based on the given passenger details, my prediction is as follows:

Reasoning: The passenger is a 22-year-old male traveling alone in third class (Class 3).
Third-class passengers were more likely to perish in the Titanic disaster, as they were at a disadvantage when it came to accessing lifeboats due to their lower priority during the evacuation. 
Additionally, being a male may further decrease the chances of survival, as women and children were given priority for lifeboats.

Survived: false")
```

Pretty good, huh? And that's just GPT 3.5!

And the cost? We could get 1000 predictions for \$3 and have it in a few minutes. Considering the labor cost of a data scientist, that's an excellent return on investment!

## Method 2: Logit Bias Trick

The logit bias trick involves adjusting the generation probability of certain tokens, effectively 'biasing' the model's predictions in a desired direction.

If you're not familiar with "tokens", they are usually sub-word units that the LLMs think/speak in. Check out [OpenAI Tokenizer](https://platform.openai.com/tokenizer) and enter different texts (check also the "token ids" tab).

We'll use tokens: "837" (for true) and "905" (for false). We could also introduce the option "unknown" (9987) for the model if it doesn't know the answer, but let's keep it simple.

```julia
# We will use the logit_bias parameter of OpenAI API to bias the model towards one of our two tokens
# Notice that we set max_tokens=1 to ensure that the model only generates the one token we want
api_kwargs = (; logit_bias=Dict(837 => 100, 905 => 100),
    max_tokens=1, temperature=0)
# We need to tell our model to first output only true/false
msg = aigenerate(tpl * "\nFirst, predict whether the passenger survived.\n Passenger survived:";
    passenger_details, model="gpt3t", api_kwargs)
```

```plaintext
[ Info: Tokens: 157 @ Cost: \$0.0002 in 2.0 seconds
AIMessage("true")
```

Hmm, not very good, is it? That's because the model didn't have the space to think through the reasoning (see the previous example). 

A solution to get this method to work would be to specifically include some survival criteria in the prompt or include examples of passengers that had survived or not.

This is still a very powerful method and it can work surprisingly well. 
That's why PromptingTools wraps it for you as `aiclassify` (see the docs for more details):

```julia
msg = aiclassify(tpl * "\nFirst, predict whether the passenger survived.\n Passenger survived:"; passenger_details, model="gpt3t")
# not api_kwargs or token IDs specified here!
```

## Method 3: aiextract Structured Extraction

Often we want to work with the predictions in a structured format, eg, a DataFrame.
`aiextract` can parse and interpret structured data, making it ideal for datasets like the Titanic.

```julia
@kwdef struct SurvivalPrediction
    reasoning::String
    survived::Bool
end
msg = aiextract(tpl; passenger_details, model="gpt3t", return_type=SurvivalPrediction)
msg.content
```

```plaintext
[ Info: Tokens: 260 @ Cost: \$0.0003 in 4.7 seconds
PromptingTools.DataMessage(SurvivalPrediction)

SurvivalPrediction("Based on the passenger's details, he is a male in third class, which was the least likely to survive. Additionally, his age, being young, may have slightly increased his chances of survival, but the combination of being male and in third class leads me to predict that he did not survive. ", false)
```

I love that in Julia we can just do `df_predicted = DataFrame([msg.content])` and all our predictions would be in a DataFrame.

## Extra: Handling Multi-Class Classification

What if our classification problem has multiple classes (outcomes)? Thanks to the amazing Enum support in Julia, we can easily handle this scenario by simply adjusting the `return_type` in our previous example.

```julia
# Define an enum for the outcome (first element is the type name, the rest are the possible values)
@enum Nationality British American French German Czech

# Add some guidance for the model
"Predict the most likely nationality of the passenger. `reasoning` should be a string explaining your reasoning for the predicted nationality."
@kwdef struct NationalityPrediction
    reasoning::String
    nationality::Nationality
end
msg = aiextract("You have data from the Titanic voyage. Passenger details: {{passenger_details}}"; passenger_details, model="gpt3t", return_type=NationalityPrediction)
msg.content
```

```plaintext
[ Info: Tokens: 204 @ Cost: \$0.0002 in 3.8 seconds
PromptingTools.DataMessage(NationalityPrediction)

NationalityPrediction("The passenger's class, fare, and embarkation point suggest that he is most likely British.", British)
```

## Conclusion

LLMs offer a versatile and quick alternative for classification tasks, especially when traditional ML methods are too cumbersome or slow. While they may not replace dedicated ML models in terms of precision, their flexibility and ease of use make them a valuable tool in the data scientist's arsenal.