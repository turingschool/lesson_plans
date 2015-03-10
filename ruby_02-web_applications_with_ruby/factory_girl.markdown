---
title: Factory Girl in Rails
length: 90
tags: factories, factory_girl, rails, testing, tdd
---

## Goals

* use Factory Girl to create objects you can use in testing

## Lecture

A factory is an object whose job it is to create other objects. What's the purpose of Factory Girl? Check out [this StackOverflow answer](http://stackoverflow.com/questions/5183975/factory-girl-whats-the-purpose).

### Setup

In your Gemfile: 

```ruby
gem "factory_girl_rails"
```

#### Using RSpec

Create a file `spec/support/factory_girl.rb`. Inside of that file: 

```ruby
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
```

#### Using Test::Unit

Inside of `test/test_helper.rb`:

```ruby
class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end
```

Factories are automatically loaded if they are in following directories:

```
# RSpec
spec/factories.rb
spec/factories/*.rb

# Test::Unit
test/factories.rb
test/factories/*.rb
```

### Example of `test/factories/users.rb`:

```ruby
FactoryGirl.define do
  factory :user do
    first_name "Taylor"
    last_name  "Swift"
    username   "tswizzle"
    admin      false
  end

  # Want to call your factory "admin" but use the `User` class? Use an alias like this.
  factory :admin, class: User do  
    first_name "sally"
    last_name  "genericlastname"
    username   "sg"
    admin      true
  end
end
```

Having the above factory allows you to do this:

```ruby
# Unsaved user (Ruby land):
user = build(:user)

# Saved user (Ruby and database land):
user = create(:user)

# Admin user:
admin = create(:admin)

# Hash of attributes for a user:
attributes = attributes_for(:user)
```

* You can override attributes in factories with `create(:user, first_name: "Joe")`
* dynamic vs. static values: "2015-03-05 11:14:47 -0700", { Time.now } or lazy attributes with block:

```ruby
factory :user do
  # ...
  activation_code { User.generate_activation_code }
  date_of_birth   { 21.years.ago }
end
```

* dependent attributes:

```ruby
factory :user do
  first_name "Joe"
  last_name  "Blow"
  email { "#{first_name}.#{last_name}@example.com".downcase }
end

create(:user, last_name: "Doe").email
```

* shared traits:

```ruby
FactoryGirl.define do
  factory :post do
    title 'New post'
  end

  factory :page do
    title 'New page'
  end

  trait :published do
    published_at Date.new(2012, 12, 3)
  end

  trait :draft do
    published_at nil
  end
end

FactoryGirl.create(:post, :published)
FactoryGirl.create(:page, :draft)
```

* callbacks

```ruby
after(:build) # called after a factory is built (via FactoryGirl.build, FactoryGirl.create)
before(:create) # called before a factory is saved (via FactoryGirl.create)
after(:create) # called after a factory is saved (via FactoryGirl.create)
```

* transient attributes:

```ruby
trait :with_comments do
  transient do
    number_of_comments 3
  end
  
  after :create do |post, evaluator|
    FactoryGirl.create_list(:comment, evaluator.number_of_comments, :post => post)
  end
end
```

This allows:

```ruby
FactoryGirl.create(:post, :with_comments, :number_of_comments) #=> 4
```

* Building or Creating Multiple Records

```ruby
built_users   = build_list(:user, 25)
created_users = create_list(:user, 25)
```

* sequences for attributes that need to be unique:

```ruby
# Defines a new sequence
FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

generate :email
# => "person1@example.com"

generate :email
# => "person2@example.com"
```

* associations

```ruby
FactoryGirl.define do
  factory :user do
    username 'rwarbelow'
  end

  factory :post do
    user
  end
end
```

* create one factory for each class that provides simplest implementation (passing validations)
* can build on top of simple factories to customize

`test/factories/posts.rb`:

```ruby
FactoryGirl.define do
  # post factory (posts belong to users)
  factory :post do
    title "How to Use Factory Girl"
    user  # this will associate a user (created with the user factory) with this post
  end
end
```

`test/factories/users.rb`:

```ruby 
FactoryGirl.define do

  factory :user do
    name "John Doe"

    factory :user_with_posts do
      transient do
        posts_count 3
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end
end
```

This association will allow the following: 

```ruby
create(:user).posts.length # => 0
create(:user_with_posts).posts.length # => 3
create(:user_with_posts, posts_count: 10).posts.length # => 10
```

* associations after create with traits:

```ruby
FactoryGirl.define do
  factory :post do
    title 'New post'
  end

  trait :with_comments do
    after :create do |post|
      FactoryGirl.create_list :comment, 3, :post => post
    end
  end
end

FactoryGirl.create(:post, :with_comments)
```

### Tips

* don't use Faker for factories (Faker is better for seeds)
* test for explicit values -- avoid false positives


### Further Reading

* [Getting Started with Factory Girl](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md)
* [Use Factory Girl's Build Stubbed for a Faster Test](https://robots.thoughtbot.com/use-factory-girls-build-stubbed-for-a-faster-test)
