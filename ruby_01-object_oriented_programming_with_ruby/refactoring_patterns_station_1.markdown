---
title: Refactoring Patterns - Move Method
length: 25
tags: ruby, refactoring, tdd
---

# Pattern 1: Move Method

## Supplies

* You should have a copy of
[this extraction of Chapter 7](https://drive.google.com/file/d/0B4C6lfVKu-E7ZlFDTnhyTklXdm8/view).

## Instructions

* Read the Move Method section from 167 to 172
* *Carefully* re-read the code sections on 170, 171, and 172
* Read/discuss the Key Ideas below
* Try refactoring the Example Scenario below using Move Method
* You're welcome to discuss / compare solutions with others
* If you finish early, read the Move Field pattern (172-175)

## Key Ideas

* Move Method comes about when you have two objects that are too tightly coupled
* One sign is when you have several methods in Class A that have the name of Class B
* You move the method from Class A to Class B and update any references
* Remember to consider the context of Class B when choosing a name for the moved method

## Example Scenario

```ruby
class Engine
  def core_weight
    250
  end

  def propeller_weight
    50
  end
end

class Plane
  attr_reader :engine

  def initialize
    @engine = Engine.new
  end

  def body_weight
    1000
  end

  def engine_count
    2
  end

  def weight
    body_weight +
    engine_count * (engine.core_weight + engine.propeller_weight)
  end
end

dusty = Plane.new
dusty.weight
```
