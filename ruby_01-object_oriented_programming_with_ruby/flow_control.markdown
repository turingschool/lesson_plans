---
title: Flow Control
length: 60
tags: fundamentals, computer science
---

# Flow Control

## Learning Goals

* explain the flow of execution through a chunk of code
* explain how evaluation happens when method calls are inside method calls
* apply the `times` method to repeat instructions
* use `while` and `until` to repeat instructions
* use `loop` and `break` to repeat instructions
* break out of an infinite loop in both IRB and regular Ruby
* use `if` statements to control execution
* use an `else` statement to create an alternative path
* combine if, elsif, and else to create multiple branches

## Discussion

### Looping

A loop is a set of instructions that is executed repeatedly until some condition is met. This condition may be a certain number of times that the loop is executed, or it may be a question that returns a true/false answer. 

Examples: 

- While looking for a parking spot at a crowded sporting event, a car continues to drive up and down the rows until an empty spot is found. (Loop that executes until a question returns true or false)
- After baking cookies, you pull the cookie sheet out of the oven which holds 24 cookies. One by one, you remove each of the cookies from the sheet and place them on a cooling rack. (Set of instructions that executes 24 times)

*Try it*: What are some other examples of looping in the real world? 

* `while`

```ruby
while condition (boolean)
  # code to execute
end
```

* `until`

```ruby
until condition (boolean)
  # code to execute
end
```

* `times`


```ruby
5.times do
  # code to execute
end
```

```ruby
5.times do |number|
  # code to execute
end
```

### Branching

In programming, branching refers to a choice that is made depending on whether or not a condition is true or false. Think of branching as "choose your own adventure".

Examples: 

- If a student earns a 3.8 GPA or higher, then they are invited to the honor roll ceremony. (One branch)
- If you want to spend a lot of money for dinner, go to a fancy restaurant. Otherwise, cook at home. (Two branches)

*Try it*: What are some other examples of looping in the real world? 

* `if`

```ruby
if condition (boolean)
  # code to execute
end
```

* `else`

```ruby
if condition (boolean)
  # code to execute if true
else
  # code to execute if false
end
```

* `elsif`

```ruby
if condition (boolean)
  # code to execute if above condition evaluates to true
elsif condition (boolean)
  # code to execute if above condition evaluates to true
else
  # code to execute if both evaluate to false
end
```

## Exercises

Before gettign started, you'll need a few tools to work with user input and output. 

* How do we tell Ruby to print text to the screen?
* How do we tell Ruby to bring in text from the user?

### 1. Basic `puts` / `gets`

Write a simple Ruby program which prompts the user to enter a message, then prints that message to the terminal. For example:

```
Type your message:
(user types "pizza" and presses enter)
pizza
```

### 2. Basic Branching

Extend your previous program so that if the text the user enters has an even number of letters, it prints "EVEN!", and if it has an odd number of letters, it prints "ODD!".

### 3. Multi-pronged branching

Write a new program that prompts the user for a message, then, depending on the following conditions, prints an appropriate message:

* If the message ends with a consonant, print "CONSONANT!"
* If the message ends with a vowel, print "VOWEL!"
* If the message ends with a "y", print "DON'T KNOW!"

### 4. Easy Looping

Use a `times` loop to generate this output:

```
Line
Line
Line
Line
Line
```

### 5. Looping with a Condition

Build on your answer from the problem above and add an `if`/`else` to generate output like this:

```
Line is even
Line is odd
Line is even
Line is odd
Line is even
```

### 6. Three Loops

Generate the output below using three totally separate implementations (`times`, `while` and `until`):

```
This is my output line 1
This is my output line 2
This is my output line 3
This is my output line 4
This is my output line 5
```

### 7. Rando-Guesser

Write two implementations, one with `while` and one with `until` that output the following:

```
(The secret number is 8)
Guess is 4
Guess again!
Guess is 5
Guess again!
Guess is 9
Guess again!
Guess is 4
Guess again!
Guess is 8
You win!
```

The secret number and the guesses are both random numbers 0 through 10.

## Alt Lesson Plan

For a less directed version of this lesson focused more around independent exercise (good for echo or mod 1 repeaters), try [this](https://github.com/turingschool/lesson_plans/blob/master/ruby_01-object_oriented_programming_with_ruby/flow_control_alt_exercise.markdown)
