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
* System Under Test (SUT) or Object Under Test

## Setup
Clone this repo: `https://github.com/bethsebian/stub_and_mock`

## Fixtures
### Basics
* Create smaller copies of files you'll use in production
* How many lines of data should your fixture include? No hard number. Include the **bare minimum** data you need to test functionality.
* Save to `fixtures` folder in your `test` folder

### Example
* `cd` into the `fixtures_example` directory 

```ruby 
def test_it_loads_dropout_data_when_initialized_alt_fixture 
    data_repository = DataRepository.new("./test/fixtures/race_and_ethnicity_dropout_rates.csv")

    assert_instance_of DistrictData, data_repository.data.last
    assert_equal 0.0, data_repository.data.last.percentage
end 
```

### Check for understanding
Create alternative implementation of `test_it_loads_enrollment_data_when_initialized` using a fixture

## Mocking versus Stubbing

### What’s the problem we’re trying to correct?
  * Order/Warehouse example
  * Always asking the question: What’s the system under test (SUT)? 
	
### Test Doubles to the Rescue
* **Stubs** provide canned answers to calls made during the test.
```ruby
object = mock()
object.stubs(:stubbed_method).returns(1, 2)
object.stubbed_method # => 1
object.stubbed_method # => 2
```
* **Stubs** Especially helpful to fake state of secondary objects that are auxilary to our test. 
* **Stubs** Allows you to imitate _state_.

* **Mocks** allow you to define what calls a method you're testing should make. Mocking libraries include extensive list of expectations to verify what you expect to happens happens. Allows you to imitate _behavior_.
```ruby
object = mock()
object.expects(:expected_method).at_least_once

object = mock()
object.expects(:expected_method).never

object = mock()
object.expects(:expected_method).at_most_once
object.expected_method #=> passes

object = mock()
object.expects(:expected_method).at_most_once
2.times { object.expected_method } #=> fails
```
* **Mocks** especially helpful to test whether SUT is behaving on secondary objects as you expect. 
* **Mocks** allows you to verify _behavior_.
* More examples: http://www.rubydoc.info/github/floehopper/mocha/Mocha/Expectation

### Setup: Mocking and Stubbing Libraries
We'll be using mocha for these exercises.
  * Run `gem install mocha` from command line
  * Require in your file or test_helper
```ruby
require 'rubygems'
gem 'mocha'
require 'mocha/mini_test'
```
* Another common library is [flexmock](https://github.com/jimweirich/flexmock)

### Stubs
* Instead of creating a new instance, we just stub it and dictate what state and behavior we want that secondary object to hold. 
* It allows us to imitate the _state_ and _state-dependent behavior_ of an actual object.
* Use cases
  * Testing across classes (example: View/Document)
  * Isolating a method within a class (example: Order Shipping Costs)
* State, state, state

### Check for Understanding: Stubs
Creating an alternate version of the color test using stubs.

### Mocks
* Mocks allow us to test whether the SUT exercises the behavior (especially on other objects) we want it to exercise. 
```ruby
class DelegatorOfThings
	def delegate_the_things(doer_of_things)
		doer_of_things.do_thing_1
		doer_of_things.do_thing_2
	end
end

class DelegatorOfThingTest < Minitest::Test
	def test_it_does_the_thing
		doer_of_things = mock()
		doer_of_things.expects(:do_thing_1).once #<= This is the verification/expectation. It will _pass_ or _fail_
		doer_of_things.expects(:do_thing_2).once #<= This is the verification/expectation. It will _pass_ or _fail_
		
		delegator = DelegatorOfThings.new
		delegator.delegate_the_things(doer_of_things)
	end
end
```
* Example: `mock_example` ("enterprise")

### Check for Understanding: Mocks
Create an alternate version of the zap test using mocking.

## The Ultimate CfU
* How will you know you're writing a test that might be appropriate for stubbing or mocking?
* What's the difference between testing doubles that rely on state versus behavior?
* How many lines of data should you include in your fixture files?
