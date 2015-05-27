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
* Practice deploying a Rails application with background workers to
  heroku

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

## Backgrounding in Production -- Deploying Sidekiq to Heroku

Our current setup is working well in development, but what if we want
to share FibTastic sequences with the world? Let's see what it would
take to get our application (along with its workers) running in
production.

### 1: Creating our App on Heroku

By now you're probably familiar with this ritual:

```
heroku create
```

This should set up a new app on heroku for you and add it as a
remote. Let's push our app to see if it works:

```
git push heroku master
```

You should be able to load the app's main page at this point, but if
you try to request a Fib sequence, you'll likely get an error.
Looking in the app's logs (using `heroku logs`) reveals a problem
connecting to Redis:

```
Redis::CannotConnectError (Error connecting to Redis on 127.0.0.1:6379 (Errno::ECONNREFUSED)):
```

### 2: Configuring Redis on Heroku

Our app is trying to enqueue jobs via Sidekiq, but we haven't set it up
to use Redis on heroku yet. We need to:

* 1: Add the RedisToGo addon to our app
* 2: Configure Sidekiq to use the appropriate redis settings

We can add RedisToGo with the command:

```
heroku addons:create redistogo
```

We can verify this worked by checking `heroku config`; you should see a
line like:

```
REDISTOGO_URL:            redis://some-redis-host
```

Now we have redis, but we need to tell Sidekiq to use the one that
we set up instead of the default (localhost) settings. Luckily
Sidekiq attempts to read from an ENV variable called `REDIS_PROVIDER`
when it boots. So we can tell Sidekiq to use our RedisToGo instance
by pointing `REDIS_PROVIDER` at our `REDISTOGO_URL`:

```
heroku config:set REDIS_PROVIDER=REDISTOGO_URL
```

Trying the app again we should be able to successfully request Fib numbers.
But the requested numbers never show up! We're now writing Fib jobs into
the Sidekiq queue, but there are no workers to process them.

We'll deal with that issue in a moment, but first there's one more
configuration option we need to deal with.

### 3: Configuring an SMTP Provider on Heroku

We had been using mailcatcher to send our emails in development,
but this obviously won't be available to us on Heroku. Instead,
let's use the email provider Mandrill, which conveniently provides
a large number of emails on a free account.

If you have not already, head over to [https://mandrillapp.com/login](https://mandrillapp.com/login)
to register for an account. Once registered you should be able to
retrieve credentials from the "Settings" tab.

We need credentials for "SMTP username" and an "API Key". Once you
retrieve these, set them in your heroku config as `MANDRILL_USERNAME`
and `MANDRILL_API_KEY`:

```
heroku config:set MANDRILL_USERNAME=my_user_name MANDRILL_API_KEY=my_api_key
```

Finally, let's configure ActionMailer to use the appropriate settings
for Mandrill. This can be done by adding this configuration to your
`config/environments/production.rb` file:

```
ActionMailer::Base.smtp_settings = {
  :port =>           '587',
  :address =>        'smtp.mandrillapp.com',
  :user_name =>      ENV['MANDRILL_USERNAME'],
  :password =>       ENV['MANDRILL_API_KEY'],
  :domain =>         'heroku.com',
  :authentication => :plain
}
ActionMailer::Base.delivery_method = :smtp
```

### 4: Workers on Heroku -- Intro to Process Types

Now that we have our SMTP provider set up, let's think about getting
these workers to run in production. Before we proceed, its good
to think a little bit about how heroku treats our applications.

As an abstraction around provisioning and running App servers,
Heroku needs to be able to handle a lot of different application
and language types. In order to support this, Heroku allows us
to define "types" of processes and then to specify what command
is needed to run processes of that type. This lets us get the
appropriate behavior for running a "web" process for our rails
app, while someone running a Node server can define the appropriate
instructions for their own "web" process, and everything just works!

The "web" process type is the most common type of process executed
on heroku -- it's so common in fact that heroku includes standard
process definitions for common applications (such as rails), which
explains how we've been able to deploy apps to heroku all this time
without worrying about this stuff.

But now that we're getting into more sophisticated deployment
setups, we'll need to think about our process types more carefully.
The way to customize process definitions for heroku is by including
a special file called a `Procfile` in the root of our application.

This file will allow us to specify the types of processes we'd like
heroku to support for this app and which commands to run them
with. You can read more about Heroku's process model [here](https://devcenter.heroku.com/articles/procfile),
but for now let's practice it with out FibTastic app.

Create a new `Procfile` in your application's root directory,
and fill it with the following settings:

```
web: bundle exec rails server -p $PORT
worker: bundle exec sidekiq
```

Commit this file and re-deploy the app -- so far nothing should visibly
change, so make sure the app still works as before.

### 5: Turning on the Worker Process

Another useful command heroku gives us is `heroku ps`, which
allows us to see what processes are currently running for
our app. Try it out and you should see something like:

```
=== web (1X): `bundle exec rails server -p $PORT`
web.1: up 2015/05/25 19:08:32 (~ 32s ago)
```

We told heroku how to start a worker process by specifying it in
our Procfile, but we didn't actually _start_ the process. By
default, Heroku only runs a single web worker on your behalf.
This is generally a good thing, since it prevents us from racking
up large Heroku bills accidentally, but it does mean that when adding
new processes like workers, we need to start them up manually.

This is done with a subcommand of `ps`, `heroku ps:scale`. In our
case, we want to add a single worker process to the single web
process that's already running:

```
heroku ps:scale worker=1
```

Woo! Workers working! If you had alreay queued up background emails
by submitting the FibTastic form, they should start to arrive now,
as the worker springs into action and notices jobs sitting on the queue.

But wait...a careful observer may check their heroku account
and find a nasty surprise:

![Holy Dynos Batman](../images/heroku_dyno_bill.png)

__Zut!__ Adding that extra worker process put us over the single free
process that Heroku allows. This is the 21st century, and that means
I should be able to access web deployment resources for free!

Let's see if we can't skirt around these pesky heroku limits. For now,
let's scale back our worker process so we don't get charged for it:

```
heroku ps:scale worker=0
```

__But for real -- scale your worker down. I won't be reimbursing anyone
who racks up accidental worker charges__

### 6: Free Workers on Heroku

In a fitting expression of 21st century capitalism, we would
really like these workers to toil away in the server mines
for free. Unfortunately, heroku's default single-free-process
model prevents us from doing this.

__But__, there is a way around
this. We get 1 free process per app, so if we need a second one,
we can just make a second app. In this case the second app
will contain the same _code_ as the first app, but its process
scaling will be different. We'll use one copy for the web process
and one for the worker.

__Copying our App__

It would be kind of a pain to re-configure all the environment settings
we already configured for our new app instance. Fortunately
heroku provides a handy `fork` command that allows us to duplicate
an existing application.

To use the `fork` command, you need to specify a "source" app
and a "target" app. In our case the "source", will be the existing
heroku FibTastic app we created. The "target" will be the new
application, so here you can provide whatever name you like.
Your application names will differ, but the command will look
something like (I'll be using `app-one` and `app-two` to represent
these 2 app instances from here on out):

```
heroku fork --from app-one --to app-two
```

You should see some terminal output as heroku forks your app,
along the lines of:

```
Installing plugin heroku-fork... done
Forking app-one... done. Forked to app-two
Deploying 966d5a5 to app-two... done
Adding addon redistogo:nano to app-two... done
Adding addon heroku-postgresql:hobby-dev to app-two... done
Transferring DATABASE to DATABASE...
Progress: done
Copying config vars:
  LANG
  RAILS_ENV
  RACK_ENV
  SECRET_KEY_BASE
  RAILS_SERVE_STATIC_FILES
  REDIS_PROVIDER
  MANDRILL_USERNAME
  MANDRILL_API_KEY
  ... done
Fork complete. View it at https://app-two.herokuapp.com/
```

(You may also get some output about heroku updating or installing
various plugins; just be patient and let these finish.)

__Adding the Forked App as a Remote__

Heroku doesn't automatically add the new app as a remote, so we will
need to do that ourselves. To find the git url of our new app, we
can use the heroku info command:

```
heroku info -a app-two
```

Where `app-two` is the name you gave to your forked copy
of the app. This command will output some stats about the app,
which look like:

```
=== app-two
Addons:        heroku-postgresql:hobby-dev
               redistogo:nano

Dynos:         1
Git URL:       https://git.heroku.com/app-two.git
Owner Email:   horace.d.williams@gmail.com
Region:        us
Slug Size:     29M
Stack:         cedar-14
Web URL:       https://app-two.herokuapp.com/
Workers:       0
```

The Git URL is what we're interested in. Add it as a remote
in your git repo using `git remote add` (you can name it whatever you like).

### 7: Managing Multiple Heroku Apps

We don't often deploy multiple copies of simple demo apps to
heroku, but this type of setup is pretty common on a larger project.
Dev teams will frequently run multiple instances in order to have
some as staging or backup environments, or students will fork their
apps to avoid paying for them.

The downside of having multiple app instances is that
heroku now requires an `--app` flag
for many commands so that it knows which instance of the app to
run the command against. So, for example, to read the config settings
for an app, we would need to specify: `heroku config --app my-app-name`.

Another downside is that you'll need to deploy both apps individually
when updating.

The upside is we will get workers for free.

### 8: Connecting Our 2 Apps Via RedisToGo

Remember that Redis, as the queue store used by Sidekiq, provides the
means of communication between our Web process and our Worker process.
In order to get our 2 separate apps talking to one another, we need
to point them at the same RedisToGo url. The easiest way to do this
is to read the config from one app:

```
heroku config:get REDISTOGO_URL --app app-one
redis://redistogo:some-redis-to-go-url
```

and set it in the second:

```
heroku config:set REDISTOGO_URL=redis://redistogo:some-redis-to-go-url --app app-two
```

Where `app-one` and `app-two` are the names of your respective heroku
apps. What this gives us is a sort of miniature Service Architecture --
we now have 2 separate applications, connected via Redis as a
communication channel.

### 9: Turning App 2 Into a Worker Farm

In order to identify the final change we need to make, let's check out
the `ps` info for our 2 respective apps:

```
$ heroku ps --app app-one
=== web (1X): `bundle exec rails server -p $PORT`
web.1: idle 2015/05/25 20:12:42 (~ 13m ago)
$ heroku ps --app app-two
=== web (1X): `bundle exec rails server -p $PORT`
web.1: up 2015/05/25 20:20:18 (~ 5m ago)
```

Your output will vary slightly, but the important point is that we're
currently running web processes on each app and no worker processes.
Our intention was to have one app as a web process and one as a worker
process, so let's set that up by scaling web to 0 and worker to 1 in
our second app:

```
heroku ps:scale web=0 worker=1 --app app-two
```

### 10: Putting It All Together

Since we're turning off the web worker for app-two, we'll remain within the 1 worker
threshold and our app will remain free. And since the 2 apps are
pointing at the same `REDISTOGO_URL`, jobs queued by the first app (web)
will be processed by the second one (worker).

Try it out by visiting the url for app-one and requesting a Fib
sequence. If everything is working correctly, app-one will enqueue
a job via Sidekiq, app-two will pick it up and process it, and you will
get your email!

__To recap what we did:__

* Added sidekiq as a background queueing library
* Defined a job for processing our fibonacci sequence emails
* Deployed our rails app to heroku like normal
* Added RedisToGo as an addon to be used by Sidekiq
* Created a second copy of our heroku app using `heroku fork`
* Pointed the second app at the same RedisToGo URL as the first app
  so they can use the same Redis to communicate
* Scaled the second app to have 0 web and 1 worker process -- it only
  processes background jobs

If this all seems a bit convoluted... Heroku will be happy to take your
money for running the additional worker process in the same app. But
additionally, this sort of a multi-app setup is decent practice for the
more sophisticated service architectures we'll be seeing later in the
module.
