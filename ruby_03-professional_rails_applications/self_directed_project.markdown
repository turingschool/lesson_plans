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

It is *not* a goal that you build something totally unique. Imitate, then innovate.

## Technical Expectations

Every project will be a bit different, but your project needs to share some
common technical characteristics:

### Need to Have All

* You must use an external OAuth provider to authenticate users
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

Your project should provide some benefit to our greater community, therefore, your project needs to provide a solution for a social problem.

### Outside Content

Your application **must make good use of one external dataset or API**. Some examples include:

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
* Create a file in your class' folder `09_self_directed_project` named like `yourlastname_yourfirstname.markdown`
* In that file, create **three ideas** following the template below
* Commit them to the branch
* Push the branch up to your fork
* Submit a pull request back to the primary repo
* An instructor will give feedback on your ideas and suggest any necessary changes
* Pick your favorite idea and bring the others to class.
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

### Problem

1-3 sentences describing the problem that you are trying to solve.

### Solution

1-3 sentences describing how your application will solve that problem.

### Target Audience

1-3 sentences describing the user that you will use.

### Integrations

* What OAuth provider makes sense for this audience?
* What API will you use?
* Any other integrations?
```

#### Feature Delivery

You'll be graded on each of the criteria below with a score of (1) well below
expectations, (2) below expectations, (3) as expected, (4) better than expected.

**1. Completion**

* 4: Developer completed all the user stories and requirements set by the client in timely manner.
* 3: Developer completed all the user stories and requirements set by the client.
* 2: Developer completed most of all the user stories and requirements set by the client.
* 1: Developer completed the user stories and requirements partially.

**2. Organization**

* 4: Developer used a project management tool and updated their progress in real-time.
* 3: Developer used a project management tool to keep their project organized.
* 2: Developer used a project management tool but didn't update the progress frequently.
* 1: Developer failed to use a project management tool to track its progress.

**3. Progress**

* 4: Developer delivered all the requested features on all iterations.
* 3: Developer delivered all the requested features on all but one iteration.
* 2: Developer delivered all the requested features on all but two iterations.
* 1: Developer failed to delivered requested features on three or more iterations.

#### Technical Quality

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

**3. User Experience**

* 4: Project exhibits a production-ready and polished UX.
* 3: Project exhibits a production-ready user experience.
* 2: Project exhibits some gaps in the UX.
* 1: Project exhibits inattention to the user experience.
