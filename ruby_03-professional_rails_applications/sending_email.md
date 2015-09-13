---
title: Sending Email
length: 90
tags: rails, email, mandrill, smtp, action mailer
---

## You've Changed

Sometimes in life, people change. Like a frog boiled slowly in a pot of
water, they may not notice. It's our job as friends to let people know:
"You've Changed".

However in-person communication is sometimes a bit dicey. Let's build an
app that lets us do this electronically via email.

What we'd like our app to do:

1. Allow us to sign up / log in
2. Allow us to enter a friend's email address
3. Send that friend a passive-aggressive email notifying them that
   "You've changed".

As we work through this app, we'll be focusing on some familiar
concepts:

1. How do we test-drive the application to verify the
expected email behavior
2. How can we configure our application to send emails in development
as well as in "production"
3. How can we view emails that are sent in a development environment.
(We'll use a tool called Mailcatcher).

## Sending Email in Rails

Topics Covered:

* Application uses for email (mailing lists, notifs, status updates, account management)
* Email history
* SMTP high level overview
* POP / IMAP
* Role of incoming vs outgoing email server
* Using 3rd party SMTP as a Service (i.e. Mandrill)
* Using ActionMailer in rails
* Uses you've changed repo as example

Possible Additions

* Testing Mailers
* Add some TDD to workshop section
* Using Mailcatcher in Dev to view emails

### Materials

* [ Slides ](https://www.dropbox.com/s/ev7tya328sv9jyh/Turing%20-%20Sending%20Email.key?dl=0)
* [ Notes ](https://www.dropbox.com/s/p496zd4xthyrnt6/Turing%20-%20Sending%20Email%20%28Notes%29.pages?dl=0)
