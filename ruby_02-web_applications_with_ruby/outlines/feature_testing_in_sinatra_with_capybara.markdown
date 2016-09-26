---
title: Feature Testing in Sinatra with Capybara
length: 120
tags: capybara, user stories, feature tests, testing
---

## Key Topics

During our session, we'll cover the following topics:

* Types of testing
* What are user stories? Why are they beneficial?
* Capybara

## Lecture

[Slides](http://m2b-slides.herokuapp.com/m2b/feature_testing_with_capybara_in_sinatra.html#/)

## Important Setup Things

Add the following lines to your `Gemfile`

```ruby
gem 'capybara'
gem 'launchy'
```

Run `bundle`

Update your `spec/spec_helper.rb` file to include the following:

```ruby
# with your other required items
require 'capybara/dsl'

Capybara.app = TaskManagerApp

# within the RSpec configuration:
  c.include Capybara::DSL
```

Since we're going to be creating a new type of test, let's add a new folder to separate them from our model tests.

`mkdir spec/features/`
`touch spec/features/user_sees_all_tasks_spec.rb`

In that new file add the following:

```ruby
require_relative '../test_helper'

RSpec.describe "When a user visits '/'" do
  it "they see a welcome message" do
    # Your code here.
  end
end
```

## Resources

* [Capybara cheat sheet](https://gist.github.com/zhengjia/428105)
* [Simple Tricks for Capybara](http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests)
