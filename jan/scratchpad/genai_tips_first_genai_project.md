@def title = "Navigating Your First GenAI Project: A Blueprint for Success"
@def published = "13 February 2024"
@def drafted = "13 February 2024"
@def tags = ["julia","generative-AI","genAI"]

# TL;DR
Embarking on your first Generative AI project can be daunting. Avoid common pitfalls by following these five practical tips: 1) Start simple and build iteratively, 2) Start from the end, 3) Use the best model available and manage costs wisely, 4) Start with a commercial API, and 5) Prepare your "vibe" check. Each tip is designed to streamline your project’s development, ensuring efficiency and effectiveness from inception to execution.

\toc 

## Introduction
I've observed numerous individuals repeating the same errors in their projects, so I hope the guidance provided here will help you avoid these common pitfalls and steer your project toward success.

## 1. Start Simple and Build Iteratively

**Key Idea**: Break your grand vision into manageable, discrete tasks. 

**Practical Application**: If designing an AI to generate news articles, start by focusing on creating compelling headlines. Once mastered, expand to introductory paragraphs, and so forth. This step-by-step approach mitigates risk and builds towards complexity gradually. 

If there are multiple GenAI steps, start with just one. Why? If each of the three consecutive steps has a 70% chance of success, the overall probability of succeeding at all three drops to around 1 in 3 - that's not a good starting point! So go step by step.

## 2. Start from the End

**Key Idea**: Visualize each step's inputs and outputs to guide development.

**Practical Application**: For an AI-powered fitness app, sketch out the final user interaction—say, providing personalized workout plans based on user input (e.g., available equipment, fitness level). Create an example of one conversation, or one input & output set and start by getting that to work.

## 3. Use the Best Model Available and Manage Costs Wisely

**Key Idea**: Opt for the highest quality AI model to test your project's potential, but be smart about data usage to keep costs in check.

**Practical Application**: Using GPT-4 Turbo might reveal that your idea is feasible, whereas starting with a smaller model could lead to unnecessary troubleshooting, blaming the idea's failure on the model's limitations. If you're worried about costs, start with a small dataset and see what you can learn from it.

People often overestimate how much the best models cost. For example, the blog post I wrote about analyzing themes in the City of Austin survey had c. 3000 verbatims (~400K characters) and embedding ALL of them cost ~$0.002! Generating the topics with GPT4Turbo cost less than half a cent!

## 4. Start with a Commercial API

**Key Idea**: Commercial APIs save time and offer efficiency, outweighing the cost.

**Practical Application**: Using OpenAI instead of Ollama might be cheaper and much faster!

- Consider the **hidden cost of locally hosted models**: Let's say you're choosing between Ollama Mixtral, which takes 30 seconds, and GPT-3.5 Turbo, which takes 2 seconds, for a task, the latter often provides better results. If you value your time at $20 an hour, using Ollama Mixtral, despite being free, effectively costs you 15 cents due to the longer duration, compared to the negligible 0.5 cents for GPT-3.5 Turbo's quicker completion.
- **Minimize your experiment cycle time**: The duration to test a new idea or modification, known as "experiment cycle time," is crucial. Opting for a commercial API justifies its cost by enabling the parallelization of tasks—what might take one GPU with Ollama Mixtral a considerable time to process can be done almost instantaneously with commercial APIs. For instance, you could execute 100 calls in the time it takes Ollama to complete just one, significantly accelerating development and reducing the effective cost of your time even further.


## 5. Prepare Your "Vibe" Check

**Key Idea**: Establish a mini benchmark for your project's core functionality and continuously assess progress against it.

**Practical Application**: Identify 2-3 key input-output pairs that encapsulate each task's essence. They should be **challenging and complementary** (ie, not duplicative because you wouldn't learn more). Regularly review your application against these pairs to notice when the performance drops. While thorough evaluations will come later, these early checks are crucial for maintaining direction and focus.

## Conclusion

Starting your first GenAI project is an exciting venture filled with opportunities and challenges. By adhering to these five tips, you position your project for success from the outset. Simplify your approach, prioritize quality, manage resources wisely, and maintain a clear vision of your project's objectives. This blueprint will guide you through the complexities of GenAI development, ensuring a smooth and productive journey from concept to completion.