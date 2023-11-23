@def title = "GenAI Mini-Task: No More Re-typing SQL Screenshots!"
@def published = "22 November 2023"
@def drafted = "6 November 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
TL;DR: Use Generative AI and the PromptingTools.jl package to effortlessly convert screenshots into text, eliminating the need for manual re-typing and streamlining everyday tasks like extracting data from images. This simple, efficient solution leverages the GPT-4 vision model for quick and accurate text extraction.

\toc 

## Scenario

Ever experienced the frustration of wanting to delve deeper into a presentation's content, but all you have are screenshots? You're not alone. Thankfully, the advent of multi-modal Generative AI models, like GPT-4 vision, has made accessing data from images a breeze. This post will show you how to leverage these capabilities to convert screenshots into usable data, without the tedious task of retyping.

**Our Example:** Imagine you've attended a training session on using a specific database. You snapped a screenshot of a critical query but now face the daunting task of retyping it. Sounds familiar? Let's simplify this with Generative AI.

For the purposes of this article, we'll use the following screenshot as our example: ![SQL Screenshot](https://www.sqlservercentral.com/wp-content/uploads/legacy/8755f69180b7ac7ee76a69ae68ec36872a116ad4/24622.png)

## Turning Screenshots into Text

Let's break down the task into two steps:
1. **Prepare Your Screenshot:** First, ensure your screenshot is saved as a file. This can be done by taking a fresh screenshot of it (Windows: use Snipping Tool and save to file, MacOS: `CMD+SHIFT+5`) or copy & paste the image into an image editor. Now, you should have a file like `my_sql.png` ready to go.

2. **Utilize [PromptingTools.jl](https://github.com/svilupp/PromptingTools.jl) and OpenAI API:** With your screenshot ready, it's time to harness the power of GenAI. Using the [PromptingTools.jl](https://github.com/svilupp/PromptingTools.jl) package, we'll apply the `:OCRTask` template. This template is specifically designed to extract text from images and we can use the placeholder `{{task}}` to specify what we want (read more with `aitemplates("OCRTask")`). We'll provide the image path via `image_path` keyword argument.

```julia
using PromptingTools

aiscan(:OCRTask; task="Transcribe the SQL code in the image.", image_path="my_sql.png",model="gpt4v")
```

It took <20 seconds to get the `image_path`, write the command and get the results back.
The cost is less than a cent! Imagine the benefit when it's 20 images or a massive SQL query!

```plaintext
[ Info: Tokens: 362 @ Cost: \$0.0045 in 2.3 seconds
AIMessage("```sql
update Orders 
set shipdate = '20150102'
where OrderID = 2112;

select *
from orders
where orderid > 2010
and orderid < 2120;
```")
```

If you want to display the SQL nicely formatted, use Julia Markdown:
```julia
using Markdown
msg.content |> Markdown.parse
```

## Other Parameters of `aiscan`

There are a few ways useful keyword arguments of `aiscan`:
- **`image_url`/`image_path`:** Can be a string for a single image or a vector of strings for multiple images. This parameter designates the location(s) of the image(s) you want to process.

- **`image_detail`:** Offers a choice between 'low' and 'high' detail levels, allowing you to dictate the depth of analysis based on the clarity and complexity of the text in your image(s). Defaults to 'auto'.

## Troubleshooting
Currently, this feature is exclusive to the GPT-4 Vision model (`gpt-4-vision-preview` which we aliased with `gpt4v`). Attempting it with other models will result in an error, but the solution is simple: switch to `model=gpt4v`, and you're set!

The error you get when using the wrong model:
```plaintext
{
  "error": {
    "message": "Invalid content type. image_url is only supported by certain models.",
    "type": "invalid_request_error",
    "param": "messages.[1].content.[1].type",
    "code": null
  }
}
```

## Conclusion

Gone are the days of tedious retyping! With tools like PromptingTools.jl and the power of GenAI, extracting text from images is now a quick and easy mini-task. This is just one of many daily tasks that GenAI can streamline, opening up more time for you to focus on your main project goals. Try it out, and share your experiences or suggestions for future topics!