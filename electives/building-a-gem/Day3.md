Working with gems - Day 3
=========================

Recap of progress so far

```
Day 1
  bootstrapping
    make the directory
    make readme w/ name, description, license
    track our work in source control

  make binary
    make it executable (fix permissions)
    use shebang to tell it to run with Ruby
    see how env works
    see how PATH works

  start with acceptance test
    high-level black-box "it does something I find useful"
    gives us confidence it works while allowing us to make changes that won't break
    because when you start a project, you don't know how it will wind up
    ours invokes the binary using open3 and running against a fixture file
    open3 allows us to run programs
    we can capture standard output
    and standard error
    and exit status
    we use `File.expand_path` to get an absolute path to the file

  then make the implementation
    take the repo to run from ARGV (commandline arguments)
    use Open3 to run git
    do this in a tempfile so that we don't leave files littering our computer
    use `Dir['*/*']` to get the list of all files
    use `File.readlines` to get the counts for that file
    check for errors we haven't tested, b/c our test provides poor feedback

Day 2
  make it a gem by adding a gemspec
  create the gem
    gem build gitloc.gemspec
    gem install gitloc-joshcheek-0.1.0.gem
  publish to rubygems
    gem push gitloc-joshcheek-0.1.0.gem
  move code into lib
    copy paste implementation
    identify dependencies and inject them (ARGV, $stdout, $stderr)
  have the bin fix the $LOAD_PATH
    $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
  namespacing
    lib/gitloc/version.rb so require doesn't collide
    Gitloc::VERSION       so constants don't collide
```

Last time, we had to skip the discussion about how versions work,
but we made our version 0.1.1 Lets discuss why this is.

Versioning Gems
---------------

Versions, how do they work? And I don't wanna talk to a rubyist... Y'all motherfuckers lying,
and getting me pissed.

In the Ruby community, we try to follow what is called [semantic versioning](http://semver.org/).
This means that our users can derive useful information purely based on the version number.

It basically amounts to the idea that you have three numbers, called the "major", "minor", and "patch" number.

* **Major version** -- first number, if it changes, expect breaking changes, and upgrade carefully.
* **Minor version** -- second number, if it changes, your code probably still works, and might have access to cool new features.
* **Patch version** -- third number, if it changes, your code should still work, and you'll have bugfixes.

Lets look at the [versions of Seeing Is Believing](https://rubygems.org/gems/seeing_is_believing/versions).

```
3.0.0.beta.1 - September 23, 2014 (372 KB)
2.2.0 - January 5, 2015 (358 KB)
2.1.4 - August 12, 2014 (222 KB)
2.1.3 - June 28, 2014 (218 KB)
```

In the bottom one, the major number is 2, the minor is 1, and the patch is 3.
See how the next one up bumps patch from 3 to 4? That means everything should
still work the same, it's just bug fixes and internal tweaks. Between 2.1.4
and 2.2.0, the minor has incremented, which means there is new functionality,
but it should still work with anything using 2.1.x And then between 2.2.0
and 3.0.0.beta.1, the major number has changed. This means all bets are off,
I can change anything I want, users can't assume that their code that works
with 2.x.x will work with 3.x.x

The beta there just means it's all still in a "pending" status, and shouldn't
be assumed stable. This allows me to get the code out there, but still
make breaking changes.

Pre 1.0.0 versions
------------------

Now, we're so early in the stages of our development, that we have incredible volatility in
the structure of our code. This means every release would have to bump the major version,
rendering the versioning useless. Or, we couldn't make the changes we need.

In this case, we keep our number below `1.0.0`, we basically treat the minor as if
it were the major, and the patch as if it were the minor. This lets people know that
they need to be careful if using our code, it's still highly volatile.

When we're ready to commit to our interface, we will release the `1.0.0` of our gem,
which lets any users know that they can now expect semantic versioning,
and they can build to that interface without worrying about us changing the library
and breaking their code all the time.


Fixing the gemspec
------------------

When I try building my gem, it tells me `gitloc-joshcheek-0.1.1 contains itself (gitloc-joshcheek-0.1.1.gem), check your files list`
That's because my `.gem` files are getting added by

```ruby
s.files = Dir["**/*"].select { |f| File.file? f }
```

Lets fix this by making that line say

```ruby
s.files = Dir["**/*"].select { |f| File.file? f } - Dir['*.gem']
```

This will remove any `.gem` files from the manifest.
We can check that it works by running `gem build gitloc.gemspec` twice.

And commit it.

```sh
$ git status
$ git diff gitloc.gemspec
$ git add gitloc.gemspec
$ git status
$ git commit -m 'Exclude .gem files from the manifest'
$ git status
```


Adding Bundler
--------------

Bundler is a gem that helps you deal with your gem dependencies.
It will lock down your environment to just the gems you specified
so that you can know the ones required are correct.

It does many things, but the two we're primarily interested in are

* Looking at version constraints and identifying which versions of each gem are most recent and also compatible with the requirements
* Locking down your environment so that it only uses the versions that you've specified
* Installing the correct versions for you

In something like a Rails app, you will specify each dependency in the Gemfile.
But if someone installs our gem, we want them to have all of our dependencies, as well.
To make that work, we speecify them in the gemspec.
To be able to use Bundler without having to maintain two lists of dependencies,
we can tell Bundler to pull our dependencies from the gemspec.
We do this by making a `Gemfile`:

```ruby
source 'https://rubygems.org'
gemspec
```

And we tell Bundler to identify the valid versions of our gems with `bundle`,
which resolves the dependencies and puts its findings in `Gemfile.lock`

```sh
$ bundle
Fetching gem metadata from https://rubygems.org/.
Resolving dependencies...
Using gitloc-joshcheek 0.1.1 from source at .
Using bundler 1.7.12
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
```

Now, we can try our test with just the gems we've declared we depend on
by executing `rspec` within the bundler environment.

```sh
$ bundle exec rspec
/Users/josh/.gem/ruby/2.1.1/gems/bundler-1.7.12/lib/bundler/rubygems_integration.rb:256:in `block in replace_gem': rspec-core is not part of the bundle. Add it to Gemfile. (Gem::LoadError)
  from /Users/josh/.gem/ruby/2.1.1/bin/rspec:22:in `<main>'
```

Hmm, looks like we need to fix that.


Declaring development dependencies
----------------------------------

We tell Rubygems about our dependencies with
[add_development_dependency](http://guides.rubygems.org/specification-reference/#add_development_dependency)
and [add_runtime_dependency](http://guides.rubygems.org/specification-reference/#add_runtime_dependency).

In our case, `RSpec` is just being used for testing,
it doesn't need to be around at runtime, so we'll add it as a dev dep
in our `gitloc.gemspec`

```ruby
# ...omitted...
  s.executables << 'gitloc'
  s.add_development_dependency 'rspec', '~> 3.0'
end
```

The `~>` means that the last digit in the version is allowed to increase.
So we're accepting accept any versions of RSpec that are greater than version 3.0
and less than version 4.0. Why is this? Think about what the version numbers mean.

Since we changed our dependencies, we need to tell Bundler to re-resolve them:

```sh
$ bundle
Resolving dependencies...
Using diff-lcs 1.2.5
Using gitloc-joshcheek 0.1.1 from source at .
Using rspec-support 3.2.1
Using rspec-core 3.2.0
Using rspec-expectations 3.2.0
Using rspec-mocks 3.2.0
Using rspec 3.2.0
Using bundler 1.7.12
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
```

And now we can try again:

```sh
$ bundle exec rspec --colour
.

Finished in 0.09318 seconds (files took 0.12633 seconds to load)
1 example, 0 failures
```

Nice, lets commit.

```sh
$ git status
$ git diff
$ git add gitloc.gemspec
$ git commit -m 'Add RSpec as a development dependency'

$ git status
$ git add .
$ git status
$ git commit -m 'Add Bundler'
$ git status
```

RSpec options
-------------

We keep having to specify `--colour` for RSpec.
Turns out we can put our flags in a file `.rspec`
Here are the ones I like:

```
--colour
--format documentation
```

And now if we run it, we have colour and we can see the names
of our specs.

```sh
$ bundle exec rspec
gitloc binary
  takes a git repository and tells me how many lines of code are in each file

Finished in 0.0946 seconds (files took 0.1891 seconds to load)
1 example, 0 failures
```

```sh
$ git status
$ git add .rspec
$ git commit -m 'Add default options for RSpec

--colour to turn on coloured output
--format documentation to see the full spec names'
$ git status
```


A better library
----------------

So our infrastructure is coming along nicely,
but our library is still pretty messy.

If someone wanted to use it right now, they'd have to pass us
fake command-line arguments and streams.
It also blows up on some files that aren't line-based,
pictures, for example.

Lets first fix the interface.
We want to split out code that is written to support the binary
from code that is written for general purpose code.
This will all go in `lib`, but we'll understand that some portions
are really there to implement the `bin`

Extracting binary code
----------------------

Lets make a file `lib/gitloc/binary.rb` to perform the binary's job.
We put it there to make sure it is file namespaced.

We'll have to come up with an interface for the library.
We can maintain the current functionality if it gives us back an array of files with their linecounts.
That will probably have to change, but this will allow me to pull the two ideas apart right now.

```ruby
require 'gitloc'

class Gitloc
  class Binary
    def self.call(argv, outstream, errstream)
      repo = argv.first
      files_to_lines = Gitloc.call(repo)
      files_to_lines.each do |filename, loc|
        outstream.puts "#{loc}\t#{filename}"
      end
    end
  end
end
```

And our library code will need to change, too

```ruby
require 'tmpdir'
require 'open3'

require 'gitloc/version'

class Gitloc
  def self.call(repo)
    Dir.mktmpdir { |dir|
      Dir.chdir dir
      out, err, status = Open3.capture3 'git', 'clone', repo, 'cloned'
      unless status.success?
        errstream.puts out, err
        exit "Failed somehow >.<"
      end
      Dir.chdir 'cloned'
      files = Dir['**/*'].reject { |name| File.directory? name }
      files.map do |filename|
        loc = File.readlines(filename).count { |line| line !~ /^\s*$/ }
        [filename, loc]
      end
    }
  end
end
```

Hmm, that error check is problematic, it should be up in the Binary!
But it won't know that information until it tries to clone the repo,
which is part of the library... Probably it should raise an error,
except nothing is testing this code right now, because it's hard to test
at the binary level. We'll leave it and fix our test afterwards.

And our `bin` needs to change to call our new binary.

```ruby
#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gitloc/binary'
Gitloc::Binary.call(ARGV, $stdout, $stderr)
```

Test and commit

```sh
$ bundle exec rspec

gitloc binary
  takes a git repository and tells me how many lines of code are in each file

Finished in 0.41049 seconds (files took 0.07477 seconds to load)
1 example, 0 failures

$ git status
$ git diff bin
$ git add bin

$ git status
$ git diff lib
$ git add lib

$ git status
$ git commit -m 'Extract binary code out of lib code'
$ git status
```

Questions!
----------

**If we wanted to provide more sophisticated options,
like allowing a user to say `gitloc --exclude test some-git-repo`,
where would the code for this go?**

Since this is being passed on the commandline,
it will come in as part of `ARGV`, so we'll need to parse
it out of there. `ARGV` is a responsibility of the binary,
so that parsing code will go in the binary. It might wind up
needing more files, in which case, we might put it in
`lib/gitloc/binary/parse.rb` and name it `Gitloc::Binary::Parse`

But once we know we want to exclude the test,
that is a responsiblity of the library.
Remember, the library is the one doing all the generally useful work,
and the binary is just presenting a nice command-line interface to it.
So we would to add a way to tell the library that we want to exclude
some files, and then we would need to add that behaviour to the library.


**If we wanted to sort the output by number of lines of code,
where would that go?**

It's not entirely clear. If this is something you consider to be
a feature of the gem, then it would go in the library so everyone could use it.
But if you consider it to be a nuance of how the binary prints the results,
then it would go in the binary.


Testing rule of thumb
---------------------

The higher up your code is, the more volatile it is.
This is because it depends on more pieces below it.
You can see we moved our entire implementation from bin into lib,
and then split it in half and moved half into `lib/gitloc/binary.rb`

If we had very focused unit tests, we'd have to go rework them every
time we did something like this. **Our tests would be a hindrance**,
preventing us from making changes!

So the less confident you are, the higher up you want to test,
This way, more of these changes are seen as implementation details,
and you can fling the code around like Jackson Pollock with a paintbrush.

But if you're testing at a high level

* you don't get very good feedback because something at the bottom might fail, but you have several layers between that failure and your test.
* you have to set up a lot more of the world to run the test
* your tests will take longer
* you might wind up repeating lots of test (eg two different paths to the same class, you have to test each to be confident, because what if you change it and it no longer goes through that class?)
* you don't get good feedback about your design (this primarily comes in the form of test pain)

So, I try to err in favour of being too high.
But as soon as I find myself annoyed by how hard it is to write this test,
I go down to a lower level, maybe testing an object directly,
or maybe testing a group of objects that work together,
seeing the underlying classes as details I don't want to test as they may change.

If you're constantly fixing your tests as your implementation changes,
you're testing too low.

If you're repeating tests or they're taking forever, you're testing too high.
If you're testing at a low level and you're still setting up the world,
then your dependencies are wrong, you need to push them up higher in the callstack
as we have done with our arguments and streams, or possibly wrap them in a class
whose job is to present a nice interface to the details, and who could be replaced
with a mock object (we might reasonably wind up doing this with our call to `git clone`
if we were to keep building our gem out)


All your errors should inherit from one class
---------------------------------------------

Your code can blow up, and in this case, you'd raise an error.
Users can rescue those errors, but only if they know what you're
going to raise, or know what it inherits from.

It is nice, then, to have all your errors inherit from one class.
This way a user can say "rescue any gitloc error"

I like to put all my errors in one file so they are easy for users identify.
We'll place them in `lib/gitloc/errors.rb`

```ruby
class Gitloc
  Error = Class.new StandardError
end
```

This means "make a new class which inherits from StandardError",
it's basically the same as `class Error < StandardError; end`,
but more elegant for the one-liner.

And require it in our main `gitloc.rb`

```ruby
require 'gitloc/errors'
require 'gitloc/version'
```


Blowing up when the repo doesn't exist
--------------------------------------

So, lets make the lib blow up when there is no repo to clone.
In `spec/gitloc_spec.rb` write:

```ruby
require 'gitloc'

RSpec.describe Gitloc do
  it 'raises RepoDoesNotExistError when the repo does not exist' do
    expect { Gitloc.call("not-a-repo") }
      .to raise_error Gitloc::RepoDoesNotExistError, /not-a-repo/
  end
end
```

And verify the failure

```sh
$ bundle exec rspec
  ...
  1) Gitloc raises RepoDoesNotExistError when the repo does not exist
     Failure/Error: .to raise_error Gitloc::RepoDoesNotExistError, /not-a-repo/
     NameError:
       uninitialized constant Gitloc::RepoDoesNotExistError
     # ./spec/gitloc_spec.rb:6:in `block (2 levels) in <top (required)>'
  ...
```

No error class, lets go make it:

```ruby
class Gitloc
  Error = Class.new StandardError

  class RepoDoesNotExistError < Error
    def initialize(repo_name)
      super "#{repo_name} does not exist"
    end
  end
end
```

And now we get the error that lets us go fix that broken code.

```sh
$ bundle exec rspec
  ...
  1) Gitloc raises RepoDoesNotExistError when the repo does not exist
     Failure/Error: expect { Gitloc.call("not-a-repo") }
       expected Gitloc::RepoDoesNotExistError with message matching /not-a-repo/, got #<NameError: undefined local variable or method `errstream' for Gitloc:Class> with backtrace:
  ...
```

Which we do like this:

```ruby
# ...
out, err, status = Open3.capture3 'git', 'clone', repo, 'cloned'
raise RepoDoesNotExistError, repo unless status.success?
Dir.chdir 'cloned'
# ...
```

Great! Lets commit.

```ruby
$ git status
$ git diff lib
$ git add lib spec
$ git commit -m 'Raises when repo DNE'
```


Why does it blow up sometimes!
------------------------------

Have you tried running gitloc against a variety of different repos yet?
You may have noticed that it blows up sometimes with an error message
like this:

```
$ bundle exec bin/gitloc https://github.com/JoshCheek/seeing_is_believing.git
/Users/josh/deleteme/gitloc/lib/gitloc.rb:16:in `=~': invalid byte sequence in UTF-8 (ArgumentError)
  from /Users/josh/deleteme/gitloc/lib/gitloc.rb:16:in `!~'
...
```

So we can see it's blowing up in our `lib/gitloc.rb` on line 16.
This is where we have our regex
`loc = File.readlines(filename).count { |line| line !~ /^\s*$/ }`
Lets add `pry` as a development dependency and then pry around that code to see what's going on.

In our `gitloc.gemspec`

```ruby
# ...
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'pry'
end
```

In our `lib/gitloc.rb`

```ruby
files.map do |filename|
  loc = File.readlines(filename).count { |line|
    begin
      line !~ /^\s*$/
    rescue
      require 'pry'
      binding.pry
    end
  }
  [filename, loc]
end
```

And run it again

```ruby
$ bundle exec bin/gitloc https://github.com/JoshCheek/seeing_is_believing.git

From: /Users/josh/deleteme/gitloc/lib/gitloc.rb @ line 21 Gitloc.call:

     8: def self.call(repo)
     9:   Dir.mktmpdir { |dir|
    10:     Dir.chdir dir
    11:     out, err, status = Open3.capture3 'git', 'clone', repo, 'cloned'
    12:     raise RepoDoesNotExistError, repo unless status.success?
    13:     Dir.chdir 'cloned'
    14:     files = Dir['**/*'].reject { |name| File.directory? name }
    15:     files.map do |filename|
    16:       loc = File.readlines(filename).count { |line|
    17:         begin
    18:           line !~ /^\s*$/
    19:         rescue
    20:           require 'pry'
 => 21:           binding.pry
    22:         end
    23:       }
    24:       [filename, loc]
    25:     end
    26:   }
    27: end

[1] pry(Gitloc)>
```

What do we want to look at? We might choose the line to see what's blowing up.

```ruby
[1] pry(Gitloc)> line
=> "GIF89a\u0000\u0002\u0000\u0001\xD5\u0000\u0000\xCD\xCF\xCF\u00135A/IR\x89\x91\u0017\x85\x92\x93rx{\xBA\xBC\xBD\n"

```

Hmm, strange output, and not very informative. what file is this from?

```ruby
[2] pry(Gitloc)> filename
=> "docs/example.gif"
```

Ahhh, it's a `gif`, an image, it's not a text file at all.
So our regex blows up when run against it!
We need to fix this. But first, lets undo our debugging changes.

```sh
[3] pry(Gitloc)> exit!

$ git diff lib
diff --git a/lib/gitloc.rb b/lib/gitloc.rb
index 34b9c5e..e109132 100644
--- a/lib/gitloc.rb
+++ b/lib/gitloc.rb
@@ -13,7 +13,14 @@ class Gitloc
       Dir.chdir 'cloned'
       files = Dir['**/*'].reject { |name| File.directory? name }
       files.map do |filename|
-        loc = File.readlines(filename).count { |line| line !~ /^\s*$/ }
+        loc = File.readlines(filename).count { |line|
+          begin
+            line !~ /^\s*$/
+          rescue
+            require 'pry'
+            binding.pry
+          end
+        }
         [filename, loc]
       end
     }

$ git checkout -- lib

$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

  modified:   Gemfile.lock
  modified:   gitloc.gemspec

no changes added to commit (use "git add" and/or "git commit -a")
```


The most important design criteria: dependencies
------------------------------------------------

So we've moved our dependencies on `ARGV`, `$stdout`, and `$stderr`
up to the binary, and our library is blissfully ignorant of their existence.
What is the biggest dependency in our library code at this point?

It's that `Open3` call to `git`, the tempfile, and the file reading.
We can't test our code without a repository, filesystem, git and so forth.

For example, to test that it handles images, we need a repository with an image!
That's an awful lot of world to set up just to show that it does what we want.
Lets split the expensive cloning and file reading out from the line counts.

This makes sense, we might want to use `gitloc`'s code to get line counts for
something that isn't a git repository, but right now, we have no ability to do this,
because they're stuck together in our method.

So, we'll first split these out, then we'll test for our example case.

Now, we could move this up into the binary, but remember that the binary is a consumer
of the library. We have to think about what is the proper interface for any given
piece of code that uses our lib. I think most users are going to want to be able
to give us the git repo, so let's maintain that interface.

There's any number of ways we could split this up, but since the thing we want
to test is the line counting code, lets pull that out first.
Later, we might find out we didn't split this right.
But we can't really know until our requirements change and see if it's hard to test this stuff.

```ruby
require 'tmpdir'
require 'open3'

require 'gitloc/errors'
require 'gitloc/version'
require 'gitloc/line_counts'

class Gitloc
  def self.call(repo)
    names_to_bodies = Dir.mktmpdir { |dir|
      Dir.chdir dir
      out, err, status = Open3.capture3 'git', 'clone', repo, 'cloned'
      raise RepoDoesNotExistError, repo unless status.success?
      Dir.chdir 'cloned'
      Dir['**/*'].reject { |name| File.directory? name }
                 .map    { |name| [name, File.read(name) ] }
    }

    LineCounts.call(names_to_bodies)
  end
end
```

And now `lib/gitloc/line_counts.rb` (why did we call it `line_counts` instead of `linecounts`?
Because we named the constant `LineCounts`, so we translate that to the snake case version).

```ruby
class Gitloc
  module LineCounts
    def self.call(names_to_bodies)
      names_to_bodies.map do |name, body|
        loc = body.lines.count { |line| line !~ /^\s*$/ }
        [name, loc]
      end
    end
  end
end
```

Run the tests to see them pass, then commit.

```sh
# make sure everything passes
$ bundle exec rspec

# first we'll add pry
$ git status
$ git diff gitloc.gemspec
$ git add gitloc.gemspec

$ git status
$ git diff Gemfile.lock
$ git add Gemfile.lock

$ git status
$ git commit -m 'Add pry as dev dep'
$ git status

# now we'll add our design changes
$ git status
$ git diff
$ git add .

$ git status
$ git commit -m 'Extraact line counting code into LineCounts'
$ git status
```

Fixing the explosions
---------------------

So, now we can test this line counting code independently
from all the big painful dependencies.

First lets describe what it does / should do in `spec/line_counts_spec.rb`

```ruby
require 'gitloc/line_counts'

RSpec.describe Gitloc::LineCounts do
  it 'returns the counts for each file'
  it 'does not count empty lines'
  it 'omits files of binary data'
end
```

And write the tests for the ones that should currently pass.

```ruby
require 'gitloc/line_counts'

RSpec.describe Gitloc::LineCounts do
  it 'returns the counts for each file' do
    counts = described_class.call([["file1", "l1"],
                                   ["file2", "l1\nl2\nl3"]])
    expect(counts).to eq [["file1", 1], ["file2", 3]]
  end

  it 'does not count empty lines' do
    counts = described_class.call([["file1", ""]])
    expect(counts).to eq [["file1", 0]]

    counts = described_class.call([["file1", "\n"]])
    expect(counts).to eq [["file1", 0]]

    counts = described_class.call([["file1", "\nline1\nline2\n"]])
    expect(counts).to eq [["file1", 2]]
  end

  it 'omits files of binary data'
end
```

Okay, everything passes.
Now, I'm kind of keeping in the back of my mind that I'm not super
confident in this interface, and if it change,s I have to come fix all these tests.
Plus, there's a lot of redundant wiring that makes it harder to see what the test does.
So, I might create test helper methods to abstract this stuff away.

But for now, I'm going to go with this, because it's not that much,
and I'm not totally sure what I want.

So, now we'll take that line we saw in our debugging sessino and make a test for it.

```ruby
  # ...
  it 'omits files of binary data' do
    counts = described_class.call([["keep1", ""],
                                   ["binary", "GIF89a\u0000\u0002\u0000\u0001\xD5\u0000\u0000\xCD\xCF\xCF\u00135A/IR\x89\x91\u0017\x85\x92\x93rx{\xBA\xBC\xBD\n"],
                                   ["keep2", ""]])
    expect(counts).to eq [["keep1", 0], ["keep2", 0]]
  end
  # ...
```

Make sure it fails

```sh
$ bundle exec rspec
# ...
Gitloc::LineCounts
  returns the counts for each file
  does not count empty lines
  omits files of binary data (FAILED - 1)

Failures:

  1) Gitloc::LineCounts omits files of binary data
     Failure/Error: counts = described_class.call([["keep1", ""],
     ArgumentError:
       invalid byte sequence in UTF-8
     # ./lib/gitloc/line_counts.rb:5:in `=~'
     # ./lib/gitloc/line_counts.rb:5:in `!~'
# ...
```

And then go fix it.

```ruby
class Gitloc
  module LineCounts
    def self.call(names_to_bodies)
      names_to_bodies.map { |name, body|
        begin
          loc = body.lines.count { |line| line !~ /^\s*$/ }
          [name, loc]
        rescue ArgumentError
          # no op
        end
      }.compact
    end
  end
end
```

See it pass

```sh
$ bundle exec rspec
```

Add it, but don't commit, in case we fuck it up in the next step.

```sh
$ git status
$ git diff
$ git add .
$ git status
```

And refactor it

```ruby
class Gitloc
  module LineCounts
    def self.call(names_to_bodies)
      names_to_bodies
        .map    { |name, body| [name, count_lines(body)] }
        .select { |name, body| body }
    end

    def self.count_lines(body)
      body.lines.count { |line| line !~ /^\s*$/ }
    rescue ArgumentError
      nil
    end
  end
end
```

Watch it pass, try it against the repo we initially saw the problem on, then commit it.

```sh
$ bundle exec rspec
$ bundle exec bin/gitloc https://github.com/JoshCheek/seeing_is_believing.git
5   bin/seeing_is_believing
64  features/deprecated-flags.feature
86  features/errors.feature
372 features/examples.feature
440 features/flags.feature
426 features/regression.feature
34  features/support/env.rb
326 features/xmpfilter-style.feature
# ...

$ git status
$ git diff lib
$ git add lib
$ git commit -m 'Omit binary files from output'
```

Release a new version
---------------------

So, lets release our code. What version should we go with?

Well, last time we released it, the interface was `Gitloc.call(ARGV, $stdout, $stderr)`,
and now it's `Gitloc.call("repopath")`, so we've broken our public interface.

If we were pats `1.0`, we would need to bump the major version to indicate a breaking change,
but since we're still pre 1.0, we can bump the minor version instead.

```ruby
class Gitloc
  VERSION = '0.2.0'
end
```

```sh
$ bundle
$ git status
$ git diff
$ git add .
$ git commit -m 'Bump version to 0.2.0'
```

And publish it

```sh
$ gem build gitloc.gemspec
$ gem push gitloc-joshcheek-0.2.0.gem
```


Finale! Anatomy of a `.gem` file
---------------------------------

So, we've done some good work,
we got to see lots of different things.
There's obviously a lot more that could be done with this,
we might find out our interface boundaries are wrong and need to refactor,
we might have additional requirements and need to further separate our dependencies.
But for now, this is good.

Lets finish off with a fun exploration to see what's actually in a .gem file!
But what is the .gem? Lets break it open and take a look:

```sh
# lets get a directory to play in
$ mkdir exploring
$ mv gitloc-joshcheek-0.1.0.gem exploring/
$ cd exploring/
$ ls -l
```

A .gem file is just a "tar" file, a bunch of other files grouped into an archive
We can use "-xf" to "extract" from the "file"

```sh
$ tar -xf gitloc-joshcheek-0.1.0.gem
$ ls -l
total 40
-r--r--r--  1 josh  staff   267 Feb 17 11:53 checksums.yaml.gz
-r--r--r--  1 josh  staff  1757 Feb 17 11:53 data.tar.gz
-rw-r--r--  1 josh  staff  6144 Feb 17 11:53 gitloc-joshcheek-0.1.0.gem
-r--r--r--  1 josh  staff   577 Feb 17 11:53 metadata.gz
```

Those `.gz` files stand for "gnu zip", and we can break them apart with the `gunzip` program.
Lets unzip those checksums and make sure our data looks good.
If they didn't match, we wouldn't want to use this code as it might be corrupted or provided by an unknown third party (malware).

```sh
$ gunzip checksums.yaml.gz
$ cat checksums.yaml
---
SHA1:
  metadata.gz: 20ca81628755bc91e5a516999f5f5fbf48689523
  data.tar.gz: 5ed0fed1bd2e4eb414ab19c10aaa0d5590d88eef
SHA512:
  metadata.gz: e60a9369dbafd913a8f65e28c2396927a0fa0651c6ad01941ad36d0323f1f937a90744e6f406935897769689d395f18b0477545b197860406773fe0cd59f56bf
  data.tar.gz: 5e8272824f9ff105a1d7ccf67bdd6c0651d2ed555975063584fe3e6cdce7b0442637a4b89c8f67f1c0a42d0a9b70f664113ade646dd95675fb38651d347d61a9

# we can check that the programs we got match the shas
$ sha1sum metadata.gz
20ca81628755bc91e5a516999f5f5fbf48689523  metadata.gz

$ sha1sum data.tar.gz
5ed0fed1bd2e4eb414ab19c10aaa0d5590d88eef  data.tar.gz

$ shasum5.12  --algorithm 512 metadata.gz
e60a9369dbafd913a8f65e28c2396927a0fa0651c6ad01941ad36d0323f1f937a90744e6f406935897769689d395f18b0477545b197860406773fe0cd59f56bf  metadata.gz

$ shasum5.12 --algorithm 512 data.tar.gz
5e8272824f9ff105a1d7ccf67bdd6c0651d2ed555975063584fe3e6cdce7b0442637a4b89c8f67f1c0a42d0a9b70f664113ade646dd95675fb38651d347d61a9  data.tar.gz
```

What's the metadata? It's a YAML version of our gemspec!
This way Ruby can load the file up and read the information
without executing any of our code on their server
(as our .gemspec is a Ruby file).

```sh
$ gunzip metadata.gz
$ cat metadata
```

And the data? That's all our files.

```sh
$ gunzip data.tar.gz
$ tar -xf data.tar
$ cat bin/gitloc
```

So that's how our gem gets packaged up and sent to Rubygems.
When we do `gem install <somegem>`, it pulls down that .gem file,
extracts it just like we did, probably checks the checksums,
and then moves the code and binaries into the appropriate locations
to make them available to us from within Ruby. Something we can see with:

```sh
$ ruby -rpp -e 'pp Gem::Specification.stubs.find { |s| s.name == "gitloc-joshcheek" }'
#<Gem::StubSpecification:0x007f83b110e190
 @base_dir=nil,
 @data=
  #<Gem::StubSpecification::StubLine:0x007f83b110df88
   @parts=["gitloc-joshcheek", "0.1.0", "ruby", "lib"]>,
 @extension_dir=nil,
 @extensions=[],
 @extensions_dir=nil,
 @full_gem_path=nil,
 @gem_dir=nil,
 @gems_dir=nil,
 @loaded_from=
  "/Users/josh/.gem/ruby/2.1.1/specifications/gitloc-joshcheek-0.1.0.gemspec",
 @name="gitloc-joshcheek",
 @platform="ruby",
 @spec=nil,
 @version=Gem::Version.new("0.1.0")>
```

Lets clean this dissection up.

```sh
$ cd ..
$ git status
$ rm -rf exploring
$ git status
$ git diff gitloc.gemspec
$ git add gitloc.gemspec
$ git status
$ git commit -m 'Gemspec knows about our binary'
```
