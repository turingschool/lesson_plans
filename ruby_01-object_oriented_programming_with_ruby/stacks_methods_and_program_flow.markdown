## Stacks, Methods, and Program Flow

__Standards__

* Understand the idea of a Stack as a general-purpos FILO data
structure
* Review standard method and control-flow patterns
* Understand how Ruby uses a stack to model flow-of-control between
methods

## Intro Discussion

* Stack -- a fundamental Data Structure in computer science
* We encountered it in the [Well-Formed Strings](https://github.com/turingschool/challenges/blob/master/well_formed_strings.markdown)
challenge
* There's actually another more ubiquitous application of stacks: managing
flow of execution and context within a computer program
* A Stack vs. __The Stack__ -- The program stack is so omnipresent we often
refer to is as The Stack


Let's kick off with a basic example. Fire up pry and define the following code:

```ruby
def say_hello
  puts "Enter your name and press ENTER:"
  name = gets
  puts "Hello, #{name}"
end
```

What happens when we evaluate the `say_hello` method?

This small example illustrates 2 fundamental rules of program
execution:

1. An outer method is able to "call into" another method, and it will
wait until the inner method completes before continuing its
execution
2. The inner method is able to generate a value and __return__ it back
to the outer method, which can then access and use it.

As we'll see in this lesson, controlling these 2 behaviors is one of the
main jobs of the stack.

## Illustrating the Stack

Recall a few stack fundamentals:

* Stacks are queue-like structures
* Specifically, a stack follows "first-in-last-out" semantics
* This is great for modeling processes that "nest", such
that the inner (or top-most, depending how you look at it) portions
have to complete before the outer/bottom portions
* Important point about a stack: Things on top of the stack cover
or hide things on the bottom -- you can't see or access lower elements
while there is a top element

__Additional Terminology__

* __Frame__ - When discussing the Stack in the context of program
execution, we refer to each "element" on the stack as a Frame.
* __Pushing__ - adding a new element to the top of the stack
* __Popping__ - removing the top element from the stack
* __Winding / Unwinding__ - Synonyms for Pushing / Popping

With these ideas in mind, let's dig into the previous example and illustrate
what's happening.

__Materials__

(Instructor should provide arts & crafts materials)

* Index cards
* Markers or Colored Pencils

__Exercise 1:__

Follow along as instructor illustrates winding and unwinding
the following stack frames:

1. "Main" (outer execution context of our program)
2. `say_hello` - frame for the method we invoked
3. `puts` - frame for ruby's built-in put string method
4. `gets` - frame for ruby's built-in get string method
5. `puts` - frame for ruby's built-in put string method

Question: Do these frames cover all of the interactions in our code snippet?
Why or why not?

__Exercise 2:__

Let's look at a slightly more involved example. Switch back to
your computer, and create a new ruby file `exercise_2.rb`.

Fill it with this code:


```ruby
def display_info_request
  puts "Enter your name and press ENTER:"
end

def get_user_info
  display_info_request
  gets
end

def say_hello
  puts "Hello, " + get_user_info
end

say_hello
```

Now let's model the stack for this example:

1. push `main`
2. push `say_hello`
3. push `get_user_info`
4. push `display_user_info_request`
5. push `puts`
6. pop `puts`
7. pop `display_user_info_request`
8. push `gets`
9. pop `gets`
10. pop `get_user_info`
11. push `puts`
12. pop `puts`
13. pop `say_hello`
14. pop `main`

Let's discuss a few takeaways from this example:

First, we can see that the stack processing for even a handful of lines
of code can involve a lot of steps. The stack is constantly winding up and down
as our program executes.

Second, we can now identify a very concrete system for determining
when a program is __done__ -- what is it?

__Exercise 3:__

Let's look at one last example. There's one particularly interesting
usage of a Stack that we've seen: Recursion.

Fundamentally, recursion uses the stack to manage iterative processes
within a program.

Open a pry session and evaluate this code:

```
def fibonacci(n)
  if (0..1).include?(n)
    n
  else
    fibonacci(n-1) + fibonacci(n-2)
  end
end
```

Try evaluating the method with a few numbers (keep them small if
you don't want to be waiting around for a while). Use a small
input like `5` to keep your process sane. If this goes smoothly,
try a larger input.

__Your Turn__

Now, get with a partner and try to walk through the stack modeling exercise
from before.

Hint 1: We'll probably see a lot of stack frams for the same `fibonacci` method - that's ok.
Hint 2: When evaluating something like an `+` statement, the left side needs
to evaluate fully before the right side starts evaluating

## Part 2 - The Stack and Method Scopes

