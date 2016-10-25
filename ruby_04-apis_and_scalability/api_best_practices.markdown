# APIs and Standards

### Learning Goals

- Be able to speak knowledgeably about APIs and Standards
- Understand the value and trade-off of standards
- Be able to contribute to planning a new API

## Why APIs?

APIs are getting more popular. [Programmable Web](http://www.programmableweb.com/category/all/apis) indexed 105 APIs in 2005. That increased to 9,000 in 2013, and they now track over 16,000 web APIs.

- Why have APIs become so popular?
- What problems do APIs solve?

### Discussion

- Open Data
- Microservices

## API Problems

What kinds of problems do we face when designing and developing our API?

Problems could be related to:

- Deciding on a structure
- Documenting that structure before it can be built
- Documenting how to use the API
- Getting people to learn your API so they can use it

### Discussion

- What kinds of problems have you run into in the past?
- Where would you start if you were creating an API from scratch

## Decisions, decisions

If you're going to build your API on top of HTTP, as is quite popular to do with a *web* service, you have a flexible structure to work with:

#### The Request

- URL
- Headers
- Body

#### The Response

- Status code
- Headers
- Body

There are some guidelines for using HTTP in the [HTTP standard](https://www.w3.org/Protocols/rfc2616/rfc2616.html), but you still have a lot of flexibility. Your API needs information from the client to know what to serve, but how do you organize that information? What do you put in the URL? What do you put in the headers? Should you put information in the body of the request?

Same for the response? What do the status codes mean? How should you structure the Body? Do the headers describe what's in the body, or does the body describe itself? Does redundancy add value, or is it wasteful.

And of course, this is just one decision. How do you implement? How do you document? How do you organize your content? How do you format your data?

## Standards

There's probably a standard for all of those things.

#### Advantages

1. Someone else has done the thinking
2. Someone has probably built a framework or tool that will help you implement the standard
3. Someone has probably built a tool to test your implementation
4. More likely that someone on your team knows the standard, or wants to learn it

#### Disadvantages

1. You're locked in. A lot of the advantages go away as soon as you want to modify the standard.

Seriously. Almost implementing a standard is the worst. Don't almost completely implement REST, and then have one non-RESTful interaction that you've buried in your documentation somewhere. Don't send JSON on every response, and then XML for some random old one. I may not know where you live, but I have [ways](https://www.whois.net/) of finding out.


## What is REST?

You learned about REST with respect to Rails in Module 2. Let's revisit it in the broader programming community.

[REST Slides](https://docs.google.com/presentation/d/1KF5ubJmFZWTKULsJYkny6olgSBplAFWwOi0d7wvH9is/edit?usp=sharing)

### REST integrations

#### Frameworks

- Ruby: [Grape](https://github.com/ruby-grape/grape)
- Javascript: [Express](http://expressjs.com/)
- Python: [Falcon](https://falconframework.org/)
- PHP: [Slim](http://www.slimframework.com/)
- Elixir: [Phoenix](http://www.phoenixframework.org/)

And Many More


#### Swagger

http://swagger.io/

Another standard, not technically code, though there are code implementations of the swagger standard.

#### JSONAPI

[JSONAPI](http://jsonapi.org/format/)

Designed to be used with REST, but also not


## REST is dead. Long live REST.

REST was designed to work well with the tried and true HTTP standard. GraphQL attempts to decouple APIs from HTTP.

[GraphQL](http://graphql.org/)

### GraphQL's claims

- As long as you only add functionality to your API, you don't need to version
- You can get more data with fewer queries
- REST is dead
