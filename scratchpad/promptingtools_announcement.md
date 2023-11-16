@def title = "Unleashing AI's Potential for Everyday Productivity: Introducing PromptingTools.jl"
@def published = "16 November 2023"
@def drafted = "30 October 2023"
@def tags = ["julia","generative-AI","prompting"]

# TL;DR

PromptingTools.jl is a Julia package developed to fill a gap in AI tooling for enhancing personal productivity, especially in automating routine tasks. It features `@ai_str` and `@aai_str` macros for quick AI-powered queries within the Julia REPL and several other utilities (all exported names start with `ai...` for easy auto-suggestions). The main focus is re-using prompts, see `?aitemplates` and `?aigenerate`. Try it out: `using Pkg; Pkg.add(url="https://github.com/svilupp/PromptingTools.jl")`.

\toc

# Introducing PromptingTools.jl

It is both my job and passion to unlock value through AI, and PromptingTools.jl is a manifestation of this endeavour. Born from the recognition of a gap in AI tooling for personal productivity, this Julia package is tailored to automate small, yet crucial tasks in your daily routine.

PromptingTools.jl stands out with features like `@ai_str` and its asynchronous variant `@aai_str`, perfect for quick, in-flow questions without leaving the REPL. The ability to switch between models with simple flags like `gpt4t` adds versatility, ensuring tailored responses for diverse queries.

Key to its design is the focus on reusing intelligent prompts with `aitemplates` and handlebars-style templating, allowing you to inject custom tasks and data effortlessly. Each interaction also reports token usage and cost, keeping you informed and in control of your AI spending.

# Examples

Here's an example of its practicality for Julia developers:

```julia
msg = ai"Efficient vectorization techniques in Julia?"
```

```none
[ Info: Tokens: 389 @ Cost: $0.0008 in 9.6 seconds
AIMessage("Julia has several efficient vectorization techniques that you can use to optimize your code. Here are a few: .... <continues>)
```

The above example would be equivalent to:
```julia
msg = aigenerate("Efficient vectorization techniques in Julia?")
```
`aigenerate` opens a lot of possibilities, such as using templates (try `aitemplates("julia")`) or injecting data/context/? into your prompt with simple handlebars-style templating (`{{placeholder}}`).

For the more difficult queries, you might want to explore the asynchronous variant `@aai_str` with some stronger models like GPT-4 Turbo (aliased as "gpt4t" - notice the flag at the end):

```julia
aai"In Julia, what is a supertype of Real?"gpt4t
```

The results will be printed to the REPL as soon as they are ready, and you can continue with your work in the meantime.

```none
[ Info: Tokens: 412 @ Cost: $0.0118 in 25.2 seconds
┌ Info: AIMessage> In Julia, the supertype of `Real` is `Number`. The type hierarchy in Julia for numerical types is designed such that `Number` is the abstract type at the top, which includes all numeric types. Below `Number`, there are two main subtypes: `Real` for real numbers, and `Complex` for complex numbers. The `Real` type itself is an abstract type and it has various concrete subtypes representing different kinds of real numbers, such as `Integer` and `FloatingPoint`.

<and it continues to provide a graph of the type hierarchy and advises to use a function `supertype` to explore it further>
```

PromptingTools.jl is a tool that integrates AI into your development environment intuitively and unobtrusively, enhancing productivity without disrupting your coding rhythm.

# Installation

While PromptingTools.jl is still in its infancy, you can install it with:

```julia
using Pkg; Pkg.add(url="https://github.com/svilupp/PromptingTools.jl")
```

I'll register it as soon as I have a few more features implemented.

# Next Steps

More examples and tutorials to show you what you can do! For example, you can `aiclassify`, `aiembed`, `aiextract`, and more...

Explore more about this AI-driven productivity tool at [GitHub repository](https://github.com/svilupp/PromptingTools.jl), and join us in redefining the role of AI in our daily coding journey.