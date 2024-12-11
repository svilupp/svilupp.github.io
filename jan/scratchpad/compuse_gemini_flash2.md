@def title = "Gemini Flash 2.0 - The Universal Computer Use Model We've Been Waiting For"
@def published = "11 December 2024"
@def drafted = "11 December 2024"
@def tags = ["generativeAI", "Gemini", "ComputerUser"]

## TL;DR

Gemini Flash 2.0 was just announced today, and it seems to be a game-changer for "Computer Use" - a term coined by Anthropic for agent-based computer control. Beyond just computer vision (and understand of screenshots specifically), it offers a comprehensive solution for multimodal AI interaction at an incredibly accessible price point.

## The Problem with Specialized Solutions

For the past couple of months, I've been wrestling with various computer vision solutions to get a reliable "Computer Use" agent - from ShowUI to OmniParser. While each excels in their niche, integrating them into a cohesive workflow has been challenging. What I really needed was a universal solution that could handle any visual task, no matter how small or specific.

## Enter Gemini Flash 2.0

Google announced Gemini Flash 2.0 today, and while the benchmarks are impressive, what's truly revolutionary are its tool-use and multimodal capabilities together. Not only does it excel at computer vision and screenshot understanding, but it also demonstrates strong performance across other modalities - bringing us closer to "Jarvis"-like experiences. Most remarkably, it delivers this comprehensive "Computer Use" experience at the same price point as the original Flash model.

Note: If you use PromptingTools.jl, use `model = "gem20f"` with version `0.69` or higher.

## Real-World Testing

_Code is provided in the appendix!_

### Test Case 1: Object Detection in Screenshots

I put Flash 2.0 to the test with a basic object detection task in screenshots - something that many frontier models struggle with (except for Anthropic Sonnet 3.6). The results were pretty good:

![Screenshot 1 with search box bounding boxes](/assets/compuse_gemini_flash2/google_detections1.png)

### Test Case 2: UI Navigation Understanding

Let's try something a bit more complex - a GitHub branch change. This tasks requires both visual understanding and contextual reasoning to know where to click.

![Screenshot 2 with GitHub branch change](/assets/compuse_gemini_flash2/github_detections2.png)

Flash 2.0 was able to correctly identify the branch change button and click it.

## What's Next

Flash 2.0's release has given me the push I needed to finally finish my computer use automation library. The library focuses on practical, everyday task automation that anyone can use.

I'll be sharing more tutorials and examples of both Flash 2.0 and the library working together. Stay tuned!

## Appendix

### Code

Basic setup code:
```julia
using PromptingTools
const PT = PromptingTools
using OmniParserIconDetectors # for the image/drawing detection
using OmniParserIconDetectors: load_image, preprocess_image, draw_detections

"Scales Google's normalized 0-1000 scale to image size"
function scale_to_img_size(x1, y1, x2, y2, img__path)
    img = load_image(img__path)
    img_width, img_height = size(img)
    # Scale coordinates from 0-1000 range to actual image dimensions
    scaled_x1 = round(Int, x1 * img_width / 1000)
    scaled_y1 = round(Int, y1 * img_height / 1000)
    scaled_x2 = round(Int, x2 * img_width / 1000)
    scaled_y2 = round(Int, y2 * img_height / 1000)
    return (scaled_x1, scaled_y1, scaled_x2, scaled_y2)
end
```

Code snippet 1: Search box detection 
```julia
image_path = "test/images/test1.png" # test image from OmniParserIconDetectors repo
prompt = "Give me the coordinates of the search box to enter the text 'hello'"
msg = aitools(prompt; image_path, model = "gem20f")
# PromptingTools.AIToolRequest("The search box is located at coordinates (110,380) to (470,410) in the provided image."; Tool Requests: 0)
detections = [DetectedItem(;
    id = 1, bbox = scale_to_img_size(110, 380, 470, 410, image_path))]
annotated_image = draw_detections(
    image_path, detections; save_path = "google_detections1.png")
```

Code snippet 2: GitHub branch change with proper tool calling
```julia
image_path = "test/images/test2.png"
detections = DetectedItem[]
## Set up mock tool call just to record the coordinates
function mouse_click(x::Int, y::Int)
    global detections, image_path
    bbox = scale_to_img_size(x, y, x, y, image_path)
    push!(detections, DetectedItem(; id = length(detections) + 1, bbox))
    @info "Clicking at coordinates: ($(bbox[1]), $(bbox[2]))"
end
tools = PT.tool_call_signature(mouse_click);

## Call the LLM with our task
prompt = "Change branch to `dev`."
msg = aitools(prompt; image_path, model = "gem20f", tools = collect(values(tools)))
PT.execute_tool(tools, msg.tool_calls[1])
# [ Info: Clicking at coordinates: (151, 402)

## Draw the detections
annotated_image = draw_detections(
    image_path, detections; save_path = "google_detections2.png")
```

