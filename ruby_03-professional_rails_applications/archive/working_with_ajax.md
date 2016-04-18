---
title: Working with Ajax
length: 120 - 180
tags: javascript, ajax, apis, front-end
---

## Learning Goals

* Understanding what is Ajax and why is important
* Using Ajax to make API calls to access a third-party API
* Replacing the data in the DOM without refreshing the page

## Structure

* 5 - Lecture: What is Ajax
* 5 - Lecture: A brief history of Ajax
* 5 - Lecture: How does Ajax work with jQuery
* 5 - Lecture: Ajax and front-end development
* 5 - Break
* 15 - Code Along: Fetching third-party data on load
* 15 - Code Along: Creating data on a third-party service and update the DOM without refreshing the page
* 10 - Workshop 1
* 5 - Break
* 15 - Workshop Review
* 15 - Code Along: Deleting data and removing elements from the DOM
* 5 - Break
* 10 - Workshop 2
* 15 - Workshop Review
* 5 - Recap

## Repository

* Birdeck - https://github.com/turingschool-examples/birdeck.git
* Birdie (third-party API)
  * Repo - https://github.com/turingschool-examples/birdie
  * Heroku - https://birdeck.herokuapp.com

## Procedure

1. Lecture: What is AJAX
2. Lecture: How does it work with JavaScript
3. Lecture: How does it work with jQuery
4. Diagram: Overall structure of the app
5. Add GET example
6. Add POST example
7. Workshop 1
8. Workshop Review
9. Add DELETE example
10. Workshop 2
11. Workshop Review

## Workshops

### Workshop 1: Refresh

1. Right now, you have to reload the page to get the new posts. Can you modify your app so that the posts are reloaded when you click a button?
2. Right now, there is some duplication when we render the template, can you refactor?

### Workshop 2: Polling & PUT

1. Right now, you have to click on a button to refresh the feed. Can you check the server every 5 seconds to see if there are any new posts?
2. Can you implement a PUT option to modify the data via AJAX?

## Supporting Materials

*[Notes](https://www.dropbox.com/s/bikkpsmenjwtlag/Turing%20-%20Working%20with%20AJAX.pages?dl=0)
* [Video 1502](https://vimeo.com/131025914)
