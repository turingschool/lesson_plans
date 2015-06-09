---
title: Testing Strategies and Encapsulation
tags: basics, testing, encapsulation
length: 120
---

## Learning Goals

* Be able to execute a strategy for writing tests and implementation
* Be able to build a small component of a larger system in isolation

## Topics

### Introduction

* TDD takes 18 months before it feels natural.
* There are two pieces to testing - validation and design.
* Validation - Does the software do what it is supposed to do?
* Design - Documents what the code does. Helps determine what software should
do and how you know it works.

### Why Don't People Like Testing?

* Code is a liability.
* Extra things and DSLs to learn.
* Tests don't run like normal code. 
* Testing feels like a different method of execution, it's a different 
paradigm.
* Testing compels you to make hard decisions early, and up front.
* This is scary because you are making decisions in a context you don't
understand.

### Types of Tests

#### Hierarchy of Tests

* Acceptance
* Feature
* Integration
* Unit

Unit Tests - tests one component in isolation.

Integration Tests - tests multiple interdependencies or coordinating components.

Feature Tests - a single feature as experienced by a user.

Acceptance Tests - a collection of user functionalities that delivers business value.

* Feature and Acceptance Tests are customer centric.
* Unit and Integration Tests are programmer centric.

#### Hourglass Testing

* There should be many Acceptance and Unit tests, and fewer feature and integration tests. 
 
### Strategies for Testing

* What are you trying to build? Why?
  * You would be will served to write a sentence on what you are building and why. 
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

#### The Garlic Press

* Imagine a garlic press.
* A clove of garlic goes in and shredded garlic comes out.
* The clove of garlic is the expected input.
* The shredded garlic is the expected output.
* The mechanics of how a clove of garlic becomes the shredded garlic doesn't really matter.

### Two Minded Approach

* Mindset 1
  * Low Visibility
  * High Exposure
  * Everything is possible.

* Mindset 2
  * Has to deal with Mindset 1.
  
* Mindset 1 writes the test.
* Mindset 2 makes what Mindset 1 wants to happen a reality.
* These two mindsets have to work independently. Mindset 1 cannot deal with the
details of how to make things happen.

### Isolating a Component

* Can we identify the input?
* Can we identify the output?
* The "interface"

## Challenges

* Rendering [URL Autolinks](https://help.github.com/articles/github-flavored-markdown/#url-autolinking)
* Handling [strikethrough text](https://help.github.com/articles/github-flavored-markdown/#strikethrough)
* Parsing [markdown images](http://daringfireball.net/projects/markdown/syntax#img)
