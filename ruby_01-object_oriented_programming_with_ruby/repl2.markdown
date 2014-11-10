---
title: REPL Essentials
length: 120
tags: repl, loops, ruby
---

# REPL Essentials

## Notes

* Download the slides from https://www.dropbox.com/sh/8dhu4b6yl03yk0h/AABuniRzrrzeR6ENVQgUjt4oa?dl=0
* This material was taught with Numbermind: https://github.com/turingschool-examples/numbermind at SHA 731af8c07d9f2f351ce3380ec214ec181dcd21cb, it has since been modified

## Standards

* define REPL
* identify situations in which a REPL would be used
* implement a REPL using Ruby

## Structure

* 5 - What is a REPL & Examples
* 5 - Game specifications
* 15 - Code-along: Setup and Main REPL
*

## Lesson

#### Topic I

#### Topic II

#### Topic III

## Wrapup

Return to standards and check progress.
* What was easy?
* What was challenging?
* What made sense?
* What didn't make sense?

## Corrections & Improvements for Next Time

### Taught by Rachel


Building Your Own REPL
======================


STANDARD INPUT AND STANDARD OUTPUT
----------------------------------

What are the inputs to your program?
  text coming in (e.g. the keyboard)

What are the outputs from your program?
  text going out (e.g. the monitor)
How do we access these in our program?
  $stdin, and $stdout
  $stdin.gets()
  $stdout.puts("hello, world")
  these are just streams of text, just like a file
Wait, what happened to `gets` and `puts`?
  These are convenience methods for quick/dirty programs
  Notice that `gets` is either a local variable or a method
  And it's not a local variable, so it must be a method
  What object is this being called on? It must be `self`
  Which means we must inherit them.
  `self.method(:gets).owner`
  How are they defined, then?
  ```ruby
  def gets
    $stdin.gets()
  end
  ```

exercise (method that directly calls gets)

What if we wanted to pull input from some other place?
  We can't if we use `gets`, because that becomes `$stdin.gets`
  So we wouldn't want to call the inherited `gets`
  we would want to call it on the input stream directly
  and we would want the ability to switch out what the input stream is

exercise (refactor the previous example so that we can give it a file instead)

REPL
----

define it: Read, Eval, Print, Loop
think through it really quickly
exercise write our own:
```
context = binding()
loop do
  $stdout.print "> "
  input   = $stdin.gets()
  result  = binding.eval(input)
  $stdout.puts(result)
end
```

Refactor it.


LOAD PATH
---------

When you say `require "some_file"`, how does Ruby find that?
  It looks for the file inside of a list of directories
  That list is stored in the array `$LOAD_PATH`
  To be able to require your files without specifying the direct path to them, you need to add the directory to the `$LOAD_PATH`

exercise to show this

Where is this file?
  In the latest versions of Ruby, we can use `__dir__` to refer to the current file's directory
  In older versions, we had `__FILE__`, the path to the current file

We use `File.expand_path(path_to_file, directory_path_is_starting_at)` to get an absolute directory
  this means it gives the path from the root of the file system
  if we don't do this, it assumes the path is from wherever we're sitting in the file system (known as the current working directory)
  which means that if we ran the same file, while we were in different directories, we would see different results
  usually manifesting in it being unable to find the file

exercise to show this


NUMBERMIND
  fix the load path
  require the files
  invoke the code, passing it stdin
  split up the replness from the game itself
  notice the toplevel file
    its job is to wire everything together:
    fix the load path
    load the code
    set the dependencies (tell them what stdin they are talking to)


CHEATSHEET
----------
  IDIOMS
    `If you need a method that means "do your thing", name it `call`
    CWD is an acronym for "Current Working Directory", aka the output of `pwd` in the shell
  FILES
    `$LOAD_PATH stores an array of directories that will be searched (via the `each` method) when you require a file`
    `File.expand_path("c/d", "/a/b")` expands to "/a/b/c/d"
    __dir__ is the path to the directory of the current file relative to CWD
    __FILE__ is the path to the current file relative to CWD
  BINARY
    definition     - The file you actually run
    responsibility - Wire up the world and kick things off
    The binary is usually invoked directly (`./numbermind`), though not in our Numbermind example (`ruby numbermind.rb`)
    We call it a "binary" for historical reasons: executable files used to have to be machine code, so 1s and 0s,
      which is called "binary", because there are only 2 values for each digit.
  IO (Input and Output)
    $stdin  - "standard input", the text input to our program
    $stdout - "standard output", the text output of our program
    gets    - shortcut for $stdin.gets
    puts    - shortcut for $stdout.puts
    NOTE: text read from `$stdin` comes from the world outside our program, we don't control it
          text written to `$stdout` goes to the world outside our program, we don't control it
          this means that these aren't testable
  A flexible program that does IO
    Instead of talking to the global variables, let the caller pass us the stream to talk to.
  StringIO
    An IO object, like our $stdin and $stdout
    but reads from a string instead of the standard input
    and writes to a string instead of the standard output
    ```
    # has hidden dependency on standard output (monitor)
    def print_greeting
      puts "Hello!"
    end
    print_greeting # goes to monitor

    # lets us choose where it prints the greeting
    def print_greeting(stream)
      stream.puts "Hello!"
    end

    # choose stdout -- goes to monitor
    print_greeting $stdout

    # choose a different IO object -- does not affect the outside world
    require 'stringio'
    stream = StringIO.new
    print_greeting stream
    stream.string # => "Hello!\n"
    ```
  REPL
    ```
    def calculator_repl(instream, outstream, calcualted)
      outstream.puts "The current number is: #{calcualted}"
      outstream.puts "Enter an operator and number, e.g. '+5', or 'q' to quit"
      loop do
        # prompt and get input
        outstream.print "> "
        raw_input = instream.gets.strip

        # potentially quit calculating, returning the calculated value
        return calcualted if raw_input == 'q'

        # parse the input for an operator or sequence of digits
        inputs   = raw_input.scan(/[-+*\/]|\d+/) # in "+5", this is ["+", "5"]
        operator = inputs[0]
        number   = inputs[1].to_f

        # perform the calculation
        if    operator == '+' then result = calcualted +  number
        elsif operator == '-' then result = calcualted -  number
        elsif operator == '*' then result = calcualted *  number
        elsif operator == '/' then result = calcualted /  number
        end

        # show the calculation, update the calculated value
        outstream.puts("#{calcualted} #{operator} #{number} = #{result}")
        calcualted = result
      end
    end

    # Read input from our object's stream, not the $stdin, write to $stdout
    require 'stringio'
    instream = StringIO.new("+2\n *3\n -4\n q\n")
    calculator_repl(instream, $stdout, 0.0) # => 2.0

    # >> The current number is: 0.0
    # >> Enter an operator and number, e.g. '+5', or 'q' to quit
    # >> > 0.0 + 2.0 = 2.0
    # >> > 2.0 * 3.0 = 6.0
    # >> > 6.0 - 4.0 = 2.0
    # >> >
    ```


QUIZ
----
  Q: What is the `$LOAD_PATH`?
  A: An array of directories to search when you require a file

  Q: You have two files in the same directory, f1.rb and f2.rb,
     f1.rb has the line `require "f2"`. When you run it, you see
     "`require': cannot load such file -- f2 (LoadError)"
     What is the problem? How do you fix it?
  A: The probalem is that their directory isn't in `$LOAD_PATH`
     Fix it by adding their directory to the load path

  Q: What method name is commonly used in Ruby to tell an object to "do what you do"
  A: call

  Q: `__dir__` gives us what?
  A: The path to the current file's directory.

  Q: `__FILE__` gives us what?
  A: The path to the current file.

  Q: Say `$LOAD_PATH` is the array `["/a/b", "/c/d"]`,
     and there are files "/a/b/hellooo.rb" and "/c/d/hellooo.rb".
     If we require "hellooo.rb", what file will be required?
  A: "/a/b/hellooo.rb"
  further thought:
     When Ruby goes looking for the file to require, it just does an `each`
     over these directories, returning the first place it finds the file.

  Q: If we were in the directory /Users/josh/Turing/numbermind
     and we saw the file "/Users/josh/Turing/numbermind/numbermind.rb",
     which wanted to require the file "/Users/josh/Turing/numbermind/lib/cli.rb"
     and it did this by saying `require 'cli'`, what code would it need to have first
     in order for that to work?
  A: `$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
  further thought:
    Unshift here is just placing the new directory at the beginning of the array.
    It's just like `$LOAD_PATH << File.expand_path('lib', __dir__)`, except
    that would place the directory at the back of the array.

  Q: If you had three files:
     * game.rb,    requires lib/cli.rb
     * lib/cli.rb, requires lib/board.rb
     * board.rb    doesn't require anything
     Where would you put your require statement?
  A: game.rb
  further thought:
    Once the load path is fixed, it is fixed
    (it's stored in a $global_variable, so everyone sees the same array).
    So you should fix the load path at the entry point to the program.
    Then the rest of the program can assume that the path is correct.

  Given these code samples:
    1: lib_dir = File.expand_path('lib', __dir__)
       $LOAD_PATH.unshift(lib_dir)
       require 'cli'
       CLI.new($stdin, $stdout).call

    2: lib_dir = File.expand_path('lib', __dir__)
       $LOAD_PATH.unshift(lib_dir)
       require 'cli'
       cli = CLI.new
       $stdout.puts cli.welcome_message
       loop do
         break if cli.game_over?
         input = $stdin.gets
         break unless input
         output = cli.call(input)
         $stdout.puts
       end

  Q: Which one probably has higher test coverage?
  A: 1
  further thought:
    Being in the binary, where simply requiring this file kicks off a game,
    something we don't want to happen in the middle of our tests,
    the code in these files is probably not tested.
    If we wanted to test it, we'd have to start a new process
    (meaning approximately `system "ruby", "numbermind.rb"`
    If you'd like to play with this, look into something like this: http://www.rubydoc.info/stdlib/open3/Open3.capture3)

  Q: Which game.rb has a better separation between logic and environment?
  A: 2
  further thoughts:
    Notice that the CLI doesn't have any knowledge of input streams and output streams.
    This means it can deal with simple strings, which are much easier to work with.
    We pulled the painful pieces up into the binary, and can now interact with that code easily.

    Also notice that CLI doesn't have a loop in it, we pulled that up into the binary.
    This means that the CLI is dramatically more flexible. For example, we could test it like this:

    ```ruby
    def test_i_am_back_at_the_main_menu_after_selecting_instructions
      cli = CLI.new
      # view instructions, get prompted again
      to_print = cli.call("i").downcase
      assert_includes to_print, "enter 'p' to play"
      assert_includes to_print, 'enter your command'

      # can quit from the main menu
      refute cli.game_over?
      assert_includes cli.call("q").downcase, "goodbye"
      assert cli.game_over?
    end
    ```

    See, in that test, how easy it is to look at each instruction independently?
    We can assert the state of `cli.game_over?` between the two inputs.
    If the cli itself took care of the loop, then we wouldn't be able to
    "pause" it at this point in order to make these assertions.

    NOTE: This example isn't always possible without further decoupling
          (with mastermind, for example, you have the game loop inside of the menu loop)

    Now, we still need to be apprehensive, there's a little bit of logic in here,
    and it's almost certainly not tested, since it's in the binary
    (we would have to have our test execute the program like we do on the command-line).
    and additional requirements could easily manifest as changes here.
    So we could easily wind up with a lot of code, including some logic,
    sitting here, untested. If we saw that this was happening, we'd probably want
    to pull this high-level nasty code into its own object (nasty because it has to
    deal with streams and loops, both of which make it much harder to work with).
    We could push it down into the cli, but that code is nice and easy to work with,
    so we wouldn't want to infect it with these dependencies unless we felt like they were really doing the same thing.










