---
title: Enumerable Methods
length: 180
tags: enumerable, ruby, collections, arrays
---

# Enumerable Methods

## Standards

#### Enumerable Methods

* explain that enumerable methods traverse and search through collections
* know that #each is the base for enumerable methods
* use #map/#collect to return a mutated array
* use #reduce/#inject to combine the objects in a collection
* use #sort_by to sort objects by specified criteria
* use #select to return an array of objects that meet a specified criteria
* use #detect/#find to return the first object that meets a specified criteria
* use #min and #max to return the object with a minimum or maximum value
* use #reject to return an array where objects that meet a specified criteria are discarded
* use #find/#detect to return the first element that meets a specified criteria
* use #count to return the number of objects that meet a specified criteria
* use #zip to produce a 2D array
* use #group_by to return a hash of grouped objects

## Structure

* 5 - What are enumerable methods?
* 20 - Enumerable methods that iterate over a collection
* 20 - Enumerable methods that filter a collection
* 5 - Break
* 10 - Enumerable methods that return true or false
* 15 - Enumerable methods that do other cool things :)
* 5 - Review
* 100 - Enumerable methods practice in pairs

## Lesson
Get the lesson slides [here](https://www.dropbox.com/sh/5ftj3s4ih89dv1f/AABNM-gkhkOnIxuyfaFkGi4Ya?dl=0).
#### What are enumerable methods?

* methods that can be used on arrays and hashes to go through each element or search for elements/an element

#### What is the syntax for writing enumerable methods?

```ruby
array.method do |item|
	item.do_something
end
```

```ruby
array.method { |item| item.do_something }
```

#### Enumerable methods that iterate over a collection
* each
* map/collect
* sort_by

#### Enumerable methods that filter a collection
* select/find_all
* detect/find
* reject

#### Enumerable methods that return true or false
* all?
* any?
* none?
* one?

#### Enumerable Methods that Distill a Collection to One Value

* reduce/inject
* max_by
* min_by

#### Enumerable Methods that Return New-Shaped Collections

* zip
* group_by

#### Reading documentation for enumerable methods
[Here](http://ruby-doc.org/core-2.1.2/Enumerable.html) is the documentation for the Enumerable mixin.

## In Pairs

Clone the [enumerable exercises repo](https://github.com/JumpstartLab/enums-exercises) and work in the pairs listed on the outline.

## Wrapup

Return to standards and check progress.
* What was easy?
* What was challenging?
* What made sense?
* What didn't make sense?

## Corrections & Improvements for Next Time

### Taught by Rachel
