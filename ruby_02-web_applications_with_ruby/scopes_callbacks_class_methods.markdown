---
title: Scopes, Callbacks, Class Methods
length: 90
tags: class methods, scopes, callbacks
---

## Goals

* Understand how callbacks work.
* Start to understand how to implement a PORO in place of a complicated scope.
* Use callbacks to your advantage.
* Use previous knowledge of class methods with Active Record.
* Use scopes for basic filtering.
* Understand the differences, advantages and disadvantages to both
scopes and class methods.

## Repository

* http://github.com/mikedao/treat-yo-self

## Callbacks and POROs.
* This is our problem.

```ruby
class OrdersController < ApplicationController
  def create
    credit_card = order_params[:credit_card_number]
    credit_card = credit_card.gsub(/-|\s/,’')
    order_params[:credit_card_number] = credit_card

    @order = Order.new(order_params)

    if @order.save
      flash[:notice] = "Order was created."
      OrderMailer.order_confirmation(@order.user).deliver
      @order.user.update_attributes(status: “active”)
      redirect_to current_user
    else
      render :new
    end
  end
end
  ```

  * This action is doing entirely too much. You're sanitizing the card number,
  sending an email if successful, updating the current_user.
  * This gets messy if we need to add additional behaviors.

```ruby
class Order < ActiveRecord::Base
  before_validation :sanitize_credit_card
  after_create :send_order_confirmation
  after_save :set_user_to_active

  private

  def sanitize_credit_card
    credit_card.gsub(/-|\s/,’')
  end

  def send_order_confirmation
    OrderMailer.order_confirmation(user).deliver
  end

  def set_user_to_active
    user.update_attributes(status: “active”)
  end
end
```

* Meet `before_save` and `after_create`
* We just pull a TON of things out of the controller.
* This is pretty good, but we can do better.
* The danger here is that the Order class knows entirely too much about other
classes.
* This is dangerous because if you make a mistake somewhere, and say there's
a problem with something of the User class, the Order class isn't really
the first place a person would go look.
* As a change of pace, before we correct this, we're going to take a slight detour.

1. before_validation
2. after_validation
3. before_save
4. before_create
WRITE TO THE DATABASE
5. after_create
6. after_save

before_update
after_update

before_destroy
after_destroy

* These are some additional callbacks with their order of operations.
* Note: before_save gets called when we update and when we create.
* before_create only gets called before a craete.

* So, our previous problem.
* We keep this up, and we get a prettu unwieldy Order class that touches
way too many other things.
* We should use a PORO instead.

```
class OrderCompletion
  attr_accessor :order

  def initialize(order)
    @order = order
  end

  def create
     if order.save
       send_order_confirmation
       set_user_to_active
     end
   end

  def send_order_confirmation
    OrderMailer.order_confirmation(user).deliver
  end

  def set_user_to_active
    order.user.update_attributes(status: “active”)
  end
end
```

* Here, we've moved all logic in order completion to a single place.
* You should only use a callback when it deals with the model instance you're currently working with.
* after call backs are often code smells. That's why we fixed it.
* Callbacks that can trigger callbacks in other classes are bad news bears.

* Let's practice using callbacks in our app.


## Class Methods

* We can use class methods to do some filtering, and pushing logic down the
stack.
* We want to put the top three most expensive items in our index view.
* How can we get the information we need?
* Logic doesn't belong in the view.
* It doesn't belong in the controller either.
* There's one last place it can go. The model.

## Scopes

* Scopes allow you to define and chain query criteria in a declarative and
reusable manner.
* Scopes take lambdas.
* A lambda is a function without a name.
* We won't go into lambdas right now, but at the bottom of the page, there are
resources where you can learn more about lambdas.
* Here's some examples.

```
class Order < ActiveRecord::Base

  scope :complete, -> { where(complete: true) }
  scope :today, -> { where("created_at >= ?",
                           Time.zone.now.beginning_of_day) }
end
```

* They can take arguments.

```
class Order < ActiveRecord::Base

    scope :newer_than, ->(date) {
        where("start_date > ?", date)
          }

end
```

* Let's convert our code into a scope.

## Scopes vs Class Methods
* These look eerily similar.
* But there are key differences.
* Scopes can always be chained.
* Class methods can be chained only if they return an object that can be chained.
* Scopes automatically work on has_many relationships.
* You can set up a default scope.

## Other Resources:

* https://rubymonk.com/learning/books/1-ruby-primer/chapters/34-lambdas-and-blocks-in-ruby/lessons/77-lambdas-in-ruby
* https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/18-blocks/lessons/64-blocks-procs-lambdas
* http://www.reactive.io/tips/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/
* [Where to Put POROs](http://vrybas.github.io/blog/2014/08/15/a-way-to-organize-poros-in-rails/)
