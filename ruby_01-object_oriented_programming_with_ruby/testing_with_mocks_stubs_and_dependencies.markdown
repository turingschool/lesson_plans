---
title: Testing with Mocks, Stubs, and Dependency Injection
length: 90
tags: tdd, ruby, dependencies, mocks, stubs
---

## Learning Goals

* Be able to use mocks to represent domain objects in a test
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

For much of our work we're going to use the Mocha library. Open up the `./test/test_helper.rb` file and you'll see the require statements that we're going to use across test files. Each of our actual test files will require this test helper so we have the libraries loaded up. run 'gem install mocha' to make sure you have access to the Mocha library. 

You may need to run `bundle` to make sure you have all the proper gems installed.

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

Unskip the first test in `./test/metrics_calculator_test.rb`, run it with `mrspec`, and see it fail. Make it pass without using any mocks/stubs just yet.

With that in place, unskip the second test, run it, and see if fail. Read the test body and figure out what's going on here.

The `MetricsCalculator` needs to have a `total_students` method. Logically that method needs to ask each `Section` about how many students there are. But our `Section` doesn't yet track actual students. What do we do?

We're working on testing the `MetricsCalculator`, not `Section`. Why go off adding functionality in `Section`? Let's, instead, pretend that `Section` has the functionality we want with a *stub*.

In the test find the comment that says that section 1 should have 22 students. Replace that line with this:

```ruby
sec_1.stubs(:student_count).returns(22)
```

Replace the later two comments with similar lines. The `stubs` method is essentially tacking a `student_count` method onto the existing `sec_1`. The `returns` sets the return value for that method call. Run the test again.

Now it fails because `total_students` is undefined. Define that method in `MetricsCalculator` assuming that each section instance now has a `student_count` method. The test should now pass.

#### Combining Stubs

Then check out the next test in `metrics_calculator_test.rb`. Unskip it and make it pass without changing `Section`. Note that this is a *weighted* average based on the number of students in each section and their average score.

### Topic 3: Dependency Injection

Many classes rely on other classes which is why we have all these strategies around unit or isolation testing.

But Ruby has a super-power that we can exploit: a flexible typing system. It's often called "Duck Typing" -- if it looks like a duck, quacks like a duck, then it's a duck.

So what is dependency injection? When "Class A" internally uses "Class B", we'd say that A depends on B. Typically that's programmed in a way where B is a "hard" dependency -- the name of the class is embedded right in A's source code. But, with a bit of work, we can turn B into a "soft" dependency -- one that's determined at runtime.

#### Getting Started

First let's just write a little code. Open up the `./test/schedule_test.rb`, unskip the second test, then write the code in `Schedule` to make it pass.

#### Building with a Dependency

The third test gets a little more complicated. It starts by deleting a file named `schedule.txt` if it exists, so we can guess there's some kind of File I/O happening. Then it checks that the file is actually deleted.

In the middle of the test we have some looping to create a bunch of classes, likely a realistic-ish schedule. Then a `schedule.write` which is likely related to the File I/O seen above. Finally there's an assertion to verify the existence of `schedule.txt`.

So we can deduce that our `.write` method needs to create a file on the file system named `schedule.txt`, but we don't yet care what's actually in it.

Write an implementation inside `Schedule` to make this pass.

#### Making the Dependency Explicit

After you passed the previous test your code surely uses `File`, likely `File.write`. That reliance on the `File` class is a dependency. Let's see what we can do to massage the dependency into a different spot.

Let's have your `write` method explicitly create a file handle object instead of using the `.write` class method. A simple version of that would look like this:

```ruby
def write
  sections.sort_by{|s| s.name}.each do |s|
    output_target.write(s.name + "\n")
  end

  output_target.close
end
```

Run your tests and the three active tests in `schedule_test.rb` should still be passing.

Now, what can we do with `output_target`?

* Add an `attr_reader` named `output_target`
* Move the `File.open('schedule.txt', 'w')` to the initialize and store the file handle it returns into `@output_target`
* Cut that first line out of your `.write` method

Run the tests and they should still be passing. Finally it's time to unskip the next test ("specifying the file system"). Run `mrspec` and see the test fail.

The change here is that the test is creating `output_file_handle` and expecting to supply that to the `initialize` of `Schedule`. We need the `initialize` to take in this argument, but also default to no arguments for the previous tests to pass. Here's the easiest way to do that:

```ruby
def initialize(target = nil)
  @sections = []
  @output_target = target || File.open('schedule.txt', 'w')
end
```

The `target` parameter is set to `nil` by default, making it optional. Then when we set `@output_target` we use a common Ruby pattern: the short-circuit OR:

* If `target` is a truthy thing (anything except `nil` or `false`), then it'll get stored into `@output_target`
* If `target` is falsey (in this case, `nil`) then the right side of the OR will be run and that object will get stored into `@output_target`

The resulting structure boils down to "if a `target` is passed in store that into `@output_target`, otherwise create a new file handle and store that into `@output_target`".

Run the test and it should pass. The test is passing in the exact same file handle that the `Schedule` would have otherwise created, but the important part is that we're now injecting the dependency.

Prove it? Go back to your test. Replace the four occurrences of the filename `schedule.txt` with the name `output.txt`. Run the test and see it pass, still. The only way it could be writing to the right file is if the `Section` is making use of the file handle we created in the test and passed in.

#### Injecting a Different Dependency

Let's say that we don't want our tests writing files to the file system. We could now inject a different dependency to the `Section`. What would it have to do? Well, look at your implementation. What methods are called on `output_target`?

The only two methods called are `.write` and `.close`. We'd call this the "interface" -- `output_target` can be anything that at least offers those two methods. If we create another object that has both of them, we can send that into the `initialize` of `Section`.

Unskip the next test. Read through the small `FakeFile` class that is written in your test file. See how it has a simple string (`content`) and any calls to `write` just append to that string? That'll be easy to work with because we're not creating and destroying files -- we're just reading a string.

Run the test and, just that easy! All tests in this test file should be passing.

### Wrapup / Q & A

Did you survive? Surely you have some questions. Consider:

* What was easy?
* What was challenging?
* What made sense?
* What didn't make sense?
