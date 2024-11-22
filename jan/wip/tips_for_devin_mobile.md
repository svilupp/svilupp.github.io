+++
title = "Tips for Using Devin on Mobile"
published = "22 March 2024"
tags = ["devin", "mobile", "tips"]
+++

# Tips for Using Devin on Mobile

TL;DR: Keep tasks small, be specific with instructions, and check progress often.

## Start With Small Steps

The biggest mistake I made when starting with Devin was trying to do too much at once. I'd write long, complex instructions about refactoring entire modules, only to watch Devin get lost in the details.

What works better is breaking tasks into small pieces. Instead of "refactor this module," start with "move this function to a new file." Once that's done, you can move to the next small change. This approach helps Devin stay focused and makes it easier to catch problems early.

## Be Crystal Clear

Devin is smart, but it can't read your mind. I learned this the hard way when I asked it to "make this code better." Without specific examples, Devin might add features you don't want or change things you wanted to keep.

The solution? Write clear instructions and include examples. Instead of "add error handling," say "add try-catch blocks around database calls and log errors to console." The more specific you are, the more likely you'll get what you want.

## Avoid Knowledge Snippets

This tip saved me hours of frustration: skip the knowledge snippets feature. While it seems helpful at first, these snippets cause problems when you're changing code. They're hard to remove later and often conflict with your updates.

I once spent an hour trying to get Devin to stop using an old approach because it was stuck on a knowledge snippet from earlier. Now I just say no to these snippets and provide information directly in my instructions.

## Watch Your PRs

Pull requests need careful handling with Devin. I check the diff view often and ask for regular updates. This might seem like extra work, but it's important because test failures can send Devin down the wrong path.

One time, a failing test caused Devin to add more and more complex fixes, making the code worse. Now I catch these issues early by watching the PRs closely.

## Getting Unstuck

When Devin seems stuck, I ask it to list possible causes of the problem. This simple technique has saved many coding sessions. Instead of watching Devin try the same failing approach repeatedly, I get it to write down its thinking.

This reflection often reveals wrong assumptions or missed requirements. Once those are clear, the solution usually becomes obvious.

## Keep Good Notes

I write my plans in a separate notes app before starting with Devin. This helps in two ways: I can easily edit my thoughts, and I can reuse instructions across different sessions.

This approach also helps me spot potential problems before they happen. When you write down "move authentication to a new service," you might realize you need to handle existing sessions first.

## Stay Connected

Regular check-ins are crucial. I ask Devin for updates often and get summaries of completed work. This isn't about not trusting Devin - it's about catching misunderstandings early.

Without these check-ins, I once let Devin work for 30 minutes only to find it had gone in a completely different direction than intended. Now I know that quick, frequent checks save time in the long run.

## Clean As You Go

Code cleanup is important but needs to be explicit. Tell Devin exactly which parts of the code to remove, using file names and function names. Just saying "remove unused code" isn't enough - Devin needs specific targets.

I keep a list of code sections that need removal and share it with Devin. This prevents old code from piling up and makes the codebase cleaner.

These tips come from real experience using Devin. They've helped me avoid common problems and get more value from this tool. Remember: the key is to work with Devin like you would with a smart but literal-minded colleague who needs clear, specific instructions to do their best work.
