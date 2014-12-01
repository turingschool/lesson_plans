---
title: Introduction to jQuery
length: 90
tags: jquery, javascript
---

## Learning Goals

* define jQuery and identify use cases
* implement basic jQuery methods and event handlers
* use jQuery to implement a set of specifications

## Full-Group Instruction

#### jQuery Demo

#### Important Words

* document object model (DOM)
* child-parent-sibling nodes (in HTML)

#### What is jQuery?

* lightweight JS library that makes it easier to implement JS functionality
* takes care of cross-browser compatibility 

#### Javascript

* language to interact with the DOM
* each browser has a slightly different JS interface
* jQuery can interact with all browsers

#### What can you do with jQuery?

* find HTML elements and content
* manipulate HTML content
* manipulate style (CSS)
* react to what a user does
* animate content
* fetch content using AJAX

#### jQuery basics

* index.html, style.css
* include source for jQuery
* \<script src="jquery.min.js"></script>
* \<script src="application.js"></script>
* order matters!
* need to make sure DOM is done loading before executing
* therefore, $(document).ready(function(){});

#### How to select elements in jQuery

* uses same selectors as CSS -- # for IDs, . for classes, and names for elements (div, p, li, h1, etc.)
* wrap selector in quotes
* $() means same as jQuery()
* $("div")
* $("#some-id")
* $(".some-class")

##### Descendant Selectors

$("#some-div li") -- find the li within #some-div

##### Common Event Handlers

* $("selector").click(function(){
	// some code here
});

* $("selector").mouseenter(function(){
	// some code here
});

* $("selector").hover(function(){
	// some code here
});

See more event methods in the [jQuery event documentation](http://api.jquery.com/category/events/).

#### Common methods

* $("selector").text # get value back
* $("selector").text("new text") # replace
* $("selector").hide()
* $("selector").toggle()
* $("selector").addClass('class-name')
* $("selector").removeClass('class-name')
* $("selector").toggleClass('class-name')
* $("selector").append('<h1>hey!</h1>')
* $("selector").prepend('<h1>hey!</h1>')
* $("selector").find("other-selector")
* $("selector").fadeToggle(1000)
* $("selector").slideToggle(1000)
* $("selector").css('property', value)
* $('#target').animate({
		    opacity: 0.25,
		    left: "+=500",
		  }, 5000, function() {
	  });

#### Let's take a trip to the jQuery playground!

Find the repo [here](#)

## Independent Challenge



## Wrap-Up

* Your questions

## Resources
