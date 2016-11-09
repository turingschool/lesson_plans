---
title: Intro to background Workers
length: 180
tags: Background Workers, sidekiq, queue, async
---

### Goals

By the end of this lesson, you will know/be able to:

* Explain when you would want to use a background worker
* Be able to implement a basic background process


#### Intro

When building websites, it’s important to keep your response times down. Long-running requests tie up server resources, degrade user perception of your site, and make it hard to manage failures.

There’s a solution to this: return a successful response, and then schedule some computation to happen later, outside the original request/response cycle.

##### Do you need a job queue?

How do you identify areas of the application that can benefit from a background job? Some common areas for asynchronous work:

* Data Processing - e.g. generating thumbnails or resizing images
* 3rd Party APIs - interacting with a service outside of your site
* Maintenance - expiring old sessions, sweeping caches
* Email - a request that causes an email to be sent

Applications with good OO design make it easy to send jobs to workers, poor OO makes it hard to extract jobs since responsibilities tend to overlap.

### 1: App Setup

Let's look at an example of backgrounding a task using Sidekiq.
We'll use the "Working-It" application for the following demo.
Clone and bundle it like so:

```
git clone git@github.com:turingschool-examples/work-it.git
cd work-it
bundle
rake db:{create,migrate}
rails s
```

Workin-it is a simple app that takes an email and a random thought to generate an email with a giphy about your thought. Start the server `rails s` and you should be able to view the app at `http://localhost:3000` which has form inputs for an email address and a thought. When you submit that form you should feel the pain of a slow page load.

### 2: Mailcatcher for Local Email Processing

In order to see the emails that the application outputs, lets
also use [mailcatcher](http://mailcatcher.me/). Mailcatcher is a ruby library
for providing local SMTP server. It allows you to get emails locally in development.

```
$ gem install mailcatcher
$ mailcatcher
```

You should now be able to monitor email at `http://127.0.0.1:1080/`.

The following lines in `development.rb` tell rails to send through port 1025 which Mailcatcher is watching.

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
```

You'll also need to update the `smtp_settings` with your own account info.

Now test that the application is working by entering an email address
and any thought you may have right now. You should
see an email in the mailcatcher UI with the thought-giphy.

Notice that for this process takes a very long time. What we have here is a perfect candidate for a background process:

* Operation is slow
* User's interaction with the process is already asynchronous (submit
  the form _then_ go check their email)
* Operation is well-encapsulated behind the UserNotifier interface
* Operation requires relatively little data as inputs (email address
  and random thought).

Sidekiq and Resque are the 2 most popular queuing libraries for ruby.
For this application, we'll use Sidekiq.

### 3: Dependency -- Redis

Like Resque, Sidekiq uses Redis to store queued jobs, so first make
sure you have redis installed and running.

Run `redis-server` 

If you don't already have redis, install it with homebrew:

```
brew install redis
```

Then run `redis-server`.

This command starts the redis server on port 6379. Once the redis server is running it is ready to queue jobs that still need to be done. 

You can check if your redis process is running by executing the command
`redis-cli`:

```
$ redis-cli
127.0.0.1:6379>
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
do anything for us. Let's create a worker to handle our Workin-it email.

Sidekiq's convention is to store worker classes under the `app/workers` directory,
so create a file at `app/workers/gif_email_worker.rb` to contain
our email worker.

In order to make use of the various methods sidekiq provides, we need to
include the `Sidekiq::Worker` module, so let's set up our worker like
so:

```ruby
class WorkinItEmailWorker
  include Sidekiq::Worker
end
```

### 6: Defining Job Operations

Within a Sidekiq worker, the instance method `#perform` is what gets
called whenever a job appears for our worker to do. Let's think about
what needs to go in here and about what inputs are required for
the worker to do its job:

* Needs to take in the email address and thought (since these
  are the parameters needed to send the email)
* Needs to send an email using the `UserNotifier`

Given these constraints, it might look something like:

```ruby
class WorkinItEmailWorker
  include Sidekiq::Worker

  def perform(email, thought)
    UserNotifier.send_randomness_email(email, thought).deliver_now
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

Under the hood, the `perform_async` method writes data into
Redis indicating the type of job which needs to be done
and the data associated with it. The workers (in a separate
process) are monitoring the queue so that whenever new jobs
appear, they can spring into action and do them!

This works out to our advantage thanks to the low
latency of Redis as a data store. The "write" to Redis is
extremely fast (often fractions of a milliseconds), so
we effectively exchange a slow action (sending an email and making an api call) for an extremely fast one.

But enough chit-chat, let's see what it looks like to actually
queue the job. Recall that we were previously sending the
email directly from our `MailersController`. Let's replace
the line that was sending the email with this line to
queue our job instead:

```ruby
WorkinItEmailWorker.perform_async(params[:mailers][:email], params[:mailers][:thought])
```

Remember -- the arguments passed in to the `.perform_async` method here
will eventually be handed to your worker's `#perform` method, so make
sure they match up.

#### The Closing: ~5 min

* Check for understanding
* Discuss any clarifications or student misconceptions
* Review goals, further resources, and next steps

### Video

* [Link to optional video](https://vimeo.com/131505902)

### Repository

* [Work-it Repo](https://github.com/turingschool-examples/work-it/tree/master/app)


### Outside Resources / Further Reading

* [background workers revisited](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/background_workers_revisited.markdown)
* [workers at scale](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/workers_at_scale.markdown)
