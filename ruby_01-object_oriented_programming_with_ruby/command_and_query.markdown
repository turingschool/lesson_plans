---
title: Command and Query
length: 60
tags: ruby object oriented programming
---


## Goals
* Understand that the attributes of an object are stored in instance variables.
* See the pattern that if attributes need to be changed, they should be
changed through methods we add.
* Realize that we encounter methods that do stuff to an object or methods
that tell us stuff about an object.

## Big Ideas

We want to write good code. We want to write reusable code. We've just
talked about objects, instances, and classes, and so now let's talk a little
bit about how we would use this in practice.

We already know that a class is kind of an template for an object, and that
an instance of a class is a particular "copy" of that class.

Let's take this discussion in the direction of physical objects that we can
visualize easier.

We can say that there exists a car class, and this is the car factory.

I have my own car, which is based on the template of the car class. You too
have your own car, which is an instance of the same car class.

How would that look in code?

```
class Car
end

my_car = Car.new

your_car = Car.new
```

This would actually be really boring. We want cars to be different colors.

Before we do, lets talk about what a color IS in terms of a car.

It's an attribute. How do we store attributes of an instance of an object?

In an instance variable. An instance variable is something that is available
to all methods in that class.

And we're going to make it so that we set the color of the car when we are
creating it. Kind of like how we get a car now. They paint it at the factory.
You don't really get the car from the dealer and then repaint it.


```

class Car

  def initialize(color)
    @color = color
  end

end


my_car = Car.new("Silver")

your_car = Car.new("Red")
```


Now, we know that we have a silver car and a red car, but how can we tell what
color they are? We can't. You don't get access to the instance variables
inside an instance of a class. If you want access, you have to create it.

```
class Car
  def initialize(color)
    @color = color
  end

  def color
    @color
  end

end
```

So now, we can access the color of the car by doing something like
`puts my_car.color`

Just for fun, let's give the car a fuel level.

```
class Car
  def initialize(color)
    @color = color
    @fuel = 100
    @engine_on = false
  end

  def color
    @color
  end

  def fuel
    @fuel
  end

  def on?
    @engine_on
  end

end
```

We're just going to say that it has 100 fuel. Completely arbitrary. We're also
going to store some other things in here. We want to track if the engine is
on or not, and by default it's going to be off. Makes sense, right? You dont
buy a car and the engine is running.

So this is where we get the idea of methods that tell you something about an
object and methods that let you change objects.



