---
title: Apicurious
length: 1 week
tags:
type: project
---

## Project Description

In this project, we'll be focusing on consuming and working with data from public APIs.

As a vehicle for learning this concepts, we'll be selecting an API from a popular website and working to re-construct a simplified version of the website's existing UI using their own API. For example, you might decide to use the Twitter API to build a basic version of the Twitter feed where users can view and post tweets.

As we build these features, we'll also be working with the OAuth protocol to authenticate our users with the third-party provider, and using various testing techniques to allow us to test against the third-party data.

The project requirements are listed below:

* [Learning Goals](#learning-goals)
* [Technical Expectations](#technical-expectations)
* [Available APIs](#available-apis)
* [Evaluation](#evaluation)

## <a name="learning-goals"></a> Learning Goals

* Learn to consume data from third-party APIs
* Continue to emphasize performance, UI, and overall user experience
* Continue using TDD to drive all layers of development
* Coordinate with project stakeholders to produce quality code and product
* This project will be completed individually over a period of 4 days.

## <a name="technical-expectations"></a> Technical Expectations

You'll work with an instructor to define more explicitly the requirements for your specific application, but the basic requirements for this project include:

* Use an Omniauth authentication library for authenticating users with the 3rd-party service.
* Mimic the interface functionality of one online service from the list below.
* Consume an external API to get real data and interact with a third-party service.

The authoritative project requirements will be created and maintained in collaboration with your client through meetings and your project management tool. This means that the requirements for your could differ significantly from other projects.

## <a name="available-apis"></a> Available APIs

To start, you need to select an API to work with. We've selected the following list of applications for their well-documented public APIs, and relatively straightforward UI's.

For each project, we have included a rough summary list of features to include. As with any development project, you should focus on moving iteratively through the most basic features before starting on more complex ones. During the project, the instructors will meet with you to assess progress and determine what features to focus on next.

### Twitter

Build a basic version of the Twitter feed. As a user, I should be able to:

* Authenticate with my Twitter account
* View a list of recent tweets from my feed
* See my basic profile information (profile pic, follower count, following count, etc)
* Post a tweet
* Favorite a tweet

Extensions:

* Retweeting a tweet
* Replying to a tweet
* Use a paginated or infinite-scroll interface to view more tweets
* Unfollow a user

### Instagram

Build a basic version of the Instagram (web) UI. As a user, I should be able to:

* Authenticate with my Instagram account
* See my basic profile information (username, profile pic)
* View a list of recent posts from my feed
* View photos for each post
* View comments for each post
* View like count for each post

Extensions:

* Infinite Scroll to view more photos
* See trending posts
* Show pictures that match a hashtag
* Search for a user

### Tumblr

Build a basic version of the Tumblr UI. As a user, I should be able to:

* Authenticate with my Tumblr account
* See my basic profile information (username, profile pic)
* View a list of recent posts from my feed
* View embedded photo or video content for the posts
* Favorite a post
* Reblog a post

Extensions:

* Create a post (perhaps starting with just text posts and moving on to more complicated types)
* Generate a permalink for a post
* Follow a user whose post was reblogged into my feed

### Github

Build a basic version of the Github profile / feed UI. As a user, I should be able to:

* Authenticate with my github account
* View basic information about my account (profile pic, number of starred repos, followers, following)
* View contribution summary information (Contributions in last year, longest streak, current streak)
* View a summary feed of my recent activity (recent commits)
* View a summary feed of recent activity from users whom I follow
* View a list of organizations I'm a member of
* View a list of my repositories

Extensions:

* View a list of open pull requests that I have opened
* View a list of "@mentions" that I was included in
* Create a new repository
* Planning & Requirements

## <a name="evaluation"></a> Evaluation

You'll be graded on each of the criteria below with a score of (1) well below
expectations, (2) below expectations, (3) as expected, (4) better than expected.

### Feature Delivery

**1. Completion**

* 4: Developer delivered all planned features plus 2 extensions.
* 3: Developer delivered all planned features.
* 2: Developer reduced functionality to meet the deadline.
* 1: Developer missed major features and/or the application is not deployed to production.

**2. Organization**

* 4: Developer used a project management tool and updated their progress in real-time.
* 3: Developer used a project management tool to keep their project organized.
* 2: Developer used a project management tool but didn't update the progress frequently.
* 1: Developer failed to use a project management tool to track its progress.

### Technical Quality

**1. Test-Driven Development**

* 4: Project demonstrates high test coverage (>90%), tests at the feature and unit levels, and does not rely on external * services.
* 3: Project demonstrates high test coverage (>80%), tests at feature and unit levels, but relies on external services
* 2: Project demonstrates high test coverage (>70%), but does not adequately balance feature and unit tests
* 1: Project does not have 70% test coverage

**2. Code Quality**

* 4: Project demonstrates exceptionally well factored code.
* 3: Project demonstrates solid code quality and MVC principles.
* 2: Project demonstrates some gaps in code quality and/or application of MVC principles.
* 1: Project demonstrates poor factoring and/or understanding of MVC.

### Product Experience

**1. User Experience**

* 4: The application is a logical and easy to use implementation of the target application
* 3: The application covers many interactions of the target application, but has a few holes in lesser-used functionality
* 2: The application shows effort in the interface, but the result is not effective
* 1: The application is confusing or difficult to use
