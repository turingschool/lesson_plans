---
title: Load Testing and Production Performance Monitoring
length: 180
tags: performance, benchmarking, capybara
---

In this lesson / tutorial we'll cover various reasons for wanting
to simulate additional load against an application. We'll then walk
through an example using some familiar tools.

## Learning Goals

* Understand the reasons for load testing Rails applications
* Practice writing scripts to simulate load against an application
* Understand the differences between elapsed time from the perspective
  of your application's code as well as from the perspective of the client
* Understand the concepts of request queueing and server overload

## Lecture

### Warmup/Discussion

So, what even is load testing?

Dealing with performance issues in our applications can be thorny.
Most developers will agree that performance is important -- but
how exactly do we know which components of our applications will prove problematic
from a performance perspective?

Sometimes there are common practices or "rules of thumb" we can fall back on --
don't write N+1 queries; don't write a loop within a loop; add database indices
on commonly-queried columns; etc. But as our applications get more complex, the
performance problems we encounter will inevitably become less obvious and more
challenging to optimize. Two (or more) operations might be totally fine in isolation, but
create problems when combined.

To make matters worse, many performance problems won't reveal themselves until
we reach a certain thresholds of scale. Something which runs snappily on your
development machine may come to a screeching halt when confronted with a larger
database or higher request throughput.

It turns out that our best line of defense against problems that only arise
in a "production" context is...to _simulate_ that context. And this is effectively
what load testing is about. In this lesson we'll look at some techniques for simulating
heavier usage patterns so that we can identify the performance issues that arise from
these contexts.

### Usage Patterns: Production vs. Development

When considering the performance of an application, it's helpful to think about
what its usage profile looks like: in what ways is it being used, how frequently,
by how many people, etc.

Consider the usage profile of an average student application:

* Few users (possibly 1 or 2 at any given time)
* Sporadic requests (often long gaps between requests)
* Generally exercising single portions of an application at a time
* Few or no simultaneous database queries

With this sort of a usage pattern, it will be difficult to reproduce the sort
of performance issues which will arise in a production, scaled environment.

What sort of characteristics would we expect from a (scaled) production application?

* Many users (10s, 100s, 1000s using the application concurrently)
* Constant requests (server receives little "down-time")
* Exercising full breadth of application (e.g. admin users and "browsers" and "purchasers"
  all using the app at once; perhaps api/native clients as well)
* Heavy simultaneous database usage (potential query bottlenecks)
* Potentially "spikey" usage patterns (numerous requests between certain hours, slower at other times)

### Simulating Load

With those ideas in mind, how can we simulate load against our early-stage application
that might help us anticipate or reproduce problems of scale?

#### Desirable Characteristics of a Scale Simulation Tool

What would we want out of our ideal load simulation tool? A few ideas come to mind:

* Ease of use (nice API)
* Ability to simulate multiple, complex user "flows" (signing up, placing an order,
  admin functionalities, data entry, etc)
* Ability to "scale out" load (i.e. simulate multiple users)

It turns out that there's a tool you've been using for some time which fits these characteristics
quite well: __Capybara__, everyone's favorite giant rodent.

We have used capybara to "script" usage of our applications in a test environment,
but it can script usage of a production or development environment just as well. Using this technique, we will think of our capybara script as a simulated "user" which navigates around our site quickly and repeatedly as we instruct it.

In the following tutorial, we'll look at:

* Writing Capybara scripts to "load test" the Blogger example application
  in a production environment
* Using threads to "scale up" the load against our server
* Using Skylight.io, a production metric service, to monitor how our application
  behaves under load.

## Code Along

### Step 1: Setup

To get setup, let's follow a familiar ritual. Clone, bundle, and setup the blogger_advanced
application. Note that we're using a branch of the application configured to use PostgreSQL
as its database:

```shell
git clone git://github.com/JumpstartLab/blogger_advanced.git load_testing_workshop
cd load_testing_workshop
git checkout -t origin/postgres
bundle
rake db:setup
```

#### Production Setup

This should get everything setup. To verify, run the tests with `rake` before continuing.

Our application should now be good to go in our development environment.
But remember that we're interested in monitoring how our application
performs under load in a _production_ environment.

To that end, let's set it up to run on Heroku
(Note: We're deploying a non-master branch to Heroku in this case):

```shell
heroku create
git push heroku postgres:master
heroku run rake db:migrate db:seed
```

Verify this worked by opening the app: `heroku open`.
Your eyes should be embraced by the familiar,
and—frankly—quite lovely, Blogger interface.

#### Metrics Service

One more piece of setup remains. In a few moments we're going to be hurling requests at our
production instance of JSBlogger. To see how it handles the load, let's install Skylight.io,
a production performance metrics service:

```shell
bundle exec skylight setup
```

You'll be prompted for the __email__ and __password__ associated with your Skylight account. If
you have not created a Skylight account before, visit [https://www.skylight.io/](https://www.skylight.io/)
to sign up. We'll be using a free tier of the service, so you won't have to enter any payment information.

This step creates a new configuration file, `config/skylight.yml`, which you'll need to commit
and push to Heroku. Don't forget to push the `postgres` branch which we're using.

If everything went well,
you should be able to visit [https://www.skylight.io/app/applications](https://www.skylight.io/app/applications)
and see your application. It probably won't be reporting any traffic yet, but we'll fix that next.

### Step 2: Fake Users Everywhere

Now that we have our application deployed, let's practice exercising the application
in an automated fashion. In this section, we'll see that Capybara is a pretty handy
tool for navigating the web -- and it's not limited to use in test suites!

Fire up a rails console, and create a new Capybara session:

```rb
Loading development environment (Rails 4.1.10)
irb(main):001:0> session = Capybara::Session.new(:selenium)
=> #<Capybara::Session>
irb(main):009:0> session.visit(<YOUR-PRODUCTION-URL-HERE>)
=> ""
irb(main):011:0> session.first("li.article a").click
=> "ok"
```

Holy automated browser sessions, batman!

If things are working, you should see a browser window (probably Firefox)
spring into life and start navigating the site. This happens because
we're using Capybara's selenium driver, which is an interface for
driving a real web browser with Capybara.

### Step 3: More Scripting

This is starting to get more exciting, but entering commands manually via the
console is not much better for producing heavy server load than clicking around
manually via a web browser.

What's the simplest server load script we could write? How about a loop?

Let's try it in console:

```rb
irb(main):001:0> session = Capybara::Session.new(:selenium)
=> #<Capybara::Session>
irb(main):002:0> loop do
irb(main):003:1* session.visit(<YOUR-PRODUCTION-URL-HERE>)
irb(main):004:1> session.all("li.article a").sample.click
irb(main):005:1> end
```

Now, your Firefox session should be going crazy with constant requests.
This little loop allows us to simulate a single, simple path through
the application -- a user visits the root url, selects a random article,
then repeats these actions over and over.

Leave the loop running and head back to your Skylight interface. This
time you should start to see some more robust traffic.

### Step 4: Load Testing "User Scripts"

It turns out that real users don't just repeatedly loop through
2 pages on our site. They follow reasonable and varied
patterns of usage through the application. When load testing, we'll
want to anticipate these patterns and try to mirror them so that our
tests are representative of what the application's real usage
patterns look like.

Here are some things to consider when designing a load testing script:

* Are there distinctive "Funnel" flows (e.g. user hits main page, views product, checks out)
* What are the application "entry points"? Do most users start from a single root
page? Are they coming in to a large variety of "leaf" pages via search engines?
* "Hot" pages: which pages generate the most traffic?
* Important/Priority pages -- are there any pages crucial to the
  operation of the business (e.g. order creation, account status, etc)
* Average session length (how many pages does the average user visit before leaving)?

#### Creating User Scripts

With these ideas in mind, take 10 minutes and jot down some ideas
for good "User Scripts" that might represent an average user's
interaction with the Blogger application.

Try to come up with 3-4 ideas for scripts, at least 1 of which involves
data entry (for example creating a comment or article). A simple example might look like:

* User visits homepage
* User views an article

It's ok if some pages are more heavily represented than others, and if
some flows are longer or more complex than others. For example, one very
simple flow might include going directly to an article page. While
a more complicated one might include browsing several articles and
entering a comment.

### Step 5: Turning our Simple Loop into a Reuseable Script

We'd like to be able to load-test our app repeatably and at-will,
so we'll want a more persistent interface to doing so. For now,
let's use a rake task to hold our script.

Create a rake task for load testing at `lib/tasks/load_test.rake`. The
basic structure for a rake task should look something like this:

```rb
desc "Simulate load against Blogger application"
  task :load_test => :environment do
end
```

Using this structure, __move the basic loop script from our console session
earlier into this Rake task__.

Try running it with `rake load_test` and verify that you see the same browser
behavior as before.

### Step 6: Refactoring

Before we continue, take a quick refactoring pass at our script --
extract the code from our rake task into its own method. The
only code within the task should then be executing this method.

### Step 7: More Users, Cap'n!

You know what's cooler than an automated user mindlessly
looping through two URLs on your site? _Several_ mindless automated users.

Let's use threads to simulate more users. Take the method you extracted
in the previous step and wrap it in some threads:

```ruby
desc "Simulate load against Blogger application"
task :load_test => :environment do
  4.times { Thread.new { browse } }
end

def browse
  session = Capybara::Session.new(:selenium)
  loop do
    session.visit("https://evening-temple-1086.herokuapp.com/")
    session.all("li.article a").sample.click
  end
end
```

Hmmmm. That wasn't very effective.

One tricky thing with threads is that since they represent an independent,
asynchronous execution context, there's nothing for the main thread
to do once it has dispatched the other threads. Thus, it exists, and our
script ends. We need a way to keep the main thread alive, waiting on
the other threads to finish their work.

A common technique to fix this is using `Thread#join` -- this tells
the main thread to "wait" until the joined thread finishes its work.

In our case, the "worker" threads are simply looping, so joining them
will cause our main thread to hang as well. Let's try it in our rake task:

```ruby
desc "Simulate load against Blogger application"
task :load_test => :environment do
  4.times.map { Thread.new { browse } }.map(&:join)
end

def browse
  session = Capybara::Session.new(:selenium)
  loop do
    session.visit("https://evening-temple-1086.herokuapp.com/")
    session.all("li.article a").sample.click
  end
end
```

Now _that's_ a user farm. We're getting closer to being able to load test
our application more scalable.

### Step 8: Headless Browsing

This swarm of Firefox windows is starting to get a little old,
and additionally my CPU is approaching meltdown temperature.

[Selenium](http://www.seleniumhq.org/) is useful for simulating a
full-fledged browser environment, but for what we need this is a bit
overkill.

[Poltergeist](https://github.com/teampoltergeist/poltergeist) is an
alternative, "headless" driver for Capybara, which means that it
emulates a full browser environment (including a Javascript runtime)
but without any of the rendering or graphical overhead.

Let's get setup with poltergeist.

First install __PhantomJS__ using homebrew:

```
brew update
brew install phantomjs
```
(Make sure you get version 2.0+)

Next add `poltergeist` to your gemfile in the `development, test` group and bundle:

```rb
gem "poltergeist"
```

Finally, update your script to use poltergeist by changing
the argument provided to `Capybara::Session.new`:

```rb
session = Capybara::Session.new(:poltergeist)
```

You'll likely also need to require `capybara/poltergeist` at the top
of your rake task:

```rb
require 'capybara/poltergeist'
```

Since poltergeist has no graphical interface, its progress through
the script is less obvious. Try adding some `puts` statements in your
script so you can see what it's doing (perhaps outputting `session.current_path`
to see what url the script is on).

Now you should see that our task is repeatedly visiting urls, this time
a lot faster. And without opening a ton of browser windows in our face.

### Step 9: Measuring Throughput

Now that we've put together a decent script for simulating load against
part of the application, let's checkout Skylight and see how it's affecting the app.

You should see a decent number of requests coming through.

### Step 10: Your Turn, Scripting More Blogger Interactions

Now that you've had a tour through some basic scripting and load
testing interactions, you're ready to script some more complicated interactions

Return to the list of User Script ideas you drafted in Step 3. Now implement
them as part of our load-testing task using Capybara. At least one of these
should involve some sort of data entry (creating a post, creating a comment, editing a post, etc)

A few pointers to consider:

* As your script grows in complexity you'll want to use more abstractions to
  keep things organized. Classes and methods are your friends.
* Remember that the full array of Capybara selectors and methods are
  available to you. Check the [documentation](https://github.com/jnicklas/capybara#the-dsl) if you get stuck.
* Consider implementing randomness into your script. Can you define a set of
  standard actions/scripts and have each loop choose randomly among them?
* As you go, refer back to Skylight to see how your new efforts are affecting
  the application

---

## TODO

A few additional topics that should be worked in:

* discuss other tools for load testing -- Apache Bench, Siege, etc.
* Discuss when / why you would need one of these tools -- the amount of load you need to generate with a test is proportional to the size of your infrastructure
* Single server process can be saturated pretty easy; large server cloud with advanced optimizations and caching will require more load
