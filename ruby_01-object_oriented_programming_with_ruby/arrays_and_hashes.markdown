---
title: Arrays & Hashes
length: 90
tags: ruby, arrays, hashes, data structures
---

## Learning Goals

* Develop a mental model to understand Arrays
* Develop a mental model to understand Hashes
* Gain some familiarity with common array and hash methods

## Structure

* 5 - Warmup
* 25 - Introducing Arrays
* 5 - Break
* 25 - Introducing Hashes
* 5 - Break
* 25 - Practicing with Arrays & Hashes

## Lesson

### Warmup

For this lesson your warmup is to build things. You have less than five minutes to:

* Take your five paper cups and use a marker to number them "0" through "4"
* Take four of your wooden beads and tie a white hanger tag around each of them
* Leave your remaining beads in a pile

### Arrays

Arrays are the most fundamental collection type in programming. Just about every language has them. Arrays are collections of data where each element is addressed by an arbitrary number called the *index* or *position*.

Let's model some of the core concepts.

1. Lay down your large piece of paper and write `data` in large letters. This is the name of your collection. How many elements are in your collection so far?
2. Put the empty `0` cup on the paper. If you now fetched the value inside `data[0]`, what would you get back?
3. Store a bead into the zero cup, the equivalent of maybe `data[0] = Bead.new`. What would you expect the answer of `data.count` to be?
4. We can explicitly set the value of another cup. Add `data[1] = Bead.new`. That does note change the answer to `data.first`, but does change `data.last`. Why?
5. The "shovel" operator (`<<`) adds an element to the end of an existing array. Pretend you ran `data << Bead.new`. How many beads are in the array in total?
6. It turns out that "shovel" is just syntactic sugar for the method named `push`. Pretend you ran `data.push(nil)`. How does that affect your array? What is the value of `data.count` now?
7. Sometimes you want to add an element to the *beginning* of an array. You do that with `data.unshift(Bead.new)`. But wait a minute. You can't add the cup with marker `4` to the beginning of `data`. What do you do?
8. You can also insert data into a specific location. Say you ran `data.insert(3, Bead.new)`. How does that change things?
9. You can remove the last element of an array by running `data.pop`. Do that now.
9. If you run `.shuffle` on an array it creates a copy of the array with the values shuffled in random order. But you only have enough cups for one array. How about you run `data = data.shuffle`?
10. There's a ton you can do with *enumerable* methods. But the fundamental enumerator is the method `each`. On the side of your paper, write the output for this code: `data.each{|b| puts "Bead Size: #{b.size}mm"}` and guess the size of each bead in millimeters

Got it? Here are the important concepts you've seen:

* You can directly assign a value to a location in an array using `[]`
* You can access the value stored at a position by using `[]`
* You can add an element to the end of an array with `<<` or `.push`
* You can remove an element from the end of an array with `.pop`
* You can add an element to the front of an array with `.unshift`. (*Note*: though not included above, `.shift` pulls off the front element)
* The `insert` method takes two arguments: first is the position where you want to insert the data, the second is the data to be inserted
* `shuffle` returns a copy of your array with the elements randomly jumbled up
* `each` is an *enumerable* method which takes a block parameter and runs that block once for *each* element in the collection.

For a little different explanation / further reading, check out the [arrays section of Ruby in 100 Minutes](http://tutorials.jumpstartlab.com/projects/ruby_in_100_minutes.html#7.-arrays).

### Introducing Hashes

Hashes are the second most important data structure in Ruby. They're a collection of data where each element is *addressed by a unique name*. Let's do some experiments.

1. Hold the black bag in your hand. This is your hash named...wait for it... `data`. You're starting the hash as though you ran `data = {}` or `data = Hash.new` (they're equivalent).
2. Take a bead-with-a-tag and write `"T"` on the tag. Insert the bead into the bag and leave the tag hanging over the edge. This is the equivalent of running the code `data["T"] = Bead.new`
3. Hashes don't have things like shovel, push, or pop. Instead run `data["U"] = Bead.new`
4. The beads in the bag are *not* in a certain order. There's no `shift` or `unshift` because there's no beginning or end. Contemplate the hash as an egalitarian society as you run `data["R"] = Bead.new`
5. So what is the point of a hash, anyway? Run the code `data["T"]` which finds the *value* associated with the name `"T"`. The name is really called the `key`, hashes are made up of *key-value pairs*
6. Let's do something wrong. Run `data["R"] = Bead.new` inserting a new bead into the hash. BUT WAIT! We've created a problem! What is it? Why's this a problem?
7. Once in awhile you'll run `data.keys` which returns you an Array (*say whaaat??*) of just the keys (not the values). What would that look like right now?
8. You can also call `data.values` to get just the value side of the pairs. What kind of data would that be? What would the values be?
9. You can use enumerable methods like `each` on a hash. Use a bit of your array paper to record the output of this code: `data.each{|k,v| puts "#{k} points to a bead that is #{v.size}mm"}`. What order would the pairs come out in (*warning*: trick question).

There aren't nearly as many useful methods on hashes as there are on arrays. Mostly we just store things in there and fetch them out later using the key.

Here are your key takeaways:

* You create a hash with `data = {}` or `data = Hash.new`
* Hashes contain key-value pairs. The key is the name that used to find the data. The value is the data that the pair stores.
* You can assign a key-value pair with bracket notation like `data[some_key] = some_value`
* Key names must be unique. If you already had a key named `"X"` then said `data["X"] = new_value` then you would *not* be creating a second key with the name `"X"`. You would be replacing the old value associated with `"X"` with the `new_value` (discarding the old value).
* You can run `.each` on a hash and it's sometimes a valuable things to do -- but it's a bit weird/unpredictable because hashes are unordered

That's your quick intro to Hashes. Read through the [Hashes section of Ruby in 100 Minutes](http://tutorials.jumpstartlab.com/projects/ruby_in_100_minutes.html#8.-hashes) to pickup a bit more.

### Practicing with Arrays and Hashes

Unfortunately that's the end of Arts & Crafts time, boohoo. Fire up that `irb` and run the through the same sequences of steps for both an Array and a Hash to see if your mental model matches up with the real results in code.

*Bonus mind bending*: What if you store an array inside an array? A hash inside an array? An array as the data in a hash? Some unholy mishmash of all these things?
