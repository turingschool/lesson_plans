---
title: How JavaScript Front-Ends Work
length: 60
tags: javascript, ember, backbone, jquery
status: draft
---

## Learning Goals

* Understand the limitations of DOM/selector-based web application development
* Understand the advantages of using a framework to separate data and logic from presentation

## Structure

* 5 - Warm Up
* 5 - A brief history of server-side web development
* 5 - A brief history of client-side web development
* 5 - Storing data in the DOM with jQuery
* 5 - Break
* 10 - Getting your data out of the DOM with Backbone
* 10 - When do you need a JavaScript framework?
* 10 - A whirlwind tour of some of the JavaScript frameworks
* 5 - Wrap Up

## Warm Up

1. In your opinion, what are of advantages of a framework (either client- or server-side)?
2. Over the past 24 weeks, you've built a number of complicated applications. What are some examples of the more complicated front-end interactions you or your group have tackled without a framework? How did you approach them?

## Lecture

### A Brief History

* Talk about the progression from writing an HTML file by hand, to using a bunch of gnarly `cgi-bin` scripts to add some small features (e.g. hit counter, guestbook), to building larger apps with spaghetti code, to the introduction of frameworks like Rails, Django, etc.
* Talk about the progression from static pages, to little scripts (e.g. DHTML), to building real applications like Gmail, to the need for frameworks.
* jQuery is a great DOM manipulation library. It papers over a number of browser inconsistencies and makes the DOM easy to work with. That said, in the face of growing complication jQuery is asked to do more than it ever promised. Managing event listeners and keeping the DOM up to date can become daunting. Furthermore, we end up storing out data in our views.
* Backbone introduced the idea of the separated your data from the DOM. It relies on events to trigger changes in a sane and sensible way. Backbone is incredibly lightweight and flexible—a lot like Sinatra.
* Angular self-describes as a framework for building frameworks. It popularized two-way data-bindings.
* Ember evolved out of Sproutcore and takes inspiration from Cocoa and Rails—as well as Angular and Backbone.
* React focuses on the view layer exclusively and uses something called the Virtual DOM and an algorithm to do the fastest possible updates.

### Some of the Advantages

- Fast response time once loaded
- Long-lived application

### Some of the Problems Front-End Frameworks Must Solve

- Initial load time
- Routing and getting the back button working
- Data modelling

## Wrap Up

1. Of the examples we shared during the warm-up, which pages could have been better solved using a framework?
2. If you've tried your hand at a framework in the past, did you really need it? Why or why not?

