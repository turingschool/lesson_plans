---
title: Beginner Enumerables
length: 90
tags: enumerables, map, select, find
---

## Goals

* Learn how to use recreate the functionality of map, select and find
using .each
* Understand how to use map, select, and find appropriately.

### Hook

We've already learned how to use each, and we can do some really cool
things with each, but we can do better.

### Map / Collect

Map is a lot like each.

The difference is that map actually returns whatever we do in the block. Think about how this is different from each that will always return the content of the original array.

Let's look at this in code. Let's take an array of the numbers one through five, and we want to end up with an array with the doubles of each of those numbers. With each, we would do it like this:

```ruby
def double
  numberzzz = [1,2,3,4,5]

  result = []

  numberzzz.each do |num|
    result << num * 2
  end

  return result
end
```

We've written a method called double. We start off with result, which we set to a an empty array. With each, we work through each item of the `numberzzz`, and with each element, we are doubling the number and we are putting it into the `result` container. At the end, we are returning explicitly the `result` variable, which should now contain [2,4,6,7,10].

This code is decent. But there are things about it I'm not entirely thrilled about. For example, we are temporarily storing things in a variable, `result`, which is inefficient. You want to avoid the use of unnecessary variables when you can. This is how we can achieve the same result using Map.

```ruby
def double
  numberzzz = [1,2,3,4,5]

  numberzzz.map do |num|
    num * 2
  end
end
```

Instinctually, this should look better to you. We don't have any unnecessary variable assignment. You may ask yourself why we aren't returning a result explicitly? Remember that a method always returns the last evaluated statement. Also remember that the last statement in a block is the one that gets returned as well.

```ruby
def double
  numberzzz = [1,2,3,4,5]

  numberzzz.map do |num|
    num * 2
    puts "I really really like you"
  end
end
```

With this code, what do you think this method returns? Why?

Let's practice, I want this method to return all of these names in caps.

```ruby

def internally_screaming
  people = ["Taylor Swift", "Carly Rae Jeppsen", "Zara Larssen"]

  people.map do |name|
    # CODE HERE!
  end
end
```

### Find / Detect

A good thing about the methods in Ruby is that you can pretty much figure out what they do just by the name.

What do you think Find or Detect does?

Find will return the first item in which the block returns not false.

But before we go into the syntax about how that works, let's implement it with each.

```ruby
def find_me_first_even
  array = [1,2,3,4,5]

  array.each do |num|
    return num if num.even?
  end
end
```

We walk through the array, and upon the first number it comes across that makes the block returns true, it just returns the item and we are D-U-N, done.

This looks like fairly simple code, but we can make it cleaner with find.

```ruby
def find_me_first_even
  array = [1,2,3,4,5]

  array.find do |num|
    num.even?
  end
end
```

Oh just look at that, so nice. Remember, it will return the first item for which the block returns a non-false value.

Practice - find me the first word over three letters in length.

```ruby
def find_long
  array = ["dog", "caterpillar", "bee" ]

  array.find do |word|
    #CODE HERE
  end
end
```

### Find_all / Select

We've figured out how to make get one matching thing out of an array, but what if we want ALL of the matching things?

Let's start by thinking about how we would do this using our old friend, each.

```ruby
def all_the_odds

  array = [1,2,3,4,5]
  result = []
  array.each do |num|
    result << num if num.odd?
  end
  return result
end
```

How does this look? Not bad, but we have that result container variable that we don't like. Pay attention to this - this is a pattern we want to keep an eye out in the future. If we are catching things with an collector like this there's probably a better enumerable that we can use. So let's use select.

```ruby
def all_the_odds
  array = [1,2,3,4,5]
  array.select do |num|
    num.odd?
  end
end
```

Better. I like it.

Practice - let's grab all of the people whose name starts with a T.

```ruby
def named_t
  array = ["Taylor", "Fred", "Bob", "Terry", "Jeff"]
  array.select do |name|
    # CODE HERE
  end
end
```

### Homework

Work on just the find, select and map exercises for [these](https://github.com/turingschool/enums-exercises).
