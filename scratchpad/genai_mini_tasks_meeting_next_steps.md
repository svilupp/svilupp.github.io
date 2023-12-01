@def title = "GenAI Mini-Tasks: Oops, Missed Another Meeting? Get the Agreed Next Steps in a Snap!"
<!-- @def published = "1 December 2023" -->
@def drafted = "30 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Missed a meeting? Use PromptingTools.jl in Julia to quickly extract key decisions and next steps from the meeting transcript with just a few lines of code! 🚀📝

\toc 

## Introduction

Hey there, Julia enthusiasts and multitaskers! Remember how we zoomed through video chapters in our last post? Today, we're tackling another mini-task lifesaver: extracting gold from missed meetings!

Did you miss the last Julia Machine Learning community call? No worries. Let's dig into **what was decided and the next steps** - without actually being there. Magic, right? 🌟

## Approach

A quick recap of the steps we'll take. If you're already familiar with the process, feel free to skip ahead.

**Step 1:** Grab that transcript. YouTube's got you covered. Click “More” → “Show Transcript” for the full scoop (for other platforms, see previous posts).

**Step 2:** Time for some Julia charm. We're using `PromptingTools.jl` with the nifty `AnalystDecisionsInTranscript` template. (Psst, type `aitemplates("decisions")` to peek under the hood!)

**Step 3:** Chop-chop! Our transcript is a lengthy 50K characters. GPT-3 Turbo can only chew 16K at a time, so let's split it into two.

**Step 4:** Send those chunks off asynchronously. Julia handles this like a pro - no sweat.

## Let's Code

Let's first open the file and see what we're working with:
```julia
fn = "youtube-ml-community-call-20231020.txt"
txt = read(fn) |> String
first(txt, 200) |> print
```

```plaintext
0:03
okay so uh thanks everyone for joining we have a couple ems on the agenda
0:11
today um starting with uh tracker and
0:16
chain rules integration um so Marius or yonas I don't know ich
0:24
```

And length?
```julia
length(txt) # 50K -> split into 2x 25K
```

We have almost 50K characters, so let's split it into two chunks.

```julia
tasks = [Threads.@spawn aigenerate(:AnalystDecisionsInTranscript; transcript=chunk, instructions="None.", model="gpt3t") for chunk in PT.split_by_length(txt; max_length=25_000)];

# Check if tasks are done: all(istaskdone, tasks)

# When it finishes:
# [ Info: Tokens: 7614 @ Cost: \$0.008 in 7.6 seconds
# [ Info: Tokens: 7326 @ Cost: \$0.0079 in 9.9 seconds
```

And we merge the chunks back together:

```julia
mapreduce(x -> fetch(x).content * "\n", *, tasks) |> Markdown.parse
```

```plaintext
Key Decision 1: Moving to Chain Rules for Second Order Derivatives [00:45:00]
  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

    •  The decision to switch from Tracker to Chain Rules for handling second-order derivatives was made due to encountering issues with the second order derivatives using Tracker. It
       was noted that some rules from the diff rule package were not correct.

  Next Steps for Decision 1
  =========================

    •  Define a proposal for requesting changes in chain rules to facilitate the implementation of higher-order derivatives in Tracker at [25:07:00]

    •  Explore the potential trade-offs and safety implications of the proposed changes, such as relying on proper rule writers, and discuss these findings with the team at [26:05:00]

    •  Experiment with and review the proposal of overloading the track method to maintain the entire graph, and share feedback with the team for further discussion at [30:03:00]

  Key Decision 2: Organizing Documentation Structure [36:04:00]
  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

    •  The decision to organize the ecosystem documentation structure was discussed, with a focus on the categories and subcategories that should be included in the top bar.

  Next Steps for Decision 2
  =========================

    •  Collaborate on defining the categories and subcategories to be included in the top bar, such as models, training, ecosystem, and data wrangling at [37:58:00]

    •  Share a proposal including the categories, subcategories, and the corresponding packages to gather feedback from the team at [39:02:00]

  Other Next Steps
  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

    •  Explore the ecosystem drop-down menu to include relevant packages such as mlj, flux, and sol at [39:33:00]

    •  Consider the addition of zot and in to the ecosystem drop-down menu while ensuring Flux remains ad-agnostic at [40:50:00]

<CROPPED TO SAVE SPACE>
```

Voila! In less time than brewing your coffee, you've got the meeting's crux and your to-dos. It's a bit verbose, but you can easily add some instructions to get a more concise summary (see previous posts).

## Conclusion

So, the next time you miss a meeting, don't fret. With a few clicks and some Julia wizardry, you're back in the loop. Stay tuned for more GenAI mini-task hacks! 🚀👩‍💻👨‍💻