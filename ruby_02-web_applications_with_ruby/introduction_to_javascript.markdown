---
title: Introduction to JavaScript
length: 120
tags: javascript, dom, browser
---

## Learning Goals

* Learn how to access and use the Chrome Developer Tools
* Develop a basic understanding for JavaScript syntax
* Work with functions as first-class objects
* Understand how to query and update a page after its been loaded

## Structure

* 5 - Warm Up
* 10 - Full-Group Instruction: History and Basics
* 15 - Pair Experiment and Review: Creating a Function
* 5 - Break
* 10 - Full-Group Instruction: Control Flow and Array Iteration
* 10 - Pair Exercise and Review: Iterating Over an Array of Functions
* 5 - Break
* 25 - Full Group Instruction
* 5 - Break
* 25 - Independent Work
* 5 - Wrap Up

### I consider myself a JavaScript ninja already... What should I do?

This is a very introductory lesson. If you find yourself already familiar with the things we are going to cover in this lesson and you want something a little spicier to chew on head over to the [JavaScript Koans](https://github.com/mrdavidlaing/javascript-koans) and try your hand at some JavaScript challenges.


## Warmup

Open up the Chrome Developer Tools by pressing `Command-Option-J` on your Mac. This will give you a REPL like `pry` or `irb`—except with JavaScript. Take a few moments to try the following:

* Perform basic arithmetic (`2 + 2`, `3 * 3`);
* Create some strings
* Create an array
* Assign a value to a variable
* Create a hash (in Ruby 1.9+ style)

What works as expected? What are some things that you noticed behave differently? Record these observations in a Gist.

## Full-Group Instruction I: History and Basics

Legend has it JavaScript was created in 10 days in May of 1995 by Brendan Eich. It was originally descended from [Self][] and [Scheme][], but its syntax was changed to be more like Java and C. It has no relation to Java.

[Self]: http://en.wikipedia.org/wiki/Self_(programming_language)
[Scheme]: http://www.scheme.com/tspl4/

### Variables

Like Ruby, JavaScript uses duck typing. Unlike Ruby, you need to use the `var` keyword when declaring a variable for the first time. If you forget the `var` keyword, your variable will be declared in the global scope—whether you meant it that way or not.

```js
var x = 1;
console.log(x); // => 1
x = 2;
console.log(x); // => 2
```

### Comments

```js
// Double slashes comment out a single line of code

var notCommentedOut = "I Am a variable that is not commented out."

/*
 You can comment out multiple
 lines of code if you sandwich those lines
 between a slash asterisk - asterisk slash
*/

var moreUncommentedCode = "I'm not commented out!"
```

### Operators

Operators are pretty straight forward in JavaScript - for the most part.

```js

  // +
  // add/concatenation
  // Used to add two numbers together, or glue two strings together.

  3 + 3 ; "I really like " + "cookies and pizza."
```
```js
  //  -, *, /
  // subtract, multiply, divide
  // These do the basic math operations you'd expect

  6 - 3 ; 3 * 3 ; 9 / 3
```
```js
  //  =
  // assignment operator
  // this assigns a variable a value

  var name = "Reginald"
```
```js
  // ===
  // Identity operator
  // This compares the values of two things and decides if they are equal to one another. Returns a true/false (boolean)

  var name = "Reginald"

  name === "Reggie" //=> false
  name === "Reginald" //=> true
```
```js
  // !, !==
  // Negation, not equal
  // Returns the logically opposite value of what it preceeds; it turns  a true into a false, etc. When it is used alongside the Equality operator, the negation operator tests whether two values are not equal

  var isTruth = true
  var isFalse = false

  !isTruth //=> false

  isTruth !== isFalse //=> true

  !isTruth !== isFalse //=> false

```

### Conditionals

We can write conditionals in JavaScript too! There are a few differences from ruby.

```js
var cookie = "chocolate chip"

if (cookie === "chocolate chip") {
  alert("This cookie is a chocolate chip cookie!")
} else if (cookie === "oatmeal raisin") {
  alert("This is not a cookie :(")
} else {
  alert("I bet you wish you had a chocolate chip cookie")
}
```


### Functions

In Ruby, we call methods on an object. Functions behave a lot like methods except that they are objects themselves. This means that you can store a function in a variable, pass a function as an argument to another function, or even call methods on a function.

Functions can be either named or anonymous. Anonymous functions can be stored in a variable or passed as an argument to another function.

```js
// Named function
function sayHello(name) {
  console.log('Hello, ' + name + '!');
}

sayHello('Alan Turing'); // Logs 'Hello, Alan Turing!'
sayHello; // Doesn't log anything. The function was never called.
sayHello(); // Logs 'Hello, undefined!' but does not raise an argument error.

// Anonymous function
function (addend) {
  return addend + 2;
};
// But how do we call it now?

// Let's try it again, but let's store it in a variable.
var addTwo = function (addend) {
  return addend + 2;
};

addTwo(2) // 4
```

Let's take a look at passing a function as an argument to another function.

```js
// Let's start out by defining some functions.

function addTwo(addend) { return addend + 2; }
function subtractOne(minuend) { return minuend - 1; }
function multiplyByThree(factor) { return factor * 3; }

// Now let's set up a function that takes a function as an argument.

function doMath(value, mathFunction) {
  return mathFunction(value);
}

doMath(2, addTwo); // => 4
doMath(4, subtractOne); // => 3
doMath(3, multiplyByThree) // => 9
```

Notice how we didn't use the parentheses when we passed the functioned into `doMath`? That's because if we used the parentheses, we would call the function. We don't want to call it. We just want to reference it.

## Pair Experiment I: Creating a Function

Try the following:

* Create a function that divides one number by the other.
* Create a function that takes a number, two of the math functions listed above, and performs both math equations on the value (e.g. `yourMathFunction(2, addTwo, subtractOne)` should return `3`).

Copy and paste each into the Chrome Developer Tools. Did it work?

# Break

## Full-Group Instruction II: Control Flow and Array Iteration

### Conditionals

Conditional statements have a few extra decorations as compared to Ruby.

```js
var hoursOfSleep = 8;

if (hoursOfSleep < 6) {
  console.log('I am groggy.');
} else {
  console.log('I feel fantastic!');
}
```

### Iterating Over Arrays

In recent versions of JavaScript. Arrays have a `forEach` method that acts kind of like Ruby's `each`. JavaScript does not have blocks like Ruby, but we can use an anonymous function in it's place.

```js
var words = ['home', 'word', 'hello'];

words.forEach(function (word) {
  console.log(word);
});
```

We could also use a reference to a named function.

```js
var words = ['home', 'word', 'hello'];
function yell(word) { console.log(word.toUpperCase()); }

words.forEach(yell);
```

### Iterating Over Collections of Objects

`forEach` is a prototype method on the Array object. It only works if the collection you are trying to iterate over is an array.  `var x = ["panda", "koala", "teddy"]`
```js
Array.isArray(x)  // true
```
 We can however use a for loop instead of forEach.

`for(initialization; condition; final-expression) { doSomething } `

so, we wanted to iterate over `var x = ["panda", "koala", "teddy"]` and `console.log` each bear we would write a for loop like this:
```js
for(var i = 0; i < x.length; i++){ console.log( x[i] ) } // "panda" "koala" "teddy" }
```

## Pair Experiment II: Iterating Over an Array of Functions

Try the following:

* Take an array of numbers. Log each number multiplied by two.
* Create an array of functions. Call each one as you iterate through the array.
* JavaScript arrays also have `map` and `reduce`. Can you figure out how to use them by looking [at the docs][mdn]?

[mdn]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array

# Break

## Full Group Instruction III: Objects and the DOM

### Objects

JavaScript doesn't have hashes, but it does have objects. Objects don't need to be instances of a class. They can be declared with a syntax that looks familiar to Ruby's hashes.

```js
var cat = { language: 'Bucu', bodyType: 'chunky' };
console.log(typeof cat); // => "object"
```

You can access the properties of a JavaScript object using dot syntax.

```js
console.log(cat.bodyType); // 'chunky'
```

You can even nest objects.

```js
var cat = {
  name: 'Bucu',
  features: {
    fur: 'orange',
    eyes: 'green'
  }
}

console.log(cat.features.eyes); // 'green'
```
We can also assign functions as object properties.

```js
var cat = {
  name: 'Bucu',
  sayHello: function () { console.log("Hello, I'm " + this.name ); }
}

cat.sayHello(); // 'Hello, I'm Bucu'
```

### The Document Object Model (DOM)

The browser gives us some useful global objects for free. The `window` object is the global object and it holds a lot of information about the browser window including it's current location (URL), size, etc. `document` contains a representation of the current web page.

`document` contains a bunch of methods that allow us to query the DOM. Let's talk about two commonly used methods.

```js
document.querySelector();
document.querySelectorAll();
```

Both methods take a query selector—like you would use in Capybara. `document.querySelector()` returns the first element that matches the query. `document.querySelectorAll()` returns a collection all of the elements that match the query.

Let's say we have a page with the following markup:

```html
<h1>This is a Page Heading</h1>

<p>The is the first paragraph.</p>
<p class="awesome">The is the second paragraph.</p>
<p id="third" class="awesome">The is the third paragraph.</p>
```

Let's try out some queries:

* `document.querySelectorAll('p')` will return a collection of all of the paragraphs.
* `document.querySelector('p')` will return just the first paragraph.
* `document.querySelectorAll('.awesome')` will return the two paragraphs with the class `awesome`.
* `document.querySelectorAll('#third')` will return the paragraph with the id `third`.

Let's say we wanted to change the contents of our `<h1>` element. We could modify it's contents with the following JavaScript.

```js
document.querySelector('h1').innerHTML = 'JavaScript is amazing!';
```

The DOM has been updated to the following:

```html
<h1>JavaScript is amazing!</h1>

<p>The is the first paragraph.</p>
<p class="awesome">The is the second paragraph.</p>
<p id="third" class="awesome">The is the third paragraph.</p>
```

# Break

## Independent Work

Visit the [this page][jsbin]. Try to implement the following using JavaScript in the Chrome Developer Tools:

[jsbin]: http://jsbin.com/vozap

### Beginning

* Find the element with the `id` of `status` and change the message to something warm and uplifting.
* Find the `h1` tag and change the header to "A Stellar Record of My Performance".
* Change all of the elements with a class of `student` to your name.

### Intermediate

* Find all of the elements with the class of `grade`. Iterate through all of them and change their content to "A+"s.
* Can you create a function that takes an HTML element as an argument and capitalizes its contents?

### Challenging

* Select an element and set `contentEditable` to true. Now, click on the element. What happened?
* Take a look at the [MDN documentation for DOM events][mdndom]. Can you bind a function to the click event of the element?

[mdndom]: https://developer.mozilla.org/en-US/docs/Web/API/Event

## Wrapup

Spend the last five minutes returning to your Gist from the Warmup. Were your initialize observations true? What are some additional differences that you've noticed after spending a few ours with JavaScript? How might the Chrome Developer Tools aid in Rails development?
