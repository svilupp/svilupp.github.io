@def title = "GenAI Mini-Tasks: Mining Themes in Survey Responses"
@def published = "28 November 2023"
@def drafted = "28 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Using Generative AI and Julia's PromptingTools.jl, we efficiently extracted key themes from a large set of survey responses in the Austin Community Survey, demonstrating how GenAI can save significant time and enhance data analysis efficiency.

\toc 

## Introduction
Welcome to our GenAI Mini-Tasks series! Today, we're diving into how Generative AI can transform the way we analyze survey data, using a real-life example from the Austin Community Survey (source: [Austin Community Survey Data](https://data.austintexas.gov/dataset/Community-Survey/s2py-ceb7/data)).

```julia
using DataFramesMeta, CSV
using PromptingTools
const PT = PromptingTools

## Survey Austin
df_survey = CSV.File("Community_Survey_cItyofaustin.csv") |> DataFrame
last(names(df_survey), 10)
```

```plaintext
10-element Vector{String}:
 "Q25 - If there was one thing yo" ⋯ 77 bytes ⋯ "stion, etc.), what would it be?"
 "Q25 - One thing to share with Mayor Topics"
 "Quality of Life Topics"
 "Economic Opportunity and Affordability Topics"
 "Mobility Topics"
 "Health and the Environment Topics"
 "Safety Topics"
 "Government That Works for All Topics"
 "Culture and Lifelong Learning Topics"
 "Share with the Mayor Topics"

```
Messy column names, huh? Check out our previous tutorial on how to clean up column names with GenAI: [GenAI Mini-Tasks: Taming Wild Table Columns Part1](https://svilupp.github.io/scratchpad/genai_mini_tasks_wild_columns_part1/).

## Example: Mining Themes

Our goal: extracting key themes from verbatim responses to the question "Q25 - If there was one thing you could share with the Mayor regarding the City of Austin (any comment, suggestion, etc.), what would it be?". With a mountain of responses (almost 2,000), manually sifting through them is daunting. That's where GenAI comes in!

Using PromptingTools.jl and a template `:AnalystThemesInResponses`, we get insightful themes extracted within 2 minutes, not hours!

```julia
col = "Q25 - If there was one thing you could share with the Mayor regarding the City of Austin (any comment, suggestion, etc.), what would it be?"
responses = @chain df_survey begin
    @rsubset :Year == 2018
    dropmissing(col)
    _[:, col]
end

# Check available templates (optional as a reminder)
# aitemplates("Themes")

# Let's take a subset of 100 
sample_responses = last(responses, 100)
msg = aigenerate(:AnalystThemesInResponses; question=col, responses=sample_responses, instructions="None.")
```

Voila!

```plaintext

[ Info: Tokens: 3785 @ Cost: \$0.0058 in 7.7 seconds
AIMessage("# Theme 1: Traffic and Transportation Improvement
- Best illustrated by: "Traffic is the main concern and needs to be addressed. Buses cause a major backup, they need to be allowed to pull over without backing up traffic even if the sidewalk needs to be pushed back in order to accommodate this, then it should be done. Many other cities do this."
- This theme is focused on the issues of traffic congestion, buses causing backups, and the need for improvement in transportation infrastructure.

# Theme 2: Affordable Housing
- Best illustrated by: "More affordable housing or part of Austin primary Black and Hispanic will disappear."
- This theme highlights the need for more affordable housing options in Austin to prevent displacement and maintain the diversity of the community.

# Theme 3: Homelessness and Public Safety
- Best illustrated by: "We have to do something about the homeless population. The homeless are downtown, under freeway passes, living in camps in the greenbelt, panhandling on every corner, all over UT Campus. Many seem to be on drugs and are unstable and aggressive. I don't feel safe at night walking downtown alone."
- This theme addresses concerns about the homeless population, including safety issues and the need for proper support and intervention strategies.")

```

For a nicer display, I would recommend using Julia Markdown:

```julia
using Markdown
msg.content |> Markdown.parse
```

## Customizing Your Analysis
Did you notice the keyword argument `Instructions="None."` we used? That’s a placeholder for when you want to deviate from the default instructions in the template.

Note: we can also use better models (like GPT-4 Turbo aliased as "gpt4t") to get better responses. In addition, GPT-4 Turbo has 128K context window, so we can easily send all verbatims without any chunking.

```julia
aigenerate(:AnalystThemesInResponses; question=col, responses=sample_responses, instructions="Identify 10 themes. Focus on Green/Sustainability topics.", model="gpt4t")
```

```plaintext
[ Info: Tokens: 4137 @ Cost: \$0.0532 in 34.2 seconds
AIMessage("
# Theme 1: Infrastructure and Traffic Management
- Best illustrated by: "Traffic is the main concern and needs to be addressed. Buses cause a major backup, they need to be allowed to pull over without backing up traffic even if the sidewalk needs to be pushed back in order to accommodate this, then it should be done. Many other cities do this."

# Theme 2: Public Transportation Improvements
- Best illustrated by: "WE NEED BETTER TRANSPORTATION. A LIGHT RAIL WOULD BE NICE."

# Theme 3: Affordable Housing and Cost of Living
- Best illustrated by: "More affordable housing or part of Austin primary Black and Hispanic will disappear."

# Theme 4: Homelessness and Support Services
- Best illustrated by: "We have to do something about the homeless population. The homeless are downtown, under freeway passes, living in camps in the greenbelt, panhandling on every corner, all over UT Campus. Many seem to be on drugs and are unstable and aggressive. I don't feel safe at night walking downtown alone."

# Theme 5: Environmental Sustainability and Clean Energy
- Best illustrated by: "IMPROVE PUBLIC TRANSPORTATION AND A BIGGER PUSH FOR GREEN ENERGY AND GENERAL SERVICES"

# Theme 6: Traffic and Non-Automotive Transportation Safety
- Best illustrated by: "Please keep bicycles off roads that are too narrow and have no bike lanes. Impress upon bicycle riders that they are REQUIRED to follow the same laws as cars if they are driving in the street lanes - NO RUNNING RED LIGHTS. If bicycle riders don't want cars to be rude to them, they need to ride appropriately."

# Theme 7: Green Spaces and Parks
- Best illustrated by: "I would like to have a city park near my home with a walking trail. Poor neighborhoods rarely have a park nearby."

# Theme 8: Utilities and Energy
- Best illustrated by: "The electric bill is too high, even with assistance program."

# Theme 9: Environmental Health and Safety
- Best illustrated by: "Sanction those who blow leaves and trimmings into the street. Create ways to accelerate traffic flow on Lamar and Airport interception."

# Theme 10: Pollution Control and Waste Management
- Best illustrated by: "THERE ARE MANY CRAZY PEOPLE WHO WANT FLUORIDE OUT OF THE DRINKING WATER HERE, PLEASE SEE PAST THE CRAZY AND REALIZE THERE ARE RATIONAL, LOGICAL AND FISCAL REASONS TO REMOVE FLUORIDE FROM THE WATER, IT IS REMOVED PEOPLE CAN STILL OPT-IN AND THE CITY CAN GET THEM FLUORIDE IN ANOTHER WAYS BUT IF IT REMAINS IN IT IS FORCED ON EVERYONE EVEN THOSE WHO DON'T WANT IT AND THOSE WITH MEDICAL CONDITION FLUOROSIS REMOVE FLUORIDE ITS A WASTE OF MONEY"
")
```

This way you can slice and dice your data in many ways, and GenAI will adapt to your needs.

## Privacy Considerations

First, OpenAI API does not use your training for training and it only retains for a short period of time to check for violations ([link](https://platform.openai.com/docs/models/how-we-use-your-data)).

Second, you can use a few utilities we provide to scrub specific named entities (see `?PT.replace_words`).

Third, PromptingTools.jl supports Ollama models, so you can switch over to local models without any changes to your code and your data never leaves your computer. If you need something quick and small, consider `openhermes2.5-mistral` or `zephyr`. If you have Apple M1 or Nvidia GPU, you can use something bigger like `yi:34b-chat`.

## Conclusion
By leveraging GenAI, we've saved countless hours and gained a clear view of community opinions. This approach isn't just a time-saver; it's a game-changer in making data analysis more accessible and efficient. Join us next time for more GenAI-powered data solutions!

Note: It does not mean that you should stop reading the verbatims completely! GenAI helps you to get different perspectives very quickly to grasp the main themes and you can then follow up with more specific prompts/questions - or ask to receive only some specific verbatims (eg, "which verbatims mention emissions?")