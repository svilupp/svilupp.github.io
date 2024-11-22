@def title = "Building a Real-Time Voice Assistant with OpenAI and Vue.jl"
@def published = "22 February 2024"
@def drafted = "22 February 2024"
@def tags = ["generative-AI", "openai", "vue", "realtime", "voice"]

# TL;DR
Building voice assistants is now surprisingly accessible with OpenAI's real-time API, but there are some sharp edges to watch out for. Here's a working example to get you started.

\toc

![Voice Agent Vue Demo](assets/openai_realtime_vue/voice-agent-vue-demo.png)

## The Promise of Real-Time AI

I wanted to build a quick demo to show a friend how simple it is to create an AI assistant. Armed with OpenAI's API and Cursor, I expected a 10-minute project - in the end it took more than 2 hours of trying and failing.

## The Journey: Unexpected Sharp Edges

What seemed straightforward revealed several technical challenges. The first attempt using a single HTML file failed due to browser security restrictions - you can't directly call external APIs from client-side JavaScript. This meant needing a proxy server to handle the OpenAI API calls, which introduced additional complexity.

The audio processing brought its own set of challenges. Browser implementations of audio APIs vary, and handling real-time audio streams properly requires careful consideration of sampling rates, buffer sizes, and timing. The WebSocket connections needed for real-time communication added another layer of complexity.

Even with a proxy in place, routing the audio stream efficiently while maintaining a responsive interface proved tricky. The real-time nature of the application meant that any latency in the audio processing pipeline would directly impact the user experience.

## The Solution

The breakthrough came from OpenAI's beta repository, which provided utilities that handled most of these challenges out of the box. This simplified the implementation significantly.

## The Final Product

The result is a straightforward example that demonstrates real-time AI interaction. The application offers:
- Real-time voice interaction with OpenAI's models
- Customizable assistant instructions
- The ability to restart and experiment with different behaviors
- A clean, intuitive interface

## Key Learnings

1. Real-time AI applications require careful consideration of audio processing and streaming
2. Browser security restrictions necessitate proper backend infrastructure
3. OpenAI's utility functions are essential for handling edge cases
4. The ability to modify instructions on the fly makes experimentation much more engaging

## What's Next?

This simple example opens up possibilities for various applications - from custom assistants to interactive learning tools. The code is available on [GitHub](https://github.com/svilupp/voice-agent-vue), ready for you to experiment with and build upon.

Whether you're looking to create your own assistant or just curious about real-time AI interactions, this implementation provides a solid foundation to start from.

## References

- [OpenAI Real-Time API Documentation](https://platform.openai.com/docs/guides/realtime/realtime-api-beta)
- [OpenAI Real-Time API Utils](https://github.com/openai/openai-realtime-api-beta/tree/main)
- [Voice Agent Vue Demo](https://github.com/svilupp/voice-agent-vue)
