@def title = "GenAI Mini-Tasks: Taming Wild Table Columns - Part 2"
@def published = "27 November 2023"
@def drafted = "26 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Transform messy data columns into clear, understandable names, making survey data easier to manage and analyze.

\toc 

This is a follow-up to the first part of the blog: [GenAI Mini-Tasks: Taming Wild Table Columns](https://svilupp.github.io/scratchpad/genai_mini_tasks_taming_wild_table_columns_part2/), where we cleaned up columns in the City of Austin's community survey data by sending the column names one-by-one in separate `aiextract` calls.

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

Awesome! It worked well. We got the old names, the parent question IDs (where relevant) and the new column names that are unique (notice the `_2` suffix).

All we have to do now, is to rename our columns:
```julia
rename_dict = Dict(cols.old_name => cols.better_name for cols in msg.content.better_names)

rename(df_survey, rename_dict) # No error this time!
```

And we're done! It was only 10 columns, so if we did all 250, it would take a few minutes and cost around \$0.3 - 0.5, but that's still nothing compared to the time and mental energy it would take to do it manually.

Imagine all the other things you can do! In the past, I've also sent a sample of a few unique responses in each column to make column names more reflective of the actual data.

## Notes

A few things to note:
- Our return type must be always a struct, but we can define wrappers like `RenameColumnsList`, if we want to extract several objects at once. It's very easy!
- `question_id` field had some nuanced logic, so to keep it closer to the field itself, we've described it in the docstring and it has passed to the LLM. Morever, this field was marked as optional by allowing `Nothing` type
- We have updated the instructions slightly for the different task
- Notice that we increased the `readtimeout` (HTTP.jl keyword argument) to 500 seconds to allow for longer prompts. That's because the longer the generated text (eg, 250 columns), the longer it takes and we don't want to time out!
- Since we knew it would take a long time, we sent the message asynchronously to not have to wait for it (`Threads.@spawn ai...`). This way we can keep working while it runs in the background and we'll be notified when it finishes by the usual INFO log


## Conclusion

There are pros and cons to both approaches. Let's summarize them:

**Pros:** You can see that this was much easier in terms of using the results. We didn't have to clean up the resulting dictionary, deduplicate the names, etc. It was also slightly cheaper (the prompt tokens are sent only once VS in each one of the 250 API calls).

**Cons:** It required an extra step to set up the prompt and the return type. Also, the feedback loop was much longer (eg, waiting a few minutes for results), so if made some mistakes, it would always take a few minutes to find out and try again.

You can see that choosing the right approach requires some experience and skill, it's just something you'll learn over time. It's similar to how we all had to learn to Google.

Until next time!