---
title: Intro to Git & Github
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

## Introduction to Git (lecture)

### What is Git?

* Version control system
* Provides "multiple save points"
* Solving the problem of `some_docV1.doc`, `some_docV2.doc`, `some_docFinal.doc`, `some_docREALLYFINAL.doc`, etc.
* Specifically: **Distributed** Version Control System; contrasts with traditional centralized VCS (journalism, architecture, engineering)
* Git's philosophy: never lose anything

### Git Branches and Commits: The Mortar and Bricks of a Git Repository
* User `commits` take snapshots of your code and store them as _changes_ since the last `commit`.
* Git `commits` combine to create a replayable log of all changes made to the repository over time
* Contents of a `commit`
  * Author (who)
  * Date (when)
  * Message (why)
  * Contents (what)
  * Parent Hash (where)
  * Hash (auto-generated fingerprint tagging the contents of the commit) uniquely id's the commit
* `Branches` document lineage of commit history and splits

### Navigating Branches and Commits
* `Branches`: Git actually allows us to have multiple histories, each on its own *branch*;
by default git creates a standard branch called *master*
* `Head`: Reference for "Where am I now?"
  * By default this is the "tip" of the current branch you're on, the latest commit on a given branch
  * If you manually jump to another commit, `head` will represent the state of your code when that commit was the most recent change.
  * When new commit is made on a branch, `head` moves to that new commit
* `Working Directory` represents the current view of files, what we see as opposed to the various changes and alternative views git stores in its history

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

### Check for Understanding
Write on the following questions to synthesize what's been covered.
* How do commits and branches serve as the bricks and mortar of a git repository?
* What _is_ a commit and how does git use it to reconstruct the history of your code?

When you're finished, post your answers in Slack.



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








## Github

Github is a platform for hosting git repositories online. Before github, developers or companies configured and ran their own independent git servers, and things were much more fragmented. Now Github has become the de facto community standard for hosting and sharing repositories.

You certainly don't need Github to use git, but its popularity and dominance, especially within the open source community, have made the 2 somewhat synonymous for many users.

As you progress through becoming a more practiced git user, don't forget that these 2 are really distinct things -- `git` provides the core technology for tracking and managing source control changes, while GitHub provides a shared location for hosting git projects.

### Basic Workflow for Using GitHub

There are a few things we'll need to do to use GitHub to host our newly-created repository:

1. Create a new repo on GitHub
2. Add the online repo as a "remote" for our local repository
3. `push` changes from our local repository to the remote copy that Github is tracking for us

### Creating a Repository with [Hub](https://github.com/github/hub)

We can create a repository via the GitHub web interface, but fortunately there's also a very handy command line utility called `Hub` that makes this even easier.

Let's install it using homebrew:

```
brew install hub
```

Hub provides a command-line interface to streamline many of the common interactions we have with GitHub. It uses GitHub's API to do things like creating repositories, opening issues, etc.

You can read more about the commands available in Hub's [documentation](https://github.com/github/hub#commands), but for now we're going to be using the `create` command.

Hub will help us create a relationship to our remote repository. Before we do that, though, let's check whether we currently have any remote relationships defined.

```
git remote -v
```

We should see no results when we run this command. Now let's add the relationship.

Make sure you're in the `intro_git` directory we created earlier, and create a new (GitHub) repository to host this content online. Use Hub's `create` command:

```
hub create
```

If this is your first time using Hub, you'll be prompted for your github username and password. After that, hub will do 2 things:

1. Create the repository on GitHub
2. Add that repository as a "remote" within our local repository (on our machine)

Check `git remote -v` and we'll see that origin has been set to our remote repo address: `origin git@github.com:username/repo_name.git`

### Pushing changes to our new remote

__Discussion:__ Remote vs. Local Copies of Repo

Thanks to hub, we have a remote available to push to. We'll do this with the `git push` command, which takes __2 arguments__:

1. A "remote" to push to (most often this will be `origin`)
2. The "branch" we'd like to push to (for now this will usually be `master`)

So we can push our code so far like so:

```
git push origin master
```

Now let's use Hub to go to our repo page on github and view our changes:

```
hub browse
```

### Check for Understanding
Write on the following questions to synthesize what's been covered.
* How is Github different from Git?
* What does Hub help us with?
* What relationship does a `remote` repository have with our `local` repository?
* What does pushing to a remote branch do for us?

When you're finished, post your answers in Slack.


## Additional Git Commands

### Reviewing Diffs

Git contains a handy "diffing" tool that is useful for examining changes you've made.

Open your `Readme.md` and add some text to it. Use `git status` to verify that git is detecting changes in this file.

Then use `git diff Readme.md` to get a more explicit view of the difference between the current state of the Readme.md file and the last committed version.

### Working on Branches (NOW OPTIONAL)
Branches are helpful when working on teams and developing new functionality. [This link](http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging) shows some helpful visuals related to git branches.

Let's create a new branch to experiment with branches and diff: `git checkout -b feature1`. Edit all three files, now execute the following commands.

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

### Merging Branches

* `git checkout master`
* Take a look at the files in your editor. All of the changes are gone! (well, not really -- they're just in our other branch)
* `git merge feature1` will merge your commits from feature1 branch into master

### Looking back at previous versions

* `git log`
* `git show SHA:path/to/file.rb` shows the file at that point in time
* press return to scroll through a long output
* type `q` to get back to command prompt when looking at a long output
* `git show SHA` shows the diff to that file at that specific commit

### Cloning a Repository from Github

Use `git clone git@github.com:username/repo_name.git` to create a local copy of a remote repo.

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
