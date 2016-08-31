---
title: Model Testing in Rails
length: 180
tags: rails, models, tdd, validations, scopes
---

## Learning Goals

* test model validations, including presence, uniqueness, format, length, and exclusion/inclusion
* create and test custom validators
* test associations using [shoulda-matchers](http://matchers.shoulda.io/docs/v2.8.0/)

## Warmup

Clone this app: `git clone -b model-testing-rspec https://github.com/turingschool-examples/belibery`. Let's walk through the schema to see what we already have. Then...

* Generate a migration and model for donations (only use the generator for migrations - not the model!). The migration needs to have an amount and a reference to the fans table. Migrate and look at the schema.
* Now, generate a migration that adds a `status` column (string) to the donations table. Migrate and look at the schema.
* Open your schema, and rollback. Now try to rollback two steps. What do you see?
* Migrate again to apply your migrations to the database.

## Getting Started with Model Testing (with RSpec)

From the RailsGuides: "In Rails, models tests are what you write to test your models."

If you use `rails g model Resource`, you'll have a model test file available to you within the `spec/models` folder. This application is already have these two test files. 

However, if you need to create a model test by hand: `$ touch spec/models/model-name_test.rb` and add this code inside of it:

```ruby
require 'rails_helper'

RSpec.describe ModelNameHere, type: :model do

end

```

## Testing Validations

You can find the Rails Guides validation documentation [here](http://edgeguides.rubyonrails.org/active_record_validations.html#validation-helpers). 

## Basic Validity

Let's write a test to check that a fan with all attributes is valid. Inside of `spec/models/fan_spec.rb`:

```ruby
require 'rails_helper'

RSpec.describe Fan, type: :model do

  it "creates a fan when passed valid attributes" do
    fan = Fan.new(name: "Jorge", email: "yosoybelieber@example.com")

    expect(fan).to be_valid
    expect(fan.name).to eq("Jorge")
    expect(fan.email).to eq("yosoybelieber@example.com")
  end

end

```

## Presence Validations

What happens if a name isn't entered? We shouldn't have a valid fan. Let's add a test. Inside of `spec/models/fan_spec.rb`:

```ruby
  it "cannot create a fan without a name" do
    fan = Fan.new(email: "yosoybelieber@example.com")
    expect(fan).to be_invalid
  end

```

This fails because we don't have any validations for presence of a name. Inside of `fan.rb`, let's add a validation:

```ruby
class Fan < ActiveRecord::Base
  validates :name, presence: true
end
```

## Uniqueness Validations

Let's assume that a fan logs into Belibery using their email address. Email addresses will need to be unique. Let's add a test for this:

```ruby
  it "cannot create a fan with the same email" do
    fan = Fan.create!(name: "Penelope", email: "yosoybelieber@example.com")
    fan_two = Fan.new(name: "Penelope", email: "yosoybelieber@example.com")
    expect(fan_two).to be_invalid
  end
```

It will fail because it's creating two fans and we're asserting that there should only be one. Inside of `fan.rb` we need to add a validation:

```ruby
  validates :email, presence: true, uniqueness: true
```

## Format Validations

Names should only contain capital and lower case letters. Let's write a test:

```ruby
  it "only accepts letters as a name" do
    fan = Fan.new(name: "Penelope12345", email: "penelope@pene-lope.com")
    expect(fan).to be_invalid
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
  it "only accepts an email between 5 and 50 characters" do
    fan = Fan.new(name: "Penelope", email: "pen")
    expect(fan).to be_invalid
  end
```

We'll use the length validation to make this test pass:

```ruby
  validates :email, presence:   true, 
                    uniqueness: true,
                    length:     { in: 5..50 }
```

## Custom Validations

What happens if we want to ban all users named Dao? We will need a custom validation method. First, let's write a test:

```ruby
  it "it cannot create a fan named Dao" do
    fan = Fan.new(name: "Dao", email: "mike-dao@gmail.com")
    expect(fan).to be_invalid
  end
```

We can validate `:no_daos` with a custom validation:

```ruby
class Fan < ActiveRecord::Base
  validate :no_daos

  def no_daos
    errors.add(:name, "cannot be Richard") if name == "Dao"
  end
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

## Testing Custom Methods

Every fan needs a belieber nickname. For example, Penelope's belieber nickname is "Penelopelieber". Let's write a test for the nickname functionality:

```ruby
  it "it has a beliber nickname" do
     fan = Fan.create!(name: "Penelope", email: "yosoybelieber@example.com")
     expect(fan.nickname).to eq("Penelopelieber")
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
  it "it belongs to a location" do
     fan = Fan.create!(name: "Penelope", email: "yosoybelieber@example.com")
     expect(fan).to respond_to(:location)
  end
```

However, this test will pass even if we just put `def location;end` in the model. 

We can use [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) to easily test out the association. 

**Take 5 minutes and see if you can use the `shoulda-matchers` gem to test this relationship.**

### Using Shoulda-Matchers

In the Gemfile:

```ruby
group :test do
  gem 'shoulda-matchers', '~> 3.1'
end
```

In your `rails_helper.rb`:

```ruby
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :rails
  end
end

```

In the model test:

```ruby
it { should belong_to(:location) }

```

Get this test to pass by adding the association in the model. 

## Check for Understanding

Using your `BookShelf` application, write model tests for the following:

* A `Book` should not be valid without a title
* A `Book`'s title is unique
* A `Book`'s price may not be more than $90005
* `Book.all` should return all book's ordered alphabetically by title


## Independent Practice

* [Model Testing in Rails Challenges](https://github.com/turingschool/challenges/blob/master/model_testing_rails.markdown)

