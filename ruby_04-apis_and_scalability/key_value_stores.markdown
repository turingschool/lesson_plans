---
title: Key/Value Stores
length: 120
tags: redis, key, value, NoSQL
status: draft
---

### Understand the problem
Demonstrate the problem before going into the solution. Have students work through the [Caching Data Tutorial](http://tutorials.jumpstartlab.com/topics/performance/caching_data.html)
  
Stop at `Using Rails.cache` heading.

Why is this approach limited?
Answer questions.

### Explain how we will solve
Where key/value stores fall in the big picture:
- Rails app
- Relational DB
  - Postgres, Sqlite
- NoSQL options (_brief_ overview of other NoSQL options as a refresher)
  - Document DBs (MongoDB)
    - Store complex data-structure with key-value pairs or sub-documents within them
      - XML, JSON, BSON
  - Graph Stores (Neo4j)
    - Store information on networks.
    - Social connections (Recommendations on friends or who to follow)
  - Wide-Column Stores (Cassandra)
    - Optimized for big data applications
    - doesn't use rows
  - Key-Value Stores
    - Simplest NoSQL DBs
    - Riak, Amazon Dynamo(supports document and key value), Redis
- Why we choose Redis for a solution and a general explanation of what a key/value store is
  - Because it's _FAST_!

### Implement the solution
Work from Rails.cache until Explicit Cache Expiration
After completed, demonstrate the following:
- Clear the cache
- Check the cache from redis-cli so they can see it disappearing
    - Reload the web page
    - How can we prevent the lag for the initial page load?
      - Background workers as a possible solution 

- When is the info that we cached invalid?
  - Whenever a new article or comment is added

Finish the tutorial starting from Explicit Cache Expiration
- This lesson to be followed up by [key/digest based caching](http://tutorials.jumpstartlab.com/topics/performance/digest_based_caching.html)

