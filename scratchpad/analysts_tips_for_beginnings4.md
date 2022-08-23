@def title = "Julia for Analysts: Tips for Better Beginnings - Patterns for Error-free Data Crunching (#4)"
@def published = "23 August 2022"
@def drafted = "17 August 2022"
@def tags = ["julia","beginners"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
This article is focused mostly on data crunching and speeding up the "time-to-insight". Stick to DataFramesMeta+StatsPlots, use symbols, use macros, and use chain pipelines.

\toc

# Patterns for Error-free Data Crunching
There are many ways how you can achieve the same in Julia. I found that a few specific tips can reduces the number of errors you make and greatly enhance your "time-to-insight".

## Always use environments
This is a must, no matter how small the analysis is. Julia REPL Pkg mode is super easy to easy and has almost no "costs" (see previous the tutorial).

All it takes is:
```
;cd my/project/path/
]activate .
``` 
and you will be in your project-dedicated environment. Why the two commands and not just `activate` with a specific path? I often want to load scripts, data, etc, which I want to address relatively (eg, `data_raw/file.csv`), so that is why I change the working directory first.

The advanced version would be to always start a new project (analysis) with `]generate` in the Package mode (see the previous article) or with [PkgTemplates.jl](https://invenia.github.io/PkgTemplates.jl/), but that is sensible only for bigger piece of work.

## Give meaningful and consistent names
This is a mouthful. You can only benefit if you choose names that represent what the logic/data they hold.
Moreover, you should standardize your naming convention, eg, always convert to a snakecase ("finance_billings" or "count_users").

My frequent pattern is to apply the following column name clean-up right after loading a DataFrame:

`rename!(df,replace.(lowercase.(names(df))," "=>"_","-"=>""))`

Ideally, the same would hold for your input/output files and the surrounding folder structure (eg, `data_raw/finance_billings_20220801.csv` and `data_processed/forecasting_df_20220801.feather`). 

It will become self-documenting and your colleagues (and your future self!) will thank you for it.

## Use symbols wherever you can
When referring to sub-objects (eg, a column in a DataFrame or using a `getfield()` call), you have a choice between a string ("col_A") and a symbol (:col_A).
Always go with symbols, ie, use `df[!,:a]` instead of `df[!,"a"]`.

It's easier to write (one extra symbol instead of two), it is (often) done under the hood anyway, but most importantly since I started doing that everywhere in the DataFrames ecosystem I have made way fewer errors (in transforms, in column access, etc.) 

If you use the [DataFrames.jl minilanguage](https://bkamins.github.io/julialang/2020/12/24/minilanguage.html), always use symbols for column names. If something breaks, you can simply take out the commands and execute them outside of `transform()` to debug them properly (especially when broadcasting many functions across many columns).

## Use DataFramesMeta as the Center of Data Universe
DataFrames ecosystem is the data-swiss-army knife that is worth mastering. I found that the below tips have significantly reduced the number of my errors but also increased the predictability of my outputs (ie, I expect to produce a load>transform>plot analysis that is stakeholder-ready within 30 minutes).

### Using DataFramesMeta, StatsPlots
Always start your data work with `using DataFramesMeta, StatsPlots`. They re-export most packages you need in the beginning, including DataFrames, Chain, and Plots package.

### Use Macros
Use DataFramesMeta (and StatsPlots) macros as much as you can. Read more [here](https://github.com/JuliaData/DataFramesMeta.jl) and [here](https://github.com/JuliaPlots/StatsPlots.jl). In particular, learn to master the following ones: 
> @select/@subset/@transform/@by/@orderby/@df

For example:
```
transform(df,:a=>(x->my_function(x,1))=>:a_my)
# becomes 
@transform df :a_my=my_function(:a,1)

subset(df, :A => a -> a .< 10, :C => c -> isodd.(c))
# becomes 
@subset df :a.<10 isodd.(:c)
# you can add brackets or && between the conditions for more readability
```

In general, you can reduce the amount of brackets, a lot of anonymous functions (vis. examples above), but most importantly it is a more natural for someone coming from Pandas where we define `output = function(input)` (eg, in Pandas we would write: `df.assign(a_my=lambda x: my_function(x["a"],1))`).

### Use Row-wise Macros
Use `@r` versions of the above macros to avoid the need to broadcast manually with a dot operator ([docs](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized)).
> @rselect/@rsubset/@rtransform

In other words, save yourself a lot of broadcasting and broadcasting-related errors, especially if you're coming from the Pandas / Numpy world where broadcasting was often done automatically.

For example, the subsetting example above would become `@rsubset df :a<10 isodd(:c)`. Simply beautiful!

One caveat is that it won't work for methods that require arrays (eg, lead, lag, categorical), but you can simply just remove the `r` and it will work again!

For keen observers, macro `@df` does not actually belong to DataFramesMeta but to StatsPlots. However, its application (and reasons for using it) are similar. We can call plots with symbols representing DataFrame's columns instead of having to provide the whole columns making it, in my opinion, more readable. 

For example:
```
bar(my_dataframe_with_poor_name.col_name,my_dataframe_with_poor_name.col_value)
# becomes
@df my_dataframe_with_poor_name bar(:col_name,:col_value)
```

### Use @chain Pipelines
I cannot overemphasize how clean and practical it is to write your data manipulation in a pipeline in a non-mutating way (ie, not having 10 different DataFrames, each for a different chart ala `new_df2=select(df,:a,:b,:c)`).

Creating new DataFrames for every task makes it more error-prone, harder to read, harder to re-run, and harder to re-factor into a fully tested data application. Learn [@chain](https://github.com/jkrumbiegel/Chain.jl) by heart and you will never look back!

Example of data->plot with @chain macro (not runnable):
```
# we start with a DataFrame df and return a bar plot (as it's the last line executed) 
pl=@chain df begin
    @select :a,:b,:c    # select what you need
    @by :b :a_sum=sum(:a) :c_min=minimum(:c)  # one-line groupby-combine call with two new columns
    @orderby :c_min     # ordering just for the show
    @rtransform :b_double=:b*2  # Easy transformations
    @rsubset :b_double<20  # And easy filtering

    # you can even add plots with @df macro
    @df bar(:b,:c_min,title="My Important Chart")
end
```
It is so elegant, so easy to read and we had to write our DataFrame name `df` only once at the top, as the result of each line gets passed automatically as the first argument to the function on the next line (hence, the name "chain").

Fun fact: The above example was written automatically by [Github Copilot](https://github.com/features/copilot) in my Neovim (it was 90% of what I wanted). It plays very well with @chain syntax.


Other highlights:
- Using `@aside` or potentially `@aside @info` for introspection or for creating temporary variables for better readability
- Using one-liner chain without begin-end when a simple pipe operator `|>` is not suitable (eg, multiple arguments are needed), eg, `@chain ["a","B"] join(_,"|")`


## Use Plots.jl
- The most intuitive and versatile (especially if you have a very specific ask/chart to make)
- Multiple backends, eg, interactive PlotlyJS()
- Incredibly easy to guess the necessary keyword (nicely composable and multiple aliases)
- If you cannot guess, jump to help `?plot` and notice the mention of `plotattr(:Series)`
    - Use it to see all available keywords
    - Also, leverage methods and @edit macro in REPL!

## A Common Broadcasting Error
If you get an error and it's a MethodError saying that there is no method defined for a Vector (or some collection), it might be a classic beginner error. You might be calling a method (function) that is defined for individual items (eg, `s="ABC"; lowercase(s)`) on a collection of items (eg, `s_vec=["ABC","DEF"]; lowercase(s_vec)` would you give you such error).

Often you can get away with a quick fix. Add a dot between the function name and the opening bracket to signal that Julia should apply this function to all items in the collection (eg, `s_vec=["ABC","DEF"]; lowercase.(s_vec)` - notice the `.` after lowercase). 

Read more in the [Julia manual](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized).
