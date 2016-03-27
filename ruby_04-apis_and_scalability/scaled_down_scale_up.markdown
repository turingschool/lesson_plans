---
title: Expedited Scale-Up
length: 90 - 180 min
tags:
---

### Goals

By the end of this lesson, you will know/be able to:

* Understand and use New Relic to improve performance
* Improve application performance by using pagination, caching strategies and query optimization

### Structure

Follow the tutorial below. We will not always go through code implementation in detail but rather demonstrate how to identify bottlenecks, strategies of data caching and fragment caching and how to improve performance of our application.

We are going to use New Relic to see the performance of our application and we will start by focusing on the `LoanRequest` view, model and controller. We are continuously going to run a load script during development which will hit our application with traffic so we don't have to manually go through and mock user interaction with our site. 

At the end of this lesson there are instructions to how you can expand the load script to hit more parts of the application which you can optimize in your own time.

Dealing with scaling and performance issues are a great part of web development as applications grow larger and experience a hihgher load.

[Fast Company: How One Second Could Cost Amazon 16 Billion in Sales](http://www.fastcompany.com/1825005/how-one-second-could-cost-amazon-16-billion-sales)  
[The Footprint of performance](https://www.youtube.com/watch?v=ZhshEZIV2F4)

### Repository

* [The Pivot](https://github.com/turingschool-examples/keevah)

### Lecture

We all have fond memories of the Pivot and want nothing else than go back to week 1 in module 3 and build out another admin interface. In this lesson we will work with a Pivot project from the 1412 cohort. We are going to use a loadscript and seed our adatabse with about 500k records and work with New Relic to optimize performance.

If you haven't done so already, create a [New Relic](http://newrelic.com/) account.

### 0. Up and running

Clone the project, bundle the gems and run the migrations.

I had an issue initializing the Rails application (take a look at line 5 in `config/environment.rb`) when I started the server, and it turned out that the `less-rails` gem was not compatible with `sprockets 3`. They have merged in a fix in the master branch so just fetch the gem like this:

```ruby
gem 'less-rails', github: 'metaskills/less-rails', branch: 'master'
```

You can read more about it in this [issue](https://github.com/metaskills/less-rails/issues/111) and check out the [PR](https://github.com/metaskills/less-rails/pull/112) that fixed it.


#### Loading the pre-seeded DB dump

This project includes a rake task to load a pre-seeded DB dump with all the data you will need. It is currently stored on Turing's dropbox. To download and import it, use this rake task:

```
$ rake db:pg_restore
```

Go to the Rails console and try to query for all records in the `LoanRequest` table, or all the `User`'s. 

#### Pushing Data to Heroku

**NOTE:** it's not necessary to create a heroku instance and test the load times in production. You can just test your application in development if you for example already have 6 heroku apps. However, if you are planning on building out the load script to touch more parts of your application, I would recommend to deploy your application and test it in production because production or it didn't happen. 

Once you've populated your local DB, push those records to a heroku instance so New Relic can monitor your production application.

1. Create heroku instance (heroku create)
2. Use `heroku pg:push` to export your local data into
the instance. For example:

```
$ heroku pg:push the_pivot_development DATABASE_URL
```

### 1. Preparing our application: Load script

Take a look in `lib/tasks`. Horace has already built out an initial load script that we will use. If you want to keep working on this project and optimize more parts of it, simply build out the load script to hit more parts of your application (more about this at the end of the tutorial) to discover bottlenecks.

`lib/tasks/load_script.rake` requires `"load_script/session"`. In these files we are using Capybara to mock user interaction with our application. Read through those two files and make sure you know what's going on.

Before you run the script, remove `sign_up_as_lender` from the array in the `actions` method. We are going to start by just hitting `LoanRequest#index` and `LoanRequest#show` - which we do with `browse_loan_requests`.

**lib/tasks/load_script/session.rb**
```
def actions
  [:browse_loan_requests]
end
```

Run the load script: `bundle exec rake load_script:run`

You won't get any feedback in the terminal that it's working, but you'll see the activity in your server. As long as the script is running, we are hitting our application with actual traffic that we can monitor using New Relic. 

However, if you run it before we have done any of the optimizations the load script will probably time out. `browse_loan_requests` will go to `/browse` - which will try to render ~500k loan requests on the page. We will run the load script in section 3, after we have implemented pagination. 

**NOTE:** if you are testing in production, prepend the command with `SERVER_URL=https://myURL.herokuapp.com`.

### 2. Registering your application with New Relic

Go to [New Relic](https://newrelic.com) and log in. Go to the `/setup` url (`https://rpm.newrelic.com/accounts/YOUR_ACCOUNT_#/setup`) and click `Browser`. Choose to enable via APM, and then select Ruby as your web agent. Follow the instructions and your application will show up on your New Relic account within a few minutes.

What your application will need to be properly connected to New Relic:

* `config/newrelic.yml`
* the New Relic gem

Once the application is registered, we can start the load script. In another terminal window, start the load script and keep it running.

**NOTE:** for those of you that are testing in production, make sure you push your changes to Heroku.

### 3. Quick fixes aka low hanging fruit

Fire up a server and go to `https://localhost:3000`. As you'll see, the landing page loads without any problems. When you click `Lend` in the  upper left corner..... the page is loading... and loading... and loading. It took my machine about 5 minutes to load all of the records and render the items and it crashed my browser. Iterating over `MyModel.all` in the view is a good idea until you are trying to render 500k records.

A super quick fix to this is to add pagination. This way, we can restrict the number of items that will render and our application will actually work.

Indexing relevant tables is also a good initial strategy. Keep this in mind as we go through the lesson and index your database as you see fit. 

#### Your turn:

Implement pagination on the `loan_request#index` view. I used the [will_paginate](https://github.com/mislav/will_paginate) gem but there are other alternatives as well, for example [Kaminari](https://github.com/amatsuda/kaminari).

Once you have implemented pagination, start the server and click `Lend` again. Success - our browser doesn't crash! Now we can start the load script and see traffic being registered on New Relic. 

### 3.1 Updating the load script 

In our load script, `browse_loan_requests` will visit `/browse` and click on a random loan request. The only problem is that we will only ever click the loan requests that are on the first page. 

To visit a random loan request we need to modify the load script. 

#### Your turn: 

Modify the load script to hit random `loan_request#show` views. Either add a line to click a random paginated view and then click a random loan request on that page - or - visit a random loan request page.    

### 3.2 OPTIONAL: adding images to loan requests

If you want to add images to loan requests, run the `load_images` rake task - read it before you run it! Be prepared that it might take a long time to run.

### 4. Fragment caching and data caching

There are two ways we can cache in Rails: fragment caching and data caching. Fragment caching allows us to store a fragment of view logic in the cache to use for subsequent requests. It's useful if we are going to the database to fetch something that will appear in the view over and over again. We use data caching primarily in our models to store values that are unlikely to change over time.

If you want a more extensive look into caching, take a look at [this](http://tutorials.jumpstartlab.com/topics/performance/caching_data.html).

Before we start implementing caching, let's see if we have gotten any data in New Relic yet. Hopefully you have kept it running!

#### Using New Relic to discover bottlenecks

Find your application on your New Relic account, click it and look at the `Overview` page. You'll see a layered area graph which will display your application's performance over time. Right below the graph, you'll see the five slowest transactions. Take some time to click around and familiarize yourself with New Relic and the different types of data you get.

On my account - and it will most likely be the same for you - the `loan_request#show` controller is by far the slowest one. This is a good place to start. Click the `Transactions` tab, and then click the `LoanRequestsController#show` bar to see more information about it. At the bottom of the page, you can see more in detail what is taking such a long time. I see that the template and the template is 70% of the loading time, the `Postgres LoanRequest find` is 24% and the rest are about 1% each.

If we look in the `show` action in the `loan_requests_controller`, there is nothing there. We should probably cache the view and figure out which queries are taking 24% of the loading time.

#### Your turn

Rails makes fragment caching super easy. If you need a refresher on how it's done, take a look at the [docs](http://guides.rubyonrails.org/caching_with_rails.html).

Cache the show page and see if your load times improve on New Relic.

**NOTE:** Be careful not to cache the bottom part of the view, if you look in `LoanRequest#related_projects` you'll see that it's always random. Caching a random value means that we rewrite the cache every time which is super expensive.

### 4.1. More caching  

There are still more caching we can do here. We are caching parts of the view - which is great and our load times should improve slightly - but there are still more caching we can do in the `LoanRequest` model. As we saw on New Relic, 30% or so of the load time is due to database lookups.

#### Your turn

Go through the `LoanRequest` model and cache the appropriate values. How can we make the cache keys unique?

### 5. Query optimization

Since we are only dealing with the `LoanReqeust` model, there's not much query optimization we can do. If you decide to work more on the project, you can use the Bullet gem (see below) to detect N+1 queries and more.

#### Your turn

Find and improve the slow query in the `LoanReqeust` model.

### 5.1 Query optimization using the Bullet gem

The [Bullet](https://github.com/flyerhzm/bullet) gem is used to detect n+1 queries and unused eager loading in our application. Read the README, set it up in your application.

These are the configs I used:

```ruby
Bullet.enable = true
Bullet.alert = true
Bullet.bullet_logger = true
Bullet.console = true
Bullet.add_footer = true
```

Click around the application, Bullet will notify you when there's an N+1 query or eager loading. The `.add_footer` config will display at the bottom of the page whenever Bullet detects an issue. Make sure you are testing bullet on pages that actually loads things. You won't get any notifications on a cart view if the cart is empty for example.

### 6. Next steps

If you are done, go back to `lib/load_script/session.rb` and put the `sign_up_as_lender` method back in the array in the `actions` method. Rerun the load script, and look at the load times on New Relic and try to figure out how to improve performance. 

Gradually add more actions to the load script to cover more parts of your application (see below). 

---

### Extra extra: Your turn

If you want more practice working with performance optimization, build out the load script to hit more views. Just as before, look at New Relic to identify bottlenecks.

The load script should cover the following:

* Anonymous user browses loan requests
* User browses pages of loan requests
* User browses categories
* User browses pages of categories
* User views individual loan request
* New user signs up as lender
* New user signs up as borrower
* New borrower creates loan request
* Lender makes loan

If you want some practice writing a loadscript, spend some time (some time = 30ish min) building it out and then reference the [load script](https://github.com/applegrain/scale-up/blob/master/lib/tasks/load_script.rake) I used for this project.
