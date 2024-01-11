@def title = "GenAI Mini-Tasks: Extracting Data Part 2!"
@def published = "11 January 2024"
@def drafted = "9 January 2024"
@def tags = ["julia","generative-AI","genAI"]

# TL;DR
You can now run the 70 billion parameter Llama2 language model locally on an M1 Mac in Julia (thanks to llama.cpp 2-bit quantization)

\toc 

## Running 70 Billion Parameters on Your Mac?

It's a fascinating time in the world of generative AI and large language models. I recently had an experience that seemed almost surreal just a year ago—I ran a 70 billion parameter language model, Llama2, locally on my Mac M1. To put that into perspective, if each parameter were an M&M, we could fill more than 10 Olympic-sized swimming pools!

What made this possible is the recent release of Llama.cpp, supporting new 2-bit quantization. This practically compresses the model to use almost 16 times less memory compared to traditional Float32 parameters. It's an incredible leap in model efficiency and accessibility. It's not without "price", but its performance is still impressive.

For those eager to try this out, the Julia programming community has made it incredibly easy. Recently, I discovered a nifty package [Llama.jl](https://github.com/marcom/Llama.jl), which wraps the famous llama.cpp, but you don't have to compile anything! Julia's Artifact ecosystem streamlines the process.
Here’s how you can do it:

```julia
using Llama

url = "https://huggingface.co/ikawrakow/various-2bit-sota-gguf/resolve/main/llama-v2-70b-2.12bpw.gguf"
model = download_model(url) # Go make a cup of tea while you wait... this is a 20GB download!

# and now we can run the server:
Llama.run_server(; model)
# Note: If you get some memory or GPU problems, look at parameter `n_gpu_layers`, which dictates how many layers of your model should go onto your GPU vs CPU
```
To try it out either open http://127.0.0.1:10897 in your browser or use PromptingTools.jl like you would with any OpenAI-compatible server:

Open a separate Julia session and run:

```julia
using PromptingTools
const PT = PromptingTools

msg = aigenerate(PT.CustomOpenAISchema(), "What is Julia lang good for?"; api_kwargs=(; url="http://127.0.0.1:10897/v1"))
```

It may take a few seconds...

```plaintext
[ Info: Tokens: 97 in 19.2 seconds
AIMessage("Julia is a high-level, high performance dynamic programming language for numerical computing. It provides an ecosystem of open source tools built by the community.")
```

The above code snippet allows you to download and run a massive 70 billion-parameter model right on your machine with just ~20GB of memory requirement. 

If a 20GB model seems overkill for your needs, try the [Rocket model](https://huggingface.co/pansophic/rocket-3B), which is less than 1GB in size but still boasts 3 billion parameters.

```julia
# Download the Rocket model and start your server
url = "https://huggingface.co/ikawrakow/various-2bit-sota-gguf/resolve/main/rocket-3b-2.76bpw.gguf"
model = download_model(url) # 1GB download
Llama.run_server(; model)
```

In a separate Julia session, call the model with PromptingTools.jl
```julia
# In a separate Julia session, call the model with PromptingTools.jl
using PromptingTools
const PT = PromptingTools
# PT.register_model!(; name="llama70b", schema=PT.CustomOpenAISchema())

msg = aigenerate(PT.CustomOpenAISchema(), "Say hi!"; api_kwargs=(; url="http://127.0.0.1:10897/v1"))
# [ Info: Tokens: 75 in 5.9 seconds
# AIMessage("Hello there! I'm glad you reached out to me. I'll do my best to be a helpful AI assistant, so if you have any questions or need assistance with anything, just let me know and I'd be happy to help. Hi there!")

msg = aigenerate(PT.CustomOpenAISchema(), "What is Julia lang good for?"; api_kwargs=(; url="http://127.0.0.1:10897/v1", max_tokens=2000))
# [ Info: Tokens: 137 in 12.6 seconds
# AIMessage("Julia is a high-performance, open-source numerical computing language designed for scientific and engineering applications. It offers fast and efficient computation capabilities with features like multi-threading, automatic array memory optimization, and built-in support for popular libraries such as NumPy, Pandas, and Matplotlib. Julia has gained popularity among data scientists, engineers, and researchers due to its speed, scalability, and ease of use. It is particularly useful when you need to perform complex computations with large datasets or handle high-dimensional arrays efficiently.")

```

As you can see, the responses are impressive for a 1GB model! It’s truly remarkable how the open-source scene is rapidly advancing, making powerful AI tools accessible to more and more people.

This exploration into running large language models locally is just a glimpse into the potential of AI and how it's being democratized. It's a testament to the power of open-source software and the continuous innovation in the field of AI and data science. Stay tuned for more amazing developments!

PS: Yes, we do need a nicer integration between PromptingTools.jl and Llama.jl. I'm already working on it. Stay tuned!