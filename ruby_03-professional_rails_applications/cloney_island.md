---
title: Cloney Island
length: 2 weeks
tags:
type: project
---

## Project Description

Now that you're a pro with building and consuming APIs, we are giving you time
to shine!

In this project, you'll be building a new platform from scratch. Within it,
you'll build a well-documented API to both internally consume and protect for
external consumption. Your platform will be built to handle multiple types of
users (guests, registered users & admins).

The project requirements are listed below:

*   [Learning Goals](#learning-goals)
*   [Teams](#teams)
*   [Setup](#setup)
*   [Workflow](#workflow)
*   [Technical Expectations](#technical-expectations)
*   [Project Prompts](#project-prompts)
*   [Base Data](#base-data)
*   [Check-ins](#check-ins-and-milestones)
*   [Evaluation](#evaluation)

## <a name="learning-goals"></a> Learning Goals

During this project, you'll learn about:

*   Working with Multitenancy
*   Implementing JavaScript
*   Securing a Rails App
*   Uploading Files
*   Creating Seed files
*   Consuming an External API
*   Building an Internal API

## <a name="teams"></a> Teams

The project will be completed by teams of three to four developers over the
span of two weeks.

You will name a team leader that will:

*   Make sure business requirements are transformed into user stories.
*   Work with the client to establish team priorities.
*   Seek clarification from the client when a user story is not clear.
*   Make sure that all the team members are on track and collaborating
following a professional workflow.

Like all projects, individual team members are expected to:

*   Seek out features and responsibilities that are uncomfortable.
*   Support your teammates so that everyone can collaborate and contribute.
*   Follow a professional workflow when developing a feature.

## <a name="setup"></a> Setup

### Project Starting Point

You'll build a new project assigned by the instructors. This is sometimes
called "greenfield" development, because you are starting from scratch.

### Beginning The Mystery project

Once you've explored the project requirements, the team leader will:

*   Create a new, blank repository on GitHub named with a suitable name.
*   Create a fresh Rails app and add the new repository as a remote
with `git remote add origin git://new_repo_url`
*   Push the code with `git push origin master`
*   Add the other team members and instructors as collaborators in Github

Once the team leader has done this, the other team members can fork the new
repo.

### Tagging the Start Point

We want to be able to easily compare the change between the start of the
project and the end. For that purpose, create a tag in the repo and push it to
GitHub:

*   `$ git tag -a <project_name>_v1`
*   `$ git push --tags`

### Project Management Tool

There are many popular project management tools out there. For this project
we'll use a lightweight tool that wraps GitHub issues: [Waffle.io](https://waffle.io/)

Setup a Waffle project for your new repo. Your team members and instructors
should be added to the project so they can create, edit, and comment on issues.

## <a name="workflow"></a> Workflow

### Client Interaction

You will meet with the client frequently to obtain his/her business needs and
correct course. You will transform these requirements into user stories.

A feature will not be considered complete until it is working on production.
You must assume that your client doesn't have any programming experience. You
will have to learn how to manage expectations.

The stories as written and prioritized in your project management tool will be
the authoritative project requirements. They may go against and likely go
beyond the general requirements in this project description.

As the stories clearly define the client's expectations, your application needs
to **exactly** follow the stories as they've been developed with your customer.
A 95% implementation is wrong.

If you want to deviate from the story as it's written, you need to discuss that
 with your client and get approval to change the story *first*.

### User Stories

User stories follow this pattern:

*As a <user>, when I <do something>, I <expect something>.*

Examples:

```
As an admin
When I click on dashboard
Then I should be on "/dashboard"
And I should see all users listed
```

```
As a guest user
When I visit "/signup"
And I fill in `Email` with "chad007@example.com"
And I fill in `Password` with "password"
And I fill in `Password Confirmation` with "password"
And I fill in `Phone Number` with "<A REAL PHONE NUMBER>"
And I click `Submit`

Then my account should be created but inactive
And I should be redirected to "/confirmation"
And I should see instructions to enter my confirmation code
And I should have received a text message with a confirmation code

When I enter the confirmation code
And I click "Submit"
Then I should be redirected to "/dashboard"
And my account should be active
```

### Working with Git

Once you have written the user stories with your client, each team member should:

1.  Select a story from the project management tool.
1.  If the story is not clear, add comments or request clarification.
1.  Create a feature branch in your *local* repo.
1.  Write a feature test.
1.  Implement the requested feature.
1.  Merge the latest master into the requested feature to make sure that all
the tests are passing.
1.  Commit referencing the issue that you are working on in the commit message.
Check this [guide](https://help.github.com/articles/closing-issues-via-commit-messages/) for more information.
1.  Push the *feature* branch to the *remote* repo.
1.  Submit a pull request asking to merge the branch into *master*.
1.  A teammate reviews the code for quality and functionality.
1.  The teammate merges the pull request and deletes the remote branch.

## <a name="technical-expectations"></a> Broad Technical Expectations

Your app should implement the following features:

*   Extensive documentation of your API. Some students have used [swagger.io](http://swagger.io/getting-started/) but it's not required.
*   Two-factor authentication using SMS confirmation via [Twilio's REST API](https://www.twilio.com/docs/api/rest).
    *   Gotcha: Use of the Twilio gem is not allowed.
*   Users must be able to "comment" in some capacity.
    *   This may be in the form of a "review" depending on your app's domain.
    *   There should be an API that supports CRUD functionality.
*   Your API must be authenticated for external use.
    *   External users must be provided an API key that they use to make requests to your API.

You are to create a platform that can handle multiple, simultaneous user needs.

Each user on the platform should have:

*   A unique URL pattern [http://example.com/<user_name>](http://example.com/<user_name>)
*   Unique administrators

Your app should be able to handle the following users:

### Guest User

As a guest, I should be able to:

*   Browse public content / profiles.
*   Log in or create an account.

### Registered User

As a registered user, I should be able to:

*   Post listings or content either publicly or privately.
*   Manage my account information.
*   Manage my profile / content.

### Platform Admin

As a platform admin, I should be able to:

*   Take a user offline / online, including all content associated with them but without removing any of the data from the database.
*   delete postings/content.

##  <a name="project-prompts"></a> Project Prompts

Your group will be assigned one of the following domains to create.

### Professional Finder (Thumbtack)

You need things done like new siding on your house or a vintage couch reupholstered. New business owners and side tinkerers want more work.
Let's create a platform that connects professionals to projects in a way that encourages people to stay honest.

#### Specific Requirements

*   User roles should include: guest, professional, requester, admin.
*   Professionals should be able to publicly post profiles of their skills.
*   Requesters should be able to publicly post work they need done on their property.
*   Both professionals and requesters should be able to message each other to discuss the project including sending images of the work that needs to be done and PDFs of estimates.
*   Once a project is assigned to a professional, it should no longer be listed publicly.
*   Requesters should be able to see all projects they've listed.
*   Professionals should be able to see all work they've applied for (with differentiation for projects they've been assigned to).
*   To keep both professionals and requesters honest, each can rate each other. (polymorhic association)
*   Only professionals can see a requester's rating.
*   Professionals should only see requests for jobs they have the skills to complete. (i.e. A seamstress probably shouldn't see a request for siding)

#### Possible Extensions

*   Integrate a 3rd party API for online payments.

### Pinspiration (Pinterest)

Need a new recipe? Maybe some ideas on what to wear to work? What color should
you paint your bedroom? Let's create a platform that allows you to keep
all of your inspiration in one place.

#### Specific Requirements

*   User roles should include: guest, registered user, admin.
*   Guests and registered users should be able to browse public pin boards.
*   Registered users should be able to post to either public or private boards they manage.
*   Private boards can be shared with specific users.
*   Registered users should be able to follow each other.
*   Registered users can comment on pins.
*   Registered users should see a dashboard on login with chronologically listed updates from those they follow.

#### Possible Extensions

*   Build a Chrome extension that makes images and links on the web "pinnable."

### Couch Surfing (Airbnb)

Traveling somewhere but don't feel like getting a hotel room? Let's create a
platform that allows you to find couches in the area that you can book, or post
your couch for someone else to crash on.

#### Specific Requirements

*   User roles should include: guest, traveler, host, admin.
*   Travelers and hosts should be able to publicly post profiles describing themselves.
*   Hosts should be able to publicly post information about room they have available.
*   Both travelers and hosts should be able to message each other to discuss a reservation.
*   Once a reservation is confirmed, it should no longer be listed as available for those dates.
*   Travelers and hosts should be able to see all reservations they've applied for (with differentiation for those confirmed).

#### Possible Extensions

*   Users can "vouch" for each other, upping their credibility across the site.

### Filesharing (Dropbox)

Share all those files you have with your friends, families and co-workers. Let's
create a platform that allows users to share files and view/download files that
others share with them.

#### Specific Requirements

*   User roles should include: guest, registered user, admin.
*   Guests can only browse publicly available files.
*   Registered users can create public or private folders that they can upload files to.
*   Registered users can invite other users to contribute to public or private folders.
*   Users should be able to download zipfiles of content they have acccess to.

#### Possible Extensions

*   Registered users can request access to other users' private data.
*   Set up breadcrumb pathing for easier navigation and shareable links (`/user/folder/inner_folder/airhorn.wav`).

### Photosharing (Flickr)

Do you have photos you want to share with the world? Maybe some photos
you don't want to share with your mom, but want to share with your friends?
Let's create a platform that allows users to share photos with certain groups of
people or share some for public consumption.

#### Specific Requirements

*   User roles should include: guest, registered user, admin.
*   Guests can only browse publicly available photos.
*   Registered users can create public or private buckets that they can upload photos to.
*   Registered users can invite other users to upload to public or private buckets.
*   Users should be able to download zipfiles of single images or entire buckets they have access to.

#### Possible Extensions

*   Create slideshow pages from users' photo buckets.
*   Users can resize images before downloading.

## <a name="base-data"></a> Base Data

You should have the following data pre-loaded:

*   1000 total registered users
*   5 - 10 postings per user
*   1 platform administrator with the following user info:
    *   Username: clancey007@example.com
    *   Password: password

It creates a much stronger impression of your site if the data is plausible.
You could use the [Faker](https://github.com/stympy/faker) gem to randomly create categorized data.

## <a name="check-ins-and-milestones"></a> Check-ins and Milestones

We want you to be able to discuss your app with non-technical parties as well as technical.

### 1st Check-in

#### What should be done

The scope of this project is more fluid than prior projects. Your client will want to go over your plan for the project. Bring wireframes and detailed user stories (ie waffle cards). Don't underestimate the value of a good plan.

(You should also have a rough schema sketched out, but you will not be reviewing this with your client.)

#### What to expect from your client

Clients will help you refine your plan, including scope, wireframes and project management. You'll also decide what should be done by the next check-in.

### 2nd Check-in

#### What should be done

This is based on what you decided in your last check-in and should be working **in production**. You should be well on your way to basic functionality. If you've changed the plan, be sure to let your client know prior to the check-in. Have a plan for what you'd like to go over.

#### What to expect from instructors

Your client will review the work you've done so far at a high level. Then it's really up to you what to look at. Get feedback on your code, even the parts you know need to be refactored. These are great moments to make changes in a way that will save you time in the long run.

You'll also decide what should be done by the next check-in.

### 3rd Check-in

#### What should be done

Last check-in before evaluation.

This is based on what you decided in your last check-in, but basic functionality should be completed. If you've changed the plan, be sure to let your instructor know prior to the check-in. Have a plan for what you'd like to go over.

#### What to expect from instructors

Your client will review the work you've done so far at a high level. Then it's up to you what to look at.

By this point, you should be near done with basic functionality, and ready to talk about extensions for your app.

## <a name="evaluation"></a> Evaluation

You'll be graded on each of the criteria below with a score of (1) well below
expectations, (2) below expectations, (3) as expected, (4) better than expected.

### Completion

**Client Expectations**

*   Team completed all the user stories and requirements set by the client.
    *   4: Better than expected
    *   3: As expected
    *   2: Below expectations
    *   1: Well below expectations

**User Experience**

*   Project exhibits a production-ready user experience.
    *   4: Better than expected
    *   3: As expected
    *   2: Below expectations
    *   1: Well below expectations

**Organization**

*   Team used a project management tool to keep their project organized.
    *   4: Better than expected
    *   3: As expected
    *   2: Below expectations
    *   1: Well below expectations

### Technical Evaluation

**Git Workflow**

*   Team always used pull requests and commented on pull requests prior to introducing code into the master branch.
    *   4: Better than expected
    *   3: As expected
    *   2: Below expectations
    *   1: Well below expectations

**Test Quality**

*   Project is well-tested (Above 90% and the most valuable pieces of the app are covered). If you were paying for someone to build this for you, would you be satisfied with the tests that are written?
    *   4: Better than expected
    *   3: As expected
    *   2: Below expectations
    *   1: Well below expectations

**Code Quality**

*   Project demonstrates well-factored code and a solid grasp of MVC principles.
    *   4: Better than expected
    *   3: As expected
    *   2: Below expectations
    *   1: Well below expectations

**Bonus**

We want to recognize and reward risk-taking and exploration. Sometimes other areas might suffer if the risk doesn't pan out. Earn a bonus point to offset a score above.

*   Did the team push themselves by taking risks?
    *   1: Yes
    *   0: No
