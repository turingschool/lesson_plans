---
title: Small Team Git Workflow & More Advanced Git
length: 90
tags: git, github, workflow, collaboration
---

## Learning Goals

* Understand some of the best practices for working collaboratively on software projects using Git and GitHub
* Learn to use GitHub's tools to review and discuss code
* Use a variety of techniques to create, track, and manage issues, bugs, and features

## Ace Ventura Git Detective

Learning to search git for specific info is incredibly useful when you are working on large projects.

1. Clone down [bundler](https://github.com/bundler/bundler).
2. Katrina Owen has one commit in the project. Find it.
3. What change was made?

#### Hints

Use your Google skills!!

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

Create a new gist. In this gist I want you to sumarize what github shorcuts you have available on different pages.
Pull up all the github shortcuts (hint: ?). In your gist include the shortcut, a description of what it does, and a practical example of when you may use that shortcut.

## Git Workflow in Teams

When working on a team, it’s important to have a workflow. The details of the workflow will vary from team to team and company to company, but it's important that you have a workflow.

Below is GitHub's workflow. Most teams will do something similar. Step 6 can vary.

1. Anything in the master branch is deployable
2. To work on something new, create a descriptively named branch off of the up to date  master branch (ie: new-oauth2-scopes)
3. Commit to that branch locally frequently. We do this so we have regular checkpoints we can always go back to incase something goes wrong or breaks and we need to go back to the last known working code.
4. Regularly push your work to the same named branch on the remote server (most likely the __origin__ remote)
5. Open a [WIP] pull request so your code can be reviewed and commented on along the way.
6. When you need feedback or help, or you think the branch is ready for merging, tag your reviewer or team in a comment with their github username (@username) asking them to review the PR. (ex: @carmer please review this branch for master)
7. After someone else has reviewed and signed off on the feature, it can be merged to master. This is usually done by the reviewer.
8. Once it is merged and pushed to ‘master’, you can and should deploy immediately. Anything on master should be deployable.

It's useful to think of branches like Ruby methods: they should be small, have descriptive names and implement a single feature. Use branches for the small features that you can implement quickly.

When your feature is complete, don't just merge it into master—submit a pull request and let someone from your team review your code.

[Here is a detialed step-by-step checklist for workflow, by Erinna Chen](https://gist.github.com/erinnachen/1f802734671d9db5c452)

You can find an alternative guide [here](https://gist.github.com/case-eee/22906249d7a2acead8a897813b7a9675).

## Github & Code Reviews

Having your code reviewed gives you confidence that your code is clear, that it runs on someone else's machine, and that it's not accidentally causing an error somewhere else in the application. It's also an opportunity to allow a mentor to review the code you're writing and give you advice.

Reviewing a teammate's code allows you to be familiar with parts of the codebase that you may not have touched. It also provides context for how the code your writing in your branch fits into the larger app.

Tools for conducting a code review:

* Line comments on Github
* Discussion in Github Issues and Waffle.io

__WIP Pull Request:__ A pull request isn’t the final word. You can always add to it based on feedback, so it can be a useful collaboration tool for code that's still "under development." Many teams will call this a "WIP" PR and sometimes will mark it with a special label (to make sure it doesn't accidentally get merged). 

## Practice & Discussion

* What makes a good commit message?
* When should you commit?
* When should you delete branches?
* A few fun git commands

## Extra Practice:

Clone down [this repo](https://github.com/turingschool-examples/git-practice) and follow the directions.

## [Optional] Activity: Conflict Resolution

In pairs assign one person the role of `Person 1` and the other `Person 2`.

1. Person 1: Create a repo on Github with a README. Add Person 2 as a Collaborator.

1. Person 1: Add the project to waffle.io

1. Person 1: Add 2 issues to your waffleboard, one for Person 1, the other for Person 2.

1. Both: checkout a unique feature_branch.

  Example:

  `git checkout -b person_1_changes_stuff`

  `git checkout -b person_2_changes_things`

1. Both: Make changes to the same line in the README in both repos.

1. Person 1: Push your branch and open a PR.

1. Person 2: Merge the PR and close the issue assigned to Person 1

1. Person 2: Push your branch and open a PR.
  * Notice that we can’t merge it automatically
  * We need to fix it locally first

1. Person 2: checkout the master branch.

1. Person 2: Pull from master on Github.

1. Person 2: Checkout the branch you have an open PR for.

1. Person 2: Merge master into your current branch.
  * This should throw an error
  CONFLICT (content): Merge conflict in sample.txt
   Automatic merge failed; fix conflicts and then commit the result.

1. Person 2: Open the file it says the conflict occurs in. You can see it if you run git status

1. Person 2: You see something that looks like this:

```git
<<<<<<< HEAD
Person 2 adds a line!
=======
Person 1 Adds a line!
>>>>>>> master
```

1. Person 2: Update the line to look the way you want it to look. This may mean you want to keep all the 'code' or just one of the two versions. Your team should know what needs to be the current work after the resolution of the conflict.
  * Remove the `<<<< HEAD`, `=======`, and `>>>> master` lines

1. Person 2: running git status tells you how to mark the conflict as resolved
  * After resolving and running git status you will see a `Changes to be committed` message.

1. Person 2: Commit the resolved changes

1. Person 2: Push the changes to your feature_branch on Github.

1. Reload the pull request
  * It should now be able to be merged in automatically.
  * You should also see the commit that merged the two changes

1. Person 1: Merge the PR and close the issue.


## Additional Resources

* [Usefull git commands](http://zackperdue.com/tutorials/super-useful-need-to-know-git-commands)
* [Minimum Viable Git Best Practices for Small Teams](https://blog.hartleybrody.com/git-small-teams/)
* [The small team workflow](https://github.com/janosgyerik/git-workflows-book/blob/small-team-workflow/chapter05.md)
* [Git Tutorial](https://www.atlassian.com/git/tutorials/merging-vs-rebasing/) is a great tutorial about the details of rebaseing vs merging. 
* [This post is about the golden rule of rebaseing](https://medium.freecodecamp.com/git-rebase-and-the-golden-rule-explained-70715eccc372#.3nkd2p6c8)
