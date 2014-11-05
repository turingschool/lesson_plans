---
title: Introduction to Git and Github
length: 120
tags: git, github
status: work-in-progress
---

## Signing up for Github

Sign up for a free Github account at [https://github.com/](https://github.com/).

## Installing Git

[This webpage](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git) has instructions for installing Git on Mac, Windows, and Linux machines. 

If you are having trouble installing Git, sign up for a Nitrous.io account at [nitrous.io](http://nitrous.io) using your Github account. Nitrous is an online IDE (integrated development environment) that already has Git configured. At the end of class, feel free to stick around to trouble-shoot installing Git on your own machine locally. 

## Configuring Git

From the command line:

* `git config --global user.email "you@example.com"`
* `git config --global user.name "Your Name"` 

Other configuration options: 

* .gitconfig dotfile

## Initializing a Git Repository

* `mkdir intro_git`
* `cd intro_git`
* `touch Readme.md`
* `git init` initializes your current directory as a git repository. This allows the files to be tracked. 
* `git status` shows you what is tracked, untracked, and changed. `Readme.md` should be red since it is untracked.

## Adding and Committing Files

* `git add Readme.md` adds the specified file to the staging area.
* `git status` shows you the current status. `Readme.md` should be green since it's been added. 
* `git commit -m 'initial commit'` commits your file with a message of 'initial commit'. 
* `git status` (to see clean working branch) shows the current status. The working branch should be clean and you should not see any red or green files.

## Editing Files

* Open your files in your text editor. (`atom .`, `subl .`, etc.)
* use your text editor to create two files (`thing.rb`, `thing_test.rb`)
* edit the `Readme.md`
* `git status` should show three red files. One has uncommitted changes and the other two are untracked.
* `git diff Readme.md` will show you the difference between the current state of the Readme.md file and the last committed version.
* `git add Readme.md`
* `git commit -m '(message about changing) Readme.md'`
* `git status`
* `git add thing.rb`
* `git status`
* `git add thing_test.rb`
* `git commit` This will open up your text editor and ask for a commit message. When finished, save and close the file. 
* `git log`

## Looking at Previous Versions

* `git log`
* `git show SHA:path/to/file.rb` shows the file at that point in time
* type `q` to get back to command prompt if your file is long 
* `git show SHA` shows the diff to that file at that specific commit

## Working on Branches

* `git checkout -b feature1` (or gc -b feature1)
* edit all three files
* `git status`
* `git diff thing.rb`
* `git add thing.rb`
* `git status`
* `git diff thing_test.rb`
* `git checkout thing_test.rb to discard changes` (explain this checkout is different from checking out a branch)
* `git status`
* `git diff Readme.md`
* `git add Readme.md`
* `git commit -m '(message about changing two files)'`

## Merging Branches

* `git checkout master`
* Take a look at the files in your editor. All of the changes are gone! (well, not really -- they're just in our other branch)
* `git merge feature1` will merge your commits from feature1 branch into master

## Pushing to Github

* create new repo on Github and name it
* follow instructions for pushing repo to Github
* refresh page -- your code is there!

## Practice On Your Own

If you're brand new to git, start with [Try Github](https://try.github.io/levels/1/challenges/1).

If you've used git before (or if you complete try.github), work through [Git Immersion](http://gitimmersion.com/). Atlassian also has a helpful [Git Tutorial](https://www.atlassian.com/git/tutorials/setting-up-a-repository).

And, if you just can't get enough Git, check out the [Pro Git book](http://git-scm.com/book).
