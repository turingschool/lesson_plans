---
title: Writing Clojure Code
length: 90
tags: electives, clojure, functional programming
---

## Learning Goals

* Start writing our own Clojure code
* Understand basics of Clojure syntax
* Use Clojure Koans to explain some common language features

## Lesson

Below is a brief oveview of the basics of Clojure's syntax and some of
the tools and idioms for working with it. As you read through the
tutorial, run the code snippets in your REPL to get some experience
writing and executing Clojure statements.

### Part 1: Overview of Clojure Syntax

#### Lisp basics

Clojure is a dialect of lisp implemented on the JVM. Fortunately for us
lisp itself has a very minimal syntax -- learning Clojure is more about
applying the same small syntax and idioms across a number of different
functions than it is about learning a large set of language features.

#### REPL -- Leiningen

Last week we got set up using leiningen. Leiningen is a powerful
multi-tool for working with Clojure programs. It includes a repl, build
tool, and dependency manager -- sort of like a super-combination of
Bundler, Pry, and rubygems.

Throughout this tutorial, the REPL
included with Leiningen will be one of our most valuable tools.

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

Here we take the multiple arguments and turn them into a single string.

#### Prefix Notation

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
Clojure and other Lisps, everything is either data or a function (and as we will see, even this line sometimes blurs). Even fundamental
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

__Booleans__ are created using `true` or `false`

```clojure
true
false
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

Similarly, we can define functions using the `defn` function. Once a
function is defined, we invoke it using a `call` list just like the
built-in functions. `defn` is a slightly unusual function with a special syntax:

`(defn <function-name> [args*] <function-body>)

Try this example in your repl:

```clojure

(defn my-function [an-argument another-argument]
  (println (str an-argument another-argument)))

(my-function 123 "pizza")
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
already have a pre-defined name. We could define these using `defn` but
that's often a bit overkill. In these situations we might use an
anonymous function:

```clojure
;Create a function which takes a single argument
;and multiplies it by 2
(fn [arg] (* arg 2))
```


note that this ^ will return something like: `#<user$eval2927$fn__2928
user$eval2927$fn__2928@6c21f22f>`. Defining the function alone is not enough to do much; let's define the same function and invoke it immediately:

```clojure
;Create a function which takes a single argument
;and multiplies it by 2
((fn [arg] (* arg 2)) 3)
```

This should return `6` -- why? This code creates a list containing 2
elements: our anonymous function and the integer 3. Clojure identifies
this as a "call" list -- we are calling our newly-created anonymous function using the argument 3.

Here we start to see some of the power of Clojure's flexible but
consistent approach to evaluating list expression. The interpreter
simply continues reducing expressions until they evaluate to a simple
value -- it doesn't care if it is evaluating functions, data, or both
together.

#### Conditionals

Conditionals are handled in Clojure using -- you guessed it -- just another function.
Specifically the function `if`, which takes 3 arguments -- a "condition",
a "consequent" (what will happen if the condition is true), and an
optional "else branch" which will happen if the condition is false:

```clojure
(if false
  1234
  5678)
```

Also worth noting is the function `=`, which is used for performing
equality checks. We often use it with conditionals:

```clojure
(if (= "pizza" "pizza")
  "yumm"
  "blergh")
```

#### Loops

In clojure, we prefer to solve problems which deal with repeated
processes using recursion. The built-in `loop` function makes this easy.
The structure of loop looks like:

```clojure
(loop [an-argument an-initial-value]
  (if (= an-argument some-termination-case)
    "done with our recursion"
    (recur (manipulate an-argument))
```

The first argument to loop is a vector of variable and "seed value"
pairs. In this example `an-argument` will be an argument to our loop
each time it recurs, and `an-initial-value` will be the value on the
first iteration.

Remember that with recursion, we're always looking for a termination
case -- often this might be something like "if the argument is 0", "if
the argument is empty", or "if the argument is nil"

The syntax of `loop` can be a bit intimidating, so let's look at another
example. Here we want to loop through the numbers from 10 to 0 and sum
them up. When we reach 0, we'll print the sum. Each pass through the
loop we'll use an intermediate `sum` argument to keep track of our
progress.

Run this example in you repl to get comfortable with the syntax:

```clojure
(loop [counter 10 sum 0]
  (if (= 0 counter)
    (println (str "Got: " sum))
    (recur (dec counter) (+ counter sum))))
```

__Challenge:__

This example is useful for demonstrating `loop`, but it's probably not
actually how we would achieve this functionality in clojure. Can you
think of a better way? See if you can find the sum of the numbers from 1
to 10 using `reduce`.


### Part 2: Explore Further with Clojure Koans

That concludes our brief overview of Clojure syntax. Now we're ready to
start looking at some slightly more advanced features and patterns. To
do this, let's look at some Clojure Koans. "Koans" are an idea from
eastern philosophy, imported to the programming community a few years
ago by Neo, which brought us the now somewhat-famous [Ruby Koans](http://rubykoans.com/). Programming Koans feature a series of short but conceptually dense exercises meant to demonstrate or explain features of a language.


You can read more about the Clojure Koans [here](http://clojurekoans.com/), but for our purposes, we're mostly interested in getting started with the exercises.


The Koans are available on github, so get started by cloning them onto
your machine:

```
git clone git://github.com/functional-koans/clojure-koans.git && cd
clojure-koans
```

Remember Leiningen? Our [mustachioed clojure wundertool](http://leiningen.org/)?

We'll use leiningen to run the clojure koans, like so:

```
lein koan run
```

This will start the koans on your machine. The Koans are basically a
test suite designed around core features of Clojure. But rather than
implementing functionality for them, we'll be filling in the tests.

When your koans start, you'll see a message like:

```
Now meditate on ~/clojure-koans/src/koans/01_equalities.clj:3
---------------------
Assertion failed!
We shall contemplate truth by testing reality, via equality.
(= __ true)
```

To get started, open the file indicated by the message and meditate upon
the current failure. When you figure out what should go in the `__`
blank, fill it in. The koans will re-run whenever you save the file, so
simply `save` to see the next koan.

As you work through the koans, you'll likely get stuck in a few places
-- this is expected, and when it happens try using google, an
instructor, or a fellow classmate for further explanation. But remember
that the objective is not just to fill in the blanks, but to comprehend
what each koan is doing. So try to make sure you understand each one
before moving on.

Finally, if you get really stuck on a particular koan, use the
repository [here](https://github.com/worace/clojure-koans)
as a reference.
