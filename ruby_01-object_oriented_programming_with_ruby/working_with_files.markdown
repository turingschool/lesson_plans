---
title: Working with Files
tags: files, I/O, command line, unix
length: 90
---

## Learning Goals

* Recognize the significance of files in modern computing systems
* Be able to create a new file from the command line, our editor, and ruby
* Be able to read data from a file from the command line, our editor, and ruby
* Be able to write data to a file from the command line, our editor, and ruby
* Understand how the cursor works in a file

## Structure

* 5 - Warmup
* 15 - Understanding Terms
* 20 - Exercising Raw Files
* 5 - Progress Checks & Questions

## Lesson

### Warmup

Spend 5 minutes answering the following questions:

1. What exactly goes into files on our computer?
2. Name 3 kinds of files you've worked with in the past.
3. What determines what kind of information goes into each kind of file?
4. Why would you want to read files, especially text files, from Ruby?

### Understanding Terms & Concepts

Let's spend 15 minutes discussing a few key concepts together:

* Writing a line
* Closing a handle

### Basics - Reading an Existing File

* Using Atom (or your preferred text editor)
* Using `cat`
* Using Ruby from Pry or IRB

### Basics - Creating an Empty File

* Using your editor
* Using `touch`
* Using Ruby and `FileUtils.touch` or `File.write("path", "")`

### Basics - Writing Data to a File

* Using your editor
* Using `echo`
* Using `curl`
* Using Ruby and `File.write`

__Discussion - Unix File Basics__

* Opening a file handle
* Read/Write mode

### Intermediate - Reading a file "bit by bit"

__Discussion - Problems Reading Whole File__

What happens to data that we read from a file?
When might it be problematic to read the entire contents of a file?

__Discussion - File Cursors & Reading Files Incrementally__

* Handles as a means of maintaining a "persistent" connection to a single file
* Using handles as opposed to `File.write` / `File.read` -- in the previous examples
we perform **exactly 1** action on the file. No need to keep it open.

* Using `less`
* From Ruby using a file handle

### Program Design - Isolating File Dependencies

### Exercising Raw Files

Write a program which, when executed, creates a file named "fib.txt". In that
file output the first 30 numbers of the Fibonacci sequence, three numbers per line.
It'd start like this:

```
0, 1, 1,
2, 3, 5,
8, 13, 21,
34, 55, 89,
```

Then, write a second program which reads the `fib.txt` and outputs the lines
in the same top-to-bottom order but reversed left-to-right like this:

```
1, 1, 0,
5, 3, 2,
21, 13, 8,
89, 55, 34,
```

#### Raw File I/O Notes

```
# Opening a Read Handle
handle = File.open("filename.txt", "r")

# Reading a whole file
handle.read

# Rewind back to the beginning
handle.rewind

# Read a single line
handle.readline

# Read a collection (array) of lines
handle.readlines

# Read one line at a time with a block
handle.each_line do |line|
  puts "A line: #{line}"
end

# Opening a Write Handle
writer = File.open("output.txt", "w")

# Write a line
writer.write("My text.\n")

# Flush output but keep the handle open
writer.flush

# Close the handle and flush
writer.close
```
