## Authorization in Rails

### Learning Goals

* Authorize users based on roles
* Write a feature tests that use a stubbing library
* Implement namespacing for routes
* Use a before action to protect admin controllers

### Setup

Use the `authentication-finished` branch of the [authentication-authorization repo](https://github.com/turingschool-examples/authentication-authorization). 

### Warm Up

Fork the following [gist](https://gist.github.com/case-eee/9ca3c160b12297caff7e7b5c4126a340) and answer the questions. It's more than likely that you'll need to research on your own to answer these questions.

### Recap

We'll answer all the questions from the gist as a class. 

### Adding Authentication to our Application

Let's first add a validation on the User model to ensure that `username` is present and unique. We wouldn't want to user's to have the same username if that's what we are using to uniquely identify user's when they login.

```ruby
  validates :username, presence: true, 
                       uniqueness: true
```

**Note**: uniqueness is something that can be more complicated than it first looks. This is an [awesome article](https://robots.thoughtbot.com/the-perils-of-uniqueness-validations) that dives deeper into uniqueness validations. Long story short - a uniqueness validation via ActiveRecord is NOT enough to ensure uniqueness in our database. This image provides an explanation:

![50% Uniqueness](https://images.thoughtbot.com/unique_without_index.png)

Next, let's create a test for the admin functionality we want to create. Our client has asked for categories in this application, and only an admin should be able to access the category index. 

We'll need to create a new test file in the `test/integration` folder.

```
$ touch test/integration/admin_categories_test.rb
```

Let's write our test. 

```
require "test_helper"

class AdminCategoriesTest < ActionDispatch::IntegrationTest

  test 'logged in admin sees categories index' do
    admin = User.create(username: "penelope",
                        password: "boom",
                        role: 1)

    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit admin_categories_path
    assert page.has_content?("Admin Categories")
  end
end
```

Because we're stubing out a method, we'll need to add the `mocha` gem - similar to yesterday. We'll need to add `gem 'mocha'` to our Gemfile and bundle, then `require 'mocha/mini_test'` in the test helper. 

We need the `role` field to exist so we can determine what level of authorization a user has within the scope of our application. This is where `enum` comes into play. First though, we'll add a migration to add this field.

```
class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: 0
  end
end
```

Don't forget to run `rake db:migrate` to run this migration! Check your `db/schema.rb` to ensure that our schema reflects these changes.

Let's add our `enum` to our `User` model.

```
class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, 
                       uniqueness: true

  enum role: %w(default admin)
end
```

Like we mentioned before, we want admin functionality when it comes to `categories`. Only admin's should be able to see the index view of all the categories. Should we use nested resources here or namespace?

Since `admin` is never going to be it's own entity within our application, we can use `namespace`.

Add this `namespace` and the route for only the `index` to your routes (we may need to add other actions later, but for now, let's only create what we need).

```
  namespace :admin do
    resources :categories
  end
```

Whenever we add something to our `routes.rb`, verify that your output via `rake routes` is what you expect.

Remember when we want to use namespace, we'll need all the controllers that are namespaced within that namespace folder.

```
$ mkdir app/controllers/admin
```

Because we may need admin functionality for other controllers as well, we are going to extract the code to authorize an admin into another controller.

```
$ touch app/controllers/admin/base_controller.rb
```

Inside of `base_controller.rb`, we'll create our `before_action` to authorize our admin.

```
class Admin::BaseController < ApplicationController
  before_action :require_admin

  def require_admin
    render file: "/public/404" unless current_admin? 
  end
end
```

Have we defined `current_admin?`? Nope! Let's make that happen.


```
# application_controller.rb

  def current_admin?
    current_user && current_user.admin?
  end
```

What gives us access to `current_user.admin?`?

We should be good to go with our authorization. Let's create our admin categories controller and put together the pieces.

```
$ touch app/controllers/admin/categories_controller.rb
```

Currently, we'll only need the index method and index view.

```
class Admin::CategoriesController < Admin::BaseController
  def index
  end
end
```

```
$ mkdir app/views/admin
$ mkdir app/views/admin/categories
$ touch app/views/admin/categories/index.html.erb
```

In our `admin/categories/index.html.erb`, we'll add the text that you specified in our test earlier. 

Let's run our test to see if we're passing.

We should also add a test to make sure a default user does not see admin categories index:

```
  test 'default user does not see admin categories index' do
    user = User.create(username: "pepe",
                        password: "password",
                        role: 0)

    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_categories_path
    refute page.has_content?("Admin Categories")
    assert page.has_content?("The page you were looking for doesn't exist.")
  end
```

### Questions?

### Work Time

Add the following functionality to your BookShelf application.

* As a user, I can view the index and show page for books that belong to myself.
* As a user, I cannot update users besides myself.
* As a user, I cannot create see or update other users' books.
* As an admin, I can create, update, read, and delete any books. 
* As an admin, I cannot update users besides myself
* As an admin, I can CRUD categories

