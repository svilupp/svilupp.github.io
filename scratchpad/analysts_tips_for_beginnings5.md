@def title = "Julia for Analysts: Tips for Better Beginnings - The Bigger Picture (#5)"
@def published = "24 August 2022"
@def drafted = "17 August 2022"
@def tags = ["julia","beginners"]

# TL;DR
After the first week, have a look at other tools that the Julia ecosystem offers (Revise, Logging, Debugger). After the first month, re-visit the tools to solve the biggest pain points you encountered. Julia is only a small part of any project's (model/insight/application) success - invest time in version control, experiment logging, effortless outputs, and automation.


## Packages that I wish to have used earlier

### Revise
[Revise.jl](https://timholy.github.io/Revise.jl/stable/) is the best thing since sliced bread! Your (loaded) code will magically update every time you make a change and you don't need to restart Julia.

I used to simply track my scripts with `includet()`, but I have now started creating a dedicated package for every mini analysis (with `]generate`). As soon as it deserves its own folder, it deserves its own project specifications - there are several downstream benefits as well.

### PkgTemplates
If you're considering publishing your work, you should ALWAYS start your project with [PkgTemplates.jl](https://invenia.github.io/PkgTemplates.jl/).

A turnkey solution for a modern Julia package - it can set up your folder structure, documentation, tests, git, Github actions, and many more.

### Test
Testing could not be easier (`using Test`)! I think the overhead for a light test suite is c. 2 minutes per function and it will save you countless hours of debugging!

My workflow:
- I apply the "Rule of Three" - If I use some logic 3 or more times (or know that I will), I wrap it in a function, generate light docstrings and add a simple assertion statement to test the expected output (`@assert X==Z`).
- This function lives in a file in the `src` folder, but Revise.jl package takes care of re-loading every change I make.
- I then move the code into a file in `test` folder in my project and add register it with my project (`include(data_handlers.jl)` line in `test/runtests.jl`)
- The only thing left to do is to replace `@assert` for `@test` (optionally wrap several tests into `@testset`s) and run all your tests with `]test` (in the REPL package mode).


### Logging
Part of the standard library, but awesome nonetheless. Macro `@info` is your friend and you will never use print again!

You can customize your loggers with [LoggingExtras.jl](https://github.com/JuliaLogging/LoggingExtras.jl).

### Debugger
[Debugger.jl](https://github.com/JuliaDebug/Debugger.jl) is an excellent tool to debug your code interactively without having to do any initial set-up.

[Infiltrator.jl](https://github.com/JuliaDebug/Infiltrator.jl) is a lighter alternative if all you care about is setting a breakpoint and being able to inspect the context.

My typical workflow when I get an odd error from `my_func_that_breaks()`
```
using Debugger
names(Debugger) # to see the functions  it exports
break_on_error(true) #or break_on(:error)
@run my_func_that_breaks()
# once inside, type ? to get help, backtick to switch to julia execution mode, and q to quit
```

### JET
An awesome code analyzer, [JET.jl](https://github.com/aviatesk/JET.jl), can catch your errors before you run your code.

Simply run: `using JET; report_and_watch_file("my_script.jl",annotate_types=true)`

### Term
[Term.jl](https://github.com/FedeClaudi/Term.jl) is mostly for building beautiful CLIs and terminal applications (similar to [Rich](https://rich.readthedocs.io/en/stable/introduction.html) in Python)

However, it has several nice methods for everyday use, eg, `termshow(func)` for displaying available methods and the soon-to-be-released `@showme` macro that will show you the definition of a given method instance.

### JuliaFormatter
[JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) is a great saver and it makes your code much more readable.

All you need to do is to run: `using JuliaFormatter; format(".")` in your project directory.

### Literate
[Literate.jl](https://fredrikekre.github.io/Literate.jl/v2/) is your gateway to Literate Programming](https://en.wikipedia.org/wiki/Literate_programming).

In short, you can write your code as an easily readable and version-controlled script but with one command you can export it into Markdown, Notebooks, etc. 

The best part is that you don't need to change almost anything - just add a `#` here and there to achieve the desired layout.

What are the benefits of Literate Programming?

In the world of data, it's often not enough that your code runs and tests succeed, you need to be able to explain it and document it for other stakeholders and yourself (there are sometimes 100+ projects in a year, would you really remember what you did?).

It is even more powerful when used with Quarto.

### Quarto
[Quarto](https://quarto.org/) is "an open-source scientific and technical publishing system built on Pandoc" (you could say it's a cross-platform successor to Rmarkdown + Knitr available to Python and Julia users).

I have not seen a better tool for parametrized runs and for publishing of beautiful reports in many output formats (presentations, html reports, and more).

See [Using Julia in Quarto](https://quarto.org/docs/computations/julia.html).

My workflow is often to push my script into Quarto Markdown (with Literate.jl) and then produce an HTML report (for distribution) and an interactive Revealjs presentation for the meetings. As an ex-management consultant, I cannot believe how easy it is to create such beautiful and professional presentations.


## Re-think your overall workflow
Julia is only a small part of any project's (model/insight/application) success. Invest time in building a robust workflow around it.

The below overview has some pointers on what works well for me and my use cases.

My Project Ecosystem
- Project structure + Documentation
  - Structure your project in a way that any collaborator will know how to navigate (eg, use PkgTemplates.jl and get inspired with [Cookiecutter](https://cookiecutter.readthedocs.io/en/stable/) folder structure)
  - At first, describe your project in the README.md file and explain step by step how to run it (/re-train models)
  - Later on, build proper documentation with examples (eg, Literate.jl + Documenter.jl)
- Version Control
  - Source code with git (eg, use Github Desktop, it makes everything effortless)
  - Data (eg, use DVC with AWS S3 backend, it is very cheap and easy to set up)
- Put the science back into data science
  - Track your experiments and progress towards your success metrics (eg, MLFlow is great - you can use [MLFlowClient.jl](https://github.com/JuliaAI/MLFlowClient.jl) or [DVC Experiment Tracking](https://dvc.org/doc/use-cases/experiment-tracking))
- Publish beautiful reports and presentations
  - There is never enough commentary and artifacts that describe the logic you applied or of reports that discuss the reports and findings (eg, use Literate.jl + Quarto)
- Automate your workflow
  - Locally: If you frequently repeat some commands in your shell, wrap them into a [Makefile](https://opensource.com/article/18/8/what-how-makefile) or add an alias in your shell's config file (see article #1)
  - On the cloud: Github Actions or Azure Pipelines can run your test suite and any other checks every time your push. This is invaluable in terms of bashing the bugs that take a long time to surface and takes minutes to set up.

Honorable mentions that I have seen used but have no experience with:
- [DrWatson.jl](https://github.com/JuliaDynamics/DrWatson.jl) with a tag line "The perfect sidekick to your scientific inquiries". It has been used in several projects, including UK's epidemiological modelling ([Epimap.jl](https://github.com/epimap/Epimap.jl-public))
- [RemoteFiles.jl] when you have to keep up-to-date with some remote origins
