---
title: Big-O Notation
length: 90
tags: algorithms, performance, analysis, data structures
---

## Learning Goals

* Understand the basic concepts of Big-O Notation
* Understand why we analyze algorithms in terms of asymptotic and
  worst-case performance
* Understand why we care about the algorithmic complexity of our
  programs on a practical level
* Explore the performance characteristics of some common ruby operations

### Other Topics

* Big-O (upper bound) vs. Omega Notation (lower bound) vs. Theta Notation (upper and lower bound)

## Structure

* 10 - Warmup Discussion - introduce concept of Big-O
* 15 - Example - Video consumption via Amazon delivery vs. downloads
* 5 - Break
* 25 - Exercise -- exploring Big-O in Ruby using Arrays and Hashes
* 5 - Break
* 25 - 


### Big-O Notation -- What is it?

* Big-O as shorthand notation vs Big-O as catch-all term for algorithmic
  analysis techniques
* Asymptotic Analysis -- practice of analyzing algorithms' performance
  as they approach some upper bound
* How does asymptotic analysis allow us to simplify the process of
  analyzing an algorithm's performance?
* Why do we only care about performance of an algo as it reaches a large
  upper bound?

### Big-O Notation -- real-world example

Consider the example of Pierre, a voracious Cinemaphile and Amazon Prime
subscriber. Pierre can access some of the films he wants to view by
downloading them in digital format, but some of them he has to have
shipped from Amazon's warehouse.

He can only download 1 film at a time, but he can order as many as he
wants for delivery. However downloading a film takes 2 hours, while
delivery takes 2 days.

How long does it take Pierre to receive 2 films a piece by each delivery
method?

```
2 films * 2hrs/film download time = 4 hours
2 films * 2 days delivery time = 2 days
```

Obviously, the download method is faster -- if Pierre's films are
available online, he would be _fou_ not to access them this way.

But what if Pierre is trying to watch _a lot_ of movies? Say, 10,000
movies.

```
10000 films * 2hrs/film download time = 20k hours (833 days)
10000 films * 2 days delivery time = 2 days
```

_ZUT!_ As we can see, once the number of films (`n`) grows above a
certain threshold, delivery overtakes downloading as the most efficient
method of film acces.

__Visualizing Algorithmic Performance:__

Can we find a way to describe, mathematically, what is happening in the
example above? What would it look like if we plotted these
time-relationships on a simple graph?

* Constant time (delivery) vs. Linear time (download)

### Why care only about performance for large N?

As humans, we might be more likely to deal with 10 films rather than
10000 films. But it turns out that when working with computers we often
_do_ want to deal with the larger number.

* How can we analyze an algorithm in terms of its "order of growth"?
* Startup costs and "initial idiosyncrasies" -- need to discount small
  constants
* Initial times can be misleading (delivery vs. download) when compared
  with growth rates


### Exercise -- An example in Ruby

We can find plenty of examples of data structures and algorithms
we use as programmers which exhibit behaviors similar to the example
above. Experiment with 2 -- looking up elements by value in an array and
a hash

* Introduction -- Ruby's Benchmark library
* How do we find a value in an array? In a Hash?

1. Open an IRB session and define 2 methods in it. We'll use these to
   generate sample data for our examination:

```ruby
def array_of_length(n)
  (1..n).to_a
end

def hash_of_length(n)
  Hash[(1..n).zip((1..n).map(&:to_s))]
end
```

2. Create a hash of length 10 and an array of length 10 and experiment
   with finding different elements. Use benchmark to measure the outputs
   of your results:

```
h = hash_of_length(10)
a = array_of_length(10)
Benchmark.measure { h[10] }.to_s
Benchmark.measure { a.find { |i| i == 10 } }.to_s
```

3. These results are likely too small to make meaningful inferences
   from. Try some larger examples, using lengths of `100`, `1000`,
   `10_000`, `100_000`, and `1_000_000`. In each example find the last
   element of the list, and make note of the times you observe.


__Discussion -- Order of Growth of reading from a Hash vs. reading from
an Array__

