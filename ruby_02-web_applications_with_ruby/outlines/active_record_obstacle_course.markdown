---
title: ActiveRecord Obstacle Course
length: 120
tags: activerecord, rails
---

## Goals

* Practice using ActiveRecord for problems beginners commonly us Ruby to solve
* Practice finding and reading ActiveRecord documentation
* Gain an understanding of `joins` and `includes`

## Instructions

1. Clone Storedom and checkout the `activerecord-obstacle-course` branch

  `git clone -b activerecord-obstacle-course https://github.com/turingschool-examples/storedom.git`
2. `bundle update`
3. Start with the top test within `spec/models/activerecord_obstacle_course_spec.rb` and work in order.
4. To run your tests, you can run `rspec spec/models/activerecord_obstacle_course_spec.rb`
5. If you want to run one specific test, you can run `rspec spec/models/activerecord_obstacle_course_spec.rb:LINE_NUMBER`.
  
  For example: `rspec spec/models/activerecord_obstacle_course_spec.rb:34`

  Note: There's one skipped spec. Ignore it until the very end.
  
6. Most of the tests follow the same format...

  Leave the Ruby as is or comment it out -- Don't erase.
  ```ruby
  # -----------------------------
  # A section with some Ruby code
  # -----------------------------
  ```
  
  Write a refactored implementation using ActiveRecord. Assign to the same variables as above.
  ```ruby
  # -----------------------------
  # A section for you to write refactor the Ruby code
  # -----------------------------
  ```
  
  Leave the expectations alone. They will determine whether you have a working solution.
  ```ruby
  # -----------------------------
  # The expectation
  # -----------------------------
  ```

7. When you think you have successfully refactored one test, show it to your instructor before moving on. If the instructor is busy, get in the queue and start the next problem.
  
## If You Finish Early

* Break your solutions into scopes and/or class methods.
* Try to implement one example using ActiveRecord's `merge`.
