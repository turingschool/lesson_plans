---
title: Debugging
length: ??
tags: pry, seeing is believing, ag, debugging
---

# REPL Essentials

## Notes

* http://tutorials.jumpstartlab.com/topics/debugging/debugging.html

## Standards

## Structure

## Tools

* [pry](https://github.com/pry/pry) - `gem install pry`
* [ag](https://github.com/ggreer/the_silver_searcher) - `brew install ag`

## Lesson

### 1. Get Feedback

* TDD
* Pry
* Pace your progress with your __feedback__
* It's easy to get in the mindset of "let me just try this 1 more thing" -- don't make blind
stabs in the dark.
* Use your tools to get meaningful feedback to guide each change.

### 2. Verify Assumptions

The most common errors students run into result not from doing something bad,
but from doing a _right_ thing to the wrong type of object.

This is usually a case of invalid assumptions. I thought I had a string but I
actually have an integer. I thought I had an Array of Hashes but I actually have
an Array of Arrays. I thought I had a Pizza but I actually had a ball of Pizza Dough.

To avoid this we need to be extremely disciplined about verifying all of the implicit
assumptions throughout our code.

__How do we verify assumptions?__

* __Tests__ - Diligent tests that cover the input and output for every method
will go a long way to avoid this type of problem.
* __Pry__ - When you run into a seemingly mysterious error, one of your first
reactions should be to pry into the context of the error and check the class of
every object. You may find some surprises.

### 3. Read Stack Traces

Say it again:

__Read Stack Traces__

Once more, with feeling:

__Read Stack Traces__

* Stack Traces -- list all lines of code touched along the path to an exception
* Tell us what the error was and how we got there
* Gives us a file name and line of code to look in

#### How to use a Stack Trace

1. Look for the "top" or "end" of the trace -- generally the error will be one
of the last things that happened (since errors halt execution), so we want to
focus on the most recent lines of our trace, since this is usually where we'll find the problem
2. Look for lines referencing __our__ code. Your average stack trace usually includes
lots of lines that pass through code that isn't ours (ruby internals, gems we're using, etc).
Usually it's our code that is the problem, so try to zero in on those lines.
3. Read the error message 2 times before you go do anything
4. Focus on 2 things: What did we try to do? and To what did we try to do it?

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
