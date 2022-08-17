
@def title = "Julia for Data: Tips for Better Beginning #1"
<!-- @def published = "20 August 2022" -->
@def tags = ["julia","beginners"]

# THIS IS AN UNFINISHED DRAFT

# TL;DR
There are a few things I would have differently, if I were to learn Julia all over again. Here is the part #1.
Install juliaup, set up your `startup.jl` file, use VSCODE (and configure the Julia extension)


Context:

This is written from the perspective of a self-taught data professional. I'll refer to this persona as an analyst, despite the use cases covering also data scientist and data engineers (since, as you know, Julia can perform even with upto 100 million rows without breaking sweat)

# Sharpen your axe :axe:
> "Give me six hours to chop down a tree and I will spend the first four sharpening the axe."
>
> - Abraham Lincoln

President Lincoln knew what all developers learn early on - invest time in setting up your tools.
Unfortunately, no one tells you that when you're a self-taught analyst.

## General Tips
1) Set up your terminal
 Whether you like it or not, you like spend a lot of time in terminal, so you might as well set it up well.

 On a Mac, I'd recommend Iterm2 + zsh + oh-my-zsh. See an [installation guide](https://medium.com/ayuth/iterm2-zsh-oh-my-zsh-the-most-power-full-of-terminal-on-macos-bdb2823fb04c)

 Benefits include autocompletion, great highlighting, clear information if you're in a GIT repository (and which branch), and many more!

2) Source your configurations and secrets

3) Pipx

4) Mamba (/Conda)
Before Julia, having clean environments for your Python projects wasn't easy. Fortunately, Mambaforge is here to help.
It makes controlling separate environments easy and unlike Conda it's really fast.

Read more: [Installation instructions](https://github.com/conda-forge/miniforge#mambaforge)

Difficulty: Low

Downsides: None

## Julia-specific Tips
1) Install [juliaup](https://github.com/JuliaLang/juliaup) and use it automatically update your julia version (or to switch between different versions)

 Installing it on a mac or linux is as simple as `curl -fsSL https://install.julialang.org | sh`

2) Prepare your startup.jl for frequently used packages
 You can have all frequently used packages loaded automatically when you start your Julia REPL.

 Example:
```plaintext
ENV["JULIA_EDITOR"] = "nvim" # what text editor to use when edit() is called
using Pkg
import REPL
using OhMyREPL
using TheFix;TheFix.@safeword fix true
using BenchmarkTools
using Term
using Revise

@async begin
    # reinstall keybindings to work around https://github.com/KristofferC/OhMyREPL.jl/issues/166
    sleep(1)
    OhMyREPL.Prompt.insert_keybindings()
end

# automatically activate a project environment if available
if isfile("Project.toml") && isfile("Manifest.toml")
    Pkg.activate(".")
end
```

 Save this file in `~/.julia/config/startup.jl` (where `~` is your user's home directory)

 If something isn't working, you can suppress loading startup.jl by starting Julia with `julia --startup-file=no`

 Difficulty: Easy

 Downsides: Slightly slower start up time of Julia REPL (if you add too many packages)

3) (later on) Precompile your Julia to reduce time-to-first-X with [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl)
 No beginner should ever start here. There is an infamous waiting time for the first time a command runs (eg, waiting for the first plot) or, in general, waiting for Julia REPL with your startup.jl file. If you find it frustrating, use [PackageCompiler.jl docs](https://julialang.github.io/PackageCompiler.jl/dev/examples/ohmyrepl.html) to create a system image with all these packages and functions you use preloaded.

 There will be an alternative solution in the Environments sections

 Difficulty: Medium

 Downsides: Lost flexibility / ability to easily update (eg, you won't be able to easily update your julia or those precompiled packages).
 Document

4) Use persistent sessions (tmux)
# Choose the right environment
There are several other options but I include only the ones I have enough experience with (eg, skipping Emacs).

## Warmup: Julia REPL + Tmux

 Following from the previous point, there is a different way to not have endure the time it takes for the first compilation. You can use persistent sessions with tmux (or Screen, Dtach, Abduco+Dvtm). Persistent means that instead of closing Julia REPL everytime, you just disconnect and later on reconnect. It will remember all variables, packages, etc.

 Note: This is not a fully fledged replacement to an IDE, but it can help with a lot of the quick tasks. You can use your "hidden" Julia REPL session as a quick calculator / Excel / file scanner.

 Try it:
 - Open your shell
 - Type `tmux` and a new window will open
 - Type `julia` to start Julia REPL and print something, eg, `println("Hello!")`
 - Now disconnect from this session by pressing `CTRL+b` followed by `d`, your screen show disappear (/switch back to previous shell)
 - Type `tmux a` and you should see your Julia session with "Hello" printed

 Read more: [Quick and Easy Guide to Tmux](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)

 Difficulty: Low

 Downsides: None (except for the layer of complexity)

## VSCODE (+Tmux)
The most modern and popular (seemingly) environment for Julia. It offers both a modern IDE and a notebook-like experience.
Julia VS Code extension is incredible! Read more [here](https://www.julia-vscode.org/).

:fire::fire::fire: Nowadays, you can start a [VS Code server](https://code.visualstudio.com/blogs/2022/07/07/vscode-server) from any remote machine and connect to it via your Github account.

A few things that are worth configuring (Extensions - Julia - Extension Settings):
- Pick your main shell (eg,"/bin/zsh" in "Julia > Persistent Session: Shell")
- Enable persistent sessions with tmux under the hood ("Julia > Persistent Session: Enabled")

 Difficulty: Low

 Downsides: None

## (N)Vim + Tmux
My personal favourite but it requires a lot of setting up.
I'd recommend plugins:
- [Julia-vim](https://github.com/JuliaEditorSupport/julia-vim)
- [Vim-Slime](https://github.com/jpalardy/vim-slime)

 Read more: [On Discourse](https://discourse.julialang.org/t/julia-vim-tutorial-for-newbies/36636/18)
 My [Nvim configuration](https://discourse.julialang.org/t/julia-vim-tutorial-for-newbies/36636/18) (adapted from the amazing [Jdhao](https://github.com/jdhao/nvim-config))

 Difficulty: High

 Downsides: Very steep learning curve, so probably not suitable when also trying to learn Julia

## IJulia (Jupyter Notebook/Lab)
The standard entry point via the Jupyter Notebook or Jupyter Lab experience. Really good option if you're bound to big cloud platforms (eg, AWS Sagemaker Notebooks)

 Difficulty: Low

 Downsides: Missing many perks of REPL and associated packages (eg, OhMyREPL)

