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

In fact, let's continue with this approach. If you haven't
done so, do the following:

1. Create a new `jsx` file: `app/assets/javascripts/components/like_article.js.jsx`

In fact, let's continue with this approach. If you haven't
done so, do the following:

1. Create a new `jsx` file: `app/assets/javascripts/components/like_article.js.jsx`
2. Copy the updated Article Component code from above into this file.
3. Remove our old `like_article.js` file.

Reload your page and verify the component is working correctly


