---
title: jQuery DOM Traversal, Manipulation, and Events
length: 180
tags: javascript, jquery
status: draft
---

## Learning Goals

* Use jQuery selectors to find content
* Understand that jQuery collections allow you to manipulate multiple elements with a single method
* Use jQuery's DOM traversal methods to move around the DOM
* Add CSS styles using jQuery
* Append new content to the DOM
* Add event listeners to elements currently in the DOM
* Understand that adding an event listener will not effect elements you add to the DOM in the future

## Structure

* 0:10 - 10 - Lecture 1: Selectors
* 0:20 - 10 - Exercise 1: Basic Selectors with the President
* 0:25 - 5 - Exercise Review
* 0:30 - 5 - Break
* 0:45 - 15 - Lecture 2: Manipulating CSS
* 1:00 - 15 - Exercise 2: Painting the Presidents
* 1:05 - 5 - Exercise Review
* 1:10 - 5 - Break
* 1:20 - 10 - Lecture 3: Appending to the DOM
* 1:35 - 15 - Exercise 3: Dead Presidents
* 1:40 - 5 - Exercise Review
* 1:50 - 10 - Break
* 2:05 - 15 - Lecture 4: Filtering and Traversal
* 2:20 - 15 - Exercise 4: One-Term Presidents
* 2:25 - 5 - Exercise Review
* 2:30 - 5 - Break
* 2:40 - 10 - Lecture 5: Events
* 2:55 - 15 - Exercise 5: Event Responder
* 3:00 - Exercise Review: Wrap Up

## Lecture, Part One: Selectors

### Basic Selectors

Out of the box, jQuery supports the selector syntax from CSS to find elements on the page. So, you already come pre-equipped with a bunch of knowledge for finding elements.

That said, let's review some of the different ways we can find an element on page.

* `$('p')`, selects all of a given element.
* `$('#heading')`, selects the element with a given id.
* `$('.important')`, selects all of the elements with a given class.

You can also use multiple selectors in the same statement:

* `$('p, #heading, .important')`, selects everything listed above.

### Attribute Selectors

See the API documentation [here](http://api.jquery.com/category/selectors/attribute-selectors/).

Let's take a look at [this simple form](http://jsbin.com/basolo/) and try out some selectors.

Use Chrome Developer Tools to select the form fields. When properly selected you should see an array of selected elements. You should see sections of the page highlighted when you hover over the elements in the array.

### Laboratory

[Here is an little experiment][exp] where you can play around and try out some different selectors.

[exp]: http://codylindley.com/jqueryselectors/

## Exercise, Part One: The Presidents

For this exercise, we're going to play with [a table of the Presidents of the United States of America](http://codepen.io/neightallen/pen/dMRMgR?editors=1011).

Let's try out a few things, just to get our hands dirty. We'll use the console in the Chrome developer tools to validate our work.

* Select each `tr` element.
* Select all of the elements with the class of `name`.
* Select all of the elements with either the class of `name` or `term`.
* Select all of the checked—umm—checkboxes. (You'll probably want to check some checkboxes first.)
* Select all of the `td` elements with the class of `number` that appear in a row of a `tr` with the class of `whig`.

(This should take about five minutes total.)

## Lecture, Part Two: Manipulating CSS

Once we have an element in our sites, we probably want to do something with it, right?

In this case, let's add some CSS styling. Let's say we wanted to grab all of the Federalist presidents and turn their font color pink. We could do something like this:

```js
$('.federalist').css('color', 'pink');
```

One thing you might have noticed about CSS is that it really likes hyphens. So, to change a background color, you would use `background-color`. The thing about hyphens is that they are a no-no in JavaScript. So, we *should* to camel-case our property names in our CSS methods.

```js
$('.federalist').css('backgroundColor', 'pink');
```

You'll notice I said "should" instead of must. At the end of the day that's just a string. You can do it the other way, but it's against convention.

```js
$('.federalist').css('background-color', 'pink');
```

Right now, we're setting individual properties. We can also pass in a conditional object in order to change multiple CSS attributes all at once.

```js
$('.federalist').css({
  backgroundColor: 'pink',
  fontWeight: 'bold'
});
```

If you ignored me earlier and insisted on using hyphens, you're going to have to wrap those property names in quotes now. Yuck.

Writing CSS by hand is probably a bad idea. We're better off using classes to style our content.

We can add and remove classes pretty easily in jQuery.

```js
$('.federalist').addClass('red');
$('.federalist').removeClass('red');
```

Keeping track of state is hard. jQuery is here to help.

```js
$('.federalist').hasClass('federalist'); // Returns true, obviously.
```

The other option is to use `toggleClass`, which will either add or remove the class depending on whether or not the class currently exists.

```js
$('.federalist').toggleClass('red');
```

## Exercise, Part Two: Style the Presidents

* Add the class of `red` to all of the Republicans.
* Add the class of `blue` to all of the Democrats.
* Add the class of `yellow` to the term column of the table.
* Take all the whig presidents and give them a purple background and white text.

(This should take 10 minutes.)

## Lecture, Part Three: Filtering and Traversal

Let's talk about a few [DOM traversal methods](http://api.jquery.com/category/traversing/tree-traversal/).

Here are some of the all-stars of the DOM traversing world:

* `find()`
* `parent()`
* `parents()`
* `children()`
* `siblings()`
* `end()`

## Exercise, Part Three: One-Term Presidents

* Add the `green` class to anyone who served right after a president who died.
* Find all of the presidents who only served one term and add the class `red`.
* Add the class of `blue` to the parent of a checked checkbox.
* Add the class of `yellow` to the siblings of the parent (`td`, in this case) of an unchecked checkbox.

## Lecture, Part Four: Adding to the DOM

Let's take a look at four approaches of adding/changing content in the DOM.

* `.text()`
* `.html()`
* `.append()`
* `.appendTo()`

## Exercise, Part Four: Dead Presidents

* Find all of the presidents who died in office (hint: they have a `died` class on their `tr`).
* Append `<span class="died">(Died)<span>` to the the `term` column.

## Lecture, Part Five: Simple Event Binding

Let's start by looking at the [jQuery Events API](http://api.jquery.com/category/events/).

The Events API tends to mimic the native DOM events, but with some abstraction to standardize across all of the browsers in use today.

Our main focus today is going to be on the `.on()` method. As of jQuery 1.7 and later, this is the preferred method for binding events. You may see `.bind()` as well, but this support older code.

Talking points:

* Talk about `this` in an event handler.
* Bind a `console.log` to a checkbox.

Let's take a look at [this simple form](http://jsbin.com/basolo/). Right now, it doesn't work. Let's wire it up together.

## Exercise, Part Five:

* Add an event handler to all of the checkboxes that when the box is checked, adds the `yellow` class to the `tr`.
* Add an event handler that adds the `red` class to a `td` element when it's clicked on.
* Modify the event handler above to remove the `red` class when it is clicked a second time.
* **Bonus**: Add a new `div` to the page, every time a checkbox is checked, add that presidents name to the `div`.
* **Bonus 2**: Remove that presidents name when the box is unchecked.
