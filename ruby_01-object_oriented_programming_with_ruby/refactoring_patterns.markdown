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
* 30 - Lecture
* 5 - Break
* 40 - Stations Session 1
* 5 - Break
* 40 - Stations Session 2
* 5 - Break
* 40 - Stations Session 3
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

## Stations

For the remaining three segments students will disburse and work through three
separate station exercises.

## Wrapup

Return to your answers from the warmup. Can you improve them now?

## Follow Up

* Tonight you should watch [Katrina's Therapeutic Refactoring talk](http://confreaks.tv/videos/cascadiaruby2012-therapeutic-refactoring).
* The readings we used today can be [found here](https://dl.dropboxusercontent.com/u/69001/Refactoring/Refactoring%20-%20Chapter%207.pdf).
