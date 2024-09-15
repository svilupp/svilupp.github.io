
@def title = "AI-Assisted Coding: Why It Won't Make You 10x More Productive (Unless You Let It)"
@def published = "15 September 2024"
@def drafted = "15 September 2024"
@def tags = ["julia","generative-AI","genAI","productivity"]

## TL;DR

I've been experimenting with AI-assisted coding tools, and I've noticed something intriguing: these tools don't automatically boost productivity. My hypothesis is that to truly benefit, developers need to fundamentally change how they approach coding. It's not just about using the tools; it's about rethinking our entire development process.

\toc

## Introduction

For the past few months, I've been grappling with a question that just won't leave my mind: Are AI-assisted coding tools really making us more productive? As I've integrated tools like GitHub Copilot, Cursor, and various AI-powered code completion systems into my workflow, I've noticed something surprising. Despite the hype, I wasn't seeing the massive productivity gains I'd expected – at least, not at first.

This observation led me down a rabbit hole of experimentation and discussion with fellow developers. What I've found is both exciting and a bit unsettling. It's a hypothesis I'm still testing, but I think it's worth sharing:

AI-assisted coding tools, on their own, won't significantly boost your productivity. To reap their full benefits, you need to fundamentally change how you approach coding. Okay, except for smart text completions -- those benefits come immediately.

Now, I'm not 100% certain about this, but it's a pattern I've observed repeatedly, both in my own work and in conversations with other developers. It reminds me of something I read about the electrification of factories in the early 20th century. Initially, factory owners simply replaced steam engines with electric motors, expecting miraculous efficiency gains. But the real revolution came when they completely redesigned their factories around electricity's unique advantages. That's when productivity truly soared.

I think we might be at a similar inflection point with AI and coding. To really leverage these new tools, we might need to rethink our entire development process. Let me explain what I mean...

## The Productivity Paradox

Many developers fall into the trap of thinking that simply enabling an AI coding assistant will automatically make them more productive. They might see small gains – quicker autocomplete, fewer typos – but nothing revolutionary.

The problem is that they're still coding the same way they always have, just with a fancier autocomplete. It's like using a smartphone only to make phone calls – you're missing out on its true potential.

## The Productivity Ladder: From 1x to 10x

Based on my experiences and discussions with fellow developers, I would like to propose a "productivity ladder" that shows how we can progressively leverage AI tools for greater efficiency. Let's climb it together:

### 1. Basic AI-assisted coding (1.2x - 1.4x)

This is where most developers start. You've enabled GitHub Copilot or a similar tool, and you're getting better code completions. It's nice, but it's not game-changing.

```julia
function calculate_total(items)
    # AI suggests the following line:
    return sum(item.price*item.quantity for item in items)
end
```
That's the +20% boost.

If you're using Cursor, you might be seeing multi-line completions and TAB-jumps to navigate through them across your file. Also, it reads your edit history, so it tries to predict what you're going to do next.

This would be the +40% boost, which comes for "free" (it's worth paying for the premium version).

### 2. Function-level assistance (2x)

Now you're starting to use the AI chat to generate entire functions. This is where many developers stop, thinking they've mastered AI-assisted coding, while they copy&paste the AI-generated code into their editor and back as they run into errors.

Chat Prompt: "Write a function to validate an email address"
```julia
function validate_email(email::String)
    pattern = r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"
    return occursin(pattern, email)
end
```

### 3. Contextual code generation (3x)

Here's where things get interesting. You're not just asking for isolated functions; you're providing context from your codebase and asking the AI to generate code that fits seamlessly into your existing structure.

Your press CMD+K to generate code inside the script (or perhaps highlight the necessary lines to change).
Then you use `@` to link in any relevant functions to use as reference or examples.
Prompt: "Based on the function XYZ, connect to the database and pull the same data, except, retrieve all the rows without any aggregation"

This is good, it means you don't have to copy&paste and have much less to change to make the function fit your needs and style. You simply click to accept the changes based on a diff, and you're done.


### 4. High-level functionality requests (5x)

Now you're thinking at a higher level. Instead of asking for specific functions, you're describing functionality and letting the AI figure out the implementation details.

Press CMD+K and ask "You have to a create a new structured extraction experiment that leverages aiextract. Prepare the prompt, extraction struct, the asyncmap loop with try-catch, capture the results and evaluate the experiment."

For something like this, you must make sure there is a comparable example to work from (either linked with `@` or in the same file).

The big hack that I've learned was to make it effortless to provide all this context. 
Did you that you can speak 2-3x faster than you can type? 
Learn to use speech-to-text software! I can recommend `BetterDictation` for Mac. It will make your prompts easy to write and they will be more complete / comprehensive.

Another hack is to refactor all your frequent rules and requirements into separate files saved in your project - think of them as SOP (Standard Operating Procedure) for your codebase. It makes it easier to link them in to your context and you won't have to repeat yourself in the prompt. 

Check out `cursorrules` for Cursor - you can find many examples in the [cursor.directory](https://cursor.directory/).

I'm also working on a tiny package to make it easier to create such "cheatsheets" for any project and repository, but we can talk about that another time.

### 5. AI-first development approach (10x)

This is the holy grail, but it's not what you might expect. The key isn't just using AI as a tool; it's fundamentally rethinking your development process. Here's the counterintuitive part: you don't start with coding or even with AI prompts.

1. Begin by clearly defining your end product and work backwards. This "right-to-left" thinking helps avoid unnecessary steps. This prevents the temptation to generate unnecessary code.

2. Use AI strategically for rapid prototyping and iteration, but only after you have a clear plan. The real boost comes from skipping unnecessary code, not just coding faster.

3. Focus your energy on truly creative aspects: problem-solving, architecture design, and user experience. Let AI handle more routine tasks.

4. Master your tool's limits. Know when to make edits yourself, when to provide more context, and when to ask for high-level functionality. This mastery comes from daily refinement and careful observation.

5. Adapting this approach to existing large codebases is challenging (you often start from 1x!). You'll need to carefully consider which productivity ladder steps to use for maximum benefit, often mixing approaches based on the specific task and codebase structure.

Remember, the goal isn't to generate as much code as possible, but to create the most effective solution with the least unnecessary work. It's a delicate balance of leveraging AI capabilities while maintaining a clear vision of your end product.

## Reengineering Your Coding Process

To climb this ladder, you need to let go of old habits. It's uncomfortable at first – you might feel like you're losing control or that your coding skills will atrophy. But remember, your value as a developer isn't in writing boilerplate code; it's in your creativity, problem-solving skills, and ability to see the big picture.

Here are some tips for each level:

1. **Basic AI-assisted coding**: Start small. Get comfortable with accepting AI suggestions for simple completions.
2. **Function-level assistance**: Learn to write clear, specific prompts. The better you communicate with the AI, the better its output.
3. **Contextual code generation**: Always provide relevant context from your codebase. This helps the AI match your coding style and conventions.
4. **High-level functionality**: Practice describing functionality in plain language. Think about what you want to achieve, not how to code it.
5. **AI-first development**: Start projects with high-level outlines. Use AI to rapidly prototype, then iterate and refine.

## Measuring Progress and Setting Expectations

As you climb the productivity ladder, it's crucial to track your progress. Time yourself on common tasks and see how you improve. For example, I know that creating a new experiment with a single prompt, loop, and basic checks takes me about 20-25 minutes from scratch, or 15 minutes if I have a similar example to work from.

Be aware of potential pitfalls:
- Over-reliance on AI can lead to debugging nightmares if you don't understand the generated code. Always check the diffs before you accept them.
- AI suggestions aren't always correct or optimal. Always review and test the code (creating tests is super easy with generative models -- you just need to ask!).
- The productivity gains aren't linear. You'll have breakthroughs and plateaus.

## Conclusion

AI coding tools are not magic wands that automatically make you a 10x developer. They're more like power tools – incredibly useful, but only in the hands of someone who knows how to wield them effectively.

The future of coding isn't about AI replacing developers; it's about developers who can effectively collaborate with AI to solve complex problems faster and more creatively than ever before.