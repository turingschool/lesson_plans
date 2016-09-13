# Testing 2.0 

## Learning Goals
* What are some of the challenges with unit testing?
* What is a fixture and when should you use one?
* What is stubbing? How do you stub in Ruby with Minitest? When should you do it?
* What is mocking? How do you mock in Ruby with Minitest? When should you do it?
* What’s the difference between behavior and state testing?

## Background Concepts
* Test Doubles(dummy, fake, stub, spies, mocks). Further reading:
  - Basic: Martin Fowler: http://www.martinfowler.com/bliki/TestDouble.html
  - Advanced: Gerard Meszaros http://xunitpatterns.com/Test%20Double.html
* Four-phase testing
	* Setup - sometimes in test, sometimes separate method
	* Exercise
	* Verify
	* Teardown 
* System under test (SUT) or Object Under Test

## Setup
Clone this repo: `https://github.com/bethsebian/stub_and_mock`

## Fixtures
### Basics
* Create smaller copies of files you'll use in production, include the bare minimum data you need to test functionality
* Save to `fixtures` folder in your `test` folder

### Example
* `cd` into the `fixtures_example` directory ``` def test_it_loads_dropout_data_when_initialized_alt_fixture 
    data_repository = DataRepository.new("./test/fixtures/race_and_ethnicity_dropout_rates.csv")

    assert_instance_of DistrictData, data_repository.data.last
    assert_equal 0.0, data_repository.data.last.percentage
end ```

### Check for understanding
Create alternative implementation of `test_it_loads_enrollment_data_when_initialized` using a fixture

## Mocking versus Stubbing

### What’s the problem we’re trying to correct?
  * Order/Warehouse example
  * Always asking the question: What’s the system under test (SUT)? 
	
### Test Doubles to the Rescue
* **Stubs** provide canned answers to calls made during the test, usually not responding at all to anything outside what's programmed in for the test.
* **Mocks** are pre-programmed with expectations which form a specification of the calls they are expected to receive. They can throw an exception if they receive a call they don't expect and are checked during verification to ensure they got all the calls they were expecting.
* Critical distinction: focus on behavior

### Setup: Mocking and Stubbing Libraries
We'll be using mocha for these exercises.
  1. Run `gem install mocha` from command line
  2. Require in your file or test_helper: `require 'rubygems'; gem 'mocha'; require 'mocha/mini_test'`
  3. Another common library is [flexmock](https://github.com/jimweirich/flexmock)

### Stubs
* Instead of creating a new instance, we just stub it and commands we’d want to call on it
* It allows us to imitate the _state_ of an actual object or call. 
* Use cases
  * Testing across classes (view and document example)
  * Isolating a method within a class (shipping costs example)
* State, state, state

### Check for Understanding: Stubs
Creating an alternate version of the color test using stubs.

### Mocks
* Focuses on behavior
* How to use (enterprise example)
* References: http://gofreerange.com/mocha/docs/Mocha/Expectation.html

### Check for Understanding: Mocks
Create an alternate version of the zap test using mocking.
