Building a Gem
==============

Material for the [Building a Gem](https://github.com/turingschool/electives/blob/master/schedule.markdown#building-a-gem-with-josh-cheek) elective.

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

Anatomy of a gem.
This structure and naming isn't mandated, but it's the conventions that almost everyone follows.


```
.
├── Gemfile     # use bundler to make sure the gems you use are loaded and not conflicting
├── Rakefile    # a lot of people put scripts here, usually the default task runs the test suite
├── Readme.md   # explanation of your lib
├── License.txt # some projects put their license in a separate file, I usually put it in the readme
├── bin         # any executables
│   └── gitloc  # an executable program (run it from the commandline)
├── lib                 # the project's ruby code
│   ├── gitloc          # code is kept under a directory named after the project
│   │   └── version.rb  # commonly, the version will get its own file, so you can say `require 'gitloc/version'`
│   └── gitloc.rb       # entry point is named after the project so you can say `require 'gitloc'`
├── gitloc.gemspec  # configure Rubygems to understand how your code is structured
└── spec            # rspec and minitest/spec tests go here (you might alternatively see a dir named "test")
    ├── fixtures    # helper data for our tests to assert against
    │   └── 2loc    # a fixture, in our case just a file with 2 lines
    └── acceptance_spec.rb  # tests go here and in subdirectories, with rspec, they are suffixed with `_spec.rb`
```

Make a new gem

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
