--- 
title: Debugging
length: 60
tags: pry, ag, debugging
---

## Goals

* Install tools to help support our debugging process.
* Understand how to use feedback, verify assumptions and read stack traces.

## Tools

To start, we need to make sure we have the appropriate tooling installed.

* [pry](https://github.com/pry/pry) - `gem install pry`
* [ag](https://github.com/ggreer/the_silver_searcher) - `brew install ag`


## Lesson

### Get Feedback

What do you think are some of the methods or tools that we have that we can use
in order to get feedback from our code? 

* TDD
* Pry
* Puts Driven Development

We want to pace our progress with the feedback that we are getting from our
code.  It is critically important that we let our feedback where we are going 
with our code. It is very easy to get into the mindset of, "let me just try
this one more thing." Don't make blind stabs in the dark. That's what we do with
CSS. (Kidding.)

The important thing here is that we need to use all of the tools at our 
disposal in order to get meaningful feedback to guide each change that we make.

Let's look at some code.

```
class Mather
  def initialize(num)
    @num = num
  end

  def calculate
    if @num == 0
      "that's a negative ghost rider, the pattern is full"
    else
      doubled = doubler(@num)
      squared = squarer(doubled)
      return squared
    end
  end

  def doubler(number)
    puts "I'm a doublin!"
    number * 2
  end
  
  def squarer(number)
    puts "I'm a squarin!"
    number * number
  end
end

mather = Mather.new(4)
puts mather.calculate
```

### Verify Assumptions

The most common errors that students encounter run into don't come from doing
something bad, but doing something right, to the wrong thing.

This is what it means often to have a case of invalid assumptions. I thought
that I had a String, but I actually had an Integer. I thought I had an Array of
Hashes, but I actually had an Array of Arrays.

To avoid this, we need to be extremely disciplined about verifying all of the
implicit assumptions throughout our code.

```
class Mather
  def initialize(num)
    @num = num
  end

  def calculate
    if @num == 0
      "that's a negative ghost rider, the pattern is full"
    else
      doubled = doubler(@num)
      squared = squarer(doubled)
      return squared
    end
  end

  def doubler(number)
    puts "I'm a doublin!"
    [number * 2]
  end
  
  def squarer(number)
    puts "I'm a squarin!"
    number * number
  end
end

mather = Mather.new(4)
puts mather.calculate
```

### Read Stack Traces

A Stack Trace is a list of all the lines of code that were touched along the 
way to an error. It tells us what the error was and how we got there. It also
gives us a file name and a line of code to look in.

#### How to use a Stack Trace

1. Look for the top or end of the trace - the error will generally be one of 
the last things that happened because the last thing that happened will halt 
your code, so we want to look at the most recent lines of our code. This is
where we will find the problem.
2. Look for the lines that refer to the code that we've written. Your stack 
trace will include lines that go through code that isn't ours - things like 
the internals of Ruby, and gems, etc.  VERY rarely is the problem in code that 
you have written, namely Ruby itself or any Gems you may be using such as 
Minitest. It's you, not the code. Focus on the code you've written.
3. Read the error message twice before doing anything.
4. Focus on two things, what did we try to do and to what did we try to do it? 

For example:

```
NoMethodError: undefined method `+' for nil:NilClass
```

A diligent reading of this error message will tell me 2 things
off the bat:

1. we tried to add something to an object
2. that object was `nil`, which does not support adding to it

This information, in combination with the line number where the error
occurred, allows me to go directly to that place in the file
and start looking for anywhere I'm adding 2 things. Likely one
of them will turn out to be `nil`.

Using the stack trace effectively allows me to go directly
to the source of the problem, as opposed to reading random lines
of code hoping that the problem will jump out at me.


### 4. Tracing Values Through Code

This is often the next step after we've "diagnosed" one
of the problems above.

For example, I had an __assumption__ about one of my objects --
that it would be an Array of hashes each containing a key of `:name`.

Thanks to an error message and some pry-poking, I conclude that this
assumption is incorrect -- my object is actually an Array of strings,
and thus doesn't work correctly in the context I'm trying to use it.

My next step is to figure out __how__ did the object end up in
this state. This requires a bit of mental exercise to trace the
object through the path it followed before it reached the site of
the error.

I sometimes think of this as filling in a mental "checklist" --
start from the location of your error and work backwards through
each line that touched your object before it got there.

At each line, ask yourself: "What is the type of the object at this
point and what is its value?"

More often than not this process will lead you to a point where
the mistake is obvious -- "Oh darn I accidentally turned each hash
into a string at this line...", etc.


## Exercise - Erroneous Creatures

Let's get some practice using these techniques.
Clone this [Erroneous Creatures](https://github.com/turingschool-examples/erroneous_creatures)
repository.

It contains some implementations of the Mythical Creatures exercises
that are riddled with small bugs.

Use the debugging techniques discussed above to diagnose and fix the
bugs, and get your creatures back to passing.

### Addenda / More Material

* http://tutorials.jumpstartlab.com/topics/debugging/debugging.html