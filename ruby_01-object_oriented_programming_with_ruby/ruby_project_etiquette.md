## Ruby Project Etiquette: How to Mind Your P's and Q's in a Ruby Project

In this session we're going to go over some common best practices for organizing and managing code in our Ruby projects. By the end of the lesson, you should be comfortable with the following tasks.  

* File naming conventions
* Directory structure conventions
* Difference between `require` and `require_relative`
* What `$LOAD_PATH` is and how it helps you
* How to build a rakefile and why you'd want to
* How to build a gemfile and why you'd want to

### Introduction
* Why conventions?
* "Bike Shedding": Importance of avoiding trivial distractions
* "Toilet Paper on Your Shoe": Don't want to give impression we don't know what we're doing
* Project / Library conventions vs. "App" conventions (which you'll see in later modules)

#### Reflection
Why should you care about Ruby convention?

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
Require statements often trip us up, but there are some straightforward guidelines we can follow that make things much more reliable. 

#### Err on the Side of `require`

Consider a project with the following structure.

```
.
├── lib
│   ├── enigma.rb
└── test
    ├── enigma_test.rb
```

If we were running our test files from `$ project/test`, we could use either use either `require_relative '../lib/enigma'` or `require './lib/enigma'`. To run our tests from `$ project`, however, only the `require './lib/enigma'` will work. It's better to get in the habit of requiring files using `require` and a path relative to the project root, from which you're presumably running your code. 

**Avoid the temptation to navigate into go into test or lib directories through terminal to run code (i.e. `test$ ruby enigma_test`). Use `enigma$ ruby test/enigma_test.rb` instead.**

##### Why do we prefer `require`?

It tends to be more common within the community. Programmers get workedup about weird things and sometimes it's best to just go with the flow



##### `require` vs. `require_relative`
Here's a quick overview of _how_ `require` and `require_relative` work.

`require_relative` attempts to require a second file using a path *relative to* the file that is requiring it.
* Does NOT matter where you run the test from (searches for path relative to the file the requirement is in)
* As directory structure gets more complex, navigating relative to the file you require come can become convoluted (`require_relative '../../../lib/enigma'`).

`require` attempts to require a second file *relative to* the place from which the first file is **being run** -- that is, relative to whatever place you are sitting when you type `ruby file_one.rb`
* DOES matter where you run the test from
* Rails assumes we're running from the main project directory. 
* require tends to behave more consistently in complex scenarios and project structures (`require './lib/enigma'`)
* require is also what we'll use for external gems and libraries. This is because...
* require is designed to cooperate with ruby's $LOAD_PATH

##### Check for Understanding
What is the difference between the `../` and the `./` path prefix? Which works better with `require` and how does that make your file requirement more resilient?

#### Load Path Crash Course
How does Ruby know where we look when we `require` something? Why is it we say `require "minitest"` but `require "./lib/enigma"` when obviously the `minitest` file is not sitting in the root of our project.

##### What is the `$LOAD_PATH`
$LOAD_PATH is an internal structure (actually an `Array`) that Ruby uses to keep track of where it can look to find files it needs (or we ask it to look for).

Open a `irb` session and type in `$LOAD_PATH`. You should get a response of something like this: 
``` ruby
["/Users/your_username/.rvm/gems/ruby-2.3.0@global/gems/did_you_mean-1.0.0/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0@global/gems/executable-hooks-1.3.2/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0@global/extensions/x86_64-darwin-15/2.3.0/executable-hooks-1.3.2",
 "/Users/your_username/.rvm/gems/ruby-2.3.0@global/gems/bundler-unload-1.0.2/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0@global/gems/rubygems-bundler-1.4.4/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0@global/gems/bundler-1.12.5/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0/gems/slop-3.6.0/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0/gems/method_source-0.8.2/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0/gems/pry-0.10.4/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0/gems/coderay-1.1.1/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0/gems/byebug-9.0.5/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0/extensions/x86_64-darwin-15/2.3.0/byebug-9.0.5",
 "/Users/your_username/.rvm/gems/ruby-2.3.0/gems/pry-byebug-3.4.0/lib",
 "/Users/your_username/.rvm/gems/ruby-2.3.0/gems/pry-rails-0.3.4/lib",
 "/Users/your_username/.rvm/rubies/ruby-2.3.0/lib/ruby/site_ruby/2.3.0",
 "/Users/your_username/.rvm/rubies/ruby-2.3.0/lib/ruby/site_ruby/2.3.0/x86_64-darwin15",
 "/Users/your_username/.rvm/rubies/ruby-2.3.0/lib/ruby/site_ruby",
 "/Users/your_username/.rvm/rubies/ruby-2.3.0/lib/ruby/vendor_ruby/2.3.0",
 "/Users/your_username/.rvm/rubies/ruby-2.3.0/lib/ruby/vendor_ruby/2.3.0/x86_64-darwin15",
 "/Users/your_username/.rvm/rubies/ruby-2.3.0/lib/ruby/vendor_ruby",
 "/Users/your_username/.rvm/rubies/ruby-2.3.0/lib/ruby/2.3.0",
 "/Users/your_username/.rvm/rubies/ruby-2.3.0/lib/ruby/2.3.0/x86_64-darwin15"]
 ```
 
The default `$LOAD_PATH` will contain Ruby itself, files in the standard library (hence we can `require "date"` without a path), **as well as our current directory**. This is why `require`, by default, works relative to the place from which you code is *being run*, and thus why we should try to stick with the habit of running code from project root

Your OS has a similar construct called `PATH` which it uses to find executable commands. Check it out by running `echo $PATH` at your terminal. This is how it knows what to execute when we type a simple command like `git`

##### Exercise: Messing with Load Path

1. Create a ruby file called `print_stuff.rb` in the directory `/tmp` on your machine (thus `/tmp/print_stuff.rb`)
2. In that file define a simple method that prints a line of text. Call it `print_stuff`
3. Go to your **Home Directory** (`cd ~`) and open a pry or IRB session
4. Use ruby to ADD the path `/tmp` to your load path (remember, `$LOAD_PATH` is just an array so you can use normal Ruby array methods on it)
5. Verify that you can require your file `print_stuff` without adding any path information to the require statement

##### Check for Understanding
Describe why the exercise above worked.

##### Extension
If you finish early, scan this article from Joshua Paling on [Load Path](http://joshuapaling.com/blog/2015/03/22/ruby-load-path.html).

### Rakefiles and Test Runners

* Unix origins, building projects, and `make`
* Problem: want a standardized command that you can run in every project
* For a C project, "building" means compiling and verifying that things work
* Ruby projects don't get compiled, so what does "building" mean for a Ruby project?
* Rake tries to create a standardized solution for this problem
* Also provides a standardized "task runner" for ruby projects
* `Rakefile` is a special file that lives in the root of your project and defines these tasks

#### Using Rake to Build a Task
Code along with your instructor to build your first rake task.

```ruby
task :pizza do
  puts "om nom nom"
end
```

This task would then be run from the command line using `rake pizza` (from the **project root** -- noticing a pattern?)

#### Building a Testing Rake Task
On your own, build your first testing rake task. Our objective is to be able to go into the root directory of your project, type `rake`, and run our test suite (all of your tests) with that one command.

```ruby
require "rake"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task default: :test # <------ important
```

##### Exercise 
Use your knowledge of Ruby's object model and blocks to make sense of the rake TestTask above. 

## Gemfiles and Bundler

* Not super important for now but we'll cover it briefly
* A "Gem" is a packaged up piece of ruby code designed to be shared with others (i.e. a library)
* [RubyGems](https://rubygems.org/) is the community-run repository and website where gems can be published so other users can download them
* [Bundler](http://bundler.io/) is the popular dependency manager rubyists use to download and manage gems
* Similar to a `Rakefile`, a `Gemfile` lives at the **root of your project** and contains a list of the gems that project *depends on*

**Sample Gemfile:**

```ruby
source "https://rubygems.org"

gem "minitest"
```

* To install the dependencies listed in this file you would run `bundle` (**Can you guess from where?**)
* Running bundle will also create a special file called `Gemfile.lock` in your project root. You should commit both of these files to source control

#### Exercise - Making A Gemfile

1. Create a new blank directory on your machine
2. Create an empty file called `http_requests.rb`
3. In the file, enter the following code to make a request using the Faraday gem:

```ruby
require "faraday"
Faraday.get('https://www.google.com').body
```

4. Create an empty `Gemfile` in the directory
5. Use GOOGLE to determine what to add to the gemfile to install the `faraday` gem
6. Then use `bundle` to install this gem and see that your code works

#### Summary
Review objectives from beginning of session.

### Homework

Tonight:

1. Update your current project to follow these conventions
2. Update one previous project (jungle beats, BST, etc) to also follow these conventions
