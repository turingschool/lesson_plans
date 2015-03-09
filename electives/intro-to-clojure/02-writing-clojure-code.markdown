
---
title: Writing Clojure Code
length: 90
tags: electives, clojure, functional programming
---

## Learning Goals

* Start writing our own clojure code
* Understand basics of clojure syntax
* Use Clojure Koans to explain some common language features

## Lesson

Below is a brief oveview of the basics of Clojure's syntax and some of
the tools and idioms for working with it. As you read through the
tutorial, run the code snippets in your REPL to get some experience
writing and executing Clojure statements.

### Overview Clojure Syntax

#### Lisp basics

Clojure is a dialect of lisp implemented on the JVM. Fortunately for us
lisp itself has a very minimal syntax -- learning Clojure is more about
applying the same small syntax and idioms across a number of different
functions than it is about learning a large set of language features.

#### REPL -- Leiningen

Last week we got set up using leiningen. Leiningen is a powerful
multi-tool for working with Clojure programs. It includes a repl, build
tool, and dependency manager -- sort of like a super combination of
Bundler, Pry, and rubygems.

Throughout this tutorial and the Koans we'll be doing later, the REPL
included in Leiningen will be one of our most valuable tools.

To fire up the REPL, run `lein repl` in your terminal. You'll then be
loaded into a clojure REPL where you can execute code:

```
worace @ Guinevere / lesson_plans / master ➸  lein repl
nREPL server started on port 60039 on host 127.0.0.1 - nrepl://127.0.0.1:60039
REPL-y 0.3.5, nREPL 0.2.6
Clojure 1.6.0
Java HotSpot(TM) 64-Bit Server VM 1.7.0_80-ea-b04
    Docs: (doc function-name-here)
          (find-doc "part-of-name-here")
  Source: (source function-name-here)
 Javadoc: (javadoc java-object-or-class-here)
    Exit: Control+D or (exit) or (quit)
 Results: Stored in vars *1, *2, *3, an exception in *e

user=> (+ 1 1)
2
```

The REPL is your most valuable tool for experimenting with and
understanding new bits of Clojure code -- use it well!

#### Parentheses, Lists, and Calls

In lisp, anything surrounded by parentheses is considered a "list"
(hence "list processing" -> "lisp"). The most common type of list (and
the one we'll be focusing on) is a `call` -- `call`s simply invoke
functions, just like methods in ruby.

Calls follow the form: `(operator operands*)`, where `operator` is a
"symbol" referring to the name of a previously defined function, and
`operands*` contains one or more arguments to the function.

Try this example in your repl:

```clojure
(str 123)
```

`str` here is the name of a function, and the integer `123` is its
argument. Many functions in clojure take one or more arguments,
consider:

```clojure
(str 123 456 789)
```

### Prefix Notation

Lisp's approach to positioning operators prior to their arguments is an
example of "prefix notation". An alternative to prefix notation is
"infix notation" -- this is what we're more used to in ruby.

Consider:

Ruby:

```ruby
1 + 1
```

VS:

Clojure:

```clojure
(+ 1 1)
```

At first this notation will likely feel clumsy, but it ultimately offers
a lot of power due to its consistency in dealing with all types of
functions and lists.

#### Everything is a Function

In ruby we often hear the refrain "everything is an object". Well, in
Clojure and other Lisps, everything is a function. Even fundamental
operators such as `+` and `-` are defined as functions in Clojure, and
we invoke them using the standard prefix call notation like any other
function:

```clojure
(+ 123 456)
(/ 9 3)
```

#### Data Types

Clojure uses many of the standard data types we know and love from
ruby. Despite being implemented using the JVM, Clojure still uses
dynamic typing -- you'll notice in these examples that we don't need to
declare the types of the data we create.

Try these examples in your REPL to get some experience with
Clojure data types:

__Integers__ are created using digits

```clojure
1234
```

__Floats__ are created using a decimal point

```clojure
12.34
```

__Strings__ are created with double quotes

```clojure
"pizza"
```

__Vectors__ are similar to ruby arrays
Create them with square brackets.
(note that elements are separated by spaces rather than commas)

```clojure
[1 2 3 4]
```

Vectors can contain multiple types of data:

```clojure
[1 "abcd" 2.0]
```

__Keywords__ are similar to symbols in ruby.
They are often used as keys in maps

```clojure
:pizza
```

__Maps__ are similar to ruby's hashes.
A key is followed immediately by its value,
and key-value pairs are separated by spaces

```clojure
{:a "b" :c "d"}
```

Retrieve values from a map using the get function

```clojure
(get {:a "b"} :a)
```

#### Defining Variables

Variables can be created using the `def` function:

```clojure
(def pizza "mmmmm")
(str pizza)
```

In practice, we often avoid using `def` to create state in favor of
another approach which we'll see next.

#### Defining functions

Similarly, we can define functions using the `defn` function. `defn` is
a slightly unusual function with a special syntax:

```clojure

(defn my-function [an-argument another-argument]
  (println (str an-argument another-argument)))

```

#### Let

`let` is a Clojure function which allows us to define "local variables"
within the context of a block of code. We often prefer using `let` in
Clojure over `def` since the side effects of `let` are constrained
within the scope of the function, while `def` will be global within the
current namespace.

Try this example in your repl:

```clojure
(let [my-string "pizza"]
  (println my-string))
```

Here we're using `let` to define the local variable `my-string` and then
printing it. `let` can make our programs more readable by
giving names to intermediate concepts. It can also be useful to temporarily save the value of an expensive computation which you might re-use.

#### Higher Order Functions

Clojure gets things done by manipulating data using functions. However
in addition to the basic data types we've seen, we can also use
functions to manipulate _other functions_.

A function which takes another function as an argument is called a
"higher order function".

You are already quite familiar with Higher Order Functions from ruby:

```ruby
[1,2,3,4].map do |int|
  int * 2
end
=> [2,4,6,8]
```

In this example, map is a method (function) which is taking as an
argument a block. That block serves as another function, which is
applied to all of the items in the collection.

Blocks in ruby are very similar to functions in other languages, and as
such methods which take blocks can be considered "higher order".

In clojure, we frequently use higher order functions to express
complicated tasks, and we will see that many of the enumerables we know
from ruby appear in Clojure as well.

Try these examples in your repl:

```clojure
;apply the function str to each item in the collection
;[1 2 3 4] and return the results as a new collection:
(map str [1 2 3 4])

;combine the elements in the collection using
;the * function and return the resulting value
(reduce * [2 4 6 8])
```

#### Anonymous functions

Often we might want to pass a function as an argument which does not
already have a pre-defined name. We could define these using 

- conditionals
- loops


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
