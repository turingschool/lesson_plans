---
title: Performance Dojo
length: 180
tags: ruby, rails, activerecord, sql
---

## Learning Goals

* Discuss performance limitations of database queries with regard to
increased DB scale and load
* Discuss common ActiveRecord techniques for managing increased database scale.
* Practice using each technique against a large JSBlogger dataset
* See some techniques for handling less common, more complicated
  ActiveRecord queries
* Get more practice expressing complex relational logic via ARel

## Setup - Blogger with DB Load

For this lesson, we'll use a special branch of blogger configured with a large
dataset. Set this up like so:

```
git clone -b blogger-perf-workshop https://github.com/JumpstartLab/blogger_advanced.git
cd blogger_advanced
bundle
rake sample_data:load
```

You should see some postgres output running through your terminal. Once
it's done, fire up your rails console and check the `count` of the Comment
model. You should have a lot (300k+) of them.

## Discussion - SQL Performance Limitations

### Q: Why are developers so concerned with database performance?

If you follow much of the tech (and especially web development) blog/think-o-sphere,
you'll probably notice lots of discussion around database performance limitations and
optimizations. It appears as a frequent topic of interview questions, blog posts, conference
talks, etc.

Let's discuss a few reasons why:

* At a high level, how might we describe the "architectural shape" of most web apps?
(DB-heavy; low algorithmic complexity; HTTP necessitates lots of i/o even for repeated reqs)
* How would we describe the performance profile of most (naive) SQL operations?
(find on 10 rows vs find on 10000 rows? where on 10 rows vs where on 10000 rows?)

(__Demo - Slow Queries on Blogger Dataset__)

Students should watch as instructor demonstrates a few queries against the large blogger
dataset.

Especially focus on:

* Some operations will scale consistently (i.e. constant time) -- last, first, count, find (indexed)
* Some operations will scale linearly with number of rows (where, find_by)

Example: `Article.find_by(title: Article.last.title)`

On master w/10 rows (sqlite)

```
irb(main):001:0> Article.find_by(title: Article.last.title)
  Article Load (0.1ms)  SELECT  "articles".* FROM "articles"   ORDER BY "articles"."id" DESC LIMIT 1
  Article Load (0.2ms)  SELECT  "articles".* FROM "articles"  WHERE "articles"."title" = 'Suscipit Dolores Nihil Et Vero Soluta 9' LIMIT 1
=> #<Article id: 10, title: "Suscipit Dolores Nihil Et Vero Soluta 9", body: "Earum amet voluptatum sunt. Qui doloribus laborum ...", created_at: "2015-07-08 18:57:43", updated_at: "2015-07-13 01:57:43", author_id: 3>
```

On perf branch with 70k rows (postgres)

```
irb(main):001:0> Article.find_by(title: Article.last.title)
  Article Load (1.6ms)  SELECT  "articles".* FROM "articles"   ORDER BY "articles"."id" DESC LIMIT 1
  Article Load (17.1ms)  SELECT  "articles".* FROM "articles"  WHERE "articles"."title" = 'Non Harum Nemo Culpa In Id 70000' LIMIT 1
=> #<Article id: 70001, title: "Non Harum Nemo Culpa In Id 70000", body: "Velit ut veniam dolorem. Molestiae qui aut laudant...", created_at: "2015-04-02 14:16:42", updated_at: "2015-04-27 02:16:42", author_id: 3347>
```

Example: `Comment.where(article_id: 7).count`

On master w/10 rows (sqlite)

```
irb(main):004:0> Comment.where(article_id: 7).count
   (0.3ms)  SELECT COUNT(*) FROM "comments"  WHERE "comments"."article_id" = 7
=> 6
```

On perf branch with 340k rows (postgres)

```
irb(main):008:0> Comment.where(article_id: 7).count
   (55.3ms)  SELECT COUNT(*) FROM "comments"  WHERE "comments"."article_id" = 7
   => 7
```

### A: It turns out that:

* An average web app is very database reliant -- at their core most of them are just
tools for displaying information from a data store and inserting it back in.
* The performance of SQL operations is relatively _inelastic_. The baseline often gives
great perf for small datasets, but for larger datasets the linear time growth is unacceptable.

### Q: What about database "load"?

* What's the difference between performance of a single query and load/performance of the entire DB?
* What sort of limitations might we run into as the DB _load_ increases? (Even if avg query
time is relatively good)

### A: A DB is also relatively inelastic from the perspective of load as well

Consider the `Comment.where(article_id: 7).count` example above. If our avg
query time is `0.3 ms` for that query, how many can we run in a second?

```
1000 ms / 0.3 ms per query = 3,333 queries per second
```

Not bad.

What about in the slower example?

```
1000 ms / 55 ms per query = 18 queries per second
```

Unsurprisingly, that's a lot less. But most importantly, what happens
if we start to go _over_ 18 queries per second?

With some exceptions (parallel query access, etc) a DB does have hard limits
to how much it can process in a given amount of time. Surpass that limit, and it
just can't keep up -- the query queue will start to grow, so that even a query
which by itself takes 20 ms will take 80 ms to get processed.

Since queries are ultimately triggered by user requests, this means users are
waiting as well, and the whole thing crawls toward a standstill. This brings
us to the dreaded web application database bottleneck, and explains
why it's such an important topic in web application performance and
architecture discussions.

(example anecdote -- infamous twitter fail whale and world cup 2008)

## Avoiding the DB Bottleneck -- SQL and ActiveRecord Performance Techniques

Fortunately this doesn't have to be us. Modern databases are quite powerful and
give us a lot of tuning and optimization tools. All we have to do is learn them.

Let's talk through a few of these:

1. Measuring and Analyzing Queries (if you can't measure it, you can't fix it)
2. Improving query times with indexing
3. Removing N+1 queries with `ActiveRecord::Base.includes`
4. Reducing query size with `select` and `pluck`
5. Consolidating data storage with hstore / json

## 1. Measuring and Analyzing Queries

As with all performance work, when tuning a DB we want to focus our
efforts on the "biggest wins", i.e. the bottlenecks. Optimizing
a query that takes 0.5 ms probably won't help our application much,
but optimizing one that takes 1 s will.

Additionally, ActiveRecord can sometimes take us by surprise with the
queries it generates, so we'll look at some tools for getting more
detail about what exactly ActiveRecord plans to do in response to a
given query.

Let's look at a few tools:

1. ActiveRecord built-in query logging
2. NewRelic / Skylight query tracking
3. ActiveRecord#to_sql
4. ActiveRecord#explain

#### 1. Log File & Console

In Rails 3.2+, ActiveRecord logs query strings and query times of
all SQL it executes. This information will appear both in application

__Exercise (5 minutes): Using SQL Query Time output__

Students use ActiveRecord from the Blogger rails console to find the following information, and note
the reported query times:

1. The last article ordered by `created_at` date
2. The first Comment
3. All comments attached to the article with the title "Earum Sequi Labore A Corporis Tenetur 66999"
4. All comments posted by the author "Brayan Larkin"

#### 2. RPM

Within New Relic's RPM, you can look into the "Details" of a request and drill down into the SQL.
If you want to know where a query came from, look for the "Rails" link and scan through the stack trace.

__Exercise (10 minutes): Use Newrelic in Dev Mode to View Queries__

1. Start your rails server and visit a sample article page (e.g. [http://localhost:3000/articles/68](http://localhost:3000/articles/68))
2. Visit the [development newrelic page](http://localhost:3000/newrelic)
3. Find the Article#show request you made and click the "Show SQL" link to view sql statements
4. Find the 3 slowest queries from the request.
5. Open the blogger source. Starting from the Controller and working down into the Views,
try to guess which specific pieces of code triggered the 3 queries you saw in the SQL log.

#### 3. `to_sql`

`ActiveRelation#to_sql` returns a string of the literal SQL used to generate that relation.

This can be a really excellent tool for understanding how adding more ARel method calls and parameters affect the resulting SQL.

__Demo: instructor demonstrates using to_sql on a few basic queries__

__Exercise (3 minutes): Using to_sql__

Try running `to_sql` on some queries in the console. Experiment
with several different queries to find:

1. A query that uses `SELECT some_table.*` in its execution
2. A query that uses a `WHERE` clause in its execution
3. A query that uses an `ORDER BY ` clause in its execution

#### 4. `explain`

Viewing the raw SQL for a query can be a good place to start debugging it, but there's actually
more to a query than just a string of SQL statements.

Under the hood, the database is responsible for reading strings of
SQL statements and fetching the requested data from its storage.

It does this by generating a "query plan" -- a type of algorithm describing
the steps needed to find a given piece of data.

This can also be a useful piece of information to have when troubleshooting
queries, and fortunately ActiveRecord makes it available to us
via the `.explain` method.

__Demo: instructor demonstrates using explain on a few basic queries__

__Exercise: SQL explain__

Use Arel to write queries for the following pieces of information:

1. The _second 5_ articles
2. The article with ID 70000 (note: you won't be able to use explain with `find_by`, so you may need to rephrase this query using `where`)
3. The _first 3_ comments with Article ID 2

Then use `explain` on each query and note the response ActiveRecord gives you.

__Discussion: Query Plan Types -- Sequential Scan vs Index__

## 2. Improving Performance with Indices

What difference did we notice using SQL Explain between
finding articles by ID vs just grabbing 5 in order out of the table?

An index is one of the easiest ways to improve performance when querying
your tables.

__Discussion: How is an Index like a Hash?__

__Demo: Instructor Demos Hash vs. Array retrieval perf while adding records__

__Discussion: Instructor talks through the points about indices [here](http://tutorials.jumpstartlab.com/topics/performance/queries.html#indices)__

__Exercise: Indexing Comments on Article ID__

One of the most common types of columns to index is a foreign key. This
provides a lot of benefit because we tend to query on these columns frequently.

For example, consider how we look up the comments associated with a given
article. Using ActiveRecord, we can simply request `Article.find(2).comments`.

But at the database layer, this requires a query which goes through the comments
table and pulls out all the rows with a matching `article_id` of 2.

Practice indexing using this example.

1. Check the current SQL methodology for finding article-related comments
by using `.explain` to explain the query for finding all comments
associated with the first article.
2. Generate a migration to add an index to the `comments` table on the
`article_id` column.
3. Run the migration then re-try the query from before. Note the change
in the SQL explanation.

## 3. Removing N+1 Queries using `includes`

Sometimes we run into performance trouble not from the speed of a single
query but from the _number_ of queries a piece of code generates.

This is often called an __N+1__ query. To understand why, let's look
at an example.

__Exercise: Students Generate an N+1 Query__

In your Rails console, write a piece of code that does the following:

1. Find the first 5 Articles
2. For each article: __a)__ Print its title to the terminal and __b)__ For each of its comments, print the comment's Author Name
3. Scan through the terminal output this produces and pull out the lines
indicating query executions. What do you notice about them?

__Discussion: N+1 - name and symptoms__

__Discussion: Includes as an ActiveRecord Feature__

One thing to keep in mind is that many of the features (especially indexing
and SQL explaining) we've been looked at are things baked into the
database engine which ActiveRecord simply gives us a convenient interface
to.

`ActiveRelation.includes` is a convenient feature to help us eliminate N+1
queries by moving a bunch of small queries into a single bulk query.

However this is something implemented at the Ruby / ActiveRelation layer rather
than something baked specially into the DB.

When using `.includes`, ActiveRecord _automatically_ makes a second query on our
behalf. This helps us avoid the N+1 scenario because it take ssomething that
was previously:

* 1 query for a collection of articles
* A bunch (N) of small queries for groups of comments

and turns it into:

* 1 query for a collection of articles
* 1 query for a bunch of comments associated with those articles

__Without includes:__

1. Make a query for a collection of articles
2. Start iterating through the articles
3. Make a query for the comments attached to the current article
4. Do something with the comments
5. Repeat 2 through 3 until we run out of articles

__With includes:__

1. Make a query for a collection of articles
2. ActiveRecord automatically generates a query to fetch all
comments associated with those specific articles
3. Iterate through the articles
4. Iterate through the comments attached to the current article,
but we don't need to make a query since AR already did it for us
5. Repeat 3-4

__Exercise: Use includes to avoid N+1 queries in previous example__

Re-write your console printing snippet of code to use
`includes`. Read through all the lines of output produces, and
note the lines representing query executions. Are they different
from our initial example? How? Is the overall time faster?

## 4. Saving Time by Fetching Less Data -- `pluck` and `select`

So far we've looked at a technique to re-structure the way the DB engine
retrieves data we request (indexing) and a way to get ActiveRecord to
generate more optimal query patterns on our behalf (inclusion).

The next techniques are perhaps more subtle, but allow us
to gain a bit of extra performance in some situations by limiting
the amount of data we retrieve from the database.

__Exercise: Identify What Data an Average ARel Query Retrieves__

1. In console, generate a query to fetch the last 6 comments.
2. Read the SQL output for the generated query.
3. What columns is ARel fetching from the table on our behalf? How do we know?

__Exercise: Executing Raw SQL via the AR Adapter__

So far we've interacted with ActiveRecord exclusively through its
Ruby interface (`where`, `limit`, `order`, `take`, etc). But it also
provides us with a mechanism for executing raw SQL if we wanted to.

This is done using the method `#execute` on our ActiveRecord ConnectionAdapter.
We can access this via `ActiveRecord::Base.connection.execute`.

1. Read the console output from the previous example (find last 6 comments) again
and identify the SQL statement it executed
2. Use `ActiveRecord::Base.connection.execute` to execute this SQL statement yourself.
Note that the console output may include some string sanitization that you will want
to omit when executing the SQL yourself.
3. Call `#to_a` on the results to retrieve them as Ruby objects
4. What type of results do you get back? How are these different from the normal
AR objects we're used to getting back from our queries?

__Discussion: ARel default queries and deserialization__

* Why does ARel default to retrieving all columns?
* What type of objects do we get back from a standard ARel query?
* What work is ARel doing behind the scenes to make this work?
* In what scenarios might we be able to do without those objects / use
a more simplified version of the data?

__Demo: Instructor Demonstrates using Pluck / Select to limit data access__

Main Points

* Pluck and Select can be easily chained onto other ARel queries
* Select is not used as frequently -- sometimes surprising to get an ActiveRecord
object without all of its attributes (`MissingAttributeError`) so watch out for that
* Pluck is great when you're going to fetch some records then iterate through them
and only use certain attributes (e.g. `Comment.all.map(&:body)` -- just use `pluck`)

__Exercise: Use Pluck__

1. Use pluck to fetch only the bodies of Comments attached to articles 7,9,182,and 6009
2. Use pluck to fetch only the titles of Articles written by the 587th Author

## 5. Consolidating Queries by Rethinking Data Storage

As a general rule, we tend to store data in small, relatively "atomic" chunks
in our DB. This idea is sometimes referred to as Database "normalization".

But in some scenarios it can impose performance overhead, especially if we require
a lot of columns to store a loosely organized or "sparse" dataset.

Alternatively, we can sometimes suffer from overhead for frequently fetching data
which may not actually change much (if ever).

We can often reduce these problems by re-structuring some of our approaches to
how the data is modeled and stored in the DB.

#### Example 1: Using Static Storage for Frequently Queried Static Data

Many applications have sets of static data that don't change.  A common example would be a list of state names with abbreviations to be used in a form. Our first thought might be to store this in a "States" table with a `state name` and `state abbrev` column.

But if your app uses this data a lot, this will mean a lot of trips to the Database for
information which actually doesn't change (and hence doesn't really need the mutability
that a databse provides).

Data like this can often be pulled out into a static constant, perhaps in a model
or an initializer.

### Static Data

```ruby
 # config/initializers/states.rb
STATE_ABBREVIATIONS = {
  "MD" => "Maryland",
  "ME" => "Maine",
  ...
}
```

Thanks to the global accessibility of ruby constants, this `STATE_ABBREVIATIONS` hash
is now accessible everywhere in the application.

#### Example 2: Serialized Columns

Another possible way to restructure your data is to serialize structures such as arrays
or hashes into a single column in the table.

Data stored in this way is relatively "schema-less", meaning there are no rigid
expectations on its shape as there would be with normal, typed DB columns.

This can give us a lot of flexibility to store data whose shape we may not entirely
know in advance. It also gives us a way to capture some of the flexibility of a "NOSQL"
datastore within our existing relational DB.

__Exercise: Serializing Article Metadata to the DB__

1. Generate a migration to add a new column called `metadata` to the Articles table. Its type
should be `string`.
2. Migrate the DB
3. Set up the appropriate serialization logic in the model by
telling ActiveRecord to `serialize :metadata` in the Article class
4. Create a new article (or update an existing one), giving it some
metadata of `{read_on: Date.today, rating: 5}`. Save the article
5. Reload the article and inspect its `metadata` attribute. What
is the format of this object?

__See Also: HStore Postgres extension__

### Appendinx / Addenda / Miscellany

#### Recap Quiz

Go through the questions in this quiz to see how much you remember from
the previous session (none of this is tracked or graded; it's just a tool to help jog your memory): https://turing-quiz.herokuapp.com/quizzes/query-perf-recap.

#### More Exercises

Let's get some more hands-on experience with improving query performance
by working through the exercises in the tutorial: [http://tutorials.jumpstartlab.com/topics/performance/queries.html#exercises](http://tutorials.jumpstartlab.com/topics/performance/queries.html#exercises)

#### Recap: Joins vs. Includes

Recall that `#includes` is a handy technique for avoiding N+1 queries by
pre-fetching associated data.

Consider our previous example using comments and approvals:

```
a = Article.includes(comments: :approval).first
a.comments.select{|c| c.approved?}.count
```

Here we are actually pre-fetching data for 2 related models along with
our article. The Comment records (associated to our article by a foreign
key and a belongs_to association) and the Approval records (associated
to articles only via the intermediate comment records).

This allows us to avoid making additional queries later if we want to
display the approval or comment data itself (in a nested partial, for
example). But let's check out the queries ARel is performing here:

```
Article Load (0.1ms)  SELECT "articles".* FROM "articles" LIMIT 1
Comment Load (0.1ms)  SELECT "comments".* FROM "comments" WHERE "comments"."article_id" IN (8)
Approval Load (0.2ms)  SELECT "approvals".* FROM "approvals" WHERE "approvals"."comment_id" IN (6, 7, 8)
```

Notice that for each model, we are running a `SELECT....* FROM...` on
the corresponding table. This is great if we intend to actually use the
data (rendering it in a UI or some such), but if we aren't using the
data, it's a bit wasteful.

Let's look at an example where we might want to query against only a
specific portion of the data. Suppose we wanted to find all the comments
which have been approved. Our current technique of using `includes`
allows us to efficiently find the approval information for a specific
comment. But it doesn't help us much with querying against the combined
comment-approval data in bulk.

To do this, we might use `joins` to effectively combine the 2 tables and
then query against all of it at once. So, for example, to find only the
comments approved by user 1:

```
Comment.joins(:approval).where(approvals: {approved_by: 1}).count
```

Here, thanks to the joins, we are able to query against data from the
comments table and the approvals table at the same time. This ability to
perform queries across multiple tables in the DB is ultimately what
makes relational databases so powerful, and the `joins` method is our
main way for accessing this power through rails.

In Summary:

* Includes -- easier to use, less fine grained -- "grab everything just
  in case"
* Joins -- allows greater control but requires more specificity -- "let
  me avoid bloat by specifying exactly what I need"
* Includes intentionally uses multiple queries to fetch all the required
  data (and then caches this data in memory)
* Joins uses actual SQL joins to allow us to address multiple tables in
  a single query

#### Using references to automate creating assocations

As of Rails 4, The `ActiveRecord::Migration` table creation system now includes a
`references` method which automates creating foreign keys for
associations.

So in the past we have always created associations in a migration with
this approach:

```
class CreatePizzas < ActiveRecord::Migration
  def change
    create_table :pizzas do |t|
      t.string  :name
      t.integer :pizza_chef_id
      t.timestamps
    end
  end
end
```

Using the Rails 4 syntax, we could simply specify:

```
class CreatePizzas < ActiveRecord::Migration
  def change
    create_table :pizzas do |t|
      t.string  :name
      t.references :pizza_chefs
      t.timestamps
    end
  end
end
```

and Rails will name the column for us. This is especially useful when
generating a model, since Rails can also add the ActiveRecord
association methods as well:

```
rails g model Pizza pizza_chef:references
```

This will give us a migration including the reference column:

```
class CreatePizzas < ActiveRecord::Migration
  def change
    create_table :pizzas do |t|
      t.references :pizza_chef, index: true

      t.timestamps
    end
  end
end
```

And a `pizza.rb` model file with the appropriate `belongs_to`
association already added:

```
class Pizza < ActiveRecord::Base
  belongs_to :pizza_chef
end
```

Ultimately this is simply a time-saving technique. In some situations
you may even prefer the explicitness of adding them manually, but if
you're confident about the assocations you need to set up, using
references can save you a few seconds.

#### Scopes with Arguments

We've discussed scopes several times in the past, most often for
pre-configuring common queries to be run against specific column states
(find me all the orders which have the status "paid", all the articles
published on today's date, etc).

But scopes aren't limited to querying against static data values --
thanks to the fact that they're implemented using lambdas, we can define
scopes which accept arguments as well.

For example, suppose we wanted to allow users to find only Articles
created after a specific date. To do this, it would be handy if we had a
scope which was limited not just to Today's date, but to any variable
date we might pass in.

This can be done using a scope argument:

```
class Article < ActiveRecord::Base
  scope :published_after, ->(time) { where("created_at > ?", time) }
end
```

```
Article.published_after(10.months.ago).count
```

#### Homework Problem Recaps

Remember these lovely AR homework problems? Let's revisit them to
discuss some that we didn't get to before and to see if there are any
new questions that come up: https://gist.github.com/stevekinney/7bd5f77f87be12bd7cc6.

#### Notes For Next Time

This session was first added for the 2/15 - 3/15 module. During several
previous ActiveRecord sessions (https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/query_performance.markdown, and homework review for https://gist.github.com/stevekinney/7bd5f77f87be12bd7cc6) we had run out of time with 1409 before working through all of the material.

This session served as a bit of mopping up to cover the remaining
material from those sessions, and to try to get students some more
practice writing more complicated AR queries in general.

Ultimately it would probably make sense to break some of these
monolithic AR sessions into multiple smaller sessions on specific topics
so that we are better able to cover all the material. But for the moment
this is how this particular lesson came to be and why it's a bit of a
hodgepodge.
