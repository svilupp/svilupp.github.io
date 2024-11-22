+++
title = "Devin Wishlist: Features for the Future"
published = "22 March 2024"
tags = ["devin", "features", "wishlist"]
+++

# Devin Wishlist: Features for the Future

TL;DR: Better mobile UI, voice input, and simpler knowledge management would make Devin much more useful.

## Mobile UI

The mobile interface needs work, and here's why: I do most of my Devin work on mobile because that's where it's most valuable - when I can't use my regular dev setup. The current UI makes this harder than it needs to be. Buttons are small, navigation is tricky, and the conversation sometimes disappears. A better mobile UI would make Devin truly useful for on-the-go coding.

## Voice Input

- Add voice commands: Typing long instructions on a phone is slow and error-prone
- Let us explain changes by talking: Would be much faster than typing on mobile
- Would make mobile use easier: Could code while walking or in situations where typing isn't practical
- Better for complex explanations: Some code changes need detailed context that's tedious to type

## Better Control

- Add a pause button: Right now, Devin starts working as soon as you hit enter
- Stop rushing to process each line: On mobile, every enter press sends the message
- Let us type multiple instructions: Need to explain complex changes in one go
- Mobile sends too quickly on enter: Makes it hard to write multi-line instructions
- Need time to think: Sometimes I want to draft my thoughts before Devin starts working

## Planning Tools

- Make planning easier to start: Currently requires specific prompts
- Clean up plan files from PRs: These files often end up in commits when they shouldn't
- Show thinking process more clearly: Would help catch wrong assumptions early
- Keep track of progress: Easy to lose track in long sessions
- Help prevent drift: Better planning would stop Devin from going off track

## Save Our Setup

- Keep development setup between uses: Tired of installing Julia every time
- Add container support: Would make environment more reliable
- Start faster with common tools ready: Save time on setup
- Remember things like Julia version: Most of my projects use the same setup
- Save common configurations: Would make starting new sessions much faster

## Fix Knowledge System

- Let us turn off auto suggestions: They get in the way when code changes
- Add bulk actions for snippets: Currently have to handle each one separately
- Handle old knowledge better: Outdated snippets cause confusion
- Focus on how we solve problems: Remember patterns, not just specific code
- Easier to update: When code changes, knowledge should too
- Better organization: Group related knowledge together

## Code Changes

- Better at moving code around: Currently introduces subtle bugs
- Handle imports better: Often misses dependencies
- More reliable file cleanup: Temporary files stick around
- Remove temporary files properly: Analysis files shouldn't be in PRs
- Track file changes better: Sometimes loses track of what changed

## Fix Common Problems

- Make snippet handling easier: Currently requires too many clicks
- Keep track of state better: Sometimes forgets previous context
- Show conversations clearly: Messages sometimes disappear
- Track progress reliably: Progress view often stops working
- Fix editor tab issues: Hard to switch between views
- Better error handling: More clear about what went wrong
- Improve navigation: Finding old messages is hard

## Testing

- Report test results accurately: Sometimes claims tests pass when they don't
- Show CI results clearly: Need better integration with CI systems
- Better error messages: More specific about what failed
- Check code removal properly: Verify deleted code is really gone
- Track test history: Show what changed between runs
- Highlight test regressions: Show when changes make things worse

These improvements would make Devin more practical for daily use, especially on mobile. Each one addresses a specific pain point I've hit while using it for real work.
