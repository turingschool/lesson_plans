---
title: Boolean Logic
length: 90
tags: ruby, computer science, logic
---

## Learning Goals

* Understand the key logic operators AND, OR, and NOT
* Be able to combine operations into a logic expression
* Be able to use a truth table to illustrate a logical expression
* Understand short-circuit evaluation of logical statements
* Be able to trace the paths through a chunk of code
* Be able to use compound logic to flatten nested `if` statements

## Structure

* 25 - Lecture
* 5 - Break
* 45 - Activities
* 5 - Break
* 10 - Wrap Up

## Lecture

* AND/OR/NOT in Ruby and beyond
* Expressions and precedence with parentheses
* Truth Tables
* Short-Circuit Evaluation
* Conditions are branches which lead to code paths
* Flattening `if` statements

As logical examples we'll use:

* `(A || B) && (A || C)`
* `(A || !B) || (!A || C)`
* `((A && B) && C) || (B && !A)`

And for a code path we'll use this code:

```ruby
if fruit.round?
  if fruit.color == "red"
    puts "apple"
  elsif fruit.color == "orange"
    puts "orange"
  end
else
  if fruit.large?
    if fruit.green?
      if fruit.tasty?
        puts "watermelon"
      else
        puts "honeydew"
      end
    else
      puts "cantelope"
    end
  else
    puts "grapes"
  end
end
```

## Activities

### 1. Compound Expression Truth-Table

Create Truth Table for this expression using the boolean values `A`, `B`, and `C`:

`((A && B) && !C) || ((A && C) && !B)`

### Diagramming Execution Paths

Consider the following code:

```ruby
class Vehicle
  attr_reader :model, :four_wheel, :big_back_wheels

  def initialize(model, four_wheel, big_back_wheels)
    @model = model
    @four_wheel = four_wheel
    @big_back_wheels = big_back_wheels
  end

  def car?
    model == "car"
  end

  def tractor?
    model == "tractor"
  end

  def pickup?
    model == "pickup"
  end

  def four_wheel_drive?
    four_wheel
  end

  def big_back_wheels?
    big_back_wheels
  end
end

vehicle = Vehicle.new("pickup", true, true)

if vehicle.car?
  if vehicle.four_wheel_drive? || !vehicle.four_wheel_drive?
    puts "Vehicle has four wheels"
    if vehicle.four_wheel_drive?
      puts "with four wheel drive"
    else
      puts "with two wheel drive"
    end
  end
elsif vehicle.tractor?
  puts "Vehicle has four wheels"
  if vehicle.big_back_wheels?
    puts "with big wheels in the back"
  end
elsif vehicle.pickup?
  puts "Vehicle has four wheels"
  if vehicle.four_wheel_drive?
    puts "with four wheel drive"
  else
    puts "with two wheel drive"
  end
  if vehicle.big_back_wheels?
    puts "With big wheels in the back"
  end
end

```

* How many unique execution paths are there through the block of code starting with `if vehicle.car?` statement? 
* Chart out the conditions which would lead to these paths (consider a truth table).

### Reshaping Logic

Take the code from the previous exercise. Let's try to refactor it. Start by flattening it down. Can you simplify the logic to reduce the number of paths? How few can you get it down to? Compare your results with a peer.

## Wrapup

Last let's get together to recap and answer questions.
