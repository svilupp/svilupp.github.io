@def title = "The Latest Scoop on PromptingTools.jl"
@def published = "5 April 2024"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
PromptingTools.jl just got a hefty update with several new versions, packed with new models, enhanced AI tools, and easier dataset prep, all thanks to a coffee-fueled solo developer who's now inviting others to join the coding party through GitHub issues. Dive in, contribute, and let's make magic together!

\toc

## Dive Into the Latest and (Maybe) Greatest PromptingTools.jl Updates!

Hello, Julia enthusiasts and AI aficionados! We've been busy tinkering in the Julia workshop, and guess what? We’ve rolled out not one, not two, but EIGHT new sub-versions of [PromptingTools.jl](https://github.com/svilupp/PromptingTools.jl)! That’s right, we’ve been on a coding spree, fueled by too much coffee and an unyielding passion for making your lives a tad easier (and ours a bit more caffeinated).

Start with:
```julia
using Pkg
Pkg.add("PromptingTools")
```

```julia
using PromptingTools
ai"How could I have lived without PromptingTools.jl for so long?"
## [ Info: Tokens: 138 @ Cost: $0.0002 in 5.4 seconds
## AIMessage("It's great to hear that you've found PromptingTools.jl to be a valuable tool! PromptingTools.jl is designed to streamline your workflow...
```

## **What’s Fresh in PromptingTools.jl?**

### **Supercharged Model Shenanigans**

- **AIGenerate Meets Anthropic:** Ready for a text generation party? Anthropic API is now on the guest list with its cool aliases – bring on the AI prose!

- **Data Extraction Gets Anthropic:** Ever wished for Claude from Anthropic to help you with data extraction? Wish granted! Now you can summon Claude 3 to pull out data like a digital magician. In other news, **Claude 3 Haiku is amazing at parties**.

- **GoogleGenAI Enters the Chat:** With a GOOGLE_API_KEY, you can now conjure up content with Google's Gemini model. It’s like having a Google genie but for AI text generation.

- **Model Registry Bonanza:** We’ve added some fancy new models to our registry like “nomic-embed-text” and “mxbai-embed-large.” Because who doesn’t like more toys in their AI sandbox?
  
### Revamped RAGTools: Sleek, Fast, and Flexible

RAGTools has received a major upgrade, making your AI adventures smoother and speedier:

- **RAGTools Goes Binary:** Think binary is just for computers and that one friend who can only answer in yes/no? Well, now RAGTools speaks binary too, for embeddings that zip and zoom faster than you can say “BinaryCosineSimilarity()”. You should read this [blog](https://huggingface.co/blog/embedding-quantization#binary-quantization-in-vector-databases). There is a benchmark blog post upcoming!

- **Customizable RAG Interface:** For those who love to tweak and tailor, the new RAG interface is a game-changer. With `retrieve` and `generate!` functions and all their sub-steps properly separated and documented, you now have the power to craft a RAG pipeline that perfectly fits your project's needs, offering unparalleled flexibility in how you approach AI-driven tasks. See the documentation for more details.

- **Debugging & Analysis Tools:** We’ve introduced pretty-printing and support annotations because sometimes you need to read AI-generated content without squinting and sometimes you want to know when the model is lying to you.

### **Dataset Prep & Nifty Utilities**

- **Easier Dataset Prep:** We made dataset prep as easy as pie. Sadly, it doesn’t come with actual pie. But, JSONL format export? Yum!

- **Docs & Tools Galore:** Dive into our expanded docs with an "Extra Tools" section that’s like finding an extra fry at the bottom of the bag. Plus, FAQs to guide you through the thicket of common woes.

### **For the Adventurous Souls**

- **Dabble in AI Art:** Feeling artsy? Our experimental support for image generation with DALL-E models lets you channel your inner digital Picasso.

### **Improvements & Bug Squashing**

We’ve polished, tweaked, and outright cajoled PromptingTools.jl into a better version of itself, all while fixing those pesky bugs that love to play hide and seek.

## **Looking Forward (With Goggles On)**

We're as excited as a kid in a candy store about these updates and can’t wait to see what you'll build, debug, or accidentally break with them. Your projects are the real MVPs here, and we’re just here to supply the tools (and occasionally entertain).

So, grab the latest version of PromptingTools.jl, unleash your creativity, and remember: in the world of coding, the journey is half the fun, and the other half? Well, that’s debugging. Happy coding, and may your coffee be strong and your bugs few!

## A Solo Journey (But Open to Hitchhikers):
Plot twist: PromptingTools.jl has been mostly a solo quest. However, I’ve started mapping out all my wild ideas and to-dos on GitHub as [issues](https://github.com/svilupp/PromptingTools.jl/issues), inviting anyone who's keen to pitch in or tackle something that sparks their interest. It’s a chance to dive into the fray and help shape the future of this project. So, if you’re up for a bit of coding camaraderie, come join the adventure! The ultimate goal is to stabilize the functionality and interfaces and transfer it under JuliaGenAI organization for faster development.

EDIT: The longer-term hope is to write an agent that will create all the PRs automatically :)