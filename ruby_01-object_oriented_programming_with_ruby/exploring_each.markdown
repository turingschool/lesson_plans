---
title: Exploring .each and Using Pry
length: 90
tags: enumerables, debugging, pry, each
---

## Goals

* Learn how to use a debugger to pause and interact with running code.
* Understand how to use each in both its single and multi-line formats.

### Hook

* We often write long complex programs, and sometimes we don't really know
how things are going or how they went until the very end. Wouldn't it be nice
to get in there, see what exactly is happening, and perhaps play. Remember,
code is free.
* Programming is like 90 percent taking some data, and turning it into other
data.
* But what if you have a lot of data. Like, a LOT. How can we efficiently
work through it?

### Opening

Let's get a debugger on our system.

`gem install pry`

What this does is that it gets us the `pry` gem.

We can start running pry just by typing in `pry`.

It's pretty simple. It works just like irb. But it has a number of other features, the best of which is being able to pause the program
you are running and open up a debugger right at a certain part of time.

Let's take this code.

```ruby
a = 1
a = a + 2
a = a + 3
puts a
```

We can kind of assume that this is going to output six. This is pretty
oversimplified, but how can we be sure of what's happening? What if we
wanted to find out what exactly was happening?

We first need to tell our code that we need it to load pry. We do
that with `require "pry"`.

```ruby
require "pry"

a = 1
a = a + 2
a = a + 3
puts a
```

Now, we have to tell the program where we want to stop and open up
a debugger session.

```ruby
require "pry"

a = 1
a = a + 2
binding.pry
a = a + 3
puts a
```

When we run this program, the line where 2 is added to `a` is executed
and the program is stopped.

We can now type in `a` and we can see what a equals at that exact
point in time. We can ensure that 2 is in fact getting added to `a`.

We're going to use `pry` to explore enumerables.

### What are enumerables?

* Enumerables are methods that can be used on arrays and hashes to go through each element or search elements or a single element.

### What is .each?

* .each is the base for enumerable methods.
* With .each, you can traverse a collection.
* It returns the original collection. (This is important to remember)

### Syntax

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

### Basic use of .each

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

### Exercises

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

### Extra Exploration

If you want more, play with the code in this [gist](https://gist.github.com/jmejia/04924190362f64fc49ab).
