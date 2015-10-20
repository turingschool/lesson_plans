---
title: Intro to Git & Github
length: 180
tags: git, github
---

## Standards

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

#### Github

* explain the purpose of Github
* clone a repository from Github
* create a remote on Github
* push a repository to Github from the command line

## Structure

* 20 - What is Git?
* 10 - Dotfiles
* 45 - Git in Practice
* 100 - Independent Git Practice
* 5 - Wrapup

## Introduction to Git (lecture)

#### What is Git?

* Version control system
* Provides "multiple save points"

#### How is Git Configured on My Computer?

* `git config --global user.email "you@example.com"`
* `git config --global user.name "Your Name"`

Dotfiles:
* .gitconfig
* .bash_profile

Don't have dotfiles? Check out Turing's [Bootstrapping New Students](https://github.com/turingschool/bootstrap_new_students) repository.

#### What is Github?

* Web-based Git repository hosting system

## A Basic Git Workflow

Git contains many features. Fortunately, in 99% of cases we don't have to
know or use most of them. Instead, we can rely on a very
simple and straightforward workflow:

1. Create a new git repository within your project directory (`git init`)
2. Do work / Change files
3. "Stage" changes using `git add`
4. "Commit" your changes using `git commit`
5. Repeat steps 2-5 until done

## Basic Workflow in Practice

Let's go through a more concrete example all together.

First, create and navigate into an empty directory to simulate a new project
we might be working on:

```
mkdir intro_git
cd intro_git
```

Next, let's create an empty file to simulate some code changes we
might have made:

```
touch Readme.md
```

Now we need to tell git to create a new, empty "repository" within
the directory:

```
git init
```

We sometimes use the terms "repository" and "directory"
interchangeably in the context of git, but technically they are
separate things. The directory contains all our working files, as well
as the hidden files used by git to track all of our work. The repository
is composed of files and directories within the hidden `.git` directory
where git does its magic.

Now that we have a repository and git knows to track this directory,
let's check our status:

```
git status
```

The `status` command shows us git's perspective on the current
state of our repository

This command shows you what is "tracked", "untracked", and "changed". `Readme.md` should be red since it is untracked.

* `git add Readme.md` adds the specified file to the staging area.
* `git status` shows you the current status. `Readme.md` should be green since it's been added.
* `git commit -m 'initial commit'` commits your file with a message of 'initial commit'.
* `git status` (to see clean working branch) shows the current status. The working branch should be clean and you should not see any red or green files.

#### Edit Files in Repository

* `atom .` Open your files in your text editor.
* use atom to create two files (`file1.txt`, `file2.txt`)
* edit the `Readme.md`

* `git status` should show three red files. One has uncommitted changes and the other two are untracked.
* `git diff Readme.md` will show you the difference between the current state of the Readme.md file and the last committed version.
* `git add Readme.md`
* `git commit -m '(message about changing) Readme.md'`
* `git status`
* `git add file1.txt`
* `git status`
* `git add file2.txt`
* `git commit` This will open up your text editor and ask for a commit message. When finished, save and close the file.

#### Working on Branches

* What is a branch?
* Why would you use a branch?
* [This link](http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging) shows some helpful visuals related to git branches.

* `git checkout -b feature1`
* edit all three files
* `git status`
* `git diff file1.txt`
* `git add file1.txt`
* `git status`
* `git diff file2.txt`
* `git checkout file2.txt` to discard changes (explain this checkout is different from checking out a branch)
* `git status`
* `git diff Readme.md`
* `git add Readme.md`
* `git commit -m '(message about changing two files)'`

#### Merging Branches

* `git checkout master`
* Take a look at the files in your editor. All of the changes are gone! (well, not really -- they're just in our other branch)
* `git merge feature1` will merge your commits from feature1 branch into master

#### Looking back at previous versions

* `git log`
* `git show SHA:path/to/file.rb` shows the file at that point in time
* press return to scroll through a long output
* type `q` to get back to command prompt when looking at a long output
* `git show SHA` shows the diff to that file at that specific commit

#### Github

* create a new repo on Github -- find the `+` button in the top right corner
* public vs. private (paid) repositories
* initializing from command line vs. initializing from Github
* after clicking "create repository" button, follow instructions

#### Pushing Ruby Exercises to Own Github Account

* create new repo on Github and name it `ruby-exercises`
* `git push origin master` doesn't work. Why?
* reset the `origin` point with `git remote rm origin`
* add the new origin using the command from Github: `git remote add origin https://github.com/username/ruby-exercises`
* git push origin master
* you will still have all of the commits associated with this repository

## Independent Practice

If you're brand new to git, start with [Try Github](https://try.github.io/levels/1/challenges/1).

If you've used git before (or if you complete try.github), work through [Git Immersion](http://gitimmersion.com/). Atlassian also has a helpful [Git Tutorial](https://www.atlassian.com/git/tutorials/setting-up-a-repository).

And, if you just can't get enough Git, check out the [Pro Git book](http://git-scm.com/book).

## Wrapup

Return to standards and check progress.
* What was easy?
* What was challenging?
* What made sense?
* What didn't make sense?

## Corrections & Improvements for Next Time

### Taught by Rachel on 9/11
