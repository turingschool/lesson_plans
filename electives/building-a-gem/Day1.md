Working with gems - Day 1
=========================

What is a library? What is a gem?
---------------------------------

A library is a set of code that solves some generic problem.
You will load them up and use them in a specific way to solve
your specific problem.

For example, Ruby comes with a set of libraries you can load up,
called the "standard libraries", or "stdlib". There are libraries
in there that do things like [CSV](http://www.rubydoc.info/stdlib/csv)
parsing and [JSON](http://www.rubydoc.info/stdlib/json) parsing.

Some libraries don't come with Ruby. Instead, we get them from rubygems.
Because of this, we call them "gems". Gems are just libraries that come
from Rubygems.

What about code like "Array", is that a library? We typically differentiate
that from a library by calling it "core", because it comes with the language,
loaded up and always available.

Our gem: gitloc
---------------

We will make a gem that takes the locaiotn of a git repository
and tells us how many lines of code it has. First, lets set up the structure.
We'll need a directory with a Readme in it.

```
$ mkdir gitloc
$ cd gitloc
$ atom Readme.md
```

Edit the readme to include your gem name, brief description, and license:

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

Now commit it

```sh
$ git init
$ git status
$ git add Readme.md
$ git status
$ git commit -m 'Add readme and MIT license'
$ git status
```

Making a binary
---------------

Executable programs are often called binary, because they used to
contain code that was compiled into machine instructions, read by
the computer as 1s and 0s. That's not still true, but hey, history.

```sh
# Make our executable program
$ mkdir bin
$ touch bin/gitloc
```

Fixing permissions
------------------

Now, if you try to run this, you'll see it won't let you

```sh
$ bin/gitloc
bash: bin/gitloc: Permission denied
```

What are its permissions?

```sh
$ ls -l bin
total 0
-rw-r--r--  1 josh  staff  0 Feb  9 11:01 gitloc

$ chmod +x bin/loc

$ ls -l bin
total 0
-rwxr-xr-x  1 josh  staff  0 Feb  9 11:01 gitloc
```

See thhat `-rw-r--r--`? it breaks down like this:

```
    | ----- OWNER ------ | ----- GROUP ------ | ----- OTHERS -----
IDK | Read Write eXecute | Read Write eXecute | Read Write eXecute
-   | r    w     -       | r    -     -       | r    -     -
```

We'll ignore group for now. So looking at owner, it means that you
can read that file and write to it, and everyone else can only read it.
After changing the permissions (see `man chmod` for more details),
we see that we have added executable permissions for everyone.

```sh
$ bin/gitloc # no error
```

Executing the binary with Ruby
------------------------------

So, since we're saying `bin/gitloc` instead of `ruby bin/gitloc`,
how do we tell the operating system to run the program with Ruby?
We use a "shebang"

```ruby
#!/usr/bin/env ruby
puts "Hello, world!"
```

And check it:

```sh
$ bin/gitloc
Hello, world!
```

We have to do the `env` thing, because the location of the ruby
executable will likely be different on every machine, but the
location of `env` is consistently at `/usr/bin/env`.

Env will uses an environment variable called `PATH`,
which is a list of directories. It will go through each
directory, in order, until it finds Ruby, then finally
execute our file with that ruby.

```sh
# see all environment variables
$ env
... lots of output ...

# see the path
$ env | grep PATH
PATH=/usr/local/heroku/bin:...

# make it more readable
$ env | grep PATH | tr : \\n
PATH=/usr/local/heroku/bin
/Users/josh/.gem/ruby/2.1.1/bin
/Users/josh/.rubies/ruby-2.1.1/lib/ruby/gems/2.1.0/bin
/Users/josh/.rubies/ruby-2.1.1/bin
...

# where is our Ruby? Notice its directory is in the PATH
$ which ruby
/Users/josh/.rubies/ruby-2.1.1/bin/ruby

# execute that Ruby with env
$ /usr/bin/env ruby -v
ruby 2.1.1p76 (2014-02-24 revision 45161) [x86_64-darwin13.0]
```

And lets commit this

```sh
$ git status
$ git add bin
$ git status
$ git commit -m 'Make a binary'
$ git status
```

Start a project with an acceptance test
---------------------------------------

When I start a project, I never know how it's going to go.
I give myself direction and flexibility by creating an "acceptance test".
This is a high-level test that treats the program as a black-box
and just asserts that it does something useful.

Because it's a black box, it doesn't know about the internals,
so I can refactor as much as I like without breaking it.

But, because it's so high level, it's not good for really getting in close
and making sure specific pieces of the code work. It will also be very
expensive (take a lot of time), so we typically have few of these,
and verify the code itself with unit tests.

```sh
# make the directory (you can name yours "test" if you want to use minitest)
$ mkdir spec
$ atom spec/acceptance_spec.rb
```

Currently, our code is entirely in the binary, how can we test that?
We'll do it by invoking the binary directly, and looking at its exitstatus
(the thing that tells us whether it succeeded) and what it printed.

```sh
require 'open3' # we'll use this to invoke the binary

RSpec.describe 'gitloc binary' do
  let(:binpath)  { File.expand_path '../../bin/gitloc', __FILE__ }
  let(:repopath) { File.expand_path '../..',            __FILE__ }

  it 'takes a git repository and tells me how many lines of code are in each file' do
    stdout, stderr, exitstatus = Open3.capture3(binpath, repopath)
    expect(stdout).to match /2.*?spec\/fixtures\/2loc/
    expect(exitstatus).to be_success
  end
end
```

Notice that I make very few assertions here. There's a ton of ways this can fail,
since I'm giving it the source of this repository directly, all the numbers are going
to be constantly changing. I'm just looking through it saying "there's a line in there somewhere,
that has the number 2, followed by whatever, followed by the path to `spec/fixtures/2loc`

We need to make that file, then:

```sh
$ mkdir spec/fixtures

$ echo -e 1\\n2
1
2

$ echo -e 1\\n2 > spec/fixtures/2loc

$ cat spec/fixtures/2loc
1
2
```

And commit it

```sh
$ git status
$ git add spec
$ git status
$ git commit -m 'Add an acceptance spec and fixture'
$ git status
```

Understanding `File.expand_path`
--------------------------------

Lets take a quick detour to see how these work

```ruby
# what is my working directory?
Dir.pwd  # => "/Users/josh/Desktop"

# what is my current file?
__FILE__  # => "/Users/josh/Desktop/example.rb"

# my working directory can change
Dir.chdir ".."  # => 0
Dir.pwd         # => "/Users/josh"

# if we don't provide the file, it will expand based on our working directory
File.expand_path 'file.rb'  # => "/Users/josh/file.rb"
Dir.chdir '..'              # => 0
File.expand_path 'file.rb'  # => "/Users/file.rb"
Dir.chdir '..'              # => 0
File.expand_path 'file.rb'  # => "/file.rb"

# no bueno, but my file is always in the same place
__FILE__  # => "/Users/josh/Desktop/example.rb"

# so get an absolute path based on the file
File.expand_path 'file.rb', __FILE__  # => "/Users/josh/Desktop/example.rb/file.rb"

# but need to back up to get to the file's directory
File.expand_path '../file.rb', __FILE__  # => "/Users/josh/Desktop/file.rb"
```

Understanding Open3
-------------------

And now, how about open3? It comes from the stdlib, like CSV,
so we don't have to install a gem to use it.

```ruby
require 'open3'

# we can run the program and get its stdout and stderr
stdout, stderr, exitstatus = Open3.capture3 'ruby', '-e', '
  $stdout.puts "hello"
  $stderr.puts "goodbye"
'
stdout     # => "hello\n"
stderr     # => "goodbye\n"
exitstatus # => #<Process::Status: pid 11855 exit 0>

# an exit status of 0 means it succeeded
stdout, stderr, exitstatus = Open3.capture3 'ruby', '-e', 'exit 0'
exitstatus.exitstatus # => 0
exitstatus.success?   # => true

# an exit status of nonzero means it failed
stdout, stderr, exitstatus = Open3.capture3 'ruby', '-e', 'exit 12'
exitstatus.exitstatus # => 12
exitstatus.success?   # => false
```

Running our test
----------------

```sh
$ rspec --color
F

Failures:

  1) gitloc binary takes a git repository and tells me how many lines of code are in each file
     Failure/Error: expect(stdout.lines).to match /2.*?spec\/fixtures\/2loc/
       expected ["Hello, world!\n"] to match /2.*?spec\/fixtures\/2loc/
       Diff:
       @@ -1,2 +1,2 @@
       -/2.*?spec\/fixtures\/2loc/
       +["Hello, world!\n"]

     # ./spec/acceptance_spec.rb:9:in `block (2 levels) in <top (required)>'

Finished in 0.04057 seconds (files took 0.1237 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/acceptance_spec.rb:7 # gitloc binary takes a git repository and tells me how many lines of code are in each file
```

Accessing commandline arguments
-------------------------------

When we run a program like `ruby myfile.rb`, how does it access the filename?
Our program is going to need to do this, because we'll say something like
`bin/gitloc https://github.com/turingschool/electives`

Ruby gives an array called `ARGV` which contains the arguments.

```sh
$ ruby -e 'p ARGV' here be the arguments
["here", "be", "the", "arguments"]
```

Using glob patterns to get a list of all files
----------------------------------------------

We'll need a list of all the files so that we can count
how many lines of code they have. We can do that using
`Dir[...]` and placing a glob pattern in the brackets.

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

Implement the code
------------------

So, I got rid of the "Hello, world!" line, and replaced it with some quick
and dirty code to get my acceptance test passing.
I'm not trying to make my code good here, I'm trying to get something
that works, which I can iterate on.

```ruby
#!/usr/bin/env ruby

require 'tmpdir'
require 'open3'

repo = ARGV.first

Dir.mktmpdir { |dir|
  Dir.chdir dir
  out, err, status = Open3.capture3 'git', 'clone', repo, 'cloned'
  unless status.success?
    $stderr.puts out, err
    exit "Failed somehow >.<"
  end
  Dir.chdir 'cloned'
  files = Dir['**/*'].reject { |name| File.directory? name }
  files.each do |filename|
    loc = File.readlines(filename).count { |line| line !~ /^\s*$/ }
    puts "#{loc}\t#{filename}"
  end
}
```

When I do these code dumps to a big acceptance test,
I will explicitly check for errors that I haven't tested for.
This is because our test is so high and abstract that it's hard
to get good information from it beyond "yep, it works".
So in places where it might reasonably error, I try to make it
die immediately with a message, that way I'm not in a situation
where it's printing nothing, and I have to go debug it.
When we get to lower level tests, we'll directly check for this situation.

And now, if we test it, we should be passing:

```sh
$ rspec --color
.

Finished in 0.08295 seconds (files took 0.13271 seconds to load)
1 example, 0 failures
```

So commit it

```sh
$ git status
$ git add bin/loc
$ git status
$ git commit -m 'Implement code in binary'
$ git status
```

In future classes, we'll cover:

* How to version and what you can learn from a gem's version.
* How to tell Rubygems how to interpret our gem
* Turning our library into a gem
* Installing the gem locally
* We'll publish our gem to rubygems
* We'll disect gitloc.gem, seeing what all is in there and how its structured
* How ruby finds code (why does `require` and the `$LOAD_PATH` work?)
* How to structure our code (how and why to namespace files and constants)
* How and why to refactor the code out of bin/gitloc into lib/gitloc.rb
* And eventually out of there, into other abstractions.
* We'll test drive this with unit tests, paying attention to any difficulties
  and instead of frustratedly implementing more painful tests, we'll analyze
  why it's difficult, and figure out how to fix our design, which will result
  in it becoming much easier to test.
* We'll update our versions and push the gems as we get them done, following semantic versioning.
