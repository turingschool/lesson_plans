---
title: Introduction to jQuery
length: 60
tags: jquery, javascript
---

## Learning Goals

* define jQuery and identify use cases
* implement basic jQuery methods and event handlers
* use jQuery to implement a set of specifications
* filter collections using jQuery

## Full-Group Instruction

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

```javascript
$("#some-div li") // find the li within #some-div
```
##### Common Event Handlers

```
$("selector").click(function(){
  // some code here
});
```

```
$("selector").mouseenter(function(){
  // some code here
});
```

```
$("selector").hover(function(){
  // some code here
});
```

See more event methods in the [jQuery event documentation](http://api.jquery.com/category/events/).

#### Some cool methods

* $("selector").text() # get text back
* $("selector").text("new text") # replace
* $("selector").hide()
* $("selector").toggle()
* $("selector").addClass('class-name')
* $("selector").removeClass('class-name')
* $("selector").toggleClass('class-name')
* $("selector").append('\<h1>hey!\</h1>')
* $("selector").prepend('\<h1>hey!\</h1>')
* $("selector").find("other-selector")
* $("selector").fadeToggle(1000)
* $("selector").slideToggle(1000)
* $("selector").css('property', value)
* $('selector').animate({  
		    opacity: 0.25,  
		    left: "+=500",  
		  }, 3000);
* $( "selector" ).click(function() {
	  $( "selector" ).animate({
	    width: "70%",
	    opacity: 0.4,
	    marginLeft: "0.6in",
	    fontSize: "3em",
	    borderWidth: "10px"
	  }, 1000 );
	});

#### Let's take a trip to the jQuery playground!

Clone down the [jQuery Playground](https://github.com/rwarbelow/jQuery-playground).

* basic-jQuery
* rails-jQuery
* book_of_faces

#### Together

We are going to make a song appear and disappear.
We are going to count the number of views that a song has.

#### Workshop #1

Can you add the same functionality to the other songs?
Can you change the color of the text when you click the colorize button?
There is some repetition. Can you create a function that encapsulates that logic?

#### Workshop #2

Fix the counter so that it only counts the times the song is being displayed.
Can you make the text bigger when the text + button is clicked?
Can you make the text smaller when the text - button is clicked?
Can you add a new feature to your fancycle site using jQuery?

## Wrap-Up

* Finished code
* Questions?

## Further Resources

* [jQuery documentation](http://api.jquery.com/)
* [Try jQuery from CodeSchool](https://try.jquery.com)
