---
title: Intro to React, Part 2
tags: javascript, react
length: 180
---


Outline:

* JSX
* Lifecycle methods
* react-rails gem and rails integrations


### Installing React - A better way

In the previous session we hardcoded a react
dependency into our application layout by sourcing
it from its public CDN link.

For this session, let's do something more permanent.
We'd like:

* to include React from our own asset bundle
* to have access to the special `jsx` processor
within the asset pipeline

Fortunately we can do this with the [react-rails](https://github.com/reactjs/react-rails)
gem.

Install it in your project by adding it to your Gemfile

```ruby
gem 'react-rails', '~> 1.0'
```

Then run `bundle`, and run the initial install:

```
rails g react:install
```

This does a few things:

* adds the react source files to our vendor/assets dir
* adds an `app/assets/javascripts/components` directory
to store our react components
* adds the JSX pre-processor to our asset pipeline so that
any `*.jsx` files we write can be translated into the appropriate javascript

### JSX

One popular feature of React is its JSX pre-processor. This
allows us to write our components using an XML-like
syntax, which is then translated to the appropriate javascript.

Remember our "LikeArticle" component from the previous session:

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
```

Using JSX, we could re-write this component like so:

```javascript
var LikeArticle = React.createClass({
  render: function() {
    if (this.state.isLiked) {
      return (
        <div onClick={this.handleClick}>
    	  "Un-like me!"
    	</div>
      );
    } else {
      return (
        <div onClick={this.handleClick}>
          "Like me!"
        </div>
      );
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
      <LikeArticle initialIsLiked={props.initialIsLiked} articleID={props.articleID} />,
      element
    );
  });
});
```

__Notice__ Several things from this snippet:

1. The use of html-like `<div>` syntax within our
component's `render` function
2. The use of a self-closing `<LikeArticle>` component
within our `React.render` call
3. the use of `{}` braces to denote JSX "interpolation"

__JSX Benefits__

* Cleaner nesting
* Community adoption
* HTML-like Attribute definition

In fact, let's continue with this approach. If you haven't
done so, do the following:

1. Create a new `jsx` file: `app/assets/javascripts/components/like_article.js.jsx`
2. Copy the updated Article Component code from above into this file.
3. Remove our old `like_article.js` file.

Reload your page and verify the component is working correctly

__JSX - Pre-Processing__

Discussion: JSX pre-processed into normal JS

Demo: viewing asset links from browser (show how
`like_article.js.jsx` becomes `like_article.js`)

At first, JSX is one of the stranger things to get used to when
doing react development. But the strangeness quickly fades away
and, given the community's strong adoption of the technology,
it quickly fades away.

### React-Rails: View Helpers

Another pretty neat thing about the react-rails gem is that it
includes view helpers for creating and mounting react
components straight from our ERB templates.

You can read more about these features in the [Rendering & Mounting](https://github.com/reactjs/react-rails#rendering--mounting)
section of the readme, but we'll demonstrate here.

Recall how we had to use Jquery to iterate over all of our
`.like-article` divs and insert a component?

The react rails view helpers give us a way to do this.

In `app/views/index.html.erb`, replace:

```html
<div class="like-article" data-article-id="<%= article.id %>" data-initial-is-liked="<%= article.liked %>"></div>
```

with:

```html
<%= react_component('LikeArticle', articleID: article.id, initialIsLiked: article.liked) %>
```

This view helper lets us:

* add a new component (technically add an empty div which gets
picked up by react and translated into a component)
* provide the props by giving a hash of arguments

It turns out to be a pretty handy way to define components.
Using `react-rails`, we define oure components in the appropriate
`.js.jsx` files in our components directory. Then we can render
them into our templates using the `react_component` helper.

Pretty sweet.

### More React

Now that we have a more robust app setup which integrates
React seamlessly with our Rails app, we can start converting
more of our interface.

Let's continue walking "up the tree" on our articles index page,
and see if we can generate an individual "article component".

First, take a look at the markup for rendering a single
article on the index page:

```html
<li>
  <%= link_to article.title, article_path(article) %>
  <span class='tag_list'><%= article.tag_list %></span>
  <span class='actions'>
    <%= edit_icon(article) %>
    <%= delete_icon(article) %>
  </span>
  <%= react_component('LikeArticle', articleID: article.id, initialIsLiked: article.liked) %>
  <%= pluralize article.comments.count, "Comment" %>
</li>
```

Consider what data would be needed by a react component
to generate the equivalent UI:

* article title
* article url
* article edit url
* article delete url
* article liked value
* article comments count (also may want to leverage rails
pluralization logic for this)
* article tag_list

Let's add a `react_component` call to render our hypothetical
`Article` component. Given the data we mentioned, it might
look something like this:

```
  <% @articles.each do |article| %>
    <%= react_component("Article", {article: article.as_json,
      tagList: article.tag_list,
      commentsCount: pluralize(article.comments.count, "Comment")},
      )
    %>
    <li>
      <%= link_to article.title, article_path(article) %>
      <span class='tag_list'><%= article.tag_list %></span>
      <span class='actions'>
        <%= edit_icon(article) %>
        <%= delete_icon(article) %>
      </span>
      <%= react_component('LikeArticle', articleID: article.id, initialIsLiked: article.liked) %>
      <%= pluralize article.comments.count, "Comment" %>
    </li>
  <% end %>
```

Notice several things:

* We're rendering our new article component alongside
the existing, html/erb definition. if this works we'll
have them duplicated side by side, and can then delete the old one
* The `Article` component doesn't actually exist yet. We'll need
to define it, and until we do, you'll get an error loading the page
* We're passing all the data mentioned above as props to the component

__Your Turn: Defining an Article Component__

Get with a __pair__, and take a stab at implementing an article
component to match the existing article `li` markup.

For now, __skip the Delete__ link -- we'll address that shortly.

Create a new component file, `app/assets/javascripts/components/article.js.jsx`,
to hold your component.

Here are a few tips to guide you:

* remember you can access prop data using `this.props` within
your JSX template
* refer to the [official react tutorial](https://facebook.github.io/react/docs/tutorial.html)
if you have more questions about JSX specifically
* remember to use `{}` to embed dynamic JS code into your JSX
* don't forget you can use custom components (such as our
`LikeArticle` component) in your JSX just like a standard
`div` or `span` component

__Demo: recapping article component as a group__

### Final Component: Article List

Now that we've moved a small interactive portion (like button)
and a larger, fairly static portion of our UI into react,
let's look at what it would take to migrate the rest of the list.

That is, we'd like to move the entire articles list into a react
component which, given a JSON representation of our list of
articles, can render individual article components for each one.

To start, create another component file: `app/assets/javascripts/components/article_list.js.jsx`.

Let's try to sketch out our initial component. Fortunately for us,
the `ArticleList` component doesn't need to do much besides...
render the list of articles.

And since we already have an `Article` component for handling
that, our process will hopefully be fairly straightforward.

Here's a rough example of what our first component might look like:

```javascript
var ArticleList = React.createClass({
  render: function() {
    return (
    <ul id="articles">
      {
        this.props.articles.map(function(a) {
          return (<Article article={a} key={"article-" + a.id} tagList="" commentsCount="5 comments" />);
        })
      }
    </ul>
    );
  }
});
```

__Notice__ we're definitely taking a few shortcuts
(removing the tag list and comments count implementations entirely)

That's ok for now. First let's discuss a few more points:

* React Iteration -- Using Map to generate multiple components
* React __key__ property -- important to identify components
during iteration
* Modular Components -- Re-using our previously defined `Article`
component from our new `ArticleList` component.

__Exercise: Refactoring and Polishing ArticleList Component__

We'd like to fill in some of the remaining gaps in our
ArticleList by enhancing the `as_json` implementation
of our Article model.

Specifically, let's see if we can fill in the
"tag list" and "comment count" functionality.

__Workshop: Filling in "delete" functionality__

Finally, let's come back to the "Delete Article" functionality
we omitted earlier. Now that we have our whole article list
UI rendering via React, it will be a little easier to implement.

Consider what needs to happen:

* When an article "delete" button is clicked, we need to
notify the server, so it can be deleted there
* When the server responds positively, we need to remove
the article from the `articles` value in our `ArticleList`
component
* In order for this to be effective, we probably need to move
our `articles` value into `state` rather than `props`, since
we'll be manipulating it as we go.
