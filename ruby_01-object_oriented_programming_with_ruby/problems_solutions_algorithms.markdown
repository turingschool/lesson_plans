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
* 38 - Lecture
* 14 - Challenge 1
* 1 - Shuffle
* 14 - Challenge 2
* 1 - Shuffle
* 14 - Challenge 3
* 3 - Closeout

## Warmup

### Part 1 - Writing

First, spend 5 minutes writing an "algorithm" that explains how to tie your shoes.
Try to be as explicit and specific as possible. Assume your reader is a human, but a
very literal one.

### Part 2 - Doing

Now, pair up with your neighbor. The person whose name is alphabetically first will
read their algorithm step-by-step to the person whose name is alphabetically last.

You can repeat instructions if needed, but don't add any instructions beyond what
you had originally written down.

## Lecture - Big-Picture Strategy

* What is an Algorithm
* What do programmers do?
* Problem solving problems: What to do vs. How to do it
* Incremental solutions (linear)
* Iterative solutions (spirals)
* Building a full "slice"
* "Half a product not a half-assed product"

### An Iterative Process

A generalized process for solving technical problems:

1. How will you know when the problem is solved?
2. How do you want to use the software?
3. What's the most trivial possible case?
4. What's the minimum-work case?
5. What's the next-most-complex case?
6. Sketch an algorithm (pseudocode)
7. Implement it
8. Is the whole problem solved? If not, return to 5.
9. Anticipate edge cases
10. Refactor

### Software Processes / Techniques

* TDD
* Pseudocode
* Agile Development

## Exercises

### Small Groups - Algorithm Challenges

We'll then break into small groups to work through this process for a few different problems.

### Common Words

I have a text document and want to know "What are the three most common words in the text?"

*Extension*: Let's exclude the following: I, you, he, she, it, we, they, they, a, an.

### Odds & Evens

I have a file with 100 numbers. I want to create two new files: one with
all the odds and one with all the evens.

*Extension*: Don't allow duplicates in the output

### Lats & Longs

I have a file with 100 latitude/longitude pairs. Find the point that's closest to the north pole.

*Extension*: Find the one closest to the **magnetic** north pole.
