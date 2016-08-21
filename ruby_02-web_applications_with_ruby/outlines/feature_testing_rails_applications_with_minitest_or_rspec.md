---
title: Featuring Testing in Rails with Minitest
length: 60
tags: capybara, rails, minitest
---

## Goals:

1. Fully TDD a new feature with Capybara
1. Set up capybara for a Rails project
1. Conceptually understand what capybara is doing

## Getting Started with RSpec

### RSpec: Setting things up

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

* now go to the rails_helper.rb and add `require "capybara/rspec"`
* Capybara specs need to be in the `spec/features` directory. If they are not they you'll need to tag them with `:type => feature`

* example of feature tag. Include tag in the describe block:

`describe "the new tool process", :type => :feature do`

* let's make our feature directory `mkdir spec/features`
* make sure you include the `require 'rails_helper'` in the top of you _spec.rb files.

```ruby
require "rails_helper"

RSpec.feature "Tool management", :type => :feature do
  scenario "User creates a new widget" do
    visit new_tool_path
    # same as: visit "/tools/new"

    fill_in "Name", :with => "Screwdriver"
    click_button "Create Tool"

    within(".tool_info")
      expect(page).to have_content("Screwdriver")
    end
  end
end
```

to run your specs you can use the following rake command:

`rspec`


## Getting Started with MiniTest

* [Capybara with Test::Unit](https://github.com/jnicklas/capybara#using-capybara-with-testunit)

In your Gemfile:

```ruby
group :development, :test do
  gem 'capybara'
  gem 'launchy'
end
```

Run `bundle install`.


__Check for understanding:__

* What does the launchy gem do for our tests?
* Why do we put these gems only in the development and test groups?

In the `test_helper.rb` make sure you add the following line:

`require 'capybara/rails'`

### __Test Directory Structure__

All feature tests will go within `test/features`. If you start to see a pattern emerging for these tests, like separating them by user type `user_can_*_test.rb` and `admin_user_can_*_test.rb` you can organize them as sub-directories within the test/features/directory. Something like this:

```
|_test
    |
    features
      |_user
      |_admin
```


### __Minitest: Setting Things Up__

In the `test_helper.rb` file make sure you include `Capybara::DSL ` within ActionDispatch IntegrationTest

```ruby
class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end
```

Next we can start to write our feature test. First `mkdir test/features` then touch a new file. `touch test/features/tool_creation_test.rb`.

```ruby
require "test_helper"

class ToolCreationTest < ActionDispatch::IntegrationTest

  test "user can create a tool" do
    visit new_tool_path

    fill_in "Name", with: "Screwdriver"
    fill_in "Price", with: "1099"
    fill_in "Quantity", with: "10"
    click_link_or_button "Create Tool"

    assert_equal current_path, tool_path(Tool.last)

    within(".tool_info") do
      assert page.has_content?("Screwdriver")
      assert page.has_content?("10.99")
      assert page.has_content?("10")
    end
  end
end

```

to run the test suite use the rake command:
`rake test`

__Check for Understanding:__
* How do we connect/link Capybara and get access to those methods within our tests?
* Where do we put feature tests? (how can we further organize this structure?)


## Let's write some feature tests!

* First, together, let's write a feature test for editing a tool.
* Now, by yourself, write feature tests for:
    * viewing all tools
    * viewing a single tool
    * deleting a tool


### Additional Resources

* [ThoughtBot RSpec feature testing](https://robots.thoughtbot.com/how-we-test-rails-applications)
* [Rails Guide on Testing](http://guides.rubyonrails.org/testing.html)
* [A Quick Read about Different types of Tests](http://www.getlaura.com/testing-unit-vs-integration-vs-regression-vs-acceptance/)
* [FactoryGirl - if you're feeling adventurous](https://github.com/thoughtbot/factory_girl)
* [Guide to Testing Rails Applications](http://guides.rubyonrails.org/testing.html)
* [Thoughtbot's Capybara Cheat Sheet](https://learn.thoughtbot.com/test-driven-rails-resources/capybara.pdf)
* [Zhengjia capybara cheat sheet gist](https://gist.github.com/zhengjia/428105)
