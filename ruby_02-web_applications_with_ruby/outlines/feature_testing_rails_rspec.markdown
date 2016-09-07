# Featuring Testing in Rails with RSpec and Capybara


## Learning Goals:

* Set up RSpec for a Rails project
* Fully TDD a new feature with Capybara

## Warm up:
* What is a feature test?
* What is a feature?

## How do you know what to test?
- Stay Organized
- Plan your test out 
- Use the following format:

	As a ___________,
	
	When I _________,
	
	And I __________
	
	Then I _________

This is also known as a User Story.

## What is a User Story?
- A tool used to communicate user needs to software developers
- Used in Agile Development
- Describes what a user needs to do in order to fulfill job function

## Examples of User Stories
* As an admin, when I visit my profile page I see all the tasks I've been assigned to complete.

* As a user, when I visit the homepage and I fill in my username and password, I can view my favorited playlists.

* As a student, when I login to the system I can purchase a parking pass. 


## Your Goal:
1. Setup RSpec & Capybara (see below) in your BookShelf application.
2. Write feature tests for the following actions:
	- Viewing all books
	- Viewing a single book
	- Deleting a book
	- Editing a book
	- Creating a book


## Getting Started with RSpec

### RSpec: Setting things up

First we want to set up RSpec in our project. 

You have two options - you can continue to follow along and follow the instructions here or you can visit the []documentation](https://github.com/rspec/rspec-rails) and try on your own!

Jump into the Gemfile and add rspec and rspec-rails to the development and test groups. I also like to add pry for debugging.

```
group :development, :test do
  gem 'byebug'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'pry-rails'
end
```

Because we added gems to our Gemfile, we'll need to run ```bundle```.

Next, in order to fully setup RSpec in our application, we'll need run the CLI command to generate what we need to write RSpec tests. This command will generate all your RSpec configuration files for you.

```
rails generate rspec:install
```

### Feature testing with RSpec: Capybara

* [Capybara Docs](https://github.com/jnicklas/capybara#using-capybara-with-rspec)

First we want to add Capybara and Launchy to our Gemfile in the development and test groups (this should be very similar to what you did when you wrote feature tests for your Sinatra applications)

After adding Capybara and Launchy, your development and test group in your Gemfile should look like the following:

```
group :development, :test do
  gem 'byebug'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'capybara'
  gem 'launchy'
end
```

Next, you'll need to ```bundle``` again since we added gems to our Gemfile.

In order to use Capybara in our tests, we'll need to `require "capybara/rspec"` in our `spec/rails_helper.rb`. We'll be writing all of our RSpec tests in our `spec` folder.

Capybara specs need to be in the `spec/features` directory. If they are not they you'll need to tag them with `:type => feature` like so:

`describe "the new book process", :type => :feature do`

The convention is to put your features tests in a `features` folder to keep everything organized, so let's do that.

Make a feature directory `mkdir spec/features`. Make a file within this directory called `create_new_book_spec.rb`. Notice, the convention is to name our RSpec files with `_spec` at the very end.

We'll need to `require 'rails_helper'` at the top of any `_spec.rb` file in order to run our tests.

Example of a feature test:

```
# spec/features/create_new_book_spec.rb
require "rails_helper"

describe "Create new book", :type => :feature do
  scenario "User creates a new book" do
    visit new_book_path
    # same as: visit "/books/new"

    fill_in "Title", :with => "The Outsiders"
    click_button "Create Book"

    within(".book_info") do
      expect(page).to have_content("The Outsiders")
    end
  end
end
```

To run your specs you can use the following rake command:

`rspec`
