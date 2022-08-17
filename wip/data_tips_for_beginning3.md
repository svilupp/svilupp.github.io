@def title = "Julia for Data: Tips for Better Beginning #3"
<!-- @def published = "20 August 2022" -->
@def tags = ["julia","beginners"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
This article is focused mostly on data crunching. Use mainly DataFramesMeta+StatsPlots and apply coding patterns that are less error-prone.

# Choose robust patterns
There are many ways how you can achieve the same thing in Julia. I found that a few specific tips can reduces the number of errors you make and greatly enhance your "time-to-insight".

## Always use environments
This is a must, no matter how small the analysis is. Julia REPL Pkg mode is super easy to easy and has almost no "costs" (see previous the tutorial).

## Name meaningfully and consistently
This is mouthful. You can only benefit if you choose names that represent what the logic/data they hold.
Moreover, you should standardize your naming convention, eg, always convert to a snakecase ("finance_billings" or "count_users"). Your future self will thank you.

## Use symbols wherever you can
When referring to sub-objects (eg, a column in a DataFrame), you have a choice between a string ("col_A") and a symbol (:col_A).


## Use DataFramesMeta as the Center-of-Data-Universe
DataFrames ecosystem is a like a swiss-army knife that is worth mastering. I found that the below tips have reduced the number of errors when building a quick analysis.

Always start your data work with `using DataFramesMeta, StatsPlots`
- They re-export DataFrames, Chain, and Plots packages
- Use macros: @select/@transform/@orderby @df
    -  Avoid brackets
- Use chain
    -  Leverage @aside or potentially @aside @info for introspection (if you load Logging)
    -  great trick `chain df . . . . `
- use @r versions of those macros
    - It wont work for array requiring methods @tr,eg, categorical arrays
- If you need to use the DataFrame.jl minilanguage - take symbols out and debug it

## Use Plots.jl
- The most intuitive and versatile (especially if you have a very specific ask/chart to make)
- Multiple backends, eg, interactive PlotlyJS()
- Incredibly easy to guess the necessary keyword (nicely composable and multiple aliases)
- If you cannot guess, jump to help `?plot` and notice the mention of `plotattr(:Series)`
    - Use it to see all available keywords

