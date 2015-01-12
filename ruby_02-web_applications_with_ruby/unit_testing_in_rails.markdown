---
title: Unit Testing in Rails
length: 90
tags: rails, testing
---

## Learning Goals

* set up a model test in a Rails app
* test validations, attributes, relationships, and methods in a model
* set up a controller test in a Rails app
* test responses, redirects, variable assignment, flash messages, and template rendering in a controller

## Lecture

### Testing in Rails

* Rails likes testing -- that's why it comes with an expanded version of Minitest
* Minitest: transparent, very similar to Ruby implementation code
* RSpec: widely-used DSL that follows natural language structure. DHH is [offended by RSpec](http://www.rubyinside.com/dhh-offended-by-rspec-debate-4610.html)
* You've seen how to test with RSpec in [Contact Manager](http://tutorials.jumpstartlab.com/projects/contact_manager.html), so today we'll use Minitest. It's beneficial to get exposure to both. 

### Types of Testing in Rails

##### Testing based on test structure

* Unit Test: test a particular unit and its possible outcomes
* Integration Test: test functionality that touches more than one unit
* Acceptance Test: test full feature that follows a user story

##### Testing based on what is tested

* Model Test: checks for assignment of attributes, validations, relationships, and additional behavior
* Controller Test: checks for the proper redirection, variable assignment, the display of flash messages, and [template rendering](http://api.rubyonrails.org/classes/ActionController/TemplateAssertions.html)
* Feature Test: checks for correct functionality of user behavior; follow user stories closely

### Model Testing

* most important tests in your application
* test the business logic contained in the models

#### What should you test?

* is the data is being created?
* does the data have the right attributes?
* do the validations work?
* do the relationships work?
* do any additional methods work?

#### Examples

```ruby
require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def valid_attributes
    {
      title:        "I am Hungry",
      body:      		"I would really like to eat a vegetable sandwich right now."
    }
  end

  test "it creates an article" do
    article = Article.new(valid_attributes)

    assert article.valid?
    assert_equal "I am Hungry", article.title
    assert_equal "I would really like to eat a vegetable sandwich right now.", article.body
  end

  test "it cannot create an article without a title" do
    article = Article.new(body: "I would really like to eat a vegetable sandwich right now.")

    assert article.invalid?
  end
end
```

#### Model Test Practice

We'll be using the [Belibery app](https://github.com/turingschool-examples/belibery). You can thank Jorge. 

<u>Whole Group: </u>

* "it creates a fan"
* "it cannot create a fan without an name”
* "it cannot create a fan without an email”
* "it cannot create a fan with the same email”
* "it can beliebe”
* "it belongs to a location”

<u>In Pairs: </u>

* Create a Location model that has a city, state and country
* Build the tests for that model. They should cover the following behavior:
	* Don’t save the Location unless it has a city, 
	state and country
	* Don’t save the Location unless the city is unique
	* Cover a method `beliebe` that returns the name of the city plus ‘lieber’ (i.e. “Denverlieber)


#### Testing Relationships

* test the relationships between the different types of models
* check that these things are assigned properly

```ruby
class FanTest < ActiveSupport::TestCase
  test "it belongs to a location" do
    location = Location.create(
      city:    "Denver",
      state:   "Colorado",
      country: "United States"
      )

    result     = Fan.create({name: "Justina Bieber", email: "beliebe.me@example.com", location_id: location.id})

    assert_equal location, result.location
  end
end

class LocationTest < ActiveSupport::TestCase
  test "locations have many fans" do
    location = Location.create({
      city:    "Denver",
      state:   "Colorado",
      country: "United States"
    })
    fan      = Fan.create({name: "Justina Bieber", email: "beliebe.me@example.com"})
    location.fans << fan

    refute          location.fans.empty?
    assert_equal    1, location.fans.count
    assert_includes location.fans, fan
  end
end
```

### Controller Testing

* Many developers don’t like/use these. They like to use capybara tests instead to cover the functionality of the model.
* Some argue that controller tests are useful since it tests the controller functionality without the view.
* They are faster than feature tests since we are sending http requests instead of mimicking the behavior of the browser.

#### What should you test?

* are we receiving the correct response? (success, redirect, etc.)
* if there was a redirect, does it work?
* are the instance variables get assigned correctly? 
* is the flash message displayed correctly? 
* is the controller rendering the correct view template?

#### Examples

* `assert_response :success` checks that the status code was 200 (more about [assert_response](http://apidock.com/rails/Test/Unit/Assertions/assert_response))
* `assert_redirected_to  user_path(assigns(:user))` makes sure that the controller redirected to the show path
* `assert_template :new` checks that the new.html.erb template was rendered
* `assert_not_nil assigns(:article)` makes sure that a @article instance variable was set
* `assert_equal "Article successfully coreated", flash[:notice]` makes sure that the flash notice contains the correct message

```ruby 
require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
 test "it gets index" do
    get :index

    assert_response :success
    assert_not_nil  assigns(:articles)
  end

  test "it gets new" do
    get :new

    assert_response :success
    assert_not_nil  assigns(:article)
  end

  test "it posts to create" do
    post :create, article: { title: "Marshmallows", body: "Blah blah blah..." }

    assert_response       :redirect
    assert_redirected_to  article_path(assigns(:article))
    assert_equal          "You have created an article.", flash[:notice]
  end

  test "it gets show" do
    article = Article.create(title: "Marshmallows", body: "Blah blah blah...")

    get :show, { id: article.id }

    assert_response :success
    assert_not_nil  assigns(:article)
  end

  test "it renders new when post is unsuccessful" do
    post :create, article: { title: "I'm only a title!" }

    assert_response :success
    assert_template :new
    assert_equal    "The article was not created. Please try again.", flash[:alert]
  end

  test "it gets edit" do
    article = Article.create(title: "Marshmallows", body: "Blah blah blah...")
    get :edit, { id: article.id }

    assert_response :success
    assert_not_nil  assigns(:article)
  end

  test "it updates an article" do
    article = Article.create(title: "Marshmallows", body: "Blah blah blah...")
    patch :update, { id: article.id, article: { title: "Chocolate Chips", body: "Blah blah blah..." } }

    assert_response      :redirect
    assert_redirected_to article_path(assigns(:article))
    assert_equal         "You have updated an article.", flash[:notice]

    result = Article.find(article.id)
    assert_equal "Chocolate Chips", result.title
  end

  test "it deletes to destroy" do
    article = Article.create(title: "Marshmallows", body: "Blah blah blah...")

    assert_difference('Article.count', -1) do
      delete :destroy, id: article.id
    end

    assert_response      :redirect
    assert_redirected_to articles_path
    assert_equal         "The article was deleted.", flash[:notice]
  end
end
```

#### Controller Test Practice 

* Create a Fans controller
* Build the tests for that controller. They should cover the following actions:
	* index
	* show
	* new
	* create
	* delete
	(you can leave edit and update for later)

Remember that a good controller test checks for the type of response, the assignment of instance variable, the correct redirection and the display of flash messages if there are any.

### Recap

* Testing in Rails
* Types of Tests
* Testing Models
* Testing Relationships
* Testing Controllers

## Resources

* [Testing in Rails](http://guides.rubyonrails.org/testing.html)
