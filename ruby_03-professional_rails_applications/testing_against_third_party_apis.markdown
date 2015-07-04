---
title: Testing Against Third Party APIs
length: 90
tags: apis, testing, controller tests, rails, VCR
---

## Testing Against 3rd Party APIs

As we build more and more sophisticated web applications, we'll
frequently want to make use of data we don't control. Generally this
data is provided to us by som 3rd party company or organization via
a public-facing API on the web.

While it's great to get access to all this data so easily, it can
sometimes create headaches for our test suite.

### 3rd Party API Testing Problems

Let's consider a few difficulties when testing around a 3rd party
API:

* Speed -- even a "fast" API will still generally have latencies in the
10s of milliseconds, which can slow our tests down
* Rate Limits -- We may be using an API which limits the volume of our
usage. We certainly don't want to waste these requests on repetitive test
queries
* Repeatibility -- The data on many endpoints will change over time. This will
cause problems if our tests are designed around 1 set of data but the API
starts providing something different. We'd like it to be consistent and repeatable.
* Network Tolerance -- Our test suite should be isolated to our machine and
shouldn't be affected by network outages. This won't be the case if we're utilizing a real API
in the test suite.


### Solutions

There are a few common solutions we might take for these issues:

* Stubbing -- often we can use in-process stubbing libraries to replace our API
queries with canned, static responses that will be fast and reliable
* Network-level Mocking -- sometimes we might want to capture the whole
network response. Fortunately there are tools like VCR available for this.

### Materials

* [Alternative Lesson Plan](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/mocking_apis_v2.markdown)
* [Code-a-Long Notes](https://www.dropbox.com/s/3afogbj3qwuptj8/Turing%20-%20Testing%20an%20External%20API%20%28Notes%29.pages?dl=0)
* [Alternative Code-a-Long](https://www.dropbox.com/s/3x1vfhu9wdx2juj/Turing%20-%20Revisiting%20Testing%20an%20External%20API.pages?dl=0)
