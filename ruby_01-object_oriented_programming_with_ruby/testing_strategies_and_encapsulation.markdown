---
title: Testing Strategies and Encapsulation
tags: basics, testing, encapsulation
length: 90
---

# Testing Strategies, or: How to help testing help us

## Learning Goals

* Understand that TDD is about asking questions and making decisions
* Understand the role of TDD in streamlining the problem-solving and design process.
* Be able to characterize the interface of a component and illustrate it with tests
* Be able to name and explain the four key types of tests
* Be able to explain and apply the "two-mindset approach" to TDD

## Structure

* Lecture 1 - 25 minutes
* Work 1 - 20 minutes
* Lecture 2 - 25 minutes
* Work 2 - 20 minutes
* Closing

## Lecture 1

### Introduction

* TDD takes 18 months before it feels natural.
* There are two pieces to testing - validation and design.
* Validation - Does the software do what it is supposed to do?
* Design - Documents what the code does. Helps determine what software should
do and how you know it works.

### Why Don't People Like Testing?

* Tests don't run like normal code.
* Extra things and DSLs to learn.
* Testing feels like a different method of execution, it's a different paradigm.
* Testing compels you to make hard decisions early, and up front.
* This is scary because you are making decisions in a context you don't understand.
* Testing (especially in the context of TDD) is a discipline tool -- forces you to a) be **specific** about what you are trying to do and b) stay **focused** on that objective

### Testing Process -- Isolating Functionality

* What makes a test easy to write? What makes it hard?
* Can we identify the input?
* Can we identify the output?
* The "interface"
* How do we characterize the transformation from input to output?

### The Essence of Testing -- Asking Questions

* Programming can be conceptually draining
* Have to make lots of small decisions
* Easy to let these decisions become implicit or arbitrary
* Testing is valuable because it forces us to make more of these decisions explicit
* Ask questions and illustrate design _first_ -- now it's more obvious and can help
us drive the design

## Work 1 - Questions & Decisions

Let's think about *the questions that lead to decisions*. Pair up with another student for one of the following short exercises.

For each exercise, you'll be given a technical prompt describing an application you will be writing.
Imagine that you are beginning development of the project, and create a list of the *questions* that you'd have to answer in the context of writing your first few tests.

For each question, describe:

* What is the question?
* Why do we need to answer this question **now** (at the first stages of development)?

Questions can be a mix of the **conceptual**, like:

    Question: Should we try to handle all the tags at once or one at a time? If the latter, which one should be first?
    Why do we need to answer this now: We need to know which part of the solution to start our implementation with.

And the more **specific**:

    Question: What will the class be named?
    Why do we need to answer this now: I can't write a first test without instantiating an object and need the classname to call `.new` on it.

    Question: Where should we put our first file?
    Why do we need to answer this now: We can't write code until we have a file to put it in.

As a pair you should be able to come up with at least 10 questions.

    Question: ...
    Why do we need to answer this now: ...


### Choice 1 -- Markdown Parser:

    We're writing a markdown parser that can take in a line of markdown and output a line of HTML. For instance:

      This is *a sample* with some **emphasis**.

    Which in HTML form is:

      <p>
        This is <em>a sample</em> with some <strong>emphasis</strong>.
      </p>

### Choice 2 -- Braille Converter:

    We're writing a program that can convert a letter of ASCII-ized Braille text into the equivalent latin-alphabet character.

    For example:
    0.
    00
    ..

    Should become "h"

## Lecture 2 - Types of Tests

### 2-Mindset Approach

### General discipline / process Discussion

* Why is it especially hard to get started on a development project?
* What is the point of a development process or technique (not a code technique but a workflow / process one)?
* We sometimes describe some dev processes or techniques as playing "mind games" with ourselves -- can you think of any?

### TDD Mindgames -- The Two-Mindset Approach

TDD Wants to help us solve some of these problems and get moving on our software projects. It's helpful to think of it in
terms of 2 mindsets -- at each phase of the work we want to place ourselves in one of the mindsets and stay focused on the task
that embodies.

* Mindset 1
  * Low Visibility
  * High Exposure
  * Everything is possible.

* Mindset 2
  * Has to deal with Mindset 1.

* Mindset 1 writes the test.
* Mindset 2 makes what Mindset 1 wants to happen a reality.

These two mindsets have to work independently. Mindset 1 cannot deal with the details of how to make things happen.

### Hierarchy of Tests

[TestPyramid](http://martinfowler.com/bliki/TestPyramid.html)

![TestPyramid](http://martinfowler.com/bliki/images/testPyramid/pyramid.png)

* Acceptance
* Feature
* Integration
* Unit

*Unit Test* - tests one component in isolation.

*Integration Test* - tests multiple interdependencies or coordinating components.

*Feature Test* - a single feature as experienced by a user.

*Acceptance Test* - a collection of user functionalities that delivers business value.

Feature and Acceptance Tests are customer-centric while Unit and Integration Tests are programmer-centric.
Especially when you move into web development projects in later modules you'll rely more heavily on Acceptance and
Feature tests to verify the behavior of your application as it wil eventually be experienced by a user.

In Module 1, on the other hand, we will rely much more heavily on **Unit** and **Integration** tests -- and it's very
important to have a good mix of both!

## Work 2

Let's think about *a hierarchy of tests*. Pair up with another student for this exercise. Given this technical problem:

Imagine that you are beginning development of the project. Create a list of tests following the idea of hierarchy we just discussed.

For now, focus on **Unit** and **Integration** tests. Try following this format:

    Type: Unit
    Question: How will we parse a single emphasis marker within a line or markdown?
    Why: A line of Markdown may have an emphasis
    Input: Markdown like "this is *a sample*"
    Output: HTML like "this is <em>a sample</em>"

As a pair you should be able to come up with at least four tests for each level.

**Note** -- Don't be afraid to identify additional, *smaller* components that might exist in your system. For example you might identify a component to help split your document into separate tokens, etc etc. This kind of brainstorming is very helpful at the outset of a project, even if all of the components you imagine don't end up making it into the final design.

### Choice 1 - Chisel

    You're writing a whole Markdown processor which takes in complete Markdown files and outputs full HTML files.

If you'd like to see a full project spec for this, [check out Chisel](https://github.com/turingschool/curriculum/blob/master/source/projects/chisel.markdown).

### Choice 2 - Nightwriter

    You're writing a whole Braille-text to Latin Alphabet converter which can read from a file of ASCII-ized braille characters and output a file of Latin Text.

If you'd like to see a full project spec for this, [check out Night Writer](https://github.com/turingschool/curriculum/blob/master/source/projects/night_writer.markdown).

### Closing -- TDD Workflow Recap

* What are you trying to build? Why?
  * You would be will well-served to write a sentence on what you are building and why.
* How will you know when it works?
  * Acceptance tests are written by the stakeholder and are the last test to pass.
* What's the smallest/simplest representation of the input?
  * [ ] => [ ]
  * [1] => [1]
  * [1,5] => [1,5]
  * [5,1] => [1,5]
  * [1,5,6] => [1,5,6]
  * [6,5,1] => [1,5,6]
* What is the start state / input?
* What are the processes / steps?
* Are the results correct?
* What's the next most difficult input?
