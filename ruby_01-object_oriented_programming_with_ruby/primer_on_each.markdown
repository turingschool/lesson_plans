---
title: Primer on .each
length: 90
tags: enumerable, ruby, collections, arrays, each
---

# Primer on .each

### Goals

* Learn how to use a debugger to pause and interact with running code
* Understand how to use single-line and multi-line each

#### Debuggers

As programmers we often make assumptions about what our code is doing. We are often wrong. One of the most important and effective debugging techniques is to validate your assumptions.

Have you ever found yourself working on a programming problem and as you attempt to solve it, you are forced to run the entire file over and over again until you get the correct result? Wouldn't it be awesome if you could pause your code at a specific line and interact with it? Enter debuggers.

Debuggers are great to see what your code is actually doing. The most common debuggers in ruby are `byebug` and `pry`. You can pick whichever you prefer. For this exercise we will use `pry`.

First, install it from the command line.
`gem install pry`

You need to require it at the top of your Ruby file.

```
require "pry"
```

Now you can use it like this...

```
favorite_things = ["Trapper Keeper", "Netscape Navigator", "Troll Doll"]
binding.pry
```

We're going to use your debugger to explore `.each` and on the challenges below.

Let's use [this gist](https://gist.github.com/jmejia/04924190362f64fc49ab) as a guide.

#### What are enumerable methods?

* methods that can be used on arrays and hashes to go through each element or
search for elements or  an element.

#### What is .each?

* .each is the base for enumerable methods.
* it allows you to traverse a collection
* it returns the original collection

#### What is the syntax for writing enumerable methods?
Multi-Line
```ruby
array.each do |item|
  item.do_something
end
```
Single-Line
```ruby
array.each { |item| item.do_something }
```

#### Basic use of .each

Let's say we have an array of words, and we want to print out to the screen
each word in the array, but in all capitalized letters.

```ruby
array = ["alice", "bob", "eve"]

array.each do |name|
  puts name.upcase
end
```
This can also be written:
```ruby
array = ["alice", "bob", "eve"]

array.each { |name| puts name.upcase }
```

What do you think each of these returns?

Remember that there is a difference between what gets output to a screen
and what a bit of code returns.

#### Exercises

Use your debugger to work through the following...

* If you had an array of numbers, e.g. [1,2,3,4], how do you print out the
doubles of each number? Triples?
* If you had the same array, how would you only print out the even numbers?
What about the odd numbers?
* How could you create a new array which contains each number multipled by 2?
* Given an array of first and last names, e.g. ["Alice Smith", "Bob Evans",
"Roy Rogers"],  how would you print out the full names line by line?
* How would you print out only the first name?
* How would you print out only the last name?
* How could you print out only the initials?
* How can you print out the last name and how many characters are in it?
* How can you create an integer which represents the total number of characters in all the names?
