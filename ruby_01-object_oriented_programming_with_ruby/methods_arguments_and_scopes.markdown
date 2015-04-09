---
title: Methods, Arguments, and Scopes
length: 90
tags: methods, scopes, arguments, ruby
---

# Enumerable Methods

## Standards
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
