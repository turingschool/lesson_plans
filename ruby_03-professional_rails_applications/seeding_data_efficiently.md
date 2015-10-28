---
title: Seeding Data Efficiently
length: 180
tags: seeding, seed, rails
status: draft
---

## Learning Goals

* Understand how to seed data in Rails in a timely manner
* Know when to update the seed file in the development process
* How to use Faker
* How to set up relationships

### Discussion

* The nightmare seed file -- we've probably all seen the 300+ line seed file
* Problems of seeding generally stem from doing too much manual / hard-coded
  work
* We should treat our seed file as just another piece of code
* Use methods as abstractions for common operations
* Use libraries to generate data we need (often randomized data to simulate real users)
* Use rails / AR idioms to pre-fill relationships in a straightforward way
* Use loops and parameterization to control repeated seeding

## Structure

* 10 - Live Code: Building an Inefficient Seed File
* 10 - Lecture: Why Seeding Efficiently Matters
* 5 - Break
* 60 - Live Code: Improving the seed file with loops
* 90 - Code: Implement seeding strategies on The Pivot

## Live Code: Building an Inefficient Seed File

* Build each record by hand
* Setup all relationships by hand

## Lecture: Why Seeding Data Efficiently Matters

* Setting up each record by hand takes too much initial time
* This Approach Makes Maintenance difficult (each migration creates work)

### Possible Improvements

* Sketch out more of the code in this lesson plan
* Shorten this lesson -- probably only 90 mins needed
* Cover populator gem for seeding large datasets?
