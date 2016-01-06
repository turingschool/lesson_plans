---
title: Refactor Tractor: Game Time and Ideabox
length: 160
tags: javascript, refactoring, jquery
---
# Refactor Tractor: The Game Time and Ideabox Edition

## Learning Goals
* Use real examples of Game Time/Ideabox code

## Structure
* 25 - Warm Up and Discussion
* 5 - Break
* 25 - API TDD Codealong (Articles#show)
* 5 - Break
* 25 - Your Turn - students add Articles#index
* 5 - Break
* 25 - Your Turn - students add Articles#index
* 5 - Break
* 25 - Your Turn - students add Articles#index
* 5 - Break
* 25 - Your Turn - students add Articles#index

## Warmup and Discussion

## Refactor Tractor

### Low Hanging Fruit

__The 'Oops I Left That In There' Code__

This is the lowest hanging of low hanging fruits.

The following things should not be committed, and should never make it into your master branch.

1. `debugger` statements
```js
  debugger;
```
2. Commented out code.
```js
  //#.bind(this);
```
 Sometimes an argument for commented out code can be made when it's there as a reminder or note to other developers. Sometimes. The above example is most likely unintentionally committed, however.

3. Wonky Whitespace
  Developers scan code - and mismatching or messed up whitespace is the equivalent of seeing someone with a misspelled tattoo. Doesn't matter how good the code is, it just looks dumb.

4. Mismatched or Too Many Semicolons Used

```js
//...
success: function(idea){
  removeIdeaFromView(idea)
},
error: function(){
  console.log("fail");
}
```

JS does not enforce the use of semicolons, so it's possible to omit them. BUT when they are missing, the JavaScript parser automatically inserts them.

_This can change how your code behaves_

Check out this example from the [JavaScript Garden](http://bonsaiden.github.io/JavaScript-Garden/#core.semicolon)

```js
(function(window, undefined) {
    function test(options) {
        log('testing!')

        (options.list || []).forEach(function(i) {

        })

        options.value.test(
            'long string to pass here',
            'and another long string to pass'
        )

        return
        {
            foo: function() {}
        }
    }
    window.test = test

})(window)

(function(window) {
    window.someLibrary = {}

})(window)
```

This is how the interpreter will parse the code - which will change what the code does.

```js
(function(window, undefined) {
    function test(options) {

        // Not inserted, lines got merged
        log('testing!')(options.list || []).forEach(function(i) {

        }); // <- inserted

        options.value.test(
            'long string to pass here',
            'and another long string to pass'
        ); // <- inserted

        return; // <- inserted, breaks the return statement
        { // treated as a block

            // a label and a single expression statement
            foo: function() {}
        }; // <- inserted
    }
    window.test = test; // <- inserted

// The lines got merged again
})(window)(function(window) {
    window.someLibrary = {}; // <- inserted

})(window); //<- inserted
```

__Accidental Global Variables__

Forgetting a `var` can cause major problems in your code.

To review:

```js
var cat = 'fluffy';
// This defines a `cat` in the current scope

snake = 'snek';
// This defines a variable called `snake` in the global scope
```

This can cause some pretty gnarly bugs. [Try running the code below is jsbin](http://jsbin.com/fukuqupalo/edit?js,console).

```js
for(var i = 0; i < 5; i++) {
  console.log(i);
  methodThatAccidentlyCreatesAGlobalVariable();
  console.log(i);
}

function methodThatAccidentlyCreatesAGlobalVariable(){
  for(i = 0; i < 5; i++) { // welp, we forgot the var statement
    // ...
  }
}
```

The `methodThatAccidentlyCreatesAGlobalVariable()` creates a global `i` variable. The initial for loop will only run once.

__Caching jQuery Selectors__

```js
  $(“#myHeader”).hide();
  // do some things
  $("#myHeader").show();
```

In the above code, jQuery is searching the entire DOM tree to locate the `#myHeader` twice.

Instead, we should consider caching - storing the reference to the object in a variable.

```js
  var $myHeader = $(“#myHeader”);

  $myHeader.hide();
  // do some things
  $myShow.hide();
```
__Passing Many Arguments to a Function__

* Example from codez
* Why is this bad? - Gets very confusing. Hard to de-couple and test. Error prone.
* How to fix = passing an object and memoization

### Higher Level Concepts

__Cross-Site Scripting Vulnerability__

__Array Iteration__

`for in` loops should not be used to iterate over arrays.

Why?

1. The `for in` loop is twenty times slower than a normal `for` loop.
2. This is the big one: The `for in` loop enumerates all the properties that are on the prototype chain.

Imagine this scenario:

```js
Array.prototype.strangePet = 'snake';

var myPets = ['dog', 'dog', 'rock'];
for(var i in myPets){
  console.log(i);
  // You will see 'snake' show up in your list of pets
}
```

Does this ever happen in the real world?

One of my favorite bugs ever was in an old JavaScript project I worked on caused by a `for in` loop.

Early in the project's history, someone had added some code to the Array object to monkey patch in some Array methods not available in Internet Explorer. It would add a new method on the prototype but only if the user was accessing the site with an early IE.

Then, someone else decided to add some click tracking that would catch an array of data on certain clicks. It would iterate through an array - call any methods in the array and record any data.

Two years later, no one knew why one section of the website had never worked in Internet Explorer 8.

The reason? The click tracking code looked something like this:

```js
  for(var i in myArray){
    // if i is an method, call that method
    // else track the info
  }
```

Because they had added a monkey patch to Array, and because the `for in` loop iterates over all properties on a prototype chain... they were accessing the monkey patched method and calling it when they didn't mean to be calling the method and things blew up.

I spent way too long in an Internet Explorer emulator trying to figure out what was going on with that bug than I'd like to admit.

#### How to Fix It?

Avoid this fate by using classic `for` loops on arrays.

```js
for(var i = 0, i < myArray.length; i++) {
  //
}
```

You can see the correct way of array iteration being used [here](https://github.com/mcschatz/breakout/blob/cd05e17be5bf83b2b79554f880f8d98038dca41d/lib/game.js#L49)

## Your Turn

Many of the code examples from the above lesson came directly from Game Time and Ideabox projects. Your mission now is to spend time in your projects doing some refactoring. Use the above examples as a roadmap, or fix other issues as you find them.

- Find your Refactoring Buddy
  - You do NOT have to pair program with them if you prefer to work solo. That said, pairing is a good skill to have so it's worth trying.
- Dig into your IdeaBox and Game Time projects and try to identify issues or places for refactoring.
- When you find a place to refactor, create a Github issue for the fix if one doesn't exist already.
- Comment on any unclaimed issue to 'claim it' when you start work on a fix.
  - Why?: This is how you know that you're not duplicating work that someone else is doing on the project.
- Check out a branch and make the fix.
- You will need to submit Pull Requests for any refactors you make.
  - You can submit a Pull Request for each individual fix or submit a PR that includes many fixes. There are pros and cons to either choice.
- Use the following template as the body of your Pull Request(s).
- On the PR
  - Tag an instructor of your choice.
  - If: you worked with your Refactoring Buddy
    - Tag the members of another refactor team to review the PR
  - Else:
    - Tag your Refactoring Buddy to review the PR
- Review any PRs you have been tagged on.
  - Comment inline on the code changes. If you like something someone did, let them know. If you have concerns about the change, let them know (nicely). If you have questions, ask them. If you think the PR is good to merge, let them know with a thumbs up or a ship emoji or just regular old words.
  - Respond to the comments that you get on your PRs.

__A Note on Refactoring__

One of the best things about working as a programmer is working with other programmers. We all make mistakes in our code, from Linus Torvalds to InfoSec Taylor Swift to some guy named Fred who just finished a Code School course and added 'software developer' to his LinkedIn profile. It's impossible to know every trick and best practice, and even if you did, you'd still make silly code mistakes in the heat of the moment.

This is why we pair program and have code reviews.

The examples that we pull out in this tutorial are the kinds that every programmer makes. Sometimes it takes a second set of eyes to see where improvements can be made. You'll see them in your code, classmates' code, your instructors' code, your boss's code... etc.

Never be afraid to make a mistake, that's what you learn from!
