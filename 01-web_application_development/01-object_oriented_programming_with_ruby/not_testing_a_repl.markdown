---
title: (Not) Testing a REPL
length: 90
tags: ruby, repl, testing
---

## Learning Goals

* Understand how to "shim" responsibilities apart
* Practice modeling a command-driven system

## Structure

* 25 - Independent Work
* Break
* 25 - Lecture/Demo
* Break
* 25 - Paired Work

## Independent Work

First up let's begin with a challenge. Work on your own to
build a simple ["Polish Notation"](http://en.wikipedia.org/wiki/Polish_notation) calculator.

### The Rules

* Don't write tests
* Don't do anything fancy with STDIN/STDOUT
* Don't use any extra gems
* Don't use the built-in `*` or `/` methods

### The Expectations

Your program should act as a "REPL" -- Read, Eval, Print, Loop. Here's an example interaction:

```plain
Enter your calculation:
> + 5 4
9
> - 12 6
6
> * 4 2
8
> / 10 5
2
```

Write your program to accept any such numeric inputs any of the operations `+`, `-`, `*`, or `/`.

## Lecture

Let's come back together to look at an example of how this could be written with tests using a "shim" technique.

## Paired Work

Now get together with your pair, restart the challenge with the provided base repo, and implement the functions with good test coverage.

Use the following commands to clone the repository:

```
$ git clone https://github.com/turingschool-examples/calculator
```

### Extensions

Get those done? Try implementing:

```plain
> ^ 2 3
8
> < 5 8
true
> > 5 8
false
> = 6 6
true
```
