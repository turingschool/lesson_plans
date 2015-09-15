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
