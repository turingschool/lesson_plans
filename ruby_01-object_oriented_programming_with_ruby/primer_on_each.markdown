---
title: Primer on .each
length: 90
tags: enumerable, ruby, collections, arrays, each
---

# Primer on .Each

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

* If you had an array of numbers, e.g. [1,2,3,4], how do you print out the
doubles of each number? Triples?
* If you had the same array, how would you only print out the even numbers?
What about the odd numbers?
* Given an array of first and last names, e.g. ["Alice Smith", "Bob Evans",
"Roy Rogers"],  how would you print out the full names line by line?
* How would you print out only the first name?
* How would you print out only the last name?
* How could you print out only the initials?
* How can you print out the last name and how many characters are in it?
