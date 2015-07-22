# Functions in JavaScript

## Learning Goals

* How to define and call functions in JavaScript
* What `this` is in JavaScript and how to explicit set its value in your functions
* How to bind functions with explicit values for `this` and other arguments
* How to split an array of values among the arguments of a function
* How to use generator functions that can pause and resume execution as well as return multiple values

## Functions

Functions in JavaScript are little units of code that can be executed later. If you've worked with JavaScript in the past, you've probably come cross functions before.

Here is a simple example of a function that takes a single argument and logs a message to the console:

```js
function sayHello(name) {
    console.log('Hello, ' + name + '.');
}
```

### Defining Functions

(Function declaration versus expressions)

### Invoking Functions

#### Calling Functions, Referencing Functions, and the Difference

The easiest way to call a function is to append a pair of parentheses to the end of the name assigned to the function.

```js
function sayHello(name) {
    console.log('Hello!');
}

sayHello();
```

Functions are incredibly flexible in JavaScript. Not only can we call them like we did above, we can also pass them as arguments to other functions. We can also assign them to properties in objects as well as store them in variables. As a result, we need a way to talk about functions without accidentally calling them.

We can refer to a function without calling it by omitting the parentheses.

```js
var myFavoriteFunction = sayHello;
```

In the first section of this content kit, we passed functions to methods on `Array.prototype`. It was the method's job to call this function on each member of the array. We _do not_ want to call it the function as we pass it to the method on `Array.prototype`.

We omit the parentheses, because we're talking about the function, not invoking.

```js
function doubleNumber(n) {
  return n * 2;
};

[1,2,3].map(doubleNumber);
```

If we did add the parentheses to `doubleNumber`, JavaScript would evaluate the function and place it's return value as the argument being passed to `c`. Without an argument, the function will attempt to multiply `undefined` by `2`. This will result in `NaN`, which stands for "not a number" and is also not a function that `Array.prototype.map` can call. An error will be thrown.

Consider the following:

```js
function returnSomething(something) {
  return something;
};

var result = returnSomething(2); // 2
var nothing = returnSomething(); // undefined
var reference = returnSomething; // reference points to the returnSomething function

reference(2); // 2
```

##### Your Turn

* Write a new function called `doubleNumber` that takes a single argument and returns that argument multiplied by two.
* Pass the number two into the function and verify that it returns `2`.
* Store a reference to the `doubleNumber` function in a variable called `timesTwo`.
* Call the `timesTwo` function, passing in `2` as an argument
* Try `console.log(timesTwo.name)` and inspect the result

#### Invoking Functions

We've explored on way of invoking a function—adding a pair of parentheses onto the end. In the section on Object-Oriented JavaScript, we also explored adding methods to an objects prototype. These methods—and the ones on `Array.prototype`—are just functions stored in object properties.

But, something special happens when we declare a function as property on a object.

```js
function logThis() {
  console.log(this);
}

logThis();

var someObject = {
  logThis: logThis
};

someObject.logThis();
```

In `someObject`, the first time we say `logThis`, we're defining a property on the object. The second time, we're providing a reference to the `logThis` function in the very beginning of the code sample.

The first time we call `logThis`, we're in the global scope. `this` is the `window` object in the browser and `global` in Node.

The second time we call `logThis`, it's in a different context—`someObject`. As a result, it logs `someObject` instead of `window` or `global`.

When functions are called in the context of properties on an object, it adapts to its new surroundings and sets `this` to a reference of the object it's being called from.

##### Your Turn

Implement the following function:

```js
function logFoo() {
  console.log(this.foo);
}
```

* Create two objects: `bar` and `baz`.
* Set a `foo` property on each object to the value of your choice.
* Set a `log` property on each object with a reference to `logFoo`.
* Call `bar.log()` and `baz.log()` and notice the difference

#### Call and Apply

It's helpful that functions will adapt to their surroundings, but sometimes we need to be explicit about what we want `this` to be when we invoke a function.

Functions in JavaScript are objects and share methods on `Function.prototype`—just like all arrays share methods on `Array.prototype`.

One method all functions share is `call`, which uses the first argument you hand it and sets it to `this`, it then takes all subsequent arguments and passes them to the function you're calling `call` on.

```js
function addToFoo(n) {
  return this.foo + n;
}

var bar = { foo: 1 };
var baz = { foo: 2 };

addToFoo(); // tries add 2 to `undefined` and returns `NaN`
addToFoo.call(bar, 2); // adds 2 to the `foo` property on `bar` and returns 3
addToFoo.call(baz, 2); // adds 2 to the `foo` property on `bar` and returns 4
addToFoo.call({ foo: 3 }, 2); // adds 2 to the `foo` property on a new object
                         // and returns 5
```

The first argument when we use the `call` method is used to set `this`. The second argument is passed to function we're calling as the first argument. If we had a third argument, it would be passed as the second argument to the function we're calling and so on.

`apply` is another method shared by all functions and it behaves in a very similar fashion to `call`, but it takes the arguments you'd like to pass to the function as an array.

```js
function addThreeNumbersToFoo(first, second, third) {
  return this.foo + first + second + third;
}

var someObject = { foo: 1 };
var numbers = [2, 3, 4];

addThreeNumbersToFoo.apply(someObject, numbers); // returns 10
addThreeNumbersToFoo.apply({ foo: 1 }, [1, 1, 1]); // returns 4
```

On top of allowing you to explicitly set `this`, `apply` makes it easy to split up an array of arguments.

```js
function addThreeNumbers(first, second, third) {
  return first + second + third;
}

var numbers = [1, 2, 3];

addThreeNumbers.apply(null, numbers);
```

We used `null` in the example above because it doesn't matter what `this` is since we're not using it.

The following are all equivalent for the purposes of splitting up an array of values amongst a function's arguments:

```js
addThreeNumbers.apply(null, numbers);
addThreeNumbers.apply(this, numbers);
addThreeNumbers.apply('oogieboogie', numbers);
```

### Explicitly Setting Context with `bind`

`call` and `apply` are great ways of explicitly setting `this` when we call a function. But sometimes, we want to set `this` when we define a function, not when we call it.

`call` and `apply` invoke the function immediately. `bind` is different. It returns a copy of the function with `this` set explicitly that we can call later.

```js
function logFoo() {
  console.log(this.foo);
}

var someObject = { foo: 'Hello' };

logFoo(); // undefined
logFoo.call(someObject); // Hello

var boundLogFoo = logFoo.bind(someObject); // returns a new function with
                                           //`this` explicitly set

boundLogFoo(); // Hello
```

Let's take one more look at this with some objects.

```js
var fido = {
  name: 'Fido',
  sayHello: function () {
    console.log('My name is ' + this.name + '.');
  }
};

var spot = {
  name: 'Spot',
  sayHello: fido.sayHello,
  boundSayHello: fido.sayHello.bind(fido),
  anotherBoundSayHello: fido.sayHello.bind({ name: 'Taco' })
};

fido.sayHello(); // My name is Fido.
spot.sayHello(); // My name is Spot.
spot.boundSayHello(); // My name is Fido.
spot.anotherBoundSayHello(); // My name is Taco.
```

`bind` is useful when working with asynchronous JavaScript using callbacks or promises. When we make an AJAX request to a server, we typically pass a callback function that will execute when we hear back from the server. While, we're usually writing this function in context of the object we're working with. It will be executed in a totally different context.

Let's take a look at an example without any asynchronous callbacks:

```js
var person = {
  firstName: 'Steve',
  lastName: 'Kinney',
  updateName: function () {
    this.firstName = 'Wes'
  }
};

person.updateName();
console.log(person.firstName); // Wes
```

This works as we expect. When we call `updateName()`, `this` is still in the context of `person` object.

Things get a little tricker when we call an asynchronous function (like an AJAX call) and pass a callback.

```js
function somethingAsynchronous(callback) {
  console.log('Maybe we\'re fetching the new name from the server.');
  setTimeout(callback, 1000);
};

var person = {
  firstName: 'Steve',
  lastName: 'Kinney',
  updateName: function () {
    somethingAsynchronous(function () {
      this.firstName = 'Wes'
    });
  }
};

person.updateName();
// Wait a second…
console.log(person.firstName); // This is still Steve.
console.log(window.firstName); // Wes. Whoops, we made a global variable.
```

Although we're writing our code in the context of the `person` object. That's not where it's getting called. It's getting called later on and our anonymous function—callback—doesn't have any context of where it came from, so `this` is `window`. The end result is that not only did we not update the property we wanted to, but we also accidentally set a property on the global object.

There are a few ways to handle this. While the callback loses it's reference to `this`, it still has access to the scope that it came from. As a result, this will work:

```js
function somethingAsynchronous(callback) {
  console.log('Maybe we\'re fetching the new name from the server.');
  setTimeout(callback, 1000);
}

var person = {
  firstName: 'Steve',
  lastName: 'Kinney',
  updateName: function () {
    var self = this;
    somethingAsynchronous(function () {
      self.firstName = 'Wes'
    });
  }
};

person.updateName();
// Wait a second…
console.log(person.firstName); // This is now Wes.
```

`self` isn't special. You may also see `_this`, `that`, and other variables in your travels.

An alternate approach is to explicitly set the value of `this` on the callback function using `bind()`.

```js
function somethingAsynchronous(callback) {
  console.log('Maybe we\'re fetching the new name from the server.');
  setTimeout(callback, 1000);
}

var person = {
  firstName: 'Steve',
  lastName: 'Kinney',
  updateName: function () {
    somethingAsynchronous(function () {
      this.firstName = 'Wes'
    }.bind(this));
  }
};

person.updateName();
// Wait a second…
console.log(person.firstName); // Wes.
```

The example above works because we used `bind(this)` to explicitly set the value of `this` on the anonymous function while we're still in the scope of `person`. When the callback is eventually called, it remembers what `this` is because we bound it to the function.

### Recursion

A recursive function is a function that calls itself. It's not uncommon to use a recursive function to solve a factorial.

The factorial `5!` is equivalent to `5 * 4 * 3 * 2 * 1` or 120.

```js
function factorial(n) {
  if (n <= 1) { return 1 };
  return n * factorial(n - 1);
}

factorial(5); // 120
```

The function above goes through the following steps:

* We pass in `5`
* `5` is not less than or equal to `1`; move on
* Return `5` times `factorial(n - 1)`, which is `factorial(4)`
* Evaluate `factorial(4)` before returning from the function
  * `4` is not less than or equal to `1`; move on
  * Return `4` times `factorial(n - 1)`, which is `factorial(3)`
  * Evaluate `factorial(3)` before returning from the function
    * `3` is not less than or equal to `1`; move on
    * Return `3` times `factorial(n - 1)`, which is `factorial(2)`
    * Evaluate `factorial(2)` before returning from the function
      * `2` is not less than or equal to `1`; move on
      * Return `2` times `factorial(n - 1)`, which is `factorial(1)`
      * Evaluate `factorial(1)` before returning from the function
        * `1` is less than or equal to `1`; return `1`
      * We now know that `factorial(1)` is `1`, return `2 * 1` or `2`
    * `factorial(2)` just returned `2`; return `3 * 2` or `6`
  * `factorial(3)` just returned `6`; return `4 * 6` or `24`
* `factorial(4)` just returned `24`; return `5 * 24` or `120`

It's important to have an escape hatch for your recursive function. Otherwise, it will go on forever—actually, you'll exceed the maximum size of the call stack and be cut off by the JavaScript runtime.

We used recursion in the section where we drew blocks to the canvas using `requestAnimationFrame`. At the end of the function, we called `requestAnimationFrame` again with a reference to the same `gameLoop` function.

```js
requestAnimationFrame(function gameLoop() {
  context.clearRect(0, 0, canvas.width, canvas.height);
  blocks.forEach(function (block) { block.draw().move(); });
  requestAnimationFrame(gameLoop); // Recursion!
});
```

#### Your Turn

##### Countdown

Write a function called `countdown`, which takes a number and counts down from the numer passed in to `0` by recursively calling itself. If you called `countdown(4)`, it should `console.log(4)`, `console.log(3)`, `console.log(2)`,  `console.log(1)`, and—finally— `console.log(0)`.

##### Fibonacci Sequence

A Fibonacci sequence is a series of numbers where the next number is the sum of the previous two—starting with 1, 1 to get the ball rolling. Here is a short example:

```
1, 1, 2, 3, 5, 8, 13, 21, 34, 55
```

Can you write a function called `fibonacci()`, which takes a number as an argument and returns a Fibonacci sequence of that length?

```js
fibonacci(5); // returns [1, 1, 2, 3, 5]
fibonacci(3); // returns [1, 1, 2]
fibonacci(10); // returns [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
```

## Currying and Partial Application

### Partial Application

Partial application is a technique that allows us to pre-fill arguments to a function. Earlier, we discussed how you can use `bind()` on functions in JavaScript to explicit set the value of `this`. Like `call()`, `bind()` takes additional arguments and will set those arguments on the function it returns.

```js
function add(a, b) {
  return a + b;
}

var addTwo = add.bind(null, 2);

addTwo(4); // 6
```

The first argument is the value of `this` inside the function. We're not using `this`, so we'll just set it to `null`. The second argument, `2`, is applied as the first argument to `add`. All we have to do is supply the second argument and we're good to go.

This technique allows us to remove repetition from our code and use functions as templates for other functions.

#### Your Turn

Given the following base functions…

```js
function add(a, b) {
  return a + b;
};

function multiply(a, b) {
  return a * b;
};
```

…can your use partial application to create the following:

* A function that adds 1 to a number
* A function that subtracts 3 from a number
* A function that doubles a number
* A function that halves a number

## Generators

When we call a function in JavaScript, it typically runs until it hits the end of the function or a `return` statement. Generators, which are new to [ES6/2015][], are functions that can paused and restarted again. Generators are functions that can return values at multiple points in their execution.

[ES6/2015]:http://es6-features.org/#GeneratorFunctionIteratorProtocol

Consider the `countdown`, `fibonacci`, and `factorial` functions from the section on calling functions. We passed either a starting or stopping point to each function. Letting them run forever would be problematic. That said, it's conceivable to think that we might want to keep working with new factorials or numbers in a Fibonacci sequence as time goes on. This is a great use for generators.

**A note on browser support:** As of this writing (July 19, 2015) generator functions are supported by most of the recent versions of Chrome and Firefox as well as [io.js][]. They are not supported by Safari, Internet Explorer, or Node.js.

[io.js]:https://iojs.org/en/index.html

Generator functions look similar to regular functions, with the addition of an `*` after the `function` keyword.

```js
function* someGeneratorFunction() {};
```

Calling a generator function returns a _Generator_ object. Generator objects have a `next()` method that either start or resume execution of the function until it hits the next `yield` statement.

```js
function* addTwoThreeTimes(addend) {
  yield addend + 2;
  yield addend + 2 + 2;
  yield addend + 2 + 2 + 2;
};

var generator = addTwoThreeTimes(2);
```

We can now call the generator to get the next value.

```js
generator.next(); // { value: 4, done: false }
generator.next(); // { value: 6, done: false }
generator.next(); // { value: 8, done: false }
generator.next(); // { value: undefined, done: true }
```

Generators return an object with two properties, the `value` emitted by the current `yield` statement and a boolean signifying whether or not the generator has reached its completion. In the example above, we could continue calling `generator.next()` and we would keep receiving `{ value: undefined, done: true }`.

We can also iterate over all of the values in a generator:

```js
for (x of generator) { console.log(x); }; // Logs 2, 4, 6
```

We can also create a generator function that yields values indefinitely. Let's create a simple counter generator that will always generate the next increment indefinitely.

```js
function* counter(count) {
  while (true) {
    yield count++;
  }
};

var count = counter(0);

count.next() // { value: 0, done: false }
count.next() // { value: 1, done: false }
count.next() // { value: 2, done: false }
count.next() // { value: 3, done: false }
count.next() // { value: 4, done: false }
count.next() // { value: 5, done: false }
count.next() // { value: 6, done: false }
// … and so on …
```

Normally, `while (true)` would create an infinite loop and lock up the main thread indefinitely—bringing our program to a screeching halt. With a generator, the execution of the function is paused each time it hits the `yield` statement and control and ceded back to the scope in which it was called.

This generator will continue generating values forever, but only when asked.

### Code-Along: A Fibonacci Generator

Let's create a generator function that will build a Fibonacci sequence one number at a time.

Let's start by creating a new generator function called `fibonacciGenerator`:

```js
function* fibonacciGenerator() {};
```

Fibonacci sequences are best expressed as an array of numbers. Let's instantiate an empty array. That we'll use to store our values.

```js
function* fibonacciGenerator() {
  var sequence = [];
};
```

We also know that we'd like to generate Fibonacci numbers indefinitely. We'll wrap our yield statement in a loop.

```js
function* fibonacciGenerator() {
  var sequence = [];
  while (true) {
    yield sequence;
  }
};
```

We can typically generate new numbers by adding the previous two together. In order to do that, we'll have to add `1` to the sequence if we have less than two numbers.

```js
function* fibonacciGenerator() {
  var sequence = [];
  while (true) {
    if (sequence.length < 2) { seqeunce.push(1); }
    yield sequence;
  }
};
```

Now, it's time for the real work. If we have at least two numbers, we want to add the last two numbers together. Additionally, we're going to need the length of the sequence in multiple difference places, so we'll store it into a variable at the beginning of each loop.

```js
function* fibonacciGenerator() {
  var sequence = [];
  while (true) {
    var length = sequence.length;
    if (length < 2) {
      sequence.push(1);
    } else {
      var nextNumber = sequence[length - 1] + sequence[length - 2];
      sequence.push(nextNumber);
    }
    yield sequence;
  }
};
```

We can now take our fibonacci generator for a spin and generate numbers to our heart's content.

```js
var fibonacci = fibonacciGenerator();

fibonacci.next().value
// { value: [ 1 ], done: false }
fibonacci.next().value
// { value: [ 1, 1 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2, 3 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2, 3, 5 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2, 3, 5, 8 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2, 3, 5, 8, 13 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2, 3, 5, 8, 13, 21 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2, 3, 5, 8, 13, 21, 34 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2, 3, 5, 8, 13, 21, 34, 55 ], done: false }
fibonacci.next().value
// { value: [ 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89 ], done: false }
```

### Your Turn

Can you create a generator function that can generate factorials? Below is an example of how the code should work when you have it up and running.

```js
function* factorialGenerator() {
  // Your code goes here.
}

var factorial = factorialGenerator();

factorial.next().value; // 1
factorial.next().value; // 3
factorial.next().value; // 6
factorial.next().value; // 24
factorial.next().value; // 120
```
