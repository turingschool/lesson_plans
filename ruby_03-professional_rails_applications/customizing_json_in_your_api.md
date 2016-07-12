---
title: Customizing JSON in your API
length: 90
tags: json, javascript, rails, ruby, api
---

## Learning Goals

* Generate and customize Rails Serializers
* Create JSON views using Jbuilder
* Compare the two tools

## Structure

* 5 - Recap: Responders
* 5 - Recap: Namespacing and API
* 10 - Lecture: Strategies to customize JSON responses
* 5 - Break
* 10 - Code Walkthrough: Creating Custom Serializers
* 10 - Practice: Applying serializers to other objects
* 5 - Break
* 10 - Code Walkthrough: Jbuilder views
* 10 - Practice: Building jbuilder views for others
* 5 - Break
* 5 - Intro to Hypermedia
* 10 - Comparison: Serializers vs Jbuilder
* 5 - Wrapup/Break

## Recap

### Responders

- Using respond_to and respond_with to serve JSON
- Add respond_with to index
- Add respond_to to controller

### API Namespacing

- Why do we namespace?
- Why do we version?
- In routes
  - Default format of JSON
- In app folder

## Lecture

### Customizing JSON output

When we call `respond_with`, Rails makes a call to `as_json` under the hood unless we have a serializer set up. Eventually, `as_json` calls `to_json` and our response is generated.

Let's imagine that you don't just want the raw guts of your model converted to JSON and sent out to the user -- maybe you want to customize what you send back. There are a few approaches:

1. Try to use some clever combination of ERB and JSON in the view
2. Massage your model into some presentable hash in the controller
3. Override `as_json` on your model ([Example][as_json])
4. Use an ActiveModel serializer
5. Use Jbuilder (a DSL for creating JSON built into Rails 4) in the view layer

[as_json]: https://github.com/JumpstartLab/blogger_advanced/commit/085a9f6681feb3c3623042a9897f037abc6d6bf7

Let's take a look at the last two ways to customize the JSON that gets sent to the user.

```
git clone git@github.com:turingschool-examples/storedom.git customizing_json
```

## Using ActiveModel Serializers to modify `as_json`

[Active Model Serializer Docs][am_serializer_guide]

[am_serializer_guide]: https://github.com/rails-api/active_model_serializers/tree/master/docs

### Intro
- Installed with a gem
- uses model syntax
- Modifies .as_json, which happens in the background of respond_with

### How to
- Create your controller
  - `rails g controller api/v1/orders index show`
  - Fix routes
  - Add responders
  - `rails g serializer order`
- A few attributes
  - Some existing fields
    - `id`, `amount`, `user_id`
  - Some custom fields
    - `num_items`
  - A relationship
    - `items`

### On your own
Do what I did to orders, but on Users now
- Some existing fields
  - `id`, `name`, `email`
- Some custom fields
  - `num_orders`
- A relationship
  - `orders`

## Using jbuilder to build JSON views

[jbuilder docs][jbuilder_readme]

[jbuilder_readme]: https://github.com/rails/jbuilder/blob/master/README.md

### Intro
- Built in to rails 4+
- Uses view files
- What does DSL mean?

### How to
- Create your controller
  - `rails g controller api/v1/orders index show`
  - Fix routes
  - Add ivars
  - Rename views
- Add attributes
  - Some existing fields
    - `id`, `amount`, `user_id`
  - Some custom fields
    - `num_items`
  - A relationship
    - `items`

### On your own
Do what I did to orders, but on Users now
- Some existing fields
  - `id`, `name`, `email`
- Some custom fields
  - `num_orders`
- A relationship
  - `orders`

### Extra: Hypermedia

That `_links` thing in some APIs. How do you do that?

## Comparison
- What differentiates Jbuilder from Serializers?
- When would you use one or the other?

## Resources

Here's some branches of storedom with customized JSON

- Storedom branch for [Serializers](https://github.com/turingschool-examples/storedom/tree/custom_json_serializers)
- Storedom branch for [Jbuilder](https://github.com/turingschool-examples/storedom/tree/custom_json_jbuilder)
