---
title: Ember Fundamentals
length: 120
tags: javascript, ember
status: draft
---

## Learning Goals

* Understand how Ember's object model works
* Create two-way data bindings
* Implement computed properties on the controller level

## Structure

* 5 - Warm Up
* 15 - Lecture: Introduction to Ember
* 25 - Lecture: The Ember Object Model
* 5 - Break
* 10 - Code Along
* 30 - Pair Practice
* 25 - Recap and Refactor
* 5 - Wrap Up

## Resources

* [Good Tipper][goodtipper]

[goodtipper]: https://github.com/turingschool-examples/good-tipper

## Warm Up

Make sure you have all of the following installed:

* [Node.js](http://nodejs.org)
* [ember-cli](http://www.ember-cli.com/) (You made need to use `sudo` depending on how your environment is configured.)
* The [Ember Inspector](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)

Also: Clone a copy of [this repository][goodtipper]. We'll be using it during the Code-Along and Pair Practice segments of the lesson.

## Lecture

We'll cover the following topics:

* What Ember actually is and does
* It's history and lineage
* The technology that makes up Ember (Handlebars, Ember Metal, RSVP)
* The tooling around Ember (the Ember Inspector, ember-cli, Ember Data)
* The Ember object model
  * Classes and instances
  * Initializing an object (and calling `this._super()`)
  * Computer properties
  * Observers
  * Working with arrays
  * Bindings

## Workshop

### Code Along

We're going to implement the basic functionality of [Good Tipper][goodtipper]. Follow along!

### Pair Practice

Can you add any of the following to your application?

* A function that observes the tip price and displays a message when someone is being a cheapskate?
* Presets calculations for 15%, 18%, and 20%. When the user clicks a button, the tip percentage is automatically set to that amount.
* Automatic calculations for 15%, 18%, and 20%. When the user enters an amount for the cost of the meal, they should automatically see these three values.
* **Challenge**: The user wants to be able to dial in an amount and a tip and save it to an array and see all of their recent meals in a table (bonus points if you store the data using `localStorage`).

## Wrap Up

What are some of the similarities between Ember's object models and Ruby's? Is there anything you like better? Is there anything you wish Ember stole from Ruby (and/or Rails)?
