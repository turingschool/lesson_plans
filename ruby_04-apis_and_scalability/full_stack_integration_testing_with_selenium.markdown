---
title: Full Stack Integration Testing with Selenium
tags: testing, selenium
length: 90
---

__Discussion -- Integration Testing__

* `Rack::Test` -- advantages and disadvantages
* "Integration" testing -- what's the point?
* How are our existing integration tests not really...integrative?
* As our apps involve JS it would be good to be able to test that the JS
portions and the server portions work correctly together.
* Capybara Architecture: Modular with respect to drivers
* Alternate drivers: Seleniuis reduxm, Poltergiest, Webkit, etc. -- give us a real
web browser in our tests. We can actually run JS!

## Using Selenium

The most popular driver is Selenium. It uses an actual browser window and you can
watch the test happen. It uses the browser's actual JavaScript engine, so it's
identical to having a human Q/A department interacting with your application.

__Setup__

The only machine dependency for using Selenium is to have Firefox installed.
If you don't have this, then go download it. If you do have it, make sure it is
up to date.

## App Setup

For this section, we'll work through a brief demo using the Blogger example
project. In this tutorial, we'll aim to:

* Get selenium set up with our app
* Write integration tests for a new feature using AJAX
* Implement the feature and verify the functionality using Selenium

### 1. Clone / Setup

Get started by cloning and setting up the blogger application:

```
git clone https://github.com/JumpstartLab/blogger_advanced.git selenium-workshop
cd selenium-workshop
bundle
rake db:setup
```

Additionally, go ahead and add the Selenium gem to your Gemfile:

```
gem 'selenium-webdriver', '~> 2.53.4'
```

__Discussion: Browser-based WebDrivers vs. Rack::Test Driver and DB Test Transactions__

Finally, we need to tweak one thing in our `spec_helper.rb` configuration. Open this file
and change the `DatabaseCleaner.strategy` from `:transaction` to `:truncation`:

```ruby
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.raise_errors_for_deprecations!
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.before(:suite) do
    # Changed this line from :transaction to :truncation
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
ec/spec_helper.rb
```

### 2. Using Selenium for a Test

The feature we'd like to add is an AJAX-based comment submission. Currently users
can submit comments by submitting the form from an Article page, but let's see if
we can make this work without a full page reload.

Fortunately, there is already a test written for the content we need -- it's in
`spec/features/article_comments_spec.rb`. However so far this is just using the default
(`Rack::Test`) capybara driver. Let's start by swapping it to use Selenium, by
setting the `js` flag on the test itself:

```ruby
# in spec/features/article_comments_spec.rb
require 'spec_helper'

## Add the :js => true option to the test group:
describe "Article Comments", :type => :feature, :js => true do
  let(:article){ Fabricate(:article) }

  it "posts a comment" do
    visit article_path(article)
    fill_in "comment_author_name", :with => "Cowboy"
    fill_in "comment_body", :with => "Testing is too hard."
    click_link_or_button "post_comment"
    within('#comments') do
      expect(page).to have_content("Cowboy said")
      expect(page).to have_content("Testing is too hard.")
    end
  end
end
```

Once this is in place, run your tests. A couple things should happen:

* A new firefox browser window will open automatically and execute your test.
* The test will fail -- perhaps surprisingly, it can't find the Article we created
in our test with Fabricator

__Reiterate/Discuss: Browser-based WebDrivers vs. Rack::Test Driver and DB threading__

To get around this, we need to fix a couple things. If we want an article to exist
in our DB for the test, we'll need to create it via the web UI (this also helps make
it a more robust/accurate "integration" test -- everything is interacting through
the application's real UI).

### 3. Creating Articles in the Test

1. Remove the `fabricate(:article)` line from our test. We won't be relying on it now.
2. Remove the `visit article_path(article)` line from the test as well.
3. Add the steps (for now we can put them in a `before(:each)` block) to create a new
Article programmatically via the UI:

```
  before(:each) do
    visit new_article_path
    fill_in "article_title", with: "My Article"
    fill_in "article_body", with: "My Article Body"
    click_link_or_button "Save"
    click_link_or_button "My Article"
  end
```

Run your tests again. With any luck they should be passing, and you'll still see the firefox
activate as the suite hits your selenium tests.

Note that we often use selenium to test JS features, but as we can see here it word
just fine with standard web interactions as well.

### 4. Creating Comments using AJAX

Now that we have our test running with Selenium, we have a reasonable foundation
to add in our AJAX feature and remain confident that it will still be testing.

For starters, let's replace our existing `articles.js.coffee` file with a normal JS file.
Probably the easiest way to do this is to just remove one and create the other:

```
rm app/assets/javascripts/articles.js.coffee
touch app/assets/javascripts/articles.js
```

(don't skip this step, or the empty coffeescript file will overwrite your work in
the new JS file)

__Workshop: Converting article comments form to AJAX__

Follow along with your instructor to modify this form to submit its data via AJAX requests.
A few topics to cover include:

* Binding to form submission event using JQuery
* Pulling data from form fields
* Preventing default submit event handling
* Submitting form data using `$.post`
* Rendering a comment partial without layout from the server so
we can easily drop the markup into the dom
* Clearing form fields after submission so a new comment can be created

Here's a sample of what it will look like when we're done: [finished commit](https://github.com/JumpstartLab/blogger_advanced/commit/be8b022e54d9859ebebc5944d1ce3075639c109a).

### 5. Your Turn

Get with a pair and practice using TDD to drive another AJAX feature.

For this feature, add some client-side filtering on the Articles#index
page. The experince we'd like to achieve is:

* When I click a tag name in the sidebar, the articles should be filtered on the client
so that only the articles including the tag I selected are shown
* When I click "all", all articles should be shown
