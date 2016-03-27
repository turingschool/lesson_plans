Working with gems - Day 2
=========================

Lets do a quick recap over what we covered last time:

```
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
```

Make it a gem with a gemspec
----------------------------

Now, our program currently works,
so lets go ahead and actually make it a gem.

To be a gem, we only need 1 thing: A "gemspec" file that tells
Rubygems how to interpret our code.
[Here](http://guides.rubygems.org/specification-reference/)
is a great resource, it tells you all the things you can put in a gemspec
and has an example file. Lets start with their example file.

Make `gitloc.gemspec` and paste their example into there.
Now, we need to go through it and update the values.

```ruby
# update to match your information, not mine :)
Gem::Specification.new do |s|
  s.name        = 'gitloc-joshcheek'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "Example project -- gives lines-of-code information for a git repo"
  s.description = "Example project for the Turing School of Software and Design, see https://github.com/JoshCheek/elective-building-a-gem -- gives lines-of-code information for a git repo."
  s.authors     = ["Josh Cheek"]
  s.email       = 'josh.cheek@gmail.com'
  s.files       = Dir["**/*"].select { |f| File.file? f }
  s.homepage    = 'https://github.com/JoshCheek/elective-building-a-gem'
end
```

Notice we have to tell it which files to include.
That could be cumbersome to keep up-to-date by hand, so we're
using the same trick we used earlier to find the files.

```sh
$ ruby -e 'p Dir["**/*"]'
["bin", "bin/gitloc", "Readme.md", "spec", "spec/acceptance_spec.rb", "spec/fixtures", "spec/fixtures/2loc"]

$ ruby -e 'p Dir["**/*"].select { |f| File.file? f }'
["bin/gitloc", "Readme.md", "spec/acceptance_spec.rb", "spec/fixtures/2loc"]
```

Building our gem into a `.gem` file
-----------------------------------

Now that it is a gem, we can turn it into a single .gem file:

```sh
$ gem build gitloc.gemspec
  Successfully built RubyGem
  Name: gitloc-joshcheek
  Version: 0.1.0
  File: gitloc-joshcheek-0.1.0.gem

$ ls -l
total 32
-rw-r--r--  1 josh  staff  1271 Feb 17 11:32 Readme.md
drwxr-xr-x  3 josh  staff   102 Feb 17 11:32 bin
-rw-r--r--  1 josh  staff  6144 Feb 17 11:34 gitloc-joshcheek-0.1.0.gem
-rw-r--r--  1 josh  staff   604 Feb 17 11:34 gitloc.gemspec
drwxr-xr-x  4 josh  staff   136 Feb 17 11:32 spec
```

This file is what rubygems downloads when you say `gem install <gemname>`
Lets commit our work.
When we do our first `git status`, we see we are about to commit a file we don't want!
`gitloc-joshcheek-0.1.0.gem` is a generated binary file. So it will be very large and it doesn't
provide us any useful information. Lets ignore it.

```sh
$ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

  gitloc-joshcheek-0.1.0.gem
  gitloc.gemspec

nothing added to commit but untracked files present (use "git add" to track)

$ echo '*.gem' >> .gitignore

$ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

  .gitignore
  gitloc.gemspec

nothing added to commit but untracked files present (use "git add" to track)

$ git add .
$ git status
$ git commit -m 'Make it a gem!'
$ git status
```

Installing our gem
------------------

Now that it is built, lets install it.

```
$ gem list gitloc

*** LOCAL GEMS ***

$ gem install gitloc-joshcheek-0.1.0.gem
Successfully installed gitloc-joshcheek-0.1.0
1 gem installed

$ gem list gitloc

*** LOCAL GEMS ***

gitloc-joshcheek (0.1.0)
```

We can see I got it installed. But there's a problem!
I can't run the program:

```sh
$ gitloc https://github.com/JoshCheek/elective-building-a-gem
bash: gitloc: command not found
`gem fetch seeing_is_believing`
```

Telling Rubygems about our binary
---------------------------------

Looking at [the docs](http://guides.rubygems.org/specification-reference/#executables)
for the gemspec, we can see that we have to tell it that our gem
includes an executable program. So lets add that.

```ruby
# ...
  s.homepage    = 'https://github.com/JoshCheek/elective-building-a-gem'
  s.executables << 'gitloc'
end
```

And try again.

```sh
$ gem build gitloc.gemspec
WARNING:  See http://guides.rubygems.org/specification-reference/ for help
ERROR:  While executing gem ... (Gem::InvalidSpecificationException)
    gitloc-joshcheek-0.1.0 contains itself (gitloc-joshcheek-0.1.0.gem), check your files list

$ rm gitloc-joshcheek-0.1.0.gem

$ gem build gitloc.gemspec
  Successfully built RubyGem
  Name: gitloc-joshcheek
  Version: 0.1.0
  File: gitloc-joshcheek-0.1.0.gem

$ gem install gitloc-joshcheek-0.1.0.gem
Successfully installed gitloc-joshcheek-0.1.0
1 gem installed

$ gitloc https://github.com/JoshCheek/elective-building-a-gem
364Day1.md
172Readme.md
90scratch
```

Cool! Now we can run our program from anywhere,
as long as we have it installed as a gem.

**Question** Why did we have to tell it about our executable differently from the rest of the stuff?


Publishing to Rubygems
----------------------

We need to push the gem to Rubygems if we want anyone else to be able to run it.

Lets follow along with [this](http://guides.rubygems.org/publishing/#publishing-to-rubygemsorg)
tutorial since it will be different for me, so there's not
a great way for me to walkthrough ahead of time, we'll have to figure it out together!

You should be able to make an account [here](https://rubygems.org/sign_up).
And then run `gem push gitloc-joshcheek-0.1.0.gem` and fill in your credentials.
You can see it with `~/.gem/credentials`

And now we can install the gem from rubygems:

```sh
$ gem install gitloc-joshcheek
```

And we can see that it is available by going to
https://rubygems.org/gems/gitloc-joshcheek

Which means you can call your mother and tell her you accomplished something today.


Code goes in lib, not in the binary!
------------------------------------

Currently, all our code is dumped into the binary.
This got us off the ground, but it will present problems going forward
as it's very difficult to test this code, we have to write files,
execute the binary, and parse output... ouch >.<

If we pull it out, we can test it independently, like we normally do.
It also means we can share the code that makes it work, so that others
can use it from within their Ruby programs.

This code we'll pull out is our library, and our binary is a consumer
of the library, as anyone else who installs our gem might be.

**lib** is the directory rubyists typically put their library code into.
So lets do that. We want to make it as independent of the big painful things
as we can, so we don't want it to talk directly to `ARGV`, `$stdout`, or `$stderr`.
Otherwise, we would have to override global objects to test it,
and that's error-prone, still painful, and tends to ultimately need to be changed anyway.

So lets make a directory and file for our code, and move it over to there,
only swapping out `ARGV`, `$stdout`, and `$stderr`

```sh
$ mkdir lib
$ touch lib/gitloc.rb
```

Our binary now looks like this

```ruby
#!/usr/bin/env ruby
require 'gitloc'
Gitloc.call(ARGV, $stdout, $stderr)
```

And `lib/gitloc.rb` looks like this:

```ruby
require 'tmpdir'
require 'open3'
class Gitloc
  def self.call(argv, outstream, errstream)
    repo = argv.first
    Dir.mktmpdir { |dir|
      Dir.chdir dir
      out, err, status = Open3.capture3 'git', 'clone', repo, 'cloned'
      unless status.success?
        errstream.puts out, err
        exit "Failed somehow >.<"
      end
      Dir.chdir 'cloned'
      files = Dir['**/*'].reject { |name| File.directory? name }
      files.each do |filename|
        loc = File.readlines(filename).count { |line| line !~ /^\s*$/ }
        outstream.puts "#{loc}\t#{filename}"
      end
    }
  end
end
```

Okay, so now our code is in lib. We still have a lot of work to do to get it cleaned up,
but lets make sure it works

```sh
$ rspec --colour -f p
F

Failures:

  1) gitloc binary takes a git repository and tells me how many lines of code are in each file
     Failure/Error: expect(stdout).to match /2.*?spec\/fixtures\/2loc/
       expected "" to match /2.*?spec\/fixtures\/2loc/
       Diff:
       @@ -1,2 +1,2 @@
       -/2.*?spec\/fixtures\/2loc/
       +""

     # ./spec/acceptance_spec.rb:9:in `block (2 levels) in <top (required)>'

Finished in 0.05033 seconds (files took 0.16941 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/acceptance_spec.rb:7 # gitloc binary takes a git repository and tells me how many lines of code are in each file
```

Hmmm... so something is wrong, and our error output is totally unhelpful.
That's the problem with acceptance tests, you're so far away from the feedback you need.
But at the same time, it let us know the thing doesn't work, so that's good.

```sh
$ bin/gitloc "$PWD"
/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- gitloc (LoadError)
  from /Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0/rubygems/core_ext/kernel_require.rb:54:in `require'
  from bin/gitloc:2:in `<main>'
```

So it can't find the file we made. How does our program know where to look for code?
Lets take a detour.

Code is requireable if its dir is in the `$LOAD_PATH`
-----------------------------------------------------

Ruby finds files to require very similarly to how your shell finds programs to execute.
It doesn't know by default where to look, so it expects you to set an array of directories
and it will search there for the file. If it can't find it in those directories, it will
look through the installed gems. Once it finds a gem, it will add that gem to the array of directories
to reduce the cost of future requires.

In the shell, the `$PATH` is the list of directories to look for executed programs.
In Ruby, the `$LOAD_PATH` is the list of directories to look for required files.

```sh
# it doesn't know about our code
$ ruby -r pp -e 'pp $LOAD_PATH'
["/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0/x86_64-darwin13.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby/2.1.0/x86_64-darwin13.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/2.1.0/x86_64-darwin13.0"]

$ ruby -r pp -e 'require "gitloc"'
/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- gitloc (LoadError)
  from /Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0/rubygems/core_ext/kernel_require.rb:54:in `require'
  from -e:1:in `<main>'

# unless we tell it where to look
$ ruby -r pp -e "\$LOAD_PATH << '$PWD'; pp \$LOAD_PATH"
["/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0/x86_64-darwin13.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby/2.1.0/x86_64-darwin13.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/2.1.0/x86_64-darwin13.0",
 "/Users/josh/deleteme/gitloc"]

$ ruby -e "\$LOAD_PATH << '$PWD/lib'; require 'gitloc'; Gitloc.call ['$PWD'], \$stdout, \$stderr"
18bin/gitloc
12gitloc.gemspec
23Readme.md
102spec/acceptance_spec.rb
23Readmespec/fixtures/2loc
```

Also, you may see the variable `$:` around. That's the same object.

```sh
$ ruby -e 'p $: == $LOAD_PATH'
true
```

Fixing the `$LOAD_PATH`
-----------------------

So, lets fix our binary to use the `$LOAD_PATH`.
My favourite way to do this is to change it to look like this:

```ruby
#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gitloc'
Gitloc.call(ARGV, $stdout, $stderr)
```

The `unshift` tells it to put our code at the beginning of the load path instead of at the end.
This will just reduce the likelihood of multiple directories in there having the same file,
and us accidentally loading the wrong one. But if you follow the rest of the conventions we'll
talk about, you can reduce the probability of that happening.

And we see our old friend `File.expand_path` again. This is important, because if we don't
use an absolute path, then the location that it looks for code will change as the working directory changes.
This is what causes strange confusing errors like tests working when you run them from one directory,
like the root of your program, but not from another directory, like the test dir.

And our tests pass again.

```sh
$ rspec -c
.

Finished in 0.09955 seconds (files took 0.10913 seconds to load)
1 example, 0 failures

$ bin/gitloc `pwd`
18  bin/gitloc
12  gitloc.gemspec
23  Readme.md
10  spec/acceptance_spec.rb
2   spec/fixtures/2loc
```

Surprisingly, to me, at least, this is all correct.
Any thoughts on the problem that I expected to exist once we got to this point?
I'll give you a hint, our binary didn't "just work".
[Here](http://guides.rubygems.org/specification-reference/#require_paths=)'s
the thing that fixed the error that I was expecting.

Lets commit.

```sh
$ git status
$ git diff bin
$ git add bin lib
$ git status
$ git commit -m 'Move the code into lib dir'
$ git status
```

Namespacing our gem's files and classes
---------------------------------------

So, since our `lib` dir is in the `$LOAD_PATH`, that means anyone can say
`require "gitloc"` and it will work. But we want more than just one file.
Lets add a version file so that we can see the version from within the gem
as well as from the gemspec. Where should we put it?

If we put it in `lib/version.rb`, that's a problem. If some other gem
put their `version.rb` in their `lib`, then which one gets loaded when
we say `require "version"`? Whichever one comes first in the `$LOAD_PATH`.

No bueno. So, we need a place to put our files that prevents us from
colliding with theirs. Lets make a directory for them. And what should we call it?
Naming it after our gem would make sense. That would allow us to say
`require "gitloc/version"`, and they could say `require "othergem/version"` and
both would work out fine.

```sh
$ mkdir lib/gitloc
$ echo "VERSION = '0.1.0'" > lib/gitloc/version.rb
$ ruby -e "\$LOAD_PATH.unshift '$PWD/lib'; require 'gitloc/version'; p VERSION"
"0.1.0"
```

Sweet, so now we have a place to put our files that won't conflict with other gems' files.
This idea is called a "namespace".

But we still have a problem... Our `VERSION` is at the toplevel.
So if the other gem did the same, then even though we can load both files,
we'll wind up both trying to set the same constant, and I might look
at the `VERSION` and see their value instead of mine!

We need another namespace, for the code we define in our files.
What should we choose? It makes sense to go with the name of our library again.
Lets change `lib/gitloc/version.rb` to look like this:

```ruby
class Gitloc
  VERSION = '0.1.0'
end
```

And now, we can see that our version string is namespaced within Ruby, too,
so we won't conflict with another gem.

```sh
ruby -e "
> \$LOAD_PATH.unshift '$PWD/lib'
> require 'gitloc/version'
> require 'sinatra/version'
> p [Gitloc::VERSION, Sinatra::VERSION]
> "
["0.1.0", "1.4.5"]
```

Lets commit this.

```sh
$ git status
$ git add .
$ git commit -m 'Add a version file'
```


Bumping our version to 0.1.1
----------------------------

We're still 1.0, and we want to release our new version with the library code and version.
So lets bump it to `0.1.1`, because everything that used to work still works (the binary),
but now we've provided classes.

```sh
# FYI, command-line editing is dangerous,
# so make sure you commit before you do things like this on your own :P
$ ruby -i -p -e 'gsub "0.1.0", "0.1.1"' lib/gitloc/version.rb
$ git diff
```

And lets load that file from `lib/gitloc.rb` so its available when our
code gets loaded.

```sh
require 'tmpdir'
require 'open3'

require 'gitloc/version'

class Gitloc
  # ...omitted...
end
```

And update the gemspec

```ruby
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'gitloc/version'

Gem::Specification.new do |s|
  s.name        = 'gitloc-joshcheek'
  s.version     = Gitloc::VERSION
  # ...omitted...
end
```

Commit it

```ruby
$ git status
$ git diff gitloc.gemspec
$ git add gitloc.gemspec
$ git status
$ git diff lib
$ git add lib
$ git status
$ git commit -m 'Bump version to 0.1.1, load version with lib'
$ git tag 0.1.1
```

The tag allows us to easily find this one we're releasing later.

And now lets release our new code.

```sh
# still works
$ rspec -c
.

Finished in 0.11081 seconds (files took 0.15634 seconds to load)
1 example, 0 failures

# clean out the old gem
$ rm gitloc-joshcheek-0.1.0.gem

# build the new gem
$ gem build gitloc.gemspec
  Successfully built RubyGem
  Name: gitloc-joshcheek
  Version: 0.1.1
  File: gitloc-joshcheek-0.1.1.gem

# install it locally
$ gem install gitloc-joshcheek-0.1.1.gem
Successfully installed gitloc-joshcheek-0.1.1
1 gem installed

# try it locally
$ bin/gitloc `pwd`
4   bin/gitloc
14  gitloc.gemspec
3   lib/gitloc/version.rb
22  lib/gitloc.rb
23  Readme.md
10  spec/acceptance_spec.rb
2   spec/fixtures/2loc

# push it to Rubygems
$ gem push gitloc-joshcheek-0.1.1.gem
```

And that's a pretty good day, if you ask me!
