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

### Pre-work

* Watch [this video](https://www.youtube.com/watch?v=beqqGIdabrE)

## Section 1 - The "Stack" Data Structure

* Stack -- a fundamental Data Structure in computer science
* Stacks are a type of **Queue**
* Follows "first-in-last-out" semantics
* Important point about a stack: Things on top of the stack cover
or hide things on the bottom -- you can't see or access lower elements
while there is a top element
* Great for modeling processes that "nest", such
that the inner (or top-most, depending how you look at it) portions
have to complete before the outer/bottom portions

Terminology

* __Top__ - Most recently added element (sometimes people will say "bottom" if they are envisioning the stack growing from top down)
* __Pushing__ - adding a new element to the top of the stack
* __Popping__ - removing the top element from the stack

__Exercise (Optional)__

Here's a common programming challenge that lends itself to
an elegant solution with a stack: [Well-Formed Strings](https://github.com/turingschool/challenges/blob/master/well_formed_strings.markdown)

## Section 2 - The "Stack" as Program Execution Model

* Another ubiquitous application of stacks: managing flow of execution and context within a computer program
* A Stack vs. __The Stack__ -- The program stack is so omnipresent we often refer to is as The Stack
* What are Stacks good at? Problems that require nesting or ordered execution
* Programs "nest" from one method call or line of code into another
* Interpreter uses a Stack to model and manage this process

Let's kick off with a basic example. Open pry and execute the following code snippet:

```ruby
def module_one
  puts "projects are:"
  puts projects
  puts "skills are:"
  puts skills
end

def projects
  "enigma, complete me, headcount"
end

def skills
  "problem solving, staying up late"
end

module_one
```

__Discussion:__ What happens when we evaluate this code?

Series of steps:

1. Define each method (ruby evaluates the definitions)
2. Ruby invokes `module_one`
3. `module_one` calls `puts`, passing to it a new string (`"projects are:"`)
4. `module_one` wants to call `puts` again, **but** this time it needs to call `projects`
first in order to get the value to provide to `puts`, so it first calls `projects`
5. `module_one` now calls `puts` again, passing it the value it got from `projects`
6. `module_one` calls `puts` providing the string `"skills are:"`
7. `module_one` calls `skills`
8. `module_one` calls `puts`, passing to it the value it got from `skills`

This small example illustrates 2 fundamental rules of program
execution:

1. An outer method is able to "call into" another method, and it will
wait until the inner method completes before continuing its
execution
2. The inner method is able to generate a value and __return__ it back
to the outer method, which can then access and use it.

## Illustrating the Stack

__Additional Terminology__

* __Frame__ - When discussing the Stack in the context of program
execution, we refer to each "element" on the stack as a Frame.
* __Winding / Unwinding__ - Synonyms for Pushing / Popping

With these ideas in mind, let's dig into the previous example and illustrate
what's happening.

__Materials__

(Instructor should provide arts & crafts materials)

* Index cards
* Markers or Colored Pencils

__Exercise 1:__

Follow along as instructor illustrates winding and unwinding
the stack frames from the previous example.

Use wiki stix or something else sticky to attach index cards to the board
so students can see what's going on.

__Exercise 2:__

Let's look at a slightly more involved example.

**First** define and execute the following code in **pry**.

**Then**, use your index cards to walk through modeling the stack
winding and unwinding

```ruby
def make_pizza
  toss_dough
  add_toppings
  bake
end

def toss_dough
  toss_count = rand(8)
  toss_count.times do |i|
    puts "Toss the dough"
	puts i
  end
end

def add_toppings
  puts "add those tasty anchovies"
end

def bake
  puts "cook it up in the oven"
end

make_pizza
```

Let's discuss a few takeaways from this example:

First, we can see that the stack processing for even a handful of lines
of code can involve a lot of steps. The stack is constantly winding up and down
as our program executes.

Second, we can now identify a very concrete system for determining
when a program is __done__ -- what is it?

__Exercise 2 -- Self Checking__

Fortunately, the inimitable Josh Cheek has made a sweet tool we can use to assess
our stack understanding in this example. Let's try it out. Run the
following steps in your terminal:

```
hub clone JoshCheek/object-model-with-lovisa
cd object-model-with-lovisa
gem install rouge
bin/spelunk examples/cook_pizza.rb
```

This will launch you into a simple interactive ruby program that will
allow you to step through the stack as the program executes.

Use the following keybindings:

* `Return` - step to the next method / line
* `Up Arrow` - go back up the stack one step
* `Down Arrow` - go back down the stack one step

Use `Return` to step through the program. Compare what it shows you
to the examples you had written on your index cards.

## Section 3 - The Stack and Execution Context

In the previous examples we showed the stack managing flow / progress through the program.
But Ruby's stack plays another important role in determining how our
programs get evaluated.

The stack also manages the definition of **local state** as
a program executes. When we say **local state** we really mean 2 things:

1. local variable definitions
2. `self` - i.e. what is the "current" object

__Local Variable Definitions__

* Local variables can be defined anywhere in a ruby program
* Variables are defined within a given "scope"
* Common scopes we encounter: methods and blocks (each creates its own independent scope)
* Passing a method argument creates a new local variable with the name of the argument

__Self__

* `self` is ruby's way to identify the current object
* In reality there are 2 things we need to know about `self`
* 1. What is its __Class__ (since this gives it methods)
* 2. What are its __Instance Variables__ (since this gives it state)

When thinking about how the stack tracks `self`, we'll show this by tracking
self as a reference to a Class and a collection of instance variables

### Exercise: Visualizing the Stack with State Mixed In

Let's use our index cards to look at another example.

This time, we'll use the cards to track 3 things:

1. What is the order of execution (shown by stacking cards)
2. What are the current local variables (list these on each card)
3. What is the current object (`self`) (list this on each card. include the object's Class and any ivars it contains)

```ruby
class Dog
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def chase(cat)
    dog_reaction = "woof"
	cat_reaction = cat.be_chased(self)
	puts dog_reaction
	puts cat_reaction
  end
end

class Cat
  def initialize(breed)
    @breed = breed
  end

  def be_chased(dog)
    puts "oh no being chased by this dog:"
	puts dog.name
	"Meow!"
  end
end

sassy = Cat.new("Siamese")
chance = Dog.new("Chance")
chance.chase(sassy)
```

### Advanced usage: Ruby's `Binding` Class (Optional)

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

### Advanced: Stacks and Recursion (Optional)

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

Get with a partner and try to walk through the stack modeling exercise
from before.

* Hint 1: We'll probably see a lot of stack frams for the same `fibonacci` method - that's ok.
It may help you to number or otherwise label them to keep things straight.
* Hint 2: When evaluating something like an `+` statement, the left side needs
to evaluate fully before the right side starts evaluating

One point goes back to what we mentioned before about program
completion -- exhausting our stack frames tells us we are done,
so nesting multiple frames for a method that is called recursively
is important for tracking the progress of our progarm.
