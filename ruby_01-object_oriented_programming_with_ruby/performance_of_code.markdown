---
title: Performance of Code
length: 120 +
tags: ruby, optimization, performance
---

## Learning Goals

* Learn how to measure the performance of Ruby code
* Practice identifying some common patterns associated with inefficient code
* Understand how size of dataset can impact the performance of code

## Agenda

* 10 min - Warmup / Discussion
* 15 min - Time.now, Benchmark
* 5 min  - Break
* 25 min - Benchmark continued
* 5 min  - Break
* 25 min - Benchmark exercises (independent)
* 5 min  - Break
* 15 min - Introduce Profiling Code
* 10 min - Ruby profiler exercise (independent)
* 5 min  - Break
* 15 min - Introduce Ruby-prof
* 10 min - Ruby-prof car exercise
* 5 min - Wrap up

## Warmup / Discussion

* Discussion: What does "benchmarking" or "profiling" mean in the
  general case.
* What metrics might we want to profile for an application?
* How do we decide what metrics are most important for our app?
* How does benchmarking reinforce and inform the optimization process?
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

```ruby
a = (1..60).to_a
start_time = Time.now
10000.times { a.shuffle }
puts "Shuffling took #{Time.now - start_time} seconds"
```

If we find ourselves using it a lot, we can even wrap this in method for
convenience:

```ruby
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

__Benchmark.measure__

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

Try it out in your terminal (not Pry):

`time ruby -e "10000.times { (1..10000).to_a }"`

To see an example with lots of "system" time, try reading from the file
system repeatedly:

`time ruby -e "400.times { File.read('/usr/share/dict/words'); nil }"`

### Benchmarking Exercises

Now that we're armed with some tools, practice on your own. One of the
fun things about Benchmarking is that it gives us a cool way to
learn about Ruby experimentally by measuring its behavior.

Clone this [Repo](https://github.com/turingschool/performance_of_code). In
it you'll find a simple file (`performance_of_code.rb`) which contains a
long list of sample code snippets to profile.

Experiment with uncommenting some of the blocks of code and moving them
into a Benchmark block.

Remember that it's often useful to experiment with different numbers of
iterations in loops, etc. to see what effect they have on performance of
the code.

* Loops
* Combining Strings
* Array Methods
* Destructive vs. Non-Destructive Methods
* Variable assignment
* Accessing data with attr_reader vs. instance variable
* Reading data from file vs. reading data from memory
* Conditional vs. Rescue

## Profiling Code

The terms "benchmarking" and "profiling" get used somewhat
interchangeably. However we often say "benchmarking" to refer to
measuring small, isolated sections of code like we saw above.

When we need to measure performance of the entirety of a longer program,
we may want to use another tool known as a "profiler."

As a rule of thumb, Benchmarking is most useful if you already have a
piece of code in mind that you want to investigate. A profiler, on the
other hand, can help you look at __all__ of your code and figure out
from a distance which pieces might be causing issues.

* Profilers are used to determine which methods are called, how many times they are called,
and how long each method is taking.
* Profilers are useful for finding bottlenecks in your code.
* Profilers are often equipped to measure other metrics such as memory
  usage.

#### Ruby Profiler

Ruby ships with a builtin profiling library. Let's try using it on the
`fib.rb` file included in the performance of code repo:

```
ruby -rprofile fib.rb
```

You should see some lengthy tabular output with information about what
methods are being called and their relative time consumption.

* Unlike benchmark which measures specific sections of code, the
  profiler measures whole program
* Profiler highlights which methods consume most time in the program,
  helping us isolate bottlenecks
* Often useful as a first step. Once we have a sense of where the
  problem is, we can add custom benchmarks to get even more specific
* Reading a profile effectively takes practice
* Try to isolate the parts that are most important (and that you have
  control over) from those parts that are incidental noise

#### Your Turn - Ruby Profiler

Try using the `-rprofile` flag on the included `car.rb` file.

See if you can make sense of the output.

Do you notice any particular bottlenecks?

#### Ruby-Prof Gem

The built-in ruby profiler is pretty good, but for even more in-depth analysis,
we can turn to the ruby-prof gem.

This library includes similar profiling features to the `-rprofile` ruby
flag, but it has the ability to display the information in some more
interesting formats.

* To see how it works, let's check out the example `fib_ruby_prof.rb` file.
* Try running the file, then check out the output that's appeared in the
  `tmp` directory in the project
* Notice ruby-prof includes several "printers" that output profile
  information in different formats
* Some cool ones are `profile.stack.html` and `profile.graph.html`

__Dot Printer__

Let's experiment with another cool printer called the "Dot Printer".
Try tweaking the code at the bottom of `fib_ruby_prof.rb` to use
this printer instead:

```
  printer = RubyProf::DotPrinter.new(result)
  File.open("./tmp/profile.dot", "w") do |f|
    printer.print(f)
  end
```

This should create 1 more file under tmp, a file called "profile.dot"

".dot" is a format used for modeling graphs. We can use the unix utility
`dot` to transform it into a more readable format like a PDF:

```
dot -T pdf -o ./tmp/profile.pdf ./tmp/profile.dot
open ./tmp/profile.pdf
```

__Note__ -- if you don't have the `dot` command on your computer (you get a "command not found" error when trying to run it), install the graphviz package using homebrew:

```
brew install graphviz
```

If everything has worked, you should see a PDF open which shows a
graphical call stack of our fib program. In this case the call stack is
quite minimal, but notice how many recursive calls to the fib method
there are. Holy exponential growth orders, Batman!

#### Your Turn - Profiling Exercise

Now that you've had some exposure to ruby-prof, try it out with the Car
class that we looked at before. Try wrapping the section of code at the
bottom of the file with the RubyProf gem.

You can refer to the `fib_ruby_prof.rb` example as a reference.

* Can you identify any particular bottlenecks in our Car?
* Are there methods that take a disproportionate percentage of time
  relative to their importance?

## Addendum

Note, when I (Cheek) taught this lesson, I based it 80+% off this lesson plan,
but wound up aggregating our notes in [a different repo](https://gist.github.com/JoshCheek/e4afb1d9e1c2fc72603b)
(it helps me synthesize my thoughts).  So if you're teaching it, you can also reference that repo.
