---
title: Hashes
length: 90
tags: ruby, hashes, data structures
---

## Learning Goals

* Understand that there are multiple types of collections
* Develop a mental model to understand hashes
* Gain some familiarity with common hash methods

## Structure

* 5 - Warmup
* 25 - Together - Building a Hash
* 5 - Break
* 25 - Group Exercise
* 5 - Break
* 25 - Independent Practice

## Hashes

### Supplies

For this section, we'll walk through performing some common Hash operations both in code using IRB and in a physical model using some basic supplies.

You'll need these supplies:

1. 1 Black Velvet Bag
2. 5 Beads
3. 5 Bead Labels

### Intro - Hash Properties

Hashes are the second most important data structure in Ruby. Like an Array, a Hash is a data structure used for representing a _collection_ of things. But whereas an Array generally represents a **list** of things (ordered, identified by numeric position), we use a Hash to represent a collection of *named* values. In a Hash, we can insert data by assigning it to a name and later retrieving it using the same name.

Some languages call their Hashes *dictionaries* for this reason -- you look up a word (the label) to retrieve its definition (the data or value with which the label was associated).

Key ideas:

* Ordered vs. Unordered
* Pairs
* Determinism and uniqueness
* Choosing a hash vs an array
* Performance characteristics

### Working a Hash

Now let's model some of the common hash operations in the physical space alongside an IRB session. As we go, we'll look at these common methods:

* `[]`
* `[]=`
* `keys`
* `values`

Follow along with the instructor as you walk through the following operations:

1. Create a new hash `data = {}`
2. Assign the key `pink`: `data["pink"] = Bead.new`
3. Read the value: `data["pink"]`
4. Store a second pair: `data["white"] = Bead.new`
5. Reuse a key: `data["pink"] = Bead.new`
6. Create a key for nothing: `data["brown"] = nil`
7. Retrieving a list of `keys` from the hash
8. Retrieving a list of `values` from the hash
9. Get a little weird: `data["red"] = [Bead.new, Bead.new]`
10. Get more weird: `data["orange"] = {"yellow" => Bead.new, "red" => Bead.new}`
11. Consider the key `"red"` and how it does and doesn't exist twice
12. Mess up your brain: `data["spinning top"] = data`

## Group Exercise

For this exercise you'll work in threes.

* Person `A` is in charge of reading the instructions
* Person `B` is in charge of the physical model
* Person `C` is in charge of working in IRB (in such a way that the others can see!)

Start with an empty `data` hash in both the physical space and IRB.

For the IRB person, recall that you can create a simple `Bead` model like this:

```ruby
class Bead
end
```

### Steps

1. Insert a "blue" bead `data["blue"] = Bead.new`
2. Find the value attached to the key `"blue"`
3. Find the value attached to the key `"green"`
4. Add a new bead referenced by the key `"green"`
5. Add a new bead referenced by the key `"purple"`
6. What are the `keys`? What kind of object does that method return?
7. What are the `values`? What kind of object does that method return?
8. What's interesting about the order of the return value of both `keys` and `values`?
9. Add a new bead referenced by the key `"green"`
10. How has `keys` changed after the last step? How has `values` changed? What
was lost?

## Independent Work

Finally let's break up for some independent work with Hashes and Arrays.

### Hash and Array Nesting

As our programs get more complex, we'll sometimes encounter more sophisticated combinations of these structures. Consider the following scenarios:

#### Array within an Array

```
a = [[1, 2, 3], [4, 5, 6]]
```

* what is `a.count`
* what is `a.first.count`
* how can I access the element `5`

#### Hash within an Array

```
a = [{:pizza => "tasty"}, {:calzone => "also tasty"}]
```

* what is `a.count`
* what is `a.first.count`
* how can I access the element `"also tasty"`

#### Hash within a Hash

```
h = {:dog => {:name => "Chance", :weight => "45 pounds"}, :cat => {:name => "Sassy", :weight => "15 pounds"}}
```

* what is `h.count`
* what is `h.keys`
* what is `h.values`
* how can I access the element `"15 pounds"`

### Practicing with Hashes and Nesting

Now that we've worked through the basics, complete [Challenge 2 from the Collections Challenges](https://github.com/turingschool/challenges/blob/master/collections.markdown#2-state-capitals)

### From the Top

Now you've got a decent understanding of hashes. Let's go at it from the
beginning and try to fill a few of the gaps: work through the [Hashes section of Ruby in 100 Minutes](http://tutorials.jumpstartlab.com/projects/ruby_in_100_minutes.html#8.-hashes) to pickup a bit more.
