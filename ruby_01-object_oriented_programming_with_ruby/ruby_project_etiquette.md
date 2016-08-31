## Ruby Project Etiquette: How to Mind Your P's and Q's in a Ruby Project

In this session we're going to go over some common best practices for organizing and managing code in our Ruby projects. By the end of the lesson, you should be comfortable with the following tasks.  

* File naming conventions
* Directory structure conventions
* Difference between `require` and `require_relative`
* What `$LOAD_PATH` is and how it helps you
* How to build a rakefile and why you'd want to
* How to build a gemfile and why you'd want to

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

#### Check for Understanding 
In pairs, identify 5 Ruby conventions regarding file naming and directory structure. 

### Require Statements

* Require statements always trip us up
* But there are some straightforward rules we can follow that make things much more reliable

#### Running Project Code

* Assume code will be run from **root** of your project

#### Check for Understanding

Given a project with the following structure:

```
.
├── lib
│   ├── enigma.rb
└── test
    ├── enigma_test.rb
```

* How would I run the code in `enigma.rb`?
* How would I run the code in `enigma_test.rb`?

Please post your answers in Slack.  

**Avoid the temptation to physically go into test or lib directories to run code**

#### `require` vs. `require_relative`

With that point out of the way we can talk about require.

Here are the rules for these 2 techniques:

1. `require_relative` attempts to require a second file using a path *relative to* the file that is requiring it.
2. `require` attempts to require a second file *relative to* the place from which the first file is **being run** -- that is, relative to whatever place you are sitting when you type `ruby file_one.rb`

This last point is why the previous section is so important -- if you don't run your files from a consistent place in the project structure, it's difficult to set up require statements that will work consistently.

#### Check for Understanding
Take two minutes to rewrite rules 1 and 2 in your own words. Post your answers in Slack.

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
* Your OS has a similar construct called `PATH` which it uses to find executable commands. Check it out by running `echo $PATH` at your terminal. This is how it knows what to execute when we type a simple command like `git`

#### Exercise: Messing with Load Path

1. Create a ruby file called `print_stuff.rb` in the directory `/tmp` on your machine (thus `/tmp/print_stuff.rb`)
2. In that file define a simple method that prints a line of text. Call it `print_stuff`
3. Go to your **Home Directory** (`cd ~`) and open a pry or IRB session
4. Use ruby to ADD the path `/tmp` to your load path (remember, `$LOAD_PATH` is just an array so you can use normal Ruby array methods on it)
5. Verify that you can require your file `print_stuff` without adding any path information to the require statement

#### Check for Understanding
Write for 4 minutes: what is `$LOAD_PATH` and how does it help you? If you finish early, scan this article from Joshua Paling on [Load Path](http://joshuapaling.com/blog/2015/03/22/ruby-load-path.html).

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

#### Baby's First Rakefile:
On your own, build your first testing rakefile.

**Rake Objective:** I go into the root directory of your project, type `rake`, and your test suite (all of your tests) should run

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

#### Check for Understanding
Write independently on the following questions:  

* Why would you use a rakefile? 
* How does it help you? 
* How else might you use a rakefile in an application?

### Gemfiles and Bundler

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
