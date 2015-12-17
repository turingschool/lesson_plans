---
title: Frames, Call Stacks, and Exceptions
length: 90
tags: Stack Frames, Call Stacks, Exceptions
---

## Learning Goals

* Ideally I'd like them to:
  * Learn the heuristics I use to understand exceptions.
  * Develop an intuition for code, based on "what would explain this?"
* Realistically:
  * they need the mechanics of how exceptions work before we can talk about things like that.
  * Understand:
    * What exceptions are
    * What they are for
    * How they change the flow of the interpreter ("bubbles" up the callstack until it finds a rescue/ensure)
    * How to rescue an exception
    * Basic exception hierarchy, and how rescuing a superclass rescues that instance
    * Multiple rescue blocks
    * `ensure` keyword
    * Rescuing within a method or a `begin`/`end` block
    * How to make their own exceptions

## Material

https://github.com/JoshCheek/lesson-exceptions

## Stuff that wasn't part of the lesson, but I wish it was

Hugs: https://github.com/JoshCheek/what-we-ve-got-here-is-an-error-to-communicate

Heuristics:

```
NameError
  When you get this vs a NoMethodError
  All the normal NoMethodError stuff
  local var is misspelled
  should be an ivar
  Misspelling the name of a constant
RuntimeError
  `raise "zomg"`
NoMethodError
  Method is misspelled
  Method is private
  Wrong object
    The method name often lets us know we have the wrong type of object
    have to identify that the issue is that we got confused about what the type is.
    Called a method like `map` on an object that is not an array,
    Called gsub on a nonString
    Calling [] on a non Hash/Array
    Maybe drill in the difference between plural and singular
  On nil
    Misspelled ivar
    Precondition not met
      other method was supposed to be called first
      block was not called
    got overwritten to nil
    Calling the ivar instead of the method that lazily initializes it
    Returning nil instead of correct null object (eg empty array)
    Hash key that is not present
    set a local var instead of invoking the setter
LoadError
  Missing a gem
  Or the $LOAD_PATH is wrong
  Otherwise, maybe its a file that they haven't made yet, in which case, we can't really know that
  Or could be a file that they renamed, but that's a lot harder to check for (ie either track files we've seen or read their git/svn/whatever history, which sounds difficult and fragile)
  If its in their current project, then they probably got the require path wrong (common one I see among noobs is require "./whatever" and then they run that from different directories)
SyntaxError
  Missing a do/end
  Using a binary search
  ruby -c filename.rb
Errno::ENOENT
  Path is wrong
  Name is wrong
  We are in an unexpected location on the file path
  `-e:1:in `read': No such file or directory @ rb_sysopen - zomg (Errno::ENOENT)`
  `  from -e:1:in `<main>'`
SystemStackError
  missing a base case for recursion
TypeError "not a module/class"
  reopening a class or module as the other one
ArgumentError "wrong number of arguments"
  Look at the last two lines of the backtrace to see what it expected vs what you gave it
```
