@def title = "Julia for Analysts: Tips for Better Beginnings - Embrace the REPL (#3)"
<!-- @def published = "20 August 2022" -->
@def drafted = "17 August 2022"
@def tags = ["julia","beginners"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
Invest time in learning to use REPL. Most importantly learn to get help (docstrings, examples, methods) within REPL to avoid breaking your [flow](https://en.wikipedia.org/wiki/Flow_(psychology)).

# Embrace the REPL
It is too powerful not to! And time invested in mastering it will return thousand-fold!

## What is REPL?
Official documentation says:
> Julia comes with a full-featured interactive command-line REPL (read-eval-print loop) built into the julia executable. In addition to allowing quick and easy evaluation of Julia statements, it has a searchable history, tab-completion, many helpful keybindings, and dedicated help and shell modes.

That is an understatement of the century. My personal favourites are:
(I assume you have enabled [OhMyREPL.jl](https://github.com/KristofferC/OhMyREPL.jl) package in startup.jl or just loaded it by `using OhMyREPL`)

## Switching modes
- ]
- ;
- ?

## Autocompletion and ans
- up & down, history search
- use `ans` (=result of the previous line) when flying through some simple calculations or when wanting to avoid building long function pipes

## Getting help without leaving my workflow (no more Googling)
- Help mode: ?
- Fuzzy search with "DataF" (or `apropos()`)
- Effortless copy & paste of examples with "julia>" - Julia REPL will "eat it"
- Outside… methodswith
- Not sure about what methods are exported by a certain package ("that function from PackageA that does XYZ")? `names(PackageA)`
- Not sure how to extract some values from a custom type `MyType` (or what fields it has)? Type `mytype|>typeof|>fieldnames` on the instance or `fieldnames(MyType)` on the type, eg, `DataFrame|>fieldnames`
- Are the docstrings not enough / would it be helpful to quickly scan the source file (eg, for `plot()`)? Look up the method, get its file location and open it via `edit()`, eg, `methods(plot)[1].file|>string|>edit`. How did I know that there is a Method attribute "file"? I typed `methods(plot)[1]|>typeof|>fieldnames` to find out where the source filenames are stored

## Extracting the history
- Pull up the history with: `edit(REPL.find_hist_file())`
- If you use vim, you can simply TODO: add regex to delete comments (CAREFUL NOT TO SAVE THIS FILE - it would break REPL history!)

## My Tips
- Leverage the vertical space
- Flying through: keyboard shortcuts like CTRL+A or +E, eg, you write a function and get an errors
    - step one type `fix` (from package TheFix) that will quickly lookup if you just made a typo and will offer a correction
    - step 2: pull up the docstrings for that function in 2 seconds:
        - `Arrow UP` (for previous command)
        - `CTRL+A` (jump to beginning of the line)
        - type `?` (trigger the help mode - you should see `?<your_function>`)
        - and ENTER --> Voila! Your docstrings are here in 2 seconds!

## Resources to learn more
- [Julia REPL Mastery Workshop](https://www.youtube.com/watch?v=bHLXEUt5KLc)
- [Julia REPL Tips and Tricks](https://www.youtube.com/watch?v=EkgCENBFrAY)
- [Official Documentation](https://docs.julialang.org/en/v1/stdlib/REPL/)

