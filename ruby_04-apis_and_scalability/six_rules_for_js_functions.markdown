---
title: Six Rules for Functions in JavaScript
tags: JavaScript, fundamentals, functions
length: 180
---

## Six Rules for Functions in JS

Functions are truly one of the fundamental building blocks for programming in JavaScript.
To newcomers or developers learning JavaScript after another language, the nuances and rules involved
can often be daunting. However it is possible to distill all of these down to a handful of
"guiding principles" which will give you the foundation you need for working with functions
in _most_ situations.

### Goals

* Understand hoisting
* Understand the Arguments array
* Have a general idea of bind(), apply() and call() 

### 1. Functions are Values

This simple fact about JavaScript is also one of its most powerful traits.
To reiterate, functions are one of the primary "types" of things we encounter in JavaScript.
We can pass them around and manipulate them just as we do more familiar data types like
Strings and Numbers.

The ability to work with functions in this way is one of the main reasons JavaScript is often
referred to as a "functional language". You'll often also hear the catchphrase "functions are first-class
citizens."

##### Demonstration: Consider these examples by executing them in your browser console:

```javascript
typeof function() { console.log("hi"); }
```

```javascript
function pizza() { console.log("mmmm"); }
```

```javascript
typeof typeof console.log
```

__What did you find?__

##### Invoking Functions

This may be familiar to you by now, but we (generally) invoke a function by
affixing a pair of parentheses to the end of it.

What's the difference between this:

```javascript
console.log()
```

and this:

```javascript
console.log
```

__Remember:__ Functions are values. If we refer by name to a variable or object property
which stores a function, it will return to us the function value itself -- just as if we
referred to a variable or object property storing a Number or a String.

#### Exercise: Functions that take functions as arguments

On your own, write a function which:

1. Takes another function as its argument
2. Invokes that function
3. Returns that function back

### 2. Functions Can be _Stored_ as Values or _Declared_ With Names

There are 2 basic ways to create a function in JavaScript: a function
__expression__ and a function __declaration__.

#### Function Expressions

Function __expressions__ are how we create function values "on the fly" in JavaScript, similarly
to how typing a series of characters surrounded by "quotation marks" produces a string.

Since, as we said in __Rule 1__, functions are values, we can do all the same things with them
that we do with other data types, including:

__Store them in Variables:__

```javascript
var pizza = function(toppingType) { console.log("MMM, that is a tasty", toppingType, "pizza!"); }
```

__Pass them as arguments to other functions:__

```javascript
[1,2,3].forEach(function(num) { console.log(num * 2); });
```

#### Function Declarations

Function declarations are a slightly more rigid way of declaring functions with explicit
names. For example:

```javascript
function doughType() { return "mmmm whole wheat"; }
```

#### Declarations vs. Expressions -- Why do I care?

There is a subtle difference in how the interpreter evaluates a function expression and a function
declaration. This behavior is generally referred to as __hoisting__, since it effectively "hoists"
declared functions to the top of their containing scope.

__Execute this example in your browser console:__

```javascript
console.log(a());
var a = function() { return "a"; }
```

What happened? Did you get an error? What kind?

__Now try this one:__

```javascript
console.log(b());
function b() { return "b"; }
```

__Sweet function Hoisting Batman! No TypeErrors here!__

For some other mindbending examples, consider this [blog post](https://JavaScriptweblog.wordpress.com/2010/07/06/function-declarations-vs-function-expressions/).

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

In JavaScript, all functions can be passed a variable number
of arguments. In practice, passing the wrong number of arguments often results in an error,
or in additional arguments being ignored. But we can pass them and the function will accept them
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

```javascript
function foo() { console.log(arguments); }
```

What happens when you evaluate:

```javascript
foo("hi");
```

What about:

```javascript
foo("hello", "world")
```

Or:

```javascript
foo();
```

__Variadic Arguments!__

This ability to always handle any number of arguments is partly responsible for the
flexible behaviors of functions like `console.log`. __Consider:__

```javascript
console.log("a", "b");
```

#### Exercise: logString Function

`console.log` is cool, but it simply prints our string to the terminal without returning
it to us. Let's see if we can add our own version which returns the actual string itself.

Define a function which:

* Accepts any number of arguments
* Returns a string of all of those arguments separated by spaces

__Level 2:__

Update your function so that  it accepts

* A "header" value, which is separated from the rest of the output by a newline (`\n`)
* Any number of additional values, which are separated by spaces after the header

### 4. `this` is a special keyword wihtin a function, referring to its context of invocation

__Lo, the dreaded [`this`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this)!__

`this` is a special keyword in JavaScript which, when referenced from within a function body,
refers, roughly, to the "contextual object" from which the function was executed.

There are actually several rules governing the exact precedence of `this` assignment,
which we will cover in more detail in a coming lesson.

For now, we can roughly think of `this` as referring to whichever object the function
we are invoking is currently attached to.

__Consider:__

```javascript
var myFunc = function() { console.log(this); }
```

what does `myFunc()` output?

What if we attach myFunc to an object:

```javascript
var myObj = {func: myFunc, name: "myObj"};
```

What does `myObj.func()` output? Why? What is the behavior of `this` as the function is
attached to different objects?

_note_ - when using "strict mode", these behaviors will behave alightly differently.
In general, strict mode (helpfully) tries to help us avoid accidentally modifying the
global scope. Thus it will often trigger an error when you do so.

#### Exercise: `this`-ness

In your console:

* Define an object called "me" with your own name as a property called `name`
* Add another property to the object called `sayHello`. When invoked, it should
output the string "Hi, my name is <your-name-here>". Use `this` within the function to retrieve
the name value stored on the object.

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

```javascript
typeof (function() { console.log("functions all the way down...")}).call
typeof (function() { console.log("functions all the way down...")}).apply
```

__Or, perhaps more clearly:__

```javascript
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

__[Function.prototype.call](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call)__ takes `N` arguments. The first argument
will be used as the value of `this` within the function. The remaining
arguments will be _passed through_ to the original function, as if they had
been provided as normal arguments.

For example, try this example:

```javascript
var anObject = {aFunction: function() { console.log(this); }, anotherProperty: 'hi there'}
anObject.aFunction();
```

What about this one:

```javascript
var anObject = {aFunction: function() { console.log(this); }, anotherProperty: 'hi there'}
anObject.aFunction.call("a different object");
```

What about other arguments? As mentioned, they are passed through to the original function.
Consider:

```javascript
function foo(arg1, arg2) { console.log(arg1, arg2); }
foo("pizza", "pie");
foo.call(null, "pizza", "pie");
```

Notice that:

* the additional arguments "pizza", and "pie" are passed into the original function
* we pass `null` as a placeholder for the first argument, since in this case we don't
really need to manipulate the function's `this` value

#### Function.prototype.apply

__[Function.prototype.apply](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply)__ is a bit more interesting. Similar to call, its first argument
will be used as the value of `this` within the function.

But for its second argument, `apply` expects actually a _collection_ - generally an Array.
What does it do with the array? Let's experiment to find out:

```javascript
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
-- here JavaScript shows some of its [LISP Heritage](http://c2.com/cgi/wiki?EvalApply).

### 6. Functions, Like Other Values, Can Be Stored As Object Properties

Whooo! That was a sprint! We've learned quite a bit about functions, though.
Now that we're here, what can we do with our newfound knowledge?

Let's close by returning to one of our earlier points, and looking more
specifically at how it can help us better organize and structure our day-to-day
JavaScript code.

Some of our main points before included:

* Functions are values just like other built-in JS types.
* In this vein, functions can be stored as _properties_ on _objects_ as we see fit.

This flexibility to shuffle functions around and organize them as we see fit is
a powerful feature of the language, and it gives us some common patterns for
organizing our code.

Consider your average programmer's JavaScript trajectory, helpfully expressed
in ASCII Art format:

```
                    Oh god now the code is everywhere----->Undefined is not a function----> X(
                    /
                   / 
                 Hey I can write some code
                 /
                /
How do I even JS
```

JavaScript can be very powerful, but it can also get very messy very quickly. A common
painpoint of JS codebases is that they become scattered piles of randomly invoked
and structured statements, often leaking scope over one another and worse.

It's amazing what a little organization can do for these symptoms, and in that vein,
here are 2 dead-simple principles of JS code organization:

1. Put your code in functions. Yes all of it. In a function of some sort.
2. Attach those functions to Objects.

__Done.__ Now you can snicker at other developer's whose JS grows into gnarled piles of
unscoped variables.

This might not get you to JavaScript PhD level, and there are more advanced techniques
we'll discuss in the coming days, but honestly for 80% of web development cases this is
sufficient.

Need to bind some event handlers around your TaskList UI? Sounds like a `TaskList`
object with a `bindEventListeners` property might be for you!

Need to send and receive Task Data from a server via AJAX? Sounds like a `TaskDataService`
with some ajax-y function properties might be for you!

Remember that functions can always be attached as properties of objects:

```javascript
var pizzaOven = {
  makeMeAPizza: function() { return "mmm za"; }
}

pizzaOven.makeMeAPizza();
```

This simple pattern will actually handle a lot of cases.
It can easily be extrapolated to Jquery-intensive code for
dealing with DOM events and manipulations

```javascript
//hypothetical example
var TaskList = {
  taskClicked: function() { console.log("woo task clicked!"); },
  bindEventListeners: function() {
    $(".task").click(this.taskClicked);
  }
}

// one call to set up our code
// as opposed to a bunch of inline Jquery statements
TaskList.bindEventListeners(); 
```

### Recap

Let's briefly summarize some of the major points we've encountered:

1. Functions are first-class values in JavaScript and thanks to this
we can manipulate them in lots of exciting ways
2. Functions in JavaScript can be defined with a _function expression_ or
a _function declaration_, which subtly tweaks their evaluation order
3. Functions in JavaScript always accept variable numbers of arguments
4. `this` is a special keyword in JS which roughly refers to a function's
"invocation context"
5. We generally invoke functions using the `()` syntax, but we can also
use special functions like `call` and `apply` to invoke them in different ways
6. Thanks to the flexibility of functions, we can get a lot of mileage out of
simple organizational idioms -- like attaching them as properties of objects!


### Reference / Related Links

* [`this`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this)
* [`call`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call)
* [`apply`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply)
* [more on JS functions in general](https://github.com/mdn/advanced-js-fundamentals-ck/blob/gh-pages/tutorials/02-functions/01-calling-functions.md)
* [Follow up reading: Functions Chapter in Eloquent javascript](http://eloquentjavascript.net/03_functions.html)
