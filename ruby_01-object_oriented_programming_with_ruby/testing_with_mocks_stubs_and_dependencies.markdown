---
title: Testing with Mocks, Stubs, and Dependency Injection
length: 90
tags: tdd, ruby, dependencies, mocks, stubs
---

## Learning Goals

* Be able to use mocks to representing domain objects in a test
* Be able to use stubs to override or stand in for object behavior
* Be able to inject a dependency into a collaborating object

## Structure

* 5 - Intro
* 20 - Session 1
* 20 - Session 2
* 20 - Session 3
* 15 - Q & A

## Content

### Intro

Let's talk for a few minutes together before you break up to learn each subject.

Clone [this repository](https://github.com/turingschool-examples/testing-dependency-injection) so you have the code we're working with.

Take a second to explore the code and run the tests. You'll find that we're working on a system to organize and report on the data for a school/class/student.

For much of our work we're going to use the Mocha library. Open up the `./test/test_helper.rb` file and you'll see the require statements that we're going to use across test files. Each of our actual test files will require this test helper so we have the libraries loaded up.

### Topic 1: Mocks

Mocks are objects that stand in for other objects. The other object might be one that's not implemented yet, doesn't yet have the functionality we need, or maybe we just want to work with a simpler situation.

Open the `./test/section_test.rb` and read the tests there. Note that the second and third tests are skipped. Run `mrspec` before you make any changes and they should be passing with the skips in place. Unskip the second test in `section_test.rb`, run the tests with `mrspec`, and see that the test is failing.

Why? The test doesn't know what a `Student` is. We could go create it!

But *wait*. We're trying to write a unit test here. We're trying to test a `Section`, not a `Student`. The `Student` class might be a whole can of worms we're not willing to deal with right now. Let's use a mock!

#### A First Mock

A mock is a simple object that stands in for another object. At the base level, a mock is just a "thing" -- a blank canvas that we can use for just about anything. You create a mock like this:

```ruby
my_thing = mock('name')
```

Looks weird, right? Read this code carefully and figure out:

* what is `mock`, from a Ruby perspective? (like an "object", "integer", what?)
* what type thing is `'name'`?

Let's try to put it to use. Replace the two `Student.new` lines in the test with these:

```ruby
student_1 = mock('student')
student_2 = mock('student')
binding.pry
```

Run your test and pry should pause things. Figure out what the class of `student_1` and `student_2` is. Find the documentation for this class on the web to get an idea of what's possible. Query the `student_1` object to find out what methods it has. Exit pry.

Remove the `binding.pry`, run the test, and it still fails. Add the functionality needed to `Section` to make it work!

Now that your tests are passing, notice how the mocks allowed you to build out the `Section` functionality without actually implementing a `Student`.

#### Mock Expectations

Mocks can do more than just stand there. Remove the `skip` from the third `section_test.rb` and run it. It fails on the `Student.new` line.

Wait a second before you drop a `mock` in there. Read the rest of the tests. See how we need the first names? The previous test didn't use that name data, but now we need it. Let's build a smarter mock.

When you look at the mocha documentation you'll find that a Mock has methods we can call on it.

* `.expects` defines a method that can be called on the mock
* `.returns` defines the value that the expected method should return

Putting that together we replace the first `Student.new` with this:

```ruby
student_1 = mock('student')
student_1.expects(:first_name).returns("Frank")
```

Also replace `student_2` with a similar two lines. Then add a `binding.pry` and run the tests.

Once you're in pry, try calling the `first_name` method on `student_1`. Does it work? Call it again? Does it work?

Now go ahead and implement the `student_names` method in `Section` to make the test pass.

That's how mocks work. You create a mock to stand in for other objects and can add some simple capabilities to get you the functionality you need.

### Topic 2: Stubs

A stub is a fake method added to or overriding an existing method on an object.

#### A First Stub

Unskip the second test in `./test/metrics_calculator_test.rb`, run it with `mrspec`, and see it fail. Make it pass without using any mocks/stubs just yet.

With that in place, unskip the third test, run it, and see if fail. Read the test body and figure out what's going on here.

The `MetricsCalculator` needs to have a `total_students` method. Logically that method needs to ask each `Section` about how many students there are. But our `Section` doesn't yet track actual students. What do we do?

We're working on testing the `MetricsCalculator`, not `Section`. Why go off adding functionality in `Section`? Let's, instead, pretend that `Section` has the functionality we want with a *stub*.

In the test find the comment that says that section 1 should have 22 students. Replace that line with this:

```ruby
sec_1.stubs(:student_count).returns(22)
```

Replace the later two comments with similar lines. The `stubs` method is essentially tacking a `student_count` method onto the existing `sec_1`. The `returns` sets the return value for that method call. Run the test again.

Now it fails because `total_students` is undefined. Define that method in `MetricsCalculator` assuming that each section instance now has a `student_count` method. The test should now pass.

#### Combining Stubs

Then check out the next test in `metrics_calculator.rb`. Unskip it and make it pass without changing `Section`. Note that this is a *weighted* average based on the number of students in each section and their average score.

### Topic 3: Dependency Injection

#### Mocking Merchant

We want to be able to call `merchant.items`. What should happen at this point? The merchant should delegate this task to its repository (who will in turn delegate the task to the sales engine -- don't worry about this for right now).

Let's draw a picture to understand how this works.

All we care about for now is the fact that when we call `merchant.items`, some method gets called on the repository. We're not concerned about what gets returned; we just want to know it happened. For this, we can use a mock.

##### Mocking in Minitest Syntax

```ruby
mock = Minitest::Mock.new
mock.expect(:method_that_should_be_called, faked_out_return_value, [method_arguments])
#some code execution
mock.verify
```

#### Testing and Implementing Merchant

Let's look at how to use a mock repository in the merchant test.

Key Points

* we'll mock out the repository
* pass in the mock repository to the new instance of merchant
* set up an expectation for what method should be called on the repository
* call `merchant.items`
* verify that the method was called on the repository

Repeat this process for `merchant.invoices`.

#### Testing and Implementing Item

In pairs, use a mock repository in the item test. You should be able to call `item.merchant` or `item.invoice_items` and it should delegate the task to the repository.

#### Mocking Merchant Repository

When we call `merchant.items`, we set up the expecation that the method `merchant_repository.items_from(id)` should be triggered. The merchant repository should then ask its sales engine to find this information.

#### Testing and Implementing Merchant Repository

Let's look at how to use a mock sales engine in the merchant repository test.

Key Points

* we'll mock out the sales engine
* pass in the mock sales engine to the new instance of merchant repository
* set up an expectation for what method should be called on the sales engine
* call `merchant_repository.items_from(id)`
* verify that the method was called on the sales engine

Repeat this process for `merchant_repository.find_invoices_from(id)`.

#### Testing and Implementing Item Repository (OPTIONAL)

In pairs, use a mock sales engine in the item repository test. You should be able to call `item_repository.invoice_items_from(id)` or `item_repository.merchant_for(id)` and it should delegate the task to the repository.

## Wrapup

Return to standards and check progress.
* What was easy?
* What was challenging?
* What made sense?
* What didn't make sense?
