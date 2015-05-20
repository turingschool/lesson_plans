---
title: Load Testing and Production Performance Monitoring
length: 90
tags: performance, benchmarking, capybara
---

## Learning Goals

* Understand the reasons for load testing rails applications
* Practice writing scripts to simulate heavy load against an application
* Understand the differences between elapsed time from the perspective
  of your app code and from the perspective of the client
* Understand the concepts of request queueing and server overload


## Warmup/Discussion -- What is load testing?

Dealing with performance issues in our applications can sometimes be a bit thorny.
Pretty much all developers you ask will agree that performance is important. But
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
in a "production" context is...to simulate that context. And this is effectively
what load testing is about. In this lesson we'll look at some techniques to simulate
heavier usage patterns so that we can identify the performance issues that arise from
these contexts.

## Usage Patterns -- Production vs. Development

Consider the usage pattern of an average Turing student application:

* Few users (1 or 2 concurrent)
* Sporadic requests
* Generally exercising single portions of an application at a time
* Little or no simultaneous database queries

With this sort of a usage pattern, it will be difficult to reproduce the sort
of performance issues which will arise in a production, scaled environment.

What sort of characteristics would we expect from a (scaled) production application?

* Many users (10s or 100s or 1000s using the application concurrently)
* Constant requests (server receives little "down-time")
* Exercising full breadth of application (e.g. admin users and "browsers" and "purchasers"
  all using the app at once; perhaps api/native clients as well)
* Heavy simultaneous database usage (potential query bottlenecks) 
* Potentially "spikey" usage patterns (numerous requests between certain hours, slower at other times)


## Simulating Load

With those ideas in mind, how can we simulate load against our early-stage application
that might help us anticipate or reproduce problems of scale?

__Scale Simulation Tool -- Desirable Characteristics:__

What would we want out of our ideal load simulation tool? A few ideas come to mind:

* Ease of use (nice API)
* Ability to simulate multiple, complex user "flows" (signing up, placing an order,
  admin functionalities, data entry, etc)
* Ability to "scale out" load (i.e. simulate multiple users)

It turns out that there's a tool you've been using for some time which fits these characteristics
quite well -- __Capybara__!

We have used capybara to "script" usage of our applications in a test environment,
but it can script usage of a production or development
environment just as well. Using this technique, we will think of our capybara script as a
simulated "user" which navigates around our site quickly and repeatedly as we instruct it.

In the following tutorial, we'll look at:

* Writing capybarara scripts to "load test" the JSBlogger example application
  in a production environment
* Using threads to "scale up" the load against our server
* Using Skylight.io, a production metric service, to monitor how our application
  behaves under load.


### Step 1 -- Setup

To get setup, let's follow a familiar ritual. Clone, bundle, and setup the blogger_advanced
application. Note that we're using a branch of the application configured to use postgres
as its database:

```
git clone git://github.com/JumpstartLab/blogger_advanced.git load_testing_workshop
cd load_testing_workshop
git checkout -t origin/postgres
bundle
rake db:setup
```

__Production Setup__

This should get everything setup. To verify, run the tests with `rake` before continuing.

Our application should now be good to go in our development environment. But remember that we're
interested in monitoring how our application performs under load in a _production_ environment.
To that end, let's set it up to run on heroku (note that we're deploying a non-master branch to
heroku in this case):

```
heroku create
git push heroku postgres:master
heroku run rake db:migrate db:seed
```

Verify this worked by opening the app: `heroku open`. Your eyes should be embraced by the familiar
and, frankly, quite lovely, JSBlogger interface.

__Last Setup Step - Metrics Service__

One more piece of setup remains. In a few moments we're going to be hurling requests at our
production instance of JSBlogger. To see how it handles the load, let's install Skylight.io,
a production performance metrics service:

```
bundle exec skylight setup
```

You'll be prompted for the __email__ and __password__ associated with your Skylight account. If
you have not created a Skylight account before, visit [https://www.skylight.io/](https://www.skylight.io/)
to sign up. We'll be using a free tier of the service, so you won't have to enter any payment information.

Note that this step creates a new configuration file, `config/skylight.yml`, which you'll need to commit
and push to heroku. Don't forget to push the `postgres` branch which we're using.

If everything went well,
you should be able to visit [https://www.skylight.io/app/applications](https://www.skylight.io/app/applications)
and see your application. It probably won't be reporting any traffic yet, but we'll fix that next.

### Step 2 -- Fake Users Everywhere

Now that we have our application deployed, let's practice exercising the application
in an automated fashion. In this section, we'll see that Capybara is a pretty handy
tool for navigating the web -- and it's not limited to use in test suites!

Fire up a rails console, and create a new capybara session:

```
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
driving a real web browser with Capybara

### Step 3 -- More Scripting

This is starting to get more exciting, but entering commands manually via
the console is not much better for producing heavy server load than entering
commands manually via a web browser.

What's the simplest server load script we could write? How about a loop?
Let's try it in console:

```
irb(main):001:0> session = Capybara::Session.new(:selenium)
=> #<Capybara::Session>
irb(main):002:0> loop do
irb(main):003:1* session.visit("https://evening-temple-1086.herokuapp.com/")
irb(main):004:1> session.all("li.article a")sample.click
irb(main):005:1> end
```

Now your firefox session should be going crazy with constant requests.
This little loop allows us to simulate a single, simple path through
the application -- a user visits the root url, selects a random article,
then repeats these actions over and over.

Leave the loop running and head back to your skylight interface. This
time you should start to see some more robust traffic.

### Step 3 -- Load Testing "User Scripts"

It turns out that real users don't just repeatedly loop through
2 endpoints on our application. They follow reasonable and varied
patterns of usage through the application. When load testing, we'll
want to anticipate these patterns and try to mirror them so that our
tests are representative of what the application's real usage
patterns look like

Here are some more things to think about when designing a load testing script:

* Funnel patterns (index -> node -> data entry)
* Application entry points (where can the user start?)
* Traffic sources -- are your users coming to the site via search engines?
  Promotional emails? Ads?
* "Hot" pages -- which pages generate the most traffic?
* Important/Priority pages -- are there any pages crucial to the
  operation of the business (e.g. order creation, account status, etc)
* Average session length (# of pages)

__Creating User Scripts__

With these ideas in mind, take __8 minutes__ and jot down some ideas
for good "User Scripts" that might represent an average user's
interaction with the Blogger application.

Try to come up with 4-5 ideas for scripts. It's ok if some pages are more
heavily represented than others. Don't worry yet about how to turn
these scripts into code; stick to Pseudocode for now.

### Step 4 -- Turning our Simple Loop into a Reuseable Script

We'd like to be able to load-test our app repeatably and at-will,
so we'll want a more persistent interface to doing so. For now,
let's use a rake task to hold our script.

Create a rake task for load testing at `lib/tasks/load_test.rake`. The
basic structure for a rake task should look something like this:

```
desc "Simulate load against Blogger application"
task :load_test => :environment do
end
```

Using this structure, move the basic loop script from our console session
earlier into this rake task.

Try running it with `rake load_test` and verify that you see the same browser
behavior as before.


### Step 5 -- Refactoring

Before we continue, take a quick refactoring pass at our script --
extract the code from our rake task into its own method. The
only code within the task should then be executing this method.

### Step 6 -- More Users, Cap'n!

You know what's cooler than a single automated user mindlessly
looping through 2 urls on your site? A __bunch__ of users doing
the same thing.

__Discussion -- Ruby Concurrency Options__

Let's use threads to simulate more users. Take the method you extracted
in the previous step and wrap it in some threads:

```
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

__Hmmmm....__ that wasn't very effective.

One tricky thing with threads -- since they represent an independent,
asynchronous execution context, the main thread of your program will
simply exit if it has nothing to do.

A common technique to fix this is using `Thread#join` -- this tells
the main thread to "wait" until the joined thread finishes its work.

In our case, the "worker" threads are simply looping, so joining them
will cause our main thread to hang as well. Let's try it in our rake task:

```
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
our application more scalably.


### Step 7 -- Headless Browsing

This swarm of Firefox windows is starting to get a little old,
and additionally my CPU is approaching meltdown temperature.

[Selenium](http://www.seleniumhq.org/) is useful for simulating a
full-fledged browser environment, but for what we need this is a bit
overkill.

[Poltergeist](https://github.com/teampoltergeist/poltergeist) is an
alternative, "headless" driver for Capybara, which means that it
emulates a full browser environment (including a javascript runtime)
but without any of the rendering or graphical overhead.

Let's get setup with poltergeist.

First install __PhantomJS__ using homebrew:

```
brew update
brew install phantomjs
```

(make sure you get version 2.0+)

Next add `poltergeist` to your gemfile in the `development, test` group and bundle:

```
gem "poltergeist"
```

And finally update your script to use poltergeist by changing
the argument provided to `Capybara::Session.new`:

```
  session = Capybara::Session.new(:poltergeist)
```

You'll likely also need to require `capybara/poltergeist` at the top
of your rake task:

```
require 'capybara/poltergeist'
```

Add some `puts` statements inside of your script `loop` and run the task.

Alternatively, try outputting `session.current_path` at the end of each loop
to see what urls it is visiting.

Now you should see that our task is repeatedly visiting urls, this time
a lot faster. And without opening a ton of browser windows in our face.

### Step 8 -- Measuring Throughput

Now that we've put together a decent script for simulating load against
part of the application, let's checkout skylight and see how it's affecting the app.

__Discussion: What to look for in Skylight__


### Step 9 -- Your Turn -- Scripting More Blogger Interactions

Now that you've had a tour through some basic scripting and load
testing interactions, you're ready to script some more complicated interactions

Return to the list of User Script ideas you drafted in Step 3. Now implement
them as part of our load-testing task using capybara. At least one of these
should involve some sort of data entry (creating a post, creating a comment, editing a post, etc)

A few pointers to consider

* As your script grows in complexity you'll want to use more abstractions to
  keep things organized. Classes and Methods are your friends.
* Remember that the full array of capybara selectors and methods are
  available to you. Check the [Docs](https://github.com/jnicklas/capybara#the-dsl) if you get stuck.
* Consider implementing randomness into your script. Can you define a set of
  standard actions/scripts and have each loop choose randomly among them?
* As you go, refer back to Skylight to see how your new efforts are affecting
  the application