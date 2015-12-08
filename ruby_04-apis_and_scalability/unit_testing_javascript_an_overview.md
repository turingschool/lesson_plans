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

Unit Testing can be difficult in JavaScript for many reasons - so this lesson aims to give you context and arm you with examples to start feeling more comfortable with it.

##### We Will Cover
* An Overview of Testing Frameworks and Related Terms
* Basic Mocha Syntax
* Assertions and Chai
* Trying Things Out
* A Note on Unit Testing in Rails
* The Connection to Game Time

## General Overview of Testing Frameworks and Related Terms

There are a lot of names that float around when you're trying to get into JavaScript testing. While not all of the following terms relate directly to unit testing, it's helpful to at least know what all of these words are.

#### Unit Testing Frameworks
* [QUnit](http://qunitjs.com/) - QUnit is an early unit testing framework. It doesn't come with a lot of bells and whistles, or really, any bells and whistles.
* [Mocha](https://mochajs.org/) - Mocha describes itself as the 'simple, flexible, fun' testing framework. The reason for the flexibility is that things like spy frameworks and assertion libraries are not built in to Mocha - so if you want these things, you add them in piecemeal.
* [Jasmine](https://github.com/jasmine/jasmine) - Jasmine describes itself as a 'Dom-less simple JavaScript testing framework'. It has a built in mocking library (unlike Mocha) and is generally thought of as an 'all-one-package'.

There are (way) more JavaScript unit testing frameworks - but these are the major ones at the time of writing.

#### Nice Things to Add to Your Testing Framework
* [Chai](http://chaijs.com/) - Chai is an 'assertion library' which can be added to any testing framework to beef up the language and readable style of tests. If you think about the syntactic sugar of RSpec, Chai will give you familiar ways to chain assertions that make tests more readable. It is usually used with Mocha, as Mocha does not have a built in assertion library. Other assertion libraries include `should.js`, `expect.js`, `better-assert`. `unexpected`.
* [Sinon.JS](http://sinonjs.org) - A library  used to add test spies, mocks and stubs to your tests. Works with QUnit, Jasmine and Mocha.

#### Test and Task Runners
* [Grunt](http://gruntjs.com/) - A JavaScript based task runner. Task runners can be configured to perform repetitive tasks for you, including running all of your test files.
* [Gulp](http://gulpjs.com/) - Yet another JavaScript task runner.
* [Karma](http://karma-runner.github.io/0.13/index.html) - a JavaScript ***test*** runner built with Node.js
* [Teaspoon](https://github.com/modeset/teaspoon) - a JavaScript test runner built for use with rails.

#### Drivers and Browsers and DOM Manipulation, Oh My

JavaScript code that was written to require a DOM needs to be run somewhere - normally it is run in a browser. When you are writing integration tests, you'll use a driver to simulate the DOM.

* [selenium](http://www.seleniumhq.org/) - Selenium is a browser automation library, usually used for testing web-applications. Selenium can fire up a browser that it controls in order to run tests on it. [selenium-webdriver](http://www.seleniumhq.org/) comes with the ability to use major browsers or a headless browser, Phantom.js, which we'll cover below.
* [Phantom.js](http://phantomjs.org/) - A headless browser used for automating web page interaction.  PhantomJS doesn't draw out a screen (thus the term 'headless'). This makes PhantomJS much faster. PhantomJS is NOT a testing framework, it is built to work with one (like Mocha, Jasmine, etc).
* [Capybara](https://github.com/jnicklas/capybara) - Capybara is an acceptance test framework for web applications written in Ruby. It supports the use of different drivers. The default driver is rack_test, but can be switched to other drivers for the purposes of testing JavaScript interactions.
  * [selenium-webdriver](https://github.com/SeleniumHQ/selenium/tree/master/javascript/node/selenium-webdriver) - See above. Can be used with Capybara.
  * [Capybara-Webkit](https://github.com/thoughtbot/capybara-webkit) - A capybara driver which uses [WebKit](https://webkit.org/) directly
  * [poltergeist](https://github.com/teampoltergeist/poltergeist) - A capybara driver for PhantomJS (a headless browser built on [WebKit](https://webkit.org/))
* [WebKit](https://webkit.org/) - an open source browser engine. WebKit is at the core of Safari and many other OS X applications. Chromium also uses an implementation of WebKit (Chrome, however, has it's own implementation for JavaScript execution called [V8](https://en.wikipedia.org/wiki/V8_%28JavaScript_engine%29)). As you can see above, many testing libraries work directly with WebKit.

Integration style testing will be covered more in the integration testing with JavaScript lesson.

## Basic Mocha syntax

We're going to try out some unit testing with Mocha. Before we dig into some exercises, let's look at some basic Mocha syntax.

#### The Interface
Mocha has different 'interface' systems that allow developers to choose the DSL style.

* `BDD` will give you an RSpec style of testing syntax, including: `describe()`, `context()`, `it()`, `before()`, `after()`, `beforeEach()`, and `afterEach()`.
  ```javascript
  describe('Array', function() {
  before(function() {
    // ...
  });

  describe('#indexOf()', function() {
    context('when not present', function() {
      it('should not throw an error', function() {
        (function() {
          [1,2,3].indexOf(4);
        }).should.not.throw();
      });
      it('should return -1', function() {
        [1,2,3].indexOf(4).should.equal(-1);
      });
    });
    context('when present', function() {
      it('should return the index where the element first appears in the array', function() {
        [1,2,3].indexOf(3).should.equal(2);
      });
    });
  });
});
///example taken from the mochajs.org page
  ```
* `TDD` will give you a MiniTest or TestUnit style of testing syntax, including: `suite()`, `test()`, `suiteSetup()`, `suiteTeardown()`, `setup()`, and `teardown()`.

  ```javascript
  suite('Array', function() {
  setup(function() {
    // ...
  });

  suite('#indexOf()', function() {
    test('should return -1 when not present', function() {
      assert.equal(-1, [1,2,3].indexOf(4));
    });
  });
});
///example taken from the mochajs.org page
  ```
  * Mocha also provides `Exports`, `QUnit` and `Require` styles.

The default style that you'll likely see is BDD.

## Assertions and Chai

As we mentioned above, Mocha does not have a default assertion library. We can add on our preferred assertion library, such as [Chai](http://chaijs.com/) to add them in.

The easiest way to see this in action is to look at a very basic implementation.

1. Fork this [js-unit-testing-basics](https://github.com/turingschool-examples/js-unit-testing-basics.git) project.

2. In this project, you'll see that we've snagged the chai.js and mocha.js files in `vendor` and included them in a JavaScript test.

3. Open the `test.html` file in the main directory in your browser. You should see one passing test.

4. Open the `test.js` file in your text editor and remove the first line from it.

5. Now, when you refresh the `test.html` file in the browser, you should see an error indicating that `assert` is not defined.

Chai can be used to add `expect` and `should` style assertions as well in the manner. Check out [Chai](http://chaijs.com/) to get more test assertion inspiration.

In future projects, mocha and chai will be brought in through `npm` or `bower` or gems - but feel free to use this simple implementation to play around with writing tests.

## Let's Try It Out

We'll try some examples out now to dig a little bit deeper into unit testing JavaScript.

* Fork this repository: [Testing JavaScript](https://github.com/turingschool-examples/testing-javascript)
* Check out the `bower.json` file in the main directory. You'll see that the dependancies object will include many of the libraries we mentioned above.

We'll now to through the following examples:

* [1-basic-mocha](https://github.com/turingschool-examples/testing-javascript/tree/master/examples/1-basic-mocha)
* [2-add-two-and-mocha](https://github.com/turingschool-examples/testing-javascript/tree/master/examples/2-add-two-and-mocha)
* [3-mocha-and-the-dom](https://github.com/turingschool-examples/testing-javascript/tree/master/examples/3-mocha-and-the-dom)
* [4-notes](https://github.com/turingschool-examples/testing-javascript/tree/master/examples/4-notes)

Challenge Level: Check out the `qunit` branch of the `testing-javascript` repo and try the exercises there.

## A Note on Unit Testing in Rails
  Rails does not make it easy to unit test JavaScript. Many developers will test their JavaScript in a rails application only with integration tests for this reason. The [Testing JavaScript In Rails](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/testing_javascript_in_rails.markdown) lesson plan is an excellent resource for preparing your testing suite in rails to unit test your JavaScript.

## Connection to GameTime

The Game Time Starter Kit comes packaged with some of our old friends. [Check out the package.json file.](https://github.com/turingschool-examples/game-time-starter-kit/blob/master/package.json#L27)
