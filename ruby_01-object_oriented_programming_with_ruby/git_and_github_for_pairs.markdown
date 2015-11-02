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
* Both `A` and `B` run `git fetch origin` on their local machine
* `A` runs `git checkout verse_3` to review the changes made by `B`
* `B` runs `git checkout verse_1` to review the changes made by `A`
* When `A` is satisfied with `verse_3`, then they merge it into master with `git checkout master` and `git merge verse_3`
* When `B` is satisfied with `verse_1`, then they merge it into master with `git checkout master` and `git merge verse_1`
* `A` then pushes with `git push origin master`
* `B` then pushes with `git push origin master`. It's rejected. Why? Follow the tips from Git until you get it pushed.
* `A` then pulls from master and both `A` and `B` are fully in synched.
* `A` repeats the process for `verse_4` and [this content](https://gist.githubusercontent.com/jcasimir/d1b1d25db859e6ba3b9d/raw/d52f89f839314e0b6ae688f73e2e8c0b8a392a02/verse%25204.txt).
* `B` repeats the process for `verse_5` and [this content](https://gist.githubusercontent.com/jcasimir/ae3706dfaaa6affb7e36/raw/45312ba210227fffc0051731049fac5914254a5b/verse%25205.txt).
* `A` and `B` pair on `A`s machine to three new commits, ones for each of [verse 6](https://gist.githubusercontent.com/jcasimir/89a12acb0ecc84f8ea4b/raw/7c8c45ca4558ea818edc05fd1b4c2940d764bbd6/verse%25206.txt), [verse 7](https://gist.githubusercontent.com/jcasimir/c61302bf832b16d14575/raw/24a2a8311364c7295d019514629f53a7c72fab6b/verse%25207.txt), and [verse 8](https://gist.githubusercontent.com/jcasimir/9cddb2e0bc0f83e946f3/raw/2155457640c278b00eab4f2f08f0044247a1a10f/verse%25208.txt) on a branch named `last_three`.
* `A` pushes that branch, `B` pulls it, `B` merges it into master, `B` pushes to master, and `A` pulls from GitHub.

Ok, so we're written some "features" successfully. Let's create a conflict:

* `A` fills in verse 2 with [this content](https://gist.githubusercontent.com/jcasimir/f746d176c87200910a1a/raw/2e0423a196f08a11975bdd75f7e48c636c066cfd/verse%25202a.txt) and commits it locally on `master`.
* `B` fills in verse 2 with [this content](https://gist.githubusercontent.com/jcasimir/51c4f98d17965f180498/raw/f48f891600adeb648af1d5e50e95b49b92309e08/verse%25202b.txt) and commits it locally on `master`.
* `A` pushes to master
* `B` pushes to master and it is rejected. `B` pulls and gets a *MERGE CONFLICT*
* `B` must manually resolve the conflict to figure out how the lines should be fit together, remove the conflict markers, commit, then push to GitHub.
* `A` then pulls from GitHub and sees the file post-resolution.

Your final work should [look like this](https://gist.githubusercontent.com/jcasimir/23f378e26416560e47a8/raw/aaa3f2848b3c7d1c7cc091c394068599d3588c90/gistfile1.txt).

### Extension / Alternate Merging Workflow

Another popular approach to merging branches involves GitHub's
built-in **Pull Request** feature. If you want to experiment with
this feature, try the following steps:


* `B` creates a branch on their local machine named `caged_bird_1_to_3` and creates a new file under the `poetry` directory called `caged_bird.markdown`
* `B` adds [this content](https://gist.githubusercontent.com/worace/d699026f3b408b4d0cee/raw/fb739aa51039d97080b53e970f2328942d6cf5d0/content.txt) to the file
* `B` stages and commits the new content, then pushes their branch to github. (**Hint** If you have the [Hub](https://hub.github.com/) CLI installed, you can do this easily with `hub browse`)
* `B` navigates to the homepage of the repository on GitHub. There should be a button available
to "Compare and Create Pull Request" for your recently pushed branch. Select this option and walk through the
steps to Create a Pull Request for this branch.
* `A` navigates to the repository on github and selects the right-hand tab for "Pull Requests". You should see
`B`'s pull request listed. Select this pull request, and use the green "Merge Pull Request" button to merge the PR.
This will merge the branch into master on *GitHub's copy* of the repository.
* Now both `A` and `B` should checkout the master branch on their machines and pull from master. This
will bring down the changes from `B` and the merge commit from when the branch was merged to master.
* Now `A` should complete this same process with a branch called `caged_bird_4_to_6` using [this content](https://gist.githubusercontent.com/worace/7649dfa5fbd96a8fb871/raw/0c80b9289ca0eb35333890f57ebba3f927e7cdae/4_to_6.txt).
* When `A` has opened a pull request for the branch, `B` should use the online workflow to merge it.
* Once it is merged, both partners should checkout master on their local machines and pull from origin
to retrieve the newly merged changes.

Your finished product should look like [this](https://gist.githubusercontent.com/worace/b1a9cefa4da6a08ea788/raw/93db0b1c59c684d03c2b8eeafd581391c378c70b/caged_bird.md).

Consult [this tutorial](https://help.github.com/articles/using-pull-requests/) for more information
on working with Pull Requests on GitHub.
