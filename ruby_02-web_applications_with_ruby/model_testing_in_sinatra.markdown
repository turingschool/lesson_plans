---
title: Model Testing in Sinatra

tags: testing, models, sinatra
---

This tutorial is based off of [TaskManager](https://github.com/JumpstartLab/curriculum/blob/a73c24c0f8ed3beec699590b9421e42d3dc648f7/source/projects/task_manager.markdown).

## Restructuring our Files

Make a `config/environment.rb` and add:

```ruby
require 'bundler'
Bundler.require

# get the path of the root of the app
APP_ROOT = File.expand_path("..", File.dirname(__FILE__))

# require the controller(s)
Dir.glob(File.join(APP_ROOT, 'app', 'controllers', '*.rb')).each { |file| require file }

# require the model(s)
Dir.glob(File.join(APP_ROOT, 'app', 'models', '*.rb')).each { |file| require file }

# configure TaskManagerApp settings
class TaskManagerApp < Sinatra::Base
  set :method_override, true
  set :root, APP_ROOT
  set :views, File.join(TaskManagerApp.root, "app", "views")
  set :public_folder, File.join(TaskManagerApp.root, "app", "public")
end
```

(Curious about [other things you can set](http://www.sinatrarb.com/intro.html#Available%20Settings) in Sinatra?)

In `config.ru`, we can now just require our environment:

```ruby
require File.expand_path('../config/environment',  __FILE__)

run TaskManagerApp
```

Remove any old configuration settings inside of your controller.

Remove any `require` or `require_relative` statements in your controller and/or models. Our `environment.rb` file now requires all of our controllers, models, and views for us. 

## Setting up Model Tests

Add `gem 'minitest'` to your Gemfile and then bundle.

### File structure

We'll create a test folder. Within that folder, we'll create another folder called models. This way we can separate our model tests from our integration tests (more on this later). 

```
$ mkdir test
$ touch test/test_helper.rb
$ mkdir test/models
$ touch test/models/task_test.rb
$ touch test/models/task_manager_test.rb
```

In `test/test_helper.rb`:

```ruby
ENV['TASK_MANAGER_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'

class Minitest::Test 
  def teardown
    TaskManager.delete_all
  end
end

```

Add a `delete_all` method in TaskManager:

```ruby
  def self.delete_all
    database.transaction do
      database['tasks'] = []
      database['total'] = 0
    end
  end
```

### Two different databases

In `app/models/task_manager.rb`:

```ruby
  def self.database
    if ENV["TASK_MANAGER_ENV"] == 'test'
      @database ||= YAML::Store.new("db/task_manager_test")
    else
      @database ||= YAML::Store.new("db/task_manager")
    end
  end
```

In `test/models/task_test.rb`:

```ruby
require_relative '../test_helper'

class TaskTest < Minitest::Test 
  def test_assigns_attributes_correctly
    task = Task.new({ "title"       => "a title", 
                      "description" => "a description",
                      "id"          => 1 })
    assert_equal "a title", task.title
    assert_equal "a description", task.description
    assert_equal 1, task.id
  end
end
```

Run the test: `$ ruby test/models/task_test.rb`.

In `test/models/task_manager_test.rb`:

```ruby
require_relative '../test_helper'

class TaskManagerTest < Minitest::Test 
  def test_it_creates_a_task
    TaskManager.create({ :title       => "a title", 
                         :description => "a description"})
    task = TaskManager.find(1)
    assert_equal "a title", task.title
    assert_equal "a description", task.description
    assert_equal 1, task.id
  end
end
```

Why symbols as the keys here as opposed to strings in the `task_test.rb`?

Run the test: `$ ruby test/models/task_test.rb`.

## Worktime

In pairs, add tests for `all`, `find`, `update`, and `destroy` in the TaskManager class. 
