---
title: Pub/Sub in the Browser
length: 180
tags: redis, pubsub, rails, services, notifications
---

## Structure

15 - Kickoff
155 - Work Time
10 - Wrap Up

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

## Work Time

Work through the tutorial in pairs.

## Wrap-Up

(Forthcoming…)