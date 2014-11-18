---
title: Building your own REPL
length: 180
tags: repl, loops, ruby
---

# Building your own REPL

## Material

* These material are at https://github.com/JoshCheek/building-your-own-repl
* Cheatsheet: https://github.com/JoshCheek/building-your-own-repl/blob/master/cheatsheet.pdf?raw=true
* Quiz: http://quiz-building-your-own-repl.herokuapp.com/

## REPL

* REPL stands for Read, Eval, Print, Loop
* Think through what these mean
* Can we think of any REPLs? pry, irb, the shell(bash)

**Exercise: Write our own**

```ruby
loop do
  print "> "
  input  = gets()
  result = eval(input)
  puts(result.inspect)
end
```

When might you want to use this?

## Standard input and output

* How do we interact with a program?
  * Text goes in (e.g. from the keyboard)
  * Text comes out (e.g. to the monitor)
* How do we access these in our program?
  * `$stdin`, and `$stdout`
  * `$stdin.gets()`
  * `$stdout.puts("hello, world")`
  * These are just streams of text, just like a file
* Wait, what happened to `gets` and `puts`?
  * These are convenience methods for quick/dirty programs
  * Notice that `gets` is either a local variable or a method.
    And it's not a local variable, so it must be a method
  * What object is this being called on? It must be `self`
    Which means we must inherit them.
    `self.method(:gets).owner`
  * How are they defined, then?
    https://github.com/rubinius/rubinius/blob/21267107492a160fbafbc1351dcce7d517976645/kernel/common/kernel.rb#L675-678

**Exercise: `gets` is `$stdin.gets`**

Define a method that gets from stdin and tells us what it got.

```ruby
def get_next_line
  line1 = gets
  line2 = $stdin.gets
  puts "FIRST  LINE IS: #{line1}"
  puts "SECOND LINE IS: #{line2}"
end
require 'pry'
binding.pry
```

Run the code and see that both do the same thing.

```sh
$ ruby example1.rb
pry(main)> get_next_line
# type "hello" and then "world"
=> "NEXT LINE IS: \"Hello, world\\n\""
```

What if we wanted to pull input from some other place?
We can't if we use `gets`, because that becomes `$stdin.gets`,
it's reading from the keyboard.
We would want to call it on the input stream directly,
and we would want the ability to switch out what the input stream is

**Exercise: Passing the input stream lets us choose where to get input from**

```ruby
def get_next_line_from(stream)
  line = stream.gets
  puts "LINE IS: #{line}"
end
require 'pry'
binding.pry
```

Make an input file

```
hello from the file
world from the file
```

Run this example and see that our method can get input
from the standard input or a file.

```sh
$ ruby example2.rb
pry(main)> get_next_line_from($stdin)
# enter "hello from the keyboard"

pry(main)> file = File.open('input')
=> #<File:input_file>

pry(main)> get_next_line_from file
LINE IS: hello from the file
=> nil

pry(main)> get_next_line_from file
LINE IS: world from the file
=> nil

pry(main)> get_next_line_from file
LINE IS:
=> nil
```

## Applying this knowledge to our REPL

Now that we understand what those `gets` and `puts` are doing,
and their limitations, lets refactor our earlier work:

* Pull it into a method
* Invoke gets and puts on the global streams directly
* Extract each global stream to a local variable at the top of the method
* Move the variable to a parameter and pass the value in from the caller

**Exercise: Refactor the repl to use streams**
```ruby
def repl(input_stream, output_stream)
  loop do
    output_stream.print "> "
    input  = input_stream.gets()
    result = binding.eval(input)
    output_stream.puts(result)
  end
end

repl($stdin, $stdout)
```


## The `$LOAD_PATH`

When working with a project like as mastermind,
you'll have multiple files. This means code
will need to be able to require the ones it
depends on (you can think of "depends on" as meaning
"doesn't work without this").

When you say `require "some_file"`, how does Ruby find that?
It looks for the file inside of a list of directories.
That list is stored in the array `$LOAD_PATH`
To be able to require your files without specifying the direct path to them,
you need to add the directory to the `$LOAD_PATH`

**Exercise: Look at the load path**

```
$ pry
pry(main)> $LOAD_PATH
=> ["/Users/josh/.gem/ruby/2.1.1/gems/coderay-1.1.0/lib",
 "/Users/josh/.gem/ruby/2.1.1/gems/method_source-0.8.2/lib",
 "/Users/josh/.gem/ruby/2.1.1/gems/pry-0.10.1/lib",
 "/Users/josh/.gem/ruby/2.1.1/gems/slop-3.6.0/lib",
 "/Users/josh/.gem/ruby/2.1.1/gems/yard-0.8.7.4/lib",
 "/Users/josh/.gem/ruby/2.1.1/gems/pry-doc-0.6.0/lib",
 "/Users/josh/.gem/ruby/2.1.1/gems/pry-rails-0.3.2/lib",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby/2.1.0/x86_64-darwin13.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/site_ruby",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby/2.1.0/x86_64-darwin13.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/vendor_ruby",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/2.1.0",
 "/Users/josh/.rubies/ruby-2.1.1/lib/ruby/2.1.0/x86_64-darwin13.0"]
pry(main)>
```

* Finding the file and directory
  * In the latest versions of Ruby, we can use `__dir__` to refer to the current file's directory
  * In older versions, we had `__FILE__`, the path to the current file
* We use `File.expand_path(path_to_file, directory_path_is_starting_at)` to get an absolute directory
  * This means it gives the path from the root of the file system
  * If we don't do this, it assumes the path is from wherever we're sitting in the file system (known as the current working directory).
    Which means that if we ran the same file, while we were in different directories, we would see different results
  * Usually manifesting in it being unable to find the file

**Exercise: See `__FILE__`, `__dir__`, and `File.expand_path`**

Make this file:

```ruby
puts "The dir:                   #{__dir__}"
puts "The file:                  #{__FILE__}"
puts "The c relative to /a/b:    #{File.expand_path("c", "/a/b")}"
puts "The c relative to the dir: #{File.expand_path("c", __dir__)}"
```

Now run it and analyze the output.

**Exercise: We can require files when the dir is in the load path**

Make these files:

f1.rb

```ruby
puts "loaded f1!"

require 'pp'
pp $LOAD_PATH

require 'f2'
```

f2.rb

```ruby
puts 'loaded f2!'
```

Run it, what do you see? Why did it break?

Now change f1.rb to be this:

```ruby
puts "loaded f1!"

$LOAD_PATH.unshift(File.expand_path('.', __dir__))

require 'pp'
pp $LOAD_PATH

require 'f2'
```

Run it, why did it work?


## Numbermind

Lets look at a bigger example, one that looks more like yours.
Clone https://github.com/turingschool-examples/numbermind

* numbermind.rb
  * We enter the program at numbermind.rb
  * This is the binary
  * Its job is to wire up the world and kick things off
  * It fixes the load path
  * Requires the Cli
  * Why does this work?
  * What is a CLI? It is a Command Line Interface,
    the code that presents us, calling it from the command-line,
    with an interface to the game.
  * What might an alternative interface be?
  * It initializes the CLI with the standard inputs and outputs
    (meaning "read from the keyboard, write to the monitor)
  * It invokes the CLI
* cli.rb
  * Why doesn't this file fix the load path?
  * Why does it take the input stream and output stream?
  * Why does it name the variable `instream` instead of `stdin`?
  * What is `messages` for?
  * Why does it print the message instead of having `messages` print it?
  * Where is the "Read" portion of the REPL?
  * Where is the "Eval" portion of the REPL?
  * Where is the "Print" portion of the REPL?
  * Where is the "Loop" portion of the REPL?
  * Why does it have a `private` keyword there?
  * Notice we can entirely see where game is used, and it has no knowledge of CLI.
  * Game is a silo.
  * Thinking back to the types of interfaces we might have, what's one problem with Game?
    We aren't even inside it, and we can see this.
  * How might we refactor that?

## Wrapup

Recap. Take the Quiz.
