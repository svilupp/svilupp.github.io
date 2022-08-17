@def title = "Julia for Data: Tips for Better Beginning #2"
<!-- @def published = "20 August 2022" -->
@def tags = ["julia","beginners"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
Invest time in learning to use REPL. Most importantly learn to look up examples (and help) to avoid breaking your [flow](https://en.wikipedia.org/wiki/Flow_(psychology)).

# Embrace the REPL
It is too powerful not to! And time invested in mastering it will return thousandfold!

## What is REPL?
Official documentation says:
> Julia comes with a full-featured interactive command-line REPL (read-eval-print loop) built into the julia executable. In addition to allowing quick and easy evaluation of Julia statements, it has a searchable history, tab-completion, many helpful keybindings, and dedicated help and shell modes.

That is an understatement of the century. My personal favourites are:
(I assume you have enabled [OhMyREPL.jl](https://github.com/KristofferC/OhMyREPL.jl) package in startup.jl or just loaded it by `using OhMyREPL`)

## #1 Switching modes

## #2 Autocompletion and ANS
- up & down, search

## #3 Getting help without leaving my workflow
- Help mode: ?
- Fuzzy search with "DataF"
- Copy&paste with "julia>…"
- Outside… methodswith

## #4 Extracting the history
- Pull up the history with: `edit(REPL.find_hist_file())`
- If you use vim, you can simply TODO: add regex to delete comments (CAREFUL NOT TO SAVE THIS FILE - it would break REPL history!)

## My Tips
- Leverage the vertical space
- Flying through: keyboard shortcuts like CTRL+A or +E

# Resources to learn
- [Julia REPL Mastery Workshop](https://www.youtube.com/watch?v=bHLXEUt5KLc)
- [Julia REPL Tips and Tricks](https://www.youtube.com/watch?v=EkgCENBFrAY)
- [Official Documentation](https://docs.julialang.org/en/v1/stdlib/REPL/)

