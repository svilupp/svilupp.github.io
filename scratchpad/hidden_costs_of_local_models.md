@def title = "The Hidden Cost of Locally-Hosted Models: A Case Study"
@def published = "20 April 2024"
@def drafted = "20 April 2024"
@def tags = ["julia","generative-AI","genAI"]

# TL;DR

\toc

## Would You Pay a Dollar to Buy 3 Extra Days This Year?

Imagine you could buy time. Not in a metaphorical sense, but literally reclaim hours of your life lost to waiting. For those of us using locally-hosted models for ad-hoc productivity tasks like coding assistance, this isn't just a daydream—it's a decision we face every day.

## Appreciating the Open-Source AI Ecosystem

First, let's give credit where it's due. The thriving open-source ecosystem in generative AI deserves a massive shoutout. Organizations like Meta and Mistral have opened up their models, and platforms like Ollama and Llama.cpp have made these tools accessible for local use. This democratization of technology is nothing short of revolutionary. However, it's crucial to discuss the true cost of operating these technologies locally (by individuals, for ad-hoc tasks).

## The Hidden Costs of Local Hosting

While the price tag on locally-hosted models might read "free," the reality is anything but. These models often underperform compared to their cloud-hosted counterparts (GPU-poor) or make you wait longer—sometimes both. For example, using a locally-hosted model like Mixtral on Ollama, you might wait 20 seconds for a response that a commercial provider like Groq, Together, etc. could deliver in less than a second.

### Case Study: Daily Coding Assistance

Let's break it down with a simple case study. Assume you're a developer making three LLM calls per hour during a three-hour coding session, each day for 250 days a year. That's 2250 LLM calls.

With Ollama, a 20-second wait per call accumulates to over 12 hours spent just waiting annually. 

In contrast, using Groq's API, even with an extremely conservative 3-second wait (Llama 3 70b, which is GPT-4 level model), you'd spend less than 2 hours waiting over the same period.

The difference? **More than 10 hours** saved—or, put another way, over 3 extra days of productive coding time each year. 

And the cost of this extra time? Right now - FREE! Assuming the announced pricing, **about \$1.5**.

Moreover, with Groq, we assumed using GPT-4 level model! So you would likely benefit even more from MUCH better answers!

## Why Choose Cloud Providers?

Given **you have roughly 4,000 weeks on this earth**, spending any of them waiting on your GPU seems like a poor use of time. In a way, time is the scarcest resource yet you throw it away to save fractions of cents.

Furthermore, you might lose out on innovations. Cloud providers continually upgrade their services with faster and more powerful models without requiring any effort on your part. Meanwhile, changing your local setup is a significant investment and it has its limits (VRAM...).

## How to Start?

Switching is simple:
1. Sign up for the [Groq API](https://console.groq.com/keys).
2. Set up your environment variable `GROQ_API_KEY`.
3. Use PromptingTools.jl with a Groq-hosted Llama3 70b, which I aliased with "gl70" (Groq Llama 70). This alias helps save time even when typing!

### Example Usage

```julia
using PromptingTools
# Assumes you have set the environment variable GROQ_API_KEY

ai"In Julia, write a function `clean_names` that cleans up column names of a DataFrame"gl70
```

```plaintext
[ Info: Tokens: 411 @ Cost: \$0.0003 in 2.7 seconds
AIMessage("Here is a Julia function `clean_names` that cleans up column names of a DataFrame:
````julia
using DataFrames
<...continues>
````
```

This simple setup can drastically cut down your waiting time, freeing up days for you to spend on more fulfilling activities or further innovation.

If you're familiar with the [PromptingTools.jl](https://github.com/svilupp/PromptingTools.jl) package, you know you can even set up an auto-fixing loop that will execute the generated code, analyze the error for feedback and retry automatically to fix any errors with Monte Carlo Tree Search (see `?airetry!` for more details).

```julia
using PromptingTools.Experimental.AgentTools: AIGenerate, run!, AICode
using PromptingTools.Experimental.AgentTools: airetry!, aicodefixer_feedback

result = AIGenerate(
    "In Julia, write a function `clean_names` that cleans up column names of a DataFrame";
    model = "gl70") |> run!
aicodefixer_feedback
success_func(aicall) = AICode(aicall) |> isvalid
feedback_func(aicall) = aicodefixer_feedback(aicall.conversation).feedback
airetry!(success_func, result, feedback_func; max_retries = 3)
```


## In Conclusion

While the allure of "free" local hosting is strong, the hidden costs in time can be substantial. By opting for a commercial solution like Groq's API, not only do you reclaim time lost to waiting, but you also benefit from superior model performance. The investment is minimal compared to the time you buy back—time that could be spent innovating, creating, or just enjoying life. Isn't that worth considering?

If you're looking to try, do it now while Groq is free!!