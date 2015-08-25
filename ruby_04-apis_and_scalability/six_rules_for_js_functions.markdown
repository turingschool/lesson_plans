---
title: Six Rules for Functions in Javascript
tags: javascript, fundamentals, functions
length: 180
---

## Six Rules for Functions in JS

Functions are truly one of the fundamental building blocks for programming in JavaScript.
To newcomers or developers learning JavaScript after another language, the nuances and rules involved
can often be daunting. However it is possible to distill all of these down to a handful of
"guiding principles" which will give you the foundation you need for working with functions
in _most_ situations.

### 1. Functions are Values

This simple fact about javascript is also one of its most powerful traits.
To reiterate, functions are one of the primary "types" of things we encounter in javascript.
We can pass them around and manipulate them just like the more familiar data types like
Strings and Numbers.

The ability to work with functions in this way is one of the main reasons JavaScript is often
referred to as a "functional language". You'll often also hear the catchphrase "functions are first-class
citizens."

##### Demonstration: Consider these examples by executing them in your browser console:

```
typeof function() { console.log("hi"); }
```

```
function pizza() { console.log("mmmm"); }
```

```
typeof typeof console.log
```

__What did you find?__

##### Invoking Functions

This may be familiar to you by now, but we (generally) invoke a function by
affixing a pair of parentheses to the end of it.

What's the difference in this:

```
console.log()
```

and this:

```
console.log
```

__Remember:__ Functions are values. If we refer by name to a variable or object property
which stores a function, it will return to us the function value itself -- just as if we
referred to a variable or object property storing a Number or a String.

### 2. Functions Can be _Stored_ as Values or _Declared_ With Names

There are 2 basic ways to create a function in javascript: a function
__expression__ and a function __declaration__.

#### Function Expressions

Function __expressions__ are how we create function values "on the fly" in JavaScript, similarly
to how typing a series of characters surrounded by "quotation marks" produces a string.

Since, as we said in __Rule 1__, functions are values, we can do all the same things with them
that we do with other data types, including:

__Store them in Variables:__

```
var pizza = function(toppingType) { console.log("MMM, that is a tasty", toppingType, "pizza!"); }
```

__Pass them as arguments to other functions:__

```
[1,2,3].forEach(function(num) { console.log(num * 2); });
```

#### Function Declarations

Function declarations are a slightly more rigid way of declaring functions with explicit
names. For example:

```
function doughType() { return "mmmm whole wheat"; }
```

#### Declarations vs. Expressions -- Why do I care?

There is a subtle difference in how the interpreter evaluates a function expression and a function
declaration. This behavior is generally referred to as __hoisting__, since it effectively "hoists"
declared functions to the top of their containing scope.

__Execute this example in your browser console:__

```
console.log(a());
var a = function() { return "a"; }
```

What happened? Did you get an error? What kind?

__Now try this one:__

```
console.log(b());
function b() { return "b"; }
```

__Sweet function Hoisting Batman! No TypeErrors here!__

For some other mindbending examples, consider this [blog post](https://javascriptweblog.wordpress.com/2010/07/06/function-declarations-vs-function-expressions/).

#### Discussion: JS Evaluation Process: Variable Declaration vs. Assignments

* JS is actually evaluated in a few distinct "phases"
* One phase declares all variables `var thing`, etc.
* At this time, function declarations are also evaluated
* After this step, execution resumes from the top of a scope and proceeds
linearly. Function expressions are evaluated as they are reached and slotted into
any appropriate variables.

One rough rule of thumb: if a function declaration appears on the right side of an `=` sign,
or surrounded by `()`, it's being declared as a value. Otherwise it is likely a declaration.

### 3. Functions Always Accept a Variable Number of Arguments

That is the gist of it really. In JavaScript, all functions can be passed a variable number
of arguments. In practice, passing the wrong number of arguments often results in an error,
or in additional arguments being ignored. But we can pass them and the function will pass them
nonetheless.

In __Ruby,__ we sometimes define methods like this:

```ruby
def my_method(a, b, *args)
  puts a.inspect
  puts b.inspect
  puts args.inspect
end
my_method("one", "two", "three", "four")
# "one"
# "two"
# ["three", "four"]
```

In JavaScript, this behavior is actually in place _all the time._ So how do we access any
extra arguments?

#### Arguments Array

Within a function, we can refer to a special variable called `arguments`. This object is an array
which stores, in order, all of the arguments that were passed to our function.

Consider this example:

```
function foo() { console.log(arguments); }
```

What happens when you evaluate:

```
foo("hi");
```

What about:

```
foo("hello", "world")
```

Or:

```
foo();
```

__Variadic Arguments!__

This ability to always handle any number of arguments is partly responsible for the
flexible behaviors of functions like `console.log`. __Consider:__

```
console.log("a", "b");
```

#### Exercise: logString Function

`console.log` is cool, but it simply prints our string to the terminal without returning
it to us. Let's see if we can add our own version which returns the actual string itself.

Define a function which:

* Accepts any number of arguments
* Returns a string of all of those arguments separated by spaces

### 4. `this` is a Special Keyword Within a Function, Referring to its Context of Invocation

__Lo, the dreaded `this`!__

`this` is a special keyword in JavaScript which, when referenced from within a function body,
refers, roughly, to the "contextual object" from which the function was executed.

There are actually several rules governing the exact precedence of `this` assignment,
which we will cover in more detail in a coming lesson.

For now, we can roughly think og `this` as referring to whichever object the function
we are invoking is currently attached to.

__Consider:__

```
var myFunc = function() { console.log(this); }
```

what does `myFunc()` output?

What if we attach myFunc to an object:

```
var myObj = {func: myFunc, name: "myObj"};
```

What does `myObj.func()` output? Why? What is the behavior of `this` as the function is
attached to different objects?

_note_ - when using "strict mode", these behaviors will behave alightly differently.
In general, strict mode (helpfully) tries to help us avoid accidentally modifying the
global scope. Thus it will often trigger an error when you do so.

### 5. `call` and `apply` -- 2 Alternate Means of Invoking Functions

Remember how we said we "generally" invoke functions by appending `()` to
them? Well there are also a couple of other ways to invoke a function, 2
of which are the functions `call` and `apply`.

Where do `call` and `apply` live? Well they're actually functions
stored on...functions. Specifically they're functions attached to
the `Function` prototype -- JavaScript's inheritance mechanism which
we'll discuss further in a future lesson.

In short, since these functions are stored on the `Function` prototype,
their behavior is available to all functions that we interact with.

__Try this:__

```
typeof (function() { console.log("functions all the way down...")}).call
typeof (function() { console.log("functions all the way down...")}).apply
```

__Or, perhaps more clearly:__

```
function pizza() { console.log("enough with the functions already"); }
typeof pizza
typeof pizza.call
```

Well, there you have it: functions (like any other object) can have properties
that store values. And since functions (like any other object) are values,
you can store them as a property...even of _another function_!


#### Using Call and Apply

So what do call and apply actually do?

In short they fulfill 2 responsibilities:

1. Explicitly assigning the value of `this` within the function
2. Passing arguments through to the invoked function

The way they do this is a little bit different, so let's take a look.

#### Function.prototype.call

__Function.prototype.call__ takes `N` arguments. The first argument
will be used as the value of `this` within the function. The remaining
arguments will be _passed through_ to the original function, as if they had
been provided as normal arguments.

For example, try this example:

```
var anObject = {aFunction: function() { console.log(this); }, anotherProperty: 'hi there'}
anObject.aFunction();
```

What about this one:

```
var anObject = {aFunction: function() { console.log(this); }, anotherProperty: 'hi there'}
anObject.aFunction.call("a different object");
```

What about other arguments? As mentioned, they are passed through to the original function.
Consider:

```
function foo(arg1, arg2) { console.log(arg1, arg2); }
foo("pizza", "pie");
foo.call(null, "pizza", "pie");
```

Notice that:

* the additional arguments "pizza", and "pie" are passed into the original function
* we pass `null` as a placeholder for the first argument, since in this case we don't
really need to manipulate the function's `this` value

#### Function.prototype.apply

__Function.prototype.apply__ is a bit more interesting. Similar to call, its first argument
will be used as the value of `this` within the function.

But for its second argument, `apply` expects actually a _collection_ - generally an Array.
What does it do with the array? Let's experiment to find out:

```
function myFunc() {
  // remember our friend the arguments array?
  console.log(this);
  console.log("first:", arguments[0]);
  console.log("second:", arguments[1]);
  console.log("third:", arguments[2]);
}

//try this:

myFunc(1,2,3);

// and what about this:

myFunc.apply("this arg", [1,2,3]);
```

__Discussion: What happens with apply?__

In short, apply allows us to "flatten out" a collection of
values against the argument list of a function. More specifically,
it allows us to "apply" the function over the "list" of arguments provided
-- here javascript shows some of its [LISP Heritage](http://c2.com/cgi/wiki?EvalApply).

### 6. Functions, Like Other Values, Can Be Stored As Object Properties

Rules

1. Functions are values
2. Functions can be stored as the value of a variable _or_ declared as a named function
3. Functions can always take a __variable number of arguments__ -- Within a function, `arguments` is a special variable which stores a collection of all the
arguments passed to the function
4. `this` is a special keyword for referring to a function's "context"
5. Call and Apply provide an alternate mechanism for invoking a function, each with its own
rules.
6. Functions, like any other value, can be stored as properties on objects. We sometimes
refer to a function stored as a property as a "method".

Functions in JS

- Anonymous vs. Named functions (hoisting)
- retrieving function values vs. calling functions
- Arguments array and variadic arguments
- Apply
- Call/Bind
- Methods / Functions as Object properties; using objects to organize JS functions
