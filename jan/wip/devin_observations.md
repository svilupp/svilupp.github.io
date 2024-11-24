@def title = "Devin: Initial Observations"
@def published = "2024-11-24"
@def tags = ["Agents", "Devin", "Software Development",]

# TL;DR
After putting Devin through its paces, it's great for coding on-the-go, debugging APIs, and Git stuff. You need to keep it on a short leash though - it's not faster than coding yourself, but it can take some weight off your shoulders for certain tasks.

\toc 

# Devin: What's the Deal?

After spending 50+ hours with Devin across various projects (20+ PRs, 1000+ commits), here's what I've learned about what it can and can't do. While I've had access for several months, I never really invested the time to learn how to use it effectively until I was on vacation without my laptop - necessity turned out to be the mother of adoption!

## What's Devin Anyway?

Think of Devin as a team of AI processes working together, not just one bot. It's got a chat interface that syncs up with its coding engine, and it loves making detailed plans for everything it does. It has an excellent UI with tonne of tools to make the development experience easier to supervise and intervene when necessary.

TODO: add screenshots of editor etc.

## Where It Really Shines

While Devin won't necessarily speed up your coding if you're already using tools like Cursor, it's awesome for:
- Making quick fixes while you're out and about
- Patching open source libraries
- Managing Git stuff like a pro
- Digging into API issues

## Real Talk: Building ChromeDevTools.jl

Here's a real example of working with Devin:

1. **First Try**
   - Started simple
   - Let it run wild for 24 hours
   - Result: Way too complicated!

2. **Take Two**
   - Scaled back our goals
   - Hit some roadblocks with WebSockets
   - Tried a simpler HTTP version first

3. **Third Time's the Charm**
   - Used Claude to get the basics straight
   - Gave Devin a simple example
   - Built it up piece by piece - much better!

## The Good, The Bad, and The Quirky

**What Works:**
- Git operations are smooth as butter
- Great at solving problems (though sometimes overthinks them)
- Killer at API debugging
- Awesome progress tracking

**What's Tricky:**
- Loses its memory after ~10 minutes
- Can write messy code when stuck
- Sometimes "fixes" tests by changing them instead of the actual code
- Writes more code than needed
- Can be stubborn about changes

**The Bottom Line:**
- Not necessarily faster than coding yourself
- Needs babysitting
- Great for reducing mental load
- Makes mobile development actually doable
- More fun than traditional coding

## Current Quirks and Limits

- Gets lost in big refactoring jobs
- Creates random helper files you don't need
- Can change your code's interface without telling you
- Mobile interface could use some work
- UI occasionally bugs out

## The Verdict

Devin's a game-changer for coding on the move and specific tasks like API work or quick patches. While it might not make you code faster, it makes the whole process more flexible and enjoyable. The key is knowing when to use it and how to keep it on track.

Note: This is based on Devin Lite - the paid versions might be different.
