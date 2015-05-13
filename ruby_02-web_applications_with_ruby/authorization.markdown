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

## Lecture

Let's start by refactoring. We'll add login and logout links in application.html.erb. Remove any references to `flash` and any login/logout links from individual views. Your `application.html.erb` should look like this:

```erb
  <% if current_user %>
    Logged in as <%= current_user.username %>.
    <%= link_to "Logout", logout_path, method: :delete %>
  <% else %>
    <%= link_to "Login", login_path %>
  <% end %>

  <% flash.each do |name, msg| %>
    <%= content_tag :div, msg, :id => "flash_#{name}" %>
  <% end %>
```

Ok. Let's start with a test for admin functionality. Let's assume that there are categories in this application, and only an admin should be able to access the category index.

```
$ touch spec/features/admin_categories_spec.rb
```

```ruby
require "rails_helper"

RSpec.describe 'admin categories' do
  context 'with admin logged in' do

    let(:admin) do 
      User.create(first_name: "Admin", 
                  last_name: "Admin",
                  username: "admin",
                  password: "password",
                  role: 1)
    end

    it 'displays categories' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
      visit admin_categories_path
      expect(page).to have_content("Listing Categories")
    end
  end
end
```

* We'll also need to add `gem 'mocha'` to our Gemfile and bundle. 

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

* add roles enum to model

```ruby
class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, 
                       uniqueness: true

  enum role: %w(default, admin)
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
    render "/public/404" unless current_admin? 
  end
end
```

* define current_admin? in the application controller

```ruby
  def current_admin?
    current_user && current_user.admin?
  end
```

* define `admin?` on user model

```ruby
  def admin?
    role == "admin"
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
