@def title = "AIHelpMe.jl Pt.2: Instant Expertise, Infinite Solutions for Julia Developers"
@def published = "30 April 2024"
@def drafted = "30 April 2024"
@def tags = ["julia","generative-AI","genAI"]

# TL;DR
[AIHelpMe.jl](https://github.com/svilupp/AIHelpMe.jl) is a Julia package that harnesses the power of AI models to provide tailored coding guidance, integrating seamlessly with PromptingTools.jl to offer a unique approach to answering coding queries directly in Julia's environment.

\toc 

## The Frustration of Searching for Julia Answers

We've all been there. You're stuck on a problem, and you need some guidance on how to implement a specific functionality in Julia. You head to your trusty search engine, type in your query, and... wait, why are all these results in Python? You tweak your query, adding "Julia" this and "Julia language" that, but still, the results are scattered and unclear.

After 5 minutes of searching, you finally stumble upon a Discourse post from 2018. But wait, is this even relevant to Julia 1.0? Should you bother opening it? You take a deep breath and dive in, hoping that the answer lies within.

Another 5 minutes pass, and you finally find what you're looking for. You copy out the necessary snippet, and after a few more minutes of customizing it to your needs, you have what you needed. The process is tedious, to say the least.

## Introduction to AIHelpMe's Official Release

AIHelpMe, a Julia package designed to enhance coding assistance with AI, has been officially registered and released. This milestone makes it easier to install directly from the Julia registry and introduces new functionalities and new knowledge packs! Now, developers can access sophisticated, AI-powered coding guidance more efficiently than ever.

## How AIHelpMe Works

AIHelpMe uses a Retrieval Augment Generation (RAG) pattern to provide accurate and relevant answers to your coding questions. It preprocesses the provided documentation, converting text snippets into numerical embeddings. When you ask a question, AIHelpMe looks up the most relevant documentation snippets, feeds them into the AI model, and generates an answer tailored to Julia's ecosystem and best practices.

Get started with:
```julia
using Pkg
Pkg.add("AIHelpMe")
using AIHelpMe
aihelp"How do I implement quicksort in Julia?"
```

Note: It requires at least the OpenAI API key (`ENV["OPENAI_API_KEY"]`), but I would strongly recommend getting a FREE Cohere API key for re-ranking (silver pipeline).

## How AIHelpMe Differs from Other Solutions

Compared to chatbots, AIHelpMe offers several advantages:

* **Grounded in actual resources**: AIHelpMe's answers are based on actual, up-to-date Julia resources, not outdated training data.
* **Customizable knowledge**: You choose what knowledge to include, allowing you to improve precision and recall.
* **Flexible trade-offs**: You choose the trade-off between cost, performance, and time, giving you greater control over your coding experience.
* **State-of-the-art RAG methods**: AIHelpMe leverages the latest RAG methods, and full customization is possible, ensuring that you get the most accurate and relevant answers.

Note: Only a limited number of packages have been pre-processed so far: Julia docs, Tidier ecosystem, and Makie ecosystem. It's still experimental, but it works! Load them with:

## Starter Example

```julia
using AIHelpMe
using AIHelpMe: pprint, last_result

# ideally, switch to better pipeline for proper results, requires setting up Cohere API key
AIHelpMe.update_pipeline!(:silver)

# load tidier index, others available: :julia, :makie
AIHelpMe.load_index!(:tidier);

# Ask a question
aihelp"How do you add a regression line to a plot in TidierPlots?"
```
![Quick answer over Tidier docs](/assets/aihelpme_reannouncement/tidier1.png)

Or show the highlighted answer (you can customize to add the actual source docs, or remove the scores/highlights):
```julia
# See highlighted answer (optional)
pprint(last_result())
```
![Highlighted answer over Tidier docs](/assets/aihelpme_reannouncement/tidier2.png)

If you're an infrequent user of AlgebraOfGraphics like me, you'll certainly appreciate the `:makie` knowledge pack -- it's much faster now to find the right keywords to customize your plot!

```julia
# Load all knowledge packs
AIHelpMe.load_index!([:julia,:makie,:tidier]);
aihelp"How to set the label of a y-axis in Makie?"gpt3t # testing a weak model
pprint(last_result())
```
![Highlighted answer over Makie docs](/assets/aihelpme_reannouncement/makie2.png)

Note: There can still be some issues with the quality of the answers (it's GenAI!), especially for the bronze pipeline and weaker models, but, hopefully, it's already good enough to create value for you!

## Advanced Usage of AIHelpMe

AIHelpMe offers several advanced features for experienced users wanting more control and deeper insights:

**Response Insights:**
- Use `pprint` to highlight potential hallucinations, show sources, their scores, and context snippets.
- Example: `aihelp("Explain Julia's multiple dispatch system", return_all=true)|>AIHelpMe.pprint`

Note: You'll always get better responses with better pipelines - see below.

**Customizing the AI Pipeline:**
- Adjust the complexity of AI responses with `update_pipeline!` choosing from bronze, silver, or gold levels.
- Specify AI models, including local options like Ollama.
- Example: `AIHelpMe.update_pipeline!(:silver; model="gllama370")` # gllama370 is Groq.com-hosted Llama 3 70b that you can access for free!

**Safe Code Execution:**
- Execute AI-generated code safely with `PromptingTools.AICode` struct.
- Example: `aihelp("How to create a named tuple from a dictionary?")|>PromptingTools.AICode` 

For more details on these advanced features, please refer to the [AIHelpMe Advanced Documentation](https://svilupp.github.io/svilupp.github.io/AIHelpMe.jl/dev/advanced).


## What's Next

Over the summer, we hope to optimize the performance (in terms of quality) and add more knowledge packs. 

We're also working on making it super easy for you to develop your own knowledge packs for the packages you use, regardless of whether they're public or private. This will enable you to tailor AIHelpMe to your specific needs and workflow.


## Conclusion

AIHelpMe is the solution to your Julia coding woes. With its AI-powered assistance, flexible querying system, and cost-effective approach, AIHelpMe is poised to revolutionize the way you code in Julia. Try it out today and experience the future of coding assistance!