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

### 2. Functions Can be _Stored_ in Variables or _Declared_ With Names


### 3. Functions Always Accept a Variable Number of Arguments

### 4. `this` is a Special Keyword Within a Function, Referring to its Context of Invocation

### 5. `call` and `apply` Give us 2 Alternate Means of Invoking Functions

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
