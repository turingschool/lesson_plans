---
title: Writing a Wrapper Gem
length: 90
tags: ruby, api, gem, testing
---

## Learning Goals

* Practice wrapping HTTP API calls in a Ruby class
* Understand how Faraday is used to make web requests
* Understand how VCR/mocks are used for testing

## Structure

* 25 - Independent Work
* Break
* 25 - Lecture/Demo
* Break
* 25 - Paired Work

## Independent Work

Work for the first 15 minutes on your own to:

* Clone the [Tweeter project](https://github.com/turingschool-examples/tweeter)
* Bundle, migrate, and run `rake db:data:load`
* Get the server running locally on port 3000
* Visit the "endpoints" to display an individual tweet and an individual poster in your broswer
* Install and read the Readme for the Faraday gem
* Load Pry, require Faraday, and use it to make the same two requests to your local server

If you complete those tasks:

* Can you use Faraday to create a Poster? Create a tweet?
* Can you use the PATCH verb to modify an existing tweet?
* Think about / experiment with: how could you create a per-user token that acted like their password to "sign" API requests?

## Lecture

Let's come back together to discuss the theory and practice of wrapper gems.

* Why create a wrapper gem?
* What does the wrapper essentially do?
* Making requests with HTTParty or Faraday
* Challenges of external dependencies
  * What if the API changes?
  * Gem to match different versions of the API
* The testing story
  * Avoiding HTTP requests to prevent slow/failing tests

## Paired Work

Now get together with your pair and:

* Clone the [Tweeter-Client project](https://github.com/turingschool-examples/tweeter-client)
* Spend about three minutes exploring the code and tests that are already there
* Write tests for the same methods you worked with in the independent work
* Write an implementation to pass the tests

With those basics in place:

* Add VCR to the project
* Use VCR to record a successful test run
* Make your test suite pass *without* the API app running
