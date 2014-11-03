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
3. Implement a many-to-many with has_many :through

#### Instructor Solutions Cheatsheet
1. `rails g scaffold photograph url:string photographable:references{polymorphic}`

  Add `has_one :photograph, as: :photographable` to `Item` and `User`

  You should be able to run the following:
  - `Photograph.create(url: url, photographable_id: user.id, photographable_type: user.class.name)`
  - `Photograph.create(url: url, photographable_id: item.id, photographable_type: item.class.name)`
  - `user.photograph.url`, `item.photograph.url`

2. 
