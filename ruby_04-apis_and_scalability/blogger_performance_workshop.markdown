---
title: Blogger Performance Workshop
length: 180
tags: rails, performance, activerecord, sql, caching, redis, memcached
---

# JSBlogger Performance Dojo

### Learning Goals

* Apply the performance techniques we've been discussing to a semi-realistic example application
* Get some experience working with a large seed dataset (750k+ records)
* Use a performance profiling tool (NewRelic) to pinpoint bottlenecks

## Warmup/Setup

For this tutorial, we'll be using the blogger-perf-workshop branch of the JS Blogger
project to practice making performance improvements to a rails
application.

To get started, you'll need to clone the `blogger-perf-workshop` branch of
the JSBlogger project. To do this, follow the instructions in that
branch's [README](https://github.com/JumpstartLab/blogger_advanced/tree/blogger-perf-workshop#blogger-advanced----perf-workshop).

### Caveats before you begin

This branch includes a pre-constructed dataset which populates the DB
with a large amount of records -- 5k authors, 70k articles, 300k+
comments, and 300k+ taggings. This is intended to get us closer to the
sorts of datasets we might see in production systems, and really drive
home the impact of SQL/AREL techniques like using indices and avoiding
n+1 queries.

As it stands, the performance of the app is __seriously__ bad. You'll
likely find that several of the pages won't even finish rendering in
less than 30-60 seconds.

So it is going to take a lot of work to whip the thing into shape.

But fear not, noble optimizers! You're up to the challenge.

Dig in and remember the key tenets of performance optimization work:

* Go after the biggest wins first
* Make decisions based on data / benchmarks
* Consider which optimizations will improve specific operations in the
  app VS which might have a "halo effect" to other parts of the app.
  (e.g. caching a chunk of markup vs adding a db index)

## Intro -- Caching Crash Course

"Caching" is an optimization technique involving saving the result of
some computation so that it can be re-used later. Usually we do this
because the computation is expensive in some way (perhaps in terms of
time, bandwidth, memory consumption, etc).

Caching can often provide an "easy way out" of certain optimization problems,
since when you cache something you don't necessarily make it faster,
you simply make it happen less often.

Within this project we'll likely want to cache 2 types of information:

1. Chunks of rendered HTML (we often call this fragment or markup caching since we're
caching fragments of markup)
2. Small bits of "expensive" data (we often call this data caching since...data)

Markup caching is almost always done in view templates and data
caching in our models or other "backend" ruby classes.

Markup caching is quite easy, simply wrap some chunk of HTML
in a cache block and voila:

```
<% cache do %>
  <h1>hi there this will be cached</h1>
<% end %>
```

Sometimes, you'll need to specify an optional cache key to
differentiate your cached markup from other cached markup:

```
<% cache("article-#{params[:id]}") do %>
  <h1><%= @article.title %></h1>
<% end %>
```

Caching data is also straightforward and is done using
the `Rails.cache` interface:

```
class MySweetModel
  def self.my_slow_business_intelligence_method
    Rails.cache.fetch("top-daily-rev") do
	  calculate_top_daily_revenue
    end
  end
end
```

Things that make a good fit for data caching include:

* Ids or slugs of specific data entities ("most popular article", "most
  frequently read author", etc)
* Small JSON payloads describing important or expensive-to-generate data
* Sets or collections of data ("ids of all articles for a tag", etc --
  read up on some of redis' set-manipulation features if you find
  yourself doing this frequently)

__Pull-Through Caching__

In both of these examples we are exploiting the cache's
ability to "pull through" any results that are uncached.
That is, when we use the `cache` template helper or the
`Rails.cache.fetch` method, the cache will first look to
see if the specified key has data in it. If so, it will
simply return that data.

If not, the cache will evaluate the provided block, store
the result in the provided key, and then return it back to
you. This way next time you need to look up the same value,
it will already be present in the cache.

## Optimization Walkthrough

Now that we have some scant basics under our belt, let's see
what we can do to tame this unruly beast.

### Step 1 -- Articles#show

This is the only page of the app that isn't completely dying, so let's
start here. For me this page is generally rendering between 150 - 250
ms.

This is not bad but let's see if we can get it under 100ms. This
shouldn't be too difficult and can likely be accomplished with one or
more of the following techniques:

* DB indices on one or more of the foreign keys we're using
* AREL Includes to save an extra query or 2
* Counter Cache for comment counts

### Step 2 -- Articles#Index

Now things will start to get more interesting. For me this page is
completely un-usable at the moment, and it will take a good bit of work
to even get it "under control" to the point that we can start doing more
refined optimizations.

For starters, try to think about what, in general, is making the page
slow. There are likely a number of culprits, but ultimately even with
some clever DB optimizations in place, we likely just have too much data
to be rendering all of the articles on a single page.

So for starters, look for ways to cut down the number of articles we're
rendering on each `GET /articles` request (hint hint: pagination...).

Then you should be able to look at some more fine-grained tweaks to the
page as well. This one may be more challenging than `Articles#show`, but
try to get it rendering under 200ms.

### Step 3 -- Dashboard#show

Similar to Articles#index, this page will likely be unusable to start
with. However the major problems we need to address will likely be slightly different
in nature -- While the Index needed to churn through a huge number of
articles in a repetitive fashion, the dashboard needs to ingest data
from across the application's schema in order to produce some
statistics.

As such we'll likely need to use a combination of clever query
optimizations and data or markup caching to get this page under control.

This page is probably the hardest one of the 3, but see if you can get
it to render in under 300ms (ideally without just markup-caching the
whole thing...)

__Hint:__ One useful technique for dealing with pathologically slow
pages can be to just comment out big chunks of the markup to start.
When a page takes over 30 seconds to render it can be really challenging
to even make progress.

By temporarily removing large chunks of logic from the rendering flow,
we can gradually improve the performance of the page by focusing on
smaller pieces at a time.
