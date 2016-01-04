---
title: Git and GitHub for Pairs
length: 60
tags: git, pairing
---

Use the exercise below with a pair to exercise your git techniques.

## Exercise

* Sort your names alphabetically. The first is person "A" and the second is person "B"
* `A` should use their own laptop, go into the directory where they store projects,
and create a directory named `poetry`.
* `A` then goes into the `poetry` directory and runs `git init`
* `A` creates a file in that folder named `still_i_rise.txt`
* `A` adds and commits that new file locally
* `A` goes on GitHub and creates a repository named `poetry`
* `A` follows the directions shown by GitHub to add the remote to their local repo
* `A` pushes the local commits up to GitHub
* `B` should then clone the repository to their local machine
* `A` should add `B` as a collaborator to the repository in GitHub
* `B` then opens the poetry file locally and adds [this content of headings](https://gist.githubusercontent.com/jcasimir/95be7c57e8e027642532/raw/9e57299977273e4b6e4f1073c6b5d37bab842930/headings.txt)
* `B` adds and commits that change, then pushes it to GitHub
* `A` pulls to commit down to their local machine
* `A` creates a branch on their local machine named `verse_1` and adds in [this content under the appropriate heading](https://gist.githubusercontent.com/jcasimir/0d6939ccf64601be374d/raw/55cad33533d63ae14b8a7ef3781fe2d603f75ab6/verse%25201.txt)
* `B` creates a branch on their local machine named `verse_3` and adds in [this content under the appropriate heading](https://gist.githubusercontent.com/jcasimir/1e85576d1435525d2ddf/raw/c307ef3d5889f4b1e11e7217644717a1e0e32299/verse%25203.txt)
* `A` commits the change and pushes their branch to GitHub with `git push origin verse_1`
* `B` commits the change and pushes their branch to GitHub with `git push origin verse_3`
* `A` navigates to the homepage of the repository on GitHub (**Hint** If you have the [Hub](https://hub.github.com/) CLI installed, you can do this easily with `hub browse`).
There should be a button available to "Compare and Create Pull Request" for your recently pushed branch (`verse_1`).
Select this option and walk through the steps to Create a Pull Request for this branch.
* `B` Repeats these steps to create a Pull Request for their `verse_3` branch
* `B` navigates to the repository on github and selects the tab for "Pull Requests". You should see
`A`'s pull request listed. Select this pull request, and use the green "Merge Pull Request" button to merge the PR.
This will merge the branch into master on *GitHub's copy* of the repository. Don't forget to use GitHub's
handy "diff" view to visually review the changes in the pull request.
* `A` repeats this process to merge `B`'s pull request.
* Now both `A` and `B` should checkout the master branch on their machines and pull from master. This
will bring down the changes from `B` and the merge commit from when the branch was merged to master.

Consult [this tutorial](https://help.github.com/articles/using-pull-requests/) for more information
on working with Pull Requests on GitHub.

Ok, so we're written some "features" successfully. Let's create a conflict:

* `A` fills in verse 2 with [this content](https://gist.githubusercontent.com/jcasimir/f746d176c87200910a1a/raw/2e0423a196f08a11975bdd75f7e48c636c066cfd/verse%25202a.txt) and commits it locally on `master`.
* `B` fills in verse 2 with [this content](https://gist.githubusercontent.com/jcasimir/51c4f98d17965f180498/raw/f48f891600adeb648af1d5e50e95b49b92309e08/verse%25202b.txt) and commits it locally on `master`.
* `A` pushes to master
* `B` pushes to master and it is rejected. `B` pulls and gets a *MERGE CONFLICT*
* `B` must manually resolve the conflict to figure out how the lines should be fit together, remove the conflict markers, commit, then push to GitHub.
* `A` then pulls from GitHub and sees the file post-resolution.

Your final work should [look like this](https://gist.githubusercontent.com/jcasimir/23f378e26416560e47a8/raw/aaa3f2848b3c7d1c7cc091c394068599d3588c90/gistfile1.txt).

### Extension / Alternate Merging Workflow

It's also possible to merge branches on your local machine

* `B` creates a branch on their local machine named `caged_bird_1_to_3` and creates a new file under the `poetry` directory called `caged_bird.markdown`
* `B` adds [this content](https://gist.githubusercontent.com/worace/d699026f3b408b4d0cee/raw/fb739aa51039d97080b53e970f2328942d6cf5d0/content.txt) to the file
* `B` stages and commits the new content, then pushes their branch to github (remember, `git push <remote name> <branch name>`).
* `A` runs `git fetch origin` on their local machine. This pulls down all branches from the remote
to `A`'s local machine.
* `A` runs `git checkout caged_bird_1_to_3` to review the changes made by `B`
* When `A` is satisfied with `caged_bird_1_to_3`, then they merge it into master with
`git checkout master` and `git merge caged_bird_1_to_3`
* `A` then pushes these newly-merged changes (`git push origin master`) so that `B` can pull them down.
* Now both `A` and `B` should checkout the master branch on their machines and pull from master. This
will bring down the changes from `B` and the merge commit from when the branch was merged to master.
* Now `A` should complete this same process with a branch called `caged_bird_4_to_6` using [this content](https://gist.githubusercontent.com/worace/7649dfa5fbd96a8fb871/raw/0c80b9289ca0eb35333890f57ebba3f927e7cdae/4_to_6.txt).
* When `A` has pushed the branch, `B` should fetch from origin, checkout the branch, review it, then merge it
to master.
* Once it is merged, `B` should push to origin, then both partners should checkout master on their local machines and pull from origin
to retrieve the newly merged changes.

Your finished product should look like [this](https://gist.githubusercontent.com/worace/b1a9cefa4da6a08ea788/raw/93db0b1c59c684d03c2b8eeafd581391c378c70b/caged_bird.md).
