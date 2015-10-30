---
title: Refactoring Patterns
length: 180
tags: ruby, refactoring, tdd
---

## Learning Goals

* Understand how refactoring fits into the RED-GREEN-REFACTOR cycle
* Know the difference between refactoring and "changing shit"
* Be able to apply the Move Method refactoring pattern
* Be able to apply the Extract Class refactoring pattern
* Be able to apply the Hide Delegate refactoring pattern

## Structure

* 5 - Warmup
* 20 - Lecture
* 5 - Break
* 10 - Lecture Wrapup
* 15 - Start First Refactoring Exercise (Individual)
* 5 - Break
* 25 - Finish First Refactoring Exercise (Individual)
* 5 - Break
* 25 - Start Second Refactoring Exercise (Paired)
* 5 - Break
* 25 - Continue Second Refactoring Exercise (Paired)
* 5 - Break
* 25 - Finish Second Refactoring Exercise (Paired)
* 5 - Wrapup

## Warmup

Attempt to answer these five questions:

1. Why do we refactor?
2. What's the difference between "refactoring" and "changing shit"?
3. What role do patterns play in refactoring?
4. Why do some refactoring patterns seem to be opposites?
5. Does refactoring always make code better?

## Lecture

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

## Stations and Exercises

For the remaining three segments students will disburse and work through three
separate station exercises.

* [Station 1](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/refactoring_patterns_station_1.markdown)
* [Station 2](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/refactoring_patterns_station_2.markdown)
* [Station 3](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/refactoring_patterns_station_3.markdown)

After an initial recap of the material from each station, we'll get some
practice with refactoring by applying the concepts described to these
2 enigma projects.

Spend __1 hour__ working on the first project by yourself,
then join a pair and work on the second project for __1 hour__.

The projects can be found here:

* [Enigma Refactoring Exercises](https://github.com/turingschool-examples/enigma_refactoring_exercises)

## Wrapup

Return to your answers from the warmup. Can you improve them now?

## Follow Up

* Tonight you should watch [Katrina's Therapeutic Refactoring talk](http://confreaks.tv/videos/cascadiaruby2012-therapeutic-refactoring).
* The readings we used today can be [found here](https://dl.dropboxusercontent.com/u/69001/Refactoring/Refactoring%20-%20Chapter%207.pdf).

### Notes

* Make reading a homework assignment for the night before
* Shorten centers length (since they won't have to read during that time)
* Try the same stations / rotation with a more sophisticated example --
probably an old enigma with some intentional obfuscations
* Try initial exercises individually
* Then get with a pair
* Then do a second pass for the following "pairing exercise"
on another codebase
* Second pass should require them to write tests first
before their refactoring
* Project for second pass should have low test coverage or
possibly some tests intentionally removed
