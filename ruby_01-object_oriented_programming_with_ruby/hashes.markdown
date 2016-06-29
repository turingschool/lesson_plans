---
title: Hashes
length: 90
tags: ruby, hashes, data structures
---

## Structure

* 5 - Warmup
* 25 - Introducing Arrays
* 5 - Break
* 25 - Introducing Hashes
* 5 - Break
* 25 - Practicing with Arrays & Hashes

## Hashes

### Supplies

For this section, we'll walk through performing some common Hash operations both in code using IRB and in a physical model using some basic supplies.

You'll need these supplies:

1. 1 Black Velvet Bag
2. 5-6 Beads
3. 5-6 Bead Labels

### Intro - Hash Properties

Hashes are the second most important data structure in Ruby. Like an Array, a Hash is a data structure used for representing a _collection_ of things. But whereas an Array generally represents a **list** of things (ordered, identified by numeric position), we use a Hash to represent a collection of *named* values. In a Hash, we can insert arbitrary data by labeling it with an identifying name (we'll look at what kind of names get used in a moment) and later retrieve it using the same name.

Some languages call their Hashes *dictionaries* for this reason -- you look up a word (the label) to retrieve its definition (the data or value with which the label was associated).

* Ordered vs. Unordered
* "Associativity"
* What does a Hash model conceptually?
* Ubiquity of Hashes
* Performance characteristics
* Relative simplicity of a hash vs. an array

### Arts & Crafts

Now let's model some of the common hash operations using our arts and crafts supplies alongside an IRB session.

As we go, we'll look at these common methods:

* `[]`
* `[]=`
* `get`
* `keys`
* `values`

Follow along with the instructor as you walk through the following operations:

1. Creating a new hash `data = {}`
2. Assign the key "a" in the hash to the value "bead one" (use a bead to represent this) `bead_one = Bead.new; data["a"] = bead_one`
3. Reading the value of a key from a hash using `[]` and using `fetch` `data["a"]` and `data.fetch("a")`
4. Contemplating the egalitarian nature of a Hash as an unordered society
5. Attempting to set a value for a key that already exists -- consider uniqueness of the keys in a hash `data["a"] = "bead two"`
6. Add additional keys "b" "c" and "d" to the hash
7. Retrieve keys that don't exist using `[]` and using `fetch`
8. Retrieving a list of keys from the hash
9. Retrieving a list of values from a hash
10. Counting the number of key/value pairs in a hash
11. Enumerating a hash using `each`

For these examples, consider using a hash called data and a simple `Bead` class to represent the beads we're inserting into the hash.

```ruby
class Bead
end

data = {} # or data = Hash.new
data["a"] = Bead.new # set a value in the hash
data["a"]
data.fetch("a")
data["b"]
data.fetch("b")
bead_one = Bead.new
bead_two = Bead.new
data["a"] = bead_one
data["a"] == bead_one # => true
data["b"] = bead_two
data["b"] == bead_one # => false (keys in a hash are unique)
data.values
data.keys
data.count
data.each do |key, value|
  puts "Key is: #{key} and Value is: #{value}"
end
```

### Hash and Array Nesting

So far we've looked at pretty straightforward or "flat" collection data structures. As our programs get more complex, we'll sometimes encounter more sophisticated combinations of these structures.

Consider the following scenarios:

#### Array within an array

```
a = [[1, 2, 3], [4, 5, 6]]
```

* what is `a.count`
* what is `a.first.count`
* how can I access the element `5`

#### Hash within an array

```
a = [{:pizza => "tasty"}, {:calzone => "also tasty"}]
```

* what is `a.count`
* what is `a.first.count`
* how can I access the element `"also tasty"`

#### Hash within a hash

```
h = {:dog => {:name => "Chance", :weight => "45 pounds"}, :cat => {:name => "Sassy", :weight => "15 pounds"}}
```

* what is `h.count`
* what is `h.keys`
* what is `h.values`
* how can I access the element `"15 pounds"`

### Independent Exercise

Make the following simple hashes in IRB

1. Create a hash containing the names and hometowns of the 3 people sitting closest to you (use names as the keys and towns as the values)
2. For the person to your left and the person to your right, create a separate hash mapping their name to their hometown. Then, put those two hashes into a third hash where the keys are "left" and "right" and the values are the corresponding hash representing that person's name and hometown. How do you access the hometown of the person to your right?

### Deeper Practice

Now that we've worked through the basics, start on [Challenge 2 from the Collections Challenges](https://github.com/turingschool/challenges/blob/master/collections.markdown#2-state-capitals)

## Practicing with Arrays and Hashes

Read through the [Hashes section of Ruby in 100 Minutes](http://tutorials.jumpstartlab.com/projects/ruby_in_100_minutes.html#8.-hashes) to pickup a bit more.

Unfortunately that's the end of Arts & Crafts time, boohoo. Fire up that `irb` and run the through the same sequences of steps for both an Array and a Hash to see if your mental model matches up with the real results in code.

*Bonus mind bending*: What if you store an array inside an array? A hash inside an array? An array as the data in a hash? Some unholy mishmash of all these things?
