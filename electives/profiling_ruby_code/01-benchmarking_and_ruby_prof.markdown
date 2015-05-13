---
title: Measuring Code Time with Benchmark and RubyProf
length: 90
tags: performance, profiling, ruby, benchmarking
---

## Learning Goals

* Understand reasons for profiling code
* Use Benchmark to experiment with performance of built-in objects and code
* Start using ruby-prof to profile more complicated projects
* Assign profiling homework for sales-engine

## Structure

* 5 - Warmup
* 25 - Discuss Profiling in general; Introducing Benchmark
* 5 - Break
* 25 - Pair Work -- Benchmarking Ruby Internals
* 5 - Break
* 25 - Introducing RubyProf
* 5 - Break
* 25 - Pair Work -- RubyProf on an example EventReporter


## Lesson

* Discussion: What does "benchmarking" or "profiling" mean in the
  general case.
* What metrics might we want to profile for an application?
* How do we decide what metrics are most important for our app?

### Poor (wo)man's benchmark: Time.now

* We can always manually benchmark something by assigning current time
  to a variable, running some code, and then comparing start time to new
time
* Can even wrap this in a block if we want to use it a lot.

### Benchmark

[Benchmark](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/benchmark/rdoc/Benchmark.html)

* Nice instrumentation over manual use of Time class
* Allows us to easily run N iterations (why is this important?)
* Built-in for pre-running the Garbage Collector (why is this
  important?)
* Reports multiple time metrics: User time, CPU time, Wall Clock time
* Discussion: what is the difference in these timing metrics?

### Exercise -- Benchmarking Ruby Internals

We don't have to only benchmark our own code. We can learn a lot about
ruby's internals by benchmarking different components. In pry or a simple benchmark script, try benchmarking the following ruby operations. Make sure to run several (usually ~10 is a good amount) iterations to make sure you are getting consistent results.

__Collection Benchmarks__

How does performance change as you add elements by
factors of 10 (10, 100, 1000, 10000, 100000, etc)? Is the time growth linear? Are there any noticeable jumps?

* Array#find
* Hash#fetch
* Array#sort
* Array#[] (accessing array by index)
* Array#map

__String Benchmarks__

* #gsub (try with a large string and a short string)
* Creating a single-quoted string vs a double quoted string
* String interpolation VS concatenation (`"a#{var}b"` vs. `"a" + var +
  "b"`)
* #upcase vs #upcase! (does modification-in-place incur a penalty?)
* #index vs #include?

__File IO__

* Read a file (e.g. `/usr/share/dict/words`)

__Assignments and Allocations__

* Instantiate built-in objects: String, Integer, Array, Hash a string
* Instantiate a class that you create
* Instantiate a Struct
* Instantiate an OpenStruct

__Parsing__

* #to_json -- Dump a hash to json
* JSON.parse -- try this with longer strings to see how the time grows
* YAML.dump -- dump a hash to json
* YAML.parse

### Ruby-Prof

A profiler is a software tool which monitors code being run and reports
statistics on it. Common focuses for profiler are:

* Frequency of method calls (which methods get called the most)
* Time usage
* Memory Usage
* CPU Usage

Ruby-prof is a popular gem for profiling ruby code. It has a lot of
features that can be customized pretty extensively. Let's look at using
it to profile an old friend -- event reporter.


#### PROFILING EVENT REPORTER

```
git clone https://github.com/dglunz/event-reporter.git
cd event-reporter
```

Add ruby-prof to the gemfile:

```
gem "ruby-prof"
bundle
```

Let's add a benchmark task to the rakefile. For now we'll just benchmark
the Test Suite.

in Rakefile:

```
task :benchmark do
  RubyProf.start
  Rake::Task["test"].execute
  result = RubyProf.stop

  printer = RubyProf::MultiPrinter.new(result)
  printer.print(:path => "./tmp", :profile => "profile")
end
```

Before running it, let's create the "tmp" directory where we'll put our
profile reports:

```
mkdir tmp
```

Run the task with:

```
rake benchmark
```

This should generate a bunch of output in "tmp". Let's check it out.

Another cool printer to use is the Dot Printer. This is useful for
generating graphviz output. let's check it out with a new rake task:

In Rakefile:
```
task :benchmark_graph do
  RubyProf.start
  Rake::Task["test"].execute
  result = RubyProf.stop

  printer = RubyProf::DotPrinter.new(result)
  File.open("./tmp/profile.dot", "w") do |f|
    printer.print(f)
  end
end
```

Now run it with `rake benchmark_graph`

this should create 1 more file under tmp, a file called "profile.dot"

".dot" is a format used for modeling graphs. We can use the unix utility
`dot` to transform it into a more readable format like a PDF:

```
dot -T pdf -o ./tmp/profile.pdf ./tmp/profile.dot
```
