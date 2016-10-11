---
title: Advanced Enumerables
length: 90
tags: enumerables, ruby, zip, group_by, reduce
---

## Goals
Be able to explain the difference between the Enumerable module and Enumerator class
Understand when and how to use zip, group_by, and reduce appropriately

## Hook

We've looked at a number of enumerables in the past, quite a lot of them, and today we are going to look at some of the tougher enumerables, and we can also look at how we can chain them.

## Basics: Enumerable and Enumerators
Ruby collections (Array, Hash, Range) have access to the [Enumerable](http://ruby-doc.org/core-2.3.1/Enumerable.html) module.
```ruby
array.included_modules
=> [Enumerable, PP::ObjectMixin, Kernel]
```

The Enumerable module gives Array access to many enumerable methods.
```ruby
Enumerable.instance_methods # 54 total
=> [:to_a, :to_h, :include?, :find, :entries, :sort, :sort_by, :grep, :grep_v, :count, :detect, :find_index, :find_all, :select, :reject, :collect, :map, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :first, :all?, :any?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :member?, :each_with_index, :reverse_each, :each_entry, :each_slice, :each_cons, :each_with_object, :zip, :take, :take_while, :drop, :drop_while, :cycle, :chunk, :slice_before, :slice_after, :slice_when, :chunk_while, :lazy]

Array.instance_methods # 184 total
=> [:fill, :assoc, :rassoc, :uniq, :uniq!, :compact, :compact!, :flatten, :to_h, :flatten!, :shuffle!, :shuffle, :include?, :combination, :repeated_permutation, :permutation, :product, :sample, :repeated_combination, :bsearch_index, :bsearch, :select!, :&, :*, :+, :-, :sort, :count, :find_index, :select, :reject, :collect, :map, :pack, :first, :any?, :reverse_each, :zip, :take, :take_while, :drop, :drop_while, :cycle, :insert, :|, :index, :rindex, :replace, :clear, :pretty_print, :<=>, :<<, :==, :[], :[]=, :reverse, :empty?, :eql?, :concat, :reverse!, :shelljoin, :inspect, :delete, :length, :size, :each, :slice, :slice!, :to_ary, :to_a, :to_s, :pretty_print_cycle, :dig, :hash, :at, :fetch, :last, :push, :pop, :shift, :unshift, :frozen?, :each_index, :join, :rotate, :rotate!, :sort!, :collect!, :map!, :sort_by!, :keep_if, :values_at, :delete_at, :delete_if, :reject!, :transpose, :find, :entries, :sort_by, :grep, :grep_v, :detect, :find_all, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :all?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :member?, :each_with_index, :each_entry, :each_slice, :each_cons, :each_with_object, :chunk, :slice_before, :slice_after, :slice_when, :chunk_while, :lazy, :pry, :__binding__, :pretty_print_instance_variables, :pretty_print_inspect, :instance_of?, :public_send, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :remove_instance_variable, :private_methods, :kind_of?, :instance_variables, :tap, :is_a?, :extend, :define_singleton_method, :to_enum, :enum_for, :===, :=~, :!~, :respond_to?, :freeze, :display, :send, :pretty_inspect, :object_id, :method, :public_method, :singleton_method, :nil?, :class, :singleton_class, :clone, :dup, :itself, :taint, :tainted?, :untaint, :untrust, :trust, :untrusted?, :methods, :protected_methods, :public_methods, :singleton_methods, :!, :!=, :__send__, :equal?, :instance_eval, :instance_exec, :__id__]
```

When an array _instance_ uses an enumerable method, the enumerator creates an instance of  [Enumerator](http://ruby-doc.org/core-2.2.0/Enumerator.html) from the array.

```ruby
array = [1,2,3]
=> [1,2.3]

array.each.inspect
=> "#<Enumerator: [1,2,3]:each]>

array.select.inspect
=> "#<Enumerator: [1, 2, 3]:select>"
```

Ruby collections (built in or created by you), can include the Enumerable module and make use of Enumerable methods as long as the class has it's own #each method that Enumerable can use. Each is built into most Ruby collections (Array, Hash, Range), but can also be written by other

Array can also use the `to_enum` method (inherited from the Object class) to transform into a Enumerator.
```ruby
Array.superclass
=> Object
Object.instance_methods
=> [...,to_enum,...]

[1,2,3].to_enum.inspect
=> "#<Enumerator: [1, 2, 3]:each>"
```

If you want to know more about why Ruby is so eager to transform collections to Enumerators, read up on Ruby's `lazy` versus `eager` tradeoffs (for example, Pat Shaughnessy's, ["Ruby 2.0 Works Hard So You Can Be Lazy"](http://patshaughnessy.net/2013/4/3/ruby-2-0-works-hard-so-you-can-be-lazy)).

### Check for Understanding
Write for 3 minutes. What is the difference between the Enumerable module and the Enumerator class? Post your answers to Slack

## zip

We have two arrays. We want to put them together, but how can we do that? We would use the enumerable `zip`. Similar to the way a zipper works: when we zip up a zipper, we tooth by tooth combine a tooth from the left side and a tooth from the right side and then a tooth from the left side and so on until we are all zipped up.

Zip in Ruby essentially shifts an element from the first array and shifts one from the second array and continues doing so until it creates a new array where the first element of this array is an array itself where the first element is the shifted element from the first array and the second element is the shifted element of the second array.

That's complicated so let's just see it in action.

```ruby
a = %w(1 2 3)
b = %w(a b c)

a.zip(b)
=> [[1, "a"], [2, "b"], [3, "c"]]
```

Is that what we expected? (The answer to this should be yes.)

### Check for Understanding
**Challenge #1:** Zip these two arrays together and then print out to the screen this brilliant ditty.

```ruby
chocolate     = [ "Ritual",
                  "Chuao",
                  "Chocolove",
                  "Scharffen Berger"]
peanut_butter = [ "Peter Pan",
                  "Skippy",
                  "Justin's",
                  "Smucker's",
                  "Crazy Richard's"]

"You got your Ritual in my Peter Pan!"
"You got your Peter Pan in my Ritual!"
"You got your Chuao in my Skippy!"
# ...and so on and so forth.
```
**Challenge #2:** Let's practice with some real world data. This is something that you'll often get. Someone writes some pretty poor software, and you get two associated arrays, but you need to actually put it together. People are the worst.

```ruby
people = ["Hannah",
          "Penelope",
          "Rabastan",
          "Neville",
          "Tonks",
          "Seamus"]

houses = ["Hufflepuff",
          "Ravenclaw",
          "Slytherin",
          "Gryffindor",
          "Hufflepuff",
          "Gryffindor"]

"Hannah is in Hufflepuff."
"Penelope is in Ravenclaw."
# ...and so on and so forth.
```

### group_by

We're going to put this idea of people and houses on hold for a second and talk about the greater idea of why we use enumerables. We've done a lot of things with enumerables.

With `.each` we've iterated through a collection and done something with each item. With `.map` we've iterated through a collection, and returned a new collection whose result was what the block returned. With `.find` and `.find_all` we've searched in a collection for something. We can probably say that `.max`, `.min`, `.max_by` and `.min_by` do the same thing, essentially. We're looking for something in a collection, and what we are looking for has certain criteria.

The next step is to start using enumerables to take existing collections and MAKE OUR OWN. `group_by` is a great place to start.

`group_by` takes an array, creates a Hash where the key is the return value of the block, and the value is the item we are currently examining in the enumerable. Let's just repeat that one more time to ourselves slowly. We are creating a HASH, where the KEY is the return value of the block and the VALUE is the item we are currently examining in the enumerable (the element in the collection we're examining).

```ruby
  array = ["dog", "fish", "corgi"]
```

In this example, group_by is going to help create a hash, where the keys are how long the words are, and the values are the actual words. This is what `group_by` DOES.

```ruby
array.group_by { |string| string.length }
=> {3=>["dog"], 4=>["fish"], 5=>["corgi"]}
```

Note that the values in this Hash are all arrays. In this example, when more than one word shares the same length, the words will be held in the array matching the key length they share.

```ruby
array = ["dog", "cat", "fish", "corgi"]
=> {3=>["dog", "cat"], 4=>["fish"], 5=>["corgi"]}
```
This is cool but kind of useless. What else can we do? How about first letters?

### Check for Understanding

**Challenge #1:** Take the `people` and `houses` arrays from the zip example and using group_by, create a hash where the keys are their houses and the values are arrays of their names.

**Challenge #2:** Using group_by on this array (`array = ["aardvark", "art", "airplane", "boy", "burp", "boot", "green", "goop", "super"]`), create a Hash where the keys are the first letter of words, and the values are the list of words that share that first letter.


## reduce/inject

### Preface
Reduce is the Cadillac of enumerables. The power of reduce is that if you really, really understand reduce, you don't have to remember how any other enumerable works. You can recreate its functionality with reduce. That's why reduce is really powerful.

But remember two important lessons I've repeated to you time and time again.

1. Don't be clever. No one likes a clever programmer. No one.
2. Clarity is King. Or Queen.

All this to say that _even if_ you can implement your desired functionality using a single complex reduce statement, opt instead for a couple simple enumerables chained together in a readable, decipherable way.

```
"The era of developers working alone is over.
 Welcome to the communication
age"

- Sarah Mei
(March 3, 2016 via Twitter)
Founder of Railsbridge,
Director of Ruby Central,
Chief Consultant of DevMynd Software.

```

If you EVER write clever code, you will feel a prickling at the back of your neck and that will be me, psychically judging you from afar.

### Using reduce

So let's talk about how to use it. Three pieces:
1) The starting value, which is the starting value of the second item,
2) The first block parameter and is accepted as an argument in reduce/inject, and
3) The third item, the second block parameter.

If you don't want to punch me in the face after that explanation you are a better person than I. Let's explain things by diagramming things out and talking about how this all works.

```
collection.inject(starting_value) { |running_total, variable| block }
```

Now, in practice.
```ruby
array = [1,2,3,4,5]
=> [1,2,3,4,5]

array.reduce(0) { |sum, num| sum += num }
=> 15
```

So, with this general case in mind, we should look at the example with the sum. We pass start to the inject method. Start is the initial value, and if we don't define start or pass anything to inject, its value is the first item over the array we are iterating over. Result is what gets passed when the enumerable is complete. Variable is the variable name we use each time we iterate through the collection, and block is whatever operation we need to perform each time we iterate through.

### Check for Understanding
Summing is easy, but we can also use `reduce` to build other things.

**Challenge #1:** Start with a array of 6 words, and write a `reduce` block that returns a string with the first letter of all the words in the array.

**Challenge #2:** Start with a string of one long word (your choice). Write a `reduce` block that returns a count of all the letters in the word.

**Challenge #3:** Given an array of the numbers 1 through ten, use inject to return an array of even numbers.
