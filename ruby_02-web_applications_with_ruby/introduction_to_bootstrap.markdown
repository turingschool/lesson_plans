---
title: Introduction to Bootstrap
length: 180
tags: bootstrap, css
---

## Learning Goals

* We will be working with [this](https://github.com/carmer/intro_to_bootstrap) repo
* Understand what Bootstrap is and its capabilities.
* Learn how to get started with the Bootstrap files and understand how to use
the the file and CDN versions.
* Understand the grid system
* Learn how adding classes to an element can change it.
* Learn how to use the Bootstrap documentation to solve issues.
* Understand the container.
* Understand how to use glyphicons.


## Understanding Bootstrap

* HTML provides our Page Structure.
* CSS provides Element Styling.
* JavaSript provides Page Behavior
* A framework is a library that can help with adding style and behavior to
our website.
* Bootstrap is the most popular framework for this.
* A list of all the classes is available [here](http://getbootstrap.com/css/)

## What can Bootstrap do?

* It reduces the amount of CSS and Javascript that we have to write.
* It's great for letting us write responsive web pages. Go to 
the [Turtle Pizza Site](http://turtlepizza.herokuapp.com/menu) and resize the webpage. See
how things change to adapt to the window size?
* It does this by providing us a CSS file and JavaScript file that we use.

## How can I get Bootstrap?

* Easiest way is to download it [here](http://getbootstrap.com/getting-started/#download)
* Compiled and minified means that it's been made human unreadable to get
the file size as small as possible, allowing it to be downloaded quickly.
* We'll be using the provided CSS files, and we also have a fonts folder.
* There's a free font called glyphicons, which is a font made up of symbols
that we can use in our website.
* The JS folder contains JavaScript that allows us to add behaviors.

## How do I install Bootstrap?

* Create an html file in the base of your Bootstrap directory.
* Add this: `<link href='css/bootstrap.css' rel='stylesheet'>`
* That link tag should be in the `<head>` section.
* We are including the Bootstrap CSS file using a relative path.
* Next, we have to add the jQuery library, which Bootstrap depends on.
* We should add the tag to the bottom of our `<body>`.
* `<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>`
* `<script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>`
* Next, we have to add the Bootstrap JavaScript library below the jQuery tags.
* `<script src='js/bootstrap.js'></script>`

## First things first, the container class.

* Our site is pretty ugly still. First step is adding a container class.
* A container is a fixed with element that responds to the size of the current
window.
* It adds margins, centers, and wraps our content so it's a little bit nicer.
* You add a `<div>` with the class of container to all of your content.
* By giving it a class of container, you are using the pre-written CSS
of Bootstrap.

## Container-fluid

* What if we wanted things to stretch across the page on larger screens?
* We use the `container-fluid` class.
* Let's wrap our `<h3>` tags in a div using the `container-fluid` class.

## The Grid System

* How can we use more of our horizontal space?
* Think of our site as a set of rows of data.
* Right now, we can think of our site as having five rows.
* Columns are vertical groupings of data.
* Right now, there's only one column. With just one column, we're
not using all of the horizontal space available to us.
* Bootstrap automatically gives us 12 columns to work with. Right now,
we are using all of them together.

* ![12 Columns](http://i.imgur.com/uppvUlG.png)

* It can get complicated.
* Use the `col-md-*` class, replacing the * with how many columns you want
that particular piece to take up.
* md represents a medium sized screen such as a laptop. md is a good starting point.
* We want the header to use a single page-wide column, so we would give it a new
`<div>` with the class of `col-md-12`.
* The next bit we can give a class of `col-md-6` since we want two columns.
* Finally, we can organize things a bit more using the `row` class.


* ![12 Column Possible Layouts](http://i.imgur.com/OVeWtxX.png)

## Glyphicons

* Bootstrap comes with over 200 icons to use.
* .woff is used by most modern browsers, but the other files are there
just in case someone is using an older browser.
* We can use the `<i>` tag to use glyphicons.
* `<i class='glyphicon glyphicon-hourglass'>`
* The first class lets us know we're using the glyphicon font family.
* The second class lets us know which icon to display.

## Tables and Documentation

* Let's check out `table.html`
* Ugh that's one ugly table.
* How can we figure out how to make this table less ugly?
* [Bootstrap Docs](http://getbootstrap.com/css/)
* Can you make this prettier?
* Can you make each alternating row of the table striped?
* Can you make it bordered as well?
* What if you wanted a row to be highlighted when you hover your cursor over it?
* How can you give an individual row a special color?

## Workshop

* In the repo, you have been given a raw.html file and a screenshot. Using bootstrap, and adding
in the appropriate classes, try to recreate the screenshot.

## Homework

* For homework tonight. add some Boostrap to your Task Manager.
* Have some fun with the things you can do with it.
