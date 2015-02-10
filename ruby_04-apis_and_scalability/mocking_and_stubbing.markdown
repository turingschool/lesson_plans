---
title: Mocking and Stubbing in Ruby
length: 90
tags: testing, mocks, stubs, doubles, ruby
---

## Learning Goals

* Understand the purpose of a test double
* Begin to identify situations where a test mock or stub will be useful
* Practice mocking with 3 popular libraries -- Minitest::Mock, Mocha, and
  rspec-mocks
* Learn some key test-object terminology both in the general case and in
  the ways it applies to our specific test libraries.
* Discuss potential downsides of over-zealous mocking and stubbing.

## Structure

* 25 - Initial discussion of Mock/Stub use-cases and terminology.
* 5 - POMODORO
* 25 - Work through "mockickal creatures" exercise using 3 different
  mocking libraries
* 5 - POMODORO
* 25 - Individual work -- Independent Project Testing
* 5 - wrap-up/review

## Primary Mocking Use-Cases

* Behavior outside your control (e.g. a gem or class that another
  team-member is working on)
* Behavior that is difficult to setup and reproduce within a test
  environment (e.g. a Service Object which fronts an extensive service
infrastructure that is difficult to set up)
* Slow things (HTTP requests, computationally expensive Data Crunching)
* Unpredictable things (e.g. rand(), live-updated data)
* Time-based things (e.g. Time.now, day-of-week)

## Key Terms

* Object-Under-Test - The specific object or class on which a given
  unit-test focuses (your unit tests do focus on a single object at
a time, don't they?)
* Collaborator - A secondary object whose behavior we are not focusing
  on in a unit test, but which is needed for our Object-Under-Test to do
its work. ActiveRecord associations are a common example.
* State verification - Testing based on begin/end state of our test
  objects (order count starts at 5, ends at 6, etc.)
* Behavior verification - Testing based on incoming/outgoing messages
  and parameters (Order receives `#place_order` with item id 5 and
quantity 3) -- better isolation; let your objects control their own
state.
* Double - Generic term for this family of stand-in test objects. (Comes
  from idea of a stunt double)
* Mock - A stand-in object which implements enough functionality to make
  it a useful replacement for a collaborator. Often includes
pre-programmed responses and validation of received messages.
* Stub - Act of scripting an object with pre-programmed responses to
  certain expected inputs. Often done to override the "real"
implementation with something we control.
* Expectation - In this context an expectation functions similarly to a
  stub, but it includes some mechanism for verifying that the expected
behavior was actually invoked.

__Caveat: this terminology is much-debated in the TDD community.
So if you come across alternate uses of the terms, don't be surprised.__

## Common Approaches

* "Classical" TDD -- use the real objects whenever possible, and insert
  a mock or stub when the real thing becomes a pain. Tends to be
slightly lazier and more pragmatic. This is how most people tend to
operate in a rails context.
* "Mockist" or "Pure" TDD -- pursue a more zealous isolation of our
  object-under-test, turning to test doubles wherever possible to remove
external dependencies. Gives great isolation, speed and design feedback
about your Object APIs. Requires more work. "Dream Driven Development". Very powerful when TDD-ing a multi-layered system from scratch.

## Popular tools

* Minitest::Mock -- most barebones, included in basic minitest. API is
  more laborious to use.
* Mocha -- popular mocking/stubbing add-on to test-unit or minitest.
  Gives very nice API. Somewhat invasive use of metaprogramming.
* Rspec mocks -- Rspec has its own mocking and stubbing library built
  in.

## Exercise -- Mockical Creatures

Work through this short exercise as an introduction to mocking and
stubbing: [Mockical-Creatures](https://github.com/turingschool/mockical-creatures)

## Exercise -- Independent Project Testing

You recently finished individual rails projects. Let's revisit those
with an eye toward mocking and stubbing. Pull up your individual project
and read through the test suite with an eye for:

* a) A test which required elaborate or laborious setup to implement a
  simple test requirement (3rd party APIs or complicated ActiveRecord
  relationships can often cause this)
* b) something you would have liked to test but did not because of how
  difficult the setup would have been

Apply Mocking/Stubbing techniques to your tests. If you project uses
Rspec you'll likely want to just use rspec-mocks. If you were using
Minitest, take your pick of Mocha or built-in Minitest::Mocks. See if
you can cleanup an otherwise tedious test implementation by inserting a
mock or stub.


## Further Reading

* [Mocks aren't Stubs](http://martinfowler.com/articles/mocksArentStubs.html)
* [TimeCop](https://github.com/travisjeffery/timecop)
* [Mocking and Stubbing in Ruby and Rails](http://www.ibm.com/developerworks/library/wa-mockrails)
* [Mocha Readme](https://github.com/freerange/mocha)
* [Rspec Mocks](https://github.com/rspec/rspec-mocks)
