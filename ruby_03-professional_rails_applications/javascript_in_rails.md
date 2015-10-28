---
title: Javascript in Rails
length: 60-90
tags: javascript, rails, asset pipeline
---

## Learning Goals

Students will understand…

* Why you probably shouldn't write your JavaScript in the views
* How to structure their JavaScript code in a Rails project
* How the Asset Pipeline loads JavaScript and how it prepares it for production
* Exposing data from Rails in the DOM using `data` attributes

## Lecture

The following are a few of Steve's golden rules of using JavaScript in your Rails applications:

* Keep Your JavaScript Out of Your View
* Prefer Small Files
* Prefer Data Attributes for Storing Information (If You Need To)
* Try Not to Store Information in the DOM

We're going to cover the first three of those today.

### Keep Your JavaScript Out of Your View

It might be tempting to write your JavaScript in the view that needs it. Here is a bad example:

```html
<div>
  <h2>Panic Button</h2>
  <button class="panic">Don't press me!</button>
</div>

<script>
  $('.panic').on('click', function () {
    alert('Now you have gone and done it.');
  });
</script>
```

Instead, it makes way more sense to refactor this out into its own JavaScript file in `app/assets/javascripts`. There are a few advantages to this approach:

* In production, the Asset Pipeline will minify your JavaScript files, which optimizes them for faster downloading.
* The browser will cache JavaScript files. So, you will not need to reload this code each time a user visits the page.

Instead, consider the following in your ERB file:

```html
<div>
  <h2>Panic Button</h2>
  <button class="panic">Don't press me!</button>
</div>
```

We'll move the JavaScript to `app/assets/javascripts/panic.js`:

```js
$(document).ready(function () {
  $('.panic').on('click', function () {
    alert('Now you have gone and done it.');
  });
});
```

### Prefer Small Files

As your application grows, it's likely that the amount of JavaScript will grow as well. Rails pushes you to break up your code into small, manageable files.

If you use generators, then it will create a small file for each controller you create. These files don't actually matter. Rails will just concatenate all of your assets together anyway. The names of the files aren't important. Make small files that isolate what you're doing in each file.

```
assets
|____images
| |____.keep
|____javascripts
| |____add-new-robot.js
| |____application.js
| |____edit-robot.js
| |____filter-robots-by-category.js
| |____robots.js
| |____search-robots.js
| |____track-users-every-move.js
|____stylesheets
| |____application.css.scss
```

The alternative is a 400 lines JavaScript file. This makes it hard to find what you're looking for. You are also more than welcome to use subdirectories.

### Prefer Data Attributes to Storing Information in Classes or Content

(This isn't really one of Steve's golden rules. There is a much better way to do this that we'll talk about in Module 4.)

Let's say you have some data about your model that you need to work with in your JavaScript. Some how, some way, you're going to need to hand this data off from your Rails application to your JavaScript.

For fun, we'll assume it's the model's `id` and that we want to show an alert whenever they click the panic button on a given blog post.

You might be tempted to put this information in the `class` or `id`.

```html
<div class="post post-15" id="15">
  <button class="panic">Panic!</button>
</div>
```

If we put it in the class, then we'd have to use some regular expression trickery to get it back you. In valid HTML, only one element can have a given `id`, so we might end up with duplicates.

You could also try to put the model's `id` in the content and go traversing around the DOM looking for it, but that's also more trouble than it ought to be.

In HTML5, we have a special feature called "data attributes", which allow us to define custom attributes on an element. All of these custom attributes must be prefixed with `data-`.

Consider the following:

```html
<div class="post" data-id="15">
  <button class="panic">Panic!</button>
</div>
```

We chose `data-id`, but we could also use `data-sandwich` if that made more sense for us (it doesn't).

jQuery makes it easy to get the value of a data attribute using the `data()` method.

```js
$('.panic').on('click', function () {
  var id = $(this).parent().data('id');
  alert('You clicked on ' + id + '.');
});
```

If you decided you really were going to go along with `data-sandwich`, then you would get the value for that key with `$(this).parent().data('sandwich');`.

### Code Along

Let's look at the [Book of Faces](https://github.com/turingschool-examples/book_of_faces).

As a group, we'll re-implement a filtering feature from Module 2 based on department following the golden rules above.

### Code Along

Next we'll implement the ability to search for a given robot by name on every key stroke. In this example, we'll use the content in the `<h3>` tag.

We'll complete the following steps:

* Bind an event to the search box that files a function on `keyup`
* When the event fires, get the `val()` of the input element
* Iterate through all of the robots and look at its `<h3>`
* If the `<h3>` contains part of the search term, show it
* Otherwise hide it

## Resources

* [Slides](https://www.dropbox.com/s/bdnyf4o772374gz/Javascript%20in%20Rails.key?dl=0)
