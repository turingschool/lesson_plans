---
title: How the Web Works
length: 90
tags: internet, web, http, dns
---

## Learning Goals

* Understand the relationship between client and server.
* Understand IP addressing.
* Understand the Domain Name System.
* Ports
* Understand HTTP Requests and Responses
  * Header
  * Response Code
  * Body

### The Client-Server Model

* The Client-Server model is a structure that partitions tasks or workloads
between the providers and consumers of a service.
* In general, the server is something that provides a resource or a service.
* In general, the client sends requests of the service provided by a server.
* This division of responsibility is a logical or perhaps virtual one, not
a physical one.
* This leads to some confusion, as a server and a client can also refer to
physical pieces of hardware.
* Example - when you wrote task manger, your laptop was a server and client
at the very same time.
* It was a server because it was running the server software that let your
Sinatra application run, and it was a client because your web browser was
making requests of your Sinatra application.
* [Visual](https://upload.wikimedia.org/wikipedia/commons/c/c9/Client-server-model.svg)


### IP Addressing

* An IP address, or an internet protocol address, is a unique identifying
number given to every single computer on the internet.
* Consider it similar to a person's phone number.
* Too reach a person, they would have to know their IP address.
* Traditionally, they are represented by four numbers separated by dots.
This is IPv4. Like 192.168.1.1.
* Now, with IPv6, it's a bit more complex, an address can look like:
3ffe:1900:4545:3:200:f8ff:fe21:67cf

### How DNS Works

* When we visit a website, we enter the domain name of the website in our
browser's address bar.
* But that's not an IP address.
* How does our computer know how to communicate to the appropriate server?
* We can compare this problem with how we handle phone numbers.
* Nowadays, we don't actualy remember phone numbers.
* If I want to call someone, I look up their name on my phone, and call them
that way.
* When that person receives my phone call, and so long as I am in their address
book, it doesn't display my phone number, but my name.
* Let's say that we want to visit cheese.com.
* Our computer checks it's cache, or short term memory to see if it knows the
IP address of cheese.com.
* We know we visit cheese.com every day, but let's pretend that we've never
been there before.
* First, it's actually going to cheese.com.
* With that extra period. With nothing after it.
* We just don't see it.
* You can test this by going to www.google.com.
* It's just hidden from us, and it stands for the root name server.
* Our computer, upon seeing that it knows nothing about cheese.com, asks
the Resolving Name Server for the IP addresses of domains it does not know.
* If the Resolving Name Server knows where it is, it sends the response back
to our computer.
* If it does not, it then contacts the root name servers and asks it about
cheese.com
* The root name servers know nothing about cheese.com. However, it knows
about the .com, or Top Level Domain name servers. It sends this information
to the resolving name servers.
* So it goes to the TLD name servers, and then asks them about cheese.com
* The TLD servers then directs them to the cheese.com name servers.
* Now these servers are the authoritative name servers.
* So the TLD servers know what the authoritative name servers are because
when you register a domain name, the registrar is told what authoritative
name servers you need to use.
* They tell the organization for the TLD, in this case, .com, and then tell
them to update the TLD name servers.
* So now the authoritative name servers will be like, I KNOW WHERE THAT IS,
and then passes along the IP address they have for that domain.

### Check for Understanding

* What does a resolving name server do?
* What information does a root name server have?
* How does the TLD Name Server know about a domain's authoritative name
server?


### The HTTP Request/Response Cycle

* What is a request?
* It is a set of instructions that tells a server what kind of response we
want.
* Let's use as our example, turing.io/team
* We are going to request this. A request is made up of many pieces.
* The first, a request path.
* Here, it is /path it tells our server what resource we are looking for.
* Next, we have our request Verb.
* When we are just visiting a site, we are using GET.
* This retreives information from our server.
* Other HTTP Verbs include POST, PUT and DELETE.
* Post sends informatoin to the server, Put updates information.
* What do you think Delete does?
* Query data, this is if we had done /team?page=2 we aren't doing this,
but if we had params, that would be the query data.
* We'd have something like this if we had pagination, pagination being
multiple pages.
* Header data, send a request using Postman to show what gets sent in header.
* Header data defines how we expect the response to be formatted
such as in language and encoding.
* See what you're sending [here](https://www.whatismybrowser.com/detect/what-http-headers-is-my-browser-sending)
* Now the server sees the request, the verb and the path.
* The server formulates an HTTP Response.
* The response has headers.
* Cookies are in the headers too.
* Also, Status Codes come back.
* What are some common status codes? 200? 404? 500?
* Finally, there is the body.

### Check For Understanding

* What are the components of an HTTP Request?
* Where are cookies stored in an HTTP Response?
* What is HTTP Code 200?


