## Stacks, Methods, and Program Flow

__Standards__

* Understand the idea of a Stack as a general-purpos FILO data
structure
* Review standard method and control-flow patterns
* Understand how Ruby uses a stack to model flow-of-control between
methods


* intro discussion - stack flow
* intro example - method calling into gets
* synchronous execution model -- outer instruction has
to wait for inner to finish

* Demo - Modeling stack examples using index cards

* Exceptions - brief discussion on how exceptions follow the same stack discipline

## Intro Discussion

* Stack -- a fundamental Data Structure in computer science
* We encountered it in the [Well-Formed Strings](https://github.com/turingschool/challenges/blob/master/well_formed_strings.markdown)
challenge
* There's actually another more ubiquitous application of stacks: managing
flow of execution and context within a computer program
* A Stack vs. __The Stack__ -- The program stack is so omnipresent we often
refer to is as The Stack


Let's kick off with a basic example. Fire up pry and define the following code:

```ruby
def say_hello
  puts "Enter your name and press ENTER:"
  name = gets
  puts "Hello, #{name}"
end
```

What happens when we evaluate the `say_hello` method?

This small example illustrates 2 fundamental rules of program
execution:

1. An outer method is able to "call into" another method, and it will
wait until the inner method completes before continuing its
execution
2. The inner method is able to generate a value and __return__ it back
to the outer method, which can then access and use it.

As we'll see in this lesson, controlling these 2 behaviors is one of the
main jobs of the stack.
