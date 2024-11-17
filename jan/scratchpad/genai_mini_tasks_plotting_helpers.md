@def title = "GenAI Mini-Tasks: Automating the Little Helpers for Plotting"
@def published = "27 November 2023"
@def drafted = "26 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
GenAI Mini-Tasks harness the power of Generative AI to automate tedious tasks in data science, such as formatting plot labels, freeing up time for more complex challenges and enhancing overall productivity in projects using tools like Julia's PromptingTools.jl.

\toc 


## Introduction
Welcome to the world of GenAI Mini-Tasks! Here, we explore how Generative AI can revolutionize even the smallest tasks in your data analyses, saving your brain power and more you more effective.

## The Small Tasks Challenge
In data science, it's often the little things that eat up time - like tweaking plot labels or formatting data. These tasks are simple yet tedious, and they distract from the bigger picture.

## GenAI: Your Coding Assistant
Thanks to GenAI and tools like Julia's PromptingTools.jl, you can now delegate these mini-tasks to AI. Whether it's adjusting plot labels in Makie or something else, GenAI is here to help.

## Practical Example: Streamlining Plot Labels
As a case study, let's consider plot labels in data visualization. They vary in length and can mess up the aesthetics of your charts (especially if you're creating many charts with the same layout but different data series). 

![Barplot with a bad legend](/assets/genai_mini_tasks_plotting_helpers/barplot_legend_long.png)

We need a function to split the labels onto a new line whenever they exceed some width. Let's ask GenAI to generate a 'wrap string' function to uniformly right-size these labels. The result? A handy function that automatically adjusts the text, saving us time and frustration.

```julia

using PromptingTools

# if you need a reminder which Julia templates are available
aitemplates("Julia") 

# call GPT-4 Turbo with the JuliaExpertAsk template
msg = aigenerate(:JuliaExpertAsk; ask="Write a function `wrap_string`. It iterates over words and it will add a new line each time a maximum `text_width::Int=10` would be exceeded. Provide an example", model="gpt4t")
```

```plaintext
[ Info: Tokens: 350 @ Cost: $0.0086 in 7.9 seconds
AIMessage("Here is a function `wrap_string` that wraps words nto lines such that each line does not exceed the text_width`:
```

```julia
 function wrap_string(text::String, text_width::Int=10)
     words = split(text)
     wrapped_text = ""
     current_line_length = 0

     for word in words
         if current_line_length + length(word) <= text_width
             wrapped_text *= (current_line_length == 0 ? "" :  " ") * word
             current_line_length += length(word) + current_line_length == 0 ? 0 : 1
         else
             wrapped_text *= "\n" * word
             current_line_length = length(word)
         end
     end

     return wrapped_text
end
```

```plaintext
Example usage of the function:
```

```julia
 text = "This function will wrap words into lines"
 wrapped_text = wrap_string(text)
 println(wrapped_text)
```

```plaintext
This will output the text wrapped to the specified width as per the function. Due to the 10-character limit, you could expect the output to be in several lines, with each line's length up to or a bit less than 10 characters, depending on the words' lengths and the spaces between them.")
```

Pretty good for a single shot! It took ~40 seconds to write, a few more seconds to generate and cost only a cent!

We tried the example and all works as expected:
```julia
 text = "This function will wrap words into lines"
 wrapped_text = wrap_string(text)
# "This\nfunction\nwill wrap\nwords into\nlines"
```

Let's use it for our chart (see the code in the appendix. Algebra of Graphics is amazing!!!):

![Barplot with a fixed legend](/assets/genai_mini_tasks_plotting_helpers/barplot_legend_fixed.png)

## Pro Tips

Be explicit in what you want ("iterate over words") and ask for examples ("provide an example"). This allows you to quickly copy and paste the code and test it.

## Conclusion
GenAI Mini-Tasks show that even the most mundane coding tasks can be streamlined with AI. Embrace these tools to focus on what truly matters in your data science projects. Stay tuned for more insights on using GenAI to tackle everyday coding challenges!

## Appendix

Code used to produce the examples above:

```julia
using DataFramesMeta
using CairoMakie, AlgebraOfGraphics

# Example data for barplot with 2 stacked series
dummy = DataFrame(
    x = repeat(["Year 1", "Year 2"], inner = 3),
    y = repeat(["This is extremely long name for category A", "B", "C"], outer = 2),
    z = [1, 2, 3, 4, 5, 6],
)

# Plot with AoG
plt =
    data(dummy) *
    mapping(:x => "Years", :z => "Values", color = :y => "Category", stack = :y) *
    visual(BarPlot) |> draw
save("barplot_legend_long.png", plt, px_per_unit = 2)


"Wraps a string to a given width by inserting newlines."
function wrap_string(text::String, text_width::Int = 10)
    words = split(text)
    wrapped_text = ""
    current_line_length = 0

    for word in words
        if current_line_length + length(word) <= text_width
            wrapped_text *= (current_line_length == 0 ? "" : " ") * word
            current_line_length += length(word) + (current_line_length == 0 ? 0 : 1)
        else
            wrapped_text *= "\n" * word
            current_line_length = length(word)
        end
    end

    return wrapped_text
end

# Plot with AoG and wrapped labels (using the function above)
plt =
    data(dummy) *
    mapping(
        :x => "Years",
        :z => "Values",
        color = :y => (x -> wrap_string(x, 20)) => "Category",
        stack = :y,
    ) *
    visual(BarPlot) |> draw
save("barplot_legend_fixed.png", plt, px_per_unit = 2)
```