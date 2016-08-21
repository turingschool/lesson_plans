---
title: Introduction to CSS Frameworks
length: 180
tags: bootstrap, css
---

###  Goals

By the end of this lesson, you will know/be able to:

* Understand what responsive web design is.
* Have a basic understanding of Bootstrap and its capabilities.
* Learn how adding classes to an element can change it.
* Learn how to use the Bootstrap documentation to solve issues.
* Understand the container.
* Understand how to use glyphicons.
* Understand the grid system of CSS Frameworks.
* Be able to translate this knowledge to other CSS Frameworks including,
but not limited to Skeleton, Materialize and Foundation.
* We will be using this [repository](http://github.com/mikedao/intro-to-bootstrap)

## Gauging Understanding - Ask In Slack to Respond from 1 - 10

* I am comfortable writing CSS.
* I am comfortable writing HTML.

## Introduction to Responsive Web Design

* Let us (rhetorically) ask the question, "What is Responsive Web Design?"
* Have the students pull up the personal website that they built over
intermission week.
* Open up the Chrome Developer Tools with Command + Option + I.
* The Chrome Dev Tools allows us to preview what a website would look like
using a number of different devices.
* Click on the phone icon at the top of the developer tools next to the
Elements button.
* We can now see what the page looks like at any resolution, in addition
to any device.
* From the device drop down, pick a device. Pick several. Alternate
between portrait and landscape modes by clicking the change orientation
button.
* If you'd like to see what a more responsive site looks like, there is
[Turtle Pizza](http://turtlepizza.herokuapp.com/menu).
* The challenge here is that we need to be able to write webpages once,
but have them work on potentially dozens of dozens of devices, at different
resolutions.
* Some really smart people came up with how to do this using CSS.
* This is not something we can really do on our own, so people have made
CSS Frameworks for us to use.
* We're first going to talk about Bootstrap, because it's the most popular
framework in use, and learning how to use it will translate and allow you
to figure out how to use other CSS frameworks.

## Web Pages and CSS Frameworks

* HTML provides our Page Structure.
* CSS provides Element Styling.
* JavaSript provides Page Behavior (sometimes css too!)
* A framework is a library that can help with adding style and behavior to
our website. Not only can using a CSS framework give us the responsiveness
we need, it also gives us some free styling tools.
* We are going to start with how to implement basic Bootstrap functionality
and then moving on towards making it responsive.
* A list of all the classes is available [here](http://getbootstrap.com/css/)
in the documentation.

## What do we get with Bootstrap?

* It reduces the amount of CSS and Javascript that we have to write.
* It does this by providing us a CSS file and JavaScript file that we use.


## How can I get Bootstrap?

* Easiest way is to download it [here](http://getbootstrap.com/getting-started/#download)
* If we don't want to download files, we can also use the CDN (Content
Delivery Network) version. Instructions on how to do so are on the
Bootstrap site.
* Compiled and minified means that it's been made human unreadable to get
the file size as small as possible, allowing it to be downloaded quickly.
* We'll be using the provided CSS files, and we also have a fonts folder.
* There's a free font called glyphicons, which is a font made up of symbols
that we can use in our website.
* The JS folder contains JavaScript that allows us to add behaviors.

## Check for Understanding

* What is responsive web design and why should we build responsive sites?
* What is a CSS Framework?

## How do I install Bootstrap?

* Create an html file in the base of your Bootstrap directory.
* Let's put some text in the body and lets put it in H3 tags.
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
* A container is a fixed width element that responds to the size of the current
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

* This is where we start getting responsive.
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

* For homework tonight, add some Bootstrap to your Task Manager. Check [here](https://gist.github.com/rwarbelow/da3ef21480b704305e68) for instructions on how to set up a layout with a stylesheet.
* Have some fun with the things you can do with it.
