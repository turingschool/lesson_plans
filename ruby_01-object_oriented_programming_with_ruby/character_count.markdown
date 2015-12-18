---
title: Character Count
length: 90
tags: ruby, code challenge, algorithims, testing
---

## Learning Goals

* Practice writing pseudocode.
* Develop the skills to convert pseudocode into tests and code


## Structure

* 5 - Introduction
* 10 - Write pseudocode for the algorithm. 
* 10 - Share your pseudocode
* 5 - Break
* 15 - Write tests to match your pseudocode. Write at the very least one integration test.
* 10 - Share your tests
* 5 - Break
* 25 - Work on your solution
* 5 - Wrap up

## Lesson

### Introduction

# Count characters in a string

Write a console application that outputs the results of the following analysis of the input string:

For each unique character that appears in the input string, report the number of occurrences of that character in the input.  Report each character on its own line, in descending order based on the number of occurrences.  Each line should be formatted as follows:

```
<character>: <number of occurrences>
```

There is no defined order for reporting characters that have the same number of occurrences.  Such entries can appear in any order of your choosing in the output.

Examples:

  **analyze aaabbc**
```ruby
  a: 3
  b: 2
  c: 1
```


  **analyze I really want to work for Wingspan**
```
   : 6
  o: 3
  r: 3
  a: 3
  n: 3
  w: 2
  l: 2
  t: 2
  k: 1
  W: 1
  p: 1
  g: 1
  i: 1
  I: 1
  f: 1
  y: 1
  s: 1
  e: 1
```