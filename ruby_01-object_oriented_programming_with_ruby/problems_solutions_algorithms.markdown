---
title: Problems, Solutions, and Algorithms
length: 90
tags: ruby, pseudocode, algorithms
---

## Learning Goals

* Be able to define the terms algorithm, pseudocode, and iteration
* Be able to use pseudocode to describe the flow of an algorithm's implementation
* Be familiar with using iterative processes to design increasingly robust solutions

## Structure

* 10 - Warmup
* 15 - Lecture
* 5 - Break
* 15 - Lecture Cont.
* 10 - Challenge 1
* 5 - Break
* 15 - Challenge 2
* 10 - Challenge 3
* 5 - Closeout

## Warmup

### Part 1 - Writing

First, spend 5 minutes writing an "algorithm" that explains how to tie your shoes.
Try to be as explicit and specific as possible. Assume your reader is a human, but a
very literal one.

### Part 2 - Doing

Now, pair up with your neighbor. The person whose name is alphabetically first will
read their algorithm step-by-step to the person whose name is alphabetically last.
The person whose name is alphabetically last will attempt to tie their shoes according
only to the instructions from their partner.

You can repeat instructions if needed, but don't add any instructions beyond what
you had originally written down.

## Lecture - Big-Picture Strategy

* What is an Algorithm
* Incremental solutions (linear)
* Iterative solutions (spirals)
* Building a full "slice"
* "Half a product not a half-assed product"

### An Iterative Process

A generalized process for solving technical problems:

1. How will you know when the problem is solved? (Identify the big-picture goal)
2. How do you want to use the software? (Indentify the "interface")
3. What's the (next-)most trivial possible case? (Indentify the next small-picture goal)
4. *How* do we achieve this goal? (Sketch an algorithm using pseudocode)
5. Implement it (do programming)
6. Is the whole problem (from step 1) solved? If not, return to 3.

### Exercise 1 -- Common Words

With a pair, answer the questions from steps 1 through 4 for the following problem.
When you get to steps 3 and 4, repeat them at least 3 times for increasing levels of complexity.

**Problem:**

I have a text document and want to know "What are the three most common words in the text?"

*Extension*: Let's exclude the following: I, you, he, she, it, we, they, they, a, an.

### Software Processes / Techniques -- why do we care

* Programming -- what makes it hard? (Translating ideas into code? Or coming up with ideas?)
* **Perception** - A good programmer is someone who solves technical problems *easily*
* **Reality** - A good programmer is someone equipped with the tools and processes to confront challenging problems and still emerge successful
* Problem solving challenges: What to do vs. How to do it
* "Dumping out the toolbox" - controlling nerves and pacing yourself
* Software development techniques are designed to *manage* these difficulties
* TDD
* Pseudocode
* Agile Development

## Remaining Exercises

### Small Groups - Algorithm Challenges

We'll then break into small groups to work through this process for a few different problems.

### Odds & Evens

I have a file with 100 numbers. I want to create two new files: one with
all the odds and one with all the evens.

*Extension*: Don't allow duplicates in the output

### Lats & Longs

I have a file with 100 latitude/longitude pairs. Find the point that's closest to the north pole.

*Extension*: Find the one closest to the **magnetic** north pole.
