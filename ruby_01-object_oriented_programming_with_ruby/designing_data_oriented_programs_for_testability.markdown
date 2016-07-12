---
title: Designing for Testability
length: 120
tags: Testing, TDD, OOP, Design, Fixtures, Headcount
---

## Outline

This lesson is divided into 3 sections:

1. Short warm-up discussion (~25 minutes)
2. Student Exercise (~50 minutes)
3. Live Coding Demo applying the principles to the Headcount project (~90 minutes)

## Discussion - Testing vs. External Dependencies

### Warmup Questions

Students should spend 5 minutes answering these questions in their notebooks.
Then call a random student to share their answer for each one.

* What is an "Edge Case"?
* How do we test an edge case?
* What makes a piece of code easy to test?
* Does this change when our objects have to deal with
  importing data from the outside world?

### Data Pains - limiting our interface to our objects

* Common pain point when dealing with external interfaces: we make
the external data dump the _only_ interface for sending information
into the object
* The action of bringing outside data in is contained within the object,
so our only way to provide it is to put the data in the right place (often a file)
and let the object slurp it in
* Programming with files/HTTP sources/Network data drives us to program with Locations rather
than values
* Rather than telling you the value of something I'll tell you it's on the whiteboard in the other classroom. Then you have to go look it up.
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

Keep these principles in mind as you complete this short
[Pizza Parlor Exercise](https://github.com/turingschool-examples/pizza_parlor)

## Live Coding Demo - Applying these Principles to Headcount

[Sample Code](https://gist.github.com/worace/a60ab88d64f892b48c0e)

## Further Reading / Watching

* [The Value of Values by Rich Hickey](https://www.youtube.com/watch?v=-6BsiVyC1kM)
* [Hexagonal Architecture by Alistair Cockburn](http://alistair.cockburn.us/Hexagonal+architecture)
* [Hexagonal Rails by Matt Wynne](https://www.youtube.com/watch?v=CGN4RFkhH2M)
