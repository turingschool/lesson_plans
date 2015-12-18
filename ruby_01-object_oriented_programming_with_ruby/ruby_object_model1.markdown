---
title: Ruby Object Model 1 (of 2)
length: 3 hours
tags: ruby, classes, objects, methods, instances
---

## Material

* Git: https://github.com/JoshCheek/ruby-object-model
* Cheatsheet: https://github.com/JoshCheek/ruby-object-model/blob/master/obj-model-cheatsheet.pdf?raw=true
* Quiz: http://quiz-ruby-object-model.herokuapp.com/

## Standards (note these are addressed again in the quiz)

let sk = "student knows"
    su = "student understands"

### Classes and Instances

* sk classes are containers for methods
* sk classes have a superclass pointer
* sk instances are containers for instance variables
* sk instances have a class pointer
* sk classes are instances (and undrestands this means they have instance variables and a class pointer)

### Bindings

* sk *all* code executes in a binding
* sk these are containers for local variables
* sk bindings have a self
* sk this gives them access to ivars and is why they can call methods on self
* sk bindings are stored on the "stack", the code currently being executed is being executed in the binding at the top of the stack

### Variables

* sk a "bareword" (unadorned consecutive characters) beginning with a lowercase letter is a local variable or a method
* sk parameters are local variables
* sk local variables only exist within a binding
* sk instance variabels begin with an asperand
* sk instance variables are only accessible from bindings executing in their instance
* sk global variables begin with a dollar sign
* sk global variables are accessible from anywhere
* sk constants begin with a capital letter
* sk constants are defined inside of other classes
* sk constants defined at the top level are defined under `Object`
* sk constants can be `SCREAMING_SNAKE_CASE` or `CamelCase`
* sk constants can be seen from anywhere within that class
* sk we access constants via the `::` (scope resolution) operator, e.g. `Float::INFINITY`

### Method lookup and invocation

Lookup:

* sk knows the first place we look for the method is the Object's class
* sk if we don't find it there, we continue looking for it through the chain of superclasses

Invocation:

* sk once the method is found, we add a binding to the stack
* sk "self" for the binding is whatever object we called the method on
* sk the code is then executed in the context of that binding

## Strucure


The last time I taught this, I made it up as I went,
and we came away with these notes: https://gist.github.com/JoshCheek/f2f4fed0c184ad9dbe98

* 45 min
  * Why you should care (ideally use positive motivation,
    ie inspire them to consider what they could be, or could understand.
    I fucked it up and went with negative motivation,
    ie don't be like these people who don't care)
  * Bindings (except for self), local variables, method calls, method chaining
  * I moved this stuff to be first, because I've always left it
    as an afterthought for when a student understands objects.
    But I've repeatedly found that I'd get to this later topic,
    and students wouldn't understand method invocation, either.
    That, in turn, undermines all of the objects and instances information.
    So, now I like to start with bindings and method calls and such.
    Just enough to understand the stack, local variables, and method invocation.
* 45 min
  * Classes and instances
  * Fairly "traditional", with my old style of teaching this,
    but add in that they are linked lists, and give them examples of "wonky"
    code, e.g. the kind of stuff that shows that the model is really helpful
    for understanding the material, whereas syntactic recognition
    fails for such cases.
* 45 min
  * Introduce instance variables, then ask how they get set.
    This necessitates that the binding keep track of the current object,
    which allows for the introduction of `self`.
    Then a number of examples (eg the `self` game).
* as much time as possible
  * Have them group up around whiteboards, give them a fairly innocuous piece of code,
    walk through it, having them draw the code. It will take a lot longer than you would expect,
    we barely got through the code sample in the example,
    and I had to push at the end to get there.
