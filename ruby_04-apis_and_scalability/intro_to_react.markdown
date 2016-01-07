---
title: Intro to React.JS
length: 180
tags: javascript, front-end framework, react
---

## Background

### Overview -- Front-End Application History

* Beginning: Basic Jquery scripting; mostly static HTML
with small bits of dynamism on top of them
* Mostly ad-hoc / isolated interactions with the server
* __Problems:__ Browser applications becoming more and more
complex; numerous DOM Elements dependent on dynamic
data coming from servers or other sources
* __Frameworks:__ Like many technical problems, the open source community
decided to solve this with more robust and sophisticated
libraries

### The Landscape - Front-End Application Architectures

As front-end frameworks have proliferated, lots of different
ideas and approaches have been attempted, and we can
place them across a few interesting continua:

* small libraries vs. large frameworks
* View and Interaction only vs. Data and Persistence management
* View/Data combination vs. View/Data separation

__Discussion: Where do the major frameworks fit on these gradients?__

* Backbone
* Ember
* Angular

### React's Take

__Analogy:__ GPU Programming

Part of the fundamental problem is that as the number of UI elements
we're dealing with grows, the complexity of keeping them up to date
and in sync with all the relevant data grows as well.

Imagine you were developing a modern video-game: You likely have numerous
in-game "objects" that interact with one another as well as with the
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
* It minimizes expensive DOM re-renders (more on this in a moment)

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

* More computationally intensive (more rendering being done); likely
to run into performance issues

### What does it mean for web development

In practice, this last difficulty has largely prevented
this approach from taking off in web development.

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
of 3 things:

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

__Other Core React Methods -- React.createElement__

Additionally, in this example we're using 2 more basic React
methods: `createElement` and `render`

`React.createElement` is React's method for creating a new
component instance based on an existing component class.
We can sort of think of this as "instantiating" our components,
which behave somewhat like "classes" within the system.

`React.createElement` accepts 3 arguments:

1. The type of component to be created
2. the `props` value for the new component (optional)
3. the children for the new component (optional - also accepts
multiple children, which will be nested appropriately)

__Question:__ In our example we use `createElement` twice.
What is the type of component, `props`, and `children` value
for each one?

__Other Core React Methods -- React.render__

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
  $(".like-article").each(function(index, element) {
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
is called on your component when it's first created. It
gives you an opportunity to do any initial data
fetching (often ajax calls are done here) to set up your
component.

Let's add a `getInitialState` method to our component. Return
a simple object which indicates whether the article has been
liked or not, and for the moment, simply hardcode this value
to `false`:

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

* Use `console.log` within your render method to observe the value
of the component's `state`
* Use `state` within the render method to _conditionally_
render a different button if the `isLiked` value is `true`
vs if it is `false`. (For now simply changing the text is good)

### Step 5 -- Interactivity with Click Handlers

If your state exercise went well, you should now have a `LikeArticle`
component rendering based on an internal `isLiked` property
of its state.

But so far this doesn't do us much good -- we don't have any way
to actually _change_ the state, so the fact that it's dynamic
is not very helpful.

Let's fix this by giving users a basic way to update the state.
Our interaction model will look like this: whenever the user
clicks on our component, we'd like to swap the value of
`isLiked` to the opposite of its current value (that is, __toggle__
it).

When we create a new element (using `React.createElement`), we
provide it a `props` value -- as mentioned before, this is often
used for storing application-specific data (a url, id, or name),
but we can also provide dom-centric attributes via props
as well.

For example, the `className` property can be provided to specify
a CSS class, the `style` property can be provided to specify
inline styles, or the `onClick` property can be provided
to specify a click handler.

__Instructor Demo -- Setting DOM properties via `props`__

In our case, `onClick` is exactly what we'd like. We will
do 2 things:

1. define a handler function within the component to handle
any clicks
2. Attach this handler function as an `onClick` prop of our
element

Update your article component like so:

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

As promised, whenever the button is clicked, we simply toggle
the `isLiked` property within our component's `state` to
the opposite of its current value.

Try clicking the "Like Me!" text in your browser.

What happened?

If all is going correctly, it should have re-rendered with
the opposite text value. But wait...we didn't specify any
re-rendering or dom-updating behavior.

Remember that these "messy" dom-updating portions are exactly what
React handles for us. From our perspective, all we have to do
is update the component's internal state. It then gets re-rendered
from scratch as a function of that state.

This ultimately is the real power of the model: data flows in
one direction, and everything is re-rendered in terms of it.

### Step 6 -- Using Real Data in Our Component

So we've found a way to update the internal state of our
component dynamically, which, in turn, causes the whole
thing to get re-rendered.

But it would be nice if the `isLiked` value of our component
had some basis in the actual data of the rest of our application.
The "real" source of information for our simple Blogger app
is the database and the various `ActiveRecord` models that sit
on top of it.

With that in mind, we'd like to make a few changes:

1. Add a new column to store the "liked" property
of an article (this will require a migration)
2. Somehow feed the information about whether an article
has been liked into the DOM
3. Use this real information as the initial `isLiked` value
of our `LikeArticle` components

__1. Migration__

First, generate a migration to add our new column to the
articles table:

`rails g migration AddLikedToArticles liked:boolean`

Additionally, let's set a default value for the column
to `false`. Update your migration like so:

```ruby
class AddLikedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :liked, :boolean, default: false
  end
end
```

Then migrate your database (`rake db:migrate`)

__2. Incorporating our Data into our Component__

Now let's work toward incorporating this new information
into our existing component. We need to somehow embed the data
into the DOM in such a way that the JS can read it.

__Discussion - how can we share data between our server and our JS elements__

Several options exist, but for now, we can just use a data attribute.
In your template, add a `data-initial-is-liked` value, and embed
in it the `liked` property of each article:

```html
<div class="like-article" data-initial-is-liked="<%= article.liked %>"></div>
```

__3. Setting Component State from Data Attr__

Finally, let's use this value to set the initial status
of our component. An easy way to achieve this is by
feeding the value in as one of the initial `props` we provide
to the element when it is created.

Now that we have a data attr on each ".like-article" element,
we can pass that value along to the component when it's created.

Finally, we'll use this value as a "seed" value for our
`getInitialState` method.

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
    return {isLiked: this.props.initialIsLiked};
  }
});

$(document).ready(function() {
  $(".like-article").each(function(index, element) {
    React.render(
      React.createElement(LikeArticle, {initialIsLiked: $(element).data("initial-is-liked")}),
      element
    );
  });
});
```

__Notice__ that the only value we can provide from the outside
of the component is `props`. If we want to use props to
provide a "seed" state value, it's common to include "initial"
or "starting" in its name in order to indicate its role.

For example: `initialClickCount` or `startingCommentCount`.

__Discussion: Props vs. State__

Finally, let's see if our system is working. Open your rails
console and set an article's `liked` value to `true`.
Then refresh the page. Your react component should now reflect
the updated value stored in the database.

### Step 7 -- Syncing Data from Client to Server

We now have data flowing in one direction: From our
server-side database into our JS components.
What would it take to get it flowing in both directions,
so that when a user clicked our button it actually
updated the corresponding article?

Let's consider the pieces we'll need:

1. React component needs to send data to the server
when it's clicked (probably via ajax)
2. Rails app needs to handle these incoming requests
and update the corresponding article (probably a new
route and controller)

__1. Sending data from a React component__

Let's start with the Client side. We'd like our component,
on click, to send an AJAX request to the server telling it
that the article has been updated.

In order to do this, we'll actually need a new piece of information
-- the article's ID -- so that we can say specifically _which_
article should be updated.

__Exercise: Incorporate article ID as another data attribute__

Just like we did with the `article.liked` value, see if you
can use a data attribute and `props` to pass the article's
ID to our component.

__Exercise: Sending AJAX Updates to the Server__

Now that you have the article's ID available, see if you
can send the appropriate updates to the server using
AJAX. Here are a few guidelines.

* Let's assume that we'll use the path `/articles/:id/likes`
for liking and unliking
* Use a POST request for liking (creating a like) and a
DELETE request for un-liking (destroying a like)
* This request should happen during the `clickHandler`
we defined earlier
* _After_ the request completes (i.e. in its callback),
we'll need to update the component's `state` to
reflect the new `isLiked` value.

__Exercise: Accepting AJAX Updates from our Rails App__

After the last exercise, you should have ended up with
a React component that attempts to send AJAX requests to
the server whenever it is clicked.

But currently, all that happens is it receives a 404. Our
server doesn't yet know how to handle these requests.
Let's see if we can wire up this portion.

1. Add new routes, nested under `articles`, for creating
and destroying "likes"
2. Add a new `LikesController`
3. In the `LikesController`, handle the `create` action
by finding the appropriate article and setting its `liked` value
to `true`, then rendering a JSON response of the article
4. Similarly, handle the `destroy` action by setting the
article's `liked` value to `false`

__Step 7 - final implementation__

```javascript
// app/assets/javascripts/article_likes.js
var LikeArticle = React.createClass({
  render: function() {
    if (this.state.isLiked) {
      return React.createElement("div", {onClick: this.handleClick}, "Un-Like Me!");
    } else {
      return React.createElement("div", {onClick: this.handleClick}, "Like Me!");
    }
  },
  handleClick: function() {
    var method = this.state.isLiked ? "DELETE" : "POST";
    $.ajax({
      url: '/articles/' + this.props.articleID + "/likes",
      type: method,
      success: function(response) {
	this.setState({isLiked: response.liked});
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {isLiked: this.props.initialIsLiked};
  }
});

$(document).ready(function() {
  $(".like-article").each(function(index, element) {
    var props = {
      initialIsLiked: $(element).data("initial-is-liked"),
      articleID: $(element).data("article-id")
    }
    React.render(
      React.createElement(LikeArticle, props),
      element
    );
  });
});
```

```ruby
# routes.rb
resources :articles do
  resources :likes, only: [:create]
  delete 'likes', to: "likes#destroy"
end
```

```ruby
# app/controllers/likes_controller.rb
class LikesController < ApplicationController
  before_action :set_article
  def create
    @article.liked = true
    @article.save!
    render json: @article
  end

  def destroy
    @article.liked = false
    @article.save!
    render json: @article
  end

  def set_article
    @article = Article.find(params[:article_id])
  end
end
```

```html
<%# app/views/articles/index -- add data-article-id %>
<div class="like-article" data-article-id="<%= article.id %>" data-initial-is-liked="<%= article.liked %>"></div>
```

## Other Topics

### Lifecycle functions

[Documentation](https://facebook.github.io/react/docs/component-specs.html)

### JSX

[Documentation](https://facebook.github.io/react/docs/jsx-in-depth.html)

### Addenda

* Other systems -- Glimmer (others?)
* Downsides -- animations (others?)
