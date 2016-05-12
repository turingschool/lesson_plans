---
title: Object-Oriented Programming
length: 120
tags: ruby, object-oriented programming
---

## Learning Goals

* explain the difference between classes and instances
* define a class and creating instances of that class
* identify and explain the role of attributes in an instance
* explain and use return values
* write and identify instance methods
* define methods with and without methods
* use arguments within methods

## Lecture

### Classes and Objects in Real Life

**TRY IT**: With your pair, brainstorm five **types** of objects and **specific** instances of that object that are at Turing. For example:

#### Type of object: Cubby

Specific instances: 

* Horace's cubby
* Steve's cubby
* Mike's cubby

#### Type of object: Refrigerator

Specific objects: 

* Small staff refrigerator
* Student refrigerator near Classroom A
* White refrigerator in the big workspace
* Black refrigerator in the big workspace

In the cases above, what we called "type of object" is called a `Class`, and what we called "specific objects" are called `instances`. 

### Classes and Objects in Code

In irb, let's make a few new instances of a String:

```ruby
a = String.new
=> "" 
a.object_id
=> 70162531807580
b = String.new
=> ""
b.object_id
=> 70162535734120
```

We can say that `String` is the class, and `a` and `b` are instances of that class. 

String (like Array, Hash, etc.) are built-in classes in Ruby. We didn't have to define those classes; they already existed. These are useful, but we are limited in what we can do with the built-in classes. 

Ruby does not have classes like `Cubby` or `Refrigerator`. Let's go ahead and define those classes. Make a new file called `classes_and_instances_playground.rb`. 

The syntax for define a class, at its most bare-bones level, is this:

```
class NameOfClass
end
```

Notice that `class` is lowercase while `NameOfClass` is CamelCased. 

```ruby
class Refrigerator
end

refrigerator_1  = Refrigerator.new
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new
p "Number 3: #{refrigerator_3}"
```

Remember, `p` is the combination of `puts` and `inspect` (like `puts steve.inspect`). Let's run the file `ruby classes_and_instances_playground.rb` and see what happens. 

Sometimes it's helpful to be able pause your file and look around. We can do this by installing the gem "pry" and then pausing execution:

```
$ gem install pry
```

```ruby
class Refrigerator
end

refrigerator_1  = Refrigerator.new
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

**TRY IT**: With your pair, define two of the classes that you brainstormed and create instances of those classes. Paste your code in your Slack channel. 

### Attributes IRL

The instances of the classes we've defined so far are basically useless. Aside from their `object_id`, there is nothing unique about these instances.

In Object-Oriented Programming (OOP), **objects need to be able to model state**. 

What are the attributes (states) that may vary among refrigerators? 

* Brand
* Color
* Temperature
* Plugged In? 
* Contents

**TRY IT**: With your pair, brainstorm the things that make a `Person` unique. 

### Attributes in Code

Let's go back to our playground file and add some attributes to the `Refrigerator` class:

```ruby
class Refrigerator
  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

Let's run the file `ruby classes_and_instances_playground.rb` and see what happens. 

**TRY IT**: With your pair, create a class `Person` that has the attributes `name`, `birth_year`, `language`, and `alive` (which will be a true/false value). Make three instances of the `Person` class. Paste your code in Slack. 

### Accessing Attribute Values

Our refrigerators now store their own attributes, but how do we access those values? Let's run the file again and try this:

```ruby
refrigerator.brand
```

What happens? Why? Let's look at the error message:

```
NoMethodError: undefined method `brand' for #<Refrigerator:0x007f8d42132c58>
from (pry):4:in `<main>'
```

This error tells us exactly what we need to do: define a method `brand` for the `Refrigerator`. 

```ruby
class Refrigerator
  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end

  def brand
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

Run the file and try it again. This time, we get nil back. Why?

### Return Values

When we call a method on an object, we expect something to be returned to us. For example, if I ask some "What is your name?", I would expect for them to respond with a name. 

Right now, when we call `refrigerator_1.brand`, we get `nil`, which in Ruby means nothingness. This is because our method is empty. This is what an empty method looks like:

```ruby
def my_method
end
```

An empty method will always return `nil`. We need to return something else. 

The last evaluated line of code will always be the return value. For example:

```ruby
def my_method
  1+1
  ["piglet", "kitten", "baby gorilla"]
  99
end
```

### Back to the Code

What should the `brand` method return?

```ruby
class Refrigerator
  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end

  def brand
    @brand
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

Now let's try calling `refrigerator_1.brand`. It works! This is called a `getter` method because we are able to read the value of an attribute. 

**TRY IT**: With your pair, create getter methods for the `color`, `contents`, `temperature`, and `contents`. Next, create getter methods for `name`, `birth_year`, and `language`. Paste your code **only for Person** in Slack. 

### Simplifying Getter Methods

Ruby gives us a built-in way to provide these same getter methods but without having to define each of these methods separately. We'll use `attr_reader` to do this: 

```ruby
class Refrigerator
  attr_reader :brand,
              :color,
              :temperature,
              :contents

  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

Try running the program and testing out the getter methods. You should get the same behavior. 

**TRY IT**: With your pair, replace your getter methods for `name`, `birth_year`, and `language` with `attr_reader`s. Paste your code **only for Person** in Slack. 

### Defining Custom Methods

Let's say we want to be able to return the temperature in Celsius. Let's define a `temperature_in_celsius` method. By the way, the formula for converting F to C is this:

(F - 32) * 5/9

So we'll need to use the `@temperature` instance variable in order to insert that for `F` in the equation. 

```ruby
class Refrigerator
  attr_reader :brand,
              :color,
              :temperature,
              :contents

  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end

  def temperature_in_celsius
    (@temperature - 32) * 5.0/9.0
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

Let's try out the method: `refrigerator_2.temperature_in_celsius`. 

**TRY IT**: With your pair, define a `age` method for `Person`. 

### Defining Custom Methods with Arguments

Let's say we wanted to add things to the contents of the refrigerator, and we want the user to be able to specify what food is being added. We'll need to allow this dynamic value to be accepted by the method. 

We've seen methods that accept parameters before:

```ruby
message = "Hello, world!"
message.start_with?("H")
=> true
message.index("e")
=> 1
```

These methods allow different values to be passed in depending on what value is wanted. 

In our refrigerator class:

```ruby
class Refrigerator
  attr_reader :brand,
              :color,
              :temperature,
              :contents

  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end

  def temperature_in_celsius
    (@temperature - 32) * 5.0/9.0
  end

  def add_item(item)
    @contents << item
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

**TRY IT**: With your pair, define a `greet(name)` method that accepts a person's name and then greets that person by returning a string like "Hi, Joanne! Nice to meet you."

### Redefining Attribute Values

Now that we've seen how to pass in arguments, let's figure out how we can change the values of instance variables. We want to be able to do this:

```ruby
refrigerator_1.color = "red"
=> #<Refrigerator:0x007fe30a2e8bd8 @brand="Maytag", @color="red", @temperature=36, @plugged_in=true, @contents=["leftover pizza", "yogurt", "soylent"]>
```

Right now when we try this, we get an error: 

```
undefined method `color= for #<Refrigerator:0x007fe30a2e8bd8>'
```

Let's define that `setter` method:

```ruby
class Refrigerator
  attr_reader :brand,
              :color,
              :temperature,
              :contents

  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end

  def temperature_in_celsius
    (@temperature - 32) * 5.0/9.0
  end

  def add_item(item)
    @contents << item
  end

  def color=(new_color)
    @color = new_color
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

Like using `attr_reader` to simplify getter methods, we can use `attr_writer` for the setter method:


```ruby
class Refrigerator
  attr_reader :brand,
              :color,
              :temperature,
              :contents

  attr_writer :color

  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end

  def temperature_in_celsius
    (@temperature - 32) * 5.0/9.0
  end

  def add_item(item)
    @contents << item
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

Even better, if we want both a getter and a setter for an attribute, we can use `attr_accessor`:

```ruby
class Refrigerator
  attr_reader :brand,
              :temperature,
              :contents

  attr_accessor :color

  def initialize(brand, color, temperature, plugged_in, contents)
    @brand       = brand
    @color       = color
    @temperature = temperature
    @plugged_in  = plugged_in
    @contents    = contents
  end

  def temperature_in_celsius
    (@temperature - 32) * 5.0/9.0
  end

  def add_item(item)
    @contents << item
  end
end

refrigerator_1  = Refrigerator.new("Maytag", "white", 36, true, ["leftover pizza", "yogurt", "soylent"])
p "Number 1: #{refrigerator_1}"

refrigerator_2   = Refrigerator.new("", "black", 40, true, [])
p "Number 2: #{refrigerator_2}"

refrigerator_3 = Refrigerator.new("", "black", 33, false, ["celery"])
p "Number 3: #{refrigerator_3}"

require 'pry'; binding.pry
puts "-------"
```

## Pair Work

Let's think about modeling cars in code. Work through these steps:

1. Create a `Car` class and save it in `car.rb`.
1. At the bottom of the file, outside the class definition, write `my_car = Car.new` to create an instance.
1. Run the file from your terminal with `$ ruby car.rb`. Observe nothing (boohoo!).
1. Add a method to the class named `horn`. In that method return the String `"BEEEEEP!"`. Then at the very bottom of the file add `puts my_car.horn`.
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

## Be a badass:

If you get done with the above exercise, then follow along with [this](https://vimeo.com/137837005) video.
It will go through [this](https://github.com/JoshCheek/1508/blob/0facae943f7785e5133ea506595534c1b00b3025/katas/blowing_bubbles_part2.rb) coding exercise.
It builds on bubble sort, but you don't have to understand the algorithm to follow along with it
It only plays with swapping representations, not changing behaviour.
We'll take a piece of toplevel procedural code and turn it into a beautilful namespaced object,
and then back again.

## Homework

* Complete Bob
* Over the weekend, complete `command-query` exercises and `mythical-creatures` exercises
* Optional: `objects-and-methods` exercises
