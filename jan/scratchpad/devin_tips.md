@def title = "Tips for Working with Cognition's Devin"
@def published = "24 November 2024"
@def drafted = "24 November 2024"
@def tags = ["AI", "Devin", "Software Development", "Best Practices"]

# TL;DR
[Devin](https://devin.ai) works best with incremental development and clear, focused tasks while requiring active monitoring to prevent implementation drift. Most effective for contained changes and log-heavy debugging, but watch for overcomplicated solutions and avoid using knowledge snippets.

\toc

# Tips for Working with Devin

After bunch of trial and error with Devin Lite, I've discovered that success comes from understanding its workflow patterns and adapting your approach accordingly. Here are the key lessons learned from over 50 hours of runtime experience and 1000+ commits.

## Essential Principles

1. **Progressive Development**
   - Start with small, contained tasks
   - Build complexity gradually
   - Verify each step before proceeding
   - Don't overwhelm with complex requirements upfront
   - Detailed PR descriptions often fail; prefer gradual tasks

2. **Clear Specifications**
   - Write specs separately in a notes app for easy formatting and reuse
   - Provide detailed docstrings with multiple examples
   - Define interfaces clearly to avoid over-complication
   - Consider using working snippets from other LLMs as starting points
   - For complex problems, create minimal examples with Claude/GPT-4 first

3. **Active Monitoring**
   - Request frequent reflections and summaries
   - Watch for "drift" in implementation
   - Be ready to course-correct early
   - Don't hesitate to rollback when needed

## Code Management Tips

1. **Knowledge Management**
   - Avoid using knowledge snippets entirely if possible
   - Be aware that old snippets persist across refactoring
   - Knowledge system is too specs-oriented rather than learning coding patterns
   - Rejecting snippets is tedious (can require multiple attempts per session)
   - Knowledge snippets can cause implementation drift in future sessions

2. **Code Quality**
   - Watch for dead code accumulation
   - Name specific code sections for removal
   - Often writes more code than needed with duplicate methods
   - Can overcomplicate solutions despite explicit simplification requests
   - May need manual cleanup of abstractions and interfaces

3. **Problem Solving**
   - When facing multiple failures, request written hypotheses
   - Use reflection files for problem analysis
   - Consider parallel solution attempts
   - Keep track of working states for potential rollback
   - Excellent at API debugging with systematic logging
   - Can be stubborn about making requested changes

## Project Management

1. **Task Structure**
   - Break down complex tasks
   - Maintain clear priorities
   - Document success criteria
   - Keep specs separate and well-formatted

2. **Version Control**
   - Review PR updates frequently
   - Prefer diff view in PRs (not all files might be pushed) or Global Diff View in Devin
   - Be cautious with test failures - may modify tests instead of fixing code
   - Watch for unintended file submissions (like reflection.md)
   - Excellent at Git workflows like restoring from diffs

3. **Testing Strategy**
   - Verify CI results independently - Devin may misreport test status
   - Watch for test modifications
   - Keep test scope focused
   - Test failures can cause implementation drift
   - May aggressively pursue fixing tests at cost of code quality

## Development On the Move

1. **Limitations**
   - GitHub workflow is challenging
   - Input can be tricky (Enter key sends messages)
   - UI navigation needs improvement (refresh if things disappear)
   - Progress tracking can be inconsistent
   - Missing some desktop features

2. **UI Issues**
   - Knowledge snippet management is cumbersome
   - Conversation messages sometimes invisible
   - Progress/editor views can hide conversation
   - Progress tracking can stop working
   - Some buttons disappear requiring refresh

## Conclusion

While Devin may not always increase raw productivity, it transforms the development experience by reducing cognitive load and enabling development from any device. Success comes from understanding its strengths (Git workflows, API debugging, systematic problem solving for "simpler" problems that require a lot of attempts) and limitations (UI issues, knowledge management, tendency to overcomplicate and duplicate code). The key is maintaining tight supervision while leveraging its capabilities for focused, incremental development.

Note: These tips are based on extensive usage of Devin Lite and may need adjustment for other versions.
