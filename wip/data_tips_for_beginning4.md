@def title = "Julia for Data: Tips for Better Beginning #4"
<!-- @def published = "20 August 2022" -->
@def tags = ["julia","beginners"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
This article is focused mostly on data crunching. Use mainly DataFramesMeta+StatsPlots and apply coding patterns that are less error-prone.

# Explore the wider ecosystem
There are many ways how you can achieve the same thing in Julia. I found that a few specific tips can reduces the number of errors you make and greatly enhance your "time-to-insight".

## Tooling that I wish to have used earlier

### Revise

### logging
@info is your friend! no more print print print needed

### Debugger
and Infiltrator
eg, break_on(:error)
Don't use it enough?
```plaintext
names(Debugger) # to see function it exports
break_on_error()
@run my_func_that_breaks()
# once inside, type ? to get help, backtick to switch to julia execcution mode, q to quit
```
### JET

# Re-Think your overall workflow
Tips:
- version control
    - source code with git (eg, Github Desktop makes it very easy)
    - data (eg, DVC)
- Put the science back into data science
    - track your experiments and progress (eg, MLFlowClient, DVC)
- Publish beautiful reports and presentations
    - use Literate + Quarto
- Automate your workflow
    - If you often repeat some commands in terminal, wrap them into a Make file or add an alias in your terminal config file
