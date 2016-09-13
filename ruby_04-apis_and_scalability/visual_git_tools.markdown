# Visual Git

I think the most common git tasks are easier to do with the command line.

- `git init`
- `git checkout -b new-branch`
- `git merge new-branch`
- `git fetch`
- `git push github master:gh-pages`

There's a couple use cases that I've been glad I had a git GUI. Let's get one.

#### A note for the haters 👿

If you really don't want a GUI for your git, manage all of your remotes via SSH, and don't ever visit github.com.

## Gitx

There are several versions of Gitx. I'm going to show you my favorite. I can't remember why I don't like the other ones, but this has what I need.

### Installation

Get yourself [Homebrew Cask](https://caskroom.github.io/), and manage all your apps through the terminal. Get it by running the following command.

```sh
brew tap caskroom/cask
```

Then you can see the controversy by typing

```sh
brew cask search gitx
```

You should get 3 results

```sh
==> Exact match
gitx
==> Partial matches
laullon-gitx  rowanj-gitx   
```

The correct version is rowanj-gitx

```sh
brew cask install rowanj-gitx
```

## Using Gitx

From any folder that is a valid git repository, type `gitx`

### Use case: all the branches

- See what branches are active and haven't been merged in
- Get a preview of what features are coming
- See what branch a bit of code was added on

### Use case: finding a change

- Use the search box to search commit messages
- Quickly scan lots of messages and branches

### Use case: state of the codebase in the past

- Select a branch/tag/commit, and browse files to see what they looked like

### Use case: splitting up code for commits

If you don't have a project with a bunch of uncommitted code, you can always run something like `git reset HEAD~3` and you'll have a bunch of uncommitted code.

- click on **Stage** in the top left
- All unstaged changes are on the left. Click on a file to see what changes have been made
- Drag the files you want to commit to the right
- If you want to commit only specific lines for a file, highlight those lines after selecting a file, and click **Stage Lines**
- Write your message, and commit

### Thinky time

- What's easier to do with the terminal, and what's easier to do with gitx?
- What would be easier to do on github, and what would be easier with gitx?

## Diffmerge

Check out [a tale of two branches](https://github.com/turingschool-examples/a-tale-of-two-branches) for installation instructions and use cases
