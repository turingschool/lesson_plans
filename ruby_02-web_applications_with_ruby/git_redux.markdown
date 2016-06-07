---
title: Git Redux
length: 120
tags: git, github, workflow, collaboration
---

## Learning Goals

* use interactive rebase to rewrite history by squashing and/or modifying commits
* navigate GitHub using keyboard shortcuts
* demonstrate git workflow in teams
* review and discuss code using GitHub's tools (pull requests, line comments)
* write complete documentation using commit messages and pull requests 

## Lesson

### Warmup: Ace Ventura Git Detective

Learning to search git for specific info is incredibly useful when you are working on large projects. In your teams, take 5-10 minutes to do the following: 

1. Clone down the source code for [bundler](https://github.com/bundler/bundler).
2. Do some Googling to figure out how to view the git log by author. Katrina Owen has one commit in the project. Find it. 
3. What change was made? Why?
4. Find all commits referencing "rubocop" (case insensitive) in the commit message. 

### Team Research

#### Person 1:

* What are some rules of thumb for proper commit messages? Write a gist of rules you can share with your team. 
* Search some popular open source repositories to find two examples of "good" commit messages. Link to those commit messages in your gist. 

Resources:

* [http://chris.beams.io/posts/git-commit/](http://chris.beams.io/posts/git-commit/)
* [https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message](https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message)

#### Person 2:

Research what each of these Git commands will do. Create a gist that you can share with your team. 

* git stash
* git stash apply
* git shortlog
* git commit --amend
* git reset --hard 
* git reset --soft
* git reset --hard HEAD~2
* Find three different ways to display the git log. One example is `git log --oneline`.

#### Person 3:

GitHub has keyboard shortcuts that increase efficiency when navigating around the interface. One example is pressing `t` in a repository which will bring up a file finder. 

What other keyboard shortcuts might be helpful when navigating on GitHub? Create a gist with descriptions of ~8 of the most helpful shortcuts you can share with your team. Try them out to make sure they work :) 

#### Whoever finishes first

Look at [thoughtbot's code review guide](https://github.com/thoughtbot/guides/tree/master/code-review) and GitHub's blog [How to Write the Perfect Pull Request](https://github.com/blog/1943-how-to-write-the-perfect-pull-request). 

### Git Workflow Review

When working on a team, it’s important to have a workflow. The details of the workflow will vary from team to team and company to company, but it's important that you have a workflow.

Below is GitHub's workflow. Most teams will do something similar. 

1. Anything in the master branch is deployable
2. To work on something new, create a descriptively named branch off of master (ie: new-oauth2-scopes)
3. Commit to that branch locally and regularly push your work to the same named branch on the server
4. When you need feedback or help, or you think the branch is ready for merging, open a pull request
5. After someone else has reviewed and signed off on the feature, you can merge it into master
6. Once it is merged and pushed to ‘master’, you can and should deploy immediately

It's useful to think of branches like Ruby methods: they should be small, have descriptive names and implement a single feature. Use branches for the small features that you can implement quickly.

__WIP Pull Request:__ A pull request isn’t the final word. You can always add to it based on feedback, so it can be a useful collaboration tool for code that's still "under development." Many teams will call this a "WIP" PR and label it as such (to make sure it doesn't accidentally get merged).

Having your code reviewed gives you confidence that your code is clear and that it's not accidently causing an error somewhere else in the application. It's also an opportunity to allow a mentor to review the code you're writing and give you advice.

Reviewing a teammate's code allows you to be familiar with parts of the codebase that you may not have touched. It also provides context for how the code your writing in your branch fits into the larger app.

Tools for conducting a code review:

* Line comments on GitHub
* Discussion in GitHub Issues and Waffle.io

Take a look at [this GitHub blog post](https://github.com/blog/1943-how-to-write-the-perfect-pull-request) for more tips on writing a pull request, reviewing code, and responding to feedback. 

### Using Interactive Rebase

The master branch of your team's project should be as pristine as possible. Take a look at [this repo](https://github.com/kristinabrown/dinner-dash/commits/master?page=5) and find commits that probably shouldn't have made it into the master branch. 

"WIP" commits or style changes should *not* be merged into master. When rebasing, you'll have the ability to combine ("squash") and reword commits.

* DO NOT REBASE MASTER (or anthing that anyone else already has been distributed to other team members)
* git rebase -i HEAD~3
* commits ordered bottom (most recent) to top (least recent)
* you'll need to force push to your branch since the commit SHA changes
* selecting "s" for a certain commit will squash it together with the previous commit (the one above it)
* watch carefully to see if you are in a detached head state
* git rebase --abort will abort the rebase without consequences

`git rebase` allows you to easily change a series of commits, modifying the history of your repository.

Because changing your commit history can make things very difficult for everyone else using the repository, it's bad practice to rebase commits when you've already pushed to a repository.

You can rebase against a point in time:

* `git rebase -i commit_sha`
* `git rebase -i HEAD^`
* `git rebase -i HEAD~7`

The caret stands for one commit back from `HEAD`. You can use multiple carets (e.g. `HEAD^^^^^`) or you can specify the number of commits back you want to rebase from using `~`.

The `-i` flag stands for "interactive mode".

Let's look at an example rebase. 

## Practice: Git Rebasing, Commit Messages, and Code Reviews

Clone down [this repo](https://github.com/turingschool-examples/git-rebase)

Check out a branch `items-index-view-your-NAME`. 

1. Generate an `item` model, migrate, and commit.  
2. Push the branch to GitHub and open a WIP pull request. 
3. Add a route for the items index. Make an items_controller with an index action and commit. Push to your branch. 
4. Make an index view for the items and commit. Push to your branch. 
5. Check to make sure everything is working properly by making a few items in the rails console, then start up the server and navigate to `/items`. If you need to make any changes, do that and commit. Push to your branch. 
6. Squash the commits you made into one commit. Make sure to use proper commit message format (subject line + description). Push to your branch. 
7. Remove "[WIP]" from your pull request. 
8. Take a look at one other person's pull request and make comments on it. 

### Takeaways

What did you learn that you didn't already know? 

### Other resources:

* [Here](https://www.atlassian.com/git/tutorials/merging-vs-rebasing/) is a great tutorial about the details of rebaseing vs merging. 
* [This post is about the golden rule of rebaseing](https://medium.freecodecamp.com/git-rebase-and-the-golden-rule-explained-70715eccc372#.3nkd2p6c8)
