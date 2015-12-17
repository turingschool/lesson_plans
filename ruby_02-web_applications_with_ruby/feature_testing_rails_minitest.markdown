---
title: Featuring Testing in Rails with Minitest and RSpec
length: 90
tags: capybara, rails, minitest
---

## Resources

* [Guide to Testing Rails Applications](http://guides.rubyonrails.org/testing.html)
* [Thoughtbot's Capybara Cheat Sheet](https://learn.thoughtbot.com/test-driven-rails-resources/capybara.pdf)

## Goals

* Set up a bare rails project in order to start writing feature/integration tests.
* Convert their knowledge of feature testing in Sinatra to Rails.

## Setup

* This lesson presumes completion of the [Blogger Tutorial](tutorials.jumpstartlab.com/projects/blogger.html).
We assume that the student has at least completed iteration 1. You may want to
remove the javascript confirmation box.

In your Gemfile:

```ruby
group :development, :test do
  gem 'capybara'
  gem 'launchy'
end
```

Run `bundle install`.

## CFU

* Why are we putting the capybara and launchy gems into the development and
test groups?
* What does the launch gem allow us to do?


## Test::Unit

You'll put your feature tests in the `test/features` test. If you start to see patterns emerging within these feature tests, you can create folders (like admin, user, etc.) within features.

Let's talk about fixtures for a second.
  * Generators automatically create them.
  * Why check for difference instead of an exact count

In your test_helper.rb, add this line:

```ruby
require 'capybara/rails'
```

Create a test: `$ touch test/features/song_creation_test.rb`.

Inside of that file:

```ruby

require "test_helper"

class ArticleCreationTest < ActionDispatch::IntegrationTest

  include Capybara::DSL

  test "user can create an article" do
    visit new_article_path

    fill_in "article[title]", with: "title"
    fill_in "article[body]", with: "body"
    click_link_or_button("Create Article")

    assert page.has_content?("title")
    assert page.has_content?("body")

    assert_equal current_path, article_path(Article.last)
  end
end
```

To run your test: `$ rake test`.

## CFU

* Write a test to delete an article.
* Students should now write some tests on their own.
* Write a test to edit an article.
