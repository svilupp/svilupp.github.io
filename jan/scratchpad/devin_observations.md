@def title = "Devin: Initial Observations"
@def published = "24 November 2024"
@def tags = ["Agents", "Devin", "Software Development",]

# TL;DR
After putting Devin through its paces, it's great for coding on-the-go, debugging APIs, and Git stuff. You need to keep it on a short leash though - it's not faster than coding yourself, but it can take some weight off your shoulders for certain tasks.

\toc 

# Devin: What's the Deal?

After spending 50+ hours with Devin across various projects (20+ PRs, 1000+ commits), here's what I've learned about what it can and can't do. While I've had access for several months, I never really invested the time to learn how to use it effectively until I was on vacation without my laptop - necessity turned out to be the mother of adoption!

## What's Devin Anyway?

Think of Devin as a team of AI processes working together, not just one bot. It's got a chat interface that syncs up with its coding engine, and it loves making detailed plans for everything it does. It has an excellent UI with tonne of tools to make the development experience easier to supervise and intervene when necessary.

The UI splits into the chat interface on the left and the Devin's progress on the right.
![Devin UI](/assets/devin_observations/devin2.jpg)

You can easily track the changes Devin makes (IMPORTANT! Do that!) in the global diff view or in the Devin's window in "Editor" mode.

![Global Diff View](/assets/devin_observations/devin3.jpg) 

![Devin's Editor](/assets/devin_observations/devin5.jpg) 

You can see how Devin works hierarchically in the "Planner" view. It keeps making and updating its plan as it goes. In addition, for any bigger tasks, it creates a lot of TODO files to keep track of the progress.
![Devin's Planner](/assets/devin_observations/devin4.jpg) 

Note: It evolves quickly and has introduced a few new features just in the past two weeks! It might look a bit different when you use it.

## Where It Really Shines

While Devin won't necessarily speed up your coding if you're already using IDE like Cursor, it's awesome for:
- Making quick fixes while you're out and about
- Patching open source libraries
- Managing Git and terminal stuff like a pro
- Digging into API issues / getting stuff to just "work" (it might not be the solution you'd like though)
- Writing extra tests to increase coverage / fix CI issues
- Implementing a small package from an idea you have (to see what it would look like)

## Real Talk: Building ChromeDevToolsLite.jl

Here's a real example of working with Devin:

1. **First Try**
   - Create a PkgTemplate (much more robust), ask o1 for full specification for a junior engineer
   - Ask it to build iteratively and test on examples
   - Let it run wild for 10+ hours
   - Result: Way too complicated (basically a clone of Playwright)! Cannot be maintained.

2. **Take Two**
   - Scaled back my goals
   - Hit some roadblocks with WebSockets
   - Asked to produce a simple HTTP-only version (to see what I'd lose)

3. **Third Time's the Charm**
   - Used "dialog engineering" with Claude to get the basics straight and build a working version
   - Gave Devin the specification and the snippet from Claude
   - Introduced proper testing with a headless version of chromium in the CI to ensure independent checks
   - Built it up piece by piece - much better! Sometimes jump in and make manual edits to speed it up or maintain some abstraction I like.

Biggest regret? Scope-creep! It was too easy to code, so I kept adding more and more functionality but then had to jump in to keep it on track (~2 hours of manual fixing overall).

Overall, I'm impressed with Devin's capabilities and how much it can take off your plate. Without Devin, I wouldn't have ever started the project in the first place -- it would be too daunting.

## The Good, The Bad, and The Quirky

**What Works:**
- Git operations are smooth as butter
- Great at solving small problems (though sometimes overthinks them)
- Killer at API debugging
- Awesome progress tracking

**What's Tricky:**
- Loses its memory after ~10 minutes
- Can write messy code when stuck ("whatever it takes to pass")
- Sometimes "fixes" tests by changing them instead of the actual code
- Writes twice as much code as needed, often "duplicates" existing functionality while fixing problems
- Can be stubborn about changes (and keeps introducing some pattern you don't like)

**The Bottom Line:**
- Not necessarily faster than coding yourself
- Needs babysitting
- Great for reducing mental load (!!)
- Makes development on the move actually doable
- More fun than traditional coding (supervising vs. writing)

## Current Quirks and Limits

- Gets lost in big refactoring jobs (lost some files in the process)
- Creates random helper files you don't need and often syncs them with the PR
- Can change your code's interface without telling you
- UI occasionally bugs out (both on mobile and desktop)

## The Verdict

Devin's a game-changer for coding on the move and specific tasks like API work or quick patches. While it might not make you code faster, it makes the whole process more flexible and enjoyable. The key is knowing when to use it and how to keep it on track. Be very specific when you know what you want, keep close supervision when you don't.

Note: This is based on Devin Lite - the paid versions might be different. I'd pay a lot to have Devin try multiple approaches in parallel (you can do it manually today but it's clunky).
