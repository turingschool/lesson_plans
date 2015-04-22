---
title: Refactoring Patterns - Part 2
length: 120
tags: ruby, refactoring, tdd
---

## Learning Goals

* Study the following refactoring patterns: Move Method, Extract Class,
Hide Delegate

Extras: Move Field, Inline Class, Remove Middleman

## Structure

* 5 - Warmup
* 20 - Discussion about Refactoring
* 5 - Break
* 25 - Pattern 1: Move Method
* 5 - Break
* 25 - Pattern 2: Extract Class
* 5 - Break
* 20 - Pattern 3: Hide Delegate
* 5 - Wrapup

## Warmup

* Start a Gist
* Set the title to "Refactoring Patterns - Part 2" and the file type to Markdown
* Paste in the following questions:

```
1. Why do we refactor?
2. What's the difference between "refactoring" and "changing shit"?
3. What role do patterns play in refactoring?
4. Why do some refactoring patterns seem to be opposites?
5. Does refactoring always make code better?
```

* Save it as a public Gist
* Edit the Gist (thus creating a second version)
* Answer the questions to the best of your knowledge
* Save it

## Discussion about Refactoring

Let's start by discussing Refactoring at a high level:

* The "Red-Green-Refactor" loop
* "Refactoring" brought into the mainstream by Martin Fowler's
"Refactoring: Improving the Design of Existing Code" in 1999
* Changing the internals of code without changing the external behavior
* "I don't pay to write features, not refactor."
* The concept of technical debt and awkward analogies to personal debt
* Software patterns are common solutions to common problems
* Refactoring patterns are common *transformations*, not *improvements*.
* Look for resiliency to change
* There are commonly *pairs* of patterns around the same idea
* Jay Fields revised Fowler's book for Ruby:
[Refactoring: Ruby Edition](http://www.amazon.com/Refactoring-Edition-Addison-Wesley-Professional-Series/dp/0321984137)

For the next three class segments, make use of
[this extraction of Chapter 7](https://dl.dropboxusercontent.com/u/69001/Refactoring/Refactoring%20-%20Chapter%207.pdf).

## Pattern 1: Move Method

### Introduction

* Move Method comes about when you have two objects that are too tightly coupled
* One sign is when you have several methods in Class A that have the name of Class B
* You move the method from Class A to Class B and update any references
* Remember to consider the context of Class B when choosing a name for the moved method

### Example

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

### On Your Own

* Read the Move Method section from 167 to 172
* Implement the example on 170
* Go through the transformations on 171 and 172

If you finish early, do the same for the Move Field pattern (172-175)

## Pattern 2: Extract Class

### Introduction

* One of the most common weaknesses in object-oriented systems
* One object is doing the work of two (or more)
* Really is a "Step 1" before applying Move Method
* Extraction allows for easier testing, reuse, and abstraction

### Example

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

### On Your Own

* Read the Extract Class section from 175 to 179
* Implement the example on 177
* Go through the transformations on 177 and 178

If you finish early, do the same for the Inline Class pattern (179-181)

## Pattern 3: Hide Delegate

### Introduction

* You can talk to your friends, but don't talk to your friends' friends
* The [Law of Demeter](http://en.wikipedia.org/wiki/Law_of_Demeter) is not a law
and is not about agriculture
* Rather than talking through, talk to
* Chains of method calls with different levels of abstraction are a red flag
* Instead pass the messages like a bucket brigade

### Example

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

### On Your Own

* Read the Hide Delegate section from 181 to 184
* Implement the example on 183
* Go through the transformations on 184

If you finish early, do the same for the Remove Middleman pattern (185-186)

## Wrapup

Spend the last five minutes returning to your Gist from the Warmup, edit
to create a third version, and update your answers.

## Corrections & Improvements for Next Time

### Taught by Jeff on 8/25

* Fixed the second code example above
* Time was a little tight, consider having students read ahead of time
* It'd be good to have them attempt the examples or something similar on
their own
