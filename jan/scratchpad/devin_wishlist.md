@def title = "Devin: Feature Wishlist"
@def published = "24 November 2024"
@def drafted = "24 November 2024"
@def tags = ["AI", "Devin", "Software Development", "Future"]
@def rss = "A practical wishlist of improvements based on extensive usage of Devin"

# TL;DR

While Devin offers an impressive suite of development tools and an innovative UI, persistent bugs and stability issues (especially in the mobile experience) currently hamper its otherwise remarkable potential.

\toc

# Devin: Feature Wishlist

After extensive use of Devin across various projects, I've compiled a wishlist of improvements that could take this already impressive AI engineer to the next level. While Devin shows incredible promise, there are several key areas where enhancements could significantly improve the development experience.

## Core UI and Session Management

**Key Points:**
- Fix persistent UI glitches (disappearing progress bars or icons, jumping text, infinite scrolls)
- Add ability to pause/resume Devin without termination
- Support "dialog engineering" breaks during active sessions (like with Claude)
- Improve context retention across interruptions

The most immediate pain points revolve around UI reliability and session control. The interface occasionally exhibits frustrating glitches that, while minor, add friction to the development process. Progress bars vanish mid-task, text unexpectedly jumps during scrolling, and markdown rendering can be inconsistent. More critically, there's currently no way to temporarily pause a session for dialog engineering without completely terminating it. The ability to take a "thinking break" while keeping the session's context intact would be transformative for complex problem-solving scenarios.

## Model Capabilities

**Key Points:**
- Option to use more powerful models for complex tasks
- Support parallel solution attempts with different approaches
- Allow "upgrading" model mid-session for challenging problems
- Implement quality-based solution selection

Devin would benefit enormously from the option to leverage more powerful models for particularly challenging tasks. Imagine being able to spawn parallel solution attempts with different approaches, or "upgrade" to a more capable model mid-session when facing a particularly thorny problem. This could be combined with automated quality assessment to select the most promising solution path, similar to how human developers often explore multiple approaches before settling on the best one.

## Development Environment

**Key Points:**
- Add persistent tool installations across sessions
- Create integrated scratchpad for isolated debugging (with LLM access)
- Enhance snapshot management

The development environment itself needs some quality-of-life improvements. While the current workspace is functional, persistent tool installations and better Docker container support would eliminate common friction points. An integrated scratchpad for isolated debugging would be particularly valuable - being able to take a minimal working example "out" of the main context to iterate on it separately would mirror how developers actually work through problems. Online VSCode editor gets close, but it doesn't have LLM integration. Better snapshot management would allow for more confident experimentation (it takes 5+ minutes to rewind to the previous state -- that's not useful for most small problems).

## Mobile Experience

**Key Points:**
- Optimize UI for touch interfaces
- Add Whisper integration for voice input
- Better handle multi-line inputs (immediately sends)

Mobile support, while impressive for an AI developer, has room for growth. Touch interface optimization and better handling of multi-line inputs would make on-the-go development more practical. Voice input via Whisper integration could be a game-changer for mobile usage, allowing developers to describe problems and requirements naturally while away from their desk.

## Future Potential

**Key Points:**
- Enhance parallel processing with quality-based selection
- Improve architectural reasoning capabilities (or perhaps manual plan updates!)
- Implement smarter resource management

Looking toward the future, the potential for enhanced parallel processing is exciting. Improved architectural reasoning capabilities and smarter resource management could help Devin tackle even larger, more complex projects effectively. Maybe if I could manually update the plan, I could steer it away from a dead-end. The ability to leverage different specialized models for different aspects of a problem could lead to more robust and creative solutions.

## Conclusion

While Devin is already a powerful tool, these improvements would address the main friction points encountered in daily use. The focus is on practical enhancements that would make the tool more reliable and efficient, particularly for complex projects that require deep problem-solving capabilities. The ability to pause sessions for dialog engineering, combined with more robust UI and model capabilities, would significantly enhance the development experience.

Note: This wishlist is based on experience with Devin Lite; some features may already exist in other versions.
