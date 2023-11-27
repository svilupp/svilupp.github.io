@def title = "GenAI Mini-Tasks: Taming Wild Table Columns - Part 1"
@def published = "27 November 2023"
@def drafted = "26 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Transform messy data columns into clear, understandable names, making datasets like ggplot's cars or Austin's Community survey easier to manage and analyze.

\toc 

## Tackling the Tangle of Data Tables with GenAI

As a data enthusiast, you've likely experienced the sinking feeling when opening a data file only to be greeted by a jungle of messy, unclear column names. It's a universal pain point — these unwieldy columns make everything from simple data transformations to creating plots unnecessarily complicated. But what if we could delegate this mundane task to GenAI?

## Example 1: Streamlining a Cars Dataset

Take the classic cars dataset (Link: [ggplot mpg](https://github.com/tidyverse/ggplot2/blob/main/data-raw/mpg.csv)). Its columns might be 'clean' (lowercased), but they're cryptic enough to trip you up.

```julia
using DataFramesMeta, CSV
using PromptingTools

## Load
df_cars = CSV.File("mpg.csv") |> DataFrame
names(df_cars)
```

```plaintext
11-element Vector{String}:
 "manufacturer"
 "model"
 "displ"
 "year"
 "cyl"
 "trans"
 "drv"
 "cty"
 "hwy"
 "fl"
 "class"
```


 Normally, you'd resort to regex or manual renaming, but GenAI offers a smarter solution. Using Julia's PromptingTools.jl, we asked GenAI to give these columns more intuitive names. 
 
 ```julia
# aitemplates("Detail") # optional: check the available templates and their placeholders

msg = aigenerate(:DetailOrientedTask; task="This is a dataset about car consumptions. Make the columns more descriptive, snakecase, 2-3 words max. Return Julia vector", data=names(df_cars))
 ```

```plaintext
[ Info: Tokens: 168 @ Cost: $0.0003 in 1.4 seconds
AIMessage("["car_make", "car_model", "engine_size", "year", "num_cylinders", "transmission_type", "drive_type", "city_mpg", "highway_mpg", "fuel_type", "vehicle_class"]")
``` 

 The result? It took 45 seconds end-to-end and not only did the columns become self-explanatory, but they also made the entire dataset more approachable. Concerned about the longer names? Don't be. Modern tools like autosuggest and double-click selection in the REPL make handling them a breeze (as long as the words are separated by underscores).

```julia
cols=["car_make", "car_model", "engine_size", "year", "num_cylinders", "transmission_type", "drive_type", "city_mpg", "highway_mpg", "fuel_type", "vehicle_class"]
df_cars = rename(df_cars, cols)
first(df_cars)
```

```plaintext
Row │ car_make  car_model  engine_size  year   num_cylinders  transmission_type  drive_type  city_mpg  highway_mpg  fuel_type  vehicle_class 
     │ String15  String31   Float64      Int64  Int64          String15           String1     Int64     Int64        String1    String15      
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ audi      a4                 1.8   1999              4  auto(l5)           f                 18           29  p          compact
```

No more "fl", "hwy", "displ", ...

## Example 2: Simplifying Survey Column Names

Next up, let's tackle Austin's Community Survey dataset ([link](https://data.austintexas.gov/dataset/Community-Survey/s2py-ceb7/data)).
Survey data is a notorious headache due to its plethora of long-form questions or statements used as column names. Also, there are >250 columns like that, so it's not a task you'd want to do manually.

Let's start by scanning the column names and what we need:

```julia
df_survey = CSV.File("Community_Survey_cItyofaustin.csv") |> DataFrame
first(names(df_survey), 8)
```

```plaintext
8-element Vector{String}:
 "ID"
 "Year"
 "Method"
 "The City of Austin as a place to live"
 "The City of Austin as a place to work"
 "The City of Austin as a place to raise children"
 "The City of Austin as a place to retire"
 "The City of Austin as a place where I feel welcome"
 ```
 
 We could use the previous method and hope that the LLM will generate all 250 columns in exactly the right order, but that's not a good idea. Instead, we'll use the `aiextract` function that allows us to specify the output format (no more Regex extractions to avoid the chit-chat in the output!).

 Let's define the output type (which fields, types, is it optional, etc.) and provide it as `return_type` kwarg. Note: you can add instructions to the docstring. 
 
 I used two column names as examples to test the instructions (=prompt) and tweak them. It worked well on the 3rd iteration and with the more powerful GPT-4 Turbo model (aliased as `gpt4t`).

 ```julia
struct RenameColumn3 # simply increment the number if you iterate the struct definition
    better_name::String
end

column_prompt = """# Instructions
You get a name of a column name from the City of Austin survey data. Create a better clean and descriptive column name.

# Guidelines
- Better Name should be brief, descriptive, snakecase, 2-3 words max. IT MUST BE LOWERCASED.
- Do not mention its from Austin as its obvious
- If some Question ID is included in the name (eg, "Q25 Some Topic"), include it in the Better Name (eg, q25_some_topic)

# Old Column Name
- {{old_column}}
"""
# We use double handlebar templating with {{old_column}}

# test it on a few columns and tweak the instructions
col = "Access to quality mental health care you can afford"
col = "Q25 - Share with the Mayor Topics"

msg = aiextract(column_prompt; old_column=col, return_type=RenameColumn3, model="gpt4t")
msg.content # we can access the string like this: msg.content.better_name (see the Struct above)

# [ Info: Tokens: 184 @ Cost: $0.002 in 0.8 seconds
# PromptingTools.DataMessage(RenameColumn3)

# RenameColumn3("q25_share_topics")
 ```
This works well. 

Let's run it for each column in parallel with `asyncmap` (we'll also disable the logging with `verbose=false` to avoid cluttering the REPL). By using `asyncmap` we call the API in parallel for all column names, so we don't have to wait long despite making 250 API calls to the "slow" GPT-4 Turbo model.

 ```julia
@time msgs = asyncmap(col -> aiextract(column_prompt; old_column=col, return_type=RenameColumn3, model="gpt4t", verbose=false), names(df_survey))
# 13.061459 seconds (414.83 k allocations: 33.739 MiB, 0.54% compilation time)
# 251-element Vector{PromptingTools.DataMessage{RenameColumn3}}:
#  PromptingTools.DataMessage(RenameColumn)
# ...

# Let's sum up the cost of each message
# PT.MODEL_COSTS and PT.MODEL_ALIASES are Dicts with the cost per 1K tokens and model alias to proper name mapping, respectively
cost = [sum(msg.tokens ./1000 .* PT.MODEL_COSTS[PT.MODEL_ALIASES["gpt4t"]]) for msg in msgs] |> sum # \$0.5 !!

# Let's define a renaming dictionary
rename_dict = Dict(old_name => msg.content.better_name for (msg, old_name) in zip(msgs, names(df_survey)))
```

It looks pretty good:

```plaintext
      rename_dict
Dict{String, String} with 251 entries:
  "Which THREE items in Health and Environment do you th… => "top_three_health_environment_priorities"
  "Overall quality of wastewater services provided by Au… => "wastewater_services_quality"
  "Traffic flow on major highways (IH-35, Mopac Expy, US… => "major_highway_traffic_flow"
  "Condition of major city streets (Congress Ave, Lamar,… => "major_streets_condition"
```

But when we try to apply it, we get an error:
```julia
rename(df_survey, rename_dict)
```

```plaintext
ERROR: ArgumentError: Tried renaming to :affordable_housing_access multiple times.
```

Let's find the duplicate!
```julia
[k => v for (k, v) in pairs(rename_dict) if v == "affordable_housing_access"]
# 2-element Vector{Pair{String, String}}:
#  "Access to quality housing you can afford" => "affordable_housing_access"
#      "Access to affordable quality housing" => "affordable_housing_access"

```

Uff, this is hard even for a human! Let's just add "_2" suffix to all duplicates:

```julia
let visited_values = Set()
    for (k, v) in pairs(rename_dict)
        if v in visited_values
            rename_dict[k] = v * "_2"
        else
            push!(visited_values, v)
        end
    end
end

# Voila! It works
rename(df_survey, rename_dict)
```

## Notes

- Never start by making all 250 API calls at once. Pick a few tricky examples and tune the prompt/setup to work well for them. You'll save a lot of time and $$$s that way (AI engineering is all about iterating quickly and effectively)
- Provide the output format as a Struct type via the `return_type` keyword argument
- The main argument of `aiextract` is the text to use for extraction. You can add some instructions there (format them into markdown-style sections), eg, `# Instructions\n\nDo ABC\n\n\n\n# Data\n\n\<your_data>`
- You can use the docstring of the `return_type` Struct to provide additional instructions for the individual fields. Docstrings will be sent to the LLM as well

## Conclusion

It did cost us \$0.5, but it was worth it. We got the results in ~5 minutes of meddling. How long would it have taken otherwise?

```julia
let cols = names(df_survey)
    # reading speed of 900 chars/minute
    reading = length.(cols) |> sum |> x -> x / 900
    # typing speed of 200 chars/minute (assume we type columns 3x shorter)
    typing = length.(cols) |> sum |> x -> x / 3 / 200
    @info "Reading time: $(round(reading;digits=1)) minutes, typing time: $(round(typing;digits=1))"
end
# [ Info: Reading time: 17.6 minutes, typing time: 26.3
```
Simple benchmarks suggest ~45 minutes of just reading + typing without any thinking time. From personal experience, I know that it would take me at least 2 hours to do it manually at a comparable quality.

The best part? We didn't have to do any manual work. We can now focus on the analysis and not on the data cleaning. By making column names more intuitive and datasets more user-friendly, it's turning what was once a tedious chore into a quick, automated process. With GenAI, we're one step closer to focusing on what truly matters in our projects.

**For the curious minds:**

Part of the above problem with duplicates was that we sent each column name separately, so the LLM didn't see the other columns.
What if we sent all the columns at once, would it be faster? Would we still have to de-duplicate them? 

Let's find out in part 2 of this blog!

## Extension // new blog?

## Title: Taming Wild Table Columns Part 2

This is a follow-up to the first part of the blog: [GenAI Mini-Tasks: Taming Wild Table Columns](https://svilupp.github.io/2021/11/27/genai-mini-tasks-taming-wild-table-columns.html), where we cleaned up columns in the City of Austin's community survey data by sending the column names one-by-one in separate `aiextract` calls.

Quick reminder, we have >250 quite verbose columns that we want to clean up. Let's show a few:

```julia
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

 ## Sending All Columns at Once

 Let's re-use the previous return type `RenameColumn` and the prompt, but we'll make a few tweaks.

 1. Add more fields to `RenameColumn4` to capture the old column name and the question ID (if available). It's nicer to have it together, because you cannot control in what order will the new column names be generated
 2. Add a docstring for `RenameColumn4` to provide instructions for the `question_id` field and set it as optional (by allowing `Nothing` type)
 3. Create a wrapper type `RenameColumnList` which is simply a vector of `RenameColumn4` -> this way LLM knows to extract many columns
 4. Add an extra instruction to the prompt that we want the new column names to be unique (and to add a suffix _2 if they are not)
 5. Lastly, we'll make the API call asynchronous to not have to wait for it to finish (big tasks can take several minutes)

 ```julia
"question_id is optional and should be extracted from the old_name where available (example: \"q25\")"
struct RenameColumn4
    question_id::Union{Nothing,String} # optional
    old_name::String
    better_name::String
end
"Vector of RenameColumn4 holding the old and new column names"
struct RenameColumnsList
    better_names::Vector{RenameColumn4} # extract all columns at once and return it as a vector
end

# updated prompt
multicolumn_prompt = """# Instructions
You get list of column names from the City of Austin survey data. Define a better clean and descriptive column name for each of them.

# Guidelines
- Better Name should be brief, descriptive, snakecase, 2-3 words max. IT MUST BE LOWERCASED.
- Do not mention its from Austin as its obvious
- If some Question ID is included in the name (eg, "Q25 Some Topic"), extract it into the field `question_id` and in the better name (eg, q25_some_topic)
- All Better Names MUST BE UNIQUE. If there is a duplicate Better Name used already, use suffix _2, _3, etc.

# Old Column Names
{{old_columns}}
"""

# we take a subset to demonstrate the approach
sample_cols = last(names(df_survey), 10)

# format the data as bullet points
old_columns = [" - ID: $idx, Column: $col\n" for (idx, col) in enumerate(sample_cols)] |> join

# use Threads.@spawn to send the message asynchronously to not have to wait for it to finish
# long readtimeout to allow more time for longer generation task and a slow model like GPT4
task = Threads.@spawn aiextract(multicolumn_prompt; old_columns, return_type=RenameColumnsList, http_kwargs=(; readtimeout=500), model="gpt4t")
```

This is an asynchronous (non-blocking) call, so we can keep working. When it's ready, we'll see the usual INFO log:
```plaintext
[ Info: Tokens: 754 @ Cost: \$0.014 in 30.8 seconds
```

Let's review the results:
```julia
msg = fetch(task)
msg.content.better_names
#  RenameColumn4("q25", "Q25 - If there was one thing you could share with the Mayor regarding the City of Austin (any comment, suggestion, etc.), what would it be?", "mayor_feedback")
#  RenameColumn4("q25", "Q25 - One thing to share with Mayor Topics", "mayor_feedback_topics")
#  RenameColumn4(nothing, "Quality of Life Topics", "quality_life_topics")
#  RenameColumn4(nothing, "Economic Opportunity and Affordability Topics", "economic_affordability_topics")
#  RenameColumn4(nothing, "Mobility Topics", "mobility_topics")
#  RenameColumn4(nothing, "Health and the Environment Topics", "health_environment_topics")
#  RenameColumn4(nothing, "Safety Topics", "safety_topics")
#  RenameColumn4(nothing, "Government That Works for All Topics", "government_works_topics")
#  RenameColumn4(nothing, "Culture and Lifelong Learning Topics", "culture_learning_topics")
#  RenameColumn4(nothing, "Share with the Mayor Topics", "mayor_shared_topics_2")
```

Awesome! It worked well. We got the question ID extracted and the new column names are unique (notice the `_2` suffix).

All we have to do now, is to rename our columns:
```julia
rename_dict = Dict(cols.old_name => cols.better_name for cols in msg.content.better_names)

rename(df_survey, rename_dict)
```

And we're done! It was only 10 columns, so if we did all 250, it would take a few minutes and cost around \$0.3 - 0.5, but that's still nothing compared to the time and mental energy it would take to do it manually.

## Notes

A few things to note
- Our return type must be always a struct, but we can define wrappers like `RenameColumnsList`, if we want to extract several of some objects. It's very easy!
- `question_id` field had some nuanced logic, so to keep it closer to the field itself, we've described it in the docstring and it has passed to the LLM. Morever, this field was marked as optional by allowing `Nothing` type
- We have updated the instructions slightly for the different task
- Notice that we increased the `readtimeout` (HTTP.jl keyword argument) to 500 seconds to allow for longer prompts. That's because the longer the generated text (eg, 250 columns), the longer it takes and we don't want to time out!
- Since we knew it will take a long time, we sent the message asynchronously to not have to wait for it to finish (`Threads.@spawn ai...`). This way we can keep working while it runs in the background and we're notified when it finishes by the usual INFO log


## Conclusion

There are pros and cons to both approaches. Let's summarize them:

**Pros:** You can see that this was much easier in terms of using the results. We didn't have to clean up the resulting dictionary, deduplicate the names, etc. It was also slightly cheaper (the tokens used in the prompt are used only once VS in each one of the 250 API calls).

**Cons:** It required a bit more work to set up the prompt and the return type. Also, the feedback loop was much longer (eg, waiting a few minutes for results), so if made several mistakes, it would always take a few minutes to find out and try again.

You can see that choosing the right approach requires some experience and skill, it's just something we have to learn. This is similar to how we all had to learn to Google.

Until next time!@def title = "GenAI Mini-Tasks: Taming Wild Table Columns - Part 1"
<!-- @def published = "27 November 2023" -->
@def drafted = "26 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Transform messy data columns into clear, understandable names, making datasets like ggplot's cars or Austin's Community survey easier to manage and analyze.

\toc 

## Tackling the Tangle of Data Tables with GenAI

As a data enthusiast, you've likely experienced the sinking feeling when opening a data file only to be greeted by a jungle of messy, unclear column names. It's a universal pain point — these unwieldy columns make everything from simple data transformations to creating plots unnecessarily complicated. But what if we could delegate this mundane task to GenAI?

## Example 1: Streamlining a Cars Dataset

Take the classic cars dataset (Link: [ggplot mpg](https://github.com/tidyverse/ggplot2/blob/main/data-raw/mpg.csv)). Its columns might be 'clean' (lowercased), but they're cryptic enough to trip you up.

```julia
using DataFramesMeta, CSV
using PromptingTools

## Load
df_cars = CSV.File("mpg.csv") |> DataFrame
names(df_cars)
```

```plaintext
11-element Vector{String}:
 "manufacturer"
 "model"
 "displ"
 "year"
 "cyl"
 "trans"
 "drv"
 "cty"
 "hwy"
 "fl"
 "class"
```


 Normally, you'd resort to regex or manual renaming, but GenAI offers a smarter solution. Using Julia's PromptingTools.jl, we asked GenAI to give these columns more intuitive names. 
 
 ```julia
# aitemplates("Detail") # optional: check the available templates and their placeholders

msg = aigenerate(:DetailOrientedTask; task="This is a dataset about car consumptions. Make the columns more descriptive, snakecase, 2-3 words max. Return Julia vector", data=names(df_cars))
 ```

```plaintext
[ Info: Tokens: 168 @ Cost: $0.0003 in 1.4 seconds
AIMessage("["car_make", "car_model", "engine_size", "year", "num_cylinders", "transmission_type", "drive_type", "city_mpg", "highway_mpg", "fuel_type", "vehicle_class"]")
``` 

 The result? It took 45 seconds end-to-end and not only did the columns become self-explanatory, but they also made the entire dataset more approachable. Concerned about the longer names? Don't be. Modern tools like autosuggest and double-click selection in the REPL make handling them a breeze (as long as the words are separated by underscores).

```julia
cols=["car_make", "car_model", "engine_size", "year", "num_cylinders", "transmission_type", "drive_type", "city_mpg", "highway_mpg", "fuel_type", "vehicle_class"]
df_cars = rename(df_cars, cols)
first(df_cars)
```

```plaintext
Row │ car_make  car_model  engine_size  year   num_cylinders  transmission_type  drive_type  city_mpg  highway_mpg  fuel_type  vehicle_class 
     │ String15  String31   Float64      Int64  Int64          String15           String1     Int64     Int64        String1    String15      
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ audi      a4                 1.8   1999              4  auto(l5)           f                 18           29  p          compact
```

No more "fl", "hwy", "displ", ...

## Example 2: Simplifying Survey Column Names

Next up, let's tackle Austin's Community Survey dataset ([link](https://data.austintexas.gov/dataset/Community-Survey/s2py-ceb7/data)).
Survey data is a notorious headache due to its plethora of long-form questions or statements used as column names. Also, there are >250 columns like that, so it's not a task you'd want to do manually.

Let's start by scanning the column names and what we need:

```julia
df_survey = CSV.File("Community_Survey_cItyofaustin.csv") |> DataFrame
first(names(df_survey), 8)
```

```plaintext
8-element Vector{String}:
 "ID"
 "Year"
 "Method"
 "The City of Austin as a place to live"
 "The City of Austin as a place to work"
 "The City of Austin as a place to raise children"
 "The City of Austin as a place to retire"
 "The City of Austin as a place where I feel welcome"
 ```
 
 We could use the previous method and hope that the LLM will generate all 250 columns in exactly the right order, but that's not a good idea. Instead, we'll use the `aiextract` function that allows us to specify the output format (no more Regex extractions to avoid the chit-chat in the output!).

 Let's define the output type (which fields, types, is it optional, etc.) and provide it as `return_type` kwarg. Note: you can add instructions to the docstring. 
 
 I used two column names as examples to test the instructions (=prompt) and tweak them. It worked well on the 3rd iteration and with the more powerful GPT-4 Turbo model (aliased as `gpt4t`).

 ```julia
struct RenameColumn3 # simply increment the number if you iterate the struct definition
    better_name::String
end

column_prompt = """# Instructions
You get a name of a column name from the City of Austin survey data. Create a better clean and descriptive column name.

# Guidelines
- Better Name should be brief, descriptive, snakecase, 2-3 words max. IT MUST BE LOWERCASED.
- Do not mention its from Austin as its obvious
- If some Question ID is included in the name (eg, "Q25 Some Topic"), include it in the Better Name (eg, q25_some_topic)

# Old Column Name
- {{old_column}}
"""
# We use double handlebar templating with {{old_column}}

# test it on a few columns and tweak the instructions
col = "Access to quality mental health care you can afford"
col = "Q25 - Share with the Mayor Topics"

msg = aiextract(column_prompt; old_column=col, return_type=RenameColumn3, model="gpt4t")
msg.content # we can access the string like this: msg.content.better_name (see the Struct above)

# [ Info: Tokens: 184 @ Cost: $0.002 in 0.8 seconds
# PromptingTools.DataMessage(RenameColumn3)

# RenameColumn3("q25_share_topics")
 ```
This works well. 

Let's run it for each column in parallel with `asyncmap` (we'll also disable the logging with `verbose=false` to avoid cluttering the REPL). By using `asyncmap` we call the API in parallel for all column names, so we don't have to wait long despite making 250 API calls to the "slow" GPT-4 Turbo model.

 ```julia
@time msgs = asyncmap(col -> aiextract(column_prompt; old_column=col, return_type=RenameColumn3, model="gpt4t", verbose=false), names(df_survey))
# 13.061459 seconds (414.83 k allocations: 33.739 MiB, 0.54% compilation time)
# 251-element Vector{PromptingTools.DataMessage{RenameColumn3}}:
#  PromptingTools.DataMessage(RenameColumn)
# ...

# Let's sum up the cost of each message
# PT.MODEL_COSTS and PT.MODEL_ALIASES are Dicts with the cost per 1K tokens and model alias to proper name mapping, respectively
cost = [sum(msg.tokens ./1000 .* PT.MODEL_COSTS[PT.MODEL_ALIASES["gpt4t"]]) for msg in msgs] |> sum # \$0.5 !!

# Let's define a renaming dictionary
rename_dict = Dict(old_name => msg.content.better_name for (msg, old_name) in zip(msgs, names(df_survey)))
```

It looks pretty good:

```plaintext
      rename_dict
Dict{String, String} with 251 entries:
  "Which THREE items in Health and Environment do you th… => "top_three_health_environment_priorities"
  "Overall quality of wastewater services provided by Au… => "wastewater_services_quality"
  "Traffic flow on major highways (IH-35, Mopac Expy, US… => "major_highway_traffic_flow"
  "Condition of major city streets (Congress Ave, Lamar,… => "major_streets_condition"
```

But when we try to apply it, we get an error:
```julia
rename(df_survey, rename_dict)
```

```plaintext
ERROR: ArgumentError: Tried renaming to :affordable_housing_access multiple times.
```

Let's find the duplicate!
```julia
[k => v for (k, v) in pairs(rename_dict) if v == "affordable_housing_access"]
# 2-element Vector{Pair{String, String}}:
#  "Access to quality housing you can afford" => "affordable_housing_access"
#      "Access to affordable quality housing" => "affordable_housing_access"

```

Uff, this is hard even for a human! Let's just add "_2" suffix to all duplicates:

```julia
let visited_values = Set()
    for (k, v) in pairs(rename_dict)
        if v in visited_values
            rename_dict[k] = v * "_2"
        else
            push!(visited_values, v)
        end
    end
end

# Voila! It works
rename(df_survey, rename_dict)
```

## Notes

- Never start by making all 250 API calls at once. Pick a few tricky examples and tune the prompt/setup to work well for them. You'll save a lot of time and $$$s that way (AI engineering is all about iterating quickly and effectively)
- Provide the output format as a Struct type via the `return_type` keyword argument
- The main argument of `aiextract` is the text to use for extraction. You can add some instructions there (format them into markdown-style sections), eg, `# Instructions\n\nDo ABC\n\n\n\n# Data\n\n\<your_data>`
- You can use the docstring of the `return_type` Struct to provide additional instructions for the individual fields. Docstrings will be sent to the LLM as well

## Conclusion

It did cost us \$0.5, but it was worth it. We got the results in ~5 minutes of meddling. How long would it have taken otherwise?

```julia
let cols = names(df_survey)
    # reading speed of 900 chars/minute
    reading = length.(cols) |> sum |> x -> x / 900
    # typing speed of 200 chars/minute (assume we type columns 3x shorter)
    typing = length.(cols) |> sum |> x -> x / 3 / 200
    @info "Reading time: $(round(reading;digits=1)) minutes, typing time: $(round(typing;digits=1))"
end
# [ Info: Reading time: 17.6 minutes, typing time: 26.3
```
Simple benchmarks suggest ~45 minutes of just reading + typing without any thinking time. From personal experience, I know that it would take me at least 2 hours to do it manually at a comparable quality.

The best part? We didn't have to do any manual work. We can now focus on the analysis and not on the data cleaning. By making column names more intuitive and datasets more user-friendly, it's turning what was once a tedious chore into a quick, automated process. With GenAI, we're one step closer to focusing on what truly matters in our projects.

**For the curious minds:**

Part of the above problem with duplicates was that we sent each column name separately, so the LLM didn't see the other columns.
What if we sent all the columns at once, would it be faster? Would we still have to de-duplicate them? 

Let's find out in part 2 of this blog!

## Extension // new blog?

## Title: Taming Wild Table Columns Part 2

This is a follow-up to the first part of the blog: [GenAI Mini-Tasks: Taming Wild Table Columns](https://svilupp.github.io/2021/11/27/genai-mini-tasks-taming-wild-table-columns.html), where we cleaned up columns in the City of Austin's community survey data by sending the column names one-by-one in separate `aiextract` calls.

Quick reminder, we have >250 quite verbose columns that we want to clean up. Let's show a few:

```julia
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

 ## Sending All Columns at Once

 Let's re-use the previous return type `RenameColumn` and the prompt, but we'll make a few tweaks.

 1. Add more fields to `RenameColumn4` to capture the old column name and the question ID (if available). It's nicer to have it together, because you cannot control in what order will the new column names be generated
 2. Add a docstring for `RenameColumn4` to provide instructions for the `question_id` field and set it as optional (by allowing `Nothing` type)
 3. Create a wrapper type `RenameColumnList` which is simply a vector of `RenameColumn4` -> this way LLM knows to extract many columns
 4. Add an extra instruction to the prompt that we want the new column names to be unique (and to add a suffix _2 if they are not)
 5. Lastly, we'll make the API call asynchronous to not have to wait for it to finish (big tasks can take several minutes)

 ```julia
"question_id is optional and should be extracted from the old_name where available (example: \"q25\")"
struct RenameColumn4
    question_id::Union{Nothing,String} # optional
    old_name::String
    better_name::String
end
"Vector of RenameColumn4 holding the old and new column names"
struct RenameColumnsList
    better_names::Vector{RenameColumn4} # extract all columns at once and return it as a vector
end

# updated prompt
multicolumn_prompt = """# Instructions
You get list of column names from the City of Austin survey data. Define a better clean and descriptive column name for each of them.

# Guidelines
- Better Name should be brief, descriptive, snakecase, 2-3 words max. IT MUST BE LOWERCASED.
- Do not mention its from Austin as its obvious
- If some Question ID is included in the name (eg, "Q25 Some Topic"), extract it into the field `question_id` and in the better name (eg, q25_some_topic)
- All Better Names MUST BE UNIQUE. If there is a duplicate Better Name used already, use suffix _2, _3, etc.

# Old Column Names
{{old_columns}}
"""

# we take a subset to demonstrate the approach
sample_cols = last(names(df_survey), 10)

# format the data as bullet points
old_columns = [" - ID: $idx, Column: $col\n" for (idx, col) in enumerate(sample_cols)] |> join

# use Threads.@spawn to send the message asynchronously to not have to wait for it to finish
# long readtimeout to allow more time for longer generation task and a slow model like GPT4
task = Threads.@spawn aiextract(multicolumn_prompt; old_columns, return_type=RenameColumnsList, http_kwargs=(; readtimeout=500), model="gpt4t")
```

This is an asynchronous (non-blocking) call, so we can keep working. When it's ready, we'll see the usual INFO log:
```plaintext
[ Info: Tokens: 754 @ Cost: \$0.014 in 30.8 seconds
```

Let's review the results:
```julia
msg = fetch(task)
msg.content.better_names
#  RenameColumn4("q25", "Q25 - If there was one thing you could share with the Mayor regarding the City of Austin (any comment, suggestion, etc.), what would it be?", "mayor_feedback")
#  RenameColumn4("q25", "Q25 - One thing to share with Mayor Topics", "mayor_feedback_topics")
#  RenameColumn4(nothing, "Quality of Life Topics", "quality_life_topics")
#  RenameColumn4(nothing, "Economic Opportunity and Affordability Topics", "economic_affordability_topics")
#  RenameColumn4(nothing, "Mobility Topics", "mobility_topics")
#  RenameColumn4(nothing, "Health and the Environment Topics", "health_environment_topics")
#  RenameColumn4(nothing, "Safety Topics", "safety_topics")
#  RenameColumn4(nothing, "Government That Works for All Topics", "government_works_topics")
#  RenameColumn4(nothing, "Culture and Lifelong Learning Topics", "culture_learning_topics")
#  RenameColumn4(nothing, "Share with the Mayor Topics", "mayor_shared_topics_2")
```

Awesome! It worked well. We got the question ID extracted and the new column names are unique (notice the `_2` suffix).

All we have to do now, is to rename our columns:
```julia
rename_dict = Dict(cols.old_name => cols.better_name for cols in msg.content.better_names)

rename(df_survey, rename_dict)
```

And we're done! It was only 10 columns, so if we did all 250, it would take a few minutes and cost around \$0.3 - 0.5, but that's still nothing compared to the time and mental energy it would take to do it manually.

## Notes

A few things to note
- Our return type must be always a struct, but we can define wrappers like `RenameColumnsList`, if we want to extract several of some objects. It's very easy!
- `question_id` field had some nuanced logic, so to keep it closer to the field itself, we've described it in the docstring and it has passed to the LLM. Morever, this field was marked as optional by allowing `Nothing` type
- We have updated the instructions slightly for the different task
- Notice that we increased the `readtimeout` (HTTP.jl keyword argument) to 500 seconds to allow for longer prompts. That's because the longer the generated text (eg, 250 columns), the longer it takes and we don't want to time out!
- Since we knew it will take a long time, we sent the message asynchronously to not have to wait for it to finish (`Threads.@spawn ai...`). This way we can keep working while it runs in the background and we're notified when it finishes by the usual INFO log


## Conclusion

There are pros and cons to both approaches. Let's summarize them:

**Pros:** You can see that this was much easier in terms of using the results. We didn't have to clean up the resulting dictionary, deduplicate the names, etc. It was also slightly cheaper (the tokens used in the prompt are used only once VS in each one of the 250 API calls).

**Cons:** It required a bit more work to set up the prompt and the return type. Also, the feedback loop was much longer (eg, waiting a few minutes for results), so if made several mistakes, it would always take a few minutes to find out and try again.

You can see that choosing the right approach requires some experience and skill, it's just something we have to learn. This is similar to how we all had to learn to Google.

Until next time!