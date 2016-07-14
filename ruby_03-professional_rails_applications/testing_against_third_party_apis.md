---
title: Testing Against Third Party APIs
length: 90
tags: apis, testing, controller tests, rails, VCR
---

## Testing Against 3rd Party APIs

As we build more and more sophisticated web applications, we'll frequently want to make use of data we don't control. Generally this data is provided to us by a 3rd party company or organization via a public-facing API on the web.

While it's great to get access to all this data so easily, it can sometimes create headaches for our test suite.

### 3rd Party API Testing Problems

Let's consider a few difficulties when testing around a 3rd party
API:

* **Speed** -- even a "fast" API will still generally have latencies in the 10s of milliseconds, which can slow our tests down
* **Rate Limits** -- We may be using an API which limits the volume of our usage. We certainly don't want to waste these requests on repetitive test queries
* **Repeatibility** -- The data on many endpoints will change over time. This will cause problems if our tests are designed around 1 set of data but the API starts providing something different. We'd like it to be consistent and repeatable.
* **Network Tolerance** -- Our test suite should be isolated to our machine and shouldn't be affected by network outages. This won't be the case if we're utilizing a real API in the test suite.

### Solutions

There are a few common solutions we might take for these issues:

* **Stubbing** -- often we can use in-process stubbing libraries to replace our API queries with canned, static responses that will be fast and reliable
* **Network-level Mocking** -- sometimes we might want to capture the whole network response. Fortunately there are tools like VCR available for this.

If you're interested in reading about testing external APIs that don't use VCR check out these two articles as a starting point:

* [How to Stub External Services in Tests](https://robots.thoughtbot.com/how-to-stub-external-services-in-tests)
* [Have you ever... Faked It?](https://robots.thoughtbot.com/fake-it)

### Workshops

We are going to use the Sunlight API to retrieve all legislators and committees that match a criteria - and we are going to test it using VCR.

#### 0. Setup

First, let's create a new Rails project.

```sh
$ rails new testing_3rd_party_apis --skip-spring --skip-turbolinks
$ cd testing_3rd_party_apis
$ bundle
$ bundle exec rake db:create
```

We also need to add a few gems. We are going to add [Faraday](https://github.com/lostisland/faraday), [VCR](https://github.com/vcr/vcr), [webmock](https://github.com/bblimke/webmock) and [Figaro](https://github.com/laserlemon/figaro).

* Faraday is an HTTP client library that provides an easy-to-use interface to make requests
* VCR records your requests and allows you to reuse the responses whenever you are testing functionality dependent on the return value of those requests
* Webmock is a library for stubbing and setting expectations on HTTP requests in Ruby
* Figaro is simple, Heroku friendly and makes it easy to hide your secret configs in a Rails app

**Gemfile**
```
....

gem 'faraday'
gem 'figaro'

group :development, :test do
  gem 'vcr'
  gem 'webmock'
  gem 'pry-rails'
end
```

Bundle your gems to install the new dependencies. To configure Figaro, we run `bundle exec figaro install`. Now we can add our secrets to `config/application.yml` which is already added to the `.gitignore`.

```sh
$ bundle exec figaro install
      create  config/application.yml
      append  .gitignore
```

We also need to configure webmock and VCR in our `test/test_helper.rb`. At the top of the file, we require 'minitest/pride', 'webmock/test_unit' and 'vcr'. We also add a VCR configuration block to `ActiveSupport::TestCase` where we declare where it should look for cassettes (more on cassettes below).

**test/test_helper.rb**
```rb
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'webmock/test_unit'
require 'vcr'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  VCR.configure do |config|
    config.cassette_library_dir = "test/cassettes"
    config.hook_into :webmock
  end
end
```

#### 1. Preparing a service

We are going to create a Sunlight service in our application that can communicate with the Sunlight API. Let's create the services folder and a service file:

```sh
$ mkdir app/services
$ touch app/services/sunlight_service.rb
$ mkdir test/services
$ touch test/services/sunlight_service_test.rb
```

In `test/services/sunlight_service_test.rb`, add the following:

**test/services/sunlight_service_test.rb**
```rb
require './test/test_helper'

class SunlightServiceTest < ActiveSupport::TestCase
  attr_reader :service

  def setup
    @service = SunlightService.new
  end

end
```

At the top, we require the `test_helper`. We also add a setup method that will create a new instance of the SunlightService (yet to be built) and add an attr_reader so we can easily reference it throughout the program.

Let's add a first test; `#legislators`. The purpose of the `legislators` method is to return all legislators that match a certain criteria. In this case, we are querying for all the female legislators. In `services/sunlight_service.rb` we need to make a call to the Sunlight API and ask for all female legislators.

On the first line of the test we are declaring which VCR cassette we should use for this test. A **cassette** is a recorded response. All of our cassettes will be stored in `test/cassettes` (as declared in the VCR configs in the test_helper). If VCR cannot find a cassette named `sunlight_service#legislators` it will make the call and save the response. If the cassette already exists, it will read the existing cassette.

**test/services/sunlight_service_test.rb**
```rb
test '#legislators' do
  VCR.use_cassette('sunlight_service#legislators') do
    legislators = service.legislators(gender: 'F')
    legislator  = legislators.first

    assert_equal 20,      legislators.count
    assert_equal 'Joni',  legislator[:first_name]
    assert_equal 'Ernst', legislator[:last_name]
  end
end
```

If we run the tests, `rake test`, the errors asks us to create the SunglightService class.

**app/services/sunlight_service.rb**
```rb
class SunlightService
end
```

#### 2. Getting the API keys

The API call we need to make in order to make the test pass is the following:

```
http://congress.api.sunlightfoundation.com/legislators?gender=F&apikey=YOUR_API_KEY
```

You can run that URL in the browser, replacing the last bit with your own API key.

* `http://congress.api.sunlightfoundation.com/` is the base url
* `legislators` is the endpoint
* `?gender=F&apikey=YOUR_API_KEY` are the params we are sending

Before we continue, hop over to the [Sunlight Foundation website](https://sunlightfoundation.com/api/) and create your API keys. When you have your key (you need to verify your email to get it), we need to add it as an environment variable in our Rails application.

**config/application.yml**
```yml
development:
  SUNLIGHT_KEY: <YOUR API KEY>

test:
  SUNLIGHT_KEY: <YOUR API KEY>
```

We are not going to use this in production, so just adding keys for `development` and `test` is sufficient. If you go to the Rails console and enter `ENV["SUNLIGHT_KEY"]`, you should be able to access your keys. If not, double check the syntax in `config/application.yml`.

Great! We have a test and we have API keys. Now we can write the request to the Sunlight API.

#### 3. Fetching legislators

if we run our test, it tells us that we don't have the method `legislators`. Before we go any further, let's create a connection to the Sunlight API using Faraday. In the `initialize` method we are creating a new connection with the base url. We also set the our API key as a param. In the legislators method we are just putting a `pry` for now.

**app/services/sunlight_service.rb**
```rb
attr_reader :connection

def initialize
  @connection = Faraday.new('http://congress.api.sunlightfoundation.com')
  connection.params[:apikey] = ENV['SUNLIGHT_KEY']
end

def legislators(criteria)
  require 'pry'; binding.pry
end
```

If we run our tests and are caught by the pry, we can see what `connection` looks like. It's a Faraday instance and you should be able to find the params we just set. In the [Faraday docs](https://github.com/lostisland/faraday#usage) we see that it's pretty easy to make `get` requests.

```rb
# GET http://sushi.com/nigiri/sake.json
response = conn.get '/nigiri/sake.json'

# GET http://sushi.com/nigiri?name=Maguro
# and if we want to send additonal params
conn.get '/nigiri', { :name => 'Maguro' }
```

Now try to make a `get` request in the pry session.

```
[5] pry(#<SunlightService>)> connection.get('legislators', criteria)
```

In the body, we get a bunch of JSON back, and if you compare the values in the body with the JSON you get with the JSON you get from making the call in the browser you'll see it's the same.

```
http://congress.api.sunlightfoundation.com/legislators?gender=F&apikey=YOUR_API_KEY
```

Ok. We know how to make the API call. We get data (JSON) back. To make better sense of it, we need to parse it.

First, let's add a private method `parse` that can parse our responses.

**app/services/sunlight_service.rb**
```rb
private

def parse(response)
  JSON.parse(response.body, symbolize_names: true)
end
```

Then, let's build out the `legislators` method. Here, we are passing the response to our `parse` method, and from that return value we are accessing the values under the `results` key. I highly recommend putting a pry in this method and look at the response and see why we are accessing the `results` key.

**app/services/sunlight_service.rb**
```rb
def legislators(criteria)
  parse(connection.get('legislators', criteria))[:results]
end
```

Run your tests... and we should have one passing test.

Also take a look at the cassette that was created. There you can find information about the response. If your tests are failing because of VCR, make sure that the response is a `200`. If it is, delete all cassettes and rerun the tests.

#### 4. Fetching committees

The process of fetching committees is fairly similar to how we fetched legislators. Let's start with a test:

```rb
test '#committees' do
  VCR.use_cassette('sunlight_service#commitees') do
    committees = service.committees(chamber: 'senate')
    committee  = committees.first

    assert_equal 20, committees.count
    assert_equal 'Regulatory Affairs and Federal Management', committee[:name]
  end
end
```

Get the test passing by adding the `committees` method.

#### 5. Creating a Legislator model

We want to implement the following behavior:

```
$ Legislator.find_by({gender: 'F'}) #=> [<Legislator>, <Legislator>, <Legislator>, <Legislator>...]
```

Right now, we don't even have a Legislator model! Before we add the model, let's add a test file.

```sh
$ touch test/models/legislator_test.rb
```

Cool, now let's add the test. We are using VCR here as well, and instead of accessing the SunlightService directly, we want to call a method on the Legislator to get Legislator objects back instead of just an array of hashes.

**test/models/legislator_test.rb
```rb
require './test/test_helper'

class LegislatorTest < ActiveSupport::TestCase
  test '#find_by' do
    VCR.use_cassette('legislator#find_by') do
      legislators = Legislator.find_by(gender: 'F')
      legislator  = legislators.first

      assert_equal 20,         legislators.count
      assert_equal Legislator, legislator.class
      assert_equal 'Joni',     legislator.first_name
      assert_equal 'Ernst',    legislator.last_name
    end
  end
end
```

The test tells us to add the model.

```sh
$ touch app/models/legislator.rb
```

**app/models/legislator.rb**
```rb
class Legislator
end
```

And add the method...

**app/models/legislator.rb**
```rb
class Legislator

  def self.find_by(criteria)
  end

end
```

This is dynamic data we are getting from a 3rd party API and there's no need to store it in our database - we don't want to be in charge of data that we can easliy query for. But we still want to return Legislator objects from the `Legislator#find_by` method. To achieve this, we can use [OpenStruct](http://ruby-doc.org/stdlib-2.0.0/libdoc/ostruct/rdoc/OpenStruct.html).

OpenStruct is a data structure very similar to a hash but we can define methods on the instance. For example:

```sh
[1] pry(main)> require 'ostruct'
=> true
[2] pry(main)> person = OpenStruct.new
=> #<OpenStruct>
[3] pry(main)> person.name = "Lovisa"
=> "Lovisa"
[4] pry(main)> person.age = 24
=> 24
[5] pry(main)> person
=> #<OpenStruct name="Lovisa", age=24>
[6] pry(main)> person.class
=> OpenStruct
```

First, let's make the class inherit from OpenStruct. This enables us to call `Legislator.new({name: "Lovisa"})`, which will return a `Legislator` object with one property set; `name: "Lovisa"`.

Then, we need to create an instance of the SunlightService so we can trigger API requests from this model.

**app/models/legislator.rb**
```rb
class Legislator < OpenStruct
  attr_reader :service

  def self.service
    @service ||= SunlightService.new
  end

  def self.find_by(params)
  end
end
```

Great! If we run our tests, nothing has changed. Now we need to use `service` to fetch all the legislators matching the given criteria, then map over the array of hashes we get back and create a `Legislator` object for each hash.

**app/models/legislator.rb**
```rb
def self.find_by(params)
  service.legislators(params).map { |legislator| Legislator.new(legislator) }
end
```

Run the tests... and it should all be passing.

#### 6. Creating a Committee model

Similar to legislators, we want to be able to query for committees matching a given criteria and get `Committee` objects back.

```
$ Committee.find_by({chamber: 'senate'}) #=> [<Committee>, <Committee>, <Committee>, <Committee>...]
```

As you can see, the `committee_test.rb` is very similar to `legislator_test.rb`.

**test/models/committee_test.rb**
```rb
require './test/test_helper'

class CommiteeTest < ActiveSupport::TestCase
  test '#find_by' do
    VCR.use_cassette('commitee#find_by') do
      commitees = Commitee.find_by(chamber: 'senate')
      commitee  = commitees.first

      assert_equal 20,       commitees.count
      assert_equal Commitee, commitee.class
      assert_equal 'Regulatory Affairs and Federal Management', commitee.name
    end
  end
end
```

Make the test pass - if you get stuck, reference the `Legislator` model.

#### 7. Review of the Big Picture

Have students create a diagram of the moving pieces for the following scenarios:

1. A test that makes an API call without a VCR cassette
  * What role do the following pieces play?
    * Rails app
    * External API (github, twitter, etc)
    * Webmock
    * VCR
    * cassettes
    * The Internet
    * Faraday
    * Figaro
1. A test that makes an API call with VCR
  * What role do the following pieces play?
    * Rails app
    * External API (github, twitter, etc)
    * Webmock
    * VCR
    * cassettes
    * The Internet
    * Faraday
    * Figaro

### Materials

* [Alternative Lesson Plan](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/mocking_apis_v2.markdown)
* [Code-a-Long Notes](https://www.dropbox.com/s/3afogbj3qwuptj8/Turing%20-%20Testing%20an%20External%20API%20%28Notes%29.pages?dl=0)
* [Alternative Code-a-Long](https://www.dropbox.com/s/3x1vfhu9wdx2juj/Turing%20-%20Revisiting%20Testing%20an%20External%20API.pages?dl=0)
