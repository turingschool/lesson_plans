---
title: How Testing Works
length: 60
tags: ruby, testing, tdd
---

## Goals
* Define and demonstrate a testing cycle
* Write a test using MiniTest
* Use error messages to drive development

## Intro to Test-Driven Development (TDD)
How did you confirm your last projects were working correctly? What are the downsides to this approach? As we write increasingly complex applications, we'll need more sophisticated testing approaches to secure the same level of confidence.

TDD is a process for writing code that helps you ensure your code works the way you intend, is understandable to others, and is cheap and easy to change.

We will review how to use TDD to build applications. TDD consists of writing tests before you write code (radical, I know), using a testing framework such as Minitest to structure your testing suite, and using a red-green-refactor process to add complexity to your application.

### Write Tests First
Why write the tests first?
  - Helps break problem into small pieces
  - Removes fear of programming
  - Communicates what your code _should_ do
  - Shapes design
  - Tells you basically exactly what to do

Let's say I'm building a model to represent a house. What testing assertions could I define that would prove to me, once they're all true, that I've in fact built the house I expect?

- Does it have a roof?
- Does it have a foundation?
- Does it have windows?
- Does it have walls?
- Do the walls create rooms?
- Does it have a kitchen? a bedroom? a bathroom? a living room?

#### Practice
Work with a partner. What testing questions could you ask to verify that the following models have been created appropriately?

- An office
- A movie set
- A staircar

### New Tool: Minitest
[Minitest](http://docs.seattlerb.org/minitest/) is a framework used for automated testing. It is the testing framework used on many of the homework exercises you've been assigned.

#### Discussion
Discuss with a partner. What are some things you've noticed about the setup of tests? What effect do these statements have?
- `assert`
- `assert_equal`
- `refute`
- `refute_equal`
- `assert_nil`
- `assert_instance_of`

#### Practice
Pick one of the models from the previous exercise (an office, a movie set, a staircar) and use Minitest to turn your assertions into real Ruby tests.

#### Test Etiquette
- Run your individual test file by running `ruby test/name_of_file_test.rb`
- Two directories: `lib` and `test`
- Filenames: `test/name_of_class_test.rb`
- `require 'minitest/autorun'`
- `require "./lib/name_of_class.rb"`
- Test Class Name: `class NameOfClassTest < Minitest::Test`
- `def test_something` for names of methods in test file -- **MUST** start with `test`

If you have extra time, explore how your code breaks when you don't follow the rules above.

### Red, Green, Refactor
Red-green-refactor is a process for writing code that involves three steps.
  - Write a failing test (red)
  - Write implementation code to make the test pass (green)
  - Clean up your code if necessary (refactor)

#### Learn to Love the Error, Learn to Love the Failure 
They're your friends, seriously. Take time to understand each error and failure you encounter. 

#### Practice
Now that you have a failing test from the exercise above, finish the red-green-refactor loop by writing code to pass the test and refactoring.


## Bring It All Together

### TDD Code Along
- Build a calculator class from scratch using TDD
- Start with whiteboarding and pseudocode
- Write pseudo code in the test file first for a few methods
- Your calculator should be able to handle the following methods
  - .new
  - #total
  - #add
  - #clear
  - #subtract

### Practice
In pairs, TDD a `Fish` and a `Fishtank`. It is up to you and your pair to determine the attributes and states of each of these objects.

## Resources
* Blog post: [Why Test Driven Development?](http://derekbarber.ca/blog/2012/03/27/why-test-driven-development/)
* Want a written-out tutorial on TDD with Minitest? [Check here](http://tutorials.jumpstartlab.com/topics/testing/intro-to-tdd.html).
* [Here](https://github.com/JoshCheek/how-to-test) is some material, based on the this lesson plan, initially given out to 1505. We had 2 hours for it, but wound up going over (had to spend time on unanticipated things like how to open a file in their editor, how to clone a repo, and what methods and classs are).
