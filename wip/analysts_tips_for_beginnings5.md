@def title = "Julia for Analysts: Tips for Better Beginnings - The Bigger Picture (#5)"
<!-- @def published = "20 August 2022" -->
@def drafted = "17 August 2022"
@def tags = ["julia","beginners"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
After the first week, have a look around at other tools that Julia ecosystem offers (Revise, Logging, Debugger,...). Julia is only a small part of any project's (model/insight/app) success - invest time in version control, experiment logging, effortless outputs, and automation.


# Explore the wider ecosystem
There are many ways how you can achieve the same thing in Julia. I found that a few specific tips can reduces the number of errors you make and greatly enhance your "time-to-insight". It feels like a lot, but the time invested will return thousand-fold.

## Tooling that I wish to have used earlier

### Revise
The best thing since sliced bread!

TODO: mention `]generate` / PkgTemplates

### Test
Testing could not be easier (`using Test`)! I think the overhead for a light test suite is c. 2 minutes per function and it will save you countless hours of debugging!

My workflow:

I apply the "Rule of Three" - If I use some logic 3 or more times (or know that I will), I wrap it in a function, generate light docstrings and add a simple assertion statement to test the expected output (`@assert X==Z`).

This function lives in a file in `src` folder, but Revise.jl package takes care of re-loading every change I make.

I then move the code into a file in `test` folder in my project and add register it with my project (`include(data_handlers.jl)` line in `test/runtests.jl`)

The only thing left to do is to replace `@assert` for `@test` (optionally wrap several tests into `@testset`s) and run all your tests with `]test` (in the REPL package mode).


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

### PkgTemplates

### Literate

### Quarto

### JuliaFormatter


# Re-Think your overall workflow
Tips:
- version control
    - source code with git (eg, use Github Desktop, it makes everything effortless)
    - data (eg, DVC)
- Put the science back into data science
    - track your experiments and progress (eg, MLFlowClient, DVC)
- Publish beautiful reports and presentations
    - use Literate + Quarto
- Automate your workflow
    - Locally: If you often repeat some commands in terminal, wrap them into a Make file or add an alias in your terminal config file
    - On the cloud: Github Actions or Azure Pipelines can run your test suite everytime your push. This is invaluable in terms of bashing the bugs that take long time to surface!

TODO: Extras
- shout out to Watson - epi
- science workflow
- ? files remote
