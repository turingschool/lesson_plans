---
title: Exploring .each and Using Pry
length: 90
tags: enumerables, debugging, pry, each
---

## Goals
* What is debugging and how can you use `pry` to build code?
* How do you install the `pry` gem?
* When and how would you use `.each` on a collection? 

### Setup: Using a Debugger 
When writing code, it's often helpful to be able to get 'realtime' information about the data available to us and the effect code we've written. Debugging tools, such as `pry` allow us to get in our code as it's executing so we can see what's happening and explore solutions to bugs. 

Debuggers allow us to intervene during the execution of code and see what's happening step-by-step. Using a debugger involves 2 steps. 

#### Install the Debugger 
We can use RubyGems, a built-in "gem" (think plugin or extension) installer that comes with Ruby, to install our debugger. Enter this statement in Terminal. 

`gem install pry`

Once this gem is installed, we can use a `pry` session in Terminal just like we've used `irb`. 

#### Using `binding.pry`
`pry` also offers some additional features beyond `irb`, namely the ability to pause a program and open up a debugger at the place you designate in your code.

```ruby
require "pry"

a = 1
a = a + 2
binding.pry
a = a + 3
puts a
```

To access the debugger, the file with our Ruby code requires two things: 
* First, we use `require "pry"` at the beginning of our file to tell Ruby that we need to load pry before reading any further.
* Second, we use `binding.pry` in our code to indicate where we want Ruby to pause as it executes. 

When we run this program, the line where 2 is added to `a` is executed and the program is stopped. We can interact with our code in Terminal to check the values in our program up to the point where we paused. We can now type `a` and ensure that 2 is in fact getting added to `a`, ultimateley evaluating to 3. While this is a simple example, in more complex scenarios it can be extremely helpful to be able to verify that our code is doing what we expect. 

We're going to use `pry` to explore enumerables.

### The Fundamental Enumerable: `.each`

#### What is an Enumerable?

* The Enumerable module defines a set of methods accessible by most types of Ruby collections. Most commonly, we will use these Enumerable methods on arrays and hashes to go iterate through a collection one-at-a-time.

#### What is .each?

* .each is the base for enumerable methods.
* With .each, you can traverse a collection.
* It returns the original collection. (This is important to remember)

#### Syntax

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

Let's say we have an array of words, and we want to print out to the screen each word in the array, but in all capitalized letters.

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

What do you think each of these _returns_? What actions will they trigger? Think careful about these questions before moving on. Remember that there is a difference between what gets output to a screen and what a bit of code returns.

![Larger World](http://s2.quickmeme.com/img/84/84a6366d15759c25439d99d98ce7058caba36d6881ae05433a1a7d5d0a3bd011.jpg)

### Exercises

Use your debugger to work through the following exercises. 

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

### Formative Assessment
* On a scale of 1-10, how much do you love debuggers like pry?
* What are the two requirements for using pry in your code?
* What does RubyGems help us do?
* How do you write a multi-line each block?
* How do you write a single-line each block?
* What are the different elements in an each block?
* BONUS: Check the methods and ancestors of these two objects: `[1,2,3]` and `[1,2,3].each`. What is the difference between Ruby’s Enumerator and Enumerable?

### Extra Exploration
If you want more, play with the code in this [gist](https://gist.github.com/jmejia/04924190362f64fc49ab).
