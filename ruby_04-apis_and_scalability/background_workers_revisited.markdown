---
title: Background Workers Revisited
length: 180
tags: performance, workers, sidekiq, rails
---

## Learning Goals

* Review the reasoning behind background processing and identify
  scenarios when it makes sense
* Practice using Sidekiq to manage background processing within a rails
  app
* Practice deploying an Rails application with background workers to
  heroku

## Structure

* 25 - Presentation: Agile Development
* Break
* 25 - Structuring Stories
* Break
* 25 - Stories Workshop
* 5 - Wrapup

## Discussion: Background Workers as an Architectural Pattern

### Response Time -- Application Goodness as a Metric

There are a lot of performance metrics to take into account
when optimizing a web application, but there's generally
one that's the most important -- __Response Time__.

Response Time (from a server perspective) represents the length of time between when your
application receives a request from a user and when it finishes
processing and sends back a completed HTTP response. Response Time
is ultimately the main factor which determines how "snappy" your
application will feel, and thus how much users will enjoy interacting
with it.

There's no hard "rule" about response times, but generally response
times under ~200 ms or so allow an application to feel snappy and
responsive.

### Managing Application Response Time

Response Time is obviously important, so how to we keep it low?
Our first choice would be to just make everything within
the response cycle fast. If your application needs to do 5 things
in order to return an HTTP response and each one takes 5 ms, then
your response time would be `5 * 5 = 25 milliseconds`. Good Job!

But sometimes our application simply needs to do something
time-intensive in order to fulfill its responsibilities. Since
we can't make it faster, our remaining option is to "get rid of it"
somehow. And this is what background processing allows us to do.

Consider a hypothetical example:

```
## APP RESPONSE CYCLE

Load user info from DB (3 ms)
          |
          |
Generate User Recommendations (100 ms)
          |
          |
Send Email via slow 3rd party service (100 ms)
          |
          |
Render HTML Response (20 ms)
--------------------------
TOTAL: 223 ms
```

With a background queue, we can replace the 2 expensive
actions in the middle with a single action -- Enqueuing
the job, and then the expensive work can happen
asynchronously:

```
## APP RESPONSE CYCLE               |  ## Worker Activity Cycle
                                    |
Load user info from DB (3 ms)       |
          |                         |
          |                         |
Queue User Rec Job to Redis (1 ms)  |  Reads Queued job (1ms)
          |                         |           |
          |                         |           |
Render HTML Response (20 ms)        |  Generate User Recommendations (100 ms)
--------------------------          |           |
TOTAL: 24 ms                        |           |
                                    |     Send Email (100 ms)
                                    | (201 ms, but not in R/R Cycle)
```


Of course, in reality the job processing likely doesn't begin
immediately after the queuing as in this diagram, but the important
point is the concept of adding asynchronous processing to our
application. The web process and the worker process communicate
via the Job Queue (Redis in this case), so they don't have to
be rigidly linked in time.

### What Makes a Good Background Job?

There are 2 main attributes that make something a good
candidate for background extraction:

* Slow
* Immediate user feedback not crucial

The common example of sending emails asynchronously
fits well here because it's relatively slow and it's also
not essential that the user get their email immediately --
a delay of a few moments is generally not noticeable.

### Designing For Background Jobs

There are a few things we can do in our code
to make the process of extracting something into a background
process easier.

* Use objects and classes to provide good "boundaries" around
  calculations
* Limit the amount of contextual data that needs to be passed
  into the calculation

If these sound just like standard OO design principles that's
because...they are. But the utility will become especially clear
once you have to extract a job from a poorly factored Rails
controller. It's much easier to move 1 line such as
`MyThing.new("some", "data").new.calculate` than it is to untangle
and move 20 lines of spaghetti code.

## In Practice: Backgrounding FibTastic Computations

### 1: App Setup

Let's look at an example of backgrounding a task using Sidekiq.
We'll use the "FibTastic" application for the following demo.
Clone and bundle it like so:

```
git clone https://github.com/worace/fibtastic.git
cd fibtastic
bundle
rails s
```

FibTastic is a very basic rails application which, upon request,
emails a user a specified quantity of fibonacci numbers.

With the server running, you should be able to view a simple
UI at `http://localhost:3000` which has form inputs for an
email address and a quantity of numbers.

### 2: Mailcatcher for Local Email Processing

In order to see the emails that the application outputs, lets
also use mailcatcher. (Recall that mailcatcher is a ruby library
for providing local SMTP server, thus allowing us to send emails
in development). It's included in the fibtastic gemfile, so
we can simply run it with:

```
bundle exec mailcatcher
```

Now test that the application is working by entering an email address
and a quantity of fibonacci numbers you'd like to receive. You should
see an email in the mailcatcher UI with the numbers.

Notice that for sequence lengths beyond 10 or so, things start to get
noticeably slower. What we have here is a perfect candidate for a
background process:

* Operation is slow
* User's interaction with the process is already asynchronous (submit
  the form _then_ go check their email)
* Operation is well-encapsulated behind the SequenceMailer interface
* Operation requires relatively little data as inputs (email address
  and sequence length).

Sidekiq and Resque are the 2 most popular queuing libraries for ruby.
For this application, we'll use Sidekiq.

### 3: Dependency -- Redis

Like Resque, Sidekiq uses Redis to store queued jobs, so first make
sure you have redis installed and running.

You can check if your redis process is running by executing the command
`redis-cli`:

```
$ redis-cli
127.0.0.1:6379>
```

(Seeing a redis command prompt appear means you're good to go)

If you don't already have redis, install it with homebrew:

```
brew install redis
```

### 4: Sidekiq Setup

Now we can add the sidekiq gem to our Gemfile:

```
gem 'sidekiq'
```

bundle the app and you should now be able to run a sidekiq
process by executing the command:

```
bundle exec sidekiq
```

You should get the fancy Sidekiq ASCII logo in your terminal:

```
         s
          ss
     sss  sss         ss
     s  sss s   ssss sss   ____  _     _      _    _
     s     sssss ssss     / ___|(_) __| | ___| | _(_) __ _
    s         sss         \___ \| |/ _` |/ _ \ |/ / |/ _` |
    s sssss  s             ___) | | (_| |  __/   <| | (_| |
    ss    s  s            |____/|_|\__,_|\___|_|\_\_|\__, |
    s     s s                                           |_|
          s s
         sss
         sss
```

### 5: Making a Job

Now we have sidekiq running with our application, but so far it doesn't
do anything for us. Let's create a worker to handle our FibTastic email
sequences.

Sidekiq's convention is to store worker classes under the `app/workers` directory,
so create a file at `app/workers/sequence_email_worker.rb` to contain
our email worker.

In order to make use of the various methods sidekiq provides, we need to
include the `Sidekiq::Worker` module, so let's set up our worker like
so:

```
class SequenceEmailWorker
  include Sidekiq::Worker
end
```

### 6: Defining Job Operations

Within a Sidekiq worker, the instance method `#perform` is what gets
called whenever a job appears for our worker to do. Let's think about
what needs to go in here and about what inputs are required for
the worker to do its job:

* Needs to take in the email address and sequence length (since these
  are the parameters needed to send the email)
* Needs to send an email using the `SequenceMailer`

Given these constraints, it might look something like:

```ruby
class SequenceEmailWorker
  include Sidekiq::Worker

  def perform(email, sequence_length)
    SequenceMailer.sequence_email(email, sequence_length).deliver_now
  end
end
```

### 7: Queueing Jobs -- Sidekiq::Worker.perform_async

The Sidekiq worker defines what actual work will be done whenever
our background process is invoked. Now we just need to actually
invoke it.

With Sidekiq, we dispatch a job for a worker to do later by
calling the class method `.perform_async` on our worker and
providing it whatever arguments are needed for the job.
This is analogous to Resque's `Resque.enqueue` method.

Under the hood, the `perform_async` method writes data into
Redis indicating the type of job which needs to be done
and the data associated with it. The workers (in a separate
process) are monitoring the queue so that whenever new jobs
appear, they can spring into action and do them!

This works out to our advantage thanks to the low
latency of Redis as a data store. The "write" to Redis is
extremely fast (often fractions of a milliseconds), so
we effectively exchange a slow action (in our case calculating fibonacci
numbers) for an extremely fast one.

But enough chit-chat, let's see what it looks like to actually
queue the job. Recall that we were previously sending the
email directly from our `SequencesController`. Let's replace
the line that was sending the email with this line to
queue our job instead:

```
SequenceEmailWorker.perform_async(params["email"], params["sequence_length"].to_i)
```

Remember -- the arguments passed in to the `.perform_async` method here
will eventually be handed to your worker's `#perform` method, so make
sure they match up.

### 8: Observing Effects -- Backgrounded Calculations

With these changes made, make sure you have your rails server
and sidekiq process running, and try requesting another FibTastic
email.

Even if requesting a long sequence of numbers, you should get an
almost immediate response from the server. Then flip over to
Mailcatcher and wait for the email. It may take several seconds, but
as expected your email should appear asynchronously, long after
the related web request has returned.
