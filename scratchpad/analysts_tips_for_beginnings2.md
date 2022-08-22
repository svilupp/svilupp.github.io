@def title = "Julia for Analysts: Tips for Better Beginnings - Pick the right IDE (#2)"
@def published = "20 August 2022"
@def drafted = "17 August 2022"
@def tags = ["julia","beginners"]

# TL;DR
While it might be tempting, resist the urge to use Jupyter Notebooks (/ Jupyter Lab) and use Julia in VS Code (with the Julia extension) instead. If you do only light analyses, consider Pluto.jl. If you need the cloud compute or don't want to install Julia, try JuliaHub.

\toc

# Pick the Right IDE
## Warmup: Julia REPL + Tmux

If you use REPL a lot, look into combining it with tmux (see the previous article (#1)). It will allow you to "hide" your opened Julia REPL session.

It is not a fully-fledged replacement for an IDE, but it can help with a lot of quick tasks. You can use your "hidden" Julia REPL session as a quick-access super-powered calculator / Excel replacement / file scanner.

 Try it:
 - Open your shell
 - Type `tmux` and a new window will open
 - Type `julia` to start Julia REPL and print something, eg, `println("Hello!")`
 - Now disconnect from this session by pressing `CTRL+b` followed by `d`, and your screen show disappear (/switch back to the previous shell window)
 - Type `tmux a` and you should see your Julia session with "Hello" printed

 Read more: [Quick and Easy Guide to Tmux](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)

_Difficulty: Low
\
Downsides: None (except for the layer of complexity, I would suggest avoiding any window management)_

## VSCode (+Tmux)
The most modern and popular (seemingly) environment for Julia. It offers a modern IDE and a notebook-like experience if you want to combine both.

You must install the Julia VS Code extension is incredible! Read more [here](https://www.julia-vscode.org/).

:fire::fire::fire: Nowadays, you can start a [VS Code server](https://code.visualstudio.com/blogs/2022/07/07/vscode-server) from any remote machine and connect to it via your Github account. It's a similar experience to using VSCode on [JuliaHub](https://juliahub.com/ui/Home).

A few things that are worth configuring (Extensions - Julia - Extension Settings):
- Pick your main shell (eg,"/bin/zsh" in "Julia > Persistent Session: Shell")
- Enable persistent sessions with tmux under the hood ("Julia > Persistent Session: Enabled")

Other tips:
- Invest time in learning some of the basic shortcuts to stay in the [flow](https://en.wikipedia.org/wiki/Flow_(psychology)), eg, start with the ones that require lifting your hands from the keyboard and that you use often enough (eg, jumping between tabs, executing cells). Read some ideas [here](https://blog.logrocket.com/learn-these-keyboard-shortcuts-to-become-a-vs-code-ninja/#:~:text=You%20can%20switch%20between%20views,page%20up%20%2F%20page%20down%20))
- Split your screen and leverage the large vertical space for your data magic in Julia REPL
- Consider installing [Github Copilot](https://github.com/features/copilot). It works with Julia and can take out some of the repetitiveness and accidental syntactical mistakes
- If you're used to (or curious about) Vim (explained below), download the [VSCodeVim extension](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim), which emulates Vim keybindings in VS Code

_Difficulty: Low
\
Downsides: None_

## (N)Vim + Tmux
This is not for Julia beginners unless you're already familiar with it.

Vim is a highly configurable text editor. The main difference I see is that you operate not with arrow keys or a mouse but by executing "motions" that can perform incredibly complex tasks (and then you can easily repeat them).

It is my personal favourite and it has led to a significant boost in my productivity. But it requires a lot of setting up (a lot lot lot).
Once you do, you will need 1-2 weeks to get used to it but then it becomes so enjoyable! It feels like playing a game while working - sometimes I make some changes, undo them and think about the best power combo to achieve the same.

I believe the trick is to combine the best of Vim and modern tools we have, eg, nvim+lua, use your mouse when it's faster, scroll with it (Neoscroll), don't use registers, etc. Basically, do things the way that is the most convenient / the fastest for YOU.


I'd recommend:
- [Julia-vim](https://github.com/JuliaEditorSupport/julia-vim)
- [Vim-Slime](https://github.com/jpalardy/vim-slime)
- Precompile your LanguageServer.jl with Fredrikekre's great [makefile](https://discourse.julialang.org/t/neovim-languageserver-jl/37286/72?u=svilupp)
- [Nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to be able to select Julia loops or functions with one quick motion
- [Leap](https://github.com/ggandor/leap.nvim) to jump anywhere in the texts
- [Vim-sandwitch](https://github.com/machakann/vim-sandwich) to easily work with (),[],{},"", and others
- [LeaderF](https://github.com/Yggdroot/LeaderF) to quickly jump between files, buffers, etc.
- [Copilot-cmp](https://github.com/zbirenbaum/copilot-cmp) to benefit from Github Copilot in Neovim

Other resources:
- Vim+Julia on Discourse: [Vim for newbies](https://discourse.julialang.org/t/julia-vim-tutorial-for-newbies/36636/18) and [Neovim and LanguageServer](https://discourse.julialang.org/t/neovim-languageserver-jl/37286/72?u=svilupp)
- My [Nvim configuration](https://github.com/svilupp/dotfiles) (adapted from the amazing version by [Jdhao](https://github.com/jdhao/nvim-config))
- Is it for you? Check out: [Why I use Vim in 2022](https://www.youtube.com/watch?v=D4YTJ2W5q4Y) and the first post in [here](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim) or the gist of it: ["Your problem is that you don't grok vi"](https://gist.github.com/nifl/1178878)

_Difficulty: High
\
Downsides: Very steep learning curve. Not suitable to learn at the same time as Julia_

## IJulia (Jupyter Notebook/Lab)
The standard entry point via the Jupyter Notebook or Jupyter Lab experience. I have learned Python in it and I'm grateful for how easy it was, but Julia REPL + VS Code is much better.

It is still a good option if you're bound to big cloud platforms (eg, AWS Sagemaker Notebooks), but if you can look into VS Code Server. If you need both the compute (big cloud machines) and Julia, [JuliaHub](https://juliahub.com/ui/Home) is the best option.

A few tips to make the transition easier:
- Split your screen and give Julia REPL a lot of vertical space - you would see so much more than in an individual notebook cell
- If you need to see some output from 2 steps ago, either:
    - Press Arrow up twice and execute it (takes 2 seconds, arguably faster than scrolling)
    - Use history search (CTRL+R) or TAB auto-completion to quickly find your commands. More on that in the next article.
    - You can also scroll in REPL...
- If you miss the Table of Contents, remember that you now work with text - learn some shortcuts for quick searching and jumping around
- If you don't want to lose the outputs of individual steps, or produce nice reports, look into [Literate.jl](https://fredrikekre.github.io/Literate.jl/v2/) or [Quarto](https://quarto.org/). I use both fairly regularly

_Difficulty: Low
\
Downsides: Missing many perks of REPL and associated packages (eg, OhMyREPL, REPL special modes, REPL history)_

## Others
I have listed only the options I have used a lot to have a basis for comparison, but there are many more.

### Pluto.jl
Pluto are reactive notebooks (ie, re-evaluating on every "input" change). They are an incredible choice for quick interactive presentations, visualizations, and teaching.

If you have simple analyses (a single file) that don't take long and don't mind working with smaller code blocks (it operates on individual statements to be reactive), Pluto.jl is the best choice for you.

See: [Pluto.jl](https://github.com/fonsp/Pluto.jl) and an amazing resource on [building slides with Pluto.jl](https://andreaskroepelin.de/blog/plutoslides/)

### JuliaHub
It's strictly not an IDE. It's a cloud service from Julia Computing that allows you to spin up and down Pluto.jl notebooks, VS Code with arbitrary computing power.

If you don't want to install Julia on your computer, [JuliaHub](https://juliahub.com/ui/Applications) is the best choice.

### Emacs
I have met as many Julia users using Emacs as those using Neovim, so definitely a popular option. Somehow it tend to be people with Computer Science background.

See: [Julia-emacs](https://github.com/JuliaEditorSupport/julia-emacs) and [julia-snail](https://github.com/gcv/julia-snail)

