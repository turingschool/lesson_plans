---
title: Intro to Caching in Rails
length: 90
tags: rails, caching, performance
---


## Structure

## Learning Goals

* Understand caching as a performance optimizaiton tool
* Practice analyzing our applications to identify performance problems
* Practice using Rails' built-in caching facilities


## Discussion -- What is Caching?

Frequently as developers we'll run into situations when we need to make
something in our programs faster.

With user-facing web applications, especially, we're relatively constrained
by a request/response cycle that needs to be kept fast -- anything over about 200ms
starts to feel slow or clunky to the user.

So we need to make something faster. We have a couple of choices:

* __1:__ Speed up the underlying process
* __2:__ Simply (part of) the underlying process go away (some of the time)

When looking at the list it seems like a no-brainer -- just choose number 1, make
your things fast, and then the problems go away!

Unfortunately it turns out that #1 is often pretty hard. In fact in some situations
it may be actually impossible (see NP-Completeness).

So often in application development we turn to choice 2 -- caching.

## Ok but what actually is caching

In short, caching is a technique of saving the results of some computation so that
we can retrieve it later without having to re-do the calculation.

To a certain extent, caching is a "non-optimizing optimization" -- we don't actually make
the underlying pieces any faster, but we make the application __seem__ faster by limiting
our usage of the slow pieces.

Let's look at a simple example in ruby using a hypothetical pizza store:

```ruby
class PizzaShop
  def make_me_a_pizza(type)
    puts "cooking up your #{type} pizza"
    sleep(3)
    "One tasty #{type} pizza"
    end
end

PizzaShop.new.make_me_a_pizza("anchovy")
cooking up your anchovy pizza
# (dramatic pause)
=> "One tasty anchovy pizza"
```

As we can see, the pizza production process is currently pretty slow.
Perhaps our pizza chefs are dozing on the job. Let's see if we can speed it up
with a cache:

```ruby
class PizzaShop

  def pizza_cache
    @pizza_cache ||= {}
  end

  def make_me_a_pizza(type)
    puts "cooking up your #{type} pizza"
    #first, check if this type of za is in the cache:
    if pizza_cache[type]
      pizza_cache[type]
    else
      sleep(3)
      cooked_pizza = "One tasty #{type} pizza"
      pizza_cache[type] = cooked_pizza
      cooked_pizza
    end
  end
end

shop = PizzaShop.new
shop.make_me_a_pizza("anchovy")
cooking up your anchovy pizza
# (dramatic pause)
=> "One tasty anchovy pizza"
shop.make_me_a_pizza("anchovy")
cooking up your anchovy pizza
# (instantaneous)
=> "One tasty anchovy pizza"
```

Let's talk through it. We've inserted a cache in the pizza-production-pathway.
The first time someone requests a pizza of a specific type, we still have the same
3-second delay. But after we make that pizza the first time, we store it.

After that, subsequent requests for the same pizza type can be served instantly.

### Caching Limitations

Let's think about some of the limitations of our trivial cache example:

* What happens if we request a different pizza type?
* What happend if we make a new pizza shop?
* What happens if we change the underlying technique of making a pizza?

It's important to remember that while caching is a very useful technique,
it does have limitations.

### Discussion - Caching in Rails?

What sorts of things might we want to cache in a Rails app?

Fortunately this is such a common use-case that Rails includes built-in support
for it via the cache helper. Let's take a look.

## Workshop -- Caching in Rails

For this exercise we'll use the storedom repo. Get set up with it via the
ever-familiar process:

```
git clone https://github.com/turingschool-examples/storedom caching_strategies
cd caching strategies
bundle
rake db:drop db:setup
```

__Demo -- looking for performance bottlenecks__

_Observe while I run through the app and talk about looking for problems_

Looks like we got some issues in the `Items#index` action. Let's cache it

__Step 1 -- enable caching in development__

(by default rails turns off caching in development, so let's turn that on)

In `config/development.rb`, update the setting `config.action_controller.perform_caching` to:

```
  config.action_controller.perform_caching = false
```

(Don't forget to restart your server after making this change)

__Step 2__ -- cache those items

Let's head over to the Items#index template (`app/views/items/index.html.erb`) and add some caching.
Again, rails anticipates this very common use-case, so they give us a helper to make it as easy
as possible. The caching helper looks like this:

`cache { "some work to generate the cached data" }`

The cache helper will look to see if the thing you are requesting has already been done. If so, it will serve
the result to you immediately. If not, it will generate it (using the provided block), and save the result in
the cache.

__Demonstration -- Items.all query disappears from logs__


__Step 2__ -- Items count

We got rid of the `SELECT items.* from items` query by caching the item rendering, but we're still seeing
a count query for displaying the number of items.

Let's fix that one by adding a second cache block around the item header. Your template will look something
like this:

```
<div class="container">
  <% cache do %>
  <div class="row">
    <div class="col-sm-12">
      <h1><%= @items.count %> Items</h1>
    </div>
  </div>
  <% end %>
  <div class="row"></div>
  <% cache do %>
  <% @items.each do |item| %>
    <div class="col-sm-3">
      <h5><%= item.name %></h5>
      <%= link_to(image_tag(item.image_url), item_path(item)) %>
      <p>
        <%= item.description %>
      </p>
    </div>
  <% end %>
  <% end %>
</div>
```

Refresh the page to see what you've done.

__Holy duplicating counts, batman!__ We did get rid of the additional count query. But now our page is all
messed up.

What's missing here is a __cache key__. We're storing different pieces of data in our cache, and we need a way
to differentiate them.

__Cache Keys -- Unlocking the Path to Greatness__

We'll talk more about cache keys in a future lesson, but for now, think back to the `PizzaShop` example from above.
In that case the "pizza type" we were providing was serving as a "key" -- a way of matching the specific piece of
information we requested with what had already been stored in the cache.

If we didn't use pizza types to label the data in the cache, a user might come in asking for "pepperoni" pizza and
get back "anchovy and blue cheese". Which is effectively what's happening in our current example.

# TODO -- add initial "mistake" (caching same data)
# Use controller/action/suffix identifiers to make cached data more specific

__Step 3 -- Differentiateing Cached Data With Keys__

Fortunately Rails anticipates our need again here. In addition to the block we already provided to the cache helper,
we can give it an optional "key" to tell how to differentiate _this specific_ chunk of cached data.

```
<% cache "items#index" do %>
<div class="container">
  <div class="row">
    <div class="col-sm-12">
      <h1><%= @items.count %> Items</h1>
    </div>
  </div>
  <div class="row"></div>
  <% @items.each do |item| %>
    <div class="col-sm-3">
      <h5><%= item.name %></h5>
      <%= link_to(image_tag(item.image_url), item_path(item)) %>
      <p>
        <%= item.description %>
      </p>
    </div>
  <% end %>
</div>
<% end %>
```