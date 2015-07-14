---
title: Building Notifications
length: 180
tags: redis, pubsub, rails, services, notifications
---

## Structure

* 15 - Kickoff
* 155 - Work Time
* 10 - Wrap Up

## Resources

* [Extracting a Notification Service Tutorial](http://tutorials.jumpstartlab.com/projects/monsterporium/extract_notification_service.html)
* [Monsterporium Installation Instructions](http://tutorials.jumpstartlab.com/projects/monsterporium/setup.html)
* [Monsterporium Repository](https://github.com/JumpstartLab/store_demo)

## Kickoff

* Frank's Monsterporium is a Dinner Dash (née Store Engine) example project.
* It sends out emails when a user creates an account or places an order.
* As it stands, the email is sent as a blocking action in the controller.
* We're going to abstract it out to a service using Redis for pub/sub.
* Instead of sending the email from the control (and blocking our HTTP response to the user), we'll send a message to our notifications service via Redis, which will send out the email.

At the end of the first, we're going to have two applications:

1. Our original Rails application
  * The request comes in from the user
  * The resource is created
  * A message is posted to the message channel (Redis)
  * The creation-successful response is sent back to the user
2. A secondary application in `lib/notifications.rb`
  * The listener waits until it sees a message on the channel
  * When a message is found, it
    * pulls in and parses the data
    * dispatches the email

After we've separated out our email sending functionality, we'll build a standalone application that fulfills a similar function.

## Work Time

Work through the tutorial in pairs.
