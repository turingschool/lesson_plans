---
title: Ember Testing
length: 90
tags: javascript, ember
status: Draft
---

## Lecture

### Getting Started

For starters, just go the `/test` directory.

By default you'll see your JSHint validations in the test suite.

Any file that ends with `-test.js` will get executed.

Generators also create some tests on your behalf.

#### Building and Tearing Down Your Application

So, we actually want to build up and tear down the entire application between tests.

If you comment out your `teardown` method. QUnit will leave you in your app—albeit, a tiny little version of your application.

Ember gives QUnit some additional super methods that allow you to navigate around your Ember application.

* `visit('/')`
* `find()`
* `fillIn()`
* `andThen()`

The first three should be relatively straight forward and somewhat familiar.

But let's take a moment to talk about `andThen()`: It's sole purpose is to try to take the pain out of testing asynchronous code. `andThen()` checks to see if there are any unresolved promises (e.g. AJAX) or anything currently pending in the Ember run loop. Once the cost is clear, it then execute the callback you handed it.

### Hooking Into Your Application

* `moduleFor` (allows you to pass something like "controller:application" or "route:index")
* `moduleForComponent`
* `moduleForModel`

## Code Along

### Unit Testing

Let's generate a new project called `social-butterfly` for keeping track of the people we meet at, umm, meetups.

```
ember new social-butterfly
```

Let Ember CLI do it's thing, then `cd` into the directory.

```
ember generate model contact
```

Ember made two files for us.

```
installing
  create app/models/contact.js
installing
  create tests/unit/models/contact-test.js
```

Alright, let's start simple. Unless we've been palling around with Cher, Bono, or Madonna. Your contacts probably have first and last names. Let's also work under the assumption that we'll want to get their full names from time to time.

So, we want to make sure that our contacts are Ember Data models. Some boilerplate test code has been written for us, but we'll need to add one or two things for our purposes.

In `tests/unit/models/contact-test.js`, let's pull in Ember Data itself.

```js
import DS from 'ember-data';
```

We'll put that up near the top where we import stuff from `ember-qunit`. Down at the bottom, let's add our test.

```javascript
test('it is an Ember Data model', function () {
  ok(this.subject() instanceof DS.Model);
});
```

If all went well, the test should pass and we now know that our contact is an Ember Data model and not just a normal Ember Object.

You probably noticed that we have this very special `this.subject()`. It's pretty much shorthand for creating a new model and then calling `createRecord()` on it.

We also have some questions about the Contact class itself that we're going to want answered. Is `firstName` a normal property or it is an attribute that is being synced with the database? I don't know. Let's write a test.

We need access to `Contact`, so let's import it.

```js
import Contact from 'social-butterfly/models/contact';
```

Take a look at that convention. Commit it to memory. The Ember Resolver will make sense of that string and pull in the right file. The basic gist is that it's your application name (what you used when you called `ember new`).

Let's write our test and then we'll talk about it a bit.

```js
test('it has a first name property', function() {
  var property = Contact.metaForProperty('firstName');
  strictEqual(property.type, 'string');
  ok(property.isAttribute);
});
```

Let's talk about `metaForProperty`.

This should fail. We have to implement the attribute, right?

```js
export default DS.Model.extend({
  firstName: DS.attr('string')
});
```

Let's run our tests again and watch everything pass.

#### Quick Practice

Can you implement a check for `lastName`?

#### Testing a Computed Property

So, we can test some attributes. Now, let's test a computed property.

Luckily, this is a lot more straightforward than the previous two tests that we wrote.

```js
test('it can compute a full name', function () {
  var contact = this.subject({
    firstName: "Steve",
    lastName: "Kinney"
  });
  strictEqual(contact.get('fullName'), 'Steve Kinney');
});
```

Okay, so now we have a failing test. Let's write an implementation.

```js
import DS from 'ember-data';

export default DS.Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),

  fullName: function () {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
});
```

Alright, let's say we wanted to keep track of how many times we met a contact at a party. If we've added them to our application we can assume that we've met them at least once. We can also level them up meet them again.

So, the first piece of this user story is having a `meetingCount` that defaults to one.

Writing a test for this one should be pretty straight-forward.

```js
test('it has a meetingCount with a default of 1', function () {
  var contact = this.subject();
  strictEqual(contact.get('meetingCount'), 1);
});
```

Let's look at our implementation.

```js
import DS from 'ember-data';

export default DS.Model.extend({
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  meetingCount: DS.attr('number', { defaultValue: 1 }),

  fullName: function () {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName'),
});
```

### Integration Testing

Super great, we have a model with tests. But we also have client-side application with no client-side.

Ember CLI didn't make any files for us by default. Ember CLI will run any file that ends in `*-test.js`. So, let's make a `integration` folder next to our `unit` folder. Let's also pop in a file called `add-contact-test.js` in that folder.

So now we have a blank file. That's great, but we're going to need some boilerplate in order to get our suite up and running.

```js
import Ember from 'ember';
import { test } from 'ember-qunit';
import startApp from '../helpers/start-app';
var App;

module('Integration - Add Contact', {
  setup: function() {
    App = startApp();
  },
  teardown: function() {
    Ember.run(App, App.destroy);
  }
});
```

So, what's going on here. Well, we're importing Ember, we're pulling in our test library, and we're also grabbing a fun little helper called `startApp`. This will basically allow us to build up a separate and isolated Ember application from the ground up before each test. We also destroy it at the end of the test.

So, let's write a failing test.

```js
test('it has an unordered list of contacts', function () {
  visit('/').then(function () {
    ok(find('.contacts').length);
  });
});
```

## Pair Practice

* Make the test above pass
* Write a test that fills in a form with a new contacts first and last name and attds them to `.contacts`
* Write a test that clicks a "Meet" button on the contact to increment the number of meetings
