@def title = "The Best Dictation App? The One You Build Yourself"
@def published = "9 December 2024"
@def tags = ["iOS","Swift","GenAI","generative-AI","Apps"]

![Memsieve Artwork](/assets/memsieve_ios_app/artwork.png)

## TL;DR
I've built [MemSieve.app](https://github.com/svilupp/ios-memsieve-app), an iOS dictation app that combines offline-first recording with OpenAI-powered transcription and text processing. It's a practical example of how GenAI enables developers to build personalized tools rather than relying on subscription-based alternatives.

\toc

Picture this: You're walking through central London, developing some ideas while talking to OpenAI's Advanced Voice Mode. Just as you reach your key point, you pass between tall buildings, your signal drops for a split second, and poof – your entire session vanishes. Sound familiar?

## Why Build Your Own App?
The market is flooded with voice memo apps, many demanding £20 monthly subscriptions for features you might never use. But here's the thing – if you already have an OpenAI API key, you're just a simple app wrapper away from having exactly what you need. No bloat, no subscriptions, just functionality tailored to your requirements. 

While Apple's built-in text-to-speech capabilities are decent for basic English, they struggle with technical terminology, code snippets, and foreign words – making them unsuitable for developers or multilingual users. This limitation alone justifies building a custom solution.

## The Future is Personal
We're entering an era where the best software isn't what you can buy – it's what you can create for yourself. GenAI is democratizing software development, making it possible for anyone with a clear need and determination to craft their perfect tool. This shift isn't just about coding; it's about rethinking how we solve our software needs.

## What I Actually Built
My app, [MemSieve](https://github.com/svilupp/ios-memsieve-app), is deliberately simple but powerful: high-quality asynchronous transcription combined with the power of large language models for text transformation (powered by OpenAI, my prompts and API keys that I already have). 

Key features include:
- Smart presets that automatically format your transcriptions (eg, bullet points or structured thoughts with headings)
- Offline-first recording that works reliably in network dead zones or on the tube
- Customizable context to improve transcription accuracy for technical terms and personal vocabulary
- Seamless import from Apple Voice Memos
- AI-powered text editing for quick refinements and reformatting
- Flexible export options for sharing and integration with other tools

The focus was on creating a robust, offline-first foundation while maintaining the ability to leverage cloud AI when needed. No unnecessary bells and whistles, just the features that make dictation truly useful for developers and technical users.

Btw. the name "MemSieve" is inspired by the Pensieve – a magical device used to store and review memories. Like its magical counterpart, MemSieve helps you capture and sift through your thoughts, making them easier to review and organize later. Instead of silvery memory strands, we use voice recordings and AI to preserve and process your ideas. The "sieve" part reflects the app's ability to filter and transform raw thoughts into structured, useful content with the help of AI.

## Development Experience
Despite never having touched Xcode before, the journey from idea to working app was surprisingly manageable. The secret? Breaking everything down into small, testable steps and leveraging GenAI tools for guidance.

## Practical Tips for Your Journey
1. **Development Environment Setup**
   - Use Cursor as your IDE
   - Leverage Claude 3.5 Sonnet for code completion and problem-solving
   - Keep Git at the core of your workflow

2. **Working with GenAI**
   - Start with clear specifications using tools like OpenAI's o1 (but start simple!!)
   - Use Perplexity for researching API changes and updates
   - Break complex problems into smaller chunks for better AI assistance

3. **Testing and Iteration**
   - Test in real-world conditions early (constantly re-run and pass the errors to Cursor to fix)
   - Focus as few files as possible to reduce potential retrieval errors
   - Always verify functionality before moving to the next feature (do not try to do several things at once)

The result isn't just a working app – it's proof that we're entering an age where personal software development is accessible to anyone willing to learn. When the perfect solution doesn't exist in the App Store, maybe it's time to build it yourself.

Want to explore the app or learn more about the development process? Check it out at [Memsieve.app](https://github.com/svilupp/ios-memsieve-app).

![Recording View](/assets/memsieve_ios_app/recording_view.png)
![Transcription View](/assets/memsieve_ios_app/transcription_view.png)

*This post is part of a series exploring practical applications of GenAI in personal software development.*