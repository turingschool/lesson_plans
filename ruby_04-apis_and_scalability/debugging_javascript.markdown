---
title: Debugging JavaScript
length: 60
tags: console, javascript, debugging
---

### Goals

By the end of this lesson, you will know/be able to:

* use `debugger` and `console` to peek into your JavaScript code in action
* be familiar with helpful features of Chrome's developer tools

### Structure

* Code-along

### Intro

Client side JavaScript has a lot of ways it can go horribly, horribly wrong. For starters, Browsers execute JavaScript with different engines, and not all interpretations are exactly the same.

MORE WORDS HERE PROBABLY

### Basic Introduction to Developer tools

All major web browsers have implemented a version of Developer Tools. For this lesson, we'll focus on Chrome's Developer Tools.

### Navigating Dev Tools
* Open Dev Tools
  * On a mac use: `Cmd` + `Opt` + `I`
	* OR right click on the mouse anywhere in the browser and select Inspect
	* OR select `View` in the navbar, open `Developer` and select `Developer Tools`

* You can also pin the tools to top or right
* ... and break them out into their own window
![navigating](http://g.recordit.co/L8euYRVfrA.gif)

### Using the Console

![console](assets/debug-console.png)

The Console tab in Chrome DevTools is probably the tab you are most familiar with. It keeps a log of every message posted to it, including errors, so it's the first place we look when something with our application goes wrong.

You can also use the Console to try things out.

- Navigate to the [Rails Github page](https://github.com/rails/rails)
- Open Chrome DevTools and click the Console tab
- Type `$`

You should see:

```js
  function (e,t){return new Q.fn.init(e,t)}
```

The console in DevTools has access to all the JavaScript included in the website that you're viewing. By inputting `$`, we can verify that Github uses jQuery and has it assigned to `$`

- Now, copy and paste the following code into the console.

```js
  $('.author').replaceWith(
    '<a href="www.github.com/rrgayhart">meeka</a>'
  )
```

![console](assets/debug-wrote-rails.png)

Excellent.

##### The Console API

As mentioned above, the console keeps track of all messages posted to it. The Console API is a collection of methods provided by the global `console` object, which is defined by browsers, as a way to output things into the console.

The most commonly used command is:

###### console.log()

`console.log()` is a statement that takes ones or more expressions and writes their current values to the console.

```javascript
$('#myButton').click(function(){
  console.log("I clicked a button at:", Date.now());
});
```

![console](assets/debug-log.png)

There are other, neat methods on `console`. Try out the following examples in your console...

###### console.table

```javascript
var browsers = [
	{ name: "Internet Explorer", vendor: "Microsoft", version: "11" },
	{ name: "Chrome", vendor: "Google", version: "31" },
	{ name: "Firefox", vendor: "Mozilla", version: "26" },
	{ name: "Safari", vendor: "Apple", version: "7" },
	{ name: "Opera", vendor: "Opera", version: "18" }
];

console.table( browsers );
```
[example source](http://www.sitepoint.com/three-little-known-development-console-api-methods/)

###### console.assert

```javascript
  console.assert(document.querySelector('.catz'), "Missing 'catz' class")
```

[To Learn More Methods](https://github.com/DeveloperToolsWG/console-object/blob/master/api.md)

### Using the Elements tab

The Elements tab of DevTools allows you to view, inspect, and temporarily change the structured HTML markup, CSS, event listeners and etc of a given website.

![console](assets/debug-elements.png)

	* Inspecting elements
	* Computed styles
	* Forcing element state

  ![chachachachanges](http://g.recordit.co/hqKRaFSCAV.gif)

[Learn More Here](https://developer.chrome.com/devtools/docs/dom-and-styles)

### Using the Sources Tab

![console](assets/debug-sources.png)

The sources tab allows you to see source files for a website and set breakpoints in your javascript code.

![using the sources](http://g.recordit.co/W9zWeVG5aq.gif)

As the demo above shows, you can set breakpoints from the browser. You can also use the command `debugger` anywhere in your client-side code to trigger a breakpoint when the debugger is hit.

Breakpoints cause the code to stop in place, which allows you see and play around with the code in the exact state where the breakpoint was hit.

Another excellent trick is using Pause on Caught Exceptions.

* Pause on Caught Exception
  ![howitlooks](http://i.stack.imgur.com/ItvZj.png)

Doing this will tell the browser to set a breakpoint anywhere that something goes 'wrong' in your code, but where the exception was caught and didn't show an error.

It's fun doing this on websites you didn't write...

### Step 4: Using the Network tab

* Network performance
	* Debugging AJAX

### Step 5: Responsive Mode
* Responsive Mode

### Step 6: Debugging Non-Client Side Code

`debugger` won't always work for you when you leave the client-side JS world.

When you get to Node, check out the [Node debugger](https://nodejs.org/api/debugger.html).


### Other Resources
- https://developer.chrome.com/devtools/docs/javascript-debugging
- http://discover-devtools.codeschool.com/
