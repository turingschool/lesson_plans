---
title: Flow Control
length: 60
tags: fundamentals, computer science
---

# Flow Control

## Learning Goals

* Understand the normal flow of execution through a chunk of code
* Understand how evaluation happens in an assignment
* Understand how evaluation happens when method calls are inside method calls
* Be able to apply the `times` method to repeat instructions
* Be able to use `while` and `until` to repeat instructions
* Be able to use `loop` and `break` to repeat instructions
* Understand how to break out of an infinite loop in both IRB and regular Ruby
* Be able to use `if` statements to control execution
* Be able to use an `else` statement to create an alternative path

## Exercises

### 1. Easy Looping

Use a `times` loop to generate this output:

```
Line
Line
Line
Line
Line
```

### 2. Looping with a Condition

Build on your answer from the problem above and add an `if`/`else` to generate output like this:

```
Line is even
Line is odd
Line is even
Line is odd
Line is even
```

### 3. Three Loops

Generate the output below using three totally separate implementations (`times`, `while` and `loop`):

```
This is my output line 1
This is my output line 2
This is my output line 3
This is my output line 4
This is my output line 5
```

### 4. Rando-Guesser

Write two implementations, one with `while` and one with `loop` that output the following:

```
(The secret number is 8)
Guess is 4
Guess again!
Guess is 5
Guess again!
Guess is 9
Guess again!
Guess is 4
Guess again!
Guess is 8
You win!
```

The secret number and the guesses are both random numbers 0 through 10.
