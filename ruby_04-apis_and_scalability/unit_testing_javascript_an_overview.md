---
title: Unit Testing JavaScript: An Overview
length: 90
tags: javascript, testing, unit testing, tdd
status: Draft
---

# Unit Testing in JavaScript: An Overview

## Unit Testing vs Integration Testing

Integration tests are great, but they are just smoke tests. They test what you assume the page is doing, but not the assumptions you've made about your own logic.

Unit Tests test units of functionality (try saying that one three times in a row). Given a certain input, test that this block of code gives certain output.

If you want a good overview of unit testing in JavaScript, check out this conference talk [Writing Testable JavaScript](https://www.youtube.com/watch?v=OzjogCFO4Zo)

### General Overview of Testing Frameworks and Related Terms

There are a lot of names that float around when you're trying to get into JavaScript testing. While not all of the following terms relate directly to unit testing, it's helpful to at least know what all of these words are.

##### Unit Testing Frameworks
* [QUnit](http://qunitjs.com/) - QUnit is an early unit testing framework. It doesn't come with a lot of bells and whistles, or really, any bells and whistles.
* [Mocha](https://mochajs.org/) - Mocha describes itself as the 'simple, flexible, fun' testing framework. The reason for the flexibility is that things like spy frameworks and assertion libraries are not built in to Mocha - so if you want these things, you add them in piecemeal.
* [Jasmine](https://github.com/jasmine/jasmine) - Jasmine describes itself as a 'Dom-less simple JavaScript testing framework'. It has a built in mocking library (unlike Mocha) and is generally thought of as an 'all-one-package'.

There are (way) more JavaScript unit testing frameworks - but these are the major ones at the time of writing.

##### Nice Things to Add to Your Testing Framework
* [Chai](http://chaijs.com/) - Chai is an 'assertion library' which can be added to any testing framework to beef up the language and readable style of tests. If you think about the syntactic sugar of RSpec, Chai will give you familiar ways to chain assertions that make tests more readable. It is usually used with Mocha, as Mocha does not have a built in assertion library.
* [Sinon.JS](http://sinonjs.org) - A library  used to add test spies, mocks and stubs to your tests. Works with QUnit, Jasmine and Mocha.

##### Drivers and Browsers and DOM Manipulation, Oh My

JavaScript code that was written to require a DOM needs to be run somewhere - normally it is run in a browser. When you are writing integration tests, you'll use a driver to simulate the DOM.

* [selenium](http://www.seleniumhq.org/) - Selenium is a browser automation library, usually used for testing web-applications. Selenium can fire up a browser that it controls in order to run tests on it. [selenium-webdriver](http://www.seleniumhq.org/) comes with the ability to use major browsers or a headless browser, Phantom.js, which we'll cover below.
* [Phantom.js](http://phantomjs.org/) - A headless browser used for automating web page interaction.  PhantomJS doesn't draw out a screen (thus the term 'headless'). This makes PhantomJS much faster. PhantomJS is NOT a testing framework, it is built to work with one (like Mocha, Jasmine, etc).
* [Capybara](https://github.com/jnicklas/capybara) - Capybara is an acceptance test framework for web applications written in Ruby. It supports the use of different drivers. The default driver is rack_test, but can be switched to other drivers for the purposes of testing JavaScript interactions.
  * [selenium-webdriver](https://github.com/SeleniumHQ/selenium/tree/master/javascript/node/selenium-webdriver)
  * [Capybara-Webkit](https://github.com/thoughtbot/capybara-webkit) - A capybara driver which uses [WebKit](https://webkit.org/) directly
  * [poltergeist](https://github.com/teampoltergeist/poltergeist) - A capybara driver for PhantomJS (a headless browser built on [WebKit](https://webkit.org/))

Integration style testing will be covered more in the integration testing with JavaScript lesson.

##### Test and Task Runners
* [Grunt](http://gruntjs.com/) - A JavaScript based task runner. Task runners can be configured to perform repetitive tasks for you, including location and running all of your test files.
* [Gulp](http://gulpjs.com/) - Yet another JavaScript task runner.
* [Karma](http://karma-runner.github.io/0.13/index.html) - a JavaScript test runner that runs on Node.js
* [Teaspoon](https://github.com/modeset/teaspoon) - a JavaScript test runner built for use with rails.

## Basic Mocha syntax

We're going to try out some unit testing with Mocha. Before we dig into some exercises, let's look at some basic Mocha syntax

.
.
.
.

## Let's Try It Out

.
.
.
.

## A Note on Unit Testing in Rails
  Rails does not make it easy to unit test JavaScript. Many developers will test their JavaScript in a rails application only with integration tests for this reason. The [Testing JavaScript In Rails](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/testing_javascript_in_rails.markdown) lesson plan is an excellent resource for preparing your testing suite in rails to unit test your JavaScript.
