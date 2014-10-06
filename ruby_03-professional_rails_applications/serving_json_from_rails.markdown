---
title: Serving JSON from Rails
length: 90
tags: json, javascript, rails, ruby, api
---

## Learning Goals

* Modify controllers to conduct RESTful actions through JSON.
* Generate and customize Rails Serializers
* Build a basic API for reading data

## Structure

* 25 - Lecture: Serving JSON from Rails
* 5 - Break
* 20 - Code Walkthrough: Creating Custom Serializers
* 35 - Pair Practice
* 5 - Wrap Up

## Lecture: Serving JSON from Rails

[Use this tutorial][jslapi] for a basic rundown of `respond_with` and `respond_to`

[jslapi]: http://tutorials.jumpstartlab.com/topics/web_services/api.html

### Customizing JSON output

When we call `respond_with`, Rails makes a call to `as_json` under the hood unless we have a view or serializer set up. Eventually, `as_json` calls `to_json` and our response is generated.

Let's say—hypothetically—that you don't just want the raw guts of your model converted to JSON and sent out to the user. There are a few approaches:

1. Try to use some clever combination of ERB and JSON in the view
2. Massage your model into some presentable hash in the controller
3. Override `as_json` on your model ([Example][as_json])
4. Use an ActiveModel serializer
5. Use Jbuilder (a DSL for creating JSON built into Rails 4) in the view layer

[as_json]: https://github.com/JumpstartLab/blogger_advanced/commit/085a9f6681feb3c3623042a9897f037abc6d6bf7

## Code Walkthrough: Creating Custom Serializers

We'll be stepping through code on the [serialization branch][bser] commit by commit.

[bser]: https://github.com/JumpstartLab/blogger_advanced/tree/serialization 

`ActiveModel::Serializer` depends on a gem.

```rb
gem 'active_model_serializers'
```

This will give us a new generator. Let's add a serializer for our Article model.

```sh
bin/rails g serializer article
```

We now have a new file located at `app/serializers/article_serializer.rb`.

### Jbuilder

Jbuilder gives is a simple DSL for declaring JSON structures. Let's step through some code together to get a feel for how it works.

We'll be stepping through code on the [jbuilder branch][bser] commit by commit.

[bser]: https://github.com/JumpstartLab/blogger_advanced/tree/jbuilder 

## Pair Practice

1. Modify `ArticlesController` so **all** actions use `respond_with` and can speak JSON and HTML.
2. Make similar changes to `CommentsController` so comments can be read and written via JSON.
3. Add controller and serializer for authors that allows you to see an author as well as the titles and last updated date of their blog posts.

## Wrap Up

* Of the strategies for customizing your JSON responses, which do you think you'd use when?
* Are there some you'd never use?