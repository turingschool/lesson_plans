---
title: Performance of Code
length: 90
tags: ruby, optimization, performance
---

## Learning Goals

* measure the performance of Ruby code
* identify some common patterns associated with inefficient code
* show how size of dataset can impact the performance of code
* benchmark various tasks (getting data from RAM, disk, API)


## Agenda

* 2 min - Goals
* 15 min - Benchmarking Intro
* 20 min - Playing with Benchmark
* 15 min - Profiling Intro
* 15 min - Playing with Profiling
* 5 min - Wrap up

## Warmup / Discussion

* Discussion: What does "benchmarking" or "profiling" mean in the
  general case.
* What metrics might we want to profile for an application?
* How do we decide what metrics are most important for our app?
* How does benchmarking re-inforce and inform the optimization process?
  (Similar to refactoring without tests, without measurement you're not optimizing;
  you're just changing things)

## What's in a Profiling Tool?

In short, all a perf tool needs to be able to do is measure and output
information about a given metric that we're interested in.

Most often this metric is "time", but memory, storage space,
database queries, or network activity are sometimes often of interest.

Perf tools range from very simple to more complex

* Simple profiling with Ruby's "Time" class
* Benchmark (built into Ruby)
* Profile (built into Ruby)
* Ruby-Prof (Gem)

## Simplest benchmark: Time.now

* In some cases a very simple tool will suffice
* Don't forget you can always manually benchmark something by storing
  current time and checking against it after running an instruction

__For example:__

```
a = (1..60).to_a
start_time = Time.now
10000.times { a.shuffle }
puts "Shuffling took #{Time.now - start_time} seconds"
```

If we find ourselves using it a lot, we can even wrap this in method for
convenience:

```
def simple_prof(name)
  puts "profiling #{name}"
  start = Time.now
  val = block_given? ? yield : nil
  puts "finished #{name} in #{Time.now - start}"
  val
end

a = (1..60).to_a
simple_prof("shuffling an array") do
  100000.times { a.shuffle }
end
```

## Benchmark

* `Benchmark` tool is part of Standard Library (must be required)
* It offers performance profiling functionality similar to what we
  looked at above but with more features and some conveniences that make
  it pleasant to use
* set a variable to run code a certain number of times (x = 1_000_000)

__Several interfaces to `Benchmark`__:

* `.realtime` -- similar to what we did above -- simple real-time
  measurement of a block
* `.measure` -- measurement of a block, reporting distinct user, system,
  total, and real times
* `.bm` -- allows us to run a profiling "session" with multiple sections
  of code in a single batch; reports stats similar to `.measure`
* `.bmbm` -- similar to `.bm`, but runs an initial "rehearsal", then
  forces the Garbage Collector to run. This protects our results from
  being unevenly impacted by the GC.

__Benchmark.realtime__

```ruby
a = (1..10000).to_a;nil
Benchmark.realtime { a.map(&:to_s).map(&:chars).map(&:rotate) }
=> 0.011097 # outputs simple real time measurement in seconds
```

__Benchmark.measure

```ruby
a = (1..100000).to_a;nil
Benchmark.measure { a.map(&:to_s).map(&:chars).map(&:shuffle).map(&:join) }
=> #<Benchmark::Tms:0x007feef2c3b250 @label="", @real=0.329244, @cstime=0.0, @cutime=0.0, @stime=0.020000000000000018, @utime=0.3100000000000005, @total=0.3300000000000005>
# ^ returns Benchmark::Tms object which stores our measured time
# output it to a more readable string with to_s
Benchmark.measure { a.map(&:to_s).map(&:chars).map(&:shuffle).map(&:join) }.to_s
=> "  0.310000   0.020000   0.330000 (  0.329244)\n"
```

__Benchmark.bm__

```ruby
arr = (1..100000).to_a;nil
Benchmark.bm do |performance|
  performance.report('shuffling') { 10.times { arr.shuffle } }
  performance.report('join') { 10.times { arr.join } }
end
```

example output:

```
       user     system      total        real
shuffling  0.000000   0.000000   0.000000 (  0.004008)
join  0.040000   0.000000   0.040000 (  0.040415)
```

__Benchmark.bmbm__

Try running the example above a bunch of times in a row. You'll likely
see from time to time that the times jump quite a bit. This is usually
due to the Garbage Collector kicking in, causing ruby to pause our code
for a moment

In an attempt to standardize benchmark times,
Benchmark.bmbm runs a "rehearsal", then runs GC.start, then runs the real thing.

```ruby
arr = (1..100000).to_a;nil
Benchmark.bmbm do |performance|
  performance.report('shuffling') { 10.times { arr.shuffle } }
  performance.report('join') { 10.times { arr.join } }
end
```

Output:

```
Rehearsal ---------------------------------------------
shuffling   0.040000   0.000000   0.040000 (  0.035227)
join        0.360000   0.000000   0.360000 (  0.364264)
------------------------------------ total: 0.400000sec

                user     system      total        real
shuffling   0.040000   0.000000   0.040000 (  0.040185)
join        0.330000   0.000000   0.330000 (  0.324359)
```

### What do these times mean anyway?
* "Real" time is also known as "wall time" -- it's how much time
  a clock on the wall would measure between the start and end of process
* User time is time spent on running our actual code
* System time is the time spent on running system instructions; this
could include reading from the file system
* Total time is User + System time.
* "Real" time is in theory just a sum of User + System time -- can we
  think of a situation when it would be more?

__a little Unix context:__

The convention of reporting these specific numbers comes from the Unix
`time` utility. This utility provides an interface similar to Benchmark
but via the command line rather than via ruby.

Try it out in your terminal (not IRB):

`time ruby -e "10000.times { (1..10000).to_a }"`

To see an example with lots of "system" time, try reading from the file
system repeatedly:

`time ruby -e "400.times { File.read('/usr/share/dict/words'); nil }"`

### Benchmarking Exercises

 [Repo](https://github.com/rwarbelow/performance_of_code)

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
