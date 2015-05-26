---
title: How Testing Works
length: 60
tags: ruby, testing, tdd
---


## Resources

[Here](https://github.com/JoshCheek/how-to-test) is some material, based on the this lesson plan, initially given out to 1505. We had 2 hours for it, but wound up going over (had to spend time on unanticipated things like how to open a file in their editor, how to clone a repo, and what methods and classs are).

## Structure

- Intro (10 min.)
- Intro to Minitest (10 min.)
- Intro to TDD (10 min.)
- TDD Code Along (60 min.)

## Intro

- Show a class in a text editor with a method already implemented (Calculator class at the time of writing).
- How do we confirm that it is working?
- Load class into pry and demo how to test manually
- What are the downsides to this approach?

## Intro to Minitest

- Show a test using Minitest that tests a method in class from above
- Review how to set up a test class
- Introduce assert, assert_equal, refute, refute_equal

## Intro to TDD

- What is TDD?
- Why write the tests first?
  - Helps break problem into small pieces
  - Removes fear of programming
  - Communicates what your code _should_ do
  - Shapes design
- Red, green, refactor
- Write pseudo code to start your tests.
- Imagine how you want it to work.

## TDD Code Along

- Build the calculator class from scratch.
- Write pseudo code in the test file first for a few methods
  - .new
  - #total
  - #add
  - #clear
  - #subtract
