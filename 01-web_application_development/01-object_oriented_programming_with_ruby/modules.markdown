---
title: Modules in Ruby
length: 90
tags: ruby, modules, oop
---

## Standards

* Understand that in Ruby, Modules serve three purposes
* Be able to use a Module to create a namespace
* Be able to use a Module to mimic functional programming
* Be able to use a Module to create a mixin

## Structure

* 5 - Warmup
* 20 - Namespacing
* 25 - Functional Programming
* 25 - Mixin

## Content

### Warmup

Spend the first five minutes writing answers to the following questions:

1. What do you know about modules already? If little, what would you guess modules are all about?
2. Golf and basketball both use a ball. But if you're on a basketball court and ask for "the ball", no one is going to
throw you a golf ball. Why? If you were as dumb as a computer, why would a golf ball be an acceptable response?
3. You've learned about the object model and method lookups. What would the impact be of injecting an
additional ancestor into a class' lookup chain?

### Namespacing

Let's break this segment into two parts: discussion and independent work.

#### Discussion (15 Minutes)

Starting with this code:

```ruby

class Car
  def start
    puts "Engine on!"
  end

  def drive
    puts "Back wheels go!"
  end
end

class Car
  def start
    puts "Engine on!"
  end

  def drive
    puts "All wheels go!"
  end
end
```

Let's explore/discuss:

* What happens when the second `class Car` is evaluated by Ruby?
* What happens if we instantiate an instance of `Car` after evaluating this code and call `drive`?
* Can we access the definition of `#drive` that uses the back wheels?

#### Explore (10 Minutes)

* Start with the code above
* Wrap the first `Car` with a module to create a `Car::RWD`
* Wrap the second `Car` with a module to create a `Car::AWD`
* Create an instance of `Car::RWD` and prove that you can access both the expected methods
* Create an instance of `Car::AWD` and prove that you can access both the expected methods

### Functional Programming

#### Discussion (15 Minutes)

* What's the difference between traditional OOP and Functional programming?
* What is a function?
* Modules cannot be instantiated
* Modules can have methods

Check out this code:

```ruby
module Pythagorean
  def self.find_c(a, b)
    Math.sqrt((a ** 2) + (b ** 2))
  end
end
```

* How would you use this method from IRB / other code?
* Why might you say that this code is functional on two levels?

#### Explore (10 Minutes)

Start with the snippet above and add `find_a` and `find_b` methods. As you might remember from geometry:

`c^2 = a^2 + b^2`

An easy triangle to use for testing purposes is `a = 3`, `b = 4`, `c = 5`.

If you find this approach to programming interesting, you might check out [Gary Bernhart's "Boundaries" Talk](https://www.destroyallsoftware.com/talks/boundaries).

### Mixin

#### Discussion (15 Minutes)

* Ruby, like other OOP languages, uses inheritance
* Ruby only allows for single inheritance, strictly speaking
* Traditional inheritance is often frowned upon
* Module mixins are inheritance by a different name
* Mixins are added to the lookup chain
* Mixins can be shared by multiple classes
* Mixins might be used by a single class to group functionality
* The latter might be a terrible idea / just obfuscate code

Consider the following code:

```ruby
class Camry
  def start
    puts "Engine on!"
  end

  def stop
    puts "Engine off!"
  end

  def drive
    puts "Back wheels go!"
  end
end

class Jeep
  def start
    puts "Engine on!"
  end

  def stop
    puts "Engine off!"
  end

  def drive
    puts "All wheels go!"
  end
end
```

Together let's create a `HasEngine` module to extract the `start` and `stop` methods.

#### Explore (10 Minutes)

Take the code from the discussion and implement a `HasAirConditioning` module that is mixed into both classes. Instances
of either class should be able to turn the AC on (`Chilly air coming your way!`) or off (`Temp is fine in here`).

Got it working? Then consider the following additional reading:

* [Include vs Extend in Ruby](http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/) from John Nunemaker
* [Modules](http://ruby-doc.com/docs/ProgrammingRuby/html/tut_modules.html) in Programming Ruby / RubyDoc
* [Ruby Class, Module, and Mixin](http://matt.aimonetti.net/posts/2012/07/30/ruby-class-module-mixins/) by Matt Aimonetti
* *Josh Cheek's Notes*: When I taught this material, I included a bit of object model
so that I would have a foundation from which to explain the things below.
We had three hours, with the intent that I could use some time for that,
My examples deviated b/c we made them up on the spot, but despite the different names,
I think the examples were very similar, and the standards were entirely based on this lesson plan.
[Here](https://gist.github.com/JoshCheek/e653d93f98c3622f4b58) is a link,
it took me a long time and a lot of effort learn all the stuff in there,
so if you're teaching this, it's probably worth skimming, just as reference.
