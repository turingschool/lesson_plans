---
title: Testing with Dependency Injection
length: 90
tags: tdd, ruby, dependencies
---

# Testing with Dependency Injection

## Standards

* test dependencies using mocks

## Structure

* 5 - Initial Setup
* 10 - Mocking
* 20 - testing and implementing merchant (together)
* 20 - testing and implementing order (in pairs)
* 20 - testing and implementing merchant repository (together)
* 25 - Choice: testing and implementing order repository OR testing dependencies in real project

## Lesson

#### Initial Setup

* clone [this repo](https://github.com/rwarbelow/testing-dependency-injection.git)
* what is already set up?
* why is an instance of merchant initialized with a repository?
* what is dependency injection?

#### Mocking Merchant

We want to be able to call `merchant.items`. What should happen at this point? The merchant should delegate this task to its repository (who will in turn delegate the task to the sales engine -- don't worry about this for right now). 

Let's draw a picture to understand how this works.

All we care about for now is the fact that when we call `merchant.items`, some method gets called on the repository. We're not concerned about what gets returned; we just want to know it happened. For this, we can use a mock.

##### Mocking in Minitest Syntax

```ruby
mock = Minitest::Mock.new
mock.expect(:method_that_should_be_called, faked_out_return_value, [method_arguments])
#some code execution
mock.verify
```

#### Testing and Implementing Merchant

Let's look at how to use a mock repository in the merchant test. 

Key Points

* we'll mock out the repository
* pass in the mock repository to the new instance of merchant
* set up an expectation for what method should be called on the repository
* call `merchant.items`
* verify that the method was called on the repository

Repeat this process for `merchant.invoices`.

#### Testing and Implementing Item

In pairs, use a mock repository in the item test. You should be able to call `item.merchant` or `item.invoice_items` and it should delegate the task to the repository. 

#### Mocking Merchant Repository

When we call `merchant.items`, we set up the expecation that the method `merchant_repository.items_from(id)` should be triggered. The merchant repository should then ask its sales engine to find this information. 

#### Testing and Implementing Merchant Repository

Let's look at how to use a mock sales engine in the merchant repository test. 

Key Points

* we'll mock out the sales engine
* pass in the mock sales engine to the new instance of merchant repository
* set up an expectation for what method should be called on the sales engine
* call `merchant_repository.items_from(id)`
* verify that the method was called on the sales engine

Repeat this process for `merchant_repository.find_invoices_from(id)`.

#### Testing and Implementing Item Repository (OPTIONAL)

In pairs, use a mock sales engine in the item repository test. You should be able to call `item_repository.invoice_items_from(id)` or `item_repository.merchant_for(id)` and it should delegate the task to the repository. 

## Wrapup

Return to standards and check progress.
* What was easy?
* What was challenging?
* What made sense?
* What didn't make sense?

## Corrections & Improvements for Next Time

### Taught by Rachel
