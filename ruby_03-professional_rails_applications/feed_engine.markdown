---
title: FeedEngine
length: 2
tags:
type: project
---

## Project Description

The goal of this project is to consume and aggregate third-party APIs. You will create a data aggregator service that pulls data and activity from other applications and publishes it through a web interface.

The project requirements are listed below:

* [Learning Goals](#learning-goals)
* [Teams](#teams)
* [Setup](#setup)
* [Workflow](#workflow)
* [Technical Expectations](#technical-expectations)
* [Project Concepts](#project-concepts)
* [Evaluation](#evaluation)

## <a name="learning-goals"></a> Learning Goals

* Learning about JSON structure and use cases
* Building an API
* Consuming an API
* Testing an internal API
* Testing an external API
* Improving an auditing Rails performance
* Using background workers
* JQuery and Ajax
* Implementing caching strategies in Rails
* Handling errors and failure
* Understanding the asset pipeline

## <a name="teams"></a> Teams

The project will be completed by teams of three to four developers over the span of two weeks.

You will name a team leader that will:

* Transform business requirements into user stories.
* Work with the customer to establish team priorities.
* Seek clarification from the customer when a user story is not clear.
* Make sure that all the team members are on track and collaborating following a professional workflow.

Like all projects, individual team members are expected to:

* Seek out features and responsibilities that are uncomfortable.
* Support your teammates so that everyone can collaborate and contribute.
* Follow a professional workflow when developing a feature.

## <a name="setup"></a> Setup

### Beginning the Feed Engine

This is a *greenfield* project. Your team leader will:

* Create a new, blank repository on Github named `feed_engine`
* Add the other team members as collaborators in Github

Once the team leader has done this, the other team members can fork the new repo.

### Project Management Tool

There are many popular project management tools out there. For this project we'll use a lightweight tool that wraps GitHub issues: [Waffle.io](https://waffle.io/)

Setup a Waffle project for your new repo. Your team members and instructors should be added to the project so they can create, edit, and comment on issues.

## <a name="workflow"></a> Workflow

### Client Interaction

You will meet with the client frequently to obtain his/her business needs and correct course. You will transform these requirements into user stories.

A feature will not be considered complete until it is working on production. You must assume that your client doesn't have any programming experience. You will have to learn how to manage expectations.

The stories as written and prioritized in your project management tool will be the authoritative project requirements. They may go against and likely go beyond the general requirements in this project description.

As the stories clearly define the customer's expectations, your application needs to **exactly** follow the stories as they've been developed with your customer. A 95% implementation is wrong.

If you want to deviate from the story as it's written, you need to discuss that with your client and get approval to change the story *first*.

### User Stories

User stories follow this pattern:

*As a [user], when I [do something], I [expect something].*

Examples:

* As an admin, when I click on dashboard, I can see all the users listed in the page.
* As a store admin, when I visit the orders page, I can see the orders listed there by status.

### Working with Git

Once you have written the user stories with your client, each team member should:

1. Select a story from the project management tool.
2. If the story is not clear, add comments or request clarification.
3. Create a feature branch in your *local* repo.
4. Write a feature test.
5. Implement the requested feature.
6. Merge the latest master into the requested feature to make sure that all the tests are passing.
7. Commit referencing the issue that you are working on in the commit message. Check this [guide](https://help.github.com/articles/closing-issues-via-commit-messages/) for more information.
8. Push the *feature* branch to the *remote* repo.
9. Submit a pull request asking to merge the branch into *master*.
10. A teammate reviews the code for quality and functionality.
11. The teammate merges the pull request and deletes the remote branch.

### Implementing a Performance Profiler

To be able to optimize the page loads of your application, you should install a profiler that will measure the performance of your app and give you suggestions on what to improve. We recommend that you install [Skylight](https://www.skylight.io).

Common performance improvement techniques include:

* Database Optimization
* Caching
* Background Workers
* Ajax Requests

However, you should always measure the performance, and identify potential bottlenecks before implementing a solution.

## <a name="technical-expectations"></a> Technical Expectations

The purpose of this project is to build an app that consumes and aggregates third-party APIs. You should also focus on improving performance to reduce page load, and create a better experience for the user.

### APIs

You can use any API provided to you by an third-party service. You need to aggregate at **least two APIs**. Examples of the services that you can use are:

* [Twitter](https://dev.twitter.com)
* [Facebook](https://developers.facebook.com)
* [Instagram](https://instagram.com/developer)
* [Github](https://developer.github.com/v3)
* [FitBit](https://dev.fitbit.com)
* [Spotify](https://developer.spotify.com/web-api)
* [Strava](https://www.strava.com/developers)
* [Uber](https://developer.uber.com)
* [Google Maps](https://developers.google.com/maps)

However, the list is not limited to these. You can choose to integrate with a service of your choosing, as long as it is approved by your client.

### Database Optimization

One common source of performance lags `n+1` queries, which are database queries within a queries. It is much faster to have 1 query that returns 1,000 records, than 1,000 queries that return 1 record.

You can check this resource for your [reference](https://secure.phabricator.com/book/phabcontrib/article/n_plus_one/).

### Caching

You are expected to use any of the following caching strategies to improve the performance of your application.

* Fragment Caching
* Low-level Caching
* Russian-Doll Caching

You can check the [Rails documentation](http://guides.rubyonrails.org/caching_with_rails.html) for your reference.

### Background Workers

You are expected to use background workers for time-consuming tasks that your app can perform in the background. These include:

* Sending Email
* Query APIs
* Process Data

You can check this [guide](https://ryanboland.com/blog/writing-your-first-background-worker/) for reference.

### Ajax Requests

You are expected to use Ajax requests to update some data without reloading the page. Check this [guide](http://www.sitepoint.com/use-jquerys-ajax-function/) for reference.

## <a name="project-concepts"></a> Project Concepts

A week prior to the FeedEngine kickoff, each cohort member needs to generate a project idea. The idea must solve a real problem. To create your project proposal follow the template below.

Once the project proposals are in place, the entire cohort will select the ones it wants to see built. Teams will then choose the project they want to work on.

### Project Template

```markdown
### [Project Title]

### Pitch

1 sentence that explains the value proposition of the application. How would you explain it to a potential business partner, team member, or investor?

### Problem

1-3 sentences describing the problem that you are trying to solve.

### Solution

1-3 sentences describing how your application will solve that problem.

### Target Audience

1-3 sentences describing what type of user your app would be applicable to.

### Integrations

* Which APIs will you use?
* Any other integrations?
```

## <a name="evaluation"></a> Evaluation

You'll be graded on each of the criteria below with a score of (1) well below expectations, (2) below expectations, (3) as expected, (4) better than expected.

### Feature Delivery

**1. Completion**

* 4: Team completed all the user stories and requirements set by the client in timely manner.
* 3: Team completed all the user stories and requirements set by the client.
* 2: Team completed most of the user stories and requirements set by the client.
* 1: Team completed the user stories and requirements partially.

**2. Organization**

* 4: Team used a project management tool and updated their progress in real-time.
* 3: Team used a project management tool to keep their project organized.
* 2: Team used a project management tool but didn't update the progress frequently.
* 1: Team failed to use a project management tool to track its progress.

### Technical Quality

**1. Test-Driven Development**

* 4: Project shows exceptional use of testing at different layers (above 95% coverage).
* 3: Project shows adequate testing (90% - 95% coverage).
* 2: Project shows gaps in test usage/coverage/design (85 - 90% coverage).
* 1: Project lacks sufficient testing (under 85% coverage).

**2. Code Quality**

* 4: Project demonstrates exceptionally well factored code.
* 3: Project demonstrates solid code quality and MVC principles.
* 2: Project demonstrates some gaps in code quality and/or application of MVC principles.
* 1: Project demonstrates poor factoring and/or understanding of MVC.

### Product Experience

**1. User Experience**

* 4: Project exhibits a production-ready and polished UX.
* 3: Project exhibits a production-ready user experience.
* 2: Project exhibits some gaps in the UX.
* 1: Project exhibits inattention to the user experience.

**2. Performance**

* 4: Project pages load on average under 300 milliseconds.
* 3: Project pages load on average under 400 milliseconds.
* 2: Project pages load on average under 500 milliseconds.
* 1: Project pages load on average over 500 milliseconds.
