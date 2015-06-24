---
title: Algorithmic Complexity
length: 120
tags: fundamentals, computer science
---

## Discussion

* Why do we care about algorithmic complexity?
* Best-case, worst-case, average case
* Varied inputs result in varied performance
* Building for 100 pieces of data is easy
* Complexities: constant, log n, linear, n^2
* Analysis vs measurement

### Bubble Sort

Bubble Sort is a classic fundamental algorithm.

* the concept
* the basic algorithm
* the best-case input
* the worst-case input
* analyzing the complexity
* implementing the algorithm
* measuring the complexity

## Exercise

Implement Bubble Sort as described here: https://github.com/turingschool/challenges/blob/master/bubble_sort.markdown

## Measure

You can get some very quick feedback on how long a chunk of code takes to execute using the `Benchmark` library built
into Ruby. It works like this:

```
> require 'benchmark'
> Benchmark.realtime do
>   1_000_000.times{ rand(1000)^2 }
> end
 => 0.181666276010219
```

Measure the performance of your binary sort using a "worst case" style input of a thousand, a hundred thousand, and
ten million numbers. What complexity do you observe?

Here's a hint about (a) how to generate a large data set and (b) how to avoid printing it to your terminal:

```
> vals = (0..10_000_000).to_a.shuffle ; nil
 => nil
> puts Benchmark.realtime{ vals.sort } ; nil
0.38994793203892186
 => nil
```
