---
title: Advanced Enumerables
length: 90
tags: enumerables, ruby, zip, group_by, reduce
---

## Goals
* Understand how to use zip, group_by, and reduce appropriately


### Hook

We've looked at a number of enumerables in the past, quite a lot of them,
and today we are going to look at some of the tougher enumerables, and we can
also look at how we can chain them.

### zip

We have two arrays. We want to put them together. but how can we do that?
We would use the enumerable `zip`. It's called zip because look at a zipper
that you have either on your jacket or some other piece of clothing you have,
or your bag. When we zip up the said zipper, we see a tooth from the left side
and then a tooth from the right side, and then a tooth from the left side
and so on until we are all zipped up.

How zip works, essentially, is that it shifts an element from the first array
and shifts one from the second array, and creates a new array where the
first element of this array is an array itself where the first element
is the shifted element from the first array and the second element is the
shifted element of the second array.

That's complicated so let's just see it in action.

Let's create an array called `a` and put in it `[1,2,3]`.

Then we create another one called `b` and put in it `["a", "b", "c"]`.

So we use the method by calling it on the first array and sending the second
as an argument.

In this instance, `a.zip(b)`.

Pretty simple.

That code will give us `[[1, "a"], [2, "b"], [3, "c"]]`

Is that what we expected? (The answer to this should be yes.)

Time to practice. I'm going to give you two arrays.

```ruby
  chocolate = ["Ritual",
                "Chuao",
                "Chocolove",
                "Scharffen Berger"]
  peanut_butter = ["Peter Pan",
                    "Skippy",
                    "Justin's",
                    "Smucker's",
                    "Crazy Richard's"]
```

I want you to zip them and then print out to the screen,

```ruby
  "You got your Ritual in my Peter Pan!"
  "You got your Peter Pan in my Ritual!"
  "You got your Chuao in my Skippy!"
```

And so on and so forth.


Now let's practice again with some `real world data`. This is something that
you'll often get. Someone writes some pretty poor software, and you get two
associated arrays, but you need to actually put it together.

People are the worst.

We have two arrays from a form.

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
```

Some jerk left us with two arrays. Take the next few minutes to put them
together and then I would like you to print them out to the screen in this
kind of format:

```
  "Hannah is in Hufflepuff."
  "Penelope is in Ravenclaw."

```

```ruby
  people.zip(houses).each do |name, house|
    puts "#{name} is in #{house}
  end
```

And so forth.


### group_by

We're going to put this idea of people and houses on hold for a second and
talk about the greater idea of why we use enumerables.

We've done a lot of things with enumerables.

With .each we've iterated through a collection and done something with each
item.

With .map we've iterated through a collection, and returned a new collection
whose result was what the block returned.

With .find and .find_all we've searched in a collection for something. We can
probably say that .max, .min, .max_by and .min_by do the same thing,
essentially. We're looking for something in a collection, and what we are
looking for has certain criteria.

So what do all of these have in common? We're doing some ordering,
we're doing some finding, we're doing some copying.

What do you think the next step is?

We are going to start using enumerables to take existing collections and
MAKE OUR OWN.

The first we are going to talk about is group_by.

What this does is that it takes an array and with that array, create a HASH
where the key is the return value of the block, and the value is the item
we are currently examining in the enumerable.

Let's just repeat that one more time to ourselves slowly. We are creating a
HASH, where the KEY is the return value of the block and the VALUE is the
item we are currently examining in the enumerable.

Let's just take a moment to let that sink in and we will move forward with an
example.

Here, we have an array of words.

```ruby
  array = ["dog", "fish", "corgi"]
```

And what we want to do is create a hash, where the keys are how long the
words are, and the values are the actual words. This is what `group_by` DOES.

It will look something like this:

```ruby

  array.group_by { |string| string.length }
```

And this returns us:

```ruby
 {3=>["dog"], 4=>["fish"], 5=>["corgi"]}
```

So as we can see, we have a hash created from an array, where the KEY is
the length of each string, and the contents are an array containing the string.

What do we think happens if theres more than one that meets the criteria?

```ruby
  array = ["dog", "cat", "fish", "corgi"]
```

We would get this:

```ruby
 {3=>["dog", "cat"], 4=>["fish"], 5=>["corgi"]}
```

This is cool but kind of useless.

What else can we do? How about first letters?

```ruby
  array = ["aardvark", "art", "airplane", "boy", "burp", "boot", "green",
            "goop", "super"]
```

Now it's your turn. Take those two arrays from the previous example
and using group_by, create a hash where the keys are their houses
and the values are arrays of their names.


### reduce/inject

Reduce is the Cadillac of enumerables. The power of reduce is that if you
really, really understand reduce, you don't have to remember how any other
enumerable works. You can recreate its functionality with reduce. That's why
reduce is really powerful.

But remember two important lessons I've repeated to you time and time again.

First, don't be clever. No one likes a clever programmer.

Second, Clarity is King. Or Queen.

If you can do it using a single complex reduce statement or a couple of simple
enumerables that you chain together, chain them together.

"The era of developers working alone is over. Welcome to the communication
age"

- Sarah Mei, Founder of Railsbridge, Director of Ruby Central, Chief Consultant
of DevMynd Software. March 3, 2016 via Twitter.

If you EVER write clever code, you will feel a prickling at the back of your
neck and that will be me, psychically judging you from afar.

So let's talk about how to use it. Three pieces. The starting value, which
is the starting value of the second item, the first block parameter, and is
accepted as an argument in reduce/inject, And the third item, the second block
parameter.

If you don't want to punch me in the face after that explanation you are a
better person than I. Let's explain things by diagramming things out and
talking about how this all works.

```ruby
 collection.inject(start) { |result, variable| block }
```

So, with this general case in mind, we should look at the example with the
sum. We pass start to the inject method. Start is the initial value, and if
we don't define start or pass anything to inject, its value is the first item
over the array we are iterating over. Result is what gets passed when the
enumerable is complete. Variable is the variable name we use each time we
iterate through the collection, and block is whatever operation we need to
perform each time we iterate through.


Let's give you an example, and walk through it.

```ruby
  array = [1,2,3,4,5]
  array.reduce(0) { |sum, num| sum += num }

end
```

Let's draw out a chart so we understand what is happening.

Summing is easy but how I like to think of this enumerable is that it builds
other things. What if we had a really crappy code where the secret message is
just the first letter of each word in a sentence? How do you think we would
reduce to create a string made up of the first letters of all of the words in
a sentence?

We can also build a hash. Let's see how we can count the letters in a word.

Finally, on your own, given an array of the numbers 1 through ten,
use inject to just give me an array of even numbers.




