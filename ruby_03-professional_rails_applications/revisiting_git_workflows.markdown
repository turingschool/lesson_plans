---
title: Revisiting Git Workflows
length: 90
tags: git, github, workflow, collaboration
---

## Learning Goals

* Understand some of the best practices for working collaboratively on software projects using Git and GitHub
* Learn to use GitHub's tools to review and discuss code
* Use a variety of techniques to create, track, and manage issues, bugs, and features
* Clean up and condense their commit history using `git rebase`

## Structure

* 10 - Warm Up and Discussion
* 15 - Full Group Instruction: Working with Github Issues and Waffle.io
* 5 - Break
* 10 - Full Group Instruction: Git Workflow and Code Reviews
* 15 - Group Activity: Code Review Simulation
* 5 - Break
* 5 - Full Group Instruction: Rebasing
* 5 - Individual Practice: Rebasing
* 10 - Team Activity: Workflow Discussion
* 10 - Wrap Up

## Warm Up

Start a gist with some of the common git-related issues encountered in your Dinner Dash projects and answer the following questions:

* What do you believe the root cause of some of these issues were?
* How did they impact your ability to work on the project?
* What solutions worked for you and your team?

## Full Group Instruction: Github Issues and Waffle.io

* Github has a number of useful keyboard shortcuts to help you navigate through a repository. Use the `?` key to see all of the shortcuts available on a given page.
* Issues are useful for stubbing out features and user stories. You can assign them and track progress towards a goal using milestones.
* In any file view, when you click one line or multiple lines by pressing SHIFT, the URL will change to reflect your selections. This is very handy for sharing the link to a chunk of code for discussion.
* If an issue involves a certain teammate, you can include their GitHub username (e.g. @stevekinney) and they'll be subscribed to that issue.
* In pull requests, issues or any comment, sha and issue number (#1 for example) will be automatically linked. Besides, you can link sha or issue number from another repository with the format of user/repo@sha1 or user/repo#1 respectively.

## Git Workflow and Code Reviews

When working on a team, it’s important to have a workflow. The details of the workflow will vary from team to team and company to company, but it's important that you have a workflow.

There are 5 steps to the collaborative Git workflow.

1. Create a branch
2. Add commits
3. Submit a pull request
4. Review and discuss code
5. Merge and deploy

It's useful to think of branches like Ruby methods: they should be small, have descriptive names and implement a single feature. Use branches for the small features that you can implement quickly.

When your feature is complete, don't just merge it into master—submit a pull request and let someone from your team review your code.

Having your code reviewed gives you confidence that your code is clear, that it runs on someone else's machine, and that it's not accidently causing an error somewhere else in the application. It's also an opportunity to allow a mentor to review the code you're writing and give you advice.

Reviewing a teammate's code allows you to be familiar with parts of the codebase that you may not have touched. It also provides context for how the code your writing in your branch fits into the larger app.

Tools for conducting a code review:

* Line comments on Github
* Discussion in Github Issues and Waffle.io

A pull request isn’t the final word. You can always add to it based on feedback.

## Activity: Workflow Simulation

Using an example repository, we're going to go through the workflow as a group.

* 5 students will implement features outlined in issues on the repository.
* 5 students will review the code when the previous students submit a pull request.
* The remaining students will discuss the issue and provide thoughts on how to implement it.

## Full Group Instruction: Git Rebase

`git rebase` allows you to easily change a series of commits, modifying the history of your repository.

Because changing your commit history can make things difficult for everyone else using the repository, it's considered bad practice to rebase commits when you've already pushed to a repository.

You can rebase against another branch using `git rebase -i <other_branch_name>`.

You can also rebase against another point in time:

* `git rebase -i commit_sha`
* `git rebase -i HEAD^`
* `git rebase -i HEAD~7`

The caret stands for one commit back from `HEAD`. You can use multiple carets (e.g. `HEAD^^^^^`) or you can specify the number of commits back you want to rebase from using `~`.

The `-i` flag stands for "interactive mode".

When rebasing, you'll have the ability to combine ("squash") and reword commits.

## Independent Practice: Git Rebasing

Create a branch on a repository and make a few commits.

1. Use `git rebase -i master` to squash all of the commits into one.
2. Use `git rebase -i master` to reword that commit.

## Group Workflow Discussion

In your project groups, discuss your current workflow, its pain points, and what you'd like to improve. Come up with the procedures for conducting code reviews before merging into master.

## Wrap Up

Each group shares details about the workflow they plan on executing for The Pivot project.

Individually, revisit your Gist from earlier:

* What strategies could you use to avoid some of the workflow issues you faced earlier?
* What is one strategy you want to use with your group today?

## Corrections & Improvements for Next Time

By Steve on 9/10/14

* I made game time decision to define roles for each park of the process (e.g. discussing the issue up front, implementing the feature, conducting the code review). This encouraged participation during the code review simulation and I think should be included in the lesson proper.
