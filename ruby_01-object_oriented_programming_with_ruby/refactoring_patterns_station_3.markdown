---
title: Refactoring Patterns - Hide Delegate
length: 25
tags: ruby, refactoring, tdd
---

## Pattern 3: Hide Delegate

## Supplies

* You should have a copy of
[this extraction of Chapter 7](https://dl.dropboxusercontent.com/u/69001/Refactoring/Refactoring%20-%20Chapter%207.pdf).

## Instructions

* Read the Hide Delegate section from 181 to 184
* *Carefully* re-read the code sections on 183 and 184
* Read/discuss the Key Ideas below
* Try refactoring the Example Scenario below using Extract Class
* You're welcome to discuss / compare solutions with others
* If you finish early, read the Remove Middleman pattern (185-186)

## Key Ideas

* You can talk to your friends, but don't talk to your friends' friends
* The [Law of Demeter](http://en.wikipedia.org/wiki/Law_of_Demeter) is not a law
and is not about agriculture
* Rather than talking through, talk to
* Chains of method calls with different levels of abstraction are a red flag
* Instead pass the messages like a bucket brigade

## Example Scenario

```ruby
class Plane
  attr_reader :engines

  def initialize
    @engines = Array.new(4){ Engine.new }
  end
end

class Engine
  def start
    @running = true
  end

  def running?
    !!@running
  end
end

dusty = Plane.new
dusty.engines.each{|e| e.start}
```
