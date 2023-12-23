@def title = "Building a RAG Chatbot over DataFrames.jl Documentation - Easy Mode"
@def published = "23 December 2023"
@def drafted = "21 December 2023"
@def tags = ["julia","generative-AI","genAI","rag"]

# TL;DR
Elevating our RAG chatbot development, this post explores the integration of PromptingTools.jl and RAGTools, showcasing a more efficient approach to building a chatbot using the DataFrames.jl documentation. We'll also delve into system evaluations.

\toc 

Last time, we crafted a RAG chatbot from scratch. Today, we're taking a leap forward with PromptingTools.jl and its experimental sub-module, RAGTools, for a more streamlined experience in Julia. Ready to dive deeper?

## Effortless RAG System Building with RAGTools

Remember, "RAG" is a cornerstone in Generative AI right now. If you're new to "RAG", this [article](https://towardsdatascience.com/add-your-own-data-to-an-llm-using-retrieval-augmented-generation-rag-b1958bf56a5a) is a great starting point.

Even if you are familiar with RAG, I would strongly recommend watching [Jerry Liu's talk on Building Production-Ready RAG Applications](https://www.youtube.com/watch?v=TRjq7t2Ms5I&ab_channel=AIEngineer). It's well spent 20 minutes and will help you understand the further sections in this article.

````julia
using LinearAlgebra, SparseArrays
using PromptingTools
using PromptingTools.Experimental.RAGTools
## Note: RAGTools module is still experimental and will change in the future. Ideally, they will be cleaned up and moved to a dedicated package
using JSON3, Serialization, DataFramesMeta
using Statistics: mean
const PT = PromptingTools
const RT = PromptingTools.Experimental.RAGTools
````

## RAG in Two Lines

Start by grabbing a few text pages from the [DataFrames.jl documentation](https://dataframes.juliadata.org/stable/), saving them as text files in `examples/data`. Aim for clean content, free of headers and footers. Remember, garbage in, garbage out!

````julia
files = [
    joinpath("examples", "data", "database_style_joins.txt"),
    joinpath("examples", "data", "what_is_dataframes.txt"),
]
# Build an index of chunks, embed them, and create a lookup index of metadata/tags for each chunk
index = build_index(files; extract_metadata = false);
````

Let's ask a question

````julia
# Embeds the question, finds the closest chunks in the index, and generates an answer from the closest chunks
answer = airag(index; question = "I like dplyr, what is the equivalent in Julia?")
````

````
AIMessage("The equivalent package in Julia to dplyr in R is DataFramesMeta.jl. It provides convenience functions for data manipulation with syntax similar to dplyr.")
````

And there you have it, a RAG system in just two lines!


What does it do?
- `build_index` chunks and embeds the documents, creating a metadata index.
  - `index` is the result of this step and it holds your chunks, embeddings, and other metadata! Just show it :)
- `airag` embeds your question, finds relevant chunks, and optionally applies tags or filters to refine the search. It then generates an answer based on the best-matched chunks.
  - embed your question
  - find the closest chunks in the index (use parameters `top_k` and `minimum_similarity` to tweak the "relevant" chunks)
  - [OPTIONAL] extracts any potential tags/filters from the question and applies them to filter down the potential candidates (use `extract_metadata=true` in `build_index`, you can also provide some filters explicitly via `tag_filter`)
  - [OPTIONAL] re-ranks the candidate chunks (define and provide your own `rerank_strategy`, eg Cohere ReRank API)
  - build a context from the closest chunks (use `chunks_window_margin` to tweak if we include preceding and succeeding chunks as well, see `?build_context` for more details)
- generate an answer from the closest chunks (use `return_context=true` to see under the hood and debug your application)

You should save the index for later to avoid re-embedding / re-extracting the document chunks!

````julia
serialize("examples/index.jls", index)
index = deserialize("examples/index.jls");
````

## Evaluations: Assessing Quality

To gauge the effectiveness of our system, we need a golden set of quality Q&A pairs. Creating these manually is ideal but can be labor-intensive. Instead, let's generate them from our index:

### Generate Q&A Pairs

Here's how to create evaluation sets from your `index` (we need the text chunks and corresponding file paths/sources).

````julia
evals = build_qa_evals(RT.chunks(index),
    RT.sources(index);
    instructions = "None.",
    verbose = true);
````

````
[ Info: Q&A Sets built! (cost: $0.102)

````

> [!TIP]
> In practice, you would review each item in this golden evaluation set (and delete any generic/poor questions).
> It will determine the future success of your app, so you need to make sure it's good!

Save your evaluation sets for later use (and ideally review them manually).

````julia
JSON3.write("examples/evals.json", evals)
evals = JSON3.read("examples/evals.json", Vector{RT.QAEvalItem});
````

### Explore a Q&A pair

Here's a sample Q&A pair to illustrate the process (it's not the best quality but gives you the idea):

````julia
evals[1]
````

````
QAEvalItem:
 source: examples/data/database_style_joins.txt
 context: Database-Style Joins
Introduction to joins
We often need to combine two or more data sets together to provide a complete picture of the topic we are studying. For example, suppose that we have the following two data sets:

julia> using DataFrames
 question: What is the purpose of joining two or more data sets together?
 answer: The purpose of joining two or more data sets together is to provide a complete picture of the topic being studied.

````

### Judging a Q&A Pair

So let's say we use this Q&A pair to evaluate our system, we plug this Question into `airag` and get a new answer back. But how do we know it's good?

We use a "judge model" (like GPT-4) for evaluation (we extract a `final_rating`):

````julia
# Note: that we used the same question, but generated a different context and answer via `airag`
msg, ctx = airag(index; evals[1].question, return_context = true);
# ctx is a RAGContext object that keeps all intermediate states of the RAG pipeline for easy evaluation
judged = aiextract(:RAGJudgeAnswerFromContext;
    ctx.context,
    ctx.question,
    ctx.answer,
    return_type = RT.JudgeAllScores)
judged.content
````

````
Dict{Symbol, Any} with 6 entries:
  :final_rating => 4.8
  :clarity => 5
  :completeness => 4
  :relevance => 5
  :consistency => 5
  :helpfulness => 5
````

But `final_rating` for the generated answer is not the only metric we should watch. We should also judge the quality of the provided context ("retrieval_score") and a few others.

This generation+evaluation loop and a few common metrics are available in `run_qa_evals`:

````julia
x = run_qa_evals(evals[10], ctx;
    parameters_dict = Dict(:top_k => 3), verbose = true, model_judge = "gpt4t")
````

````
QAEvalResult:
 source: examples/data/database_style_joins.txt
 context: outerjoin: the output contains rows for values of the key that exist in any of the passed data frames.
semijoin: Like an inner join, but output is restricted to columns from the first (left) argument.
 question: What is the difference between outer join and semi join?
 answer: The purpose of joining two or more data sets together is to combine them in order to provide a complete picture or analysis of a specific topic or dataset. By joining data sets, we can combine information from multiple sources to gain more insights and make more informed decisions.
 retrieval_score: 0.0
 retrieval_rank: nothing
 answer_score: 5
 parameters: Dict(:top_k => 3)

````

QAEvalResult is a simple struct that holds the evaluation results for a single Q&A pair. It becomes useful when we evaluate a whole set of Q&A pairs (see below).

## Evaluate the Whole Set

Fortunately, we don't have to do the evaluations manually one by one.

Let's run each question & answer through our eval loop in async (we do it only for the first 10 to save time). See the `?airag` for which parameters you can tweak, eg, `top_k`

````julia
results = asyncmap(evals[1:10]) do qa_item
    # Generate an answer -- often you want the model_judge to be the highest quality possible, eg, "GPT-4 Turbo" (alias "gpt4t)
    msg, ctx = airag(index; qa_item.question, return_context = true,
        top_k = 3, verbose = false, model_judge = "gpt4t")
    # Evaluate the response
    # Note: you can log key parameters for easier analysis later
    run_qa_evals(qa_item, ctx; parameters_dict = Dict(:top_k => 3), verbose = false)
end
## Note that the "failed" evals can show as "nothing" (failed as in there was some API error or parsing error), so make sure to handle them.
results = filter(x->!isnothing(x.answer_score), results);
````

Note: You could also use the vectorized version `results = run_qa_evals(evals)` to evaluate all items at once and skip the above code block.

````julia

# Let's take a simple average to calculate our score
@info "RAG Evals: $(length(results)) results, Avg. score: $(round(mean(x->x.answer_score, results);digits=1)), Retrieval score: $(100*round(Int,mean(x->x.retrieval_score,results)))%"
````

````
[ Info: RAG Evals: 10 results, Avg. score: 4.6, Retrieval score: 100%

````

Note: The retrieval score is 100% only because we have two small documents and running on 10 items only. In practice, you would have a much larger document set and a much larger eval set, which would result in a more representative retrieval score.

If you prefer, you can also analyze the results in a DataFrame:

````julia
df = DataFrame(results)
````

We're done for today!

# Where to Go From Here?

- Review your evaluation golden data set and keep only the good items
- Experiment with the chunk sizes (`max_length` in `build_index`)
- Explore using metadata/key filters (`extract_metadata=true` in `build_index`)
- Add filtering for semantic similarity (embedding distance) to make sure we don't pick up irrelevant chunks in the context (`minimum_similarity` in `airag`)
- Use multiple indices or a hybrid index (add a simple BM25 lookup from `TextAnalysis.jl`)
- Data processing is the most important step - properly parsed and split text could make wonders, so review your current approach
- Add re-ranking of context (see `rerank` function, you can use Cohere ReRank API)
- Improve the question embedding (eg, rephrase it, generate hypothetical answers and use them to find better context)
- Try different models and providers for different parts of the RAG pipeline

... and much more! See some ideas in [Anyscale RAG tutorial](https://www.anyscale.com/blog/a-comprehensive-guide-for-building-rag-based-llm-applications-part-1)

If you want to learn more about helpful patterns and advanced evaluation techniques (eg, how to measure "hallucinations"), check out this talk by [Eugene Yan: Building Blocks for LLM Systems & Products](https://www.youtube.com/watch?v=LzeC1AQ-U5o&t=4s&ab_channel=AIEngineer).
