@def title = "GenAI Mini-Tasks: Should I Watch this Youtube Video?"
<!-- @def published = "28 November 2023" -->
@def drafted = "28 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Use PromptingTools.jl to quickly analyze YouTube video transcripts with Generative AI, allowing you to determine in just 30 seconds whether a video is worth watching, saving time and effort.

\toc 

## Feeling Overwhelmed by Online Content? There's a GenAI Fix!

In today's digital age, keeping up with the constant stream of online content can feel like trying to drink from a firehose. So, what if I told you that you could scan a YouTube video for its key takeaways in just 30 seconds? Let's dive into how you can use Generative AI, specifically with Julia Language's `PromptingTools.jl` package, to achieve this.

## Practical Example: JuliaCon Video Analysis

Let's take a "not-so-random" video from this year's JuliaCon: [Julia-fying Your Data Team: the Ultimate Upgrade](https://www.youtube.com/watch?v=oKuaKPy-gPo&ab_channel=TheJuliaProgrammingLanguage). Perhaps, you are curious about the content but unsure if it's worth your time. Here's how you can quickly find out:

**Step 1: Download the Transcript**
   - Go to the YouTube video
   - Below the video, click on the 'more' option to expand extra information
   - Scroll to Transcript section and click 'Show Transcript'
   - Copy the transcript (you can save it to a file or a variable, depending on its size)

**Step 2: Analyze with GenAI**
   - In Julia, use `PromptingTools.jl` and run the template `:AnalystChaptersInTranscript` on your transcript
   - In moments, you'll get a detailed chapter analysis

```julia
txt = read(open("youtube-juliafying-your-data-team.txt", "r")) |> String
# See the details: aitemplates("AnalystChaptersInTranscript")
msg = aigenerate(:AnalystChaptersInTranscript; transcript=txt, instructions="None.", model="gpt4t")
```

```plaintext
[ Info: Tokens: 4082 @ Cost: \$0.0543 in 46.9 seconds
AIMessage("# Chapter 1: Introduction to Julia Adoption in Business [00:00:00]

- The speaker discusses the adoption of the Julia programming language in business settings, particularly for decision intelligence.
- A quick audience interaction reveals that many use Julia within their teams.
- The speaker introduces himself as Ian Shimo, a data head working on decision intelligence at LexisNexis and presents his wide experience across different roles where Julia could be impactful.

# Chapter 2: What is Decision Intelligence and Why Use Julia? [00:01:29]

## Section 2.1: Defining Decision Intelligence [00:01:29]

- Decision intelligence involves taking on complex business problems that require coordination across multiple disciplines and data sources, aligning closely with stakeholders, and delivering business value.
- The speaker posits that Julia is the ideal tool for decision intelligence due to its capabilities in helping users learn faster, build faster, and create better solutions for business advancement.

## Section 2.2: Learning and Building Faster with Julia [00:02:27]

- Julia enables quick learning because knowledge from one application easily transfers to others.
- The speaker highlights Julia's excellent readability, reusability, and easy look-under-the-hood features, leading to a quicker time to learn.
- Julia's power lies in its composability and its tool ecosystem, which allows seamless work across various environments.

## Section 2.3: Building Better with Julia [00:04:57]

- Julia doesn't confine the user to the limitations of available packages and allows for solving unique business problems efficiently.
- The speaker presents an example of building an insights recommender system in just 200 lines of code.
- Emphasizes that Julia helps write code that is easier to understand, less error-prone, and tailored to one's unique business needs.

# Chapter 3: Return on Investment and How to Implement Julia [00:05:53]

## Section 3.1: Assessing the Business Case for Julia [00:05:53]

- With an initial learning time investment of one to two months, Julia can potentially halve project completion times.
- Investing in Julia can thus result in significant business returns.

## Section 3.2: Strategy for Adopting Julia [00:06:19]

- For success with Julia, businesses should focus on decision intelligence work, foster a team that is curious and eager to learn, and embrace necessary shifts in mindset.
- Key mindset shifts include proper use of Julia environments, embracing Julia's methods and types, and defining problems as unitary as possible.

# Chapter 4: Lessons Learned and Conclusion [00:08:28]

- Avoid trying to convert everyone to Julia immediately and refrain from premature optimizations—focus on building first.
- The speaker encourages trying out Julia, suggesting that with its powers, businesses can blaze their own trail rather than just keeping up with the times.

# Chapter 5: Q&A and Advice for Promoting Julia Adoption [00:09:16]

- In response to a question on promoting Julia at lower positions within a company, the speaker advises showcasing Julia's strengths through practical demonstrations.
- Examples such as fast-loading Pluto notebooks can visually demonstrate Julia's advantages over competitors like Tableau.
- The approach is to showcase focused powerful applications of Julia to gain buy-in from higher-ups.")

```

For a nicer display, I would recommend using Julia Markdown `Markdown.parse(msg.content)` or just copy it to a separate window in VSCode `clipboard(msg.content)`

All this in just a few seconds! 
Yeah, this video sounds interesting, I should probably watch it! 😃

## Practical Tip: Zoom out!

GenAI isn't just about quick analysis; it's about customization.

One of the best things is that it allows you to effortlessly increase or decrease the level of detail of a summary, similar to having zoom-in and zoom-out buttons but for the amount of information!

My favorite instruction when I want to quickly scan something is to say “Make it 5 words at maximum” or "Maximum 5 words per bullet point" and run it again:

```julia
msg = aigenerate(:AnalystChaptersInTranscript; transcript=txt, instructions="Maximum 2 bullet points per section or chapter. Maximum 5 words per bullet point.", model="gpt4t")
```

```plaintext
[ Info: Tokens: 3729 @ Cost: \$0.0434 in 21.5 seconds
AIMessage("# Chapter 1: Julia Adoption in Business [00:00:00 - 00:09:18]

- Discussing Julia's advantages.
- Focused on decision intelligence.

## Section 1.1: Benefits of Julia [00:17:00 - 00:59:00]
- Enhances learning and building.
- Encourages coding flexibility.

## Section 1.2: Decision Intelligence Defined [01:29:00 - 02:05:00]
- Involves complex end-to-end problems.
- Julia suits this niche.

## Section 1.3: Learning and Composability [02:07:00 - 04:49:00]
- Julia's learning curve short.
- Composable tools increase flexibility.

## Section 1.4: Building Better with Julia [04:57:00 - 05:49:00]
- Focus on unique problems.
- Write less, achieve more.

## Section 1.5: Implementing Julia [05:56:00 - 08:25:00]
- Start with right projects.
- Team needs curiosity and bravery.

## Section 1.6: Challenges and Mindset Shifts [08:01:00 - 08:45:00]
- Utilize environments, methods, types.
- Solve smallest unit problems.

## Section 1.7: Adopting Julia at Lower-Company Levels [09:18:00]
- Present Julia's strong features.
- Showcase through practical demonstrations.")
```

Talk about a lifesaver! Now, I can jump to the specific section I need without having to watch the entire video.


## Conclusion: A Time-Saving Trick for the Digital Age
In less than a minute, you've analyzed the key messages and extracted their timestamps - that's ~10x timesaving compared to watching the entire video!

Stay tuned for more GenAI mini-task magic in upcoming posts, where we'll continue to explore practical, time-saving uses of Generative AI for everyday tasks. Happy coding and watching! 🚀📺