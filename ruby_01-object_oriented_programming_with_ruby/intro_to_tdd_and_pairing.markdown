---
title: Intro to TDD & How to Pair
length: 150
tags: ruby, tdd, pairing
---

## Standards

#### Pairing
* explain the purpose of pairing
* demonstrate the roles of driver and navigator while pairing
* give contextual, actionable, relevant, encouraging, and specific feedback to pair

#### TDD
* install a Ruby gem
* create and run a minitest test suite
* write assertions using minitest
* read error messages
* fix error messages
* read test failures
* fix failing assertions
* explain and demonstrate the TDD workflow

## Structure
* 15 - Introduction to pairing (lecture)
* 15 - Practice pairing away from code (pairs)
* 5 - Pair feedback and recap (group)
* 15 - Introduction to TDD (lecture)
* 20 - TDD code-along
* 5 - Questions about TDD
* 5 - Break
* 85 - TDD tutorial (pairs)
* 5 - Standards check/wrapup (group)

## Introduction to Pairing (lecture)

#### What is it?
* Share out ideas about what pair programming is/isn't
* Introduce standards for session
* Define pair programming
* Purpose of pairing

#### Roles and Process
* Roles: driver and navigator
* Responsibilities of both roles
* Read this [description](http://www.wikihow.com/Pair-Program) of the pair programming process

#### Pairing at Turing
* Pairing at Turing: varying levels, don't be afraid to fail or be wrong
* Tools: external monitors, keyboards, mice
* Giving feedback: contextual, actionable, relevant, encouraging, specific

## Practice Pairing Away from Code (pairs)

Use [this example LSAT game](https://www.manhattanlsat.com/Logic-Game-Example.cfm) to practice pairing.
* Pair for 12 minutes to solve problem(s)
* Three minutes for feedback
* Gather back together as group to recap

## Introduction to TDD (lecture)

#### What is it?

* Share out ideas about what TDD is/isn't
* Introduce standards for session
* Definition of TDD
* Why TDD?

## TDD Code-Along

#### File Structure
* One project folder
* One file for test code
* One file for implementation code

#### Specifications for Code-Along

* Students should have names
* Students should have laptops. The laptop is usually an Apple, but it can be any brand
* Students can bring various flavors of cookies to their instructors

#### Code-Along

* Demonstrate setting up folder and files, students do the same
* Prepare test file with gem, require `minitest/autorun` and `minitest/pride`
* Tests in Minitest start with `def test_something`..
* Create class StudentTest that inherits from minitest
* Write test for first specification (students should have names):

```ruby
def test_student_has_a_name
  stu = Student.new("Stu")
  assert_equal "Stu", stu.name
end
```
* Run test, read error message, and fix
* Write implementation code to make test pass

```ruby
class Student
  attr_reader :name
  def initialize(name)
    @name = name
  end
end
```
* Repeat process for remaining specifications

#### Questions? Misunderstandings?

## TDD Tutorial (pairs)

Practice TDD and pairing with this [tutorial](http://tutorials.jumpstartlab.com/topics/testing/intro-to-tdd.html).

## Wrapup

Return to standards and check progress.
* What was easy?
* What was challenging?
* What made sense?
* What didn't make sense?

## Corrections & Improvements for Next Time

### Taught by Rachel on 9/9
