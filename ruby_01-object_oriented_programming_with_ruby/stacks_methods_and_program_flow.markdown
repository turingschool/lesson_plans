## Stacks, Methods, and Program Flow

__Standards__

* Understand the idea of a Stack as a general-purpose FILO data
structure
* Review the standard method and control-flow patterns we've encountered
in programs
* Understand how Ruby uses a stack to model flow-of-control between
methods
* Understant how Ruby's stack and bindings collaborate to control
local scope

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

```pry
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

* Hint 1: We'll probably see a lot of stack frams for the same `fibonacci` method - that's ok.
It may help you to number or otherwise label them to keep things straight.
* Hint 2: When evaluating something like an `+` statement, the left side needs
to evaluate fully before the right side starts evaluating

## Part 2 - The Stack, Method Scopes, and Return Values

In the previous example (modeling the stack behavior of fibonacci), what
did your stack look like? Probably you had a ton of different stack frames
for the `fibonacci` method, with some calls to `include?` and `+`
thrown into the mix here and there.

If this is the case, what's the value of adding different stack
"frames" for each recursive call into the same `fibonacci` method?

One point goes back to what we mentioned before about program
completion -- exhausting our stack frames tells us we are done,
so nesting multiple frames for a method that is called recursively
is important for tracking the progress of our progarm.

But looking at the numerous nested fibonacci frames exposes another
important role that the Stack plays in our program: Managing local
state.

__Discussion: Stack as the location for storing "local" state__

When looking at our recursive fibonacci stack, we saw:

* Different calls could be distinguished by different values
of the `n` parameter
* Each call could kick off another call after modifying `n`
* Within each frame, we would have to wait for any nested frames
to complete, and _temporarily store their value_ to reuse in another
computation.

* Each stack frame provides a new local "context" (i.e. _scope_)
* The ability to redefine and store temporary values within
this scope allows us to get useful behaviors like variable shadowing
* Our previous Index Card stack modeling only covers part of the
picture
* We need to also envision the local scope provided by each stack frame
to complete the metaphor

### Ruby's `Binding` Class

The role of managing local scope and variable lookup is partly
managed by ruby's `Binding` class. What is a binding?

* `Binding` is a class
* `Binding` is ruby's abstraction around local scopes within programs
* `Binding` unifys 2 key ideas: `local_variables` and a `self` reference
* We can retrieve the current one using the special `binding` method

Try the following examples in pry. We're going to illustrate 3 points:

* `binding` stores local variables
* `binding` can evaluate values within its context using `eval`
* `binding` stores a reference to the current `self` context

```ruby
[1] pry(main)> binding
=> #<Binding:0x007f86dd9c61c8>
[2] pry(main)> binding.class
=> Binding
```

```ruby
pry(main)> binding.local_variables
=> [:__, :_, :_dir_, :_file_, :_ex_, :_pry_, :_out_, :_in_]
pry(main)> x = 10
=> 10
pry(main)> a = "pizza"
=> "pizza"
pry(main)> binding.local_variables
=> [:a, :x, :__, :_, :_dir_, :_file_, :_ex_, :_pry_, :_out_, :_in_]
pry(main)> binding.eval("a")
=> "pizza"
pry(main)> binding.eval("x")
=> 10
```

```ruby
pry(main)> binding.eval("self")
=> main
pry(main)> @a = "calzone"
pry(main)> binding.instance_variables
=> []
pry(main)> binding.eval("self").instance_variables
=> [:@pizza, :@a]
```

__Discussion:__

* What is the distinction between instance variables and local variables?
* What role does a binding's `self` reference play in the evaluation of data?

Let's try a more complicated example using multiple objects with independent
bindings:

```ruby
class Dog
  def initialize(name)
    @name = name
  end

  def chase(cat)
    dog_local = "woof"
    puts "chase self: #{binding.eval("self")}"
    puts "chase self ivars: #{binding.eval("self").instance_variables}"
    puts "chase locals: #{binding.local_variables}"
	meow = cat.be_chased(self)
    puts "self: #{binding.eval("self")}"
    puts "locals: #{binding.local_variables}"
  end
end

class Cat
  def initialize(breed)
    @breed = breed
  end

  def be_chased(dog)
    puts "be_chased self: #{binding.eval("self")}"
    puts "be_chased self ivars: #{binding.eval("self").instance_variables}"
    puts "chase locals: #{binding.local_variables}"
    puts "be_chased self: #{binding.eval("self")}"
	"Meow!"
  end
end

Dog.new("fido").chase(Cat.new("siamese"))
```

* What do you see from running this example?
* What can we infer about ruby's handling of local bindings based
on these examples?
* Within the `Dog#chase` method, we created a local variable
`meow`. How did we obtain the value that we inserted into `meow`?

### Putting it all together

* The internal call stack manages the flow of execution
through our programs
* The stack also manages the tracking of local state and the
current `self` references. Ruby's `Binding` class provides an
abstraction around this

Now, let's put it all together by revisiting the exercises from
above and tracking the local state associated with the stack at each
point.

* __1:__ Use index cards to model the stack from the Cat/Dog example
above. This time on each card also track what local variables are
attached to each binding, and what the `self` reference is
* __2:__ Repeat the same process for the fibonacci example from before

### Notes for next time

* Did this lesson for the first time on 10/28 as a 90 minute lesson.
Material should be cut or else extended to 180 minutes.
Did not have time to cover everything adequately, and ended up
cutting several of the student exercises.
* Possibly could be 2 separate lessons, 1 on stack with respect
to order of execution and nesting and on 1 on stack with respect
to local scopes / binding
* The string concatenation and interpolation methods are
confusing examples; would be nice to pick methods that have
more obvious explicit receivers
* When demoing the stack exercises, it would be good to stick the cards on the board
somehow (tape? sticky putty? wiki stix?) so that students can see.
