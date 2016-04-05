## Ruby Project Etiquette -- How to Mind Your P's and Q's in a Ruby Project

In this session we're going to go over some common best practices for organizing and managing code in our Ruby projects.

### Intro Discussion

* Why conventions?
* "Bike Shedding" -- Importance of avoiding trivial distractions
* "Toilet Paper on Your Shoe" -- Don't want to give impression we don't know what we're doing
* What works, what doesn't?
* Project / Library conventions vs. "App" conventions (which you'll see in later modules)

### Directory and File Organization

#### File Naming Conventions

1. Snake-case file names (`my_file.rb` rather than `myFile.rb` or `my-file.rb`)
2. End files in `.rb`
3. Match file names to the class name -- e.g. a file containing the class `RotationGenerator` should be `rotation_generator.rb`

#### Directory Structure

In a standard Ruby project, we tend to organize code into 3 subdirectories:

1. `lib` for source code
2. `test` for test files
3. `bin` for any "executable" files (you may not have encountered any of these yet; if you don't have them, leave `bin` out)

Additionally, it's common for test files and source files to match relatively 1-to-1. Thus a class called `RotationGenerator` will generally be found in the source file at `lib/rotation_generator.rb` and will have a corresponding test file at `test/rotation_generator_test.rb`.

#### Exercise

Take the following 2 code snippets and place them into a correct ruby project structure. Consider:

* What directories and files do you create
* What content goes into each file
* How do you require the code file from the test

```ruby
class TastyPizza
  def nom
    "mmmm 'za"
  end
end
```

```ruby
require "minitest/autorun"
# _______________ <--- Your Require Statement Here

class TastyPizzaTest < Minitest::Test
  def test_za_is_tasty
    assert_equal "mmmm 'za", Pizza.new.nom
  end
end
```

### Require Statements

* Require statements always trip us up
* But there are some straightforward rules we can follow that make things much more reliable

#### Running Project Code

* Assume code will be run from **root** of your project

**Pause and Wait Question:**

Given a project with the following structure:

`.
├── lib
│   ├── enigma.rb
└── test
    ├── enigma_test.rb
```

* How would I run the code in `enigma.rb`?
* How would I run the code in `enigma_test.rb`?

**Avoid the temptation to physically go into test or lib directories to run code**

#### `require` vs. `require_relative`

With that point out of the way we can talk about require.

Here are the rules for these 2 techniques:

1. `require_relative` attempts to require a second file using a path *relative to* the file that is requiring it.
2. `require` attempts to require a second file *relative to* the place from which the first file is **being run** -- that is, relative to whatever place you are sitting when you type `ruby file_one.rb`

This last point is why the previous section is so important -- if you don't run your files from a consistent place in the project structure, it's difficult to set up require statements that will work consistently.

**Rule of Thumb: Prefer `require`**

#### Load Path Crash Course

Let's talk a bit about reasons for preferring `require`

1. It tends to be more common within the community. Programmers get workedup about weird things and sometimes it's best to just go with the flow
2. `require` tends to behave more consistently in complex scenarios and project structures.
3. `require` is also what we'll use for external gems and libraries. This is because...
3. `require` is designed to cooperate with ruby's `$LOAD_PATH`

**What is the `$LOAD_PATH`**

* How does Ruby know where we look when we `require` something?
* Why is it we say `require "minitest"` but `require "./lib/enigma"` -- obviously the `minitest` file is not sitting in the root of our project
* `$LOAD_PATH` is an internal structure (actually an `Array`) that Ruby uses to track in which locations it is allowed to look for things we require
* Default `$LOAD_PATH` will contain Ruby itself, files in the standard library (hence we can `require "date"` without a path), **as well as our current directory**
* the last point is why require, by default, works relative to the place from which you code is *being run*, and thus why we should try to stick with the habit of running code from project root

### Rakefiles and Test Runners

### Gemfiles and Bundler

### Homework
