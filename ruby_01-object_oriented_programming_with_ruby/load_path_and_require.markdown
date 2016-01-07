---
title: Load Path & Require
length: 60
tags: fundamentals, computer science
---

## Learning Goals

* Understand how Ruby finds code when using `require`
* Understand file namespacing (advantages of `lib/enigma/chunk_rotate.rb` over `lib/chunk_rotate.rb`)
* No more relative requires (`require "./lib/file"` or `require_relative "file"`)
* Understand why they can use `require` when testing, but not when run outside the test env
* Be able to use Ruby's `-I` flag
* Be able to set the `$LOAD_PATH` from their toplevel file.
* Understand how to find code with `gem which anything/i/can/require`

## Structure


## Content

Raise your hand if your code has ever mysteriously broken because it can't find the file you're requiring
(that's all of you). Ever fix it by messing around with the require statement until it works...
only to find it broken again at some other point? Fkn frustrating, eh?

What we'll learn today will put that nonsense in the past!


### What is the `$LOAD_PATH`?

The `$LOAD_PATH` is a global variable that points at an array of directoryies (folders).
Take a look at it now:

```
$ ruby -r pp -e 'pp $LOAD_PATH'
["/Users/josh/.rubies/ruby-2.2.2/lib/ruby/site_ruby/2.2.0",
 "/Users/josh/.rubies/ruby-2.2.2/lib/ruby/site_ruby/2.2.0/x86_64-darwin13",
 "/Users/josh/.rubies/ruby-2.2.2/lib/ruby/site_ruby",
 "/Users/josh/.rubies/ruby-2.2.2/lib/ruby/vendor_ruby/2.2.0",
 "/Users/josh/.rubies/ruby-2.2.2/lib/ruby/vendor_ruby/2.2.0/x86_64-darwin13",
 "/Users/josh/.rubies/ruby-2.2.2/lib/ruby/vendor_ruby",
 "/Users/josh/.rubies/ruby-2.2.2/lib/ruby/2.2.0",
 "/Users/josh/.rubies/ruby-2.2.2/lib/ruby/2.2.0/x86_64-darwin13"]
```

### Exercise: Write `my_require`

When you require a file, Ruby will search through this array, sequentially,
until it locates the file you required.

Go ahead and try writing it. You'll need to know about these helpful methods:

* `File.exist?("my_file.rb") # => true` Give it a path, it will tell you whether there's a file there.
* `raise LoadError, "cannot load such file -- #{filename}"` This will make it blow up like it does when you require nonexistent files
* `File.read("#{dirname}/#{filename}.rb")` Returns the file's contents, as a string
* `eval("123 + 456") # => 579` Give it a string of Ruby code, it will evaluate the code

Here is [my solution](https://gist.github.com/JoshCheek/bb272ccc4748a5d062db).

### Exercise

Put this in a file named `file1.rb`.

```ruby
# this is file1
puts "beginning of file1"
# directory = File.expand_path(".", __dir__) # __dir__ is the directory of the current file
# $LOAD_PATH.unshift(directory)
require 'file2'
puts "end of file1"
```

In the same directory, this will be `file2.rb`

```ruby
puts "file2 loaded"
```

The first file requires the second, and it is in the same directory.
Run (`$ ruby file1.rb` it and see it fail.

Uncomment the third and fourth lines to fix the load path.
Now run it and see it pass.

Now, put file1 into a directory named test, and file2 into a directory named lib.
Run it again, it should fail. Fix the path so it finds the correct directory.

```sh
$ mkdir test lib
$ mv file1.rb test/file1.rb
$ mv file2.rb lib/file2.rb
```

### Setting the `$LOAD_PATH`

Here are a few common ways to set the `$LOAD_PATH`

1. Edit the global variable, as we've done above.
2. In a test environment, mrspec will add `lib` and `test` and `spec` for you, if those directories exist.
3. The -I flag will also set directories on the load path `ruby -I /abc -r pp -e 'pp $LOAD_PATH'`

### Exercise

Recomment the load path code in test/file1.rb, and use the `-I` flag to make the require statement work again.


### Questions

* What happens if there are 2 directories that have a file of that name?


-----

Other stuff I didn't incorporate, but might be useful for next time:

```
Related topics we can cover if we have time
  Why do we do `$LOAD_PATH.unshift dirname` instead of `$LOAD_PATH << dirname` ?
  What happens if you require a file more than once?
  Why do gems follow the directory structure of example2?


------------------------
The $PATH
  On the command line there is the $PATH
  This can be thought of as an array which holds directories.
  Really it's string with directories separated by colons.
  `$ echo $PATH`
  `$ echo $PATH | tr : "\n"`
  When I run a program like `$ls`, it searches through these directories until it finds the program, and then runs it.
  You can see where a program is by saying `$which ls` (/bin/ls)
  And we can see that /bin is in the $PATH, so when we run it, it will search through these directories until it finds the ls in /bin
  Now what if we put another directory in front of it, which has an ls program in it?
  Then it will find the other ls program.

  `
  $ echo echo LOLOL > ls
  $ chmod +x ls

  $ ls
  some_file.rb ls

  $ export PATH="$PWD:$PATH"
  $ ls
  LOLOL
  `

  In fact, this is how RVM switches out which Ruby you are currently using, it modifies the load path so that the ruby you want to use will always be found first.
```
