---
title: Authorization in Rails
length: 90
tags: authorization, rails
---

## Goals

* authorize users based on roles
* write a feature test that uses a stubbing library
* use namespacing for routes
* use a before action to protect admin controllers

## Structure

## Video

## Repository

Use the `authentication-finished` branch of the [authentication-authorization repo](https://github.com/turingschool-examples/authentication-authorization). 

## Lecture

## Code-Along

Let's start by refactoring. We'll add login and logout links in application.html.erb. Remove any references to `flash` and any login/logout links from individual views. Your `application.html.erb` should look like this:

```erb
  <% if current_user %>
    Welcome, <%= current_user.username %>.
    <%= link_to "Logout", logout_path, method: :delete %>
  <% else %>
    <%= link_to "Login", login_path %>
  <% end %>

  <% flash.each do |name, msg| %>
    <%= content_tag :div, msg, :id => "flash_#{name}" %>
  <% end %>
```

We'll also quickly add a few flash messages in the sessions controller and users controller so that you can see how the content tag is dynamic:

```ruby
# users controller

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user # user_path(@user)
    else
      flash.now[:error] = @user.errors.full_messages.join(", ")
      render :new
    end
  end
```

* We'll also add a validation on the User model:

```ruby
  validates :username, presence: true, 
                       uniqueness: true
```

* Ok. Let's start with a test for admin functionality. Our client has asked for categories in this application, and only an admin should be able to access the category index. Let's start with a test.

```
$ touch test/integration/admin_categories_test.rb
```

```ruby
require "test_helper"

class AdminCategoriesTest < ActionDispatch::IntegrationTest

  test 'logged in admin sees categories index' do
    admin = User.create(username: "admin",
                        password: "password",
                        role: 1)

    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit admin_categories_path
    assert page.has_content?("All Categories")
  end
end
```

* migration to add "role:integer" to user table, default 0

```ruby
class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: 0
  end
end
```

* migrate

```
$ rake db:migrate
```

* Run your tests: `rake test`. You should get an error about undefined method `any_instance`. This is a stubbing method that comes from the Mocha library. To fix this, add `gem 'mocha'` to our Gemfile and bundle, then `require 'mocha/mini_test'` in the test helper. 

* add roles enum to model

```ruby
class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, 
                       uniqueness: true

  enum role: %w(default admin)
end
```

* routes for admin

```ruby
  namespace :admin do
    resources :categories
  end
```

* run `rake routes`:

```
             Prefix Verb   URI Pattern                          Controller#Action
              users POST   /users(.:format)                     users#create
           new_user GET    /users/new(.:format)                 users#new
               user GET    /users/:id(.:format)                 users#show
   admin_categories GET    /admin/categories(.:format)          admin/categories#index
                    POST   /admin/categories(.:format)          admin/categories#create
 new_admin_category GET    /admin/categories/new(.:format)      admin/categories#new
edit_admin_category GET    /admin/categories/:id/edit(.:format) admin/categories#edit
     admin_category GET    /admin/categories/:id(.:format)      admin/categories#show
                    PATCH  /admin/categories/:id(.:format)      admin/categories#update
                    PUT    /admin/categories/:id(.:format)      admin/categories#update
                    DELETE /admin/categories/:id(.:format)      admin/categories#destroy
              login GET    /login(.:format)                     sessions#new
                    POST   /login(.:format)                     sessions#create
             logout DELETE /logout(.:format)                    sessions#destroy
```

* folder for admin namespaced controllers

```
$ mkdir app/controllers/admin
```

* base controller for admin

```
$ touch app/controllers/admin/base_controller.rb
```

* Inside of that file:

```ruby
class Admin::BaseController < ApplicationController
  before_action :require_admin

  def require_admin
    render file: "/public/404" unless current_admin? 
  end
end
```

* define current_admin? in the application controller

```ruby
  def current_admin?
    current_user && current_user.admin?
  end
```

* make admin categories controller:

```
$ touch app/controllers/admin/categories_controller.rb
```

* Inside of that file:

```ruby
class Admin::CategoriesController < Admin::BaseController
  def index
  end
end
```

* Create a views folder for admin/categories:

```
$ mkdir app/views/admin
$ mkdir app/views/admin/categories
$ touch app/views/admin/categories/index.html.erb
```

* add text for what you're testing:

```erb
<h1>All Categories</h1>
```

* We can also add a test to make sure a default user does not see admin categories index:

```ruby
  test 'default user does not see admin categories index' do
    user = User.create(username: "default_user",
                        password: "password",
                        role: 0)

    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_categories_path
    refute page.has_content?("All Categories")
    assert page.has_content?("The page you were looking for doesn't exist.")
  end
```

## Work Time

### User: 
* can view index and show page for tools that belong to self
* cannot update users besides self
* cannot create see or update other users tools


### Admin: 
* can create, update, read, and delete tools
* cannot update users besides self
* can CRUD categories

## Other Resources:
