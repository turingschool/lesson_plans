---
title: Revisiting Git Workflows
length: 180
tags: git, github, workflow, collaboration
---

## Learning Goals

* Understand some of the best practices for working collaboratively on software projects using Git and GitHub
* Learn to use GitHub's tools to review and discuss code
* Use a variety of techniques to create, track, and manage issues, bugs, and features
* Clean up and condense commit history using `git rebase`

## Structure

## Warm Up

Start a public gist and make some notes about git-related issues you encountered in your recent projects. Answer the following questions:

* Find an example commit from your Rush Hour project which was dealing
  exclusively with a Git problem rather than a feature or bugfix (e.g.
"Fix merge commit", "Really add file...", "Merge master multiple times
in a row", etc)
* What do you believe the root cause of some of these issues were?
* How did they impact your ability to work on the project?
* What solutions worked for you and your team?

## Ace Ventura Git Detective

Learning to search git for specific info is incredibly useful when you are working on large projects.

1. Clone down [bundler](https://github.com/bundler/bundler).
2. Katrina Owen has one commit in the project. Find it.
3. What change was made?
4. Why? Read the article linked there.

#### Hints

Use the man page for git-log to figure out how to get the commit hash based on the author name.

Once you have the correct commit hash, use the man page for git-log to figure out how to look at the commit.

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

## Git Workflow

When working on a team, it’s important to have a workflow. The details of the workflow will vary from team to team and company to company, but it's important that you have a workflow.

Below is GitHub's workflow. Most teams will do something similar. Step 6 can vary.

1. Anything in the master branch is deployable
2. To work on something new, create a descriptively named branch off of master (ie: new-oauth2-scopes)
3. Commit to that branch locally and regularly push your work to the same named branch on the server
4. When you need feedback or help, or you think the branch is ready for merging, open a pull request
5. After someone else has reviewed and signed off on the feature, you can merge it into master
6. Once it is merged and pushed to ‘master’, you can and should deploy immediately

It's useful to think of branches like Ruby methods: they should be small, have descriptive names and implement a single feature. Use branches for the small features that you can implement quickly.

When your feature is complete, don't just merge it into master—submit a pull request and let someone from your team review your code.

[Here is a detialed step-by-step checklist for workflow, by Erinna Chen](https://gist.github.com/erinnachen/1f802734671d9db5c452)

## Github and Code Reviews

Having your code reviewed gives you confidence that your code is clear, that it runs on someone else's machine, and that it's not accidently causing an error somewhere else in the application. It's also an opportunity to allow a mentor to review the code you're writing and give you advice.

Reviewing a teammate's code allows you to be familiar with parts of the codebase that you may not have touched. It also provides context for how the code your writing in your branch fits into the larger app.

Tools for conducting a code review:

* Line comments on Github
* Discussion in Github Issues and Waffle.io

__WIP Pull Request:__ A pull request isn’t the final word. You can always add to it based on feedback, so it can be a useful collaboration tool for code that's still "under development." Many teams will call this a "WIP" PR and sometimes will mark it with a special label (to make sure it doesn't accidentally get merged).

## Activity: Conflict Resolution

In pairs assign one person the role of `Person 1` and the other `Person 2`.

1. Person 1: Create a repo on Github with a README. Add Person 2 as a Collaborator.

1. Person 1: Add the project to waffle.io

1. Person 1: Add 2 issues to your waffleboard, one for Person 1, the other for Person 2.

1. Both: checkout a unique branch.

  Example:
  
  `git checkout -b person_1_changes_stuff`
  
  `git checkout -b person_2_changes_things`

1. Both: Make changes to the same line in the README in both repos.

1. Person 1: Push your branch and open a PR.

1. Person 2: Merge the PR and close the issue assigned to Person 1 via a commit message.
  [halp?](https://help.github.com/articles/closing-issues-via-commit-messages/)

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
1. Person 2: Update the line to look the way you want it to look.
  * Remove the `<<<< HEAD`, `=======`, and `>>>> master` lines

1. Person 2: running git status tells you how to mark the conflict as resolved
  * After resolving and running git status you will see a `Changes to be committed` message.

1. Person 2: Commit the resolved changes

1. Person 2: Push the changes to your branch on Github.

1. Reload the pull request
  * It should now be able to be merged in automatically.
  * You should also see the commit that merged the two changes
 
1. Person 1: Merge the PR and close the issue via your commit message.
  [halp?](https://help.github.com/articles/closing-issues-via-commit-messages/)

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


