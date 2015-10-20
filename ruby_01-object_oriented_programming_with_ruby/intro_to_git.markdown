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
state of our repository. We'll see changes in 3 possible states
here:

1. Unstaged (we have made changes but not told git that we would like to commit them)
2. Staged (we have made changes and told git that we are getting ready to commit them)
3. Committed (we have committed our changes to the repository's log of commits)

Our `Readme.md` file will be showing as Unstaged at this point, so let's add it:

```
git add Readme.md
```

We can verify the `add` worked by using the status command again:

```
git status
```

We'll now see that `Readme.md` (and the changes we made to it) have moved to the
"staging" area -- they are ready to be committed.

Finally, let's make a commit! We use the `git commit` command for this. One
key component of every commit is a "message" describing what the commit does.
We can provide this message from the command line using the `-m` flag, like so:

```
git commit -m "initial commit; added Readme"
```

Run `git status` one more time. Since we committed all of our changes,
our working directory is now "clean".

This cycle -- make changes, stage changes (`git add`), and commit changes --
is the backbone of a standard git workflow.

You should use these steps frequently as you're working on a project.

__Your Turn -- Making More Changes and Commits__

Work through the process again at least 2 more times.

Create a new file called `file1.txt` in your directory,
add some text to it, stage it, and commit it.

Then repeat the process with another file called `file2.txt`

#### Reviewing Diffs

Git contains a handy "diffing" tool that is useful for
examining changes you've made.

Open your `Readme.md` and add some text to it. Use
`git status` to verify that git is detecting changes
in this file.

Then use `git diff Readme.md` to get a more
explicit view of the difference between the current state of the Readme.md file and the last committed version.

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

## Github

Github is a platform for hosting git repositories online. Before
github, developers or companies configured and ran their own independent
git servers, and things were much more fragmented.

Now Github has become
the de facto community standard for hosting and sharing repositories.
You certainly don't need Github to use git, but its popularity and
dominance, especially within the open source community, have made
the 2 somewhat synonymous for many users.

### Using GitHub - Basic Workflow

There are a few things we'll need to do to use GitHub to host
our newly-created repository:

1. Create a new repo on GitHub
2. Add the online repo as a "remote" for our local
repository
3. "push" changes from our local repository to the
remote copy that Github is tracking for us

### Creating a Repository with [Hub](https://github.com/github/hub)

We can create a repository via the GitHub web interface, but
fortunately there's also a very handy command line utility
called `Hub` that makes this even easier.

Let's install it using homebrew:

```
brew install hub
```

Hub provides a command-line interface to streamline many of the
common interactions we have with GitHub. It uses GitHub's
API to do things like creating repositories, opening issues, etc.

You can read more about the commands available in Hub's
[documentation](https://github.com/github/hub#commands),
but for now we're going to be using the `create` command.

Make sure you're in the `intro_git` directory we created
earlier, and create a new (GitHub) repository to host this
content online. Use Hub's `create` command:

```
hub create
```

If this is your first time using Hub, you'll be prompted for
your github username and password. After that, hub will
do 2 things:

1. Create the repository on GitHub
2. Add that repository as a "remote" within our local
repository (on our machine)

### Pushing changes to our new remote

__Discussion -- Remote vs. Local Copies of Repo__

Thanks to hub, we have a remote available to push to.
We'll do this with the `git push` command, which takes
__2 arguments__:

1. A "remote" to push to (most often this will be `origin`)
2. The "branch" we'd like to push to (for now this will usually be `master`)

So we can push our code so far like so:

```
git push origin master
```

Now let's use Hub to go to our repo page on github
and view our changes:

```
hub browse
```

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
