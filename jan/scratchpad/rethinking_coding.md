@def title = "AI-Assisted Coding: Why It Won't Make You 10x More Productive (Unless You Let It)"
@def published = "15 September 2024"
@def drafted = "15 September 2024"
@def tags = ["julia","generative-AI","genAI","productivity"]

# TL;DR

AI-assisted coding tools don't automatically boost productivity. To truly benefit, developers need to fundamentally change how they approach coding. It's not just about using the tools; it's about rethinking our entire development process.
Key hacks: Use voice dictation for prompts, don't use chat, create SOPs (Standard Operating Procedures) for your codebase, improve documentation, and keep pushing the limits of what works.

\toc

# Introduction

For the past 1.5 years, I've been using AI-assisted coding tools, and for many months, I've been exploring their impact on my own productivity. Despite the claims everywhere, I wasn't seeing the massive gains I'd expected – at least, not consistently. This led me to a surprising hypothesis:

**AI-assisted coding tools, on their own, won't significantly boost your productivity. To reap their full benefits, you need to fundamentally change how you approach coding.**

This reminds me of the electrification of factories in the early 20th century. Real productivity gains came not from simply replacing steam engines with electric motors, but from completely redesigning factories around electricity's unique advantages.

We might be at a similar inflection point with AI and coding. Let's explore how we can climb the AI-assisted coding productivity ladder.

## The Productivity Ladder: From 1x to 10x

Before we dive into each step, here's an overview of the productivity ladder:

1. Basic AI-assisted coding (1.2x - 1.4x)
2. Function-level assistance (2x)
3. Contextual code generation (3x)
4. High-level functionality requests (5x)
5. AI-first development approach (10x?)

![Productivity Ladder](/assets/rethinking_coding/productivity-ladder-infographic.svg)

Now, let's climb it together:

## 1. Basic AI-assisted coding (1.2x - 1.4x)

This is where most developers start. You've enabled GitHub Copilot or a similar tool, and you're getting better code completions. It's nice, but it's not game-changing.

Example:
```julia
function calculate_total(items)
    # AI suggests the following line:
    return sum(item.price * item.quantity for item in items)
end
```

That's the +20% boost.

If you're using Cursor, you might be seeing multi-line completions and TAB-jumps to navigate through them across your file. Also, it reads your edit history, so it tries to predict what you're going to do next.

This would be the +40% boost, which comes for "free" (it's worth paying for the premium version).

## 2. Function-level assistance (2x)

Now you're starting to use the AI chat to generate entire functions. This is where many developers stop, thinking they've mastered AI-assisted coding.

Example:
Chat Prompt: "Write a function to validate an email address"
And you get this which you need to copy & paste back into your editor (praying that it runs).

```julia
function validate_email(email::String)
    pattern = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"
    return occursin(pattern, email)
end
```

**Key Tricks**: Ask for functions not code lines

## 3. Contextual code generation (3x)

Here's where things get interesting. You're not just asking for isolated functions; you're providing context from your codebase and asking the AI to generate code that fits seamlessly into your existing structure.

Example:
You press CMD+K to generate code inside the script (or perhaps highlight the necessary lines to change).
Then you use `@` to link in any relevant functions to use as reference or examples.
Prompt: "Based on the function XYZ, connect to the database and pull the same data, except, retrieve all the rows without any aggregation"

This is good, it means you don't have to copy&paste and have much less to change to make the function fit your needs and style. You simply click to accept the changes based on a diff, and you're done.

**Key tricks**: Use In-editor generation, Add more context to the prompt (examples from elsewhere in the codebase are great)

## 4. High-level functionality requests (5x)

At this level, you're thinking at a higher level. Instead of asking for specific functions, you're describing functionality and letting the AI figure out the implementation details.

This level can feel weird and scary at first, but with practice, you'll figure out how to describe the functional blocks you need effectively.

Example: 
Press CMD+K and ask "Create a new structured extraction experiment that leverages aiextract. Prepare the prompt, extraction struct, the asyncmap loop with try-catch, capture the results and evaluate the experiment."

This will not work if you take it too far.

**Key Tricks**:

- **Use voice-to-text software**: Did you know that you can speak 2-3x faster than you can type? I recommend `BetterDictation` for Mac. It makes your prompts easier to write and they will be more complete / comprehensive.
- **Use `cursorrules` for Cursor**: If you use Cursor, bootstrap your main rules (style, logic, packages to use, etc.) with many examples from the [cursor.directory](https://cursor.directory/). If you're using Github Copilot, you can use something similar to `cursorrules` from the [version 1.93](https://code.visualstudio.com/updates/v1_93#_code-generation-instructions)!
- **Refactor frequent instructions into separate files**: Think of them as Standard Operating Procedures (SOPs) for your codebase. It makes it easier to link them into your context and you won't have to repeat yourself in the prompt. 

## 5. AI-first development approach (10x?)

Short answer is that I don't know! If you do know, please reach out.

I sometimes feel like I hit 100x on a new hobby project, but then it quickly plateaus. On large and complex projects, I'm getting 2-3x at best on average. So, how do we keep the 10x, especially for large codebases?

I suspect the answer is that we **don't have the perfect tool for it yet**. New projects are so easy because there are no styles/patterns/abstractions to match, and LLMs can figure out all the defaults for us. Maybe the missing tool is something about finding the **perfect context** and an agentic loop that can **make more than one step** on its own?

While we wait for that perfect tool, here's what I've noticed works well to keep the speed up:
- **Master your AI tool's limits**: Every day, I keep trying to push myself to find out what reliably works and what's too much to ask. It's a great practice because the tools are literally changing day to day (keep trying the new features).
- **Be better at communication**: Obsessively write documentation and explain everything in comments; it will help you but it will also help the LLM.
- **Don't give in to the lure of easy code writing**: I lost so much time on generating code and variations I didn't need. **Ruthless prioritization** was an effective strategy in the old coding world, it **is still important**!

Are we fully in the AI-first development process yet? Not quite. We see glimpses of it with Cursor Composer mode, but it still has too many sharp edges. Tools like Devin and other auto-agents are a step too far. We need something in between that's more autonomous than Composer if it's confident about next steps.

## Conclusion

AI coding tools are not magic wands that automatically make you a 10x developer. They're more like power tools – incredibly useful, but only in the hands of someone who knows how to wield them effectively.

The future of coding isn't about AI replacing developers; it's about developers who can effectively collaborate with AI to solve complex problems faster and more creatively than ever before. As we continue to refine our AI-first development processes, we'll likely see even greater productivity gains, but it will require ongoing adaptation and a willingness to rethink our entire approach to coding.