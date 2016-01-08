---
title: Regular Expressions for Fun and Proffit
length: 120
tags: fundamentals, computer science
---

## Learning Goals

1. Understand what a RegEx is
2. Understand why they’re used
3. Be able to read "basic" regexes
4. Be able to write basic regexes,  "basic" includes the ability to use `.\s\d+*` and a capture.
5. Get better at science (answering your own questions)

## Structure

* 30 minutes guided chaos
* 60 minutes students discover and update our shared knowledge
* 30 minutes take the results and solve a challenge


## Content

### Definition

Regex are ways to match strings.

### Axiomatic information

These methods, on strings, are useful:

* `=~`
* `[]`
* `gsub`
* `split`
* `scan`

These variables might or might not get set with information after a match:

* `$1`
* `$2`
* `$3`
* ...

### Guided chaos

Lets figure out how a few of these work.
We'll discover the answer together, I'll lead, but not tell you anything.
You have to tell me which experiments
to try and then summarize what we figure out.

Here are some fun starting strings

```ruby
"HTTP/1.1 200 OK"
"Horace Williams [11:32 AM]"
```


### Coalesce our knowledge!

Break out into groups, figure out as much as you can,
and update a single cheat sheet of information.

[Here](https://github.com/JoshCheek/regular-expression-knowledge-we-have-discovered)
is the result from last time, to get a sense of what it looks like,
but don't take results from it, that robs you of the opportunity to discover!

### Challenge

Run this to get some text to match: `$ curl -i google.com`

* Get me every set of consecutive characters where none of them is a space
  and they include "http" in there somewhere, regardles of case.
  I'm expecting the result to be this:

  ```ruby
  ["HTTP/1.1",
   "http://www.google.com/",
   "http-equiv=\"content-type\"",
   "HREF=\"http://www.google.com/\">here</A>."]
  ```
* Get me every header. I'm expecting this:

  ```ruby
  ["Location",
   "Content-Type",
   "Date",
   "Expires",
   "Cache-Control",
   "Server",
   "Content-Length",
   "X-XSS-Protection",
   "X-Frame-Options"]
  ```
