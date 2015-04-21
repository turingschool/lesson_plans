---
title: Authorization in Rails
length: 90
tags: authorization, rails
---

## Goals

* authorize users based on roles
* use namespacing for routes
* use a before action to protect admin functionality

## Lecture

* refactor to put login and logout in application.html.erb:

```erb
  <% if current_user %>
    <%= link_to "Logout", logout_path, method: :delete %>
  <% else %>
    <%= link_to "Login", login_path %>
  <% end %>
```

* migration to add "role:integer" to user table, default 0

```ruby
class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: 0
  end
end
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


