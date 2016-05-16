---
title: How Testing Works
length: 60
tags: ruby, testing, tdd
---

## Goals

* Write a test using MiniTest
* Define and demonstrate the four phases of testing
* Use error messages to drive development

## Intro

- How did you confirm that your Deaf Grandma program was working correctly? 
- What are the downsides to this approach?

## Intro to TDD

- What is TDD?
- Why write the tests first?
  - Helps break problem into small pieces
  - Removes fear of programming
  - Communicates what your code _should_ do
  - Shapes design
  - Tells you basically exactly what to do
- Red, green, refactor
  - Write a failing test (red)
  - Write implementation code to make the test pass (green)
  - Clean up your code if necessary (refactor)
- Write pseudo code to start your tests.
- Imagine how you want it to work.
- Four phases of testing: setup, exercise, verify, teardown

## Intro to Minitest

- [Minitest](http://docs.seattlerb.org/minitest/) is a framework used for automated testing. 
- Where have you seen MiniTest used before? 
- What are some things you've noticed about the setup of tests? 
- `assert`
- `assert_equal` 
- `refute`
- `refute_equal`
- `assert_nil` 
- `assert_instance_of`

## Things to Remember

- Two directories: `lib` and `test`
- Filenames: `test/name_of_class_test.rb`
- `require 'minitest/autorun'`
- `require "./lib/name_of_class.rb"`
- Test Class Name: `class NameOfClassTest < Minitest::Test`
- `def test_something` for names of methods in test file -- **MUST** start with `test`

## TDD Code Along

- Build the calculator class from scratch using TDD
- Write pseudo code in the test file first for a few methods
  - .new
  - #total
  - #add
  - #clear
  - #subtract

## Your Turn

In pairs, TDD a `Fish` and a `Fishtank`. It is up to you and your pair to determine the attributes and states of each of these objects.

## Resources

* Blog post: [Why Test Driven Development?](http://derekbarber.ca/blog/2012/03/27/why-test-driven-development/)
* Want a written-out tutorial on TDD with Minitest? [Check here](http://tutorials.jumpstartlab.com/topics/testing/intro-to-tdd.html). 
* [Here](https://github.com/JoshCheek/how-to-test) is some material, based on the this lesson plan, initially given out to 1505. We had 2 hours for it, but wound up going over (had to spend time on unanticipated things like how to open a file in their editor, how to clone a repo, and what methods and classs are).
