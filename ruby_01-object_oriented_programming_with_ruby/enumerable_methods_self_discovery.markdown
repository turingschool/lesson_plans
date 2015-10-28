---
title: Enumerable Methods Self Discovery
length: 150
tags: enumerable, ruby, collections, arrays
---

# Enumerables

This a variant of the other [enumerable_methods](enumerable_methods.markdown),
it is very similar, but attempts to teach the students how to discover answers
that they don't know rather than needing someone to teach them.

## What are they?

"Enumerable", in Ruby, is a set of methods for collections. They are used in all the common collection classes. This command will tell you which classes. Try to guess a few before you run it:

```
$ ruby -e 'p ObjectSpace.each_object(Class).select { |c| c < Enumerable }'
```

To use Enumerable, a class needs to define its own `each` method, all Enumerables are abstractions on top of `each`.


## Teaching ourselves

Here are a set categories, turn each one into a comment,
and place each enumerable method beneath the given category with a description of what it does and an example to illustrate it.
When we are done, we will have a cheatsheet we can refer back to, and it will be runnable with Seeing Is Believing.
If, after several tries, you don't have any good idea how to use it, you can look at [the documentation](http://ruby-doc.org/core-2.2.2/Enumerable.html)

* Enumerable methods that iterate over a collection
* Enumerable methods that filter a collection
* Enumerable methods that return true or false
* Enumerable Methods that Distill a Collection to One Value
* Enumerable Methods that Return New-Shaped Collections

Here are the methods to categorize. Pay attention to all information available to you.
What might the name mean? Does it blow up if you give it an argument? What might that name mean if it takes an argument?
Did it do nothing interesting? Maybe it takes a block, what might go in the block? What might the block receive?
How can you answer those questions? (hint: Seeing Is Believing)

```
to_a
count
find
find_all
map
inject
group_by
each_with_object
take
drop
each_with_index
first
all?
any?
none?
min
min_by
max
max_by
include?
sort
zip
```


## Lets figure the first one out together

Lets figure out how `map` works, together using Seeing Is Believing.

(after working our way through, we come up with this one:)

```markdown
# Enumerable methods that iterate over a collection

# map
# Get a collection of desired values,
# based on a collection of existing values
numbers = [1,2,3,4,5]
squares = numbers.map { |number| number ** 2 }
numbers # => [1, 2, 3, 4, 5]
squares # => [1, 4, 9, 16, 25]

# Enumerable methods that filter a collection

# Enumerable methods that return true or false

# Enumerable Methods that Distill a Collection to One Value

# Enumerable Methods that Return New-Shaped Collections
```


## Some questions to help you explore:

* What contexts might this word make sense in?
* What thing might I want to do to a collectino like an array, that I would describe using this word?
* How are Enumerable methods often called? What happens when I call it that way?
* Is there an error I can use to gain a better understanding of what to do or how it works?
* How does this differ from things I know that it seems similar to?
* What if I take this idea to an extreme, does it do what I predict?
* When might I use this?

## Go through the Enumerable Exercises

We have a large number of small focused tests to try and illustrate the patterns in Enumerable.
Work through them until they are all passing: [enums-exercise](https://github.com/JumpstartLab/enums-exercises)

If you would like to see me code, I implemented Enumerable on video [here](https://vimeo.com/133626457).
