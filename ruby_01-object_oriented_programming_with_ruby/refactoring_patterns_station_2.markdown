---
title: Refactoring Patterns - Extract Class
length: 25
tags: ruby, refactoring, tdd
---

# Pattern 2: Extract Class

## Supplies

* You should have a copy of
[this extraction of Chapter 7](https://dl.dropboxusercontent.com/u/69001/Refactoring/Refactoring%20-%20Chapter%207.pdf).

## Instructions

* Read the Extract Class section from 175 to 179
* *Carefully* re-read the code sections on 177 and 178
* Read/discuss the Key Ideas below
* Try refactoring the Example Scenario below using Extract Class
* You're welcome to discuss / compare solutions with others
* If you finish early, read the Inline Class pattern (179-181)

## Key Ideas

* One of the most common weaknesses in object-oriented systems
* One object is doing the work of two (or more)
* Really is a "Step 1" before applying Move Method
* Extraction allows for easier testing, reuse, and abstraction

## Example Scenario

```ruby
class Plane
  attr_reader :engine_1_running, :engine_2_running,
              :engine_3_running, :engine_4_running

  def initialize
    @engine_1_running = false
    @engine_2_running = false
    @engine_3_running = false
    @engine_4_running = false
  end

  def start
    @engine_1_running = true
    @engine_2_running = true
    @engine_3_running = true
    @engine_4_running = true
  end

end

dusty = Plane.new
dusty.start
```
