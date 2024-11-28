@def title = "Deno + Webview: The Lightweight Path to Desktop AI Apps"
@def published = "28 November 2024"
@def tags = ["Deno", "Webview", "Apps", "GenAI"]


## TL;DR
I've created a [template for building desktop AI applications](https://github.com/svilupp/deno-webview-chat-assistant) using Deno 2.1, Vue.js, and Webview. The template makes it easy to create standalone executables for your GenAI tasks in just a few minutes.

\toc

# Introduction

During my recent AI hacks, I found myself wanting a simpler way to create desktop applications for my GenAI experiments. I needed something that would let me access local files securely without cloud uploads, integrate naturally with desktop workflows, and be easily distributed as single executables. 

The existing solutions weren't quite what I was looking for - Electron felt too heavyweight for my needs, and Tauri, while powerful, required a complex setup that felt like overkill for simple applications. I wanted to use Deno but there were too many sharp edges and missing pieces. That's when Deno 2.1 came along with its new features, particularly the ability to [bundle arbitrary files into executables](https://deno.com/blog/v2.1#embed-assets-files-in-deno-compile). This opened up the possibility to create exactly what I needed: a lightweight, straightforward template for building desktop AI applications.


# Gotchas & Lessons Learned

The journey wasn't without its challenges. Here are some key issues I had to solve:

## Webview Threading Issues
Webview can be tricky as it cannot run on other threads or yield control. This meant the server couldn't run in the main thread, leading to a worker-based solution.

## Worker Import Problems
Running the server in a worker created its own set of challenges with Deno's import system (JSR packages). The solution required careful structuring of imports and proper path handling.

## Asset Bundling Complexity
While Deno 2.1's new bundling capabilities are amazing, getting all pieces to work together was tricky:
- Main application code
- Worker code
- VueJS assets
- Correct path resolution after compilation

## Path Resolution Post-Compilation
The trickiest part was getting paths to work correctly after the app was compiled. Oak middleware kept causing issues, so I ultimately switched to Deno's standard file reader, which handled the path re-linking more reliably and then I just pass the bytes to the router.

# Getting Started

The template is designed to be minimal yet functional. You can get started with just a few commands: 
```bash
git clone https://github.com/svilupp/deno-webview-chat-assistant
cd deno-webview-chat-assistant
deno task dev # interactive dev server
deno task compile # compile to an executable
```

Check out the [README](https://github.com/svilupp/deno-webview-chat-assistant) for more details on features, prerequisites, and building your app.

What you'll get is an app in a few minutes that you can distribute as a single executable file.
![App UI](/assets/deno_webview_template/screenshot.jpg)

It's a simple chat app that lets you talk to OpenAI in turns and reset the conversation. A great starting point for building your own apps!

# Conclusion

I'm excited about the potential of this template for quickly creating lightweight desktop applications for GenAI tasks that will be super easy to distribute. It's a great way to bridge the gap between the generality of LLMs and the needs of focused and performant local applications.
