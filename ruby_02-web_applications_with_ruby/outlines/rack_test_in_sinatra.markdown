---
title: Rack::Test in Sinatra
length: 90
tags: testing, tdd, sinatra, http, rack
---

# Testing Sinatra Applications

## Learning Goals

* Test HTTP requests and responses using `Rack::Test`
* Use database_cleaner to support tests
* Use ActiveRecord validations

## Setup (before lesson)

* Clone the repo [here](https://github.com/s-espinosa/rack_test_in_sinatra)

## Review: Unit and Feature Tests (Slides - 5 mins)

* Unit tests - our specific function works the way we expect with given inputs
    * Action: method calls on an object
    * Result: return values/object state
    * Test: (on slide)

      ```ruby
      def test_assigns_attributes_correctly
        task = Task.new({"title"       => "a title",
                         "description" => "a description",
                         "id"          => 1})
        assert_equal "a title", task.title
        assert_equal "a description", task.description
        assert_equal 1, task.id
      end
      ```

* Feature tests with Capybara - user clicks a link, etc.
    * Action: User interaction with a webpage
    * Result: New web page with content (HTML)
    * Test: (on slide)

      ```ruby
      def test_task_creation_with_valid_attributes
        visit '/tasks/new'

        fill_in 'task[title]', with: 'Example Task'
        fill_in 'task[description]', with: 'Example Description'
        click_button 'Submit'

        assert_equal '/tasks', current_path

        within '.task' do
          assert page.has_content? 'Example Task'
        end
      end
      ```

* Rush hour
    * Not sending information in forms, not data that’s entered by a human on a web page
    * Modeling something closer to a machine to machine interaction
    * Still need to provide certain responses so that client machines know that they have successfully submitted a request even though we’re not rendering a view.
    * Need to test this functionality
        * Action: Submit curl request
        * Result: HTTP response/Updates to DB
        * Test: ?

## Lecture (Slides - 10 mins)

* How do we test this?
    * Rack::Test (via rack-test gem)
    * Gives us a way to test our controllers
    * Mimics a request/response cycle
    * Doesn’t require a view to be rendered for either submissions  or responses (no Capybara)
* What does rack-test give us?
    * HTML verbs in our tests (get, post, put, patch, delete)
    * Ability to pass params using a params hash as second argument (`post ‘/‘, {title: “My Idea”, description: “fake descriptions are difficult”`}
    * last_response.status: check status codes (200, 404, 302, 500, etc): Walk through some of the common ones. Point them to dog status codes as a resource.
        * 1xx - Informational
        * 2xx - Success (e.g. 200 - o.k., 201 - created, if you want an example: `curl notnerdyenough.io -v`)
        * 3xx - Redirection (e.g. 301 - moved permanently, for an example: `curl google.com -v`)
        * 4xx - Client Error (e.g. 404 - not found, for an example: `curl http://www.google.com/sal -v`)
        * 5xx - Server Error (e.g. 503 - Service unavailable)
    * last_response.body: check body content - look for relevant strings using string methods like `.include?`, etc.
    * Ability to follow a redirect with `follow_redirect!`
* How do we use?
    * Gemfile
        * `gem ‘rack-test'`
    * Test
        * `include Rack::Test::Methods`
        * app definition

          ```ruby
          def app
            AppName
          end
          ```

## Tutorial (30 - 45 mins)

In the links file in the repo you cloned there is a link to a tutorial for you to complete. The instructions are fairly detailed, but let us know if there is anything in that tutorial that gives you trouble. Once you've completed that, move on to the Independent Practice.

## Independent Practice (30 - 45 mins)

In the repo you cloned there's another folder for a to-do application. In that test/controllers file there are four groups of tests:

* **Detailed Pseudo Code - Existing Features:** detailed descriptions of tests for you to test existing features.
* **Test Names - Existing Features:** test names only (no other description) for tests for existing features.
* **Detailed Pseudo Code - New Features:** detailed descriptions of tests for you to test features that you will need to implement.
* **Test Names - New Features:** test names only (no other description) for tests for features you will need to implement.

Complete each section as described in that file.
