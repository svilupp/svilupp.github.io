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

2. **Clean and Chunk**: Trim out the fluff from the script. Next, break it into chunks (say, every 40000 characters) separated by double newlines. This makes it more digestible for our AI buddy.

3. **Let GenAI Do Its Magic**: Send each chunk to GenAI asynchronously. No need for complex instructions yet.

4. **Merge and Marvel**: Once processed, stitch the summaries together. You can either display them directly or beautify them in Markdown format.

**And voilà!** In about a minute, you have a concise, to-the-point summary of your missed meeting. You can now jump to the crucial parts if needed.

TODO: Add example

TODO: Add a note that we didn't have to chunk data for with this video, but in practice it's needed

**But wait, there's more!**

For an even quicker scan, ask GenAI to limit each point to 5-7 words. It's like getting the 'trailer' of your meeting - quick, crisp, and clear.

TODO: Add example for shorter summary

TODO: Add example for long transcripts

**The best part?** This entire process takes less than 2 minutes and costs mere pennies, saving you a whopping 1.5 hours! That's a 45x benefit!

**Privacy Concern? No Problem!**

Handling a sensitive meeting? Switch to Ollama models for enhanced privacy (see previous posts). Plus, you can always scrub key entities before uploading, like this simple Julia `replace_words` code snippet.

## Conclusion

With all this saved time, maybe catch another episode of your favorite show? Or dive into another Julia project? The choice is yours!