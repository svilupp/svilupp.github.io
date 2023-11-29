@def title = "GenAI Mini-Tasks: Oh no, I missed a meeting. What now?"
<!-- @def published = "28 November 2023" -->
@def drafted = "28 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Use GenAI and PromptingTools.jl in Julia to quickly summarize missed meetings or webinars in minutes, saving hours of catch-up time with a concise, AI-generated overview that's easy and efficient.

\toc

## Introduction

Ever found yourself in a pinch for missing a meeting or a webinar? Maybe it slipped your mind, or you skipped it to keep coding (we don't judge!). But now you're scrambling to catch up without sitting through hours of recordings. Fear not! GenAI and PromptingTools.jl are here to rescue your day.

## How to turn "oops" into "ahh"

Steps:

1. **Get the Transcript**: Most meetings and webinars have a downloadable transcript. If not, you can usually get it from Chrome Inspector. 
   - With Microsoft Stream, jump to the Chrome Inspector, open the Network tab, filter for "streamContent" and reload the video! You'll see both the flat text file (VTT) version and the JSON-formatted version
   - With Zoom, you can download the transcript directly from the Cloud Recordings tab in your browser
   - Copy & paste the transcript into a text file on your computer

2. **Clean and Chunk**: Trim out the fluff from the script. Next, break it into chunks (say, every 35000 characters for a model with 16K context window). This makes it more digestible for our AI buddy and it can work on it in parallel.

3. **Let GenAI Do Its Magic**: Send each chunk to GenAI asynchronously. Add instructions to keep the summary succinct.

4. **Merge and Marvel**: Once processed, stitch the summaries together. You can either display them directly or beautify them in Markdown format.

**And voilà!** In about a minute, you have a concise, to-the-point summary of your missed meeting. You can now jump to the crucial parts if needed.

## Example: A Video Recorded on Stream

Let's use a recording of a lightning talk for JuliaCon 2022 and save the transcript.

```julia
using Markdown # for nicer display
using PromptingTools
const PT = PromptingTools

fn = "stream_mmm.txt"
txt = read(fn) |> String
print(first(txt, 50))
```

```plaintext
WEBVTT

25649d85-10aa-4aba-87cc
00:00:32.798 --> 00:00:33.008
Well.

25649d85-10aa-4aba-87cc
00:00:33.088 --> 00:00:36.460
Come to this lightning talk
about optimizing marketing

25649d85-10aa-4aba-87cc
00:00:36.460 --> 00:00:36.828
spent.
```
We can see that the transcript is not perfect (eg, breaking the word "Welcome") and that it contains a lot of useless data (the ID 256...).

Let's load it again, but this time line-by-line skipping the lines starting with "256" (why pay the tokens for it...)
We will replace some abbreviations with `PromptingTools.replace_words` - this is a great utility if you have a list of sensitive words/names that you want to quickly scrub.

```julia
words_to_replace = ["MMM"] # this can be also useful to remove sensitive words like `["Apple, Inc.", "Samsung", "Huawei"] -> "Company"`
replacement = "Mix Media Modelling"

# Notice that we skip all the lines starting with 256...
txt = [PT.replace_words(line, words_to_replace; replacement) for line in readlines(fn) if !startswith(line, "256")] |> x -> join(x, "\n")

# We use the usual trick to make the summary more zoomed-out
msg = aigenerate(:AnalystChaptersInTranscript; transcript=txt, instructions="Maximum 3 Chapters. Each bullet point must be maximum 5 words.", model="gpt4t");
Markdown.parse(msg.content)
```

Voilà! Notice that we've used the Instructions placeholder to zoom out a bit and get a less wordy summary.

```plaintext
[ Info: Tokens: 4505 @ Cost: \$0.0524 in 26.9 seconds
AIMessage("# Chapter 1: Introduction to Marketing Optimization [00:00:32.798]

- Marketing spend optimization discussed.
- Motivational quote highlights waste.
- Issue: identifying effective ad spend.

## Section 1.1: Challenges in Optimization [00:03:44.138]

- Insufficient and unobservable data problematic.
- Underspecified problems with multiple solutions.
- Bayesian framework used for plausibility.

## Section 1.2: Benefits of Julia [00:04:43.198]

- Julia's composability advantageous for modeling.
- Contrasted with Facebook's mixed-language Robin package.

# Chapter 2: Understanding Media Mix Modeling [00:03:08.978]

- Media mix modeling quantifies marketing.
- Aims to maximize revenue from spend.
- Beware of vendors overestimating their value.

## Section 2.1: Diminishing Returns and Adstock Effect [00:06:49.948]

- Marginal ROAS and diminishing returns examined.
- Hill curve demonstrates diminishing returns effect.
- Adstock accounts for lagged advertising impact.

# Chapter 3: Implementing Optimization Example [00:05:12.618]

- Local business with three channels presented.
- Goal: maximize revenue across channels.
- Model fitted to historical revenue.

## Section 3.1: Analyzing Marketing Contributions [00:07:37.838]

- Revenue contribution by channel measured.
- Marginal ROAS quantifies spending efficiency.
- Disparity in spend versus effect opportunity.

## Section 3.2: Optimal Budget Allocation [00:09:09.038]

- Adjusts marketing spend for optimization.
- Projected benefits through budget reallocation analyzed.
- Bayesian framework contextualizes uncertainty in uplift.
- Suggests experimenting with optimized budget plan.")
```

**But wait, there's more!**

What if we wanted to use this approach with an open-source model that has only a 4K context window? Let's mimic it with the default model GPT-3 Turbo (the older version, not the latest preview 1106):
```julia
msg = aigenerate(:AnalystChaptersInTranscript; transcript=txt, instructions="Maximum 3 Chapters. Each bullet point must be maximum 5 words.")
```

We get a familiar error that the document we're sending is too large:
```plaintext
{
  "error": {
    "message": "This model's maximum context length is 4097 tokens. However, your messages resulted in 7661 tokens. Please reduce the length of the messages.",
    "type": "invalid_request_error",
    "param": "messages",
    "code": "context_length_exceeded"
  }
}
```

Let's use our chunking utility `PromptingTools.split_by_length`, which does what it says on the tin - it splits your text by spaces and ensures that each "chunk" is fewer than `max_length` characters. I tend to use rule of thumb of 2,500 characters for each 1K tokens of context (to account for the prompt and leave some space for the response). 

Let's chunk our text into two parts by splitting on `max_length=10_000` characters.
```julia

chunked_text = PT.split_by_length(txt; max_length=10_000)
# Output: 2-element Vector{String}: ...
```

Great, we can use that directly in our list comprehension to send each chunk for analysis asynchronously (I don't like waiting):

```julia
instructions = "Maximum 1-2 Chapters. Maximum 2 bullets per Chapter/Section. Each bullet point must be maximum 5 words."
tasks = [Threads.@spawn aigenerate(:AnalystChaptersInTranscript; transcript=chunk, instructions, model="gpt3t") for chunk in PT.split_by_length(txt; max_length=10_000)]

# Output 2-element Vector{Task}:
#  Task (runnable) @0x000000014abe6270
#  Task (runnable) @0x000000014abe6400
```

A few seconds later, we get the familiar INFO logs announcing that the results are ready:
```plaintext
[ Info: Tokens: 5087 @ Cost: \$0.0052 in 4.5 seconds
[ Info: Tokens: 3238 @ Cost: \$0.0034 in 6.0 seconds
```
If you want to check if the tasks are done (ie, we received all responses), you can simply run `all(istaskdone, tasks)`. If you send a lot of chunks, you might want to disable the INFO logs with `verbose=false`.

Unfortunately, now we have 2 tasks that have messages in them. We want to: convert tasks to messages with `fetch` , extract the content with `msg.content` and then concatenate the messages into a single piece of text. We can do it all as a one-liner with `mapreduce` (it executes the first function on each task and then joins them together):

```julia
mapreduce(x -> fetch(x).content * "\n", *, msgs) |> Markdown.parse
```

```plaintext
  Chapter 1: Optimizing Marketing [00:00:32 - 00:07:22]
  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

  Section 1.1: Introduction and Motivation
  ========================================

    •  Lightning talk about marketing optimization.

    •  Discusses the challenge of tracking advertising spending effectiveness.

  Section 1.2: Marketing Optimization Strategies
  ==============================================

    •  Media mix modeling for quantifying marketing benefits.

    •  Challenges include insufficient data and underspecified problems.

  Chapter 1: Model Fitting and Revenue Impact [00:07:22 - 00:09:12]
  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

  Section 1.1: Model Fitting Challenges [00:07:22 - 00:08:02]
  ===========================================================

    •  Different parameters can lead to the same curves.

    •  Fitting these models is challenging.

  Section 1.2: Revenue Impact Analysis [00:08:04 - 00:09:12]
  ==========================================================

    •  Search ads contribute almost 10% to revenues.

    •  Optimizing search ads can yield 4X revenues.
```

Perfect! It took a minute, cost less than a cent and we have our meeting summary!
Note that the Chapter numbering is misaligned as we produced each chunk separately, but that's not a big deal.

If you want to copy the text into your text editor, just replace `|> Markdown.parse` with `|> clipboard`!

## Tips for Longer Meetings

For longer meetings (>30 minutes), I would recommend to always chunk your transcript even if your AI model supports large context.
It is a well-known fact that even GPT-4 Turbo and Claude 2 struggle to utilize the full context effectively and you might miss some important parts of your meetings.

As a bonus, if you split your transcript into several chunks, they can be analyzed in parallel, which means you'll get your answers faster!

## How about privacy?

Handling a sensitive meeting? Switch to Ollama models for enhanced privacy (see previous posts). Plus, you can always scrub key entities before uploading, like this simple Julia `replace_words` code snippet.

## Why not simply use ChatGPT?

Of course, use it whenever you can! The benefits of using PromptingTools.jl are:
- The full power of Julia REPL at your disposal (eg, chunk long documents, merge answers, scrub sensitive information)
- Automate tasks, eg, "Summarize these 20 meetings and save it as a nicely formatted Markdown file or a Quarto document"
- Leverage intricate templates in PromptingTools.jl and placeholders in them (eg, just provide the transcript and we take care of the rest)

## Conclusion

With all this saved time, maybe catch another episode of your favorite show? Or dive into another Julia project? The choice is yours!