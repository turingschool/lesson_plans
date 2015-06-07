---
title: Getting Started with Services
length: 90
tags: services, architecture, performance, refactoring
---

## Learning Goals

* Understand the concept of a "service" in software architecture
* Understand how service design relates to OOP principles such as SOLID and SRP
* Understand how services might be used in a typical web application
* Understand some patterns of service design
* Understand the basic role and functionality of a messaging channel
* Understand both the **proxy** and **smart client** approaches to services

## Discussion -- Software Design

__Q__ How could we describe the overall process of designing software?

* __A__ Solving problems by subdividing them into smaller __units__ that
can be encapsulated by a specific piece of software

__Q__ What is required to make something a useful software __unit__?

* Needs to do some useful work
* Need some way to receive information about what work needs to be done
* Needs some way to communicate information about what it did

__Q__ What are some of the types of units we use to write software?

* expressions/statements
* methods
* classes
* libraries (gems)
* applications


### Fractal Design

Recall some of the principles we like to think about when analyzing our code:

* [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design))
* [SRP](http://en.wikipedia.org/wiki/Single_responsibility_principle)
* [Law of Demeter](http://en.wikipedia.org/wiki/Law_of_Demeter)
* [Open/Closed Principle](http://en.wikipedia.org/wiki/Open/closed_principle)

We've seen how object-oriented abstractions like methods, classes, and libraries
give us tools to apply these principles in various ways.

It turns out that (good) software systems exhibit the same design principles at
multiple levels of abstraction:

* An expression should easily readable and have clear intent
* Methods within a class should be well-factored and concise
* A class should have a clearly defined responsibility which it fully encapsulates and shouldn't
  leak information unnecessarily
* A library or sub-system within an application should have a well-designed interface, perform some
  useful function and be re-useable in multiple contexts
* __So what about an entire application?__ Does it exhibit these principles as well?

Consider your average rails application. There's a very good chance that it does:

* View templating / rendering
* Data modeling, persistence, and retrieval
* Network I/O
* User authentication
* Background queuing/processing
* Administrative management/reporting
* ... not to mention the actual business logic, which probably involves several problem domains in its own right

Why do we adhere so closely to all of these design principles at a micro level (methods, classes, etc.)
but then turn around and build monolithic applications that absorb every responsibility we can
think of?

This is the problem that a service architecture attempts to solve.

### Definitions and Concepts

* A __Service__ is an application designed to function as a unit
  within a larger application architecture. 

Remember that as a software __unit__, the service will need to:

* __1)__ do some chunk of useful work
* __2)__ Receive information about what work needs to be done
* __3)__ Communicate information about the work that it did

One of the challenges with services is there are practically infinite shapes they
can take. But based on these 3 ideas, we can see that they will vary along 2 common
axes:

* __How does the service do its work internally?__  (languages
* __How does the service communicate with the outside world?__ 

### Common service communication mechanisms

* HTTP - probably most common in today's world.
* Pub/Sub - Publisher(s) send messages to channel that subscribers listen to
* Queueing - Producers enqueue work to be retrieved by a worker later

Common messaging protocols -- HTTP w/json or XML, SOAP, Thrift, TCP, UDP
Common pubsub/queueing technologies - Redis (e.g. Resque, Sidekiq), Kafka, ZeroMQ, RabbitMQ

* HTTP interfaces support great accessibility and tooling, but lower-level interfaces can sometimes offer performance benefits
* A **Message** is an package of data one application communicates with another
* A **Message Service** is the channel which accepts and delivers a message

During the next few weeks we'll probably be working mostly with services that communicate over HTTP or via a Redis queue.
But it's good to have an understanding that these represent only a few of the many options out there.

### Some example services within an MVC application

#### The Proxy Approach

* Extracting separate web application to encapsulate some portion of data or logic within the system
* Often starts with traditional DB-backed setup, then pulls out a service to wrap a specific
  model or set of models
* From the original application data in the service is accessed via a model-like service layer
* The controller and view shouldn't know that the service exists (good OO practices and interface design to allow these refactorings to be done transparently)

#### The Smart (Browser) Client Approach

* Extracting presentation and interaction logic as separate service
* Allows us to incorporate sophisticated JavaScript clients
* The "primary" app doesn't have to know everything -- remove templating and User Interaction from its responsibilities
* Client application uses the web application as a data store and API

## Identifying a Service

Good candidates for extraction to a service...

* Have limited and known interactions with other parts of the domain logic (easier extraction)
* Are conceptual pieces of value rather than just pieces of functionality
* Could potentially be reused in a different application
* Application components with special performance requirements
* Application components with special language or technology requirements (need to use a tool
  in a certain language, but don't want to re-write our whole infrastructure in it)

Poor candidates for service extraction...

* Need access to large pieces of data from the primary application (has its fingers in all the pies -- makes extraction hard)
* Are reading and writing primary application data (needs lots of direct acces to a DB)
* High "back-and-forth" data flow components -- can lead to overly "chatty" API interactions
* "Fat" data  -- e.g. very large data-sets -- can be challenging for traditional transport mechanisms to handle (service extraction may still be possible with data transfer moved offline)

## Exercise - Service Identification

Get into small groups and grab a piece of paper and a pen/pencil.

Consider a service-oriented approach to building your assigned application.
In practice we would probably start with a single "monolithic" app
and refactor it over time -- but imagine you're going to build with services
from the start.

Some example applications to consider:

* github
* pivotal tracker or waffle.io
* instagram
* youtube / vimeo
* pinterest
* stackoverflow
* netflix

What services would you use? What data would flow between each service? Sketch
out a diagram. You should be able to come up with at least 5 services.

### The Pros and Cons

#### Pros

* lower churn
* connect for free / low cost
* failsafe/redundancy
* easier to reason about
* scaling
* reuse
* uncoupled deployment
* reimplement / experiments

#### Cons

* deployment / ops
* versioning
* testing
* http requests (chatty)
* duplication (creating POROs)

### The Process of Building a Service

Duplicate, Validate, Delete:

1. Implement message sending from the primary app
2. Build the service to consume those messages
3. Validate the functionality of the service in parallel with the primary application
4. Remove functionality from the primary application

A note on testing and SOA:

* Good high-level (integration) test coverage can be invaluable for transitioning to SOA.
* Well-factored tests at the appropriate layers (unit, functional, integration) will allow you to keep an eye on the high-level functionality while having free-reign to swap out backends as needed
* SOA can pose additional challenges for testing in consumer applications -- standard DB-based setup mechanisms will no longer be sufficient.
* It is often wise to consider building tooling into your service components (especially clients) to make this process easier
