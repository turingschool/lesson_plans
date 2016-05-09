---
title: Strings and Integers
tags: basics, strings, Ruby in 100 Minutes
length: 90
---

## Learning Goals

* define "string"
* define "integer"
* define "float"
* assign values to variables using proper naming conventions
* use string concatenation with literal strings and variables
* use string interpolation with variables
* call key methods on strings
* call key methods on integers and floats
* read Ruby documentation

## Intro

There are several different types of objects in Ruby. Today, we'll focus on Strings and Integers. We'll also talk about variables, which are not a data type but instead a structure used to store references to data. 

## Strings

### Definition

Programming strings are used to store collections of letters and numbers. That could be a single letter like "a", a word like "hi", or a sentence like "Hello my friends."

A Ruby string is defined as a quote (") followed by zero or more letters, numbers, or symbols and followed by a closing quote of the same type ("). Quotes can either be single (') or double ("). 

The shortest possible string is called the empty string: "". It’s not uncommon for a single string to contain paragraphs or even pages of text.

In Ruby, strings are objects. 

### Practice

Which of the following are valid strings? Why?

1. ''
2. "123"
3. 123
4. "@*#%&"
5. hello, world!
6. 'welcome to Turing'
7. '987654321."
8. "hot chocolate is the best"

### Substrings

*Try it*: Type the following examples in IRB and determine what they do:

```ruby
"hello, world"[0]
"Turing"[0]
"ruby"[2]
"lunch"[-1]
```

We can pull out specific parts of a string. For example, I may want to know only the first letter of a string. In programming, we start with the position 0 and count up from there. 

I can access the first letter of a string using this notation:

```
"hello, world"[0]
```

If we type this into IRB, we'll get back the letter "h".

*Try it*: Type the following examples in IRB and determine what they do:

```ruby
"hello, world"[0..4]
"Turing"[0..1]
"ruby"[1..-1]
"lunch"[0..-2]
```

We use this notation to pull out substrings. For example, I may want to get back the substring "hello" from "hello, world". To do that, I can use this notation:

```ruby
"hello, world"[0..4]
```

In Ruby, `..` indicates an inclusive range. The above example means give me back all of the characters at positions 0, 1, 2, 3, and 4. 

Ruby interprets negative positions to count back from the end of the string. So in "Hi", the "i" is in position -1 and the "H" is in position -2.

So if a letter has both a positive and negative position number, which should you use? If you can use the positive numbers do it, they’re easier to reason about. But, if you’re looking for something based on it being at the end of the string (like "What’s the last character of this string?"), then use the negative positions.

### Introduction to String Methods

A `method` in Ruby can be thought of as a message that's being sent to an object. The message is received, and something is returned where it was called. Here's a simple example:

```ruby
"hello, world".upcase
```

The method is `.upcase`, the object it's being called on is "hello, world", and the return value is "HELLO, WORLD". Like the above example, most methods you'll see use what we call "dot notation" where there is a dot between the object and the method. 

Let's open up some Ruby documentation: [String](http://ruby-doc.org/core-2.2.3/String.html). Take a look on the left-hand side underneath "Methods". We'll walk through the two below to start:

```
capitalize
center
```

*Try it*: Find the following methods and their documentation, then experiment with them in IRB and jot down your own definition of what the method does. *You may need/want to Google other definitions or examples for some*. 

```
delete
downcase
empty?
gsub
include?
index
length
reverse
split
start_with?
tr
upcase
==
```

You can look at all of the possible string methods by calling the method `methods`:

```ruby
"here is a string".methods
```

Another helpful method is `.class`, which tells you what type of object you're working with:

```ruby
"here is a string".class
```

### String Concatenation

In order to talk about string concatenation, we'll first talk a little about variables. Programming is all about creating abstractions, and in order to create an abstraction we must be able to assign names to things. Variables are a way of creating a name for a piece of data.

First, we'll assign the string "mary" to the variable `student`:

```ruby
student = "Mary"
```

Let's say that we want to create a string that says "Welcome to class, Mary." There are two ways to do this. We'll start with concatenation first, which joins strings together with the plus sign:

```ruby
"Welcome to class, " + student + "."
```

Try it out in IRB. 

*Try it*: Create two more of your own examples of string concatenation using a variable. 

Note that the `+` is also a string method. It does not use dot notation. 

### String Interpolation

The second approach is to use string interpolation where we stick data into the middle of a string.

String interpolation only works on a double-quoted string. Within the string we use the interpolation marker #{}. Inside those brackets we can put any variables or Ruby code which will be evaluated, converted to a string, and output in that spot of the outer string. Our previous example could be rewritten like this:

```ruby
"Welcome to class, #{student}."
```

If you compare the output you’ll see that they give the exact same results. The interpolation style tends to be fewer characters to type and fewer open/close quotes and plus signs to forget. String interpolation is preferred and more common. You should take note of the fact that string interpolation **will only work inside of double-quoted strings**. This would not work: `'Welcome to class, #{student}.'`

*Try it*: Create two more examples of your own using string interpolation and a variable. 

## Variables

Now that we've talked about basic variable assignment, let's get into some of the more detailed rules. 

In some languages you need to specify what type of data (like a number, word, etc) can go in a certain variable. Ruby, however, has a flexible type system where any variable can hold any kind of data. Additionally, some languages require you to "declare" a variable before you assign a value to it. Ruby variables are automatically created when you assign a value to them. Let’s try an example:

```ruby
x = 10
x
```

The line `x = 10` creates the variable named a and stores the value 10 into it.

In English we read left-to-right, so it’s natural to read code left to right. But when evaluating an assignment using the single equals (=), Ruby actually evaluates the right side first. Take the following example:

```ruby
b = 10 + 5
```

The 10 + 5 is evaluated first, and the result is given the name b.

*Try it*: What is c at the end of this? Why?

```ruby
c = 15
c = "hello"
c
```

### Naming Variables

Most Ruby variables (local variables) have a few requirements. They...

* always start with a lowercase letter (underscore is permitted, though uncommon)
* have no spaces
* do not contain most special characters like $, @, and &

In addition to those requirements, Rubyists have a few common style preferences for variable names:

* use snake case where each word in the name is lowercase and connected by underscores (_)
* are named after the meaning of their contents, not the type of their contents
* aren’t abbreviated

Good variable names might be count, students_in_class, or first_lesson.

A few examples of bad Ruby variable names include:

* `studentsInClass` – uses camel-case rather than snake-case, should be students_in_class
* `1st_lesson` – variables can’t start with a number, should just be first_lesson
* `student_name_string` – includes the type of the data in the name, should just be students
* `msg` – abbreviates rather than just using message

*Try it:* Use IRB to store values with each of the following variable names. Which names are good, which are actually invalid Ruby, and which are valid but go against Ruby style?

* `time_machine`
* `student_count_integer`
* `homeworkAssignment`
* `3_sections`
* `top_ppl`

## Integers

Numeric data comes in two types: Integers and Floats. Integers are whole numbers (no decimals) and are either of the class Fixnum or Bignum. Floats are numbers that have decimal places. 

```ruby
123456789.class
1_000_000_000_000_000_000_000.class
5.6.class
1.239.class
```

*Try it*: Predict the return value before trying these in IRB. Which of these work? Which of these do something you didn't expect? 

```ruby
3 + 4
2 * 4
2 ** 5
6 - 2
4 / 2
3 / 4
3.0 / 4.0
3 / 4.0
3.0 / 4
1.5.to_s
5.5.to_i
1 + "2"
1 + "2".to_i
(1 + 2) * 3
1 + (2 * 3)
```

We can also (somewhat) combine strings and integers. Try these:

```ruby
"hi" * 5
5 * "hi"
```

### Introducing Number Methods

All of the arithmetic operations that you tried above are actually methods. Let's look at the documentation for [Integer](http://ruby-doc.org/core-2.2.3/Integer.html#method-i-gcd) and [Float](http://ruby-doc.org/core-2.2.3/Float.html). 

```
round
to_f
to_i
to_s
floor
ceil
abs
%
==
>
>=
even?
odd?
next
```

Spicier methods:

```
upto
times
```

## Recap

Today, you accomplished the following:

* define "string"
* define "integer"
* define "float"
* assign values to variables using proper naming conventions
* use string concatenation with literal strings and variables
* use string interpolation with variables
* call key methods on strings
* call key methods on integers and floats
* read Ruby documentation

## Homework

Complete the [Working with Strings and Integers](https://github.com/turingschool/challenges/blob/master/working_with_strings_and_integers.markdown) challenge. 
