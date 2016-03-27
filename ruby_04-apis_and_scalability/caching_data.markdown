---
title: Caching Data
length: 90
tags: rails, caching, performance, redis
---

# Caching Data


## Learning Goals

* Discuss differences between Fragment/Template Caching and Data Caching
* Understand how data caching can used to speed up slow computations
* Practice using Redis to store cached data

## Structure

* Discussion: Data Caching Concepts
* Tutorial: [http://tutorials.jumpstartlab.com/topics/performance/caching_data.html](http://tutorials.jumpstartlab.com/topics/performance/caching_data.html)

## Discussion

When adding caching to web applications, we can think of 2 general approaches available:

* Cache the "end result" of a request, thus speeding things up by skipping whatever
  computations would have been required to generate the result.
* Cache the results of the individual computations needed to generate the response, thus
  making it fast to re-generate when needed.

__Fragment Caching -- Approach A__

So far we have looked at Template or "fragment" caching, which falls into the first category. Ultimately
your web application is a fancy apparatus for taking inputs via HTTP and returning
an HTTP Response (generally containing HTML or JSON). Thus caching portions of the HTML or JSON itself
represent caching the "end product". If the HTML you need is already available in a cache, we don't need
to do whatever computations were required to generate it in the first place.

__Data Caching -- Approach B__

Today, we're going to look at another approach which focuses on using caching to speed up individual
computations or pieces of information rather than caching the final chunk of rendered markup.
If your page spends 90% of its time processing 2 expensive methods, we can imagine how much faster
the action would be if we could simply retrieve the results of our expensive methods from a cache.
Even though we may still need to re-render some markup, this is generally quite fast as long as
the required data is readily available.

### When to Data Cache

In order to get a better idea of which situations are well-suited to data caching, let's
think about some of the downsides of Fragment Caching:

* Not very granular (have to grab a whole swath of markup and whatever data is included with it)
* Not applicable to other contexts (sharing data between API and HTML endpoints; sharing data between
  web responses and offline tasks)
* Difficult to "set" data from other contexts (e.g. pre-generating cached data)

The big advantage data caching gives us over caching markup is granularity and specificity.
With data caching its easy to isolate slow actions to the smallest possible context, and then
cache them accordingly. (We'll often cache data at a method level)

Additionally, when caching data, we're working with more general or universal formats -- i.e. Integers,
Strings, Lists/Sets. This is good especially in a larger application because its much more
likely to be re-useable in another context. Your JSON API is not able to get much benefit
from the blobs of HTML cached by your templates. But it _can benefit_ from re-using more general
data cached at an object or method level.

In general, moving our caching to a data layer rather than a view layer gives us more flexibility
to access the data from other contexts.

Want to re-use the cached data between different response
formats or API versions? Simply access the same methods from your appropriate controllers or templates.

Want to make sure your requests never hit a "cold" cache? We could design a system where the application
only Reads from the cache, and there is a separate offline process (often a cron job or background worker)
which refreshes the data on a regular basis. This would be challenging if the offline job needed
to access the application's templates and view-layer logic to render complete HTML, but
if all that is required are simple data types, then it is fairly simple.

Similarly, we could imagine larger architectures with multiple applications reading from the same
data cache (perhaps even from multiple languages or application frameworks).

### What kinds of data are good to cache?

In general we want to be writing the simplest data possible into our caches.
This means:

* Basic data types are best -- integers and strings
* If you need to cache a more complex data structure,
  consider serializing it to JSON and storing the string
  representation

## Your Turn -- Data Caching Tutorial

Now that we've discussed some of the larger concepts behind caching data,
try it yourself with the [Caching Data Tutorial](http://tutorials.jumpstartlab.com/topics/performance/caching_data.html). This tutorial takes us through using Redis as a data cache
to speed up the slow computations on the JSBlogger Dashboard Page.

In this example, we'll see how the Blogger Dashboard is a good
fit for data caching because it involves numerous statistics
that are expensive to calculate but can be represented easily
as simple data (strings or integers) and accessed through
standard method interfaces (`Article.total_word_count`, etc).
