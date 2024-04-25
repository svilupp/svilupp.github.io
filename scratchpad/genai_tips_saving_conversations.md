@def title = "Automatically Saving Conversations with PromptingTools.jl and AIHelpMe.jl"
@def published = "25 April 2024"
@def drafted = "25 April 2024"
@def tags = ["julia","generative-AI","genAI"]

# TL;DR
Learn how to automatically save conversations with PromptingTools.jl. By saving conversations, you can contribute to building a dataset for fine-tuning a Julia-specific language model. This tutorial provides code examples to get you started

\toc 

## Introduction
Recently, there have been exciting discussions about fine-tuning a language model for the Julia programming language (see [here](https://discourse.julialang.org/t/an-llm-fine-tuned-for-julia-call-for-comments-help/113462/8)). 

As part of this effort, we need a high-quality dataset of GOOD conversations related to Julia. One way to contribute to this effort is to start logging conversations with Large Language Models (LLMs) that are relevant to Julia. 

In this blog post, we will explore how to automatically save conversations using PromptingTools.jl and AIHelpMe.jl, a powerful Julia package for interacting with language models. By saving these conversations, we can build a valuable dataset for fine-tuning a Julia-specific language model.

## Defining a Custom Schema for Saving Conversations

A lesser-known feature, PromptingTools has a custom callback system that allows us to define custom schemas that will then call your arbitrary functions before and after each LLM call (it's used mostly for observability).

To save conversations, we need to define a custom schema that wraps our normal prompt schema. We can do this by creating a new struct `SaverSchema` that inherits from `PT.AbstractTracerSchema`.

```julia
using Dates
using JSON3
using PromptingTools
const PT = PromptingTools

const SAVE_DIR = "finetune_julia"

@kwdef struct SaverSchema <: PT.AbstractTracerSchema
    schema::PT.AbstractPromptSchema
end
```

Any call to this schema triggers a call to function `initialize_tracer` before the LLM call and to `finalize_tracer` after the LLM call.

In our case, we want to overload the `finalize_tracer` function to save the conversation after the LLM call.

```julia
function PT.finalize_tracer(
    tracer_schema::SaverSchema, 
    tracer, 
    msg_or_conv; 
    tracer_kwargs=NamedTuple(), 
    model="", 
    kwargs...
)
    # We already captured all kwargs, they are already in `tracer`, we can ignore tracer_kwargs in this implementation

    time_received = Dates.format(now(), "YYYYmmdd_HHMMSS")
    path = joinpath(SAVE_DIR, "conversation__$(model)__$(time_received).json")
    conv = msg_or_conv isa AbstractVector ? msg_or_conv : [msg_or_conv]
    PT.save_conversation(path, conv)

    return msg_or_conv
end
```

### Example 1: Saving Conversations with `aigenerate`

Now that we have defined our custom schema, we can use it to save conversations with `aigenerate`. We need to explicitly provide the `SaverSchema` instance to `aigenerate` along with the input prompt.

```julia
schema = SaverSchema(PT.OpenAISchema())
msg = aigenerate(schema, "Say hi", model="gpt3t", return_all=true)
```

When you call this function, it will save the conversation to the folder defined in `SAVE_DIR`.

One gotcha, if you send multiple messages in the save convo, is that all turns will be saved in separate files.
The easiest way would be to ignore it and solve it in post-processing (`AIMessage` have unique IDs so it should be easy to detect)
Alternatively, you can save the hash of the content of the first 2-3 messages in the filename to clearly see the continued conversations.

### Example 2: Registering a Traced Model

Instead of providing the custom schema every time, we can register a traced model with the custom schema. This way, we can use the model name instead of the schema instance.

```julia
# Overwrite the schema for this model and define a nice alias
PT.register_model!(; name="gpt-3.5-turbo", schema)
PT.MODEL_ALIASES["gpt3t"] = "gpt-3.5-turbo"

# Notice the return_all -> we need to return ALL messages, it would be a useless record otherwise
msg = aigenerate("Say hi", model="gpt3t", return_all=true)
```
Conversation gets saved.

### Loading Conversations

Once we have saved conversations, we can load them back into Julia using `load_conversation`.

```julia
conv = PT.load_conversation("finetune_julia/conversation__gpt3t__20240425_205853.json")
```

### Exporting Conversations in ShareGPT Format

Once we have enough conversation, we will want to export so our finetuning tool can use them. 
I would highly recommend Axolotl (see an example from [my finetune](https://github.com/svilupp/Julia-LLM-Leaderboard/blob/main/experiments/cheater-7b-finetune/lora.yml)). 

Axolotl can work with instructions (conversations) in ShareGPT format. This is how you can export multiple conversations into the required JSONL file:

```julia
conv1 = [PT.SystemMessage("System message 1"), 
         PT.UserMessage("User message"), 
         PT.AIMessage("AI message")]
conv2 = [PT.SystemMessage("System message 2"), 
         PT.UserMessage("User message"), 
         PT.AIMessage("AI message")]
path = joinpath("finetune_julia", "export_sharegpt.jsonl")
PT.save_conversations(path, [conv1, conv2])
```

## Saving AIHelpMe Conversations

If you use AIHelpMe, you're also generating loads of interesting data!
The simplest thing for auto-logging your questions is to wrap the entry function `aihelp` and serialize the whole `RAGResult` (it has all the diagnostics and underlying information)

```julia
function aih(question; kwargs...)
    result = aihelp(question; return_all=true, kwargs...)
    dt = Dates.format(now(), "YYYYmmdd_HHMMSS")
    JSON3.write(joinpath(SAVE_DIR, "aihelp__$(dt).json"), result)
    return result
end
```

To use it, you would replace `aihelp("some question...")` with `aih("some question...")`.

The serialized RAGResult is c. 200kB, but it provides a lot of helpful detail about your question.
If you want to save space, save just the individual conversations in `result.conversations`.

## Sharing The Conversations

Where to share these? To be discussed. Come join us on [Discourse](https://discourse.julialang.org/t/an-llm-fine-tuned-for-julia-call-for-comments-help/113462/8) or on Julia Slack in #generative-ai.

## Conclusion

In this blog post, we have seen how to automatically save conversations using PromptingTools.jl. By defining a custom schema and overloading the `finalize_tracer` function, we can save conversations to files. We can also register a traced model and use it to generate text. Finally, we can load and export conversations in ShareGPT format for finetuning. With AIHelpMe.jl, we can serialize the whole `RAGResult` with JSON3.

