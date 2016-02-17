---
title: Forms and Route Helpers in Rails
length: 180
tags: forms, routes, helpers, rails
---

## Learning Goals

* construct forms using built-in Rails form helpers
* construct links using built-in Rails helpers
* create user interfaces for CRUD functionality in a Rails app

## Setup

```
$ rails new tool_chest
$ cd tool_chest
$ rails g model Tool name:text price:integer quantity:integer
$ rake db:migrate
```

Let's add a few tools from the console:

```
$ rails c
Tool.create(name: "Rotary cutter", price: 10000, quantity: 10)
Tool.create(name: "Hammer", price: 1599, quantity: 10)
Tool.create(name: "Rake", price: 2000, quantity: 10)
Tool.create(name: "Cheese slicer", price: 599, quantity: 10)
Tool.create(name: "Saw", price: 1999, quantity: 10)
Tool.create(name: "Water timer", price: 2399, quantity: 10)
```

## Routes

Add RESTful routes for Tools:

```ruby
Rails.application.routes.draw do
  resources :tools
end
```

Run `$ rake routes` and look at the output:

```
    Prefix Verb   URI Pattern                    Controller#Action
     tools GET    /tools(.:format)               tools#index
           POST   /tools(.:format)               tools#create
  new_tool GET    /tools/new(.:format)           tools#new
 edit_tool GET    /tools/:id/edit(.:format)      tools#edit
      tool GET    /tools/:id(.:format)           tools#show
           PATCH  /tools/:id(.:format)           tools#update
           PUT    /tools/:id(.:format)           tools#update
           DELETE /tools/:id(.:format)           tools#destroy
```

Create a controller for Tools:

```
$ touch app/controllers/tools_controller.rb
```

### Index

Inside of that file:

```ruby
class ToolsController < ApplicationController

  def index
    @tools = Tool.all
  end
end
```

Create a view:

```
$ mkdir app/views/tools
$ touch app/views/tools/index.html.erb
```

Inside of that file:

```erb
<% @tools.each do |tool| %>
  <%= tool.name %> - <%= tool.quantity %>
<% end %>
```

Start up your server (`rails s`) and navigate to `localhost:3000/tools`.

## Route Helpers

We can use the prefixes from our `rake routes` output to generate routes:

```
    Prefix Verb   URI Pattern                    Controller#Action
     tools GET    /tools(.:format)               tools#index
           POST   /tools(.:format)               tools#create
  new_tool GET    /tools/new(.:format)           tools#new
 edit_tool GET    /tools/:id/edit(.:format)      tools#edit
      tool GET    /tools/:id(.:format)           tools#show
           PATCH  /tools/:id(.:format)           tools#update
           PUT    /tools/:id(.:format)           tools#update
           DELETE /tools/:id(.:format)           tools#destroy
```

If we want to go to `/tools`, we can create a link to `tools_path`. If we want to go to `/tools/new`, we can create a link to `new_tool_path`. Notice that we just add on `_path` to the prefix.

Rails also has a link helper that looks like this:

```erb
<%= link_to "Tool Index", tools_path %>
```

Which will generate the equivalent of:

```erb
<a href="/tools">Tool Index</a>
```

We can add a link to view individual tools with this:

Inside of that file:

```erb
<% @tools.each do |tool| %>
  <%= link_to tool.name, tool_path(tool) %>
<% end %>
```

1) What is `tool_path(tool)`?

### Show

Add a route for show:

```ruby
class ToolsController < ApplicationController

  def index
    @tools = Tool.all
  end

  def show
    @tool = Tool.find(params[:id])
  end
end
```

Let's create a view to show the individual tool: `$ touch app/views/tools/show.html.erb`.

Inside of that file:

```erb
<h1><%= @tool.name %> - <%= @tool.quantity %></h1>
<h3><%= @tool.price %></h3>
```

### New

1) Ok, back to the index (`/tools`). How can we create a link to go to a form where we can enter a new tool? Let's put that link on our `index.html.erb` page.

This link relies on a new action in our controller, so let's add that:

```ruby
class ToolsController < ApplicationController

  def index
    @tools = Tool.all
  end

  def show
    @tool = Tool.find(params[:id])
  end

  def new
    @tool = Tool.new
  end
end
```

Add a `new.html.erb` file in your tools views folder.

Inside of that file:

```erb
<%= form_for(@tool) do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>
  <%= f.label :price %>
  <%= f.text_field :price %>
  <%= f.label :quantity %>
  <%= f.text_field :quantity %>
  <%= f.submit %>
<% end %>
```

Let's start up our server and check out this form. If we inspect the elements, where will this form go when we click submit?

### Create

Add a `create` action in the controller:

```ruby
class ToolsController < ApplicationController

  def index
    @tools = Tool.all
  end

  def show
    @tool = Tool.find(params[:id])
  end

  def new
    @tool = Tool.new
  end

  def create
    @tool = Tool.new(tool_params)
    if @tool.save
      redirect_to tool_path(@tool)   # Rails is smart enough to also do redirect_to @tool
    else
      render :new
    end
  end

  private

  def tool_params
    params.require(:tool).permit(:name, :price, :quantity)
  end
end
```

### Edit

Let's go to the show view and add a link to edit. What will this link look like?

Add a route in the controller for edit.

Add a view for edit which contains a `form_for(@tool)`. This form looks EXACTLY THE SAME as our `new.html.erb`. What can we do to get rid of duplicated code?

Better question: If we use a partial, how does Rails know which route to use depending on if it's a `new` or an `edit`?

### Update

Add an update method in the controller:

```ruby
  def update
    @tool = Tool.find(params[:id])
    if @tool.update(tool_params)
      redirect_to tool_path(@tool)
    else
      render :edit
    end
  end
```

### Destroy

Add a link on the tool show view to destroy the tool:

```erb
<%= link_to "Delete", tool_path(@tool), method: :delete %>
```

Add a `destroy` action in your controller:

```ruby
  def destroy
    @tool = Tool.find(params[:id])
    @tool.destroy
    redirect_to tools_path
  end
```
