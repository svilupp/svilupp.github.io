@def title = "AIHelpMe.jl: AI-Enhanced Coding Assistance for Julia"
@def published = "23 January 2024"
@def drafted = "23 January 2024"
@def tags = ["julia","generative-AI","genAI"]

# TL;DR
[AIHelpMe.jl](https://github.com/svilupp/AIHelpMe.jl), a new Julia package, transforms your existing docstrings into an interactive AI-powered guide, offering personalized insights directly from your code's documentation. It's in the early stages and seeks community feedback, promising a unique, low-cost way to interact with your documentation.

\toc 

## Announcing AIHelpMe.jl Pre-Release

Welcome to [AIHelpMe.jl](https://github.com/svilupp/AIHelpMe.jl), a new Julia package that transforms your detailed docstrings into a rich source of insights. It's not about writing code for you; rather, it's about shining a light on the valuable documentation you and others have already created. Think of it as having a chat with your code's documentation, enhanced by AI's clever touch.

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

aihelp"In Julia, how to create a named tuple from a dictionary? Give me an example"gpt3t
```

````plaintext
[ Info: Done generating response. Total cost: \$0.001
AIMessage("You can use the splatting operator to create a named tuple from a dictionary in Julia. Here's an example:

```julia
d = Dict(:a => 1, :b => 2)
nt = (; d...)
```
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

   <Author: this example is incorrect. See the below note>

These constructors allow for flexibility in creating `NamedTuple`s programmatically or from existing data structures in Julia.")
````

## LLMs will make mistakes...
... and it's okay! It's usually easy to check & iterate, so the overall solution still ends up being faster / easier.

The original example used the default chat model and had a mistake as pointed out by @oxinabox. We changed to "gpt3t" model for better performance. There was also a change in the prefix and suffix, but that was not required - it's just a habit of how I write prompts/questions to LLMs.

Similarly, the last constructor in the examples from GPT4 Turbo throws an error. We can ask the LLM to fix it:
```julia
aihelp"How to fix `nt = NamedTuple((:c => 3, :d => 4, existing_nt...))`. I get error $err"gpt4t
```

````plaintext
[ Info: Done generating response. Total cost: \$0.002
AIMessage("You can fix the code snippet by using the `merge` function properly, to merge the `NamedTuple` with the key-value pairs:

```julia
existing_nt = (a=1, b=2)
nt = merge(existing_nt, (c=3,), (d=4,))
```

This code merges the existing named tuple `existing_nt` with two additional key-value pairs, `(c=3,)` and `(d=4,)`. The result `nt` will be a named tuple including all four key-value pairs.")
````

## Pre-Release Testing
As AIHelpMe is in its early stages, we're eager for community involvement to test and refine its capabilities. 

Is it valuable? What are its limitations?

Your feedback is invaluable in shaping this tool’s future, so join us in this innovative journey!

EDIT: Thanks to @oxinabox for pointing out that the original example had an error in it!