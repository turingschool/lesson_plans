---
title: Refactoring Good Tipper
length: 60
tags: ember, javascript
---

## Set Up

Make sure you clone down [Good Tipper][gt] if you haven't already. We'll be working on the `built-calculator` branch. Run `git pull` in case there have been any changes from last time.

[gt]: https://github.com/turingschool-examples/good-tipper

```shell
git clone git@github.com:turingschool-examples/good-tipper.git
git checkout built-calculator
```

If you're pulling down for the first time, make sure you run `npm install && bower install` to install all of our dependencies.

## Lecture/Code-Along

### Controller Refactoring

Let's revisit [Good Tipper][gt] from a previous lesson. In this iteration, we're going to focus on a few major topics:

* Use custom setters and getters on our controller's properties.
* Using Handlebars helpers to handle the presentation logic.
* Make use of Handlebars iterators and conditionals.

First, let's review [our controller from last time][bcapp].

[bcapp]: https://github.com/turingschool-examples/good-tipper/blob/built-calculator/app/controllers/application.js

It's a good start for our first taste of Ember, but we can do better. Our controller is handling a lot of presentation logic and we have a lot of properties that do almost the same thing. It may also have a few bugs. Bugs are bad. I wouldn't ship bugs.

The first issue that we came across is that every time we entered a new value for the tip or bill amount, our precious numbers were swapped out for strings under our noses and the JavaScript's `+` started doing concatenation instead of addition. Weak sauce.

One solution is to sprinkle around a liberal amount of defensive `parseInt()`s everywhere. The other option was create some more computed properties with that parsed the input field back into an integer. Both solutions are variations on a theme. Another bad solution was to observe `tipAmount` and `billAmount` and then try to force them back into numbers. This is bad, because changing the property would—in turn—trigger the observer again. Yuck.

There's got to be a better way, right?

Yea, there is. The syntax is a little weird (and will be getting better in Ember 2.0), so we'll go slowly.

When we defined a computer property before, we didn't pass it any arguments. It looked something like this:

```js
export default Ember.Object.extend({

  firstName: "Steve",
  lastName: "Kinney",

  fullName: function () {
    return this.get('firstName') + this.get('lastName');
  }.property('firstName', 'lastName')

});
```

JavaScript is funny like that: it doesn't raise/throw an `ArgumentError` if you pass it the wrong number of arguments. It just goes along it's merry way. This is the default behavior and usually what we want.

We can, however, define some additional parameters, which will allow us to set a custom setter.

Let's say we wanted `person.fullname('Jeff Casimir')` to split on the space and set the first and last time of the person:

```js
export default Ember.Object.extend({

  firstName: "Steve",
  lastName: "Kinney",

  fullName: function (key, newValue, oldValue) {
    if (arguments.length === 1) {
      return this.get('firstName') + ' ' + this.get('lastName');
    } else {
      var name = newValue.split(' ');
      this.set('firstName', name[0]);
      this.set('lastName', name[1]);
      return newValue;
    }
  }.property('firstName', 'lastName')

});
```

So, let's see this in action: check out [this JSBin](http://jsbin.com/sosiya/3).

There are a few things happening here:

1. We're passing the computed property some additional parameters
  * `key` is the name of the parameter. This isn't particularly helpful. In this case it's `fullName`.
  * `newValue` is whatever we passed into `person.set('fullName', rightHere)`.
  * `oldValue` is whatever it was before we changed it.
2. We check how many arguments were actually passed in. If it's 1, then it was probably called with `person.get('fullName)`, so let's just do the normal thing. But if there are more arguments, then this is the setter and let's implement our custom functionality.
3. Lastly, we split apart our `newValue` and set `firstName` and `lastName`.

We can do something similar in Good Tipper. What we want to do is take whatever the user inputs and parse it into an integer on the way in.

On a first pass, something like this should work:

```js
export default Ember.Controller.extend({

  billAmount: function (key, newValue, oldValue) {
    if (arguments.length !== 1) { return parseInt(newValue, 10); }
  }.property(),

  tipPercentage: function (key, newValue, oldValue) {
    if (arguments.length !== 1) { return parseInt(newValue, 10); }
  }.property(),

  // Additional code left out for brevity.

});
```

This will crash our application because we are still relying on Numeral.js to format numbers and they'll start out as `undefined`, which will throw an error. We're going to be ripping Numeral.js out of the controller, but default values will be nice to have. So, let's implement them now.

```js
export default Ember.Controller.extend({

  setDefaultAmounts: function () {
    this.set('billAmount', 10);
    this.set('tipPercentage', 18);
  }.on('init'),

  billAmount: function (key, newValue, oldValue) {
    if (arguments.length !== 1) { return parseInt(newValue, 10); }
  }.property(),

  tipPercentage: function (key, newValue, oldValue) {
    if (arguments.length !== 1) { return parseInt(newValue, 10); }
  }.property(),

  // Additional code left out for brevity.

});
```

Oh, hey: New concept! What is this `.on('init')` business? Remember ActiveRecord callbacks. This is _kind of_ similar. Ember objects fire off certain events over the course of their life cycle. We swapped out our raw numbers for computed properties, so what we're doing here is setting those properties when the object is initialized.

Our app, should work now. But we haven't reaped any of the advantages of our new approach. All those extraneous `parseInt`s? It's time to get rid of them. [Take a look at this commit for more information](https://github.com/turingschool-examples/good-tipper/commit/8cdea75aa0febfa467600109e91b58ba4f0512ba).

### Handlebars Helpers

Okay, the next target of our ire is going to be properties like `tipAmountFormattedForHumans`. That's gross.

Rails has a `number_to_currency` helper for—well, I'll let you guess what the helper does. Ember doesn't ship with a similar helper by default. But we can certainly roll our own.

From your terminal, let's generate a new helper.

```shell
ember generate helper number-to-currency
```

This generated the following template:

```js
import Ember from 'ember';

export function numberToCurrency(input) {
  return input;
};

export default Ember.Handlebars.makeBoundHelper(numberToCurrency);
```

Not bad, it looks like we can steal some of the logic from our controller and move it here.

```js
import Ember from 'ember';

export function numberToCurrency(input) {
  return numeral(input).format('$0.00');
};

export default Ember.Handlebars.makeBoundHelper(numberToCurrency);
```

We now have a new helper called `number-to-currency` that we can call in our views. Let's head into `application.hbs` and switch out all of those ridiculous properties. [Check out this commit if you'd like to see the code removed](https://github.com/turingschool-examples/good-tipper/commit/9ebcbccf4af14714218c3317d55c16f1559595f3).
