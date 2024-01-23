@def title = "AIHelpMe: AI-Enhanced Coding Assistance for Julia"
@def published = "23 January 2024"
@def drafted = "23 January 2024"
@def tags = ["julia","generative-AI","genAI"]

# TL;DR
[AIHelpMe](https://github.com/svilupp/AIHelpMe.jl), a new Julia package, transforms your existing docstrings into an interactive AI-powered guide, offering personalized insights directly from your code's documentation. It's in the early stages and seeks community feedback, promising a unique, low-cost way to interact with your documentation.

\toc 

## Announcing AIHelpMe Pre-Release

Welcome to [AIHelpMe](https://github.com/svilupp/AIHelpMe.jl), a new Julia package that transforms your detailed docstrings into a rich source of insights. It's not about writing code for you; rather, it's about shining a light on the valuable documentation you and others have already created. Think of it as having a chat with your code's documentation, enhanced by AI's clever touch.

## Motivation and Value
Why write great docstrings? AIHelpMe gives you a compelling reason, turning them into an interactive, insightful guide. It's a subtle, yet powerful way to connect your queries with tailored, documentation-driven answers.

There are a few things that set this package apart from generic chatbots:

**Direct Access to Your Work**: AIHelpMe uniquely utilizes the latest information and modules directly from your laptop, ensuring up-to-date and relevant assistance.

**Full Control Over Searches**: Tailor your search scope and methods with AIHelpMe, aligning AI insights precisely with your needs.

**Contextual Understanding**: Go beyond typical chatbot responses; AIHelpMe offers deep insights, revealing the sources behind each answer, so you can continue your research 🧠📚

## Getting Started
Simply add AIHelpMe to your Julia environment (not registered yet) and get ready to interact with your code's documentation in a whole new way. Remember, API keys from Cohere and OpenAI are required, but the cost per query is just a tiny fraction of a cent.

```julia
using Pkg
Pkg.add("https://github.com/svilupp/AIHelpMe.jl")

using AIHelpMe # automatically some downloads pre-processed documentation

aihelp"How to create a named tuple from a dictionary?"
```

````plaintext
[ Info: Done generating response. Total cost: \$0.001
AIMessage("To create a named tuple from a dictionary, you can use the `NamedTuple` constructor and provide the dictionary's key-value pairs as arguments using the `name=value` syntax. Here's an example:

```julia
d = Dict("a" => 1, "b" => 2)
nt = NamedTuple(d)
```

In this example, the dictionary `d` is converted into a named tuple `nt` using the `NamedTuple` constructor. Each key-value pair in the dictionary becomes a named field in the named tuple.")
````

You can also ask GPT-4 Turbo to weigh in on your question (notice the "!" in `aihelp!"..."`) when you need deeper insights. For example, you can ask GPT-4 Turbo to explain the constructors for `NamedTuple`:

```julia
aihelp!"What other constructors does NamedTuple have?"gpt4t
```

````plaintext
[ Info: Tokens: 1023 @ Cost: \$0.0154 in 30.7 seconds
AIMessage("Aside from creating named tuples from pairs or a dictionary, `NamedTuple` offers other constructors as well:

1. **Tuple literal with keys**:
   ```julia
   nt = (a=1, b=2)
   ```

2. **Tuple literal with semicolon**:
   ```julia
   nt = (; a=1, b=2)
   ```

3. **Using `NamedTuple` type as constructor**:
   ```julia
   nt = NamedTuple{(:a, :b)}((1, 2))
   ```

4. **With specified types**:
   ```julia
   nt = NamedTuple{(:a, :b), Tuple{Int, Int}}((1, 2))
   ```

5. **From another named tuple or iterable**:
   You can create a new named tuple by splatting an existing named tuple or any iterable of pairs:
   ```julia
   existing_nt = (a=1, b=2)
   nt = NamedTuple((:c => 3, :d => 4, existing_nt...))
   ```

These constructors allow for flexibility in creating `NamedTuple`s programmatically or from existing data structures in Julia.")
````


## Pre-Release Testing
As AIHelpMe is in its early stages, we're eager for community involvement to test and refine its capabilities. 

Is it valuable? What are its limitations?

Your feedback is invaluable in shaping this tool’s future, so join us in this innovative journey!