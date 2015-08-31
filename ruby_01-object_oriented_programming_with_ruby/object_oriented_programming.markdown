---
title: Object-Oriented Programming
length: 120
tags: ruby, object-oriented programming
---

## Learning Goals

* Understand the difference between classes and instances
* Be able to write and identify instance methods
* Understand the role of attributes in an instance
* Practice defining a class and creating instances of that class
* Understand how arguments are used with methods
* Understand how methods send back a return value

## Structure

* 5 - Warmup
* 25 - Concepts Discussion
* 5 - Break
* 25 - Group Practice
* 5 - Break
* 25 - Exercises

## Warmup

Object-oriented programming excels at modeling the real world in software. Imagine a class definition of a car. What methods would the car offer (aka, what things can it **do**)? What attributes would the car have (aka, what are the observable, measurable characteristics)?

## Concepts Discussion

Let's talk about the big picture ideas of Object Oriented programming:

* **objects** and **conversations**
* **messages** and **responses**
* the **class** definition
* creating **instances** of a class
* writing our own **language**
* how to **write a method**
* how to **accept an argument** and **use it**
* the concept of a **call stack**
* the role of **attributes**
* creating **instance variables** to store **atttribute values**
* combining it all together

### Concepts Exploration: Hamlet

Let's talk about Shakespere's Hamlet. If you were going to implement Hamlet in code, you would have to have a Horacio class, and then you would have to instantiate it.

```ruby
class Horacio
end

h = Horacio.new
```

Whatever it means to be Horacio, you would define in the class, and then create an instance of the class. This is
the idea of Horacio-ness and you would create one Horacio from that mold.

Contrast that with something like a generic guard.

```ruby
class Guard
  def initialize
    @status = :guarding
  end

  def march
    @status = :marching
  end
end

g1 = Guard.new
g2 = Guard.new
g3 = Guard.new

guards = [g1, g2, g3]
```

When items are unique and important, we will have a single class that gets instantiated one time.

Other times we are going to create forms and create multiple instances of them. They are not the same, they have some uniqueness, but they more or less have the same form.

In the example above, all of the guards may be able to stab, or call for help, but they may have unique attributes such as names, heights, and weapons.

## Group Practice

Next we'll work together to create a software model of a fish tank.

## Exercises

Let's think about modeling cars in code. Work through these steps:

1. Create a `Car` class and save it in `car.rb`.
1. At the bottom of the file, outside the class definition, write `my_car = Car.new` to create an instance.
1. Run the file from your terminal with `$ ruby car.rb`. Observe nothing (boohoo!). Note: If you have Seeing Is Believing, you can run the file from within your editor using `Command+Option+b` (if you don't have it, but want it, just walk up to the front and give me your computer :P)
1. Add a method to the class named `horn`. In that method return the String `"BEEEEEP!"`. Then at the very bottom of the file add `puts my_car.horn`. If you're using Seeing Is Believing, you can omit the `puts`, that will print it so that you can see it from the terminal, but you don't need to do that if you're using SiB.
1. Run your file again and observe output (yay!).
1. Add a method to your class named `drive` which takes an argument named `distance`. When the method is called, have it return the a string like `I'm driving 12 miles` where `12` is the value passed in for `distance`.
1. Add `puts my_car.drive(12)` to the bottom of your file and run it again. Observe two lines of output (double yay!).
1. Add an `attr_accessor`, an externally-accessible attribute, with the name `color`.
1. Add a method named `report_color` that returns the String `"I am purple"` where `"purple"` is the value stored in `color`.
1. Add two lines to the bottom of the file: `my_car.color = 'purple'` and `puts my_car.report_color`
1. Add an externally-accessible attribute named `wheel_count` and add a line at the bottom setting it to `18`.
1. At the bottom of the file, write a line that prints out `"This sweet ride is sitting on 18 wheels"` where `18` is the value returned from the `wheel_count` method.
1. At the bottom of the file, write a line that creates a second instance of the class Car called, `my_second_car`, and sets the `wheel_count` to `2`. Then write a line that prints "This sweet ride is sitting on 2 wheels". Observer how the two instances have their own instance variables (one car has 18 wheels, the other has 2 wheels, the code is shared through the class, but the variables are stored on the object).
1. This one is tricky. Add a method named `start`. If the car has not yet been started, when the method is called it should return `"Starting up!"`. But if the car has previously been started, it should return `"BZZT! Nice try, though."`. You'll need to create an instance variable, a method, use an if statement, and return a value.
