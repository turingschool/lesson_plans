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
* 5 - Wrap-up/Break

## Recap

### API Namespacing

- Why do we namespace?
- Why do we version?
- In routes
  - Default format of JSON
- In app folder

## Lecture

### Customizing JSON output

When we call `render json:`, Rails makes a call to `as_json` under the hood unless we have a serializer set up. Eventually, `as_json` calls `to_json` and our response is generated.

Let's imagine that you don't just want the raw guts of your model converted to JSON and sent out to the user -- maybe you want to customize what you send back. There are a few approaches:

1. Try to use some clever combination of ERB and JSON in the view
2. Massage your model into some presentable hash in the controller
3. Override `as_json` on your model ([Example][as_json])
4. Use an ActiveModel serializer
5. Use Jbuilder (a DSL for creating JSON built into Rails 4/5) in the view layer

[as_json]: https://github.com/JumpstartLab/blogger_advanced/commit/085a9f6681feb3c3623042a9897f037abc6d6bf7

Let's take a look at the last two ways to customize the JSON that gets sent to the user.

## Setup

We're going to start where we left off in the internal API testing lesson. We want to work with objects that have related models, so let's add an orders model:

```
rails g model order order_number
rails g model order_item order:references item:references item_price:integer quantity:integer
rails db:migrate
```

Add relationships to your models:

```ruby
# in item.rb
has_many :order_items
has_many :orders, through: :order_items

# in order.rb
has_many :order_items
has_many :items, through: :order_items
```

And whip together a quick seed file:

```ruby
10.times do
  Item.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
  )
end

10.times do
  Order.create!(order_number: rand(100000..999999))
end

100.times do
  OrderItem.create!(
    item_id: rand(1..10),
    order_id: rand(1..10),
    item_price: rand(100..10000),
    quantity: rand(1..10)
  )
end
```

And seed

```ruby
bundle exec rake db:seed
```

## Responses

> What's he building in there? -Tom Waits

JSON responses should contain the following keys from the following endpoints:

**api/v1/items**
```javascript
[
  {
    "id": 1,
    "name": "Hammer",
    "description": "When it is this time, you stop."
  },
  {...}
]
```

**api/v1/items/:id**
```javascript
{
  "id": 1,
  "name": "Hammer",
  "description": "When it is this time, you stop."
  "num_orders": 5,
  "orders": [
    {"order_number": "12345ABC"},
    {...}
  ]
}
```

**api/v1/orders**
```javascript
[
  {
    "id": 1,
    "order_number": "12345ABC",
  },
  {...}
]
```

**api/v1/orders/:id**
```javascript
{
  "id": 1,
  "order_number": "12345ABC",
  "num_items": 5,
  "items": [
    {
      "id": 1
      "name": "Hammer"
    },
    {...}
  ]
}
```

## Using ActiveModel Serializers to modify `as_json`

[Active Model Serializer Docs][am_serializer_guide]

[am_serializer_guide]: https://github.com/rails-api/active_model_serializers/tree/master/docs

### Intro

- Install with a gem: `gem 'active_model_serializers', '~> 0.10.0'`
- Uses model syntax
- Modifies [`.as_json`](http://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html#method-i-as_json), which happens in the background of [`respond_with`](http://edgeapi.rubyonrails.org/classes/ActionController/Responder.html)

### Code Along

We're going to create a serializer for `Order`.

First, let's checkout a new branch called `json_serializers`.

- Create your controller
  - `rails g controller api/v1/orders index show`
  - Set `index` and `show` methods to render appropriate json

- Create your serializer
  - `rails g serializer order`

- Add a few attributes
  - Some existing fields
    - `id`, `order_number`
  - Some custom fields
    - `num_items`
  - A relationship
    - `items`

Our final product should look something like this:

```ruby
# controllers/api/v1/orders_controller.rb
class Api::V1::OrdersController < ApplicationController
  def index
    render json: Order.all
  end

  def show
    render json: Order.find(params[:id])
  end
end
```

```ruby
# serializers/order_serializer.rb
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_number, :num_items

  has_many :items

  def num_items
    object.items.count
  end
end
```

### Lab

Do what I did to `Order`, but on `Item` now.

- Some existing fields
  - `id`, `name`, `description`
- Some custom fields
  - `num_orders`
- A relationship
  - `orders`

## Using jbuilder to build JSON views

[jbuilder docs][jbuilder_readme]

[jbuilder_readme]: https://github.com/rails/jbuilder/blob/master/README.md

### Intro

- Built in to Rails 4+
- Uses Rails views
- What does DSL mean?

### Code Along

Let's use Jbuilder to create JSON views for `Order`.

First, add and commit your serializers work and

- Create your controller
  - `rails g controller api/v1/orders index show`

- Add views
  - (/views/api/v1/orders)

- Add attributes
  - Some existing fields
    - `id`, `order_number`
  - Some custom fields
    - `num_items`
  - A relationship
    - `items`

Our final product should look something like this:

```ruby
# controllers/api/v1/orders_controller.rb
class Api::V1::OrdersController < ApplicationController
  def index
    render json: Order.all
  end

  def show
    render json: Order.find(params[:id])
  end
end
```

```ruby
# views/api/v1/orders/index.json.jbuilder
json.(@orders) do |order|
  json.(order, :id, :order_number)
  json.num_items(order.items.count)
end
```

```ruby
# views/api/v1/orders/show.json.jbuilder
json.(@order, :id, :order_number)
json.num_items(@order.items.count)
json.items @order.items do |item|
  json.(item, :id)
end
```

### Lab

Do what I did to `Order`, but on `Item` now.

- Some existing fields
  - `id`, `name`, `description`
- Some custom fields
  - `num_orders`
- A relationship
  - `orders`

<!-- ### Extras -->

<!-- `rails g jbuilder api/v1/items name description orders --model-name=item` -->

<!-- Hypermedia: That `_links` thing in some APIs. How do you do that? -->

## Comparison

- What differentiates Jbuilder from Serializers?
- When would you use one or the other?

## Resources

Here's some branches of Storedom with customized JSON

- Storedom branch for [Serializers](https://github.com/turingschool-examples/storedom/tree/custom_json_serializers)
- Storedom branch for [Jbuilder](https://github.com/turingschool-examples/storedom/tree/custom_json_jbuilder)
