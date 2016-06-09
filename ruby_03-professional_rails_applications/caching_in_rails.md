---
title: Intro to Caching in Rails
length: 180
tags: rails, caching, performance
---


## Structure

* 25 mins -- Start Discussion: What is Caching?
* 5 mins -- break
* 15 mins -- finish Discussion and IRB demo
* 10 mins -- Start Caching workshop
* 5 mins -- break
* 25 mins -- Workshop
* 5 mins -- break
* 25 mins -- Workshop, cont.
* 5 mins -- break
* 25 mins -- Workshop, cont.
* 5 mins -- break
* 25 mins -- Finish workshop and wrap-up


## Learning Goals

* Understand caching as a performance optimization tool
* Practice analyzing our applications to identify performance problems
* Practice using Rails' built-in caching facilities


## Discussion -- What is Caching?

Frequently as developers we'll run into situations when we need to make
something in our programs faster.

With user-facing web applications in particular, we're constrained
by a request/response cycle that needs to be kept fast -- anything over about 200ms
starts to feel slow and clunky to the user.

So we need to make something faster. We have a couple of choices:

* __1:__ Speed up the underlying process
* __2:__ Figure out a way to get rid of the underlying process (at least some of the time)

When looking at the list it seems like a no-brainer -- just choose number 1, make
your things fast, and then the problems go away!

Unfortunately it turns out that #1 is often pretty hard. In fact in some situations
it may be actually impossible (see [NP-Completeness](https://en.wikipedia.org/wiki/NP-complete)).

So often in application development we turn to choice 2 -- caching.

## Ok but what actually is caching

In short, caching is an optimization technique focusing on
saving the results of a computation so that we can retrieve it again later
without having to re-do the original calculation.

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
Perhaps our pizza chefs are napping on the job. Let's see if we can speed it up
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
* What happens if we make a new pizza shop?
* What happens if we change the underlying technique of making a pizza?

It's important to remember that while caching is a very useful technique,
it does have limitations.

### Discussion - Caching in Rails?

What sorts of things might we want to cache in a Rails app?
(try to list at least 4 common sources of performance problems in a typical web app)

Fortunately this is such a common use-case that Rails includes built-in support
for it via the cache helper. Let's take a look.

## Workshop -- Caching in Rails

For this exercise we'll use the storedom repo. Get set up with it via the
ever-familiar process:

```
git clone https://github.com/turingschool-examples/storedom caching_strategies
cd caching_strategies
bundle
rake db:drop db:setup
```

__Demo -- looking for performance bottlenecks__

_Observe while I run through the app and talk about looking for problems_

Looks like we got some issues in the `Items#index` action. Let's cache it

### Step 1 -- enable caching in development

(by default rails turns off caching in development, so let's turn that on)

In `config/environments/development.rb`, update the setting `config.action_controller.perform_caching` to:

```ruby
  config.action_controller.perform_caching = true
```

(Don't forget to restart your server after making this change)

### Step 2 -- cache those items

Let's head over to the Items#index template (`app/views/items/index.html.erb`) and add some caching.
Again, rails anticipates this very common use-case, so they give us a helper to make it as easy
as possible. The caching helper looks like this:

`cache { "some work to generate the cached data" }`

The cache helper will look to see if the thing you are requesting has already been done. If so, it will serve
the result to you immediately. If not, it will generate it (using the provided block), and save the result in
the cache.

__Demonstration -- Caching `Item.all` render loop__

* Wrap item iteration block in template in a cache block
* Reload the page twice to demonstrate the `Items.all` query disappearing from the logs
* __Question:__ Why does the query only disappear the _second_ time we load the page?

### Step 3 -- Items count

We got rid of the `SELECT items.* from items` query by caching the item rendering, but we're still seeing
a count query for displaying the number of items.

Let's fix that one by adding a second cache block around the item header. Your template will look something
like this:

```erb
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
messed up. It's rendering the count information twice in place of the list of items.

What's missing here is a __cache key__. We're storing different pieces of data in our cache, and we need a way
to differentiate them.

__Cache Keys -- Unlocking the Path to Greatness__

We'll talk more about cache keys in a future lesson, but for now, think back to the `PizzaShop` example from above.

In that case the "pizza type" we were providing was serving as a "key" -- a way of matching the specific piece of
information we requested with what had already been stored in the cache.

If we didn't use pizza types to label the data in the cache, a user might come in asking for "pepperoni" pizza and
get back "anchovy and blue cheese". Which is effectively what's happening in our current example.

### Step 4 -- Differentiating Cached Data With Keys

Fortunately Rails anticipates our need again here.

By default the `cache` helper caches data by
controller action. That is, the current controller and action are used as the key. However, we
often will want to cache multiple different things per action. To do this, we need to give
some additional, optional parameters to the `cache` helper, like so:

```ruby
<div class="container">
<% cache(action: "index", action_suffix: "items_count") do %>
  <div class="row">
    <div class="col-sm-12">
      <h1><%= @items.count %> Items</h1>
    </div>
  </div>
<% end %>
<% cache(action: "index", action_suffix: "items_list") do %>
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
<% end %>
</div>
```

Refresh the page and you should see it rendering correctly again. Additionally, check
your server logs to see that the server is now reading and writing 2 distinct fragments.

Caching different portions of the page individually like this is often referred to as "fragment caching"

#### Cache Keys -- Alternate API

Sometimes explicitly providing an "action" and "suffix" label
can be a bit tedious. Fortunately the `cache` helper also
accepts a simple string as a key (similar to our pizza example).

So alternatively, we could have written our cache keys like this:

```ruby
<div class="container">
<% cache("items-count") do %>
  <div class="row">
    <div class="col-sm-12">
      <h1><%= @items.count %> Items</h1>
    </div>
  </div>
<% end %>
<% cache("items-list") do %>
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
<% end %>
</div>
```

Just remember -- the burden is on us as the developer to make sure
these keys are properly unique. Otherwise we'll be right back
where we started with duplicated pieces of markup showing up
in the wrong places.

And keep in mind that cache keys are shared over the entire application. So if we have something called "items-list" on our index page
as well as something called "items-list" on our show page, they _will_ collide. This can be a very frustrating source of bugs.

## Your Turn -- Caching Order Count and Orders List

Apply the same techniques we just used on Items#index to Orders#index

* Load the page and observe what's going on in your server logs. Especially pay attention
  to the response time and any SQL queries that are being executed
* Use the `cache` helper to individually cache the count and list of orders. Make sure
  to use the `action` and `action_suffix` parameters to differentiate your fragments.
* Once you're done, reload the page and watch for differences in the log output. You should
  see fewer SQL queries and probably also a small improvement in response time.


### Step 5 -- Cache Invalidation

_Demo_ - Observe as I demonstrate the flaws in our current setup by making items

We're caching the markup for displaying all of our items, but what happens
when a new item is created?

At the moment...nothing. The cached data is still
valid as far as the cache is concerned, so it continues to display it even though
it's now inaccurate.

What we need is a mechanism to invalidate the cached markup when the underlying data
(in the database) changes. One easy place to do this would be in model callbacks.

Consider the times when our overall collection of Items might change:

* An item is created
* An item is saved
* An item is destroyed

Let's practice using them in our Item callbacks to expire the related fragments.

In `app/models/item.rb`:

```ruby
  after_create :clear_cache
  after_save :clear_cache
  after_destroy :clear_cache

  def clear_cache
    Rails.cache.clear
  end
```

Reload console code, create an item, load the items index, and you should see that the count and items
list are both updated to reflect the new item.

## Your Turn -- Order Cache Invalidation

Create a new order, reload the Orders#index, and see if your markup updates (it should not).

Apply the same techniques we used with Items to the Order model. Add `after_create`, `after_save`, and `after_destroy`
callbacks to clear the cache.

Once you're done, verify that loading the Orders#index after creating, updating, or destroying a new order
updates the markup appropriately.

### Step 6 -- Cache Invalidation: A Better Way

__Discussion__ - Can you think of any problems with our current approach to invalidating the cache?

__Solutions__: It would actually be cleaner if we could have the cache somehow update itself based
on the underlying data.

To do this, we'll actually want to look at another caching mechanism -- using an explicit cache key.
Using an explicit key requires a bit more forethought, but it gives us more control over the expiry
conditions.

Furthermore, it can give us a cleaner solution than having to manually expire cache fragments
from within our models (which shouldn't be concerned with things like caching in the first place).

__Discussion__ - Let's think about what information might be useful for generating a cache key for
our list of items.

Ultimately we can infer whether there have been any item updates based on these pieces of information:

* The maximum "updated_at" timestamp across all items
* The count of all items

Let's change our
the caching implementations in our view templates to use this approach:

In `app/views/items/index.html.erb`:

```ruby
<div class="container">
  <% cache "items-count-#{Item.count}-#{Item.maximum(:updated_at)}" do %>
  <div class="row">
    <div class="col-sm-12">
      <h1><%= @items.count %> Items</h1>
    </div>
  </div>
  <% end %>
  <div class="row"></div>
  <% cache "items-list-#{Item.count}-#{Item.maximum(:updated_at)}" do %>
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

__Discussion__ -- Talk about explicit/manual cache keys.

Are there any tradeoffs involved in this approach? What
are the potential downsides?

* We're incurring a higher cost now whenever we want to check
the cache key (since we have to first check the count and max timestamp of the items)
* In exchange for this penalty, we get more accurate cache updating without having to include manual expiration callbacks
elsewhere in our code.
* On the other hand, the manual expiration approach allows
us to achieve faster _reads_ in exchange for clunkier _writes_

As with everything in software development, we simply have to weigh these pros and cons to decide which tradeoff is more worthwhile.

In some situations, it may be perfectly fine to _not explicitly update the cache at all_. Instead, we might simply say "let this cache expire after 30 minutes", regardless of what data changes
may have taken place.

__One More Thing -- Refactoring With a Cache Key Helper__

It's kind of a drag to have this string interpolation for generating the cache keys
just hanging out in our templates. Let's use a helper to pull it out:

(In `app/helpers/application_helper.rb`)

```ruby
module ApplicationHelper
  def cache_key_for(model_class, label = "")
    prefix = model_class.to_s.downcase.pluralize
    count = model_class.count
    max_updated = model_class.maximum(:updated_at)
    [prefix, label, count, max_updated].join("-")
  end
end
```

And now we can use that helper in our template instead of interpolating things in-place:

(In `app/views/items/index.html.erb`):

```ruby
<div class="container">
  <% cache cache_key_for(Item, "count") do %>
  <div class="row">
    <div class="col-sm-12">
      <h1><%= @items.count %> Items</h1>
    </div>
  </div>
  <% end %>
  <div class="row"></div>
  <% cache cache_key_for(Item, "list") do %>
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

## Your Turn: Key-Based Expiration for Orders

Take the techniques we just used to move Items#index from manual expiration
to key-based expiration. Additionally, tidy up the remaining bits of code
we left around from `Item`:

* Use the `cache_key_for` helper to generate explicit cache keys for the 2 cached
  fragments in Orders#index
* Remove the associated cache callbacks from `Item` and `Order`
* Make sure that things are still updating properly when you create or update
  an order.

## Next Steps -- If you finish all of the steps above, consider the following challenges

* Russian-doll caching: Currently we're caching all of the items and orders as a single blob.
  Can you update your solution to cache the records as a group _as well as_ each individual
  record by itself? Refer to [this section of the Rails guides](http://guides.rubyonrails.org/caching_with_rails.html#fragment-caching)
  to get started.
* Dependent update -- Currently we're expiring the order display when an order is updated,
  but what would happen if an item associated with an order was updated (perhaps it changes
  its name)? At that point the order listing would be incorrect. Fortunately ActiveRecord
  gives us a `touch` option on `belongs_to` associations to help in this situation. Consult
  [this section](http://guides.rubyonrails.org/association_basics.html#touch) of the Rails Guides
  to see how it works. Add this to your Item<->Order association to get order display to update
  when a relevant item is updated.
* A different storage mechanism: We haven't really touched on the question of where the
  cached data is stored. By default rails actually uses the file system to store cached
  data. Can you update it to use Memcached instead? You'll want to use [this section](http://guides.rubyonrails.org/caching_with_rails.html#activesupport-cache-memcachestore)
  of the Rails guides as well as some googling to get started. Some of the issues
  you'll need to address include: installing memcached (via brew); using the dalli
  gem to access it; configuring rails to use memcached as its cache store.
