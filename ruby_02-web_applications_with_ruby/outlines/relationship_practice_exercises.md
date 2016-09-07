---
title: Practicing Relationships
length: 90
tags: ActiveRecord, Rails, Relationships
---

# Practicing Relationships with ActiveRecord in Rails

#### Steps to set things up:
  * Clone down the (relationship exercise repo)[https://github.com/Carmer/relationship_practice_exercises] or `git clone https://github.com/Carmer/relationship_practice_exercises.git`
  * run `git fetch`

#### One-To-Many Relationships

##### Part1 - Tracks, Genres, Media-Type, Album

  * Checkout the branch `one-to-many-part1` - `git checkout one-to-many-part1`.
  * run `rake test`
  * You should see 10 errors.
  * Follow the errors one by one - maybe skip all but one test at a time to keep things in perspective.
  * Once you have implemented migrations and relationships so that you satisfy each error you can move onto the next part.
  * Make sure you commit your changes so you can save them locally on this branch

##### Part2 - Album, Artist, Employee, Customer, Invoice

  * Checkout the branch 'one-to-many-part2'.
  * Run `rake test`
  * You should see 12 errors
  * Follow the errors and failures
  * Implement all migrations and relationships once you have completed this you can move on to many-to-many exercises
  * Make sure you commit your changes so you can save them locally on this branch

#### Many-To-Many Relationships

##### Part1 - Invoices, Tracks

  * Checkout the branch `many-to-many-part1`
  * Run 'rake test'
  * You should see 7 errors.
  * Run migrations and create relationships to make these tests pass.
  * Once you get a passing test suite move onto part2
  * Make sure you commit your changes so you can save them locally on this branch

##### Part2 - Tracks, Playlists

  * Checkout the branch 'many-to-many-part2'
  * you should see 11 errors
  * Create migrations and relationships to get these tests to pass.
  * Once you get these to pass you can move onto has_one relationships
  * Make sure you commit your changes so you can save them locally on this branch

#### Has-One Relationships

##### Part1 - Customer, Profile

  * Checkout the branch has-one-part1
  * You should see 4 errors
  * Create migrations and relationships to get these tests to pass.
  * Once you have completed this you have finished the exercises.
  * Make sure you commit your changes so you can save them locally on this branch

#### Extra Challenge

* Try to take all the branches we just worked on and get all the work together on one branch
