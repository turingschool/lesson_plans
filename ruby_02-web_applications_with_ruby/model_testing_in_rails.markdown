---
title: Model Testing in Rails
length: 180
tags: rails, models, tdd, validations, scopes
---

## Key Topics

During our session, we'll learn how to test the following things:

* Model validations
* Instance methods that you define
* Relationships
* Scopes vs. class methods

## Warmup

Clone this app: `git clone -b model-testing git@github.com:turingschool-examples/belibery.git`.

* Generate a migration and model for donations (use `rails g model` to get the model and the migration). The migration needs to have an amount and a reference to the fans table. Migrate and look at the schema.
* Now, generate a migration that adds a string status column to the donations table. Migrate and look at the schema.
* Open your schema, and rollback. Now try to rollback two steps. What do you see?
* Migrate again to apply your migrations to the database.

## Getting Started with Model Testing

From the RailsGuides: "In Rails, models tests are what you write to test your models."

If you use `rails g model Thing`, you'll have a model test file available to you within the `test/models` folder. This is how the repo was initially set up for Fan and Location, so you already have these two test files. 

However, if you need to create a model test by hand: `$ touch test/models/thing_test.rb` and add this code inside of it:

```ruby
require 'test_helper'

class ThingTest < ActiveSupport::TestCase
end
```

Remember that your generated fixtures will be loaded when you run your tests unless you remove that line in your test_helper.rb.

## Testing Validations

You can find the Rails Guides validation documentation [here](http://edgeguides.rubyonrails.org/active_record_validations.html#validation-helpers). 

## Basic Validity

Let's write a test to check that a fan with all attributes is valid. Inside of `test/models/fan_test.rb`:

```ruby
require 'test_helper'

class FanTest < ActiveSupport::TestCase
  def valid_attributes
    {
      name:               "Jorge",
      email:              "yosoybelieber@example.com",
    }
  end

  test "it creates a fan" do
    result = Fan.new(valid_attributes)

    assert result.valid?
    assert_equal "Jorge", result.name
    assert_equal "yosoybelieber@example.com", result.email
  end
end
```

## `Presence of` Validations

What happens if a name isn't entered? We shouldn't have a valid fan. Let's add a test. Inside of `test/models/fan_test.rb`:

```ruby
  test "it cannot create a fan without an name" do
    result = Fan.new(email: "yosoybelieber@example.com")

    assert result.invalid?
  end
```

This fails because we don't have any validations for presence of a name. Inside of `fan.rb`, add:

```ruby
  validates :name, presence: true
```

**Your Turn**: Add a test to validate the presence of the email and make it pass. 


## Uniqueness Validations

Let's assume that a fan logs into Belibery using their email address. Email addresses will need to be unique. Let's add a test:

```ruby
  test "it cannot create a fan with the same email" do
    2.times { Fan.create(valid_attributes) }

    result = Fan.where(email: "yosoybelieber@example.com")
    assert_equal 1, result.count
  end
```

It will fail because it's creating two fans and we're asserting that there should only be one. Inside of `fan.rb` we need to add a validation:

```ruby
  validates :email, presence: true, uniqueness: true
```

## Your Turn

Write tests and implement the code for these features:

* A location is valid with a city, state, and country.
* Locations are invalid if they are missing a city, state, or country.
* A city must be unique within the scope of a state. For example, we can have Bloomington, IL, and Bloomington, IN, but we can't have two of Bloomington, IN. 

## Format Validations

Names should only contain capital and lower case letters. Let's write a test:

```ruby
  test "it only accepts letters as a name" do
    fan = Fan.create(
      name:   "Jorge1",
      email:  "yosoybelieber@example.com"
      )

    refute fan.valid?
  end
```

We can use regex and a format validator to make this test pass:

```ruby
  validates :name,  presence:   true, 
                    format:     { with: /\A[a-zA-Z]+\z/, message: "only allows uppercase and lowercase letters"}
```

## Length Validations

Let's limit our fans' email addresses to between 5 and 50 characters. Our test:

```ruby
  test "it only accepts an email between 5 to 50 characters" do
    fan = Fan.create(
      name:               "Jorge",
      email:              "Jorj"
      )

    assert fan.invalid?
  end
```

We'll use the length validation to make this test pass:

```ruby
  validates :email, presence:   true, 
                    uniqueness: true,
                    length:     { in: 5..50 }
```

## Your Turn

Write tests and implement the code for these features:

* A state must be exactly two characters. Take a look at the documentation to figure out how to do exact length validations.
* Cities and countries may only contain uppercase letters, lowercase letters, and spaces.
* Extension: What is a confirmation validation? Can you create one for email? (Warning: this will probably break some tests you've already written. Just go back and update those failing tests.)

## Custom Validations

What happens if we want to ban all users named Richard? We will need a custom validation method. First, let's write a test:

```ruby
  test "it cannot create a fan named Richard" do
    fan = Fan.create(
      name:               "Richard",
      email:              "richard@example.com"
      )

    refute fan.valid?
    assert_includes fan.errors.messages[:base],
                    "Richards are not allowed to beliebe."

  end
```

You can also use [ActiveModel::Validator](http://guides.rubyonrails.org/active_record_validations.html#custom-validators) for custom validations. 

## Inclusion and Exclusion Validations

Examples from RailsGuides:

```ruby
class Coffee < ActiveRecord::Base
  validates :size, inclusion: { in: %w(small medium large),
                                message:   "%{value} is not a valid size" }
end

class Account < ActiveRecord::Base
  validates :subdomain, exclusion: { in: %w(www us ca jp),
                                     message: "%{value} is reserved." }
end
```

## Your Turn

Write model tests and implement the following functionality for donations:

* Donation amounts can only be numbers. Use either regex or take a look at the documentation for a built-in way to write this. 
* Donations can only be created if they are associated with a user.
* Donation statuses can be "processed", "pending", or "cancelled". No other values should be allowed.

## Testing Custom Methods

Every fan needs a belieber nickname. For example, Jorge's belieber nickname is "Jorgelieber". Let's write a test for the nickname functionality:

```ruby
  test "it has a beliber nickname" do
    fan = Fan.create(valid_attributes)

    assert_equal "Jorgelieber", fan.nickname
  end
```

We'll make this pass by creating a `nickname` method in `fan.rb`:

```ruby
  def nickname
    "#{name}lieber"
  end
```

## Testing Relationships

Relationships can be tested in the model, but the functionality is probably better tested in a feature test. The only thing we'll test at the model level is that an object can respond to an association method.

```ruby
  test "it belongs to a location" do
    fan = Fan.create(valid_attributes)

    assert fan.respond_to?(:location)
  end
```

## Testing Scopes and Class Methods

You've probably seen things like this:

```ruby
class Post < ActiveRecord::Base
  def self.published
    where(published: true)
  end
end
```

We can accomplish the same thing with a scope:

```ruby
class Post < ActiveRecord::Base
  scope :published, 
        -> { where(published: true) }
end
```

Scopes are custom-made queries that are called on a model class or on an association object. You can use where, joins, and includes in scopes. Because they return a ActiveRecord::Relation, you can chain scopes together. They are "lazily loaded", which means that the query won’t get executed until they are all invoked.

Scopes are defined by the word “scope”, then the name of the scope as a symbol and a lambda that specifies the query.
You can call scopes in the class or in the association:

````ruby
Post.published #=> returns ActiveRecord association of the published posts
category = Category.first
category.posts.published #=> returns ActiveRecord association of the published posts for that specific category
```

Scopes can accept arguments:

```ruby
class Post < ActiveRecord::Base
  scope :created_before, 
        ->(time) { where("created_at < ?", time) }
end
```

## Default Scope

You can also modify the default scope. By default, Rails give you the records based by their created date; however, you can override this by using default_scope.

```ruby
class Post < ActiveRecord::Base
  default_scope { where(active: true) }
end
```

## Your Turn

Write model tests and implement the following functionality for custom methods, relationships, and scopes:

* When calling `full_name` on a location, it should return a string of the city, state, and country. (Example: `location.full_name` returns "Denver, CO, USA")
* A donation should belong to a fan. 
* `Fan.locals` should return all fans that are from Denver, CO
* `Fan.all` should return all fans ordered alphabetically by last name. 
* Extension: Can you create a scope that accepts an argument of a date and returns all the fans that have joined since that date?

#### Other Things

Interested in seeing how these model tests are implemented in RSpec? Take a look at [this branch](https://github.com/turingschool-examples/belibery/tree/controller_test/spec/models) of the Belibery app. 
