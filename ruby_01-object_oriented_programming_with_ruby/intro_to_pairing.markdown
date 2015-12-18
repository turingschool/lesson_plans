---
title: Intro to Pairing
length: 60
tags: ruby, pairing
---

## Learning Goals

* Understand the purposes of pairing
* Be able to apply simple pairing patterns like Driver/Navigator
* Be able to setup a productive physical/virtual pairing arrangement

## Introduction to Pairing (lecture)

### What is it?

* What have you heard about pair programming?
* Defining pair programming
* Who uses pairing?
* Why do they do it?
* Patterns for skill differentials

### Skill Differential Pairs

* Expert / Novice - Novice gets raised, Expert questions preconceptions.
* Intermediate / Novice - Novice learns to ask good questions, Intermediate digs deeper.
* Novice / Novice - Safe space, great chance for experimentation.

### Patterns

* Driver/Navigator
* Popcorn
* Tag

### Feedback

Giving and asking for feedback:

* investing in each other
* short and difficult > long and painful
* good feedback is contextual, actionable, relevant, encouraging, specific

### The Work Environment

* Physical space: one monitor, two keyboards, one computer
* Virtual space (or physical, too): ScreenHero, etc

## Practice Pairing Away from Code

Let's try [this LSAT game](http://cl.ly/2g0S0F070m0h) and apply the *Driver/Navigator* pattern.

* Pair for 12 minutes to solve problem(s)
* Three minutes for feedback
* Gather back together as group to recap

## Pairing with Code

Let's implement some fake enumerables and practice pairing with these short challenges:

* Without using `select`, `find_all`, or `detect`, write code that finds seven-letter words in a collection of words
* Without using `any?`, write code to find whether or not there are any instances of `"hello"` in a collection of words
* Without using `group_by`, write code to group a collection of words by their length (with the length as the key and
the words in an array as the value)
