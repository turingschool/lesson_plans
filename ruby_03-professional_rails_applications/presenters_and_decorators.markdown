---
title: Decorators & Presenters
length: 90
tags: presenters, decorators, rails, refactoring, mvc
---

## Learning Goals

* Understand the decorator pattern
* Practice rewriting helpers using a Draper decorator
* Understand the theory and purpose of a presenter object
* Practice creating a presenter to collect and wrap data

## Structure

* 30 - Lecture: Intro to Decorators
* 30 - Tutorial: Experimenting with Draper
* 15 - Lecture: Intro to Presenters
* 15 - Code: Creating a Dashboard Presenter

## Lecture: Intro to Decorators

### Q and A Discussion: What Problem are Decorators trying to Solve?

* __Q:__ What is the standard tool in rails for abstracting view-layer
  responsibilities?
* __Q:__ What are some downsides to this approach? (hint: when you see a method
  called in a view template, how do you determine where this method is defined?)
* __Q:__ What might a more object-oriented approach to view-layer
  interactions look like?

### Decorator Basics

* Decorators are a Software Pattern for applying object-oriented techniques to handling
application presentation logic
* Decorators are often used to solve similar problems as `Helpers` in Rails, but rather than mixing the
helper methods into our view template, we will create an object that provides the desired behavior
* Most implementations of the Decorator pattern are built around "wrapping" and "delegation"
* Decorators are a good demonstration of
  the [Open/Closed Principle](https://en.wikipedia.org/wiki/Open/closed_principle) --
  we are able to add functionality to the wrapped object without
  modifying it directly
* Decorators in ruby also exploit ruby's use of duck typing -- since
  they delegate unknown methods to the internal/wrapped object, they
  effectively preserve the same interface and can be used
  interchangeably.

### Wrapper / Delegator Pattern

It's often useful on OO design to create an object which adds additional functionality
as a "layer" on top of another object. We could use inheritance for this, but it's
not always an accurate expression of the relationship -- my new object might not really
be a "descendant" of the original one, but it can still be involved in enhancing its
functionality.

A common approach to this type of relationship is to define the second object as a "delegator"
or "wrapper" around the first. When creating an instance of Object B, we will pass it an
instance of Object A. In some cases Object B will define its own methods, but in some
cases it will simply "pass through" methods that are called on it to Object A.

Let's look at a more concrete example.

```ruby

class ObjectA
  def pizza
    "pizza"
  end

  def calzones
    "calzones"
  end
end

class ObjectB
  def initialize(object_a)
    @object_a = object_a
  end

  def pizza
    @object_a.pizza
  end

  def calzones
    @object_a.calzones.upcase
  end
end

obj = ObjectB.new(ObjectA.new)
obj.pizza
=> "pizza"
obj.calzones
=> "CALZONES"
```

As we said, ObjectB takes as its initialization argument an instance
of ObjectA. The methods we define on ObjectB either delegate directly
to methods on ObjectA, or add small modifications on the equivalent method
from ObjectA.

This pattern gives us 2 main advantages:

1. Since ObjectB defines the same suite of methods as ObjectA
we can use them interchangeably (recall what we said about Duck Typing before)
2. Since ObjectB has the ability to modify the return values of methods from
ObjectA, we can use it as a way to add small tweaks onto these existing
behaviors. This can be very useful for presentation logic, which we often want to keep
out of the main model methods.

### Decorator Pattern - Popular Libraries

There are quite a few libraries out there that implement this pattern,
including one particularly popular one by some guy named Casimir.

Let's take a look at some Draper basics.

* [Draper Docs](https://github.com/drapergem/draper)

## Tutorial: Experimenting with Draper

[Work through this tutorial](http://tutorials.jumpstartlab.com/topics/decorators.html)
using Decorators to extract some view logic from Blogger.
If you get done with the core tutorial, then try out the bit at the end about
creating XML and JSON from your decorator.

## Lecture: Intro to Presenters

### Presenter Basics


Consider these 4 rules from Sandy Metz for practicing good Rails
hygiene:

1. Your class can be no longer than 100 lines of code.
2. Your methods can be no longer than five lines of code.
3. You can pass no more than four parameters and you can't just make it one big hash.
4. When a call comes into your Rails controller, you can only instantiate one
   object to do whatever it is that needs to be done. And your view can only know about one instance variable.

The first 3 are probably familiar to us at this point (even if we
grumble about them), but what about that last one?

We've certainly seen Rails controllers and views that utilized more
than one object. So how can we reconcile the need to get things done
with this outline for code cleanliness?

Presenters are a technique for solving this problem.

* Similar to Decorators, Presenters are a pattern for abstracting
  complexity in our view/presentation layer
* Decorator -- Adds functionality (often view-related) to a single
  object (or possibly collection of objects)
* Presenter -- Combines functionality across _multiple objects_
  into a single interface
* A presenter is just another domain object -- one that represents
  a larger abstraction across multiple objects
* In more complicated scenarios, Presenters and Decorators can be
  used in conjunction
* No library needed -- just POROs!
* Example: creating a `Dashboard` presenter

## Code: Creating a Dashboard

Go back to your Blogger project a presenter for the Dashboard such
that the **only** instance variable in `views/dashboard/show.html.erb` is
`@dashboard`.

If you get that working, try creating a `DashboardDecorator`. What logic can
you pull out of the view template into the decorator?
