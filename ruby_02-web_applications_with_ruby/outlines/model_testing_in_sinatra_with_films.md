---
title: Model Testing in Rails
length: 120
tags: rails, models, tdd, validations, scopes
---

## Goals

## Repository

* [ActiveRecord Sinatra: Intro and Homework Complete](https://github.com/turingschool-examples/active-record-sinatra/tree/intro_and_homework_complete): This branch is the result of completing the ActiveRecord Sinatra lesson available [here](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/outlines/intro_to_active_record_in_sinatra.markdown), and the homework linked at the bottom of that lesson. At this point, students should have their own copy of this assignment, and should not have to clone this down.

To clone and checkout the remote `intro_and_homework_complete` branch:

`git clone -b intro_and_homework_complete git@github.com:turingschool-examples/active-record-sinatra.git`

## Warmup

Read [this](https://robots.thoughtbot.com/four-phase-test) Thoughtbot article about the four-phase test design.

## Intro to RSpec

Will be using RSpec for this lesson.

* Slightly different than Mini-Test, but not by much.
    * `describe` blocks
    * nested `describe` blocks
    * `it` blocks
    * `expect` instead of assert
* Flags
    * --color
    * --format=documentation
    * Can save in a `.rspec` file in your home directory

## Code-Along

### Setting up Model Tests

Add the following line to your `Gemfile`

```ruby
gem 'rspec'
```

Run `bundle`.

### File structure

We'll create a spec folder. Within that folder, we'll create another folder called models. This way we can separate our model tests from our integration tests (more on this later).

```
$ mkdir spec
$ touch spec/spec_helper.rb
$ mkdir spec/models
$ touch spec/models/film_spec.rb
```

In `spec/spec_helper.rb`:

```ruby
require 'rspec'
require File.expand_path('../../config/environment.rb', __FILE__)
```

### Testing the `.total_sales` Method

Let's write our first model test. In `spec/models/film_spec.rb`:

```ruby
require_relative '../spec_helper'

RSpec.describe "Film" do
  describe ".total_sales" do
    it "returns total sales for all films" do
      Film.create(title: "Film1", year: 2012, box_office_sales: 3)
      Film.create(title: "Film2", year: 2013, box_office_sales: 2)

      expect(Film.total_sales).to eq(5)
    end
  end
end
```

At this point you should be able to run your tests from the command line using the command `rspec`. `rspec` will also take some flags to change the output. For a full list run `rspec --help | less`. For example, run `rspec -c -f d` to see how the output differs. If you find yourself consistently using flags you can save them to a `.rspec` file in your home directory. See [this](http://stackoverflow.com/questions/1819614/how-do-i-globally-configure-rspec-to-keep-the-color-and-format-specdoc-o) Stack Overflow answer for additional details.

Did we get what we expected? No? What's going on here? It looks like the total that's being reported by our test is the full total of our all the films currently in our database.

Run it one more time to check. Notice that the actual value that we're getting increased? So, not only are we not testing with only the data we're providing in the test, but on top of that, every time we run the test we're adding new films to our development database.

This is not the behaviour we want. We're polluting the database that we're using when we browse the site locally. Wouldn't it be better if we could run our test suite without making these changes?

We're going to set an environment variable in our spec helper file and then use that variable to determine which database to use. In `spec_helper.rb` add the following **above** all the `require` lines:

```ruby
ENV['RACK_ENV'] = 'test'
```

It's very important that this line comes before you require the environment. If you want to trace why, take a look first at line 14 in your `config/environment.rb` file, which should lead you to the `config/database.rb` file. In that file, you'll see that the database name gets set based on the current environment.

One more step and then we should be in good shape. From the command line:

```
$ rake db:test:prepare
```

This should both create and run the migrations for a test database (you should be able to see the new file in your `db` directory). Now run your test again from the command line using `rspec`. Passing test? Great!

Run the test again. Failing test! Damn.

What's happening here? Before we were saving new films to our development database every time we ran our test suite. Now we're doing the same thing to our test database. What we'd like to do is to clear out our database after each test. We could create these methods in each one of our tests, but there's a tool that will help us here: [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner).

In the test/development section of your Gemfile add the following line:

```ruby
  gem 'database_cleaner'
```

Then in your spec helper, add the following after your current `require` lines:

```ruby
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.configure do |c|
  c.before(:all) do
    DatabaseCleaner.clean
  end
  c.after(:each) do
    DatabaseCleaner.clean
  end
end
```

Save and run your tests again from the command line. Passing test? Great again!

### Testing Validations

One thing we haven't really worried about up to this point was whether or not a new Film had all of its pieces in place when we were saving it to the database. We want to make sure that when someone tries to save a film that they're providing us with all the information we need. We don't want to have someone save a film with, for example, no name.

Add the following test to your `film_spec` within the main `describe` block, but outside of your existing `describe '.total_sales'` block.

```ruby
  it "is invalid without a title" do
    film = Film.new(year: 2012, box_office_sales: 3)

    expect(film).to_not be_valid
  end
```

Run your test suite from the command line with `rspec` and look for the new failure. The heart of this error is telling us that it expected `.valid?` to return false when called on our new film, and instead got true.

Great! It seems like this is testing what we want, but how can we actually make this pass?

### Writing Validations

ActiveRecord actually helps us out here. Go into the `app/models/film.rb` model and add the following line:

```ruby
  validates :title, presence: true
```

Run your tests again, and... passing. Great news.

## Worktime

* In pairs, add the following tests:
    * a test for the `.average_sales` method
    * a test for the `.total_sales` method that ensures that when two directors exist, you're able to scope `.total_sales` down to a single director by calling something like `Director.first.films.total_sales` (hint: you'll need to create your associations in your test, and make sure that `box_office_sales` for the second director are not included in the `.total_sales` result)
    * tests that a film cannot be created without a year or `box_office_sales`
* Add the validations to make the last pair of tests pass.
* We also likely want to make sure that we can test that the name of each of our films is `unique`. Write a test that would ensure we can't create two films with the same name, and then use the ActiveRecord documentation available [here](http://guides.rubyonrails.org/active_record_validations.html#uniqueness) to see what you could do to ensure the `uniqueness` of a new film.

## Other Resources:

* [RSpec Documentation](http://rspec.info/documentation/): For now you'll likely be most interested in the `rspec-core`, and `rspec-expectations` links.
