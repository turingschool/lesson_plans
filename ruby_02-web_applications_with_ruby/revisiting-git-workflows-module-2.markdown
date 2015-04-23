---
title: Revisiting Git Workflows
length: 120
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

Start a public gist and make some notes about git-related issues you encountered in your recent projects. Answer the following questions:

* Find an example commit from your Traffic Spy project which was dealing
  exclusively with a Git problem rather than a feature or bugfix (e.g.
"Fix merge commit", "Really add file...", "Merge master multiple times
in a row", etc)
* What do you believe the root cause of some of these issues were?
* How did they impact your ability to work on the project?
* What solutions worked for you and your team?

## Github efficiency techniques

As developers, we often use github as much as some of our other
development tools (editors, command-line-tools, etc). It's worth
investing a little time in getting familiar with the interface so you
can navigate it more efficiently.

* Github has a number of useful keyboard shortcuts to help you navigate through a repository. Use the `?` key to see all of the shortcuts available on a given page.
* On a repository view the `t` command brings up a "fuzzy find" UI for
  finding files easily.
* The `history` view for a given file allows you to see what commits
  touched that file and in what order
* The `blame` view lets you see who last touched a given line in a file.
* When viewing a file, the `y` key lets you get the "canonical url" to
  that file, which can be useful to link to the current state of a file
  even if it changes in the future.
* Clicking line-numbers of a file in the file-view allows you to link to
  a specific line or range of lines of that file. Useful for calling a
  teammate's attention to a specific chunk of code.

## Github Issues and Waffle.io

Ultimately a Git workflow is just one part of your overall team
collaboration process. Git let's you move project work into the final
source code, but deciding what to work on and when is also an important
part of the process.

Let's briefly look at a process for doing this using Github Issues and
Waffle.io.

* Issues are useful for stubbing out features and user stories. You can assign them and track progress towards a goal using milestones.
* In any file view, when you click one line or multiple lines by pressing SHIFT, the URL will change to reflect your selections. This is very handy for sharing the link to a chunk of code for discussion.
* If an issue involves a certain teammate, you can include their GitHub username (e.g. @stevekinney) and they'll be subscribed to that issue.
* In pull requests, issues or any comment, sha and issue number (#1 for example) will be automatically linked. Besides, you can link sha or issue number from another repository with the format of user/repo@sha1 or user/repo#1 respectively.

## Activity: Issue Creation and Assignment

We'll use this simple example git repository for the next few exercises:
https://github.com/worace/my-first-gitastrophe.

For now just follow along, but shortly you'll need to create a fork of
the repository and work on some simple "features."

I'd like you to each add yourself to a "roll call" process in the
repository, so I'll create issues for each person to add themselves.

## Git Workflow

When working on a team, it’s important to have a workflow. The details of the workflow will vary from team to team and company to company, but it's important that you have a workflow.

Here's a basic but relatively standard workflow that you'll encounter
across many teams:

1. Create a branch
2. Add commits
3. Submit a pull request
4. Review and discuss code
5. Merge and deploy

It's useful to think of branches like Ruby methods: they should be small, have descriptive names and implement a single feature. Use branches for the small features that you can implement quickly.

When your feature is complete, don't just merge it into master—submit a pull request and let someone from your team review your code.

## Github and Code Reviews

Having your code reviewed gives you confidence that your code is clear, that it runs on someone else's machine, and that it's not accidently causing an error somewhere else in the application. It's also an opportunity to allow a mentor to review the code you're writing and give you advice.

Reviewing a teammate's code allows you to be familiar with parts of the codebase that you may not have touched. It also provides context for how the code your writing in your branch fits into the larger app.

Tools for conducting a code review:

* Line comments on Github
* Discussion in Github Issues and Waffle.io

__WIP Pull Request:__ A pull request isn’t the final word. You can always add to it based on feedback, so it can be a useful collaboration tool for code that's still "under development." Many teams will call this a "WIP" PR and sometimes will mark it with a special label (to make sure it doesn't accidentally get merged).

## Activity: Workflow Simulation

Let's work through an exercise now to add some simple "code" for each of
us into the my-first-gitastrophe repo.

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

## Notes / Corrections & Improvements for Next Time

* this lesson is a slightly tweaked extraction of a similar lesson
  originally delivered in [module
3](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/revisiting_git_workflows.markdown).
Since I wanted to tweak some of the project-specific language I decided
to make a duplicate rather than mess with the original. - Horace


