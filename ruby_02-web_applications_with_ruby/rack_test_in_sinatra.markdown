---
title: Rack::Test in Sinatra
length: 90
tags: testing, tdd, sinatra, http, rack
---

# Testing Sinatra Applications

## Learning Goals

* Test HTTP requests and responses using `Rack::Test`
* Use ActiveRecord validations

## Warmup 

With a partner, discuss the following questions: 

* We know that we can test user interactions on the web using Capybara. What happens when the interaction is not web-interface-based (like in Traffic Spy)? How would we test it? 

## Setup

* [ActiveRecord Skeleton Repo](https://github.com/rwarbelow/active-record-sinatra) -- this should be set up with a database, Film model, Genre model, and Director model using the [Intro to ActiveRecord in Sinatra](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/intro_to_active_record_in_sinatra.markdown) lesson plan. 

## Lecture

Let's first get rid of our test database so that you can see what happens when we've created and migrated development but not test. Add [database cleaner](https://github.com/DatabaseCleaner/database_cleaner) and rack-test to the Gemfile:

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
  
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
```

(More about [Rack::Test::Methods](http://www.rubydoc.info/github/brynary/rack-test/master/Rack/Test/Methods))

Let's begin by adding a test for a post request to create a genre. This is going to be very similar to a post request from a source wanting to register with the Traffic Spy app. Rack gives us some tools to make HTTP requests to our Sinatra application and inspect the response and make assertions based on the response.

In that same test file:

```ruby
  def test_create_a_genre_with_valid_attributes
    post '/genres', { genre: { name: "Cartoon" } }
    assert_equal 1, Genre.count
    assert_equal 200, last_response.status
    assert_equal "Genre created.", last_response.body
  end
```

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

Cool, it works. But what if someone tries to create a task without a title? We need to [validate](http://guides.rubyonrails.org/active_record_validations.html) our data. Let's write a test first:

```ruby
  def test_cannot_create_a_genre_without_a_name
    post '/genres', { genre: { } }
    assert_equal 0, Genre.count
    assert_equal 400, last_response.status
    assert_equal "missing name", last_response.body
  end
```

Normally at this point, we would drop down into a model test and write a test for our validations. For the purpose of this lesson, we'll skip that for now. 

In our Genre model:

```ruby
class Genre < ActiveRecord::Base
  validates_presence_of :name
end
```

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

What happens to the `genre` object if `if genre.save` doesn't get hit? You can access the following things:

```ruby
genre.errors.full_messages
genre.errors[:title]
```

Let's try it out in tux. 

## Key Points and Other Things

* Use the `rack-test` gem to test rack applications (e.g. Sinatra, Rails)
* Rack-test hooks in at the level of Rack, so it calls your code the same as a real web request, but with mock objects
* Declare an `app` method so it knows what Rack app to use

* What can you do with Rack::Test? 
  * get access to the methods by including `include Rack::Test::Methods`
  * make a request: (`get/post/put/patch/delete`)
  * pass params by providing a params hash as the second argument: `post '/', { title: "My Idea", description: "it's hard to come up with descriptions" }`
  * follow a redirect: `follow_redirect!`
  * get the request or response: `last_request` or `last_response`

* What to use `last_response` for:
  * `last_response.status` codes: (200, 404, 302, 500, etc) -- see all status codes [here](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)
  * `last_response.body`

* Make assertions about the body
  * look for relevant strings using normal string methods like `.include?`, etc.

## Resources

* [Testing Sinatra with Rack::Test](http://www.sinatrarb.com/testing.html)
