+++
title = "Devin: Initial Observations"
published = "2024-11-24"
tags = ["AI", "Devin", "Software Development", "AI Agents"]
rss = "Real-world observations and insights from extensive usage of Devin, the AI software engineer"
+++

# Devin: Initial Observations

After 30+ hours of runtime working with Devin across various projects, I've gathered significant insights into its capabilities, limitations, and optimal usage patterns. This post shares my journey from initial skepticism to finding an effective workflow that leverages Devin's strengths.

## What is Devin?

Devin is an AI system designed to function as a software engineer, but it's important to understand what that really means. It's not just one agent, but rather multiple parallel and hierarchical processes working together. The conversation interface is independent of the problem-solving engine, and they sync up regularly when the execution engine "yields". The planning and progress tracking is highly hierarchical, organized around a master plan while solving current steps within that framework.

## Key Value Proposition

While Devin might not make you more productive if you can sit at your computer and use an LLM-powered workflow (e.g., Cursor), it shines in specific scenarios:
- Perfect for making small contained changes while on the move
- Excellent for patches in open source libraries
- Extraordinary at workflow management and Git operations
- Powerful for API debugging and analysis

## Case Study: Building ChromeDevTools.jl

Let me illustrate Devin's capabilities through a real project - developing a Chrome DevTools Protocol package for Julia. This journey showcases both Devin's strengths and the importance of proper task structuring:

1. **Initial Approach**
   - Started with simple specifications
   - Let Devin work for 24 hours with an iterative example-by-example approach
   - Result: Built something close to Playwright's scope - too complex

2. **Course Correction**
   - Simplified the approach
   - Struggled with WebSocket implementation
   - Launched separate HTTP-only version to evaluate trade-offs

3. **Final Solution**
   - Used Claude to understand CDP and Playwright's approach
   - Passed minimal example to Devin
   - Successfully implemented and verified examples one by one

This project demonstrated how Devin works best with gradual, iterative development rather than attempting complete solutions in one go.

## Key Observations

1. **Problem Solving**
   - Excellent at workflow and Git operations
   - Strong problem-solving capabilities but tends to overcomplicate solutions
   - Struggles with abstracting and reusing functionality without explicit interface definitions
   - Produces a lot of dead code during iterations

2. **Code Quality**
   - Can "drift" during long sessions, especially when fixing test failures
   - May create spaghetti code in desperate attempts to fix errors
   - Often writes more code than needed
   - Can be stubborn about making requested changes

3. **Testing and Verification**
   - Sometimes misreports test success
   - May fix tests by changing them rather than fixing the underlying issue
   - Excellent at API debugging with comprehensive logging and analysis

4. **Context Management**
   - Loses some history/context after about 10 minutes
   - Planning feature is excellent but can fail by adding new requests at the wrong point
   - Works best with regular check-ins and course corrections

## Productivity Impact

While I've generated 20+ PRs, 5 new packages, and thousands of commits over 50+ hours of interaction, the productivity equation isn't straightforward:
- Not necessarily faster than direct coding
- Requires significant oversight and course correction
- Value comes from reduced cognitive load and ability to work while mobile
- More enjoyable and effortless experience overall

## UI and Interaction

1. **Strengths**
   - Excellent progress tracking
   - Helpful file diff viewing
   - VS Code extension available
   - Good PR integration

2. **Pain Points**
   - Knowledge snippets management is cumbersome
   - Mobile interface limitations
   - Occasional UI bugs (disappearing conversation tab, progress viewing issues)
   - Sometimes requires window refresh to restore functionality

## Current Limitations

1. **Workflow Issues**
   - Code restructuring is challenging
   - Can create unnecessary helper files
   - May submit temporary files in PRs
   - Struggles with large-scale refactoring

2. **Development Challenges**
   - Can change interface types without notice
   - Creates unnecessary constructs
   - Can be stubborn about requested changes
   - Parallel processing potential remains unexplored

## Conclusion

Devin represents a significant step forward in AI-assisted development, particularly for mobile work and specific tasks like API debugging or patch development. While it may not always increase raw productivity, it offers a more flexible and enjoyable development experience. Success with Devin comes from understanding its strengths and limitations, and structuring work accordingly.

[Note: These observations are based on extensive usage of Devin Lite; more powerful paid versions may offer different capabilities]
