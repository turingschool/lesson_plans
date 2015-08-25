---
title: Full Stack Integration Testing with Selenium
tags: testing, selenium
length: 90
---

For example Selenium 2.40.0 (released on Feb 19, 2014) supports Firefox 27, 26, 24, 17

__Discussion -- Integration Testing__

* `Rack::Test` -- advantages and disadvantages
* "Integration" testing -- what's the point?
* How are our existing integration tests not really...integrative?
* As our apps involve JS it would be good to be able to test that the JS
portions and the server portions work correctly together.
* Capybara Architecture: Modular with respect to drivers
* Alternate drivers: Selenium, Poltergiest, Webkit, etc. -- give us a real
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
gem 'selenium-webdriver'
```

### 2. Test Configuration


### 3. Using Selenium for a Test

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

__Discussion: Browser-based WebDrivers vs. Rack::Test Driver and DB threading__

To get around this, we need to fix a couple things. If we want an article to exist
in our DB for the test, we'll need to create it via the web UI (this also helps make
it a more robust/accurate "integration" test -- everything is interacting through
the application's real UI).

