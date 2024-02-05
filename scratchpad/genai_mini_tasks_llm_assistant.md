@def title = "The Quest for Ultimate Productivity: Building an LLM-Powered Assistant"
@def published = "5 February 2024"
@def drafted = "5 February 2024"
@def tags = ["julia","generative-AI","genAI","assistant"]

# TL;DR
A quick preview of my journey in developing a proof of concept for a personalized LLM-powered assistant, aiming to streamline daily productivity tasks. You can do the same!

\toc 

## Introduction

Hello, fellow productivity enthusiasts! 🌟 Ever find yourself drowning in a sea of tasks, with your desk looking more like a paper warehouse and your inbox resembling a bottomless pit? Yeah, me too. It’s the 21st-century dilemma: so much to do, yet so little time. 🕰️

Over the years, I've devoured productivity books and experimented with every app under the sun, from GTD to Timeboxing, and from Wunderlist to Motion. Despite my efforts, something always felt off. 📚✖️

One day I saw a [tweet](https://x.com/MilesCranmer/status/1738222999063650474?s=20) from Miles Cranmer about his Notion&Langchain project.
That's when a lightbulb went off 💡: what I need is a super "narrow" LLM-powered assistant, fine-tuned just for me! Imagine an assistant that knows only 2-3 tasks but executes them with unparalleled precision, because it knows you! 

## 🛠️ Building the Dream Assistant

In the past, I encountered a few key challenges, so I wanted to address them head-on:

1. **Ease of Use**: Annotating tasks felt like a chore. Who has 5 minutes to fill out a task form? 🤷 My goal was to enable the assistant to understand tasks from just a simple sentence, removing the need for detailed input.

2. **Fresh Starts**: I ditched rolling over unfinished tasks to keep each day's slate clean, focusing solely on the present day's priorities. That was the failure point of auto-scheduling in Motion - at some point, the conflict backlog explodes.

3. **Realistic Boundaries**: To counteract my tendency to stretch myself too thin, the assistant now evaluates my daily capacity, scheduling only when there is space left and ensuring I set achievable goals by warning me against overloading my schedule. The duration estimation is out of my hands, hopefully, improving the quality of the estimates.

Integrating these improvements, the assistant now supports a streamlined approach to productivity, focusing on what tasks are essential, when they'll be tackled, and maintaining realism in daily planning. This refined tool is all about enhancing daily productivity without the overhead, starting each day anew, and keeping ambitions in check.

## 🤖 Integration and Automation

Connecting Notion was a no-brainer since my to-do list resides in Notion, making for a seamless transition. Now with their Calendar app, it's even stronger proposition. I rolled up my sleeves and crafted quick macros: `@tadd` for adding tasks (because who doesn’t love a good abbreviation?) and `@cadd` for calendar additions (tasks meant to be auto-scheduled). It was like giving my assistant its own language. 🗣️💬

Here’s a sneak peek of how it works: 
```julia
## Call out the tasks to schedule for today:
@cadd "Hack up POC for GolemScheduler.jl"
@cadd "LLMTextAnalysis.jl: add a warning if the provided strings are empty or if length is >10K"
@cadd "Ping James about the progress"
@cadd "Analyze the data for project XYZ"

## [ Info: Processing task...
## [ Info: Tokens: 1282 @ Cost: \$0.0159 in 17.4 seconds
## [ Info: Scheduling task
## [ Info: Scheduled for 2024-02-05T08:00:00 - 2024-02-05T10:00:00
## CreatedPage @ https://www.notion.so/Develop-Proof-of-Concept-for-GolemScheduler-jl-732e8e0b0f4e4b0aa7d07ae3911f99fd

## [ Info: Processing task...
## [ Info: Tokens: 1274 @ Cost: \$0.0154 in 11.8 seconds
## [ Info: Scheduling task
## [ Info: Scheduled for 2024-02-05T10:00:00 - 2024-02-05T11:00:00
## CreatedPage @ https://www.notion.so/Add-warning-functionality-to-LLMTextAnalysis-jl-0e9ebf4a13234424a247fac1256d4285

## [ Info: Processing task...
## [ Info: Tokens: 1207 @ Cost: \$0.0138 in 8.5 seconds
## [ Info: Scheduling task
## [ Info: Scheduled for 2024-02-05T11:00:00 - 2024-02-05T11:15:00
## CreatedPage @ https://www.notion.so/Ping-James-about-the-progress-00f9acf18e014eca89ca40d136c81a43

## [ Info: Processing task...
## [ Info: Tokens: 1221 @ Cost: \$0.0141 in 7.7 seconds
## [ Info: Scheduling task
## ┌ Warning: No available slot found. `overflow` will be set to `true`.
## └ @ Main ~/Documents/Julia-training-range/prompting-tools-research/golem_scheduler/api_services.jl:181
## CreatedPage @ https://www.notion.so/Analyze-the-data-for-project-XYZ-2e8f182d7c454f38a02c53b330b08367
```

Here is a snapshot of my day in Notion:
![A Notion screenshot of my day](/assets/genai_mini_tasks_llm_assistant_pt1/notion_snapshot.png)

## 📅 When Plans Overflow

As you can see, it happened again - I was too ambitious and the last task simply didn't fit in the allocated time.

So my assistant nudged me with: “Warning: No available slot found. `overflow` will be set to `true`.” This is my cue to hop into Notion and play Tetris with my tasks, filtering on “overflow=true.” 🚫📆

You can see that it automatically slots in the corresponding section on My Day in Notion.

The best part? All of the links next to "CreatedPage" are clickable, taking me directly to the task in Notion if I want to quickly edit anything. It’s like having a personal assistant who knows exactly what I need, when I need it. 🤖👩‍💼

## Wrapping Up

So, there you have it—a glimpse into my journey of building a personalized LLM-powered assistant. It’s still early days, but the potential to revolutionize personal productivity is immense.

Are you intrigued by the idea of crafting your own productivity sidekick? Or perhaps you’re just here for the techy talk and tales of trial and error. Either way, I’d love to hear your thoughts! 🗨️💭

If there’s enough interest, I might just package this up and share it with the world. Until then, let’s keep pushing the boundaries of what’s possible, one task at a time. 🚀

---

Remember, the journey to productivity is as much about the tools we use as it is about the mindset we cultivate. Stay curious, stay inventive, and most importantly, stay productive! 🌈✨