---
title: The Pivot
length: 2 weeks
tags:
type: project
---

## Project Description

Your Little Shop of Orders application was *almost* great, but it turns out that we need to *pivot* the business model.

In this project, you'll build upon an existing implementation of Little Shop. You will transform your restaurant ordering site into a platform that handles multiple, simultaneous businesses. Each business will have their own name, unique URL pattern, items, orders, and administrators.

The project requirements are listed below:

* [Learning Goals](#learning-goals)
* [Teams](#teams)
* [Setup](#setup)
* [Workflow](#workflow)
* [Technical Expectations](#technical-expectations)
* [Pivots](#pivots)
* [Base Data](#base-data)
* [Evaluation](#evaluation)

## <a name="learning-goals"></a> Learning Goals

During this project, you'll learn about:

* Working with Multitenancy
* Implementing JavaScript
* Securing a Rails App
* Sending Email
* Creating Seed files

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

### Project Starting Point

You'll build upon an existing code base assigned by the instructors. You need to work on adapting and improving this codebase, not building your own thing from scratch. This is sometimes called "brownfield" development, and you'll soon know why.

### Exploring the Little Shop App

As a group, dig into the code base and pay particular attention to:

* Test coverage and quality
* Architectural concerns
* Components that are particularly strong or weak
* General strengths and weaknesses

### Beginning The Pivot

Once you've explored the base project, the team leader will:

* Create a new, blank repository on GitHub named `the_pivot`
* Clone the Little Shop project that you'll be working with to your local machine
* Go into that project directory and `git remote rm origin`
* Add the new repository as a remote `git remote add origin git://new_repo_url`
* Push the code `git push origin master`
* Add the other team members as collaborators in Github

Once the team leader has done this, the other team members can fork the new repo.

### Tagging the Start Point

We want to be able to easily compare the change between the start of the project and the end. For that purpose, create a tag in the repo and push it to GitHub:

* $ git tag -a little_shop_v1
* $ git push --tags

### Restrictions & Outside Code

Your project should evolve, refactor, and clean up the code you inherit. This includes deleting redundant, broken, or obsolete code. However, you should **not** throw out the previous work wholesale.

Furthermore, there should be *no reduction in functionality* except when explicitly called for by new requirements.

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

## <a name="technical-expectations"></a> Technical Expectations

You are to extend Little Shop so that it can handle multiple, simultaneous businesses. Each business should have:

* A unique name
* A unique URL pattern (http://example.com/name-of-business)
* Unique items
* Unique orders
* Unique administrators

The Pivot should be able to handle the following users:

### Guest Customer

As a guest customer, I should be able to:

* Visit different businesses.
* Add items from multiple businesses into a single cart.
* Log in or create an account before completing checkout.

### Registered Customer

As an registered customer, I should be able to:

* Make purchases on any business
* Manage my account information
* View my purchase history

### Business Admin

As a business admin, I should be able to:

* Manage items on my business
* Update my business information
* Manage other business admins for your store

### Platform Admin

As a platform admin, I should be able to:

* Approve or decline the creation of new businesses
* Take a business offline / online
* Perform any functionality restricted to business admins

## <a name="pivots"></a> Pivots

Your group will be assigned one of the following problem domains to pivot Little Shop:

### Collector Items

How many times did you want to buy that old Pacman arcade so that you could put it next to that Atari console? Let's rework Little Shop into a platform to bid on collectors' items.

### Farmers' Market

Organic vegetables that grow in innercity sidewalks are a great source of vitamins. Let's rework Little Shop into a marketplace for local produce.

### Lending

Micro-lending is a powerful tool for social progress. Let's rework Little Shop
into a micro-lending platform.

### Jobs

Employment is key to quality of life. Let's rework our Little Shop into a platform
to help people find great jobs.

### Lodging

Experiencing other cultures is one of the strongest ways to build our understanding
of humanity. Let's make it easier for people to open their homes to travelers.

### Photos

People hated our restaurant, but they loved our product photos. Let's pivot
the platform to sell photography, providing our customers a "whitelabel" experience.

### Tickets

Who wants to stand in line for tickets the day they come out? Nobody. Instead you
can just pay 50-500% more to buy them from someone else.

## <a name="base-data"></a> Base Data

You should have the following data pre-loaded in your marketplace:

* 20 total businesses
* 10 categories
* 50 items per category
* 100 registered customers, one with the following data:
  * Username: josh@turing.io
  * Password: password
* 10 orders per registered customer
* 1 business admins per business
  * Username: andrew@turing.io
  * Password: password
* 1 platform administrators
  * Username: jorge@turing.io
  * Password: password

It creates a much stronger impression of your site if the data is plausible. We recommend creating a few "template" businesses that have real listings, then replicating those as needed. You could also use the [Faker](https://github.com/stympy/faker) gem.

## <a name="evaluation"></a> Evaluation

You'll be graded on each of the criteria below with a score of (1) well below
expectations, (2) below expectations, (3) as expected, (4) better than expected.

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
