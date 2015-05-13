---
title: Feature Testing in Sinatra with Capybara
length: 120
tags: capybara, user stories, feature tests, testing
---

## Key Topics

During our session, we'll cover the following topics:

What are [status codes](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)?

What is Rack::Test? What is Nokogiri? How can they work together? 

How can we use Capybara to avoid the clunkiness of Rack::Test + Nokogiri?

1. What is a feature test
2. How to setup Capybara with Sinatra
3. How to template a feature test
4. The essential Capybara searching features
5. The essential Capybara interaction features
6. How to debug a feature test

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

class ModelTest < Minitest::Test 
  def teardown
    TaskManager.delete_all
  end
end

Capybara.app = TaskManagerApp

class FeatureTest < Minitest::Test
  include Capybara::DSL

  def teardown
    TaskManager.delete_all
  end
end
```

`front_page_test.rb`

```ruby
require_relative '../test_helper'

class FrontPageTest < FeatureTest
  def test_user_sees_index_and_new_links
    # your test code here
  end
end
```

## Resources

* [Capybara cheat sheet](https://gist.github.com/zhengjia/428105)
* [Simple Tricks for Capybara](http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests)
