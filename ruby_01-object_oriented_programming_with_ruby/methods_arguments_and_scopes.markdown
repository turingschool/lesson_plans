---
title: Methods, Arguments, and Scopes
length: 90
tags: methods, scopes, arguments, ruby
---

## Goals

By the end of this lesson,  you will know/be able to:

  * understand that methods generate a new local scope
  * understand how a method "binds" its arguments within its scope
  * recognize the difference between a bound and an unbound variable
  * understand that instance methods remain in scope to other methods
    within a class
  * understand that local variables within a method will override
    variables/methods of the same name in outer scopes
  * understand the idea of a top-level "global" scope where code will
    execute by default

## Concepts
  * A scope represents a local "environment" where code can be executed
  * Scopes recognize the names of variables or methods which are defined
    in them and can translate these names back to their appropriate
    values
  * Scopes can be "nested," and in the case of a nested scope, the
    closest definition of a given name will always take precedence
  * Several things in ruby create new local scopes -- methods, blocks,
    classes/modules, and instances are the main ones we encounter

### Structure

* Global Scope
* Scope Methods and Arguments
* Methods Accessing Other Methods
* Break
* What About Blocks?
* Blocks with overlapping Inner/Outer variables
* Break
* Defining Classes and Instantiating Them
* Classes Can Have Methods Too
* Referring to the Current Object
* Instance Methods with Arguments
* Using Method Values as arguments to other methods
* Argument Names are Arbitrary
* Default Argument Values
* Other Methods Can Be Used as Default Values


## Group Discussion / Walkthrough

#### Step 1: Global scope

Let's start with the most basic code structure we could look at in ruby
— a single file with some statements executing in top-level scope.

Create a file called `global_scope.rb` on your machine:

```
touch global_scope.rb
```

Open the file in your text editor so we can work on it.

Let's add some very basic code:

```
  x = 10
  puts "x is #{x}"
  x += 20
  puts "x is #{x}"
```

[diff](https://github.com/worace/scope-examples/commit/99bd90b6421369aebe941e318f8fc2eaaaa3def5)

Before running the file, state briefly in your head what output you
expect to see. Then run the file (`ruby global_scope.rb`) and see if
your expectations were correct.

In this trivial example `x` is functioning as a local variable. So far
we have not added any methods, classes, blocks, or other structures that
would create additional scopes, so we might say that `x` is currently
defined in the "global" or top-level scope.

__Methods in Global Scope__

While we most often define methods on objects in ruby, we can define
them in the global scope as well, just as we defined the local variable
`x` in the example above.

#### Step 2: Method Scopes and Arguments

Let's add some lines to the bottom of `global_scope.rb`:

```
  def print_doubled_value(x)
    puts "double the value #{x} is #{x * 2}"
  end

  print_doubled_value(x)
```

[diff](https://github.com/worace/scope-examples/commit/f56f9de91d717e0ba0b3d3033060fc85c589b7ac)

Again, consider what you expect this code to do, and then run it.

So far so good — we can probably guess pretty easily how this example will
behave.

Let's add another example using the new `print_doubled_value` method:

```
  y = 27
  print_doubled_value(y)
```

[diff](https://github.com/worace/scope-examples/commit/e32ef8a58454a1dcde2ee8fe81f07a0096c5fef1)

Does this code behave as you expect? Consider the 2 uses of the variable
`x` in our current example — we have a variable called `x` in the top
level scope which begins as `10` and is then incremented to `30`.

But inside of the `print_doubled_value` method, we see another usage of `x`,
this one apparently changing each time the method is called.

This illustrates one of the important behaviors of methods in ruby --
they create new scopes with an independent set of variables from
whatever scope surrounds the method.

In this case the `x` which appears in the definition of our method
(`def print_doubled_value(x)`) is an __argument__ to the method,
and as such it becomes a new local variable available within the
scope of the method.

To get fancy, we might say that the variable `x` is _bound_ by the
method `print_doubled_value` -- other definitions of variables named `x`
may exist, but within `print_doubled_value` they are irrelevant, since
the method's own definition of this variable supersedes any other
definitions.

Enough theory, let's look at another example. Redefine
`print_doubled_value` and call it like so:

```
def print_doubled_value(x)
  orig = x
  x = x * 2
  puts "double the value #{orig} is #{x}"
  puts "inner x is now: #{x}"
end

print_doubled_value(x)
puts "outer x is still: #{x}"
```

[diff](https://github.com/worace/scope-examples/commit/7fb472bd5257e3fc2e360201eeab1145069a96a9)

What output do you expect from this code? Think especially about the
output about "inner" and "outer" values of x:

`inner x is now: ??`

`outer x is still: ??`

We can see from this example that modifying the value of `x` inside of
the method has no effect on the value of `x` outside of the method.

This behavior holds true even when (as in this example) the outer
variable and the inner (method) variable _have the same name_!

The method's variable of the name `x` is completely independent of the
global scope's method of the name `x`, so any modifications we make
within the method have no effect on the outer variable.

Let's consider another example. Add a new `combine_variables` method to
your file:

```
a = 4
b = 12
def combine_variables(x)
  puts "inner x is: #{x}"
  puts "and outer b is: #{b}"
end
combine_variables(a)
```

[diff](https://github.com/worace/scope-examples/commit/93c89cb3b11b45032638669c420308544f6aa37c)

How does this code match your expectations?

We might have expected some output like:

```
inner x is: 4
and outer b is: 12
```

But what actually happens? We should get an error similar to:

```
global_scope.rb:29:in `combine_variables': undefined local variable or method `b' for main:Object (NameError)
	from global_scope.rb:31:in `<main>'
```

What does this error show us about method scopes?

Not only do they have independent versions of any variables that might
have existed in their parent scope, but they can't even access other
variables from the parent scope.

This can be a common source of confusion when you're new to ruby so make
a note: method's __can't__ access local variables in their parent scope.

#### Step 3: Methods Accessing Other Methods

So what can methods access? Let's replace the code from our last
iteration with a new version which actually works:

```
def combine_variables(x)
  puts "inner x is: #{x}"
  puts "and outer b is: #{b}"
end

def b
  12
end

a = 4
combine_variables(a)
```
[diff](https://github.com/worace/scope-examples/commit/ab96fbdb5842489391f0b6cd582fdb20d8d7b75d)

Why does this version work when the other did not?

While a method can't access local variables defined in its parent scope,
it _can_ access other methods defined in that scope.

We might think of these methods as "siblings" -- since they are created
at the same level in our code, they can reference one another freely.

But don't forget that local variables within the method always take
precedence.

Let's modify our `combine_variables` method to look like so:

```
def combine_variables(x)
  puts "inner x is: #{x}"
  puts "and outer b is: #{b}"
  b = "pizza"
  puts "but now b is: #{b}"
end
```

[diff](https://github.com/worace/scope-examples/commit/408fa7e3d0028a0423357354596f78a393ee3a5c)

What happens to `b` during the course of this method? We can see that at
first it refers to the method `b`; after we create a new local variable
of the same name, however, `b` refers to that instead.

When trying to determine what value a variable refers to, a method will
always look first for a local variable, and only if one is not found
will it attempt to look for another method of that name.


#### Check for Understanding

* When a variable is defined outside of any classes, what scope would we say that it is in?
* Why are local variables when defined in a method, no accessible to other scopes?
* When are methods siblings? What does being a sibling allow them to do?

#### Step 4: What about blocks?

We saw earlier that methods create new scopes which lack the ability to
reference local variables in their parent scope. But methods aren't the
only things that can create scopes.

Another common way that we create new scopes in ruby is by using blocks.
You've seen blocks many times by now, especially when using enumerables:

```
[1,2,3].each { |num| puts "num is #{num}" }
num is 1
num is 2
num is 3
=> [1,2,3]
```

Note that the `num` block variable functions very similarly to a method
argument — each time the block is executed, a new value will be supplied
for `num`

Do blocks have the same behavior when it comes to scopes and arguments?
Let's find out. Add some more code to the bottom of our `global_scopes.rb` file:

(this file is starting to get a bit messy, but such is the price of
learning)

```
creatures = ["IndustrialRaverMonkey", "DwarvenAngel", "TeethDeer"]
hero = "Dwemthy"

def battling_technique
  ["heroically", "clumsily", "cleverly"].sample
end

creatures.each do |c|
  puts "#{hero} battles #{c} #{battling_technique}"
end
```

[diff](https://github.com/worace/scope-examples/commit/565a23d6c6a87649a0aeed38d99841be8aa83ed4)

There are quite a few pieces in play here — 2 local variables, a method,
and a block variable! What output do you think it will produce?

Holy cavorting closures batman! Unlike the method example we saw before,
which blew up when trying to refer to an adjacent local variable, this
code works just fine.

This is due to the ability of blocks to create what is called a
"closure." Unlike a method scope, which captures its arguments but
ignores surrounding local variables, a closure "closes over" those
variables and allows them to be referenced from the inner scope.

But how do blocks handle collisions between variables? Let's try an
example. More code!

#### Step 5: Blocks with overlapping inner/outer variables

```
new_creatures = ["IntrepidDecomposedCyclist", "Dragon"]
villain = "AssistantViceTentacleAndOmbudsman"
hero = "who knows"

new_creatures.each do |villain|
  hero = "Dwemthy"
  puts "this time the villain is #{villain} and the hero is #{hero}"
end
```

[diff](https://github.com/worace/scope-examples/commit/2b6505e840553e683daac0d6b8abc9c536d73160)

What happens to our variables each time the block is executed?
Especially of interest in this example are the `villain` and `hero`
variables.

In this case we see that the block variable `villain` "shadows" the
outer variable of the same name within the block. But what happens to
`villain` after the block is done?

And what about `hero`? How does it change during the execution of the
block?

The ability of blocks to refer to surrounding local variables is
powerful, but it can also be potentially dangerous. We should to pay close
attention to what variables we modify within a block to avoid
accidentally modifying the wrong thing.

#### Check for Understanding

* What is a closure? How do blocks handle variable naming collisions?
* What is the danger in blocks being able to access surrounding local variables?

## Part 2: Classes and Objects

Let's look at some more examples to see how these same principles apply
to scopes within objects.

#### Step 1: Defining classes and instantiating them

Create a new file called `object_scopes.rb` and add some code to it:

```
class PizzaOven
end

oven = PizzaOven.new
puts "cookin pizza in the oven: #{oven}"
```

[diff](https://github.com/worace/scope-examples/commit/c084df3520a4e58b6743ec7ac4458710aa93568b)

By now we're hopefully getting somewhat comfortable with defining
classes and creating objects, so we can probably predict what output
this code will produce:

```
cookin pizza in the oven: #<PizzaOven:0x007fe7da9de418>
```

We've just created a new instance of the `PizzaOven` class and output a
description of it by "interpolating" it into a string. By the way —
where does this strange ` #<PizzaOven:0x007fe7da9de418>` output come
from?

#### Step 2: Classes can have methods too

As we've seen, we can add methods to this class. Let's cook some 'za.
Add a `cook` method to our PizzaOven class so our file reads like this:

```
class PizzaOven
  def cook
    puts "cookin pizza in the oven: #{oven}"
  end
end

oven = PizzaOven.new
oven.cook
```

[diff](https://github.com/worace/scope-examples/commit/3b00fd75c01a84561c6491fdcdec151b07cba4a9)

What's going to happen when we run this? We'd probably like to see the
same output as before (`cookin pizza in the oven: #<PizzaOven:0x007fe7da9de418>`).

But in fact we get an error. What happened to the `oven` local variable
— consider why it's no longer in scope.

#### Step 3: Referring to the current object

Our problem is that we moved the code for printing our cookin statement
_inside_ of the object. We can still access the `oven` object if we
want, but the way to do so is different. We need to use a special method
called `self`.

Let's tweak our `cook` method to use `self` so we can still output the
info about our oven:

```
class PizzaOven
  def cook
    puts "cookin pizza in the oven: #{self}"
  end
end

oven = PizzaOven.new
oven.cook
```

[diff](https://github.com/worace/scope-examples/commit/03aaae77046ceb6ae4e2d27299522752f57c8dc3)

In ruby, the method `self` will always refer to the _current object_;
that is, the object inside of which your code is currently executing.

In our case, we have created a class `PizzaOven`, defined an _instance
variable_ `cook`, and called that method on an instance of `PizzaOven`.
At the moment when we hit the `puts` statement inside of the cook
method, `self`, then, will refer to the _current_ `PizzaOven` — the
specific oven on which the `cook` method was called.


#### Check for Understanding

* What happens when we simply try to puts an object?
* How can an instance of a class refer to itself?
* What is an instance method?

#### Step 4: Instance methods with arguments

Let's look at adding some more methods to our class, this time using
arguments to customize the behavior.

Let's add a `temperature` and `crust_type` method and have cook use them
to determine what we're cooking:

```
class PizzaOven
  def cook(temp, crust_type)
    puts "mmm, mmm. cookin #{crust_type} pizza in the oven at #{temp}"
  end

  def temp
    "400 degrees F"
  end

  def crust_type
    "New Haven Style"
  end
end

oven = PizzaOven.new
oven.cook("100 degrees F", "Digiorno")
```

[diff](https://github.com/worace/scope-examples/commit/8da19dadabb04b354409bb0eb42169bdb28d5ac9)

Did this produce the output you expected?

We might have expected to see `mmm, mmm. cookin New Haven Style pizza in the oven at 400 degrees F`
— after all, our `PizzaOven` has a `temp` method ("400 degrees F") and
`crust_type` method ("New Haven Style").

But remember that method arguments exist only as local variables defined within the scope of the method.
Even if a method's arguments happen to have the same name as another
method on the same object (in this case an instance of `PizzaOven`), the
two definitions are completely independent of one another.

#### Step 5: Using method values as arguments to other methods

Consider another example. Change the code at the bottom of your file to
read:

```
oven.cook(oven.temp, oven.crust_type)
```

[diff](https://github.com/worace/scope-examples/commit/327ab68aaf940b69290a728abdbbedc6be625ee8)

Output:

```
mmm, mmm. cookin New Haven Style pizza in the oven at 400 degrees F
```

Tasty.

Now we've fixed our problem by explicitly passing in the values from the
appropriate `PizzaOven` methods into the oven's `cook` method.

But remember: the fact that the names match in this instance is
irrelevant to the execution of the code. When the interpreter evaluates
`oven.temp` and `oven.crust_type` in the last line of the file, it gives
no consideration to the fact that the method `cook` uses those same
names for its arguments.

#### Step 6: Method argument names are arbitrary

To hopefully drive home the lack of connection between the 2 sides of
calling a method (values being input vs. values being consumed), let's
tweak our code once more:

```
oven.cook(oven.crust_type, oven.temp)
```

[diff](https://github.com/worace/scope-examples/commit/adf91fc0d22d1ffc18d16b5a04533cb815db1cef)

What will this code output? Our values are backwards! Again, the `oven.crust_type` and `oven.temp`
which we are passing __in__ to the method are evaluated in a completely
different context from. So something we call `crust_type` before passing
it into the method can just as easily be called `temp` _inside_ of the
method. The 2 scopes are independent

#### Step 6: Default argument values

We can also assign what we call "default" values for a method. This
technique is often used to allow a method to be called without an
argument in most cases, but still accept a method whenever necessary.

Let's add some defaults for our `cook` method:

```
class PizzaOven
  def cook(temp = "425 F", crust_type = "Deep Dish")
    puts "mmm, mmm. cookin #{crust_type} pizza in the oven at #{temp}"
  end

  def temp
    "400 degrees F"
  end

  def crust_type
    "New Haven Style"
  end
end

oven = PizzaOven.new
oven.cook
oven.cook(oven.temp, oven.crust_type)
```

[diff](https://github.com/worace/scope-examples/commit/a52eac0c32428b2235f7bc417282f5e21e19c4ca)

How does the `cook` method behave differently between these 2
invocations? Notice that the default arguments only get applied in the
case that no argument is provided. Since we first called `cook` with no
arguments, ruby will pull in the "defaults" of `425 F` for `temp` and
`Deep Dish` for `crust_type`.


#### Check for Understanding

* Does it matter what we name our arguments? Why?
* How do we use default argument values?

#### Step 7: Other methods can be used as default values

Let's look at one more potentially confusing example. Currently we're
providing static data for our default arguments in the `cook` method
(the string `"425 F"` and the string `"Deep Dish"`).

We could actually use other methods as the default arguments if we so desired.

Let's change our code to read like so:

```
class PizzaOven
  def cook(temp = temp, crust_type = crust_type)
    puts "mmm, mmm. cookin #{crust_type} pizza in the oven at #{temp}"
  end

  def temp
    "400 degrees F"
  end

  def crust_type
    "New Haven Style"
  end
end

oven = PizzaOven.new
oven.cook
oven.cook(oven.temp, oven.crust_type)
```

[diff](https://github.com/worace/scope-examples/commit/812ccf0f5a94f02f78fa6f2535570f4fae8e6185)

__WAT__?

What will we see when we run this? In fact, it will produce the same
output both times.

How does ruby allow this? How can we define the method-local variable
`temp` in terms of itself?

Well it turns out we're not actually defining `temp` in terms of itself.
When we perform a variable assignment, there are slightly different
rules for what happens on the left side vs. the right side of the
assignment.

For the left, we're creating a new local variable -- pretty much always.

For the right, we're __looking__ for a value named `temp`, and to find
it we'll follow the same "lookup chain" we mentioned before — look for a
local variable called `temp`; if it doesn't exist, continue up the chain
and look for an instance method called `temp. In this case we'll find
one (instance variable `temp`) and use it!


### Video

[Video](https://vimeo.com/129376008)
