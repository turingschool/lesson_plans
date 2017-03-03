---
title: Intro to Git Redux
length: 180
tags: git, github
---

## Prework (the Night Before)

Set up your ssh keys on github according to [these instructions](https://help.github.com/articles/generating-ssh-keys/)

## Standards

After this lesson, students should be able to:

#### Git

* explain the purpose of Git
* manipulate git configuration in the .gitconfig file
* initialize a new git repository
* add files to git staging area
* commit files and directories
* check the status of the working directory and staging area and interpret the output
* view previous commits
* create and checkout a new branch
* switch between branches
* merge local branches to local master
* access earlier commits
* examine the difference between current state of a file and the last commit

#### Github

* explain the purpose of Github
* create a remote on Github
* push a repository to Github from the command line
* clone a repository from Github
* git log, show, merge

## Structure

* Introduction to Git (40 min)
* A Basic Git Workflow (25 min)
* Github (25 min)
* Independent Git Practice (80 min)
* Wrapup (10 min)

## Introduction to Git

### What is Git?

* Version Control System
* Provides "multiple save points"
* Solves the problem of `doc1.doc`, `doc1_v1.doc`
* Git is specifically a Distributed Version Control System, contrast this with
an old fashioned centralized version control system. 
* Git's philosophy is that we never lose anything.
* Git is the best worst tool there is.
* It was originally made for kernel developers.
* It was supposed to make people who are file system engineers
feel right at home. 
* It was never meant to function as a source control system.
* Exactly.

### Git Branches and Commits.

* When we add some changes that we make to something we call
the staging area, git saves it.
* When we commit it, it gives it a special ID that consists of an 
author, date, message, contents, and previous commit.
* Branches document the lineage of commit history.

### Git Conceptual Arts & Crafts Demo

Instructor should demonstrate going through a basic git flow using a hypothetical scenario.
Students should follow along using Wiki Stix and Index Cards to represent commits and the connections between them.

* Make a directory
* Init a git repository
* Make a file
* Add changes to file
* Stage changes
* Commit changes
* Repeat x 2-3
* Create a branch (moving HEAD)
* Repeat changes / Commits
* Checkout master (moving HEAD)
* Merging branch (moving HEAD)



## A Basic Git Workflow

Git contains many features. Fortunately, in 99% of cases we don't have to
know or use most of them. Instead, we can rely on a very simple and straightforward workflow:

1. Create a new git repository within your project directory (`git init`)
2. Do work / Change files
3. "Stage" changes using `git add`
4. "Commit" your changes using `git commit`
5. Repeat steps 2-5 until done

### Preliminary `gitconfig` Setup

* Git stores a special configuration file at `~/.gitconfig`
* You can put a ton of options here but for now we just care about basics
* `git config --global user.email "you@example.com"`
* `git config --global user.name "Your Name"`
* You can also double check what values are currently set by running `git config -l` at the command line

### Basic Workflow in Practice

Let's go through a more concrete example all together.

First, create and navigate into an empty directory to simulate a new project
we might be working on:

```
mkdir intro_git && cd intro_git
```

Next, let's create an empty file to simulate some code changes we
might have made:

```
touch Readme.md
```

Now we need to tell git to create a new, empty "repository" within the directory:

```
git init
```

We sometimes use the terms `repository` and `directory` interchangeably in the context of git, but technically they are separate things. The directory contains all our working files, as well as the hidden files used by git to track all of our work. The repository is composed of files and directories within the hidden `.git` directory where git does its magic.

Now that we have a repository and git knows to track this directory, let's check our commit history:

```
git log
```

It shows we currently have no commits. Let's also check git `status`.


```
git status
```

The `status` command shows us git's perspective on the current state of our repository. We'll see changes in 3 possible states here:

1. __Unstaged__ (we have made changes but not told git that we would like to commit them)
2. __Staged__ (we have made changes and told git that we are getting ready to commit them)
3. __Committed__ (we have committed our changes to the repository's log of commits)

Our `Readme.md` file will be showing as Unstaged at this point, so let's add it:

```
git add Readme.md
```

We can verify the `add` worked by using the status command again:

```
git status
```

We'll now see that `Readme.md` (and the changes we made to it) have moved to the "staging" area -- they are ready to be committed.

Finally, let's make a commit!

We use the `git commit` command for this. One key component of every commit is a "message" describing what the commit does. We can provide this message from the command line using the `-m` flag, like so:

```
git commit -m "initial commit -- added Readme"
```

Run `git status` one more time. Since we committed all of our changes,
our working directory is now "clean".

Check `git log` once more. We will now see one commit documented in our log.

This cycle -- make changes, stage changes (`git add`), and commit changes --
is the backbone of a standard git workflow.

You should use these steps frequently as you're working on a project.

### Practice

Work through the process again at least 2 more times. Create a new file called `file1.txt` in your directory, add some text to it, stage it, and commit it. Then repeat the process with another file called `file2.txt`

### Check for Understanding
Write on the following questions to synthesize what's been covered.
* What's the difference between unstaged, staged, and committed changes?
* How do these states (unstaged, staged, committed) help git keep track of the history of your code?
* How are `git status` and `git log` used to review the status of our code? How are they different?

When you're finished, post your answers in Slack.





