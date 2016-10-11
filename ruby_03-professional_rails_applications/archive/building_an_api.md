---
title: Building an API
length: 120
tags: apis, json, respond_to, rails
---

## Building an API

### Discussion -- Being an API Provider

* Where is the real "value" in an average web app?
* Ultimately many web apps are just a layer on top of putting data
into a database and taking it out again
* APIs are a tool for exposing this data more directly than we do
in a typical (HTML) user interface
* What differentiates an API from a UI -- Machine readability

__Questions to Consider when Providing an API__

* Which formats you will accept and return?
* Parameter inputs you will accept -- are any required?
* Will you use authentication or authorization?

More Sophisticated:

* Rate Limiting / Usage Tracking
* Caching

## Workshop -- Adding an API to storedom

### Setup

```
$ git clone -b building_api https://github.com/turingschool-examples/storedom.git building_api
$ rake db:{drop,create,migrate,seed}
```

### Background

As with most things in programming there are multiple ways to serve an API. In this lesson, we'll approach it using a basic approach and get into namespacing and versioning your API. This lesson does not cover JBuilder or ActiveModel::Serializer. If you are interested in that, check out this [lesson plan](serving_up_an_api.md).

### Iteration 1: Setup the existing `ItemsController` to serve JSON

Rails makes serving multiple formats from a controller mostly easy. Let's first set up our `index` action. Here we are using the `respond_to` block to serve `HTML`, `JSON`, and (_gasp!_) `XML`.

```ruby
class ItemsController < ApplicationController
  # ...

  def index
    @items = Item.all
   
    respond_to do |format|
      format.html { @items }
      format.json { render json: @items }
      format.xml  { render xml:  @items }
    end
  end

  # ...
end
```

Now we should be able to navigate to `/items`, `/items.json`, and `/items.xml`.

Try the same technique for the `show` action.

```ruby
class ItemsController < ApplicationController
  # ...

  def show
    @item = Item.find_by(id: params[:id])
 
    respond_to do |format|
      format.html { @item }
      format.json { render json: @item }
      format.xml  { render xml:  @item }
    end
  end

  # ...
end
```

*Think About It*

1. Why does it make sense to start with `index` and `show` instead of something like `create`?
1. Which actions shouldn't we add this functionality to? Why?
1. What do you dislike about this approach so far?

Let's clean up some of that repetition. Right now we are creating a `respond_to` block for each action. We can actually use `respond_to` at the class level to cut down on our lines of code. We will also need to use the `respond_with` method in each action.

```ruby
class ItemsController < ApplicationController
  respond_to :html, :json, :xml
 
  def index
    @items = Item.all
 
    respond_with @items
  end
 
  def show
    @item = Item.find_by(id: params[:id])
 
    respond_with @item
  end
end
```

### Workshop 1

1. Modify the orders controller so that it accepts json and xml requests using respond_to in the index and show actions.
1. Refactor your implementation so that it uses respond_to at the class level and respond_with at the action level.

### Iteration 2: Add `create` and `update`

This is where things start to get messy. `respond_with` has limitations. If we want to customize messages or add redirects then we will need to fall back to `respond_to`.

*Think About It*

1. What should happen if we successfully save using HTML? What about JSON and XML? How do they differ?
1. What should happen if we the save fails in HTML? What about JSON and XML? How do they differ?

Here is some code to get this to work.

```ruby
def create
  @item = Item.new(item_params)

  if @item.save
    respond_to do |format|
      format.html { redirect_to items_path, notice: "The item was created." }
      format.json { render json: @item }
      format.xml  { render xml:  @item }
    end
  else
    respond_to do |format|
      format.html do
        flash.now[:notice] = "The item was not created."
        render :new
      end

      format.json { render json: { messages: @item.errors.messages}, status: 400 }
      format.xml  { render xml:  { messages: @item.errors.messages}, status: 400 }
    end
  end
end
```

This is starting to get messy, but let's go with it for now. We can refactor after we get it working.

It's important to confirm that your code is doing what you think it should. Let's send a POST request to `/items.json` using cURL, Postman, or a similar app.

*Think About It*

1. What params do we need to send over?

What was the response after sending your request? I received a `422 Unprocessable Entity`. Read the error message to determine why this is.

So what's the fix? Go read the commented out code inside of your `ApplicationController`. Can you get it to work?

*Think About It*

1. Why does this "fix" our error?
1. What do you suspect are the downsides of this approach?

Let's do something similar for our `update` action.

```ruby
def update
  @item = Item.find(params[:id])

  if @item.update_attributes(item_params)
    respond_to do |format|
      format.html { redirect_to items_path, notice: "The item was updated." }
      format.json { render json: @item }
      format.xml  { render xml:  @item }
    end
  else
    respond_to do |format|
      format.html do
        flash.now[:notice] = "The item was not updated."
        render :edit
      end

      format.json { render json: { messages: @item.errors.messages}, status: 400 }
      format.xml  { render xml:  { messages: @item.errors.messages}, status: 400 }
    end
  end
end
```

#### Iteration 3: Separating Responsibilities

Combining machine and human controllers is a bad idea due to the complexity that arises. As it stands we need to write our actions in a way that accounts for both HTML, JSON, and XML. The actions above would be much cleaner if split out.

We can split out responsibilities using namespacing and creating separate controllers.

```ruby
# routes.rb

namespace :api do
  namespace :v1 do
    resources :items, except: [:new, :edit]
  end
end
```

Why did we exclude `new` and `edit`? Would we ever want a JSON view for them?

This will create endpoints for `/items` nested under `/api/v1`. e.g. `GET /api/v1/items.json`. Specifying `.json` every time is a bit cumbersome. We can specify that we want to default to JSON instead of HTML.

```ruby
namespace :api, defaults: { format: :json } do
  namespace :v1 do
    resources :items, except: [:new, :edit]
  end
end
```

Create a versioned single responsibility controller for items.
Add the supporting routes.
Add the index, show, create, update and delete actions.
Explain why you don’t need new and edit.
Show that it works via Postman.

* [notes](https://www.dropbox.com/s/13amb27emariz2q/Turing%20-%20Building%20an%20API%20%28Notes%29.pages?dl=0)

Topics:

* code-a-long adding an API to storedom
* using `respond_to` to handle multiple request formats
* using ActiveRecord default `to_json` / `to_xml` to handle serialization
* Using routing namespaces to version and partition dedicated API controllers
