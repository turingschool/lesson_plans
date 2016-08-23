---
title: Multitenancy Authorization
length: 180
tags: rails, pivot, security
---

## Learning Goals

* Understanding the importance of security in software development
* Learning how to avoid common security exploits
  * Privilege escalation
  * Mass Assignment
  * Cross-site Scripting

## Structure

* 25 - Lecture: Introduction to Security
* 5 - Break
* 15 - Lecture: Privilege Escalation
* 15 - Lecture: Mass Assignment
* 5 - Break
* 35 - Code Time & Workshop: Mass Assignment
* 5 - Break
* 10 - Lecture: Cross-site Scripting
* 35 - Code Time & Workshop: Cross-site Scripting
* 5 - Break
* 5 - Questions & Recap
* 5 - Install Brakeman
* 15 - Auditing Projects

## Setup Prior to Class

* Set up [OregonSale](https://github.com/turingschool-examples/store_engine) prior to class. There won't be time for us to set up during class. Look at the `README` for details.
* Download the [Postman App](https://www.getpostman.com/)

`$ git clone https://github.com/turingschool-examples/store_engine.git fundamental_security`

## Procedure

1. Mass Assignment
  1. Create an account
  2. Create some orders
  3. Look at the update method in the orders_controller
  4. Look at the routes
  5. Change the total cost of an order
  6. Delete an order
  7. Workshop 1
2. Cross-site Scripting
  1. Open app/views/products/\_sm_product.html.erb.
  2. Change line 4 from <%= p.name %> to <%= p.name.html_safe %>
  3. Run the server and navigate to http://localhost:3000/categories/2
  4. Visit the admin page at /admin
  5. In the "Product Management" section, go to the "Grub" tab and find "Rations"
  6. Edit the name to be Rations<script>alert("BOOM!")</script>
  7. Visit/refresh http://localhost:3000/categories/1 and you should see a JavaScript alert box saying "BOOM!"
  8. Workshop 2
3. Install Brakeman

## Workshops

### Workshop 1

1. Create two users.
2. Create various orders with one user.
3. Can you change an order to a different user?
4. Can you change the status of an order?
5. Can you destroy an order?

### Workshop 2.1

1. Change a product or user description in the view to accept html_safe or raw.
2. Modify an article’s name or description and inject some JavaScript.
3. Can you make the page alert some text when it loads?
4. Can you print some output to the console when the page loads?
  1. Can you make the body fade out?
  2. Can you make item titles bigger and change their color?
  3. Can you make buttons blink?

## Supporting Materials

* [Tutorial](http://tutorials.jumpstartlab.com/topics/fundamental_security.html)
* [Notes](https://drive.google.com/open?id=0B4C6lfVKu-E7V2F1SzRlQl8wRUk)
* [Slides](https://drive.google.com/open?id=0B4C6lfVKu-E7UGxzdHYyNFBFTVU)
* [Video 1502](https://vimeo.com/129022094)

## Corrections & Improvements for Next Time

* None
