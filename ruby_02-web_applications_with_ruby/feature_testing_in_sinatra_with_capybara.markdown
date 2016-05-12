---
title: Feature Testing in Sinatra with Capybara
length: 120
tags: capybara, user stories, feature tests, testing
---

## Key Topics

During our session, we'll cover the following topics:

* Types of testing
* What are user stories? Why are they beneficial?
* Capybara

## Lecture

[Slides](https://www.dropbox.com/s/djzqkdyfyh6jdjz/Feature%20Testing%20with%20Capybara.key?dl=0)

## Important Setup Things

`Gemfile`

```ruby
gem 'capybara'
gem 'launchy'
```

`test_helper.rb`

```ruby
ENV['TASK_MANAGER_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'capybara'

module TestHelpers
  def teardown
   task_manager.delete_all
   super
  end
  
  def task_manager
   database = YAML::Store.new("db/task_manager_test")
   TaskManager.new(database)
  end
end

Capybara.app = TaskManagerApp

class FeatureTest < Minitest::Test
  include Capybara::DSL
end
```

`user_sees_all_tasks_test.rb`

```ruby
require_relative '../test_helper'

class UserSeesAllTasksTest < FeatureTest
  include TestHelpers
  def test_user_sees_index_of_tasks
    # your test code here
  end
end
```

## Resources

* [Capybara cheat sheet](https://gist.github.com/zhengjia/428105)
* [Simple Tricks for Capybara](http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests)
