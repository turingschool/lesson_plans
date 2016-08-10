---
title: Rack::Test in Sinatra
length: 90
tags: testing, tdd, sinatra, http, rack
---

# Testing Sinatra Applications

## Learning Goals

* Test HTTP requests and responses using `Rack::Test`
* Use database_cleaner to support tests
* Use ActiveRecord validations

## Setup (before lesson)

* Clone the repo [here](https://github.com/s-espinosa/rack_test_in_sinatra)

## Review: Unit and Feature Tests (Slides - 5 mins)

* Unit tests - our specific function works the way we expect with given inputs
    * Action: method calls on an object
    * Result: return values/object state
    * Test: example test
* Feature tests with Capybara - user clicks a link, etc.
    * Action: User interaction with a webpage
    * Result: New web page with content (HTML)
    * Test: example test
* Rush hour
    * Not sending information in forms, not data that’s entered by a human on a web page
    * Modeling something closer to a machine to machine interaction
    * Still need to provide certain responses so that client machines know that they have successfully submitted a request even though we’re not rendering a view.
    * Need to test this functionality
        * Action: Submit curl request
        * Result: HTTP response/Updates to DB
        * Test: ?

## Lecture (Slides - 10 mins)

* How do we test this?
    * Rack::Test (via rack-test gem)
    * Gives us a way to test our controllers
    * Mimics a request/response cycle
    * Doesn’t require a view to be rendered for either submissions  or responses (no Capybara)
* What does rack-test give us?
    * HTML verbs in our tests (get, post, put, patch, delete)
    * Ability to pass params using a params hash as second argument (post ‘/‘, {title: “My Idea”, description: “fake descriptions are difficult”}
    * last_response.status: check status codes (200, 404, 302, 500, etc)
    * last_response.body: check body content - look for relevant strings using string methods like .include?, etc.
    * Ability to follow a redirect with follow_redirect!
* How do we use?
    * Gemfile
        * gem ‘rack-test'
    * Test
        * include Rack::Test::Methods
        * def app
            AppName
          end

## Code Along (30 mins)

In the repo you cloned there's a film_file folder holding the FilmFile repo that we worked on previously. This version is up to date with the work that we've completed previously.

### Setting up rack-test
Add `rack-test` to your Gemfile:

```ruby
source 'https://rubygems.org'

gem 'sinatra', require: 'sinatra/base'
gem 'sqlite3'
gem 'activerecord'
gem 'sinatra-activerecord'

group :development, :test do
  gem 'shotgun'
  gem 'minitest'
  gem 'tux'
  gem 'capybara'
  gem 'rack-test'
end
```

Run `rake db:drop` just so we can see how these tests respond when the database has not yet been set up.

### Writing a test with rack-test methods
Create a test:

```
$ touch test/controllers/create_genre_test.rb
```

Inside of that file:

```ruby
require './test/test_helper'

class CreateGenreTest < Minitest::Test
  include Rack::Test::Methods     # allows us to use get, post, last_request, etc.

  def app     # def app is something that Rack::Test is looking for
    FilmFile
  end
end
```

Let's begin by adding a test for a post request to create a genre. This is going to be very similar to a post request from a source wanting to register with the Rush Hour app. Rack gives us some tools to make HTTP requests to our Sinatra application and inspect the response and make assertions based on the response.

In that same test file:

```ruby
  def test_create_a_genre_with_valid_attributes
    post '/genres', { genre: { name: "Cartoon" } }
    assert_equal 1, Genre.count
    assert_equal 200, last_response.status
    assert_equal "Genre created.", last_response.body
  end
```

(More about [Rack::Test::Methods](http://www.rubydoc.info/github/brynary/rack-test/master/Rack/Test/Methods))

Run the test. You should see some error about the database table. That's because we haven't migrated our test database:

```
$ rake db:test:prepare
```

Now run the test. You should see something like this:

```
Run options: --seed 11902

# Running:

F

Finished in 0.027348s, 36.5657 runs/s, 36.5657 assertions/s.

  1) Failure:
CreateGenreTest#test_create_a_genre_with_valid_attributes [test/controllers/create_genre_test.rb:16]:
Expected: 1
  Actual: 0

1 runs, 1 assertions, 1 failures, 0 errors, 0 skips
```

### Getting the request test to pass

To get this test passing, we need to add this route in our controller:

```ruby
class FilmFile < Sinatra::Base
  get '/genres' do
    @genres = Genre.all
    erb :genres_index
  end

  post '/genres' do
    Genre.create(params[:genre])
    status 200
    body "Genre created."
  end
end
```

Run the test a few more times.

```
Run options: --seed 21194

# Running:

FF

Finished in 0.054689s, 36.5703 runs/s, 36.5703 assertions/s.

  1) Failure:
CreateGenreTest#test_cannot_create_a_genre_without_a_name [test/controllers/create_genre_test.rb:27]:
Expected: 0
  Actual: 1


  2) Failure:
CreateGenreTest#test_create_a_genre_with_valid_attributes [test/controllers/create_genre_test.rb:20]:
Expected: 1
  Actual: 2

2 runs, 2 assertions, 2 failures, 0 errors, 0 skips
```

**It was passing. Why is it failing now?**


### Database Cleaner

Go back to your Gemfile and add database_cleaner

```ruby
source 'https://rubygems.org'

gem 'sinatra', require: 'sinatra/base'
gem 'sqlite3'
gem 'activerecord'
gem 'sinatra-activerecord'

group :development, :test do
  gem 'shotgun'
  gem 'minitest'
  gem 'tux'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner'
end
```

Configure the database cleaner in `test_helper.rb`:

```ruby
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation, {except: %w[public.schema_migrations]}
```

Wondering WTF `DatabaseCleaner.strategy = :truncation` means? Check out [this Stackoverflow answer](http://stackoverflow.com/questions/10904996/difference-between-truncation-transaction-and-deletion-database-strategies).

Update your test file to include setup and teardown methods that run Database Cleaner before and after each test is run.

```ruby
require './test/test_helper'

class CreateGenreTest < Minitest::Test
  include Rack::Test::Methods     # allows us to use get, post, last_request, etc.

  def app     # def app is something that Rack::Test is looking for
    FilmFile
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  # existing test is here.
end
```

Try to run your tests again - they might fail a couple of times with slightly changing results as DB cleaner works its magic. They should pass after one or two more tries.

### Sad Paths

What if someone tries to create a task without a title? We need to [validate](http://guides.rubyonrails.org/active_record_validations.html) our data. Let's write a test first:

```ruby
  def test_cannot_create_a_genre_without_a_name
    post '/genres', { genre: { } }
    assert_equal 0, Genre.count
    assert_equal 400, last_response.status
    assert_equal "missing name", last_response.body
  end
```

Run our test to see it fail since we're able to successfully create this genre when our test says we shouldn't.

Normally at this point, we would drop down into a model test and write a test for our validations. For the purpose of this lesson, we'll skip that for now.

In our Genre model:

```ruby
class Genre < ActiveRecord::Base
  validates_presence_of :name
end
```

Run our test. Will still fail, but this time because we're giving the wrong status code.

**Any thoughts on how we can send a different status code based on whether a genre has successfully saved?**

In our controller:

```ruby
  post '/genres' do
    genre = Genre.new(params[:genre])
    if genre.save
      status 200
      body "Genre created."
    else
      status 400
      body "missing name"
    end
  end
```

## Independent Practice (30 - 45 mins)

In the repo you cloned there's another folder for a to-do application. In that test/controllers file there are four groups of tests:

* **Detailed Pseudo Code - Existing Features:** detailed descriptions of tests for you to test existing features.
* **Test Names - Existing Features:** test names only (no other description) for tests for existing features.
* **Detailed Pseudo Code - New Features:** detailed descriptions of tests for you to test features that you will need to implement.
* **Test Names - New Features:** test names only (no other description) for tests for features you will need to implement.

Complete each section as described in that file.
