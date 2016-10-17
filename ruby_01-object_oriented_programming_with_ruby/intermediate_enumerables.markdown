---
title: Intermediate Enumerables
length: 90
tags: enumerables,max, min, max_by, min_by, sort_by
---

## Goals
* Understand how to use `max`, `max_by,` their opposites, and `sort_by` 
appropriately.

### Hook

We've got a handle on the beginner enumerables, and you've probably figued out
how to use another few to sort our information. So far, we've learned how to 
create a new collection, and how to search in the selection returning us either
a single item or multiple items.

### min / max

What would we do if we wanted to take the smallest thing out of an array?

Let's think about how we would do that with .each.

```ruby
  def max(array)
    result = array.first

    array.each do |num|
      result = num if num > result
    end

    result
  end

  result ([1,3,2,4,5])
```

That's cool. But there's easier.

```ruby
[1,3,2,5,4].max
```

And what if we wanted to take the smallest? You'd just use .min instead.

Note, that you can use these methods for strings as well as numbers.
Letters have a sort of intrinsic values on their own.

What do I mean? open up a pry session in your terminal and type in,
`"a" > "b"`

We can see that the string, `"a"` is in fact, less than the string `"b"`.

Knowing this we can do some cool things like grabbing the "lowest"
alphabetical string within an array.

```ruby
  ["selena", "carly", "justin"].min
```

This code, here, it'll return us `"carly"`

If we swap out the min for a max, what will we get?

This is normally where we would have you try this on your own, but
I'm not going to insult your intelligence.


### min_by / max_by

Getting the largest value out of an array is all well and good, but life
isn't always that simple. We often deal with complex sets of data.

Imagine we have a class `Person` that has some data stored in instance
variables. Let's just arbitrarily say that it is storing the person's name
and their age.

```ruby
  class Person
    attr_reader :name,
                :age

    def initialize(name, age)
      @name = name
      @age = age
    end
  end
```

 So far, we haven't done anything even remotely exotic. But let's store
 a number of these persons into an array.

```ruby
people = []
people << Person.new("Alice", 24)
people << Person.new("Dave", 26)
people << Person.new("Zayn", 30)

```

We've now got an array of three `Person` objects.

The challenge here is how we can grab the largest or smallest items by
a particular attribute.

So let's walk this process out and look at how we would do this with .each.
It's a lot like how we would implement .max or .min.

```ruby
  def max_by(people)
    result = people.first
    people.each do |person|
      result = person if person.age > result.age
    end
  end
```

This is very similar to our original implementation. The main difference
is that instead of comparing the objects and determing which is "greater
or lesser", we are comparing their attributes to each other.

And so, the max_by enumerable works similarly.

```ruby
  people.max_by do |person|
    person.age
  end
```

We are iterating over the array, looking at each item in the array, looking
at the attribute and then returning the entire object that has the largest
value that we want.

Simply put, to use this enumerable, we just list our criteria for searching
in the block, and the numerable will simply give us the matching object.

We can also grab the first alphabetically here.

```ruby
  people.min_by do |person|
    person.name
  end
```

But we may be overcomplicating things. It doesnt have to be an array of
objects, it can be an array of arrays. We're talking about a collection
of things that might hold more than one piece of data.

So let's simplify the problem.

```ruby
  people = [["Bob", 24],["Dave", 26],["Zayn", 30]]

  people.max_by do |person|
    person[1]
  end
```

Now you try.

```ruby
class Person
  attr_reader :name,
              :age

  def initialize(name, age)
    @name = name
    @age  = age
  end
end

one_direction = []

one_direction << Person.new("Niall", 22)
one_direction << Person.new("Liam", 22)
one_direction << Person.new("Harry", 22)
one_direction << Person.new("Louis", 24)
one_direction << Person.new("Zayn", 23)

```

On paper, Grab me the oldest member of One Direction, and then grab me the first 
alphabetically.

Now check with your work with your neighbor.

### sort_by

There's a theme today, and that's dealing with place.

We've worked on grabbing the largest thing or smallest thing out of a
collection, and that's great. But the next logical step is to sort them.

Essentially, it works very similarly to the enumerable methods that we've
been talking about so far. The main difference is that instead of
returning a single object, it returns an array of sorted objects, sorted
by the criteria that you select IN ASCENDING ORDER.

So let's look at some code.

```ruby
  [2,4,3,1].sort_by do |num|
    num
  end
```

This bit of code will return `[1,2,3,4]`, because it sorts items in
ascending order.

That's a simple array, we can take it to the next level by using
our previous example.

```ruby
class Person
  attr_reader :name,
              :age

  def initialize(name, age)
    @name = name
    @age  = age
  end
end

one_direction = []

one_direction << Person.new("Niall", 22)
one_direction << Person.new("Liam", 22)
one_direction << Person.new("Harry", 22)
one_direction << Person.new("Louis", 24)
one_direction << Person.new("Zayn", 23)

```

Using this, how do you think we can sort by their name alphabetically?

Do this on paper. Check your work with a nearby friend.


### all?

Finally, we are going to take a different tack here.

We're going to look at one of the enumerables that returns a simple true
or false.

Let's look at the name of this enumerable, `all?`. Simply, it's an
enumerable with a conditional in the block. If every item in a collection
returns true when going through the block, it returns `true`. Otherwise,
it will return `false`.

Example:

```ruby
[1,1,1,1].all? do |num|
  num == 1
end
```

This returns `true`.

```ruby
["dog","cat","pig","hippopotamus"].all? do |word|
  word.length == 3
end
```

This would return false.

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
