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

* 9:05 - 5 - Intro
* 9:15 - 10 - Lecture 1: Selectors
* 9:25 - 10 - Exercise 1: Basic Selectors with the President
* 9:30 - 5 - Exercise Review
* 9:35 - 5 - Break
* 9:50 - 15 - Lecture 2: Manipulating CSS
* 10:00 - 10 - Exercise 2: Painting the Presidents
* 10:05 - 5 - Exercise Review
* 10:10 - 5 - Break
* 10:25 - 15 - Lecture 3: Filtering and Traversal
* 10:40 - 15 - Exercise 3: One-Term Presidents
* 10:45 - 5 - Exercise Review
* 10:55 - 10 - Break
* 11:05 - 10 - Lecture 4: Appending to the DOM
* 11:20 - 15 - Exercise 4: Dead Presidents
* 11:25 - 5 - Exercise Review
* 11:30 - 5 - Break
* 11:40 - 10 - Lecture 5: Events
* 11:55 - 15 - Exercise 5: Event Responder
* 12:00 - 5 - Exercise Review: Wrap Up

## Intro to the DOM

DOM stands for Document Object Model. The browser uses it to represent everything on the page. It's an "object model" because it is made of objects. Each element is an object. If you wanted to, you could directly translate the DOM to a javascript object.

The DOM is hierarchical. If you have a tag wrapping another tag, then the inner object is a child of the outer object, which is the parent.

```html
<ol>                <!-- parent -->
  <li>First</li>    <!-- child  -->
  <li>Second</li>   <!-- child  -->
</ol>

```

The browser creates the DOM by reading from HTML, but from then on, javascript controls any changes to the DOM.

```
HTML --> DOM <--> JS
```

## Lecture, Part One: Selectors

### Basic Selectors

Out of the box, jQuery supports the selector syntax from CSS to find elements on the page. So, you already come pre-equipped with a bunch of knowledge for finding elements.

That said, let's review some of the different ways we can find an element on page.

* `$('p')`, selects all of a given element.
* `$('#heading')`, selects the element with a given id.
* `$('.important')`, selects all of the elements with a given class.

You can also use multiple selectors in the same statement:

* `$('p, #heading, .important')`, selects everything listed above.

### Chaining Selectors

There are a few different ways to chain selectors to use them together. You can seperate these selectors with a comma, a space, or nothing at all.

* Comma: `$('p, #heading, .important')` just combines all of the selectors together.
* Space: `$('p #heading .important')` treats each selector as a child of the previous. This will give you items of the class `important` that are children of the id `heading` which are inside a `<p>` tag.
* Nothing: * `$('p#heading.important')` matches elements that have all three selectors. This selector would select a paragraph which was defined like this: `<p id="heading" class="important">`

### Attribute Selectors

See the API documentation [here](http://api.jquery.com/category/selectors/attribute-selectors/).

### Laboratory

[Here is an little experiment][exp] where you can play around and try out some different selectors.

Play around with this on your own for a bit.

[exp]: http://codylindley.com/jqueryselectors/

## Exercise, Part One: The Presidents

For this exercise, we're going to play with [a table of the Presidents of the United States of America](https://gist.github.com/neight-allen/a49b8caa02d127a3a3fcf409eea3ed14).

```
git clone https://gist.github.com/a49b8caa02d127a3a3fcf409eea3ed14.git jquery_lesson
```

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

## Exercise, Part Three: One-Term Presidents

* Add the `green` class to anyone who served right after a president who died.
* Find all of the presidents who only served one term and add the class `red`.
* Add the class of `blue` to the parent of a checked checkbox.
* Add the class of `yellow` to the siblings of the parent (`td`, in this case) of an unchecked checkbox.

## Lecture, Part Four: Adding to the DOM

Let's take a look at some approaches of adding/changing content in the DOM.

* `.text()`
* `.html()`
* `.append()`
* `.prepend()`

## Exercise, Part Four: Dead Presidents

* Find all of the presidents who died in office (hint: they have a `died` class on their `tr`).
* Append `<span class="died">(Died)<span>` to the the `term` column of presidents who have `.died`.
* **Bonus**: Add a radio button before the number in each row.

## Lecture, Part Five: Simple Event Binding

### Event Driven Programming

Event driven programming relies on some external action to determine how the program behaves. Some external actor (a user or another computer) takes an action, and your program responds.

You've done event driven programming before. Can you think of projects that use this pattern?

### Event binding using jQuery

Let's start by looking at the [jQuery Events API](http://api.jquery.com/category/events/).

The Events API tends to mimic the native DOM events, but with some abstraction to standardize across all of the browsers in use today.

Our main focus today is going to be on the `.on()` method. As of jQuery 1.7 and later, this is the preferred method for binding events. You may see `.bind()` as well, but this support older code.

Talking points:

* Talk about `this` in an event handler.
* Bind a `console.log` to a checkbox.
* Inline handlers vs named functions

## Exercise, Part Five

As pairs, try to work through the following prompts. We'll do the first one together.

* Add an event handler to all of the checkboxes that when the box is checked, adds the `yellow` class to the parent `tr`.
* Add an event handler that adds the `red` class to a `td` element when it's clicked on.
* Modify the event handler above to remove the `red` class when it is clicked a second time.
* **Bonus**: Add a new `div` to the page, every time a checkbox is checked, add that president's name to the `div`.
* **Bonus 2**: Remove that president's name when the box is unchecked.

## Exercise, Part Six

Let's take a look at [this simple form](http://output.jsbin.com/jezomug/1). Right now, it doesn't work. I'm going to need your help to wire this up.

1.  First, how could I select all `input`s?
2.  How could I use jQuery to fill in the value for the `.link-title`?
3.  How could I use jQuery to fill in the value for the `.link-url`?
4.  How could I click the submit button from my console?

Let's hop out of the console and actually edit the JS now.

5.  Capture the `on submit` event for the submit button?
6.  On submit, let's get the value of the inputs?
7.  Now let's append those values under `My Links`
