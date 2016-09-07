---
title: Testing an Internal API
length: 90
tags: apis, testing, controllers, rails
---

## Learning Goals

* Understand how an internal API at a conceptual level
* Use controller tests to cover an internal API
* Feel comfortable writing controller tests that deal with different HTTP verbs (GET, POST, PUT, DELETE)

## Structure

### Block 1: 25 minutes

* 5  - Conceptual discussion
* 10 - Intro to Fixtures
* 5  - Application setup
* 5  - Break

### Block 2: 35 minutes

* 10 - Implement the #index controller test
* 5  - Implement the #index API endpoint
* 10 - Workshop 1: Implementing the #show controller test
* 5  - Demo: How to implement the #show controller test
* 5  - Break

### Block 3: 30 minutes

* 5  - Implement the #create controller test
* 5  - Implement the #create API endpoint
* 10 - Workshop 2: Implementing the #update controller test
* 5  - Demo: How to implement the #update controller test
* 5  - Recap

## Fixtures mini-lesson

### Why fixtures?

You've got to create dummy data anyway. Why not use a standard, readable language like YAML, and built in testing features to do it.

> You got it already. Don't have to make a new one! -Dr. Steve Brule

### YAML files

Fixtures are defined in YAML. YAML (Yet another markup language) is a format for storing simple nested key-value pairs. It's just text, like JSON, but also like JSON, parsers exist in many languages

Consider this hash:

```ruby
{
  rubyonrails: {
    name: "Ruby on Rails",
    url: "http://www.rubyonrails.org"
  },
  google: {
    name: "Google",
    url: "http://www.google.com"
  }
}
```

The same structure can be defined in YAML:

```yaml
rubyonrails:
  name: Ruby on Rails
  url: http://www.rubyonrails.org

google:
  name: Google
  url: http://www.google.com
```

In YAML, ***Whitespace Matters***. You don't use curly braces to define the beginning and end of a hash or object. You simply tab in one level, and YAML interprets that as a nested object.


### Using fixtures in your tests

Let's pretend the YAML example above is in `test/fixtures/websites.yml`. When you tests start up, two records will be added as `Website` objects.

You might be used to retrieving records in your test with something like `website = Website.find(1)`. In the interest of keeping things random, records from fixtures are given random ids. So you can't count on the first one having an `id` of `1`, and you can't even count on the first one being `.first`.

To get a record from a fixture, use the syntax `website = websites(:google)`. Whatever the lowercase plural version of your model name is, and then pass it a symbol that you defined in your YAML file.

### Id based relationships in Fixtures

Let's say we wanted to add a `Category` model, and add a `belongs_to :category` to our `Website` model. We would need to define some `Category` fixtures:

**categories.yml**
```yaml
development:
  name: development

search:
  name: search
```

If we want to modify our `Website` fixtures to include a category, we would need to know the id of category to use in our `websites.yml` file. Since fixtures sets random ids each time you run your tests, we can hard code the ids like so:

**categories.yml**
```yaml
development:
  id: 1
  name: development

search:
  id: 2
  name: search
```

This enables you to add related `Category` records to your `Website` fixtures:

**websites.yml**
```yaml
rubyonrails:
  name: Ruby on Rails
  url: http://www.rubyonrails.org
  category_id: 1

google:
  name: Google
  url: http://www.google.com
  category_id: 2
```

Now when you use `Website` fixtures in your tests, they will have a related `Category` record from the fixtures.

There's a couple disadvantages here.

1. We've lost our randomness that we like to have in our tests
2. When you're looking at `websites.yml`, how do you remember which category has which id, especially when you have a lot of categories.

### Key based relationships in Fixtures

When you use fixtures in your test, you refer to the key you defined in your YAML file, e.g. `websites(:rubyonrails)`. You can use that same key when defining relationships. Let's modify the YAML files from above.

**categories.yml**
```yaml
development:
  name: development

search:
  name: search
```

**websites.yml**
```yaml
rubyonrails:
  name: Ruby on Rails
  url: http://www.rubyonrails.org
  category: development

google:
  name: Google
  url: http://www.google.com
  category: search
```

Now we get to keep our random id's, we know which category a website is just by looking at the fixtures, and our `categories.yml` file is a little bit smaller.

## Workshops

### Workshop 1: Implementing the #show controller test

* Can you implement a controller test that sends a request to the show action in the items controller?
* You need to make sure that the response is successful.
* You also need to make sure that the contents that you are expecting are there.

### Workshop 2: Implementing the #update controller test

* Can you implement a controller test that sends a request to the update action in the items controller?
* You need to make sure that the response is successful.
* You also need to make sure that the contents that you are expecting are there.

## Procedure

### 0. Setup

Let's start by creating a new Rails project.

```sh
$ rails _5.0_ new testing_internal_apis -d postgresql --api
$ cd testing_internal_apis
$ bundle
$ bundle exec rake db:create
```

Add `require 'minitest/pride'` to your test_helper because colors make it more fun to test.

**test/test_helper.rb**
```rb
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
```

### 1. Create Item model and Item controller

Our goal is to implement a controller test that sends a request to the show action in the items controller. To do this, we need some items.

Let's generate a model.

```sh
$ rails g model Item name description:text
$ bundle exec rake db:migrate
== 20160229180616 CreateItems: migrating ======================================
-- create_table(:items)
   -> 0.0412s
== 20160229180616 CreateItems: migrated (0.0413s) =============================
```

And let's fill in our Item fixture

**test/fixtures/items.yml**

```yaml
one:
  name: Hammer
  description: When it is this time, you stop.

two:
  name: Screwdriver
  description: Not just for breakfast anymore.

```


Our model wouldn't be very helpful without a related controller:

```sh
$ mkdir -p app/controllers/api/v1
$ touch app/controllers/api/v1/items_controller.rb
```

Note that we are namespacing the controller under `api/v1`.

**app/controllers/api/v1/items_controller.rb**
```rb
class Api::V1::ItemsController < ApplicationController
end
```

### 2. Implement Api::V1::ItemsController#index

Since we didn't generate the controller, we need to create the structure of the test folders ourselves.

```sh
$ mkdir -p test/controllers/api/v1
$ touch test/controllers/api/v1/items_controller_test.rb
```

Great! Now we can start test driving our code. First, let's set up the test file.

On the first line of the test we are making the request. We want a `get` request to `api/v1/items` and we would like to get json back. At the end of the test we are asserting that the response was a success.

**test/controllers/api/v1/items_controller_test.rb**

```rb
require 'test_helper'

class Api::V1::ItemsControllerTest < ActionDispatch::IntegrationTest
  test "can get all items in index" do
    get "/api/v1/items"

    assert_response :success
  end
end
```

Let's make the test pass!

First, the test tells us that we don't have a matching route. `ActionController::RoutingError: No route matches [GET] "/api/v1/items"`. Add the namespaced routes:

**config/routes.rb**
```rb
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index]
    end
  end
```

Also, add the action in the controller:

**app/controllers/api/v1/items_controller.rb**
```rb
class Api::V1::ItemsController < ApplicationController

  def index
  end

end
```

Great! We are successfully getting a response. But we aren't actually getting any data. Without any data or templates, Rails 5 API will respond with `Status 204 No Content`. Since it's a `2xx` status code, it is interpreted as a success.

Now lets see if we can actually get some data.

**test/controllers/api/v1/items_controller_test.rb**
```rb
test "can get all items in index" do
  get "/api/v1/items"

  assert_response :success

  items = JSON.parse(response.body)

end
```

When we run our tests again, we get a semi-obnoxious error of `JSON::ParserError: A JSON text must at least contain two octets!`. This just means that we need open and closing braces for it to actually be JSON. Either `[]` or `{}`

Well that makes sense. We aren't actually rendering anything yet. Let's render some JSON from our controller.

**app/controllers/api/v1/items_controller.rb**
```rb
class Api::V1::ItemsController < ApplicationController

  def index
    render json: Item.all
  end

end
```

And... our test is passing again.

Let's take a closer look at the response. Put a pry on line six in the test, right below where we make the request.

If you just type `response` you can take a look at the entire response object. We care about the response body. If you enter `response.body` you can see the data that is returned from the endpoint. We are getting back two items that we never created - this is data served from fixtures. Please feel free to edit the data in the fixtures file as you see fit.

The data we got back is json, and we need to parse it to get a Ruby object. Try entering `JSON.parse(response.body)`. As you see, the data looks a lot more like Ruby after we parse it. Now that we have a Ruby object, we can make assertions about it.


**test/controllers/api/v1/items_controller_test.rb**
```rb
test "can get all items in index" do
  get "/api/v1/items"

  assert_response :success

  items = JSON.parse(response.body)
  assert_equal items.count, 2
end
```


### 3. Implement ItemsController#show test

Now we are going to test drive the `/api/v1/items/:id` endpoint. From the `show` action, we want to return a single item.

First, let's write the test. As you can see, we have added a key `id` in the request:

**test/controllers/api/v1/items_controller_test.rb**
```rb
  test "can get one item by its id" do
    id = items(:one).id

    get "/api/v1/items/#{id}"
    item = JSON.parse(response.body)

    assert_response :success
    assert_equal item["id"], id
  end
```

Try to test drive the implementation before looking at the code below.
---

Run the tests and the first error we get is: `ActionController::RoutingError: No route matches [GET] "/api/v1/items/980190962"`, or some other similar route. Fixtures has created an id for us.

Let's update our routes.

**config/routes.rb**
```rb
namespace :api do
  namespace :v1 do
    resources :items, only: [:index, :show]
  end
end
```

Run the tests and... `The action 'show' could not be found for Api::V1::ItemsController`.

Add the action and declare what data should be returned from the endpoint:

```rb
def show
  render json: Item.find_by(id: params[:id])
end
```

Run the tests and... we should have two passing tests.

### 4. Implement Api::V1::ItemsController#create

Let's start with the test. Since we are creating a new item, we need to pass data for the new item via the HTTP request. We can do this easily by adding the params as a key-value pair. Also note that we swapped out the `get` in the request for a `post` since we are creating data.

Also note that we aren't parsing the response to access the last item we created, we can simply query for the last Item record created.

**test/controllers/api/v1/items_controller_test.rb**
```rb
test "can create a new item" do
  item_params = { name: "Saw", description: "I want to play a game" }

  post "/api/v1/items", params: {item: item_params}
  item = Item.last

  assert_response :success
  assert_equal item_params[:name], item.name
end
```

First, we need to add the route and the action.
**config/routes.rb**
```rb
namespace :api do
  namespace :v1 do
    resources :items, only: [:index, :show, :create]
  end
end
```

**app/controllers/api/v1/items_controller.rb**
```rb
def create
end
```

Run the tests... and the test fails. It should be telling you that it was expecting "Saw" but instead got "Hammer" or "Screwdriver", depending on the order fixtures created them. That's because we aren't actually creating anything yet.

We are going to create an item with the incoming params. Let's take advantage of all the niceties Rails gives us and use strong params.

**app/controllers/api/v1/items_controller.rb**
```rb
def create
  render json: Item.create(item_params)
end

private

def item_params
  params.require(:item).permit(:name, :description)
end
```

Run the tests and we should have 3 passing tests.

### 5. Implement Api::V1::ItemsController#update

Like before, let's add a test.

This test looks very similar to the previous one we wrote. Note that we aren't making assertions about the response, instead we are accessing the item we updated from the database to make sure it actually updated the record.

**test/controllers/api/v1/items_controller_test.rb**
```rb
test "can update an existing item" do
  id = items(:one).id
  previous_name = items(:one).name
  item_params = { name: "Sledge" }

  put "/api/v1/items/#{id}", params: {item: item_params}
  item = Item.find_by(id: id)

  assert_response :success
  refute_equal previous_name, item.name
  assert_equal "Sledge", item.name
end
```

Try to test drive the implementation before looking at the code below.
---

**config/routes.rb**
```rb
namespace :api do
  namespace :v1 do
    resources :items, only: [:index, :show, :create, :update]
  end
end
```

**app/controllers/api/v1/items_controller.rb**
```rb
def update
  render json: Item.update(params[:id], item_params)
end
```

### 6. Implement Api::V1::ItemsController#destroy

Ok, last endpoint to test and implement: destroy!

In this test, the last line in this test is refuting the existence of the item we created at the top of this test.

**test/controllers/api/v1/items_controller_test.rb**
```rb
test "can destroy an item" do
  item = items(:one)

  delete "/api/v1/items/#{item.id}"

  assert_response :success
  refute Item.find_by(id: item.id)
end
```

We can also use Minitest's [assert_difference](http://apidock.com/rails/ActiveSupport/Testing/Assertions/assert_difference) method as an extra check. In our case, `assert_difference` will check that the numeric difference of `Item.count` before and after the block is run is `-1`.

```rb
test "#destroy" do
  item = items(:one)

  assert_difference('Item.count', -1) do
    delete "/api/v1/items/#{item.id}"
  end

  assert_response :success
  refute Item.find_by(id: item.id)
end
```

Make the test pass.
---

**config/routes.rb**
```rb
namespace :api do
  namespace :v1 do
    resources :items, except: [:new, :edit]
  end
end
```

**app/controllers/api/v1/items_controller.rb**
```rb
def destroy
  Item.delete(params[:id])
end
```

## Discussion

In this session, we'll be looking at some techniques to test an API
within our own application.

### Terminology

* "Internal" API -- In this context we say this to mean an API within
our own application, i.e. an API we are _providing_
* This is in contrast to a "3rd party" API that we might consume from
another entity such as twitter or instagram
* Sometimes people say "internal API" to refer to an API that is reserved for
internal use only (for example in a service-oriented architecture)
* They might also have an "external" API hosted in the same application, which
could be intended for use by other consumers outside of the organization

### Topics

* Good news -- testing an API is often simpler than testing a more complicated UI involving HTML (and possibly JS)
* Generally when testing an API we are able to treat it in a more "functional" way -- that is, data in, data out
* Controller tests can often be a good fit for this, although we can use full-blown integration/feature tests as well
* What are we looking for? Given the proper inputs (query parameters, headers) our application should provide the proper data (JSON, XML, etc.)
* Looking for edge cases -- what about bad inputs? Bad request headers? Authentication failures?
* Recall the main point about APIs -- they are designed to be machine readable rather than human readable. For this reason we will often care more about response codes with an API
* Proper response code handling can be very useful to automated clients, since they can use this information to take correct action in response

## Supporting Materials

* [Notes](https://www.dropbox.com/s/zxftnls0at2eqtc/Turing%20-%20Testing%20an%20Internal%20API%20%28Notes%29.pages?dl=0)
* [Video 1502](https://vimeo.com/129722778)
* [Video 1412](https://vimeo.com/126844655)
