---
title: Getting Started with Services
length: 90
tags: services, architecture, performance, refactoring
---

## Learning Goals

* Understand how services fit with MVC
* Understand both the **proxy** and **smart client** approaches to services
* Understand the basic role and functionality of a messaging channel

## Warmup

Grab a piece of paper and a pen/pencil.

Imagine you're building a blogging platform that can serve thousands of authors
and millions of readers. The right thing to do is write a "monolithic" app
and refactor it over time -- but imagine you're going to build with services
from the start.

What services would you use? What data would flow between each service? Sketch
out a diagram. You should be able to come up with at least 5 services.

## Lecture

### Warmup Recap

Let's set the stage by discussing how you might answer the warmup.

### Fractal Design

Then let's discuss the *why* of building services:

* What is good software?
* [SOLID](http://bit.ly/nHYoAY) and [SRP](http://en.wikipedia.org/wiki/Single_responsibility_principle)
* Apply it at several layers of abstraction
  * Line of code
  * Method
  * Class
  * **Application**

### Definitions and Concepts

* A **Service**, strictly speaking is an application that runs independently with only the message service as a communication mechanism. But, for our purposes, it's any application that supports the functionality of another application, whether we interact through the message channel or directly via an API.
* A **Message** is an package of data one application communicates with another
* A **Message Service** is the channel which accepts and delivers a message

Then we'll think about two general message service usages:

* **Pub/Sub** is a messaging architecture which allows multiple subscribers to listen to a single publisher
* **Queuing** is a messaging architecture where messages are dropped into a list
and retrieved later

### Services within MVC

#### The Proxy Approach

* Starting with a traditional MVC layout
* The model is responsible for domain logic and data access
* Services are data and domain logic
* As such, they should be encapsulated down at the model layer
* The controller and view shouldn't know that the service exists

#### The Smart Client Approach

* The primary app doesn't have to know everything
* It's acting as a middleman
* We can take advantage of smart JavaScript clients
* Treat the client as the proxy
* Directly access the services and manipulate the DOM
* Completely remove the service from the primary app's MVC

### Identifying a Service

Good candidates for extraction to a service...

* Have limited and known interactions with other parts of the domain logic
* Are conceptual pieces of value rather than just pieces of functionality
* Could potentially be reused in a different application

Poor candidates for service extraction...

* Need access to large pieces of data from the primary application
* Are reading and writing primary application data

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
* http requests
* duplication (creating POROs)

### The Process of Building a Service

Duplicate, Validate, Delete:

1. Implement message sending from the primary app
2. Build the service to consume those messages
3. Validate the functionality of the service in parallel with the primary application
4. Remove functionality from the primary application
