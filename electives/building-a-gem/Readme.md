Building a Gem
==============

Material for the [Building a Gem](https://github.com/turingschool/electives/blob/master/schedule.markdown#building-a-gem-with-josh-cheek) elective.
We ultimately build [this](https://github.com/JoshCheek/gitloc) gem, available on [rubygems](https://rubygems.org/gems/gitloc-joshcheek).

Start with [Day1](day1.md).

We're going to make a gem that has a program you can invoke on the commandline.
You'll give it a git repository and it will tell you how many non-blank lines
are in each file, as well as the total for the whole repository.

We'll cover:

* Working with gems
  * What libraries and gems are
  * The structure of the .gem format
  * How to install a gem you are building
  * How to version a gem
  * How to publish a gem
* How to make an executable
  * Where it goes, what it does
  * The `$PATH`
  * File permissions
  * Shebangs
  * The `$LOAD_PATH`
  * How to get command line arguments
  * How to print output and errors
* How to make the code
  * Where it goes
  * Load path namespacing
  * Constant namespacing
  * Mapping class names to file locations
* Test Driving our gem
  * Start with an acceptance/integration test
    * to give us confidence that we haven't broken anything
    * and flexibility to iterate and make changes
  * Using fixtures
  * Dropping down to unit tests
    * to get feedback about our design
    * to make it easy to verify features do what we expect, with minimal overhead
    * the thought process of writing tests
  * Our testing will follow what's I do in reality.
    I treat all religions with iconoclasm, TDD is no exception --
    we will test our code this way because it is incredibly effective,
    not because someone will shame us if we don't.

You will need to be comfortable working with basic Ruby classes like
arrays, enumerables, and strings -- I don't want our time to be eaten up
tripping over Ruby.

------

Cheatsheet
==========

File structure of a gem.
------------------------

This structure and naming isn't mandated, but it's the conventions that almost everyone follows.


```
.
├── License.txt                # some projects put their license in a separate file like this, I usually put it in the readme
├── Gemfile                    # where you tell bundler what gems you depend on to make sure the gems you use are loaded and not conflicting
├── Gemfile.lock               # bundler's cache of which gems depend on which, what ones it chose for your lib, and where it found them
├── Rakefile                   # a lot of people put scripts here, usually the default task runs the test suite
├── Readme.md                  # explanation of your lib, license goes here or in a License.txt
├── bin                        # any executables
│   └── gitloc                 # an executable program (run it from the commandline)
├── gitloc-joshcheek-0.2.0.gem # the gem you publish and install, built from the gemspec
├── gitloc.gemspec             # where you tell Rubygems how to package your code
├── lib                        # the project's ruby code
│   ├── gitloc                 # code is kept under a directory named after the project
│   │   ├── binary.rb          # code to perform the tasks of bin/gitloc, if needs multiple files, they would go in lib/gitloc/binary/filename.rb
│   │   ├── errors.rb          # I put all my errors in one file so you can see everything that could be raised
│   │   ├── line_counts.rb     # a class used by the library
│   │   └── version.rb         # commonly, the version will get its own file, so you can say `require 'gitloc/version'`
│   └── gitloc.rb              # entry point is named after the project so you can say `require 'gitloc'`
└── spec                       # your tests go here (if using Minitest::Test, place this dir would be called `test`) with rspec, the test filenames are suffixed with `_spec.rb`
    ├── acceptance_spec.rb     # high-level black box tests that capture whether the lib actually does complete the features we want from it
    ├── fixtures               # data to be operated on for tests
    │   └── 2loc               # in this case, a file with a known line count that we can assert is in the output
    ├── gitloc_spec.rb         # tests on the toplevel of our library (lib/gitloc.rb)
    └── line_counts_spec.rb    # tests on one of our library's classes lib/gitloc/line_counts.rb)

5 directories, 15 files

```

Bootstrapping a new gem
-----------------------

First make the directory and files.

```sh
# make the dir
$ mkdir gitloc
$ cd gitloc

# make a readme with the name, description, and license (example below)
$ atom Readme.md

# Make our executable program
$ mkdir bin
$ touch bin/gitloc
$ chmod +x bin/gitloc  # set its permissions to allow it to be executed.
$ echo '#!/usr/bin/env ruby' > bin/gitloc  # write this line to the file
$ echo 'puts "hello, world"' >> bin/gitloc # append this line to the file
```

Initial readme

```markdown
Gitloc
======

Takes a git url, prints out information about how many lines of code it has.

[MIT License](http://opensource.org/licenses/MIT)
-------------------------------------------------

The MIT License (MIT)

Copyright (c) 2015 Josh Cheek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

Permissions and making a program executable

```sh
# see permissions
$ ls -l bin
total 0
-rw-r--r--  1 josh  staff  0 Feb  9 11:01 gitloc

# Breaks down like this
#     | ----- OWNER ------ | ----- GROUP ------ | ----- OTHERS -----
# IDK | Read Write eXecute | Read Write eXecute | Read Write eXecute
# -   | r    w     -       | r    -     -       | r    -     -

# make it executable
$ chmod +x bin/loc

# check that it's now executable
$ ls -l bin
total 0
-rwxr-xr-x  1 josh  staff  0 Feb  9 11:01 gitloc
```

Use a shebang to tell the Operating system to execute the binary with Ruby

```ruby
#!/usr/bin/env ruby
puts "Hello, world!"
```

Getting the full path to a file (do this so the path doesn't change if you run the code from different directories)

```
# what is my working directory?
Dir.pwd   # => "/Users/josh/Desktop"

# what is my current file?
__FILE__  # => "/Users/josh/Desktop/example.rb"

# Get an absolute path to a file in the same directory as my current directory
File.expand_path 'file.rb', __FILE__     # => "/Users/josh/Desktop/example.rb/file.rb"
File.expand_path '../file.rb', __FILE__  # => "/Users/josh/Desktop/file.rb"
```

Commandline arguments are stored in `ARGV`

```sh
$ ruby -e 'p ARGV' here be the arguments
["here", "be", "the", "arguments"]
```

Executing programs from Ruby with [Open3](http://www.rubydoc.info/stdlib/open3/Open3)
(it's in the stdlib)

```ruby
require 'open3'

code = '
  $stdout.puts ARGV.inspect     # stdout
  $stderr.puts "with zombocom"  # stderr
  exit 12
'

# we can run the program and get its stdout and stderr
stdout, stderr, exitstatus = Open3.capture3 'ruby', '-e', code, 'you', 'can', 'do', 'anything'
stdout                 # => "[\"you\", \"can\", \"do\", \"anything\"]\n"
stderr                 # => "with zombocom\n"
exitstatus             # => #<Process::Status: pid 13414 exit 12>
exitstatus.exitstatus  # => 12
exitstatus.success?    # => false
```

Get a list of files and directories.

```ruby
# these will all be relative to our working directory
Dir.pwd      # => "/Users/josh/deleteme/gem2/gitloc"

# splat matches all files in this directory
Dir['*']     # => ["bin", "example.rb", "Readme.md", "spec"]

# here, we're saying 'match anything, followed by a slash, followed by anything'
Dir['*/*']   # => ["bin/gitloc", "spec/acceptance_spec.rb", "spec/fixtures"]

# if we use two asterisks, it will match recursively
# so this is anything in any directory below my current working directory
# in other words, all files and dirs in the project
Dir['**/*']  # => ["bin", "bin/gitloc", "example.rb", "Readme.md", "spec", "spec/acceptance_spec.rb", "spec/fixtures", "spec/fixtures/2loc"]
```

Make your library into a gem
----------------------------

Relevant files

* `gitloc.gemspec` - tell Rubygems about your code. Docs are [here](http://guides.rubygems.org/specification-reference/).
* `gitloc-joshcheek-0.1.0.gem` the actual gem itself, built from the gemspec and your code. This is what you publish and what others install.

```ruby
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'gitloc/version'

Gem::Specification.new do |s|
  s.name        = 'gitloc-joshcheek'
  s.version     = Gitloc::VERSION
  s.licenses    = ['MIT']
  s.summary     = "Example project -- gives lines-of-code information for a git repo"
  s.description = "Example project for the Turing School of Software and Design, see https://github.com/JoshCheek/elective-building-a-gem -- gives lines-of-code information for a git repo."
  s.authors     = ["Josh Cheek"]
  s.email       = 'josh.cheek@gmail.com'
  s.files       = Dir["**/*"].select { |f| File.file? f } - Dir['*.gem']
  s.homepage    = 'https://github.com/JoshCheek/elective-building-a-gem'
  s.executables << 'gitloc'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'pry'
end
```

Build the gem

```sh
$ gem build gitloc.gemspec
  Successfully built RubyGem
  Name: gitloc-joshcheek
  Version: 0.1.0
  File: gitloc-joshcheek-0.1.0.gem
```

Install the gem locally

```sh
$ gem install gitloc-joshcheek-0.1.0.gem
Successfully installed gitloc-joshcheek-0.1.0
1 gem installed
```

See that it is installed

```sh
$ gem list gitloc

*** LOCAL GEMS ***

gitloc-joshcheek (0.1.0)
```

Publish the gem

```sh
$ gem push gitloc-joshcheek-0.1.0.gem
```

If that fails, sign up for a rubygems account [here](https://rubygems.org/sign_up).
And try again. If you're still having issues, follow along with [this](http://guides.rubygems.org/publishing/#publishing-to-rubygemsorg)
tutorial.

You can see your gem at https://rubygems.org/gems/gitloc-joshcheek
Just change the name to be yours.


Library vs binary
-----------------

`bin` is where your executable goes. `lib` is where your code goes.

Code that will be required by some app or some other gem is called
library code, and goes in `lib`. If your binary has a lot of code
to implement it (eg option parsing, formatting, etc), still put that
in `lib`, but put it under its own directory to keep it separate,
eg `lib/gitloc/binary`


Mapping a constant name to it's file location
---------------------------------------------

These are conventions, not requirements.
So you will find gems that do not follow them,
but they are correct 95% of the time.

If you have a CamelCased constant, that
maps to a `snake_cased` filename. So `SeeingIsBelieving`
would be located in a file `seeing_is_believing.rb`

If you have a `Namespaced::Constant`,
that maps to either a `folder/filename.rb` or
a `gemname-extensionname.rb`

For example, `ActiveRecord::Base` is in a file `active_record/base.rb`

You can find a file that you require by using `gem which`, for example

```sh
$ gem which active_record/base
/Users/josh/.gem/ruby/2.1.1/gems/activerecord-4.2.0/lib/active_record/base.rb
```

Code can be required if its directory is in the `$LOAD_PATH`
------------------------------------------------------------

If you have a file `lib/gitloc.rb`, then you can require it with
`require 'gitloc'`, if `lib` is in the `$LOAD_PATH`.

RSpec will automatically put `lib` in the `$LOAD_PATH` for you.
Your binary needs to explicitly manipulate it with something like

```ruby
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gitloc/binary'
```

Namespacing files and constants
-------------------------------

A namespace is a place to put your stuff where it won't conflict with
other people's things. With Ruby, "things" means files and constants.

If you follow the naming rules, your code will be appropritaely namespaced.
But you want to put your files inside of a directory named after your gem,
this way your version is at `gitloc/version.rb` and doesn't conflict with
`sinatra/version.rb`

You will also want to namespace your constants by putting them in
a class or module named after your gem. So your version would be in
`Gitloc::VERSION`, and would not conflict with Sinatra's at `Sinatra::VERSION`


Semantic Versioning
-------------------

[semantic versioning](http://semver.org/) uses three numbers, separated by
periods to let users know what kinds of changes have occurred.

The current `Rails` is on version [`4.2.0`](https://rubygems.org/gems/rails/versions/4.2.0)

* **4: Major version** -- first number, if it changes, expect breaking changes, and upgrade carefully.
* **2: Minor version** -- second number, if it changes, your code probably still works, and might have access to cool new features.
* **0: Patch version** -- third number, if it changes, your code should still work, and you'll have bugfixes.

Pre 1.0 releases are not expected to follow these rules, they're given additional leeway
as their interface is likely volatile. Specifically, we usually just drop each number back by one,
So, breaking changes would bump minor instead of major.

But once it has released a `1.0.0`, it is expected to adhere to semantic versioning.


Bundler
-------

Bundler ensures our gems are compatible and that we load the correct ones at runtime.
You can tell it to use the gems from your gemspec with

```ruby
source 'https://rubygems.org'
gemspec
```

You lock down the environment at runtime with `bundle exec program`.
So to run `rspec` and ensure you can only use the gems you specified,
you would say `bundle exec rspec`.

Bundler stores the specific versions it has selected in `Gemfile.lock`


Default RSpec options
---------------------

If you want to always use RSpec options, you can set them in
your project root's `.rspec` file. If you don't have one, you
can make one. I turned on colour and the `format` output with
a `.rspec` file containing

```
--colour
--format documentation
```

Structuring your code
---------------------

The most important thing for structuring your code is to keep
the dependencies as early in the callstack as possible.

So your binary, which talks to `ARGV`, `$stdout`, and `$stderr`,
will pull these up into binary specific code so that the library
doesn't have to deal with them.

The difficult dependencies of git, invoking other programs,
making tempdirs, reading from the filesystem, are pulled out
away from the rest of the code as soon as they start to interfere
with our ability to test it. This allows us to do things like test
the line counting code without dealing with git repos and the file system.

Testing our code
----------------

In general, err on the side of testing at too high a level (early in the callstack,
with lots of dependencies being dealt with), as this is
typically easier to recover from, and won't lock you into a crappy implementation.
You will know you need to test lower,
at a more unit-level when you experience pain like this:

* test is not helpful for figuring out what is wrong
* repeatedly testing the same idea because it is a low-level class used by multiple different codepaths
* having to do a lot of setup to test one small thing
* slow test suites because too many tests have to deal with the world

Conversely, you can test at too low of a level.
You do not need to have unit tests on every class,
if you are not confident in it, don't test it directly, instead test
it by testing the code that uses it.
You will know you need to test higher, at a more integration-level
when you experience pain like this:

* You cannot change implementation details without breaking your tests
* You frequently need to change the way several classes talk to each other
  They belong together, and the lower classes are implementation details of the
  higher classes, so test at the highest interface of these classes.
  If they all have public interface, then your dependencies are wrong,
  if class `A` uses class `B`, then `B` should know nothing of `A`.
* Your tests don't give you confidence that your code works.
* Your code breaks even though your tests pass.


All errors inherit from one class
---------------------------------

Do this so that someone can rescue the parent error if they want
to rescue everything your library could raise.
For example, [all errors](https://github.com/JoshCheek/seeing_is_believing/blob/267b9e8f5a8cdff268658376bb10670de102c58f/lib/seeing_is_believing/error.rb)
in `SeeingIsBelieving` inherit from `SeeingIsBelieving::SeeingIsBelievingError`.


Debugging
---------

When your code blows up and you don't know why, put a `begin/rescue/end`
around it, and drop a `binding.pry` in the rescue portion.
This way you can poke around and figure out what is going wrong.

ie "what string caused the regex to blow up?" and
"what file did that string come from?" and so forth.


Dissecting a `.gem`
-------------------

You can get a `.gem` file with `gem fetch seeing_is_believing`

A gem is just a `tar` file, so you can get its contents with
`tar -xf seeing_is_believing-2.2.0.gem`

To see an example that explores all the files within there,
see [this](https://github.com/JoshCheek/tweeter-client-whatevz/blob/8cf5563d1818c682d0fd5ef10de956e0f506b725/Readme.md)
readme.
