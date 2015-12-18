---
title: Revisiting ActiveRecord Relationships
length: 120
tags: ActiveRecord, relationships, polymorphic
status: draft
---

### Resources
[Keynote Slides](https://www.dropbox.com/sh/5ivjdaqg4lgix6v/AAApF1jJsbXHgXVkwPeTW8uBa/ActiveRecord%20Relationships.key?dl=0)

### Learning Goals
- One to one
- Many to many
- Has many through
- Polymorphic

### Workshop
Use [Storedom](https://github.com/turingschool-examples/storedom)

1. Create a Photo (with just a URL) which can attach to either a user or an item (polymorphic)
2. Implement a one-to-one with a Login class and a Customer class
3. Implement a many-to-many with has_many :through using items and categories

#### Instructor Solutions Cheatsheet

Code [sample branch](https://github.com/turingschool-examples/storedom/tree/revisiting_active_record_relationships_r3). There are three commits associated with this exercise: 4aaae57, 92c9a09, 982528b

1. `rails g scaffold photograph url:string photographable:references{polymorphic}`

  Add `has_one :photograph, as: :photographable` to `Item` and `User`

  You should be able to run the following:
  - `user.create_photograph(url: url)`
  - `item.create_photograph(url: url)`
  - `user.photograph.url`, `item.photograph.url`

2. `rails g scaffold customer name:string` and `rails g scaffold login name:string customer:belongs_to`
  - Add `has_one :login` to `Customer`
  - Should be able to run:
    - `customer = Customer.create(name:"Josh Mejia")`
    - `customer.create_login(name: 'jmejia')`
    - `customer.login.name`
    - `login = Login.last`
    - `login.customer.name`

3. `rails g scaffold category name:string` and `rails g model categorization item_id:integer category_id:integer`
  - Add the following code:
    - `belongs_to :item` and `belongs_to :category` to `Categorization`
    - `has_many :categorizations` and `has_many :categories, :through => :categorizations` to `Item`
    - `has_many :categorizations` and `has_many :items, :through => :categorizations` to `Category`
  
  - You should be able to run:
    - `category = Category.create(name: 'Food')`
    - `item = Item.last`
    - `item.categories << category`
    - `category_2 = Category.create(name: 'clothing')`
    - `category_2.items << item`
  

    
