---
title: Intro to MVC
length: 60
tags: rails, mvc
---

## Learning Goals

* understand why MVC is a useful model and how it's used in Rails
* explain the responsibilities of each component of an MVC application
* diagram the typical MVC request/response loop

## Lecture

* clone the [mvc-rest-example](http://github.com/rwarbelow/mvc-rest-example) repo

### What is the Rails Framework?

* library that sets up a large part of the code for you
* takes care of basic configuration
* you write the customizable parts of your application

### What is MVC in Rails?

* Model/View/Controller
* Request/response loop -- Here's [an illustration of the whole flow](http://tutorials.jumpstartlab.com/images/rails_mvc.png)
* separates the responsibilities of an application into three layers (MVC) 

#### Receiving the Request - Router

* application receives a request
* router recognizes URL and matches it to a controller action
* example `routes.rb` file:

```
get '/articles', to: 'articles#index'
```

* More about [Rails Routing](http://guides.rubyonrails.org/routing.html)

#### Controller: Processing the Request

* controllers live in `app/controllers`
* sits between the model (database interface) and the view (presentation interface)
* handles HTTP request and determines what to do
* can access parameters from URLs or forms
* fetches, saves, queries, or delegates work to a model
* generally returns HTML, but can also return JSON, CSV, XML, etc.
* example `articles_controller.rb` file:

```ruby
class ArticlesController
	def index
		@articles = Article.all   #fetches all articles from the Article model
	end
end
```

* `rails generate controller Authors` will generate a controller, a view folder, test files, a helper, a JavaScript file, and a CSS file.
* More about the [Controller](http://guides.rubyonrails.org/action_controller_overview.html)

#### Model: Business Logic & Database

* models live in `app/models`
* acts to represent the "things" in your application -- articles, users, items, etc.
* relates Ruby objects to records in the database
* encapsulates logic for validations, associations, and any business logic you define for the model
* method names are provided for column names in database tables (ie: `user.first_name`, `user.last_name` when first_name and last_name are columns in the database)
* models can be POROs (Plain Old Ruby Objects) or can inherit from ActiveRecord::Base
* class that inherit from ActiveRecord::Base include many useful methods

```ruby
class Article
	belongs_to :author
	has_many   :comments

	def some_custom_method
		# your code here
	end
end
```
* `rails generate model Author first_name:string last_name:string` will generate a model, a migration, and test files.
* More about [Models](http://guides.rubyonrails.org/active_record_basics.html)

#### View: Output Template

* views live in `app/views`
* provide a template to display the application's data
* most templates are written using embedded Ruby and HTML
* generally one view template per controller action -- for example, if you have `def index` in your controller, you will have a `index.html.erb` in your views folder

* More about [Views](http://guides.rubyonrails.org/action_view_overview.html)

## Other Resources

* http://www.tutorialspoint.com/ruby-on-rails/rails-framework.htm
* http://en.wikibooks.org/wiki/Ruby_on_Rails/Getting_Started/Model-View-Controller
* http://www.codelearn.org/ruby-on-rails-tutorial/mvc-in-rails
* more on Rails command line generators [here](http://guides.rubyonrails.org/command_line.html)
