@def title = "GenAI Mini-Task: Buy More Time by Mastering Mini-Tasks"
@def published = "21 November 2023"
@def drafted = "6 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
This blog highlights how Generative AI can be a time-saving asset for Julia programmers, offering an economical way to 'buy' time by efficiently handling everyday mini-tasks and minimizing distractions.

/toc 

## Welcome to the Future of Programming!

Hello, Julia enthusiasts! We're kicking off an exciting new blog series exploring how Generative AI, especially through PromptingTools.jl, can revolutionize your coding experience - "GenAI Mini-Tasks". Imagine turning the mundane, time-consuming tasks into a breeze. That's what we're here to uncover!

## The Magic of Mini-Tasks

Mini-tasks: those pesky, everyday chores like reformatting text, tidying up messy files, or coding a utility function for data plotting. They often trip us up, yet they are unavoidable to reach our main goals. What if we could delegate these to a smart, efficient helper?

## Why Delegate to AI?

**Economically Sensible:** Save those precious minutes for just a few cents. It's not just about saving time; it's about investing it wisely in things that actually matter.

**Cognitive Load:** Every time you pause your main task to tackle a mini-task (eg, "how do I ..."), you're draining mental energy. Generative AI steps in to take that load off your shoulders, allowing you to focus on what truly matters.

**Learn As You Go:** Engaging with AI tools is a fantastic way to understand their capabilities and limitations, fine-tuning your approach to get the best results. This will become the new way of working/interacting, so why not get ahead of the curve?

## The Hidden Cost of Switching

Did you know...

Research shows that context switching is more costly than we realize. Each interruption can set you back >20 minutes in regaining focus (I recommend reading [Attention Span](https://www.amazon.co.uk/Attention-Span-Finding-Fighting-Distraction)). It seems that once we're interrupted, we are more likely to switch to another task, and another, and another... only to come back to the original task (eg, VSCode->Chrome->Email->Slack->Teams->Email... sounds familiar?).

This is why [PromptingTools.jl](https://github.com/svilupp/PromptingTools.jl) tries to keep you in the REPL!

## Real-World Example: String Manipulation

A task that came up recently: 
- You're given a list of currency pairs in the format `"BTC/USDT"`
- You need to change the double quotes to single quotes (eg, `"BTC/USDT"` -> `'BTC/USDT'`)
- You need to flip the order of pairs (eg, `'BTC/USDT'` -> `'USDT/BTC'`)
  
This is easy in Julia, right? Yes, but it costs more time and mental energy than it seems.

Let's practice delegating mini-tasks to GenAI!
```julia
using PromptingTools

# Example data to keep example smaller
pairs = """["BTC/USDT", "ETH/USDT", "BCH/USDT", "XRP/USDT", "EOS/USDT"]"""
```

Let's use a template prompt `DetailOrientedTask` with placeholders `{{task}}` and `{{pairs}}` and split the tasks into two parts to make it easier for GenAI:

```julia
# Set temperature=0 to avoid creative responses
msg = aigenerate(:DetailOrientedTask; task="Change the double quotes to single quotes. Flip the order of currencies", data=pairs, api_kwargs=(; temperature=0))`
```

It took ~30 seconds to write the command and we get solid results back in ~1 second.
The cost is two-ten-thousands of a cent (0.0002 USD)!
```plaintext
[ Info: Tokens: 121 @ Cost: $0.0002 in 1.1 seconds
AIMessage("['USDT/BTC', 'USDT/ETH', 'USDT/BCH', 'USDT/XRP', 'USDT/EOS']")
```

I can practically hear: "But that's a toy example! I can do it manually!" 

Well, the full task was 300 pairs and it wasn't that much slower/more expensive:
```plaintext
[ Info: Tokens: 2174 @ Cost: $0.0034 in 6.1 seconds
```
So we have our results in a matter of seconds for a _fraction of a cent_.

I hear: "But this task is super easy to code in Julia!"

Assuming that something is easy is the most common mistake. I didn't think twice and started writing a list comprehension, then I realized I need to split twice, then I need to remove the square brackets, and then them back elsewhere, then I need to join, then I need to add quotes, then I need to flip the order, then I need to join again, then I need to join the list of pairs... and I keep writing and re-write code and I'm not done.

8 minutes later I was done with a Frankenstein-code that I'm not proud of:
```julia
pairs_flip = []
for pair in split(pairs, ",")
    temp = replace(pair, "\"" => "")
    currencies = split(temp, "/")
    currency1 = strip(currencies[1]) |> x -> replace(x, "[" => "", "]" => "")
    currency2 = strip(currencies[2]) |> x -> replace(x, "[" => "", "]" => "")
    push!(pairs_flip, string("'", currency1, "/", currency2, "'"))
end
pairs_flip = join(pairs_flip, ", ") |> x -> string("[", x, "]")
```

It would have been much easier to do some of the cleanup in the editor to have easier types and then use Regex substitutions to do the rest, but I didn't think about it because it was "easy". Also, I'm not that familiar with Regex substitutions, so I would have had to Google it anyway -> context switch! Lastly, this has no comment or documentation, so I would have to add that to explain what I'm doing.

**Summary:** GenAI version is easier to read, faster to produce (30s vs. 8 minutes), and costs a fraction of a cent. It's an excellent productivity boost if the value of your time is higher than \$0.03/hour (`0.0034/7.5*60 ≈ $0.03`)


## Embracing AI in Your Workflow

So, there you have it! Generative AI isn't just a tool; it's a productivity partner. Stay tuned for more insights and use cases in our upcoming posts. Dive into the world of AI-powered programming and experience the difference in your Julia projects!