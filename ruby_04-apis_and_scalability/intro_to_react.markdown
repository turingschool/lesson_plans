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

__Additional Test Setup__

Additionally, we'll want to test-drive the new React
features we'll be adding, so let's configure our app for
this use-case.

Currently, the app features some integration tests using
Capybara with the built-in `Rack::Test` driver. Since
we'll be adding some javascript, let's also configure the app
to use the Poltergeist driver.

__PhantomJS Dependency__

First, make sure you have PhantomJS (this is a dependency of
Poltergeist) installed on your system by running `which phantomjs`.

If see a path to a phantomjs executable, you're good to go. If not,
install PhantomJS using Homebrew:

```
brew install phantomjs
```

__Adding the Gem__

Next, add the `poltergeist` gem to your Gemfile:

```ruby
group :test do
  gem "poltergeist"
end
```

__Configuring Capybara__

Finally, we need to tell Capybara to use PhantomJS
whenever it runs a test which requires javascript.

In your `spec/spec_helper.rb`, add:

```ruby
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
```

### Step 2 -- Our First Test

We want to add an "article-liking" feature to the Blogger app.
For now, we'll put this feature in the Article Index -- when
viewing a list of articles, you'll have an additional option
to like one of them.

Let's write our initial test for this feature. First, create
a new file, `spec/features/like_article_spec.rb`

Fill the file with our basic test boilerplate to start:

```ruby
require 'spec_helper'

describe "Liking an Article", :type => :feature, :js => true do
  let!(:article){ Fabricate(:article) }

  it "posts a comment" do
    visit articles_path
    expect(page).to have_content(article.title)
  end
end
```

Before you continue, run your tests and make sure that the
new one passes -- so far we haven't added any requirements
that should fail.

Now, let's add to the test to describe our new feature.
Within each article, we'd like a "like" button to appear.
For now, we can describe this behavior by simply asserting
that there's a `button` element which has a class of `like-article`.


Add to your existing test:

```ruby
require 'spec_helper'

describe "Liking an Article", :type => :feature, :js => true do
  let!(:article){ Fabricate(:article) }

  it "posts a comment" do
    visit articles_path
    expect(page).to have_content(article.title)
    within("ul#articles li") do
      expect(page).to have_css("button.like-article")
    end
  end
end
```

Now, run this new test -- predicably, it should fail. This
test is pretty light so far, but it will give us some guidance
as we start to add our initial React code.

### Step 3 -- Installing React

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


__TODO:__

* App setup
* Add React dependency - list alternatives
* Define basic component with no behavior (rendering empty heart)
* Jquery.cookie for client-side cookie-ing
* Adding remote verification -- comment-likes model; ajax creation

### Lifecycle functions


### Addenda

* Other systems -- Glimmer (others?)
* Downsides -- animations (others?)
