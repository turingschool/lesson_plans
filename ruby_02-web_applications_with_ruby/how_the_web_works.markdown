---
title: How the Web Works
length: 90
tags: internet, web, http, dns
---

There are [Josh's slides](https://www.dropbox.com/s/iya4p2i6wvp83tu/how_the_web_works.key?dl=0) or [Rachel's slides](https://www.dropbox.com/s/p85t37ygbaclrto/how_the_web_works_2.key?dl=0) that are intended to use along with whiteboard drawings.

## Learning Goals

* Understand the relationship between client and server
* Understand HTTP Requests
  * Protocols
  * HTTP Verbs
  * Address
* DNS Lookup
* IP Address
* Ports
* Servers
* Understand HTTP Responses
  * Header
  * Response Code
  * Body

### Notes for Discussion

- Client - Browser, command line using tools like cURL.

- Request
  GET /path/file.html HTTP/1.0
  From: someuser@example.com
  User-Agent: HTTPTool/1.0

  - Protocol
    - HTTP - Foundation of data communication on the Web
    - IMAP, SSH, SMTP, FTP
  - Verb
    - GET - Retrieve information identified by the Request-URI.
    - POST - Create a new resource identified by the Request-URI.
    - PUT - Update a specific resource identified by the Request-URI.
    - DELETE - Delete the resource identified by the Request-URI.
  - Address
    - DNS lookup


- DNS Lookup
  - Domain Name System
  - Protocol within the set of standards for how computers exchange information (called TCP/IP).
  - Massive database mapping domain names to IP addresses.
  - DNS name resolution.
  - DNS servers are often selected by configuration settings sent by your Internet service provider (ISP), WiFi network,
    modem or router that assigns your computer's network address.
  - It's a distributed system on millions of machines managed by millions of people.
  - Check for the domain name and IP address in its database, it resolves the name itself.
  - If it doesn't have the domain name and IP address in its database, it contacts another DNS server on the Internet.
  - Cache the lookup results for a limited time so it can quickly resolve subsequent requests to the same domain name.
  - Return an error indicating that the name is invalid or doesn't exist if it can't find the domain.


- IP Address
  - IPv4 uses 32 bit addresses or 2**32
  - Human readable:
    - 172.16.254.1
    - 172     .16      .254     .1
    - 10101100.00010000.11111110.00000001
    - 76543210 (Places of binary)
    - Each number is one byte, or eight bits
  - Some addresses are reserved
    - 127.0.0.0/8 (Is this a range of 0-8???)
  - IPv6 uses 128-bit addresses or 2**128


- Port
  - Endpoints on a connection
  - Allows processes and applications running on a machine to share a physical connection to a packet-switched network like the Internet.
  - Well known ports are reserved.
    - HTTP 80, HTTPS 443


- Server
  - Apache/Nginx routes to Puma, Unicorn or Passenger


- Response
  - Header
  - Response Code
  - Body
```html
  HTTP/1.0 200 OK
  Date: Fri, 31 Dec 1999 23:59:59 GMT
  Content-Type: text/html
  Content-Length: 49

  <html>
  <body>
  <h1>Hello World!</h1>
  </body>
  </html>
```
### Resources
[Request Protocols](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html)
[IP Addresses](http://en.wikipedia.org/wiki/IPv4#Addressing)

