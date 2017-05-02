---
title: Arrays
length: 90
tags: ruby, arrays, data structures
---

## Learning Goals

* Understand the basic idea of a collection type
* Develop a mental model to understand arrays
* Gain some familiarity with common array methods

## Structure

* 5 - Warmup
* 25 - Together - Data Structures, Collections, and Programming
* 5 - Break
* 25 - Group Exercise
* 5 - Break
* 25 - Independent Practice

## Supplies

Before we begin, collect the following Arts & Crafts supplies:

* 1 piece of paper
* 5 paper cups
* 6 wooden beads
* A pen or marker

Then take your five paper cups and use a marker to number them "0" through "4".

## Together - Data Structures, Collections, and Programming

* What is a "Data Structure"?  
  A data structure is a particular way of organizing information so that it can be used efficiently
* Why are Arrays so ubiquitous?
* What does an Array model conceptually?  
* What are some of the properties of an array?  
  Arrays are the most fundamental collection type in programming. Just about every language has them. Arrays are collections of data where each element is addressed by a number called the index or position.

### Arrays - Group Exercise

Let's model some of the core concepts. In this section, we'll step through using some of the fundamental Array methods, including:

* `[]`
* `count`
* `<<` / `push`
* `pop`
* `shift`
* `unshift`
* `insert`
* `shuffle`

As we go, we'll work side-by-side with our physical Array model and with an IRB/Pry session.

1. Lay down your large piece of paper and write `data` in large letters. This is the name of your collection. How many elements are in your collection so far?
2. Put the empty `0` cup on the paper. If you now fetched the value inside `data[0]`, what would you get back?
3. Store a "blue" bead into the zero cup, the equivalent of maybe `data[0] = "blue"`. What would you expect the answer of `data.count` to be?
4. We can explicitly set the value of another cup. Add `data[1] = "red"`. That does not change the answer to `data.first`, but does change `data.last`. Why?
5. The "shovel" operator (`<<`) adds an element to the end of an existing array. Pretend you ran `data << "green"`. How many beads are in the array in total?
6. It turns out that "shovel" is just syntactic sugar for the method named `push`. Pretend you ran `data.push(nil)`. How does that affect your array? What is the value of `data.count` now?  
9. You can remove the last element of an array by running `data.pop`. Do that now.  
9. You can remove the first element of an array by running `data.shift`. Do that now.
7. Sometimes you want to add an element to the *beginning* of an array. You do that with `data.unshift("purple")`. But wait a minute. You can't add the cup with marker `4` to the beginning of `data`. What do you do?
8. You can also insert data into a specific location. Say you ran `data.insert(3, "orange")`. How does that change things?
9. If you run `.shuffle` on an array it creates a copy of the array with the values shuffled in random order. But you only have enough cups for one array. How about you run `data = data.shuffle`?
10. There's a ton you can do with *enumerable* methods. But the fundamental enumerator is the method `each`. On the side of your paper, write the output for this code: `data.each {|b| puts b }`.

Got it? Here are the important concepts you've seen:

* You can directly assign a value to a location in an array using `[]`
* You can access the value stored at a position by using `[]`
* You can add an element to the end of an array with `<<` or `.push`
* You can remove an element from the end of an array with `.pop`
* You can add an element to the front of an array with `.unshift`.
* The `insert` method takes two arguments: first is the position where you want to insert the data, the second is the data to be inserted
* `shuffle` returns a copy of your array with the elements randomly jumbled up
* `each` is an *enumerable* method which takes a block parameter and runs that block once for *each* element in the collection.

## Group Exercise

For this exercise you'll work in threes.

* Person `A` is in charge of reading the instructions
* Person `B` is in charge of the physical model
* Person `C` is in charge of working in IRB (in such a way that the others can see!)

Start with an empty `data` array in both the physical space and IRB.

#### Steps

1. Insert a "blue" bead to index 1 `data[1] = "blue"`
2. Check the value of index 0 `data[0]`
3. Check the value of index 1 `data[1]`
4. Check the count of the array `data.count`
5. Push a green and a red bead onto the array `data.push("green")` then `data.push("red")`
6. Pop the last bead off of the array `data.pop`
7. Remove the first element from the array `data.shift` -- what value will this return to you?
8. Check the count of the array `data.count`
9. Insert a red bead at index 1 `data.insert(1, "red")`
10. Insert an orange bead at index 1 `data.insert(1, "orange")`
11. Prepend a purple bead to the front of the array `data.unshift("purple")`
12. Overwrite the value at index 1 by assigning a yellow bead there `data[1] = "yellow"`

## Independent Work

You can continue to sit in your threes to work independently and ask each other
questions / compare answers:

### From the Top

Start over with the [arrays section of Ruby in 100 Minutes](http://tutorials.jumpstartlab.com/projects/ruby_in_100_minutes.html#7.-arrays). Make sure to run the code snippets.

### Check Your Understanding

Here are some questions to check your understanding of arrays:

* We say that arrays are "zero-indexed". Why does that make counting and positions
somewhat confusing?
* Why would `array << 7` be useful as opposed to setting a specific index (ie `array[12] = 7`)
* It's easy to mix up `push` and `pop` or `shift` and `unshift`. Can you come
up with a way to keep them straight?
* Which methods that you've seen here can grow the size of the array? Which
shrink it?
* What happens if you try to access a position outside the length of the array
(like `array[100000]`)?
* What happens when you call `pop` on an empty array?
