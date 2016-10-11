---
title: Object Oriented Javascript
length: 150
tags: javascript, object oriented programming, prototypes
---

## Object-Oriented Javascript

In this lesson, we'll discuss some of the common techniques
and idioms for writing Javascript in an object-oriented style.

### Goals:

* Understand the prototype mechanism in javascript
* Learn how to create new objects ad-hoc using `Object.create`
* Learn how object property queries are passed up the prototype chain
* See how constructor functions give us some nicer support around this
  behavior
* Discuss some of the pros and cons of OOP in javascript


### Object Basics in Javascript

* Object literals -- our ad-hoc way of creating objects in JS
* Behaves somewhat like a Map or Hash in other languages, but has
some additional features layered on top
* We can set properties on an object as needed, and they will be
specific to that object

### Prototypes

Prototypes are Javascript's main mechanism for sharing behavior
across similar objects. That is, we have a function, and would like
it to be accessible across all objects of a given type

We can find out what the prototype of a given object using
`Object.getPrototypeOf`

__Try it__

Check the prototype of these objects:

* `"pizza"`
* `1234`
* `{}`

In short, any function defined on an object is also available to
any object of which it is a prototype.

### Assigning Prototypes

So how do we set the prototype of a new object?

One very basic way is to use the `Object.create` method.

It looks like this:

```javascript
var parent = {name: "Hi i'm the parent"};
var child = Object.create(parent);
child.name
```

`Object.create` takes a single argument, which will become the prototype
of the new object it creates. Thus, `child` is a brand new object with, so
far, no properties of its own.

However since we assigned `parent` as its prototype, it can freely
access properties on the parent as if they were its own.

__Try it__

* Create a new object called `studentProto`; give it a property of
  `school` set to `Turing`
* Use `Object.create` to create a new object, `student`, with
  `studentProto` as its prototype
* Assign a `name` property to `student` with your name
* Verify you can access `name` (and get your own name) and `school` (and
  get `Turing`)
* Use `Object.getPrototypeOf` on `student` to check its prototype

In practice, we generally don't actually use `Object.create` to assign
prototype relationships. There are better ways. But it is useful for
making very clear how the relationships are getting assigned, as we have
done here.

### Prototypes vs. Classes

This is a topic that has been hashed out to great length on the
internet. In some ways there are a lot of similarities between
classes in a language like ruby and prototypes in a language like
javascript:

* Both allow child instances of their type to access their methods and
  behavior
* Both use a "chain" mechanism to continue searching for requested
  properties in their parent
* Both can be used (via constructor invocation) to "set up" new objects
when they are created

However, there are also some major differences

* Prototypes don't really provide a mechanism for encapsulation of
  state, which is one of the major principles of most OO languages.
  Javascript doesn't provide an OO-style mechanism for "private"
  functions (although we can achieve something similar with closures).
* Prototypes don't distinguish between their own methods and the methods
  provided to their children (i.e. class methods vs. instance methods).

__Zen Contemplation:__

Javascript's object model is similar to what Ruby's would be if
there were no metaclasses (aka anonymous superclasses aka eigenclasses).

### Prototype Chains

As in most OO languages, prototypes actually form a "chain" stretching
back from the current object to the "root" object in the system --
`Object` itself.

Behavior for an object can come from any point in this chain, with
entries closer to the object (further _down_ the chain) taking
precedence.

__Exercise: Retrieving Prototype Chains__

Write a function, `protoChain(object)`, which, given an object, returns
an array of all the objects in its prototype chain.

### Constructors and Prototypes in Practice

Let's see how we would use some of these techniques in practice.
To look at this, we'll work through this tutorial from Mozilla:

https://github.com/mdn/advanced-js-fundamentals-ck/blob/gh-pages/tutorials/03-object-oriented-javascript/01-introduction-to-object-oriented-javascript.md
