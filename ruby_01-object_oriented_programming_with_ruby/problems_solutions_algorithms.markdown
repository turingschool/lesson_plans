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

* 5 - Warmup
* 38 - Lecture
* 14 - Challenge 1
* 1 - Shuffle
* 14 - Challenge 2
* 1 - Shuffle
* 14 - Challenge 3
* 3 - Closeout

## Sessions

### Warmup

Spend our first four minutes writing an algorithm that explains
how to tie your shoes.

### Lecture - Big-Picture Strategy

* Incremental solutions (linear)
* Iterative solutions (spirals)

#### An Iterative Process

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

### Small Groups - Algorithm Challenges

Let's break into small groups to work through this process for a few different problems.

#### Common Words

I have a text document and want to know "What are the three most common words in the text?"

*Extension*: Let's exclude the following: I, you, he, she, it, we, they, they, a, an.

#### Odds & Evens

I have a file with 100 numbers. I want to create two new files: one with
all the odds and one with all the evens.

*Extension*: Don't allow duplicates in the output

#### Lats & Longs

I have a file with 100 latitude/longitude pairs. Find the point that's closest to the north pole.

*Extension*: Find the one closest to the **magnetic** north pole.
