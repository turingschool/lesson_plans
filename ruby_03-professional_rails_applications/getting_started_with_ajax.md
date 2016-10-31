---
title: Getting Started With Ajax
length: 180
tags: JavaScript, AJAX, APIs, front-end
---

### Goals

By the end of this lesson, you will know/be able to:

*   Make all CRUD functionality AJAX calls.
*   Access APIs through all client side JavaScript.
*   Dynamically change content on a webpage without reloading the page.
*   Explain the difference between client-side and server-side.

#### Why AJAX?

*   UX and User Perception
*   Client Side interactions - voting, polling, rating, interact with HTML elements, auto-complete, nearly instantaneous loading

## AJAX Discussion

-   What does AJAX stand for?
-   Explaining asynchronous vs synchronous
-   What is it used for? Where is it used?
-   Client vs. Server

<!-- ### Reading

*   [1s - AJAX: History](http://www.phpasks.com/articles/historyajax.html)
*   [1s - More AJAX History](http://www.softwareengineerinsider.com/programming-languages/ajax.html#context/api/listings/prefilter)
*   [2s - Client Side vs Server Side](http://www.codeconquest.com/website/client-side-vs-server-side/)
*   [2s - More Client Side vs Server Side](http://skillcrush.com/2012/07/30/client-side-vs-server-side/) -->

<!-- ### Checks for Understanding

*   What does AJAX stand for?
*   What is the difference between client side and server side?
*   What is the main reason we use AJAX? -->

## JavaScript Refresh

### Variables

Variables are declared with `var <variableName>` in `camelCase`. You may sometimes see `let` or `const` instead of `var` thanks to ECMAScript - don't worry about this.
Once a variable is declared

## Debugging in Javascript

Debugging JavaScript is a different beast than debugging Ruby. Because JS is run entirely in the browser, the technique for troubleshooting broken code is more complicated than `binding.pry`. Luckily, modern browsers are aware of this and give us a collection of options for digging into your code.

### 1. Developer Tools

One of the first things you should familiarize yourself with when working with JavaScript (or HTML...or CSS...) are the dev tools. You can find a cool tutorial to dive deeper with  [Code School's Discover-DevTools Tutorial.](http://discover-devtools.codeschool.com/) (Chapters 3 & 4 are particularly helpful)

To open developer tools in Chrome:
-   Mac: `Cmd` + `Opt` + `i` (or `Cmd` + `Opt` + `j`)
-   (or) Right click on the browser window and select `inspect`
-   (or) Select `View` in the navbar, then `Developer`, then `Developer Tools`

When working with JavaScript, it is useful to keep your console open at all times to watch for errors and anything you've told your code to print out. Bringing us to...

### 2. console.log()

`console.log()` is to JS what `puts` is to Ruby. This line of code will print whatever is provided as an argument to the console.

Given the following function called `printStuff()`, adding console.log() will print the value of `myVariable` to the console.

```js
var printStuff = function(){
  var myVariable = 5 + 5
  console.log(myVariable);
}

printStuff()
=> 10
```

If you're confused about what a variable or function is returning, throw `console.log()` into your code or directly into the `console` in your browser to confirm/deny suspicions.

### 3. Debugging In the Console

Debugger is the `pry` of JS. Stick `debugger;` within a function to pause the browser from running the script when it hits a particular part of your code.

```js
// index.js
$('#search-ideas').on('keyup', function() {
  var currentInput = this.value.toLowerCase();

  $ideas.each(function (index, idea) {
    var $idea = $(idea);
    var $ideaContent = $idea.find('.content').text().toLowerCase();
    debugger;
  });
```

In the browser, if we open up the dev tools, navigate to the console and try to search for something.  The program will freeze on the line `debugger`. This lets us type stuff into our `console` to see what's going on.

*NOTE - The console must be open for debugger to catch, otherwise the app will look normal and you won't get any error messages - if you get stuck, refresh your page while the console is open and go from there.*

For more details and information about other ways to dig into your js, check out the [Chrome Documentation](https://developer.chrome.com/devtools/docs/javascript-debugging).

## AJAX CRUD

### Posts APIs

For this lesson, we'll use [Birdeck](https://github.com/turingschool-examples/birdie), a REST API with dummy JSON data. Our interactions with this API would be similar for any other REST API you'd work with down the road.

> As a refresher, REST simply refers to CRUD-ful routes you'd expect from an API (`get`, `show`, `create`, `update`, `delete`).

Please set up `Birdeck` by doing the following:

```bash
git clone git@github.com:turingschool-examples/birdie.git birdeck_api
bundle install
bundle exec rake db:setup
bundle exec rails server
```

### AJAX - `GET` Index Code Along

1.  Right now, our Birdeck client isn't loading in any posts from the our API. We'll want to change that to fetch posts on page load using jQuery's `$.ajax()`, but first, let's see what our data looks like in Postman.

```
GET http://localhost:3000/api/v1/posts
```

```js
// assets/javascripts/birdeck.js
var API = 'http://localhost:3000';

$(document).ready(function(){
  var getPosts = function() {
    return $.ajax({
      url: API + '/api/v1/posts',
      method: 'GET',
    }).done(function(data){
      for (var i = 0; i < data.length; i++) {
        $('#latest-posts').append('<p class="post">' + data[i].description + '</p>');
      }
    }).fail(function(error){
      console.error(err);
    });
  };

  // on page load
  getPosts();
});
```

2.  Let's modify our app to refresh posts when clicking the "Fetch Posts" buton.

### AJAX - SHOW Workshop

On your own, try getting a post by ID (aka, hitting a `show` endpoint).

### AJAX - POST Code Along

Let's set up our app to send an AJAX POST request to create a new post and update our feed with this new post all with one click of the "Create Post" button.

### AJAX - PUT Workshop

First, with your neighbor, discuss strategies for accomplishing this. Remember, you'll need to make sure you're collecting the ID and updated description of the post to be updated.

Then, on your own, implement a form to update a post by ID. On submit of this form, you should be using AJAX to PUT this update, as well as get an updated posts feed.

### AJAX - DELETE Workshop

You know the drill - let's delete a post by ID. Feel free to discuss approach again with your neighbor, but try to accomplish this on your own.

### Additional Resources

*   [How to use $.ajax()](http://www.sitepoint.com/use-jquerys-ajax-function/)
*   [Basics of Jquery AJAX](http://www.i-programmer.info/programming/jquery/8895-getting-started-with-jquery-ajax-the-basics.html)
*   [jQuery Promises and Deferred](http://www.i-programmer.info/programming/jquery/4788-jquery-promises-a-deferred.html)
*   [MDN AJAX](https://developer.mozilla.org/en-US/docs/AJAX)
*   [MDN Getting Started with AJAX](https://developer.mozilla.org/en-US/docs/AJAX/Getting_Started)
*   [jQuery $.ajax()](http://api.jquery.com/jquery.ajax/)

### Readings

*   [AJAX: History](http://www.phpasks.com/articles/historyajax.html)
*   [More AJAX History](http://www.softwareengineerinsider.com/programming-languages/ajax.html#context/api/listings/prefilter)
*   [Client Side vs Server Side](http://www.codeconquest.com/website/client-side-vs-server-side/)
*   [More Client Side vs Server Side](http://skillcrush.com/2012/07/30/client-side-vs-server-side/)

### Video

*   [Video](https://vimeo.com/131025914)
