---
title: Featuring Testing in Rails with Minitest
length: 60
tags: capybara, rails, minitest
---

## Feature Testing Resources

* [Guide to Testing Rails Applications](http://guides.rubyonrails.org/testing.html)
* [Thoughtbot's Capybara Cheat Sheet](https://learn.thoughtbot.com/test-driven-rails-resources/capybara.pdf)
* [Zhengjia capybara cheat sheet gist](https://gist.github.com/zhengjia/428105)

## Goals:

1. Fully TDD a new feature with Capybara
1. Set up capybara for a Rails project
1. Conceptually understand what capybara is doing

## Getting Started with RSpec

### Setting up your Rails project for RSpec testing

* First we want to set up RSpec in our project. Jump into the Gemfile and add rspec and rspec-rails to the development and test groups. I also like to add pry for debugging.

```ruby
group :development, :test do
  gem 'byebug'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'pry-rails'
end
```

next run ```bundle```

* Now we'll run the CLI command to generate what we need to write RSpec tests

```
rails generate rspec:install
```

This command will generate all your RSpec files for you.

### Setting up your Rails project for Feature testing with RSpec

* [Capybara Docs](https://github.com/jnicklas/capybara#using-capybara-with-rspec)
* First we want to add Capybara and Launchy to our Gemfile in the development and test groups

```ruby
group :development, :test do
  gem 'byebug'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'capybara'
  gem 'launchy'
end
```

* now ```bundle```

* now go to the spec_helper.rb and add `require "capybara/spec"`
* Capybara specs need to be in the `spec/features` directory. If they are not they you'll need to tag them with `:type => feature`

example of feature tag. Include tag in the describe block:

```describe "the new tool process", :type => :feature do```

__Check for understanding:__

* What does the launchy gem do for our tests?
* Why do we put these gems only in the development and test groups?

##
