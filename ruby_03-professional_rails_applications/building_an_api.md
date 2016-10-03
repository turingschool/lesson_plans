---
title: Building an Internal API
length: 90
tags: apis, testing, requests, rails
---

## Learning Goals

* Understand how an internal API works at a conceptual level
* Use request specs to cover an internal API
* Feel comfortable writing request specs that deal with different HTTP verbs (GET, POST, PUT, DELETE)

## Structure

### Block 1: 25 minutes

* 5  - Conceptual discussion
* 10 - Intro to Factory Girl
* 5  - Application setup
* 5  - Break

### Block 2: 35 minutes

* 10 - Implement the #index request spec
* 5  - Implement the #index API endpoint
* 10 - Workshop 1: Implementing the #show request spec
* 5  - Demo: How to implement the #show request spec
* 5  - Break

### Block 3: 30 minutes

* 5  - Implement the #create request spec
* 5  - Implement the #create API endpoint
* 10 - Workshop 2: Implementing the #update request spec
* 5  - Demo: How to implement the #update request spec
* 5  - Recap

## Discussion

### API vs Web App

Where is the real "value" in an average web app?
* Ultimately many web apps are just a layer on top of putting data
into a database and taking it out again
* APIs are a tool for exposing this data more directly than we do
in a typical (HTML) user interface
* What's differentiates an API from a UI -- Machine readability

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
* Request specs can often be a good fit for this, although we can use full-blown integration/feature tests as well
* What are we looking for? Given the proper inputs (query parameters, headers) our application should provide the proper data (JSON, XML, etc.)
* Looking for edge cases -- what about bad inputs? Bad request headers? Authentication failures?
* Recall the main point about APIs -- they are designed to be machine readable rather than human readable. For this reason we will often care more about response codes with an API
* Proper response code handling can be very useful to automated clients, since they can use this information to take correct action in response

### Controller Specs vs Request Specs

* A controller spec tests the controller actions `get :index`
* A request spec tests the http request that is sent to our app `get "/api/v1/items"`
* We want to replicate the way a user would be accessing our data, thus the request specs.

## Factory Girl mini-lesson

### Why Factory Girl?

You've got to create dummy data anyway. We could use before(:each) or even before(:all) to create objects for our tests. We could also use fixtures since it comes with Rails, but both these options don't provide us an easy way to customize our data. We want to make our lives easy, so Factory Girl it is! Factory Girl is a fixtures replacement with a straightforward and easy definition syntax. With Factory Girl, you a re able to create a factory(ies), which is an object whose job it is to create other objects.

### Factory  files

Factory Girl gives us the ability to create factories. Factories are defined in ruby files, and enable you to create other objects.

Consider this test:

```ruby
describe "A Test" do
  it "tests somethings" do
    item = Item.create(name: "Some Item", description: "Some Description")

    expect(Item.last.id).to eq(item.id)
  end
end
```

With only one test, it might not seem daunting to explicitly create an object. But what happens when you need to create this object for multiple tests? Sure, you could create a before(:each) block, but then what happens when you need to customize the object and say, give it a different name. Or maybe you want to create multiple objects for only a specific test. You could end up with something like this:

```ruby
describe "A Test" do
  before(:each) do
    item = Item.create(name: "Some Item", description: "Some Description")
  end

  it "tests somethings" do
    expect(Item.last.id).to eq(item.id)
  end

  it "tests something again" do
    item2 = Item.create(name: "Another Item", description: "Another Item Description")

    expect(item.name).to_not eq(item2.name)
  end
end
```

With Factory Girl we could create an Item Factory and refactor our code to look like this:

```ruby
describe "A Test" do
  it "tests somethings" do
    item = create(:item)
    expect(Item.last.id).to eq(item.id)

    item2 = create(:item, name: "Another Item", description: "Another Item")
    expect(item.name).to_not eq(item2.name)
  end
end
```

### Setting up Factory Girl

In your Gemfile:

```ruby
gem "factory_girl_rails"
```

```sh
$ bundle
$ mkdir spec/support/factory_girl.rb
```

Inside of the factory_girl.rb file:

```ruby
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
```

Now your rails app is configured to generate factories anytime you create a model. The factories will be generated in `spec/factories`. Additionally, if you want to manually create a factory, you can create a file in the `spec/factories` folder or create an all encompassing factory file `spec/factories.rb`, though this isn't recommended if you plan on having a large list of factories.

Here is an example factory that would automatically be generated for an Item model that has the attributes of name(type: text) and description(type: string):

```ruby
FactoryGirl.define do
  factory :item do
    name "MyText"
    description "MyString"
  end
end
```

Note that the default name for the attributes is `My` and the data type of that attribute. You can change these values to reflect whatever your heart desires.

#### Factory Girl Usage

Let's continue to use this factory as an example.

```ruby
FactoryGirl.define do
  factory :item do
    name "MyText"
    description "MyString"
  end
end
```

With this factory we are now able to do the following things:

```ruby
#Item that is created but not saved to the database:
item = build(:item)

# Saved item:
item = create(:item)
```

We can also override attributes in factories like so:

```ruby
# override one attribute
item = create(:item, name: "Renamed Item")

# override all attributes
item = create(:item, name: "Renamed Item", description: "Renamed Description")
```

**Building or Creating Multiple Records**

```ruby
built_items = build_list(:item, 30)
created_items = create_list(:item, 30)
```

**Associations**

We can also have Factory Girl create factories with associations. Let's say we have users, and items belong to a user.

```ruby
FactoryGirl.define do
  factory :user do
    name: 'bieber'
  end

  factory :item do
    name: "item"
    description: "description"
    user
  end
end
```

Now when you create an item, a user will be associated with that item.

Go forth and conquer.


## Workshops

### Workshop 1: Implementing the #show controller test

* Can you implement a controller test that sends a request to the show action in the items controller?
* You need to make sure that the response is successful.
* You also need to make sure that the content that you are expecting is there.

### Workshop 2: Implementing the #update controller test

* Can you implement a request spec that sends a request to the update action in the items controller?
* You need to make sure that the response is successful.
* You also need to make sure that the content that you are expecting is there.

## Procedure

### 0. Setup

Let's start by creating a new Rails project. If you are creating an api only Rails project, you can append `--api` to your rails new line in the command line.
Read [section 3 of the docs](http://edgeguides.rubyonrails.org/api_app.html) to see how an api-only rails project is configured.

```sh
$ rails _5.0_ new building_internal_apis -T -d postgresql --api
$ cd building_internal_apis
$ bundle
$ bundle exec rake db:create
```

Add `gem 'rspec-rails` to your Gemfile.

```sh
$ bundle
$ rails g rspec:install
```

Now let's get our factories set up!

add `gem 'factory_girl_rails'` to your :development, :test block in your Gemfile.

```sh
$ bundle
$ mkdir spec/support/
$ touch spec/support/factory_girl.rb
```

Inside of the factory_girl.rb file:

```ruby
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
```

Inside of the rails_helper.rb file:

```ruby
require 'support/factory_girl'
```


### 1. TDD, Yeah you know me.

Now that our configuration is set up, we can start test driving our code. First, let's set up the test file.
In true TDD form, we need to create the structure of the test folders ourselves. Even though we are going to be creating controller files for
our api, users are going to be sending HTTP requests to our app. For this reason, we are going to call these specs `requests` instead of
`controller specs`. Let's create our folder structure.

```sh
$ mkdir -p spec/requests/api/v1
$ touch spec/requests/api/v1/items_request_spec.rb
```

Note that we are namespacing under `/api/v1`. This is how we are going to namespace our controllers, so we want to do the same in our tests.

On the first line of our test, we want to set up our data. We configured Factory Girl so let's have it generate some items for us.
We then want to make the request that a user would be making. We want a `get` request to `api/v1/items` and we would like to get
json back. At the end of the test we want to assert that the response was a success.

**spec/requests/api/v1/items_request_spec.rb**

```rb
require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items

    expect(response).to be_success
  end
end
```

Let's make the test pass!

The first error that we should receive is `Failure/Error: create_list(:item, 3) ArgumentError: Factory not registered: item`

This is because we have not created a factory yet. The easiest way to create a factory is to generate the model.

Let's generate a model.

```sh
$ rails g model Item name description:text
```

Notice that not only was the Item model created, but a factory was created for the item in
`spec/factories/items.rb`

Now let's migrate!

```sh
$ bundle exec rake db:migrate
== 20160229180616 CreateItems: migrating ======================================
-- create_table(:items)
   -> 0.0412s
== 20160229180616 CreateItems: migrated (0.0413s) =============================
```

Before we run our test again, let's take a look at the Item Factory that was generated for us.

**spec/factories/items.rb**

```rb
FactoryGirl.define do
  factory :item do
    name "MyString"
    description "MyText"
  end
end
```

We can see that the attributes are created with auto-populated data using `My` and the attribute data type.
This is boring. Let's change it to reflect a real item.

**spec/factories/items.rb**

```rb
FactoryGirl.define do
  factory :item do
    name "Screwdriver"
    description "Not just for breakfast anymore."
  end
end
```

### 2. Implement Api::V1::ItemsController#index

We're TDD'ing so let's run our tests again.

We should get the error `ActionController::RoutingError: No route matches [GET] "/api/v1/items"`
This is because we haven't created our controller yet so let's create it! Keep in mind the namespacing we used to setup the test directory.
`api/v1`

```sh
$ mkdir -p app/controllers/api/v1
$ touch app/controllers/api/v1/items_controller.rb
```

**app/controllers/api/v1/items_controller.rb**
```rb
class Api::V1::ItemsController < ApplicationController
end
```
If we were to run our tests again, we should get the same error because we haven't setup the routing.

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

Great! We are successfully getting a response. But we aren't actually getting any data. Without any data or templates, Rails 5 API
will respond with `Status 204 No Content`. Since it's a `2xx` status code, it is interpreted as a success.

Now lets see if we can actually get some data.

**spec/requests/api/v1/items_request_spec.rb**

```rb
require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
     create_list(:item, 3)

      get '/api/v1/items

      expect(response).to be_success

      items = JSON.parse(response.body)
   end
end
```

When we run our tests again, we get a semi-obnoxious error of `JSON::ParserError: A JSON text must at least contain two octets!`.
This just means that we need open and closing braces for it to actually be JSON. Either `[]` or `{}`

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

Let's take a closer look at the response. Put a pry on line eight in the test, right below where we make the request.

If you just type `response` you can take a look at the entire response object. We care about the response body. If you enter `response.body` you can see the data that is returned from the endpoint. We are getting back two items that we never created - this is data served from fixtures. Please feel free to edit the data in the fixtures file as you see fit.

The data we got back is json, and we need to parse it to get a Ruby object. Try entering `JSON.parse(response.body)`. As you see, the data looks a lot more like Ruby after we parse it. Now that we have a Ruby object, we can make assertions about it.


**spec/requests/api/v1/items_request_spec.rb**
```rb
require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get "/api/v1/items"

    expect(response).to be_success

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end
end
```

Run your tests again and they should still be passing.

### 3. Implement ItemsController#show test

Now we are going to test drive the `/api/v1/items/:id` endpoint. From the `show` action, we want to return a single item.

First, let's write the test. As you can see, we have added a key `id` in the request:

**spec/requests/api/v1/items_request_spec.rb**
```rb
  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"
    
    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item["id"]).to eq(id)
  end
```

Try to test drive the implementation before looking at the code below.
---

Run the tests and the first error we get is: `ActionController::RoutingError: No route matches [GET] "/api/v1/items/980190962"`, or some other similar route. Factory Girl has created an id for us.

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
  render json: Item.find(params[:id])
end
```

Run the tests and... we should have two passing tests.

### 4. Implement Api::V1::ItemsController#create

Let's start with the test. Since we are creating a new item, we need to pass data for the new item via the HTTP request.
We can do this easily by adding the params as a key-value pair. Also note that we swapped out the `get` in the request for a `post`
since we are creating data.

Also note that we aren't parsing the response to access the last item we created, we can simply query for the last Item record created.

**spec/requests/api/v1/items_request_spec.rb**
```rb
it "can create a new item" do
  item_params = { name: "Saw", description: "I want to play a game" }

  post "/api/v1/items", params: {item: item_params}
  item = Item.last

  assert_response :success
  expect(response).to be_success
  expect(item.name).to eq(item_params[:name])
end
```

Run the test and you should get `ActionController::RoutingError:No route matches [POST] "/api/v1/items"`

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

Run the tests... and the test fails. You should get `NoMethodError: undefined method 'name' for nil:NilClass`. That's because we aren't
actually creating anything yet.

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

**spec/requests/api/v1/items_request_spec.rb**
```rb
it "can update an existing item" do
  id = create(:item).id
  previous_name = Item.last.name
  item_params = { name: "Sledge" }

  put "/api/v1/items/#{id}", params: {item: item_params}
  item = Item.find_by(id: id)

  expect(response).to be_success
  expect(item.name).to_not eq(previous_name)
  expect(item.name).to eq("Sledge")
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

**spec/requests/api/v1/items_request_spec.rb**
```rb
it "can destroy an item" do
  item = create(:item)

  expect(Item.count).to eq(1)

  delete "/api/v1/items/#{item.id}"

  expect(response).to be_success
  expect(Item.count).to eq(0)
  expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
end
```

We can also use RSpec's [expect change](https://www.relishapp.com/rspec/rspec-expectations/v/2-0/docs/matchers/expect-change) method as an extra check. In our case, `change` will check that the numeric difference of `Item.count` before and after the block is run is `-1`.

```rb
it "can destroy an item" do
  item = create(:item)

  expect{delete "/api/v1/items/#{item.id}"}.to change(Item, :count).by(-1)

  expect(response).to be_success
  expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
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

Pat yourself on the back. You just built an API. And with TDD. Huzzah! Now go call a friend and tell them how cool you are.

## Supporting Materials

* [Notes](https://www.dropbox.com/s/zxftnls0at2eqtc/Turing%20-%20Testing%20an%20Internal%20API%20%28Notes%29.pages?dl=0)
* [Getting started with Factory Girl](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md)
* [Use Factory Girl's Build Stubbed for a Faster Test](https://robots.thoughtbot.com/use-factory-girls-build-stubbed-for-a-faster-test)
* [Building an Internal API Short Tutorial](https://vimeo.com/185342639)
