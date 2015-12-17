---
title: Intro to Project Management
length: 90
tags: rails, mvc
---

## Learning Goals

* Understand the common roles of a team in a professional setting
* Discuss possible arrangements for working in a groups at Turing
* Understand the importance of taking a front to back approach to projects
* Understand the importance of taking a front to back approach to projects
* UNDERSTAND the importance of taking a FRONT to back approach to projects
* Why not start by creating all of your migrations up front?

## Lecture

Start with a discussion of the big picture. Explain that they will need to find ways to fulfill these roles by dividing up the work among their teams.

### Common Roles on a Team

* **Client** - Who the software is being built for. (Instructors at Turing)
* **Product Owner** - Translates the needs for the client to the team (this piece can usually be skipped at Turing). Often is responsible for confirming that the stories meet the client's needs (Having someone check your work is important).
* **Team Lead** - Commonly in charge of estimation and making sure the dev team is on track. Commonly the go between for the team and the Product Owner and sometimes the Client.
* **Developers** - Responsible for working on stories. Multiple devs will review other team members pull requests.
* **Designers** - They design things.


### Stages of the Group Lifecycle
[Tuckman's Group Lifecycle](https://en.wikipedia.org/wiki/Tuckman%27s_stages_of_group_development)
* Forming
* Storming
* Norming
* Performing

### Big Picture Workflow

- Show how to convert the requirements of the project to stories/issues on Waffle
- Discuss the advantages of designing the schema after the stories have been written and the problems are well understood
- Let the stories drive development, even copy and paste the story into the tests
- Do not create migrations before you have a story written. Why not create all "necessary" migrations right up front?

### Git Workflow

_Currently teaching a pull and merge workflow versus a fetch and rebase workflow since it tends to be easier to understand for beginners._

- Each user works on a feature branch: `git checkout -b 01-registering-an-application` follows the following naming convention `[issue_number]-[issue-title]`
- Each user is responsible for pulling from `origin/master` to their local `master` branch and merging with their feature branch before merging their pull request with `origin/master`(assuming `origin` is the "central" repo).
  * `git checkout master`
  * `git pull origin master`
  * `git checkout 01-registering-an-application`
  * `git merge master`
  * `git push origin 01-registering-an-application`
  * IMPORTANT: You may need to go through steps above multiple times if another pull request gets merged into master before yours does. This is because your version of `master` is behind shared repo's version of `master`.
- You will still get merge conflicts with this approach. This is OK.
- When merging a pull request, you can close the associated issues using `closes #1` in your merge message on Github.
