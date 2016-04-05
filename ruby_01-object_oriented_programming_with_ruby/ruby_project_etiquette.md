## Ruby Project Etiquette -- How to Mind Your P's and Q's in a Ruby Project

In this session we're going to go over some common best practices for organizing and managing code in our Ruby projects.

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

#### Load Path Crash Course

#### `require` vs. `require_relative`

### Gemfiles and Bundler

### Rakefiles and Test Runners
