---
title: Advanced Database Topics: Views, Replication and Clustering
length: 180
tags: postgres, database, clustering, replication, sql, active record
status: draft
---

# Advanced Database Topics - Views, Replication and Clustering

## Learning Goals

* Understand the use-cases for some more advanced SQL techniques
* Introduce SQL virtual tables
* Practice creating SQL views from SQL interface and from ActiveRecord
  migrations
* Understand SQL logs as a mechanism for sharing state of a database
* Understand mechanics of leader-follower database setup
* Practice configuring master-follower dbs with Postgres on our machines
* Brief discussion of CAP theorem as it relates to multi-server DB
  setups

### Section 1 - SQL Views

Discussion: Common use-cases for more sophisticated SQL
* ActiveRecord is designed to abstract most common SQL techniques from
  us (Selects, Joins, foreign-key querying, etc)
* When we see complicated SQL in our Rails code, this is a bit of a
  "smell" - we generally want to push SQL logic out of our code
* But SQL is still a powerful tool that we should take advantage of when
  needed
* For some problems, SQL really will be the best tool for the job.
  Common examples: BI reporting, pre-caching complicated data, flattening an object graph for an API

SQL views are one technique we have for taking advantage of more
sophisticated SQL without simply embedding raw query strings in our
code. Let's work through this SQL view tutorial to learn more about how
they work: http://tutorials.jumpstartlab.com/topics/sql/sql_views.html

### Section 2 - SQL Replication

Discussion:
* replication use-cases and performance profile
* SQL as a pre-made log format
* Replication delays for master-follwer replication (good and bad)

### Section 3 - SQL Sharding

Discussion:
* sharding use-cases vs. replication use-cases
* mechanisms of sharding

Reach goal: setting up postgres replication on a VPS

More reading
http://en.wikipedia.org/wiki/CAP_theorem
http://aphyr.com/tags/jepsen
https://devcenter.heroku.com/articles/distributing-reads-to-followers-with-octopus
http://www.postgresql.org/docs/9.3/static/high-availability.html
