---
title: Self-Directed Project
length: 3
tags:
type: project
---

## Goals

In this individual project your big goals are to:

1. Find the strengths and gaps in your knowledge of Ruby, Rails, and organizing
a project.
2. Build something interesting that demonstrates your skills, delivers value to
the user, and makes use of open data.
3. Learn about providing and consuming JSON APIs
4. Learn to use a Virtual Private Server along with automating common tasks

It is *not* a goal that you build something totally unique. Imitate, then innovate.

## Technical Expectations

Every project will be a bit different, but your project needs to share some
common technical characteristics:

### Need to Have All

* You must use an external OAuth provider to authenticate users
* You must make use of a Virtual Private Server to host your application
* Make use of background workers for all appropriate tasks
* Send notifications to users over email/SMS/Twitter
* You must expose a JSON API that at least allows a user read data
* You must create a Ruby gem which allows a user to easily interact with your API

## Functional/Content Expectations

### Project Scope

A good project idea should:

* break down into logical iterations so that you can deliver a strong product on time
* be something that real people would want to use and find some utility for their life
* have enough *technical* challenge to be worth your time (as opposed to a *content* challenge)

### Areas of Focus

Your project should provide some benefit to our greater community. It needs to
be anchored to one of these social issues relevant to Colorado:

* Homelessness
* Education
* The Environment
* Urban Growth/Housing

### Outside Content

Your application **must make good use of one external dataset or API from
a public/non-profit non-partisan source such as:**

* [Data.gov](https://www.data.gov/)
* [Sunlight Foundation](http://sunlightfoundation.com/)
* [ProPublica](http://www.propublica.org/tools/)
* [NASA](http://data.nasa.gov/api-info/)
* [US Census](http://www.census.gov/data/developers/data-sets.html)
* [Socrata Listings](https://opendata.socrata.com/dataset/Socrata-Customer-Spotlights/6wk3-4ija)
* [Bureau of Labor & Statistics](http://www.bls.gov/developers/api_ruby.htm)
* [United Nations](https://www.undata-api.org/) (3rd party API)
* [Google's Directory of Public Data](http://www.google.com/publicdata/directory)
* [OpenColorado](http://data.opencolorado.org/)
* [Denver Regional Council of Governments](https://drcog.org/services-and-resources/data-maps-and-modeling)

## Project Idea Generation

* Fork the repo at https://github.com/turingschool/ruby-submissions
* Clone it to your local machine
* Create a branch named `individual_project` and switch to it
* Create a file in your class' folder `07_self_directed_project` named like `yourlastname_yourfirstname.markdown`
* In that file, create **three ideas** following the template below
* Commit them to the branch
* Push the branch up to your fork
* Submit a pull request back to the primary repo
* An instructor will give feedback on your ideas and suggest any necessary changes
* An instructor will pick the strongest of your ideas
* You'll revise your document to mark the selected idea and push the updated
version to your fork (which updates your pull request automatically)
* Your pull request will be accepted and you can begin work

### Idea Template

```markdown
### [Project Title]

If this project gets selected, put **SELECTED** here

### Pitch

1 sentence that explains the value proposition of the application. How would
you explain it to a potential business partner, team member, or investor?

### Description

5-8 sentences about the application, what it'll do, and why it should exist

### Target Audience

2-4 sentences about who would use this application

### Integrations

* What OAuth provider makes sense for this audience?
* What Data.gov data or API will you use?
* Any other integrations?
```

## Rubric

### Feature Delivery

You'll be graded on each of the criteria below with a score of (1) well below
expectations, (2) below expectations, (3) as expected, (4) better than expected.

* Feature Completion: were the components you built well implemented?
* Project Completion: did you build enough features to realize the vision of a
useful application?
* User Experience: (1) inattention to the user experience, (2) some gaps in the
UX, (3) a production-ready user experience, (4) a polished UX

### Technical Quality

* Organization: did you use your project management tool to keep the project organized?
* Test-Driven Development: (1) disregard for testing, (2) gaps in test
usage/coverage/design, (3) adequate testing, (4) exceptional use of testing
* Code Quality: (1) poor factoring and understanding of MVC, (2) some gaps in
code quality / application of MVC, (3) solid code quality and pushing logic down
the stack, (4) exceptionally well factored code
