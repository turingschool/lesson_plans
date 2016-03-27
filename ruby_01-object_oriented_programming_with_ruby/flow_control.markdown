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

## Discussion

* How does Ruby determine the order in which statements in our code get evaluated?
* How does Ruby evaluate a more complicated assignment statement?
* How can we tell Ruby to do one thing or the other?
* How can we tell Ruby to choose one out of a list of possible choices?
* How can we tell Ruby to do one thing over and over?

## Tools - Working with Input and Output

* How do we tell Ruby to output text to the screen?
* How do we tell Ruby to _read_ text from the user?

## Exercises

### 1. Basic `puts` / `gets`

Write a simple Ruby program which prompts the user to enter a message, then prints that message to the terminal. For example:

```
Type your message:
(user types "pizza" and presses enter)
pizza
```

### 2. Basic Branching

Extend your previous program so that if the text the user enters has an even number of letters, it prints "EVEN!", and if it has an odd number of letters, it prints "ODD!".

### 3. Multi-pronged branching

Write a new program that prompts the user for a message, then, depending on the following conditions, prints an appropriate message:

* If the message ends with a consonant, print "CONSONANT!"
* If the message ends with a vowel, print "VOWEL!"
* If the message ends with a "y", print "DON'T KNOW!"

### 4. Easy Looping

Use a `times` loop to generate this output:

```
Line
Line
Line
Line
Line
```

### 5. Looping with a Condition

Build on your answer from the problem above and add an `if`/`else` to generate output like this:

```
Line is even
Line is odd
Line is even
Line is odd
Line is even
```

### 6. Three Loops

Generate the output below using three totally separate implementations (`times`, `while` and `loop`):

```
This is my output line 1
This is my output line 2
This is my output line 3
This is my output line 4
This is my output line 5
```

### 7. Rando-Guesser

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
