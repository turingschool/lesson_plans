---
title: Performance of Code
length: 60
tags: ruby, optimization, performance
---

## Learning Goals

* measure the performance of Ruby code
* determine why one instruction could be slower or faster than several instructions
* show how size of dataset can impact the performance of code
* benchmark various tasks (getting data from RAM, disk, API)

## Agenda

* 2 min - Goals
* 15 min - Benchmarking Intro
* 20 min - Playing with Benchmark
* 15 min - Profiling Intro
* 15 min - Playing with Profiling
* 5 min - Wrap up 

## Materials
* [Repo](https://github.com/rwarbelow/performance_of_code)

## Key Points

* Code is not free.
* All instructions are not created equally. 


## Tools

* Benchmark (built into Ruby)
* Profile (built into Ruby)
* Ruby-Prof (Gem)


## Benchmark

* Used to measure and report time used to execute Ruby code
* part of Standard Library (must be required)
* set a variable to run code a certain number of times (x = 1_000_000)

#### Benchmark.bm
```ruby
Benchmark.bm do |performance|
  performance.report('thing1') { 
    # your code here
  }

  performance.report('thing2') { 
    # your code here
  }
  ...
end
```

#### Benchmark.bmbm
The times may vary dramatically between running Benchmark.bm. In an attempt to standardize benchmark times,
Benchmark.bmbm runs a "rehearsal", then runs GC.start, then runs the real thing.

```ruby
Benchmark.bmbm do |performance|
  performance.report('thing1') { 
    # your code here
  }

  performance.report('thing2') { 
    # your code here
  }
  ...
end
```

#### Output
* Real time is the amount of time that a stopwatch or clock would measure between the start and end of process. 
* User time is the time spent on running code that the user typed.
* System time is the time spent on running system instructions.
* Total time is User + System time.

#### Benchmark Exercises
* Loops
* Combining Strings
* Array Methods
* Destructive vs. Non-Destructive Methods
* Variable assignment
* Accessing data with attr_reader vs. instance variable
* Reading data from file vs. reading data from memory
* Conditional vs. Rescue

## Profiling Code
* Profilers are used to determine which methods are called, how many times they are called,
and how long each method is taking.
* Profilers are useful for finding bottlenecks in your code.

#### Ruby Profiler
```
ruby -rprofile filename.rb
```
#### Ruby-Prof Gem
```
gem install ruby-prof
ruby-prof filename.rb
```

#### Profiling Exercises
* Car
* Fibonacci Sequence
* Repeated Calculations
