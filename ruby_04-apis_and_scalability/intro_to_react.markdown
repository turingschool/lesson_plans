---
title: Intro to React.JS
length: 180
tags: javascript, front-end framework, react
---


## Background


### Overview -- Front-End Application Architectures

* __Problems:__ Browser applications becoming more and more
complex; numerous DOM Elements dependent on dynamic
data coming from servers or other sources
* __Frameworks:__ Like with any technical problem, the open source
decided to solve this with 

* Backbone
* 

### The Landscape - Front-End Application Architectures

Continuum:

small libraries vs. large frameworks
data / persistence management vs. view and interaction only
How to solve problem of integrating or separating UI/Presentation
layer from logic and interaction layer


* Backbone
* Ember
* Angular

### React's Take

__Analogy:__ GPU Programming

Part of the fundamental problem is that as the number of UI elements
we're dealing with grows, the complexity of keeping them up to date
and in sync with all the relevant data grows as well.

Imagine you were developing a modern video-game: You likely have numerous
in-game "objects" that interact with another as well as with the
game's landscape and environment, and ultimately all of these are getting
rendered onto a high resolution screen that could easily have millions of
pixels.


Suppose the player flips a switch in the game causing a light to turn on
somewhere in the environment. How do you handle updating the screen?
Do you seek out all the specific pixels which correspond to the light
and turn them on individually?

Probably not! But this is, in many ways, how front-end web technologies
have handled the problem of updating Browser-based User Interfaces in
response to user interactions.

Clicked a button? Hold on, let me find the dom element which corresponds
to the button you clicked and update its color.

Clicked a dropdown? Hold on, let me find the (currently hidden) chunk of
html which is associated with it and toggle it on.

And this is not to say that front-end developers are incompetent --
there are many reasons for doing things this way:

* it's relatively intuitive
* for much of the web's history, the amount of interactive elements
we've dealt with on a page were small and easy to track
* 

### So what's the alternative?

Think back to our video game example: we gave one example of
something we probably _wouldn't_ do. So how _would_ we handle
the situation?

As an alternative to trying to selectively re-draw portions
of the scene, we could take a more whole-hog approach: Just
re-draw everything.

Consider the benefits of this approach:

* Conceptually simpler: rendered scene is simply a product
of all the existing information about the world's state
* Conceptually consistent: every re-render follows the same process
(initial render is no different than subsequent updates)

But also consider the costs:

* Likely more computationally intensive; likely
to run into performance issues

### What does it mean for web development

In practice, this last difficulty has largely prevented
this approach from taking on in web development.

One of the perennial thorns in the side of browser developers
is the speed of updating the DOM. Whenever we want to, say,
add a CSS class to an element, the browser has to go through
an extensive "re-painting" process. With sufficient
numbers of DOM elements, this process can get slow enough
for the UI to feel sluggish and unusable.

By avoiding large swaths of updates (i.e. with the traditional
approach of updating small chunks of markup at a time), we
can avoid this problem and keep our browser-based
UI's snappy.

### Where does React come in?

React's big innovation is that it gives us a way to utilize
the "re-render the world" approach in the context of DOM manipulation.

Using React, we'll define __components__ -- individual pieces of our UI
in terms of the pieces of data they depend on. Then, we'll give each
component a key __render__ function, which tells React how to
re-generate the portion of the DOM controlled by that component
_in terms of its data._

Then, whenever anything changes, React can walk down the component tree,
re-rendering components in terms of their associated data (which may or may not have changed).

But what about the performance problems of DOM repaints?

React gets around this problem by implementing a separate, in-memory model
of the current DOM (called a "virtual DOM"). When things need to be re-rendered,
it can (very quickly) re-generate its virtual representation of the DOM. Then,
it actually uses an algorithm to isolate those elements that _actually changed_,
and sends real DOM updates to only those elements.

So when we said React allows us to continuously re-render the entire UI in response
to data changes, we were oversimplifying. In reality, React itself does end up
sending selective updates to the DOM.

However its internal implementation (using
a virtual representation of the DOM and a diffing algorithm) allows us, the developer,
to write our code as if the top-to-bottom re-render was actually occurring.

While the idea of a "virtual DOM" is an interesting and important implementation
detail, the fundamental shift toward a more functional and less imperative model
of UI programming is ultimately what makes React so interesting.

### Other things to like about React

* __Lightweight__ -- does a specific thing and does it pretty well
* __Very modular__ -- easy to drop in for a small portion
of your UI without having to "rewrite the whole thing in React"
* __Easy to learn__ -- As we will see shortly, there's honestly
not that much to it. Learn the basics for setting up components
as well as a few core lifecycle methods, and you're ready to start
building your own UI.

## Example -- Adding React to an Existing Rails Project

Enough with the discussion! Let's try it out. For this tutorial,
we'll be taking our beloved [Blogger](https://github.com/JumpstartLab/blogger_advanced)
project and adding a simple "like" interface to it.

### Step 1 -- App Setup

To start, clone and set up the repository.

```
git clone https://github.com/JumpstartLab/blogger_advanced.git react_tutorial
cd react_tutorial
bundle
rake db:setup
rake
```

That last command will run the test suite, which you can use
to verify that you have set everything up correctly.

### Step 2 -- Installing React

There are several ways we could add React to our app,
and for the moment we're going to use the most crude
and straightforward.

For a more robust and feature-rich alternative, check
out the [react-rails gem](https://github.com/reactjs/react-rails) which
adds some interesting view helpers and support around interacting
with React from Rails.

But for now, let's simply source React from its publicly
available CDN by adding this script tag to our `application`
layout:

in `app/views/layouts/application.html.erb`:

```html
<!DOCTYPE html>
<html>
<head>
  <title>Blogger</title>
  <%= stylesheet_link_tag    "application" %>
  <script src="https://fb.me/react-0.13.3.js"></script>
  <%= javascript_include_tag "application" %>
  <%= csrf_meta_tags %>
</head>
<body>

<p class='flash'><%= flash[:notice] %></p>

<%= yield %>

</body>
</html>
```

__Hello World__

To verify this is working, let's create our first, super
basic, React component.

First, create a new javascript file to hold our upcoming
JS code: `app/assets/javascripts/article_likes.js`

Then, let's fill this file with an extremely basic
React example:

```javascript
var Hello = React.createClass({
  render: function() {
    return React.createElement("div", null, "Hello World");
  }
});

$(document).ready(function() {
  React.render(
    React.createElement(Hello),
    document.getElementById('articles')
  );
});
```

Finally, head back to your Articles index. If things are
working, you should see a simple "Hello World" message
taking over the area where your list of articles used to be.

Congrats! React is awesome!

### Step 3 -- React Component Basics

Before we continue, let's discuss what we did in the last
step.

First, we used the `React.createClass` method to generate
a new __component.__ Components are the fundamental units for
developing with React, and they give us a way to encapsulate
the data and behavior behind portions of our UI.

Fortunately, components are also quite simple. They consist
of 2 things:

1. A `render` function, which must return a single React element
(this could be a simple DOM element like a "div", or another custom component of our own creation)
2. Properties, or `props`, which represent static data which will
not change for the lifetime of the component. In our example, we're passing `null`,
since we don't (yet) have any meaningful data to associate with the component.
3. State, which represents mutable data which is expected to change
over the lifetime of the component. We'll address this shortly.

Components can also implement and use a collection of additional
"lifecycle" methods which we'll look at later, but these 3
pieces are the core elements which define any React component.

__Other Core React Methods__

Additionally, in this example we're using 2 more basic React
methods: `createElement` and `render`

`React.createElement` is React's method for creating a new
component instance based on an existing component class.

`React.createElement` accepts 3 arguments:

1. The type of component to be created
2. the `props` value for the new component (optional)
3. the children for the new component (optional - also accepts
multiple children, which will be nested appropriately)

__Question:__ In our example we use `createElement` twice.
What is the type of component, `props`, and `children` value
for each one?

Finally, we're also using the `React.render` method. This
is React's function for attaching React component(s) to
the DOM. It "kicks things off" for a React UI, and accepts 2
arguments: the component to generate, and the element in the DOM
in which to insert it

__Exercise: Using Props__

Within a component, you can retrieve the props object
using `this.props` (it is simply a property of the current
component). Get some practice working with `props` by
trying the following:

* Observe the current props of our `Hello` component by
logging it from within the `render` method
* Pass a new JS object containing your name (e.g. `{name: "Pizza Man"}`)
as the `props` value when we create an element based on our
`Hello` component (remember `React.createElement` creates elements)
* Use the name property of the object you provided to update your
component so it renders "Hello, <your name>" instead of "Hello World"

### Step 4 -- A Real Component

Our Hello World component is neat, but not that useful.
Let's see if we can add something more useful. Start by
defining a new `LikeArticle` component, with a simple
render method:

```javascript
var LikeArticle = React.createClass({
  render: function() {
    return React.createElement("div", null, "Like Me!");
  }
});
```

Next, we'll need a place in the DOM to install our newly
created component. Let's add a placeholder div with class
"like-article" inside of each article we're rendering on the
index page.

In `app/views/articles/index.html.erb`:

```html
<ul id="articles">
  <% @articles.each do |article| %>
    <li>
      <%= link_to article.title, article_path(article) %>
      <span class='tag_list'><%= article.tag_list %></span>
      <span class='actions'>
        <%= edit_icon(article) %>
        <%= delete_icon(article) %>
		<%# Add placeholder div here: %>
		<div class="like-article"></div>
      </span>
      <%= pluralize article.comments.count, "Comment" %>
    </li>
  <% end %>
</ul>
```

Finally, let's try putting a `LikeArticle` component into
each of these placeholder divs. We'll use a bit of jquery
to do this

(in `app/assets/javascripts/article_likes.js`):

```javascript
$(document).ready(function() {
  $("ul#articles li .like-article").each(function(index, element) {
    React.render(
      React.createElement(LikeArticle),
      element
    );
  });
});
```

Here we use jquery to find all of the like-article elements
we inserted, iterate through them, and create a LikeArticle
element inside of each one. You should see some basic "Like Me"
text appearing inside each of your articles.

It's worth noting that in a more fully "react-ified" app,
we likely wouldn't call `React.render` so many times, since
the whole UI would be defined from the top down starting with
a few basic components. But setting things up in this way
can be a useful technique for migrating portions of your
UI over to React.

### Step 4 -- Using `state` to Activate our Component

As mentioned, we have 2 ways to associate data with a
component in React. `props`, for holding immutable, constant
properties of the component, and `state`, for holding more temporary
values which are likely to change over the lifetime of the component.

In the case of a "like this article" button, we'd like to
be able to associate information about whether an article
has been liked or not. And since this information is expected
to change (when the user interacts with the button), `state`
will be a better fit for storing it.

To do this, we'll rely on the `state` property of our component,
and on the `getInitialState` lifecycle method. `getInitialState`
is called on your component when its first created. It
gives you an opportunity to do any initial data
fetching (often ajax calls are done here) to set up your
component.

Let's add a `getInitialState` method to our component. Return
a simple object which indicates whether the article has been
liked or not, and for the moment, simply hardcode this value
to true:

(in `app/assets/javascripts/article_likes.js`):

```javascript
var LikeArticle = React.createClass({
  render: function() {
    return React.createElement("div", null, "Like Me!");
  },
  getInitialState: function() {
    return {isLiked: false};
  }
});
```

__Exercise: Using State:__

Similar to `props`, state is a property of the component,
and can be accessed using `this.state` within component
methods. Try the following experiments:

* Use `console.log` within your render method to see what the
value of `state` is
* Use `state` within the render method to _conditionally_
render a different button if the `isLiked` value is `true`
vs if it is `false`

### Step 5 -- Interactivity with Click Handlers


```javascript
var LikeArticle = React.createClass({
  render: function() {
    if (this.state.isLiked) {
      return React.createElement("div", {onClick: this.handleClick}, "Un-Like Me!");
    } else {
      return React.createElement("div", {onClick: this.handleClick}, "Like Me!");
    }
  },
  handleClick: function() {
    this.setState({isLiked: !this.state.isLiked});
  },
  getInitialState: function() {
    return {isLiked: false};
  }
});
```

### Step 6 -- Real Data

* Add migration -- new liked boolean on article
* render data into data attr of ".like-article"
* read data attr in get initial state

`rails g migration AddLikedToArticles liked:boolean`

```
class AddLikedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :liked, :boolean, default: false
  end
end
```

__TODO:__

* App setup
* Add React dependency - list alternatives
* Define basic component with no behavior (rendering empty heart)
* Basic state example on/off
* Adding remote verification -- comment-likes model; ajax creation
* Reading liked/not-liked from data attr of element?

### Lifecycle functions


### Addenda

* Other systems -- Glimmer (others?)
* Downsides -- animations (others?)
