@def title = "GenAI Mini-Tasks: Advanced Data Extraction Techniques"
@def published = "31 December 2023"
@def drafted = "31 December 2023"
@def tags = ["julia","generative-AI","genAI","prompting"]

# TL;DR
Dive into advanced data extraction techniques using Julia's PromptingTools.jl, where we gracefully handle messy CSV files and enrich data extraction with reasoning about each item, transforming complex text datasets into structured, insightful information.

\toc 

## Introduction

Welcome back to our series, GenAI Mini-Tasks! Today, we're diving into Part 2 of our exploration on structured data extraction, focusing on some nifty advanced techniques using the PromptingTools.jl package. If you thought Part 1 was great, brace yourself for even more GenAI wizardry!

We'll be tackling two advanced techniques today:

- Graceful Error Handling: With the MaybeExtract{T} wrapper, you can elegantly manage extraction errors and understand why they occurred.
- Add Model Reasoning: This involves asking the model to reason about each item's extraction to improve the quality of the output or to add a layer of depth to the data.


## Today's Task - Broken CSV File

Let's dive into an example. We've got a text blob of product data, but it's riddled with issues (broken lines, missing columns, inconsistent separators.). You cannot use CSV.jl anymore. What to do? 

```julia
## Imports we need
using DataFramesMeta, CSV
using PromptingTools
PT = PromptingTools

# Fake product data - notice that there are several invalid rows and that the last two rows are missing any reviews or ratings, ie, it's not possible to load this file with CSV.jl
text_blob = """
  Product ID,Product Name,Price,Rating,Number of Reviews,Description
  B01XYZW0,Eco-Friendly Water Bottle,\$15.99,4.5,112,"Stay hydrated and eco-friendly with our BPA-free, stainless steel water bottle. Perfect for travel and outdoor activities."
  B04XYZW2,Wireless Bluetooth Headphones,\$89.99,4.0,340,"Experience high-quality sound without the hassle of wires. Ideal for workouts, commuting, and leisure."
  B07XYZW4,Compact Digital Camera,\$120.50,4.2,85,"Capture your precious moments with our easy-to-use, high-resolution camera. Compact design, perfect for travel."
  B010XYZW6,Portable External Hard Drive,\$59.99,4.7,220,"Secure and portable storage solution for your files. USB 3.0 for fast data transfer, robust and slim design."
  ,,,,,
  ,,,,,,,,,
  jaksdsjdlkaskjdaslkdjaksjdlaksdj
  ,,,,,
  ,,,,,
  B013XYZW8,Smart LED Light Bulb,\$17.99,4.3,150,"Control your lighting with voice commands or via mobile app. Energy-efficient, customizable colors and brightness."
  B016XYZW10,High-Speed USB Flash Drive,\$25.99,4.6,95,Quickly transfer and store your files with our high-speed USB 3.2 flash drive. Durable and compact design.
  B019XYZW12,Ergonomic Wireless Mouse,\$29.99,4.1,78,"Enjoy comfortable navigation with our ergonomic wireless mouse. Long battery life, precise tracking, and silent clicks."
  B022XYZW14,Noise Cancelling Earbuds,\$99.99,4.8,305,"Block out the noise and focus on your music with our advanced noise-cancelling technology. Comfortable fit, long battery life."
  B025XYZW16,Waterproof Smartwatch,\$199.99,"Track your fitness and stay connected with our waterproof smartwatch. Heart rate monitor, GPS, and various health tracking features."
  B028XYZW18,Ultra-Thin Laptop,\$899.99,"Lightweight yet powerful, this laptop is ideal for both work and entertainment. High-resolution display, long battery life, fast processor."
  """
CSV.read(IOBuffer(text_blob), DataFrame); # Outputs garbled data, showing the need for advanced extraction.
```

Let's use `aiextract` to extract the data we need. We'll define a custom struct to hold the extracted data and use the `:DetailOrientedTask` template to extract the data. We'll also use the `MaybeExtract{T}` wrapper to handle extraction errors gracefully.

```julia
# Let's define a schema for our data
# Notice that whenever we're not sure if the data is present, we use Union with `Nothing` to indicate that the data may be missing.
@kwdef struct Product
    id::String
    name::String
    price::Float64
    rating::Union{Float64,Nothing} = nothing
    reviews::Union{Int,Nothing} = nothing
    description::Union{String,Nothing} = nothing
end
# Create a wrapper to extract all products at once
@kwdef struct ManyProducts
    products::Vector{Product}
end

msg = aiextract(:DetailOrientedTask; task="Extract all Products in the provided in the Data.", data=text_blob, return_type=ManyProducts, model="gpt4t")
msg.content.products # Preview results
```


```plaintext
10-element Vector{Product}:
 Product("B01XYZW0", "Eco-Friendly Water Bottle", 15.99, 4.5, 112, "Stay hydrated and eco-friendly with our BPA-free, stainless steel water bottle. Perfect for travel and outdoor activities.")
 Product("B04XYZW2", "Wireless Bluetooth Headphones", 89.99, 4.0, 340, "Experience high-quality sound without the hassle of wires. Ideal for workouts, commuting, and leisure.")
 Product("B07XYZW4", "Compact Digital Camera", 120.5, 4.2, 85, "Capture your precious moments with our easy-to-use, high-resolution camera. Compact design, perfect for travel.")
 Product("B010XYZW6", "Portable External Hard Drive", 59.99, 4.7, 220, "Secure and portable storage solution for your files. USB 3.0 for fast data transfer, robust and slim design.")
 Product("B013XYZW8", "Smart LED Light Bulb", 17.99, 4.3, 150, "Control your lighting with voice commands or via mobile app. Energy-efficient, customizable colors and brightness.")
 Product("B016XYZW10", "High-Speed USB Flash Drive", 25.99, 4.6, 95, "Quickly transfer and store your files with our high-speed USB 3.2 flash drive. Durable and compact design.")
 Product("B019XYZW12", "Ergonomic Wireless Mouse", 29.99, 4.1, 78, "Enjoy comfortable navigation with our ergonomic wireless mouse. Long battery life, precise tracking, and silent clicks.")
 Product("B022XYZW14", "Noise Cancelling Earbuds", 99.99, 4.8, 305, "Block out the noise and focus on your music with our advanced noise-cancelling technology. Comfortable fit, long battery life.")
 Product("B025XYZW16", "Waterproof Smartwatch", 199.99, nothing, nothing, "Track your fitness and stay connected with our waterproof smartwatch. Heart rate monitor, GPS, and various health tracking features.")
 Product("B028XYZW18", "Ultra-Thin Laptop", 899.99, nothing, nothing, "Lightweight yet powerful, this laptop is ideal for both work and entertainment. High-resolution display, long battery life, fast processor.")
```

Notice that the last two rows are missing any reviews or ratings, but we simply receive the values as nothing - easy to detect and handle in Julia.

We can simply create a DataFrame:
```julia
df = DataFrame(msg.content.products)
```

That was easy, wasn't it? But what if we want to scan the data row-by-row? Or what if we want to scan many text blobs some of which may not contain any products? Let's look at `MaybeExtract{T}` wrapper.

## MaybeExtract{T}

Let's see what happens when we try to extract products from a text that doesn't contain any products:

```julia
msg = aiextract(:DetailOrientedTask; task="Extract all Products in the provided in the Data.", data="njahkshdshdkjhasdjahskdjhaskjhdkasjdhaksjdha", return_type=Product, model="gpt4t")
msg.content
```

```plaintext
Product("njahkshdshdkjhasdjahskdjhaskjhdkasjdhaksjdha", "njahkshdshdkjhasdjahskdjhaskjhdkasjdhaksjdha", 0.0, nothing, nothing, nothing)
```

We get a valid `Product` object, that's guaranteed by the `return_type` feature, but it's not a valid product! The model just always returns _something_.

`MaybeExtract{T}` allows you to handle extraction errors gracefully and get a reason why extraction failed, so you can run your extraction of any arbitrary text without fear of crashing your program.

```julia
# Notice the return_type is MaybeExtract{Product}
msg = aiextract(:DetailOrientedTask; task="Extract all Products in the provided in the Data.", data="njahkshdshdkjhasdjahskdjhaskjhdkasjdhaksjdha", return_type=PT.MaybeExtract{Product}, model="gpt4t")
msg.content
```

```plaintext    
PromptingTools.MaybeExtract{Product}(nothing, true, "The provided data does not contain any product information.")
```

If a product was found, it would be in the `result` field. If no product was found, `result` is `nothing` and the `error` field is `true`. The `message` field contains a short and concise reason why the extraction failed.

So using the `MaybeExtract{Product}` is effectively the same as creating:
```julia
struct MaybeExtractProduct
    result::Union{Product, Nothing}
    error::Bool # true if a result is found, false otherwise
    message::Union{Nothing, String} # Only present if no result is found, should be short and concise
end
```

But it saves you the time of defining it yourself and it's guaranteed to be compatible with `aiextract` and other functions in PromptingTools.jl.


## Add Reasoning Layer

We can add a layer of reasoning to force the model to think more deeply during each extraction. It's like Chain of Thought, but for data extraction. Let's see how we can do this.


Let's work with our product data again. Let's say we want to extract the body part that is most likely to be in contact with the product, because of some skin irritation risk. For example, it could become a feature in a downstream machine-learning model or a new search filter.

This information is not directly in our data, but we can ask the model to reason about it. Let's define a new return type, add a `reasoning` field and add a docstring to tell the model what to do. We can then use our favorite DataFrame tools for the rest.

```julia
"First, reason about which body part is in contact with the product in `reasoning_for_body_part` and then record the body part in `body_part_in_contact`. If there are multiple, separate them with a comma."
@kwdef struct ProductSkinRisk
    reasoning_for_body_part::String
    body_part_in_contact::String
end

# Let's run the extraction - we can use our favorite macros to do that:
# (If you have a lot of duplicate rows or want to run it in parallel, I'd recommend the asyncmap or Threads.@spawn!)
df = @chain df begin
    ## Call LLM for each row (data gets injected into "data" field from each respective column)
    @rtransform skin_risk = aiextract(:DetailOrientedTask; task="Extract all Products in the provided in the Data.", data="Name: $(:name), Description: $(:description)", return_type=ProductSkinRisk, model="gpt4t")
    ## Extract the result from the LLM response into respective columns
    @rtransform begin
        :reasoning_for_body_part = :skin_risk.content.reasoning_for_body_part
        :body_part_in_contact = :skin_risk.content.body_part_in_contact
    end
end
select(df, :name, :reasoning_for_body_part, :body_part_in_contact)
```

```plaintext
10×3 DataFrame
 Row │ name                           reasoning_for_body_part            body_part_in_contact 
     │ String                         String                             String               
─────┼────────────────────────────────────────────────────────────────────────────────────────
   1 │ Eco-Friendly Water Bottle      The user is likely to hold the w…  hands
   2 │ Wireless Bluetooth Headphones  Headphones are designed to be wo…  Ears
   3 │ Compact Digital Camera         Typically, cameras are held and …  hands
   4 │ Portable External Hard Drive   When using a Portable External H…  Hands
   5 │ Smart LED Light Bulb           The light bulb would typically b…  Hands
   6 │ High-Speed USB Flash Drive     A USB flash drive is primarily h…  hands
   7 │ Ergonomic Wireless Mouse       The product mentioned is a mouse…  hand
   8 │ Noise Cancelling Earbuds       The product described is `Noise …  ears
   9 │ Waterproof Smartwatch          The waterproof smartwatch is typ…  wrist
  10 │ Ultra-Thin Laptop              The laptop is most commonly in c…  hands, lap
```

Let's review one of the responses:
```julia
df.skin_risk[10].content
# Output: ProductSkinRisk("The laptop is most commonly in contact with the user's hands while typing or navigating, and it may also be placed on the user's lap during use.", "hands, lap")
```

We've added a new layer of depth to our data extraction, asking the model to reason about the product's contact with skin, leading to more insightful features - incredible!

Note: Why did we keep the `skin_risk` column with AI messages? It allows us to quickly sum up the elapsed time, costs or see what went wrong.

## Conclusion

Wrapping up, we see how effortlessly we can integrate this processed data into a DataFrame. It's not just about extracting data anymore; it's about enriching it, understanding it, and making it work for you.

Stay tuned for more tips and tricks in our "GenAI Mini Tasks" series. Happy data wrangling with Julia and PromptingTools.jl! 🌟📊🎩