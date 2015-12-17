---
title: Testing Strategies and Encapsulation
tags: basics, testing, encapsulation
length: 120
---

## Learning Goals

* Be able to characterize the interface of a component and illustrate it with tests
* Understand that TDD is about asking questions and making decisions
* Be able to name and explain the four key types of tests
* Be able to explain and apply the "two-mindset approach" to TDD

## Structure

* Lecture 1 - 25 minutes
* Work 1 - 20 minutes
* Lecture 2 - 25 minutes
* Work 2 - 20 minutes
* Closing

## Content

### Lecture 1

#### Introduction

* TDD takes 18 months before it feels natural.
* There are two pieces to testing - validation and design.
* Validation - Does the software do what it is supposed to do?
* Design - Documents what the code does. Helps determine what software should
do and how you know it works.

#### Why Don't People Like Testing?

* Code is a liability.
* Extra things and DSLs to learn.
* Tests don't run like normal code.
* Testing feels like a different method of execution, it's a different
paradigm.
* Testing compels you to make hard decisions early, and up front.
* This is scary because you are making decisions in a context you don't
understand.

#### Isolating Functionality

* Can we identify the input?
* Can we identify the output?
* The "interface"
* How do we characterize the transformation from input to output?

### Work 1 - Questions & Decisions

Let's think about *the questions that lead to decisions*. Pair up with another student for this short exercise. Given this technical problem:

    We're writing a markdown parser that can take in a line of markdown and output a line of HTML. For instance:

      This is *a sample* with some **emphasis**.

    Which in HTML form is:

      <p>
        This is <em>a sample</em> with some <strong>emphasis</strong>.
      </p>

Imagine that you are beginning development of the project. Create a list of the *questions* that you'd have to answer in the context of writing your first few tests. For example:

    Question: What will the class be named?
    Why: I can't write a first test without instantiating an object and need the classname to call `.new` on it.

    Question: ...
    Why: ...

As a pair you should be able to come up with at least 10 questions.

### Lecture 2 - Types of Tests

#### Hierarchy of Tests

* Acceptance
* Feature
* Integration
* Unit

*Unit Test* - tests one component in isolation.

*Integration Test* - tests multiple interdependencies or coordinating components.

*Feature Test* - a single feature as experienced by a user.

*Acceptance Test* - a collection of user functionalities that delivers business value.

Feature and Acceptance Tests are customer-centric while Unit and Integration Tests are programmer-centric.

#### 2-Mindset Approach

* Mindset 1
  * Low Visibility
  * High Exposure
  * Everything is possible.

* Mindset 2
  * Has to deal with Mindset 1.

* Mindset 1 writes the test.
* Mindset 2 makes what Mindset 1 wants to happen a reality.

These two mindsets have to work independently. Mindset 1 cannot deal with the details of how to make things happen.

### Work 2

Let's think about *a hierarchy of tests*. Pair up with another student for this exercise. Given this technical problem:

    You're writing a whole Markdown processor which takes in complete Markdown files and outputs full HTML files.

If you'd like to see a full project spec for this, [check out Chisel](https://github.com/turingschool/curriculum/blob/master/source/projects/chisel.markdown).

Imagine that you are beginning development of the project. Create a list of tests following the idea of hierarchy we just discussed. Try following this format:

    Type: Unit
    Question: How will we parse a single emphasis marker within a line or markdown?
    Why: A line of Markdown may have an emphasis
    Input: Markdown like "this is *a sample*"
    Output: HTML like "this is <em>a sample</em>"

As a pair you should be able to come up with at least four tests for each level.

### Closing

* "Hourglass Testing"

### Appendix - A Strategy for Testing

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
