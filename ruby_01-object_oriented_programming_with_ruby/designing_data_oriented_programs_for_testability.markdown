---
title: Designing for Testability
length: 120
tags: Testing, TDD, OOP, Design, Fixtures, Headcount
---

## Outline

This lesson is divided into 3 sections:

1. Short warm-up discussion (10 - 15 minutes)
2. Student Exercise (20 - 30 minutes)
3. Live Coding Demo applying the principles to the Headcount project (60 - 90 minutes)

## Discussion - Testing vs. External Dependencies

### Q & A

(call a random student by name for each question)

* What makes a piece of code easy to test?
* What makes it hard?
* What is an "Edge Case"?
* How do we test an edge case?
* Does this change when our objects have to deal with
  importing data from the outside world?
* Student 1: Describe 1 way to organize the relationship between
  an object and data it imports from the outside world?
* Student 2: Describe another way to do it?

### Data Pains - limiting our interface to our objects

* Common pain point when dealing with external interfaces: we make
the external data dump the _only_ interface for sending information
into the object
* The action of bringing outside data in is contained within the object,
so our only way to provide it is to put the data in the right place (often a file)
and let the object slurp it in
* What does this mean for our tests?
* What would an alternative look like?
* Can we preserve the simple data interface (i.e. provide data in the form of ruby
objects) _as well as_ the "slurp it up from a file" interface?
* Best of both worlds: Testability and flexibility when you want to provide standard basic
objects; Ease of use / "Do it all" when you need to pull in a bunch of external data
* Additional win: If the importing task becomes more complex, we can easily extract
it into a separate entity
* The interface between our objects is simple data, rather than external infrastructure

## Exercise - TDD Pizza Parlor

## Live Coding Demo - Applying these Principles to Headcount

[Sample Code]()
