---
title: Model Testing in Sinatra
tags: testing, models, sinatra
---
### Goals

By the end of this lesson, you will know/be able to:

* configure Sinatra using the `set` method
* explain the purpose of a model test
* test model functionality in a Sinatra app
* explain the differences between a development environment and test environment

## Structure

* Code-along

### Video

None yet.

### Repository

* [TaskManager: model-testing-lesson branch](https://github.com/turingschool-examples/task-manager/tree/model-testing-lesson): this branch is the result of completing the [TaskManager tutorial](https://github.com/JumpstartLab/curriculum/blob/master/source/projects/task_manager.markdown) and the [CRUD lesson](https://github.com/turingschool/lesson_plans/blob/master/ruby_02-web_applications_with_ruby/crud_sinatra.markdown). At this point, following the sequence of lesson plans, students should have their own copy of TaskManager and should not have to clone this down. 

## Code-Along

### Restructuring our Files

We're going to restructure our files in order to require all of the necessary pieces in one place -- a environment file. It is not necessary to memorize any of this section, but it's important to know what it's doing. 

Make a `config/environment.rb` and add the following code:

```ruby
require 'bundler'
Bundler.require

# get the path of the root of the app
APP_ROOT = File.expand_path("..", __dir__)

# require the controller(s)
Dir.glob(File.join(APP_ROOT, 'app', 'controllers', '*.rb')).each { |file| require file }

# require the model(s)
Dir.glob(File.join(APP_ROOT, 'app', 'models', '*.rb')).each { |file| require file }

# configure TaskManagerApp settings
class TaskManagerApp < Sinatra::Base
  set :method_override, true
  set :root, APP_ROOT
  set :views, File.join(APP_ROOT, "app", "views")
  set :public_folder, File.join(APP_ROOT, "app", "public")
end
```

(Curious about [other things you can set](http://www.sinatrarb.com/intro.html#Available%20Settings) in Sinatra?)

In `config.ru`, we can now just require our environment:

```ruby
require File.expand_path('../config/environment',  __FILE__)

run TaskManagerApp
```

Remove any old configuration settings inside of your controller.

Remove any `require` or `require_relative` statements in your controller and/or models except for `require 'yaml/store'` in TaskManager. Our `environment.rb` file now requires all of our controllers, models, and views for us. 

### Setting up Model Tests

Add `gem 'minitest'` to your Gemfile and then bundle.

### File structure

We'll create a test folder. Within that folder, we'll create another folder called models. This way we can separate our model tests from our integration tests (more on this later). 

```
$ mkdir test
$ touch test/test_helper.rb
$ mkdir test/models
$ touch test/models/task_test.rb
```

In `test/test_helper.rb`:

```ruby
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
```

Let's write our first model test. In `test/models/task_test.rb`:

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

### Testing the TaskManager

```
$ touch test/models/task_manager_test.rb
```

TaskManager is the object that interacts with our "database". Every time we run our tests, we want to start with a fresh slate with no existing tasks in our YAML file. Because of this, we need to have two different databases: one for testing purposes and one for development purposes. __This way, we will still have access to all of our existing tasks when we run `shotgun` and look at our app in the browser, but we won't have to worry about those tasks interfering with our tests because they'll be in a separate database.__

How will our app know which environment -- test or dev -- we want to use at any moment? By default (like when we start the server with `shotgun`), we will be in development. If we want to run something in the test environment, we need an indicator. We'll use an environment variable: `ENV['RACK_ENV']`. So, in `test/test_helper.rb`:

```ruby
ENV['RACK_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'tilt/erb'

module TestHelpers
  def teardown
    task_manager.delete_all
    super
  end

  def task_manager
    database = YAML::Store.new('db/task_manager_test')
    @task_manager ||= TaskManager.new(database)
  end
end
```

Add a `delete_all` method in TaskManager:

```ruby
  def delete_all
    database.transaction do
      database['tasks'] = []
      database['total'] = 0
    end
  end
```

Run the test: `$ ruby test/models/task_test.rb`.

In `test/models/task_manager_test.rb`:

```ruby
require_relative '../test_helper'

class TaskManagerTest < Minitest::Test 
  def test_it_creates_a_task
    task_manager.create({ 
      :title       => "a title", 
      :description => "a description"
    })
    
    task = task_manager.find(1)
    assert_equal "a title", task.title
    assert_equal "a description", task.description
    assert_equal 1, task.id
  end
end
```

Run the test: `$ ruby test/models/task_manager_test.rb`. You should be passing!

### Worktime

* In pairs, add tests for `all`, `find`, `update`, and `destroy` in the TaskManager class. 
* Add model tests for RobotWorld or Skill Inventory (this is homework)

### Extensions

* None yet.

### Other Resources:

* [Minitest Docs](http://docs.seattlerb.org/minitest/)
