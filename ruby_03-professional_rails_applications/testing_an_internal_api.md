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

### Block 1: 30 minutes

* 5  - Conceptual discussion
* 5  - Application setup
* 10 - Implement the #index controller test
* 5  - Implement the #index API endpoint
* 5  - Break

### Block 2: 30 minutes

* 10 - Workshop 1: Implementing the #show controller test
* 5  - Demo: How to implement the #show controller test
* 5  - Implement the #create controller test
* 5  - Implement the #create API endpoint
* 5  - Break

### Block 3: 30 minutes

* 10 - Workshop 2: Implementing the #update controller test
* 5  - Demo: How to implement the #update controller test
* 5  - Implement the #destroy controller test
* 5  - Implement the #destroy API endpoint
* 5  - Recap

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
$ rails new testing_internal_apis --skip-spring --skip-turbolinks -d postgresql
$ cd testing_internal_apis
$ bundle
$ bundle exec rake db:create
```

Add the gem 'responders' to your Gemfile. We need to do this because with the launch of Rails 4.2 the use of `respond_with` and `respond_to` was split to an external gem; the Responders gem. Read more about the split [here](http://stackoverflow.com/questions/25998437/why-is-respond-with-being-removed-from-rails-4-2-into-its-own-gem).

**Gemfile**
```rb
gem 'responders'
```

Also add `require 'minitest/pride'` to your test_helper because colors make it more fun to test.

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

We name the test `#index` to indicate that `index` is a method (`#`) we are testing.

On the first line of the test we are making the request. We want a `get` request to `items#index` and we would like to get json back. At the end of the test we are asserting that the response was a success.

**test/controllers/api/v1/items_controller_test.rb**

```rb
require 'test_helper'

class Api::V1::ItemsControllerTest < ActionController::TestCase
  test "#index" do
    get :index, format: :json

    assert_response :success
  end
end
```

Lets' make the test pass!

First, the test tells us that we don't have a matching route. `No route matches {:action=>"index", :controller=>"api/v1/items", :format=>:json}`. Add the namespaced routes:

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

Lastly, we get the error `Missing template api/v1/items/index...`. Rails is trying to find a namespaced template to render. But since we just want to serve data and not return a template, we need to tell our controller that we are going to respond with JSON and not render a view template.

On the line right below the class declaration we are using the `respond_to` method (that the Responders gem make available to us) to declare on the class level what formats our controller responds to. Then, in the index method we are using `respond_with` (also from the Responders gem) to declare what data should be returned from this action.

**app/controllers/api/v1/items_controller.rb**
```rb
class Api::V1::ItemsController < ApplicationController
  respond_to :json

  def index
    respond_with Item.all
  end

end
```

And... our test is passing. At this point, our test isn't very robust. It's just asserting a successful response. Instead, we want to parse the response body and assert that we are getting actual items back.

Put a pry on line six in the test, right below where we make the request.

If you just type `response` you can take a look at the entire response object. We care by the response body. If you enter `response.body` you can see the data that is returned from the endpoint. We are getting back two items that we never created - this is data served from fixtures. Please feel free to edit the data in the fixtures file as you see fit.

The data we got back is json, and we need to parse it to get a Ruby object. Try entering `JSON.parse(response.body)`. As you see, the data looks a lot more like Ruby after we parse it. Now that we have a Ruby object, we can make assertions about it.

**test/controllers/api/v1/items_controller_test.rb**
```rb
test "#index" do
  get :index, format: :json

  items = JSON.parse(response.body)

  assert_response :success
  assert_equal items.count, 2
end
```

### 3. Implement ItemsController#show test

Now we are going to test drive the `Api::V1::Items#show` endpoint. From the `show` action, we want to return a single item.

First, let's write the test. As you can see, we have added a key `id` in the request:

**test/controllers/api/v1/items_controller_test.rb**
```rb
  test "#show" do
    id = Item.first.id

    get :show, id: id, format: :json
    item = JSON.parse(response.body)

    assert_response :success
    assert_equal item["id"], id
  end
```

Try to test drive the implementation before looking at the code below.
---

Run the tests and the first error we get is: `No route matches {:action=>"show", :controller=>"api/v1/items", :format=>:json, :id=>1}`.

Let's add a route.

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
  respond_with Item.find_by(id: params[:id])
end
```

Run the tests and... we should have two passing tests.

### 4. Implement Api::V1::ItemsController#create

Let's start with the test. Since we are creating a new item, we need to pass data for the new item via the HTTP request. We can do this easily by adding the params as a key-value pair. Also note that we swapped out the `get` in the request for a `post` since we are creating data.

Also note that we aren't parsing the response to access the last item we created, we can simply query for the last Item record created.

**test/controllers/api/v1/items_controller_test.rb**
```rb
test "#create" do
  item_params = { name: "Computer", descripion: "awesome computer" }

  post :create, item: item_params, format: :json
  item = Item.last

  assert_response :success
  assert_equal item.name, item_params[:name]
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

Run the tests... and we are getting the `Missing template` error. We are going to create an item with the incoming params. Let's take advantage of all the niceties Rails gives us and use strong params.

**app/controllers/api/v1/items_controller.rb**
```rb
def create
  respond_with Item.create(item_params)
end

private

def item_params
  params.require(:item).permit(:name, :description)
end
```

We still get an error. Now, Rails is trying to find an `item_url`. Rails is creating the resources both for json and html, even though we aren't using any html. We need to specify that we are not going to use `item_url` and therefore don't need to set it. We do this by explicitly stating that the location is `nil`.

**app/controllers/api/v1/items_controller.rb**
```rb
def create
  respond_with Item.create(item_params), location: nil
end
```

Run the tests and we should have 3 passing tests.

### 5. Implement Api::V1::ItemsController#update

Like before, let's add a test.

This test looks very similar to the previous one we wrote. Note that we aren't making assertions about the response, instead we are accessing the item we updated from the database to make sure it actually updated the record.

**test/controllers/api/v1/items_controller_test.rb**
```rb
test "#update" do
  id = Item.first.id
  previous_name = Item.first.name
  item_params = { name: "NEW NAME" }

  put :update, id: id, item: item_params, format: :json
  item = Item.find_by(id: id)

  assert_response :success
  refute_equal previous_name, item.name
  assert_equal "NEW NAME", item.name
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
  respond_with Item.update(params[:id], item_params)
end
```

### 6. Implement Api::V1::ItemsController#destroy

Ok, last endpoint to test and implement: destroy!

In this test, the last line in this test is refuting the existence of the item we created at the top of this test.

**test/controllers/api/v1/items_controller_test.rb**
```rb
test "#destroy" do
  item = Item.last

  delete :destroy, id: item.id, format: :json

  assert_response :success
  refute Item.find_by(id: item.id)
end
```

We can also use Minitest's [assert_difference](http://apidock.com/rails/ActiveSupport/Testing/Assertions/assert_difference) method as an extra check. In our case, `assert_difference` will check that the numeric difference of `Item.count` before and after the block is run is `-1`.

```rb
test "#destroy" do
  item = Item.last

  assert_difference('Item.count', -1) do
    delete :destroy, id: item.id, format: :json
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
  respond_with Item.delete(params[:id])
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
