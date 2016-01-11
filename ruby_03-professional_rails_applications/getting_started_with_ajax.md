---
title: Getting Started With Ajax
length: 180
tags: JavaScript, AJAX, APIs, front-end
---

### Goals

By the end of this lesson, you will know/be able to:

* Make all CRUD functionality AJAX calls.
* Access APIs through all client side JavaScript.
* Dynamically change content on a webpage without reloading the page.
* Explain the difference between client-side and server-side.

### Structure

* 25 - Read and Teach
* 5 - Break
* 5 - Review
* 20 - Code Along - AJAX basics - GET
* 5 - Break
* 25 - Code Along - AJAX - POST DELETE
* 5 - Break
* 5 - Code Along Review
* 20 - Workshop 1: Refresh
* 5 - Break
* 25 - Workshop 2: Polling and Put
* 5 - Break
* 25 - Finish up and Review

#### Why AJAX?

* UX and User Perception
* Client Side interactions - voting, polling, rating, interact with HTML elements, auto-complete, nearly instantaneous loading


### Reading

* [1s - AJAX: History](http://www.phpasks.com/articles/historyajax.html)
* [1s - More AJAX History](http://www.softwareengineerinsider.com/programming-languages/ajax.html#context/api/listings/prefilter)
* [2s - Client Side vs Server Side](http://www.codeconquest.com/website/client-side-vs-server-side/)
* [2s - More Client Side vs Server Side](http://skillcrush.com/2012/07/30/client-side-vs-server-side/)


### Checks for Understanding

* What does AJAX stand for?
* What is the difference between client side and server side?
* What is the main reason we use AJAX?


### Repository

* Birdeck - https://github.com/turingschool-examples/birdeck.git
* Birdie (third-party API)
  * Repo - https://github.com/turingschool-examples/birdie
  * Heroku - https://turing-birdie.herokuapp.com

## Workshops

### Workshop 1: Refresh

1. Right now, you have to reload the page to get the new posts. Can you modify your app so that the posts are reloaded when you click a button?
2. Right now, there is some duplication when we render the template, can you refactor?

### Workshop 2: Polling & PUT

1. Right now, you have to click on a button to refresh the feed. Can you check the server every 5 seconds to see if there are any new posts?
2. Can you implement a PUT option to modify the data via AJAX?

### Additional Resources

* [How to use $.ajax()](http://www.sitepoint.com/use-jquerys-ajax-function/)
* [Basics of Jquery AJAX](http://www.i-programmer.info/programming/jquery/8895-getting-started-with-jquery-ajax-the-basics.html)
* [jQuery Promises and Deferred](http://www.i-programmer.info/programming/jquery/4788-jquery-promises-a-deferred.html)

### Video

* [Video](https://vimeo.com/131025914)
