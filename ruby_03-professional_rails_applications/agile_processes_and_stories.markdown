---
title: Agile Processes & Stories
length: 90
tags: agile, planning, stories
status: draft
---

## Learning Goals

* Understand the differences between waterfall and agile development
* Understand some of the common roles and processes of agile teams
* Be able to write a well-structured agile story

## Structure

* 25 - Presentation: Agile Development
* Break
* 25 - Structuring Stories
* Break
* 25 - Stories Workshop
* 5 - Wrapup

## Presentation: Agile Development

We'll start with a few slides and a bit of discussion about agile.

[Here's a link to the deck](https://www.dropbox.com/sh/e833eu3q0796sk3/AACPBI0_xL8Hcxt_RA5x1nofa?dl=0).

## Structuing Stories

### The Purpose

* User-centric > Feature-centric
* Delivering value to the customer/user
* Communication between stakeholders
* Stories function as our "to-do" items

### Writing Stories

* "As a <role>, I want <goal/desire> so that <benefit>"
* Gherkin language is one option:

```
 Feature: Some terse yet descriptive text of what is desired
   In order to realize a named business value
   As an explicit system actor
   I want to gain some beneficial outcome which furthers the goal

   Scenario: Some determinable business situation
     Given some precondition
       And some other precondition
      When some action by the actor
       And some other action
      Then some testable outcome is achieved
       And something else we can check happens too
```

### Estimating

The most controversial and difficult part of agile is estimating.

* When will the value be delivered?
* Set milestones
* Change scope, not timing
* Points! Points! Points!
* Estimate complexity, not time

#### Points

* 3 Points: I don't know
* 2 Points: It's a big job that I'm sure can be done
* 1 Points: I get it

#### Working

* You shouldn't ever work on a three-point story
* Decompose complex stories into smaller ones
* Ideally there are only one-point stories
* Typically a one-pointer is <= 1/2 day of work
* The challenges of "velocity"

## Workshop

Let's think back to Dinner Dash. Imagine you're planning the first two iterations.
What value would you deliver first? How would you estimate the complexity of
the story? Get together with a small group to draft a set of stories.

You can collaborate using one or more of these tools:

* Write raw text together using [EtherPad](https://etherpad.mozilla.org/)
* Try [Sprintly](https://sprint.ly/)
* Try [Pivotal Tracker](http://www.pivotaltracker.com/)

## Wrapup

* Agile is about people, not processes
* People like processes, so Agile has processes

Read [Dave Thomas' article 'Agile is Dead'](http://pragdave.me/blog/2014/03/04/time-to-kill-agile/).

Watch [Glenn Vanderburg's Presentation 'Real Software Engineering'](http://www.confreaks.com/videos/282-lsrc2010-real-software-engineering)
