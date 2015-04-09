---
title: Methods, Arguments, and Scopes
length: 180
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




