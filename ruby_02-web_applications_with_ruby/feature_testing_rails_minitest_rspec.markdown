---
title: Featuring Testing in Rails with Minitest and RSpec
length: 90
tags: capybara, rails, minitest, rspec
---

## Resources

* [Guide to Testing Rails Applications](http://guides.rubyonrails.org/testing.html)
* [Thoughtbot's Capybara Cheat Sheet](https://learn.thoughtbot.com/test-driven-rails-resources/capybara.pdf)

## Setup

In your Gemfile:

```ruby
group :development, :test do
  gem 'capybara'
  gem 'launchy'
end
```

Run `bundle install`.

## Test::Unit

You'll put your feature tests in the `test/features` test. If you start to see patterns emerging within these feature tests, you can create folders (like admin, user, etc.) within features.

Let's talk about fixtures for a second. 

In your test_helper.rb, add this line:

```ruby
require 'capybara/rails'
```

Create a test: `$ touch test/features/song_creation_test.rb`.

Inside of that file:

```ruby
require 'test_helper'

class SongCreationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "user can create a song" do
    visit new_song_path
    # fill in stuff here
    assert page.has_content?("your stuff here")
  end
end
```

To run your test: `$ rake test`. 

## RSpec

In your Gemfile, add `gem 'rspec-rails'`. 

* Run `rails generate rspec:install`. This will generate a spec folder with two files: spec_helper.rb and rails_helper.rb. 

In `spec/rails_helper.rb`, add these two lines:

```ruby
require 'capybara/rspec'
require 'capybara/rails'
```

Make a folder: `mkdir spec/features`. Any file inside of the features folder will have access to Capybara methods, so you don't need to include the Capybara::DSL (unlike Minitest).

Create a spec file: `touch spec/features/song_creation_spec.rb`. This MUST end with `_spec.rb` (not `_test.rb`).

```ruby
require 'rails_helper'

RSpec.describe "User creates a song" do
  context "with valid attributes" do
    it "saves and displays the song title" do
      visit new_song_path
      # fill in stuff here
      expect(page).to have_content('your stuff here')
    end
  end
end
```

Run `rake spec`. 

## Other things

Remember that you'll want to set up the `database_cleaner` gem. The [documentation](https://github.com/DatabaseCleaner/database_cleaner) includes instructions for both RSpec and Minitest. 
