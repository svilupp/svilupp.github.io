@def title = "Julia for Analysts: Tips for Better Beginnings - Embrace the REPL (#3)"
@def published = "22 August 2022"
@def drafted = "17 August 2022"
@def tags = ["julia","beginners"]

# TL;DR
Invest time in learning to use REPL. Most importantly learn to get help (docstrings, examples, methods) within REPL to avoid breaking your [flow](https://en.wikipedia.org/wiki/Flow_(psychology)).

# Embrace the REPL
It is too powerful not to! And the time invested in mastering it will return a thousand-fold!

## What is REPL?
The official documentation says:
> Julia comes with a full-featured interactive command-line REPL (read-eval-print loop) built into the julia executable. In addition to allowing quick and easy evaluation of Julia statements, it has a searchable history, tab-completion, many helpful keybindings, and dedicated help and shell modes.

That is an understatement of the century, see [Julia REPL Tips and Tricks](https://www.youtube.com/watch?v=EkgCENBFrAY) to learn more.

I will highlight some of my personal favourites in the following sections. I will assume you have enabled [OhMyREPL.jl](https://github.com/KristofferC/OhMyREPL.jl) package in `startup.jl` or just loaded it by `using OhMyREPL`. You can find a how-to for setting up your `startup.jl` file in article #1 of this series.

## Switching modes
It's a 4-in-1 deal: your standard programming mode and three more, Package, Shell, and Help. Type a leading character to try them:
- `]` for Package mode: You can activate a project environment in the same folder (`activate .`) or add a package (`add XYZ`)
- `;` for Shell mode: I never have to leave REPL and lose my progress when I want to move files and change directories, but I also don't have to use special commands (eg, `run('ls')`) to pass commands to my shell. You can also easily interpolate your Julia variables into these shell commands, an incredible power tool for working with the filesystem
- `?` for Help mode: You can access docstrings and examples without having to switch over to the browser and search on StackOverflow

If you delete the character (eg, with a Backspace), it will jump back to normal Julia mode.

Why is that so powerful? It allows you to quickly switch into a dedicated context(/experience) allowing you to achieve your goals more efficiently. All it takes is one character in front of your command.

With the difference being a single leading character you can also quickly take the same command and use it in different modes (more on that in the next section about Getting Help) without any clicking or copy&pasting.

For example, to active my project, I would:
- `;cd my/project/path/` to change the directory
- and `]activate .` to activate my project-specific environment

Why did I write the two commands and not `activate` with a specific path? I often want to load scripts or data from the same folder and use relative addresses (eg, `data_raw/file.csv`), which is why I change the working directory first.

## Autocompletion, Navigation, and ans
Keep pressing TAB. All relevant packages, variables, functions, etc. are preloaded, so you can save yourself a lot of typing.

Navigating back to your recent commands has never been easier - just use `ARROW UP` and `ARROW DOWN`. If you jump to a certain point in history, you can also replay your commands from that point by continuing with `ARROW DOWN`.
Lastly, you can quickly fuzzy search your history with `CTRL+r`.

Results of the previous command are saved in a variable named `ans`, so you simply fly through some simple calculations without having to nest multiple function calls or use pipes. Try it!

## Getting help without leaving my workflow (no more googling)
With Julia REPL, you can avoid the majority of googling for help, which means more productive coding time!

To be able to run the below examples, you'll need to run `using DataFrames, Dates, Plots` first.

Different ways how to help yourself:
- Open the Help mode and type the name of the function or object, eg, `?DataFrame`, to pull up the documentation and examples
- Use fuzzy search if you're not sure about the exact name (add quotes around the word, eg, `?"DataF"` or use `apropos()`)
- When you find a good example, copy & paste the example with "julia>" in it. Julia REPL will "eat it" and the example will run
- Cannot recall the name of the function for the Week object in the Dates package? Run `methodswith(Dates.Week)` to see all functions that have specialization (a version for) Weeks
- Not sure about what functions are exported by a certain package (ie, "that function from PackageA that does XYZ")? Run `names(PackageA)`
- Not sure how to extract some values or attributes from a custom type `MyType` (or what fields it has)? Type `mytype|>typeof|>fieldnames` on the instance (ie, on your existing variable) or `fieldnames(MyType)` on the type itself, eg, `DataFrame|>fieldnames`
- Are the docstrings not enough / would it be helpful to quickly scan the source file (eg, for `plot()`)? Look up the method, get its file location and open it via `edit()`, eg, `methods(plot)[1].file|>string|>edit`.
    - How did I know that there is a Method attribute "file"? I typed `methods(plot)[1]|>typeof|>fieldnames` to find out where the source filenames are stored (see the tip above)

Was that too many new functions? You need to remember only the first few letters, then press a TAB and REPL will magically autocomplete for you!

## Extracting the Command History
You can also pull all your commands to create a proper script: `edit(REPL.find_hist_file())`. You might need to run `import REPL` first.

If you use Vim or VSCode, you can then simply remove all the lines starting "#" and your script is ready! WARNING: Do not change the actual file - you would break it!!

## Some Random Tips
- Leverage the vertical space - split your screen and use the full height of REPL to see your DataFrames and vectors properly
- Learn some basic navigation shortcuts. The most frequent ones for me are: `CTRL+A` or `CTRL+E` to jump to the beginning and end of the command

Example workflow: 

Imagine you write a function and get an error
- Step 1: type `fix` (from package TheFix) that will quickly lookup if you just made a typo and will offer a correction
- Step 2: pull up the docstrings for that function in 2 seconds:
    - `Arrow UP` (for previous command)
    - `CTRL+A` (jump to beginning of the line)
    - type `?` (trigger the help mode - you should see `?<your_function>`)
    - and ENTER --> Voila! Your docstrings are here in 2 seconds!

## Resources to learn more
- [Julia REPL Mastery Workshop](https://www.youtube.com/watch?v=bHLXEUt5KLc)
- [Julia REPL Tips and Tricks](https://www.youtube.com/watch?v=EkgCENBFrAY)
- [Official Documentation](https://docs.julialang.org/en/v1/stdlib/REPL/)
