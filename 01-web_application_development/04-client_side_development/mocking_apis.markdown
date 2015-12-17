---
title: Mocking Apis
length: 90
tags: apis, json, clients, mocking, testing
status: draft
---

## Learning Goals

* Structure code so it is easy to inject dependencies, so mocks can be easily provided.
* Initialize client dependency based on environment.
* Create your own mock
* Create service to mock the third party.

## Context

You have a client that talks to a service, how do you test this?

## Key Points

* Inject the client so you can wire it up appropriately for the given context
* You can then inject a mock version of the gem
* Or mock it out with webmock
* Or create a fake service that you direct the client to instead of the real one.

## When Client Includes a Mock

Clients that include mocks are great! Nice to know they give a shit about testing.
Initialize your client with appropriate values for the given environment,
and then inject the initialized client into your code.

We'll use [eval_in](http://rubygems.org/gems/eval_in),
which provides a mock that you can use for non-prod objects.

### Code Examples / Code-along

#### Create the app
Create a new Rails app

```
$ rails new mocking_apis
$ cd mocking_apis
$ echo 'gem "eval_in"' >> Gemfile
$ bundle
$ bundle exec rake db:migrate
```

#### What is injection?

Injecting something means that the caller provides the object
to use, rather than the code knowing all the details about it.
When code knows this information, we would say the client is a
hard dependency. It's hard, because those decisions are embedded
into the code and difficult to change.

When you inject it, you make it a soft dependency.
We will use Rails' configuration object to perform our injection,
Now, we can either change that config object, or use stubs
in our tests to swap out what object it receives.

#### Do the injection

We'll inject it in an initializer.

`config/initializers/eval_in.rb`

```ruby
require 'eval_in'

if Rails.env.production?
  Rails.application.config.eval_in = EvalIn

elsif Rails.env.development?
  require 'eval_in/mock'
  languages = { 'ruby/mri-2.1' => {program: RbConfig.ruby, args: []} }
  mock      = EvalIn::Mock.new(languages: languages)
  Rails.application.config.eval_in = mock

elsif Rails.env.test?
  require 'eval_in/mock'
  Rails.application.config.eval_in = EvalIn::Mock.new(
    result: EvalIn::Result.new(
      code:               'Test code',
      exitstatus:         0,
      language:           'The language',
      language_friendly:  'The language friendly',
      output:             'The output',
      status:             'The status',
      url:                'The url'
    )
  )
else
  raise "Wat kind of environment is this?"
end
```

Now show that we can get the different objects depending on our environment:

**test**

```
$ env RAILS_ENV=development rails runner 'require "pp"; pp Rails.application.config.eval_in.call("puts %(hello, world)", language: "ruby/mri-2.1")'
#<EvalIn::Result:0x007fa48eb386b8
 @code="puts %(hello, world)",
 @exitstatus=0,
 @language="ruby/mri-2.1",
 @language_friendly="ruby/mri-2.1",
 @output="hello, world\n",
 @status="OK (0.072 sec real, 0.085 sec wall, 8 MB, 19 syscalls)",
 @url="https://eval.in/207744.json">
```

**development**
```
env RAILS_ENV=development rails runner 'require "pp"; pp Rails.application.config.eval_in.call("puts %(hello, world)", language: "ruby/mri-2.1")'
#<EvalIn::Result:0x007fa48eb386b8
 @code="puts %(hello, world)",
 @exitstatus=0,
 @language="ruby/mri-2.1",
 @language_friendly="ruby/mri-2.1",
 @output="hello, world\n",
 @status="OK (0.072 sec real, 0.085 sec wall, 8 MB, 19 syscalls)",
 @url="https://eval.in/207744.json">
```

**production**

```
env RAILS_ENV=production rails runner 'require "pp"; pp Rails.application.config.eval_in.call("puts %(hello, world)", language: "ruby/mri-2.1")'
#<EvalIn::Result:0x007fa752ff15f8
 @code="puts %(hello, world)",
 @exitstatus=0,
 @language="ruby/mri-2.1",
 @language_friendly="Ruby — MRI 2.1",
 @output="hello, world\n",
 @status="OK (0.056 sec real, 0.061 sec wall, 8 MB, 19 syscalls)",
 @url="https://eval.in/210546.json">
```

Now lets allow users of our app to submit code, which is saved as a "snippet",
a link to the code on `EvalIn`

Create scaffolds:

```
$ rails g scaffold user name:string
$ rails g scaffold snippet url:string user_id:integer
```

Update models:
```
class User < ActiveRecord::Base
  has_many :snippets
end

class Snippet < ActiveRecord::Base
  belongs_to :user
end
```

Add routes:

```ruby
get  '/users/:user_id/code' => 'user_code#new',   as: :user_code_url
post '/users/:user_id/code' => 'user_code#create'
```

Add a views `app/views/user_code/new.html.erb`

```html
<h1>
  Submit Ruby code for <%= @user.name %>
</h1>

<%= form_tag "/users/#{@user.id}/code" do %>
  <div class="field">
    <%= label_tag :code %><br>
    <%= text_area_tag :code, @code %>
  </div>
  <div class="actions">
    <%= submit_tag 'Submit' %>
  </div>
<% end %>
```

And controller `app/controllers/user_code_controller.rb`
```html
class UserCodeController < ApplicationController
  def new
    @user = User.find params[:user_id]
    @code = ""
  end

  def create
    user    = User.find params[:user_id]
    code    = params[:code]
    result  = Rails.application.config.eval_in.call(code, language: 'ruby/mri-2.1')
    snippet = Snippet.create! user: user, url: result.url
    redirect_to snippet
  end
end
```


## Client Does Not Include a Mock
Lets add a test, and assume that the client doesn't include a mock:

### Code Examples / Code-along

Change the initializer:

```ruby
elsif Rails.env.test?
  Rails.application.config.eval_in = EvalIn
```

Now, write a test

```ruby
ruby -I test test/controllers/user_code_controller_test.rb
Run options: --seed 61862

# Running:
#<Snippet id: 980190963, url: "https://eval.in/210562.json", user_id: 980190962, created_at: "2014-10-27 16:20:48", updated_at: "2014-10-27 16:20:48">
.

Finished in 1.713045s, 0.5838 runs/s, 0.0000 assertions/s.

1 runs, 0 assertions, 0 failures, 0 errors, 0 skips
```

We can see that our current environment is working, but we're hitting the real URL.
Lets inject a mock:

```ruby
require 'test_helper'

class UserCodeControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "it calls EvalIn with the provided code, saving it in a snippet" do
    require 'eval_in/mock'
    Rails.application.config.eval_in = EvalIn::Mock.new(
      on_call: lambda { |code, options|
        assert_equal code, 'The code'
        EvalIn::Result.new(url: 'The url')
      }
    )

    post :create, user_id: @user.id, code: 'The code'
    assert_equal 'The url', Snippet.last.url
  end
end
```

But, of course, we're assuming the client doesn't provide a mock:

```ruby
require 'test_helper'

class UserCodeControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  class MockEvalIn
    Result = Struct.new :url
    attr_reader :code, :language
    def initialize(url)
      @url = url
    end

    def call(code, language: language)
      @code = code
      @language = language
      Result.new @url
    end
  end

  test "it calls EvalIn with the provided code, saving it in a snippet" do
    mock = MockEvalIn.new('The url')
    Rails.application.config.eval_in = mock
    post :create, user_id: @user.id, code: 'The code'
    assert_equal 'The url', Snippet.last.url
    assert_equal 'The code', mock.code
    assert_equal 'ruby/mri-2.1', mock.language
  end
end
```


## Integration
### Code Examples / Code-along
