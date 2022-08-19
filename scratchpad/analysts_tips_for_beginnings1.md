@def title = "Julia for Analysts: Tips for Better Beginnings - Sharpen your Axe (#1)"
@def published = "19 August 2022"
@def drafted = "17 August 2022"
@def tags = ["julia","beginners"]

# TL;DR
Prepare your tools before you even start coding. Get better terminal and configure it. Install pipx, juliaup, set up your `startup.jl` file.

\toc

# Introduction
If I were to learn Julia all over again, I would do a few things differently.

If you are a data professional (analyst/scientist/engineer) looking to _minimize the time to learn enough Julia to be dangerous_, this series is for you.

# Invest in Sharpening your Axe :axe:
> "Give me six hours to chop down a tree and I will spend the first four sharpening the axe."
>-- Abraham Lincoln

President Lincoln knew what all developers learn early on --> invest time in setting up your tools.

Unfortunately, no one tells you that when you're a self-taught data analyst/scientists/engineer.

# General Tips
## Set up your Terminal
Whether you like it or not, you will likely spend a lot of time in the terminal, so you might as well set it up well.

On a Mac, I'd recommend Iterm2 + zsh + oh-my-zsh. See an [installation guide](https://medium.com/ayuth/iterm2-zsh-oh-my-zsh-the-most-power-full-of-terminal-on-macos-bdb2823fb04c)

Benefits include autocompletion, great highlighting, clear information if you're in a GIT repository (and which branch), and many more!

_Difficulty: Low_
\
_Downsides: None_

## Shell Configurations and Secrets
Do you often call the same long commands? Do you need some secrets or configuration to access the same data warehouse across many projects?

Invest time in setting up the default configuration of your shell (eg,`~/.zshrc` file if you have zsh).

**Tricks**
- If you use long commands (eg, different versions of Python or Julia), give them an alias that you can call directly,

    eg, add the following line `alias myapp='conda run -n my-app-environment python3 /some/long/path/myapp.py -g -r'` and you'll never have to type this command again. You can simply call `myapp`
- If you use a GIT repository that requires SSH access, it's nice if your shell remembers your password (see [Start SSH agent on login](https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login))
- Automatically load your credentials into the [environment variables](https://www.twilio.com/blog/2017/01/how-to-set-environment-variables.html)
    - add the following line `source ~/.secrets.sh` to your configuration file (eg, `~/.zshrc`)
    - create the file `~/.secrets.sh` and add the following lines
```plaintext
# DATABASE CONNECTIONS
export DB_ORACLE_IP="..." # add your details
export DB_ORACLE_USERNAME="..." # add your details
export DB_ORACLE_PASSWORD="..." # add your details

# you can even have aliases for the same value
export MYDB_PASSWORD=$DB_ORACLE_PASSWORD #it will mirror the value above
```
&nbsp;&nbsp;&nbsp;&nbsp;- Now, try accessing these values from shell (`echo $DB_ORACLE_IP`), python (`os.environ["DB_ORACLE_IP"]`), or Julia (`ENV["DB_ORACLE_IP"]`)

On the last point, there are several benefits:
- You'll drastically reduce the risk of accidentally publishing a file with your passwords (eg, `.env` files)
- It's easier for your collaborators (and cloud jobs) to set up their own credentials and the code will magically run for all of you
- You can use them across Python/Julia/? without any specialized parsers

_Difficulty: Low_
\
_Downsides: None_

## Use pipx
Start using [pipx](https://pypa.github.io/pipx/) for all Python-based CLI applications (eg, AWS CLI, black, flake8, jupyter, language servers, mlflow)

A lot of Python-based applications ask you to "simply install with pip" (eg, `pip install ABC`). Unfortunately doing that will change all relevant python packages in your global environment (ie, break things)!

You could create small environments for each application to be able to independently remove them / update them. That is exactly what pipx does for you (and more)!

Try it out! On macOS:
```plaintext
brew install pipx
pipx ensurepath
```

No more `pip install`...

_Difficulty: Low_
\
_Downsides: None_

## Use Mamba (/Conda)
Before Julia, having clean environments for was not easy. If you use Python, the closest thing you can get is [Mamba](https://mamba.readthedocs.io/).

It makes creating and managing separate environments for Python easy and unlike Conda it's really fast.

Read more: [Installation instructions](https://github.com/conda-forge/miniforge#mambaforge)

_Difficulty: Low
\
Downsides: None_

# Julia-specific Tips
## Use Juliaup
Install [juliaup](https://github.com/JuliaLang/juliaup) and use it automatically update your Julia version (or to switch between different versions)

Installing it on a mac or linux is as simple as `curl -fsSL https://install.julialang.org | sh`

## Create startup.jl
Similar to the theme of setting up your terminal with configurations, you can do the same for your Julia.

You can have all frequently used packages loaded automatically when you start Julia REPL by adding them to a file called `startup.jl` ([Documentation](https://docs.julialang.org/en/v1/manual/command-line-options/)).

 Example:
```plaintext
# what text editor to use when edit() is called
# "code" assumes you can call VS Code from your shell
ENV["JULIA_EDITOR"] = "code"
using Pkg
import REPL
using OhMyREPL
using TheFix;TheFix.@safeword fix true
using BenchmarkTools
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
Save this file in `~/.julia/config/startup.jl` (where `~` is your user's home directory). You will thank me later.

If something isn't working, you can suppress loading startup.jl by starting Julia with `julia --startup-file=no`

There are a few packages that haven't made it to my startup.jl file yet, but I would suggest you consider them:
- [Term.jl](https://github.com/FedeClaudi/Term.jl) for displaying available methods with `termshow(func)`
- [JET.jl](https://github.com/aviatesk/JET.jl) to catch silly errors in your scripts. See [video from JuliaCon 2021](https://www.youtube.com/watch?v=7eOiGc8wfE0)
- [JuliaSyntax.jl](https://github.com/JuliaLang/JuliaSyntax.jl) Exciting new syntax parser that will give you much better error messages. I'm waiting for version 0.1. Check out the [JuliaCon 2022 video](https://www.youtube.com/watch?v=CIiGng9Brrk)

_Difficulty: Easy
\
Downsides: Slightly slower start-up time of Julia REPL (if you add too many packages)_

## (Advanced) Precompile your Sysimage
No beginner should ever start here, but it might happen in the first weeks/months.

There is an infamous waiting time for the first time a command runs (eg, waiting for the first plot) or, in general, waiting for Julia REPL with your startup.jl file. If you find it frustrating, use [PackageCompiler.jl docs](https://julialang.github.io/PackageCompiler.jl/dev/examples/ohmyrepl.html) to create a system image with all these packages and functions you use preloaded.

There is an alternative solution below.

_Difficulty: Medium
\
Downsides: Lost flexibility / ability to easily update (eg, you won't be able to easily update your Julia or those precompiled packages)_

## Use persistent sessions (tmux)
Following on from the previous point, there is a different way to mostly avoid the "time-to-first-X" (ie, the first compilation).

You can use persistent sessions with tmux (=Terminal MUltipleXer, or others like Screen, Dtach, Abduco+Dvtm). Persistent means that instead of closing Julia REPL every time, you just disconnect and later on reconnect. It will remember all your loaded functions, variables, packages, etc.

Note: This is incredibly useful if you use Julia REPL as your super-calculator / Excel-replacement.

Try it:
 - Open your shell
 - Type `tmux` and a new window will open
 - Type `julia` to start Julia REPL and print something, eg, `println("Hello!")`
 - Now disconnect from this session by pressing `CTRL+b` followed by `d`, and your screen show disappear (/switch back to previous shell)
 - Type `tmux a` and you should see your Julia session with "Hello" printed

Read more: [Quick and Easy Guide to Tmux](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)

_Difficulty: Low
\
Downsides: None (except for the layer of complexity)_
