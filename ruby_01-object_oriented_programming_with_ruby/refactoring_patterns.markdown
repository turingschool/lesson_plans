---
title: Refactoring Patterns
length: 120
tags: ruby, refactoring, tdd
---

## Learning Goals

* explain how refactoring fits into the RED-GREEN-REFACTOR cycle
* identify the difference between refactoring and "changing shit"
* define and apply the Move Method refactoring pattern
* define and apply the Extract Class refactoring pattern
* define and apply the Hide Delegate refactoring pattern

## Structure

* 5 - Warmup
* 20 - Key Points
* 5 - Check for Understanding
* 5 - Break
* 25 - Choosing the Appropriate Refactoring Tactic (15 min individual work, 10 min group work)
* 5 - Break
* 15 - First Refactoring Station (Groups)
* 15 - Second Refactoring Station (Groups)
* 5 - Break
* 15 - Third Refactoring Station (Groups)
* 5 - Wrap Up and transition into Enigma Exercises

## Warmup

Attempt to answer these five questions:

1. Why do we refactor?
2. What's the difference between "refactoring" and "changing shit"?
3. Does refactoring always make code better?

## Key Points

Let's start by discussing Refactoring at a high level:

* The "Red-Green-Refactor" loop
* "Refactoring" brought into the mainstream by Martin Fowler's
"Refactoring: Improving the Design of Existing Code" in 1999
* Changing the internals of code without changing the external behavior
* "I'm paid to write features, not refactor."
* The concept of technical debt and awkward analogies to personal debt
* Software patterns are common solutions to common problems
* Refactoring patterns are common *transformations*, not *improvements*.
* Look for resiliency to change
* There are commonly *pairs* of patterns around the same idea
* Jay Fields revised Fowler's book for Ruby:
[Refactoring: Ruby Edition](http://www.amazon.com/Refactoring-Edition-Addison-Wesley-Professional-Series/dp/0321984137)
* Three common refactoring patterns
  * Move Method
  * Extract Class
  * Hide Delegate

### Check for Understanding
Describe the three common refactoring patterns (move method, extract class, hide delegate) and in what scenarios they should be used. Post your answers to Slack.

## Choosing the Appropriate Refactoring Tactic
### Individual Work
Identify 1 scenario suited to each type of refactor (3 total). Use [past M1 projects](https://github.com/turingschool/ruby-submissions/tree/master/1606-b) for inspiration. Post responses on the Google sheet posted in Slack.

### Group Work
In groups of 3, assign one tactic to each person in your group and one-by-one have each member teach-back their tactic and the matching scenario they picked. Each member should explain to the group:
  1. What the tactic is,
  2. When to use the tactic, and
  3. Why the scenario you picked is a good match for the tactic.  

## Refactoring Pattern Stations
For the remaining time students will disburse and work through three separate station exercises in small groups of three. 

For the **first 10 minutes of each station**, work through the exercise independently. For the **last 5 minutes of each station**, review your refactored code together and address any discrepancies between your answers -- are they a matter of personal style or deviations from convention?

* [Station 1](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/refactoring_patterns_station_1.markdown)
* [Station 2](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/refactoring_patterns_station_2.markdown)
* [Station 3](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/refactoring_patterns_station_3.markdown)

## Follow Up: Enigma Refactoring Exercises

Students should join a pair to work on applying these techniques to a sample Enigma project using [these exercises](https://github.com/turingschool-examples/enigma_refactoring_exercises).

## Follow Up

* Tonight you should watch [Katrina's Therapeutic Refactoring talk](http://confreaks.tv/videos/cascadiaruby2012-therapeutic-refactoring).
* The readings we used today can be [found here](https://dl.dropboxusercontent.com/u/69001/Refactoring/Refactoring%20-%20Chapter%207.pdf).
