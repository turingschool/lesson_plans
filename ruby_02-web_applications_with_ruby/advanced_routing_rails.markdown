# Advanced Routing in **Rails**


## Warm Up

* What do you **know** about routing in Rails so far? 
* Is there anything you know you don't know?


## Learning Goals

- Why/when do we use namespace in our routes?
- What is the difference between Namespacing and Scoping?
- When would we use one over the other?
- In what case should you use Nested Resources?

## Review 

How confident are you that you can create all 8 prefixes/http-verbs/uri-patterns/controller&actions that Rails gives you when you have the following?

```
# config/routes.rb

resources :cats
```


### Resources will give us the following:
![Resources Cats](http://i.imgur.com/efXfyNW.png)

### Example:

Let's say we have:
- cats
- admin

We want a way to distinguish your routes so an admin has additional functionality/control over your application.


Let's say we want `http://localhost:3000/admin/cats` to show edit/delete buttons for each individual cat (and only admin's can get here).

We also want `http://localhost:3000/cats` to show a list of cats (and anyone visiting our application can get here)

What can we do?

### Scope


```
# config/routes.rb

scope :admin do
	resources :cats
end
``` 

Adding `scope` to our routes gives us the following when we run `rake routes`:

![Scope 150%](http://i.imgur.com/O10zMLa.png)


### Workshop

Using the follow [practice repository](https://github.com/case-eee/horse-example), add a route so a user can hit `/admin/horses` and see all the horses. 


### Recap

* What did you add to your `routes.rb`?
* Can anyone spot potential problems?


### Problems with **scope**	

We're going to need a way to **differentiate** our controllers. We want what we already have (the url prefix) **AND** a separate controller to encapsulate the different functionality. 

We want both `/admin/cats` and `/cats` to be handled by our controllers in different ways. 

### Scope and Module

```
scope :admin, module: :admin do
	resources :cats
end
``` 

If we have `scope` with `module` in our routes, we will get the following `rake routes` output:


![Scope-Module 150%](http://i.imgur.com/GvKOhiv.png)

By using `module`, Rails looks for our controller in a different place. 

```
# When we hit "http://localhost3000/admin/cats"

# app/controllers/admin/cats_controller.rb
class Admin::CatsController < ApplicationController
	def index
		@cats = Cat.all
	end
end

```

**Note:** Where do you think Rails will look for this view template? It will look in the `views/admin/cats` folder. 


### Workshop

* Add a route so a user can hit `/admin/horses` and see all the horses with links on each horse to edit and delete the specific horse
* Add a route so a user can hit `/horses` and see all the horses

### Recap
* What did you add to your routes?
* Any questions?
* Do you notice anything missing when you run `rake routes`?

As you may have noticed, we don't have any path helpers that are specific to this "special" `admin` prefix. Again, Rails can help us out with this.


### Scope and Module and As

```
scope :admin, module: :admin, as: :admin do
	resources :cats
end
``` 

This produces the following when we run `rake routes`:


![Scope-Module-As 150%](http://i.imgur.com/eY5o0wx.png)

So what does using `scope`, `module`, and `as` provide for us?

* path helpers via the prefix (`admin_cats_path`)
* controller prefix (`Admin::CatsController`) for more organization
* url prefix for user's to see in their browser (`http://localhost:3000/admin/cats`)

As you may have expected, this seems like a lot of work for something that's used quite often. Rails actually makes this even easier for us. 

### Namespace

Namespace **=** scope + module + as

```
namespace :admin do
	resources :cats
end


scope :admin, module: :admin, as: :admin do
	resources :cats
end
```

### Why should we use `namespace`, `scope`, `module`, or `as`? 

* readability
* organization
* specificity


Can you imagine what happens when you have 400 lines in your routes file?!

### Nested Resources  

Let's say we have these relationships:

```
class Cat < ActiveRecord::Base
	has_many :votes
end

class Vote < ActiveRecord::Base
	belongs_to :cat
end

```

My `config/routes.rb` might look like the following:

```
resources :cats do
	resources :votes
end
```

### Recap
What's the difference between using **namespace** and **nested resources**?


### Member

If you only want one route with a specific ending, you can use `member`:

```
resources :cats do
	member do
	  post :votes
	end
end

# post '/cats/:id/votes'

```

### Time permitting
Practice with these advanced routing concepts with the following [repository](https://github.com/case-eee/lesson-example)

### Closing
Can you answer these questions?

- Why do we namespace things?
- What is the difference between Namespacing and Scoping?
- When would we use one over the other?
- In what case should you use Nested Resources?
