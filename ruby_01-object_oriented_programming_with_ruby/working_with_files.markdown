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
* Be able to read command-line arguments from within a ruby program using `ARGV`

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
5. What other kinds of files might you want to read from a program?

### Basics - Reading an Existing File

* Using `cat`
* Using Ruby from Pry or IRB

### Basics - Creating an Empty File

* Using `touch`
* Using Ruby and `FileUtils.touch` or `File.write("path", "")`

### Basics - Writing Data to a File

* Using `echo`
* Using `curl`
* Using Ruby and `File.write`

## Command-line Arguments and `ARGV`

Working with files represents 1 common way our ruby programs will
interact with the system environment.

Another common interaction involves reading **"Command Line Arguments"**

Examples you've seen before:

* `ls -l`
* `git commit -m`
* `ruby -v`

__Discussion: Reading Arguments from a Ruby Program__

* `ARGV` - a special array
* Arguments are provided as strings
* Arguments are separated by spaces
* `ARGV` is a "constant" and is globally accessible from anywhere
in a ruby program

### Exercise - Ruby copy

Now that you know the basics of working with files and command-line
arguments, you have all you need to implement a simple ruby
file copy utility.

Create a short ruby file, `copy.rb` which takes 2 file names
as command line arguments, and copies the contents of the first file
into the second one.

I would like to use the program like this:

```
echo "pizza" > pizza1.txt
ruby copy.rb pizza1.txt pizza2.txt
cat pizza2.txt
pizza
```

### Video

https://vimeo.com/130322465
