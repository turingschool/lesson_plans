---
title: Revisiting Authorization Strategies
length: 90
tags: rails, authorization, authentication
status: draft
---

**Current Status**: Draft (Work in Progress)

## Learning Goals

* Students will implement user-level authorization
* Students will be able to explain the advantages of user-based authorization over role-based authorization
* Students will implement basic authentication with Devise

## Structure

* 5 - Warmup
* 5 - CanCan and the Challenges of Multi-Tenancy
* 5 - Strategy One: Defining Abilities with Blocks
* 5 - Strategy Two: Hash of Conditions
* 5 - Stacking Permissions
* 5 - Break
* 10 - Authorization scopes and `accessible_by`
* 45 - Pair Practice
* 5 - Wrap Up

## Warm-Up

In a gist or your notebook or the text editor of your choice:

Role-based authorization worked in Dinner Dash, where you were hosting the menu and items from just one restaurant.

But what if you were more like GrubHub and hosted multiple restaurants? How would you prevent the admin of one restaurant from editing the content of another restaurant?

## Full-Group Lecture

### Introduction

Brief review of role-based authentication and CanCan.

```rb
class Ability  
  include CanCan::Ability  

  def initialize(user)  
    if user.role? :admin  
      can :manage, :all  
    else  
      can :read, :all  
    end  
  end  
end
```

Just because you are an admin for one restaurant, it doesn't mean you should be an admin for *all* restaurants and be able to adjust your competitor's menu items and prices.

### Setting Up User-Based Authorization

So, how can we limit which actions the user can engage to just those that they own?

```rb
# Update this to reflect whatever my example is
class Ability  
  include CanCan::Ability  

  def initialize(user)  
    user ||= User.new  

    can :update, Item do |item|  
      item.try(:user) == item
    end
  end  
end
```

There are two problems with this:

1. It's ugly and verbose.
2. The block is **only** evaluated when an actual instance object is present. It is not evaluated when checking permissions on the class (such as in the index action). This means any conditions which are not dependent on the object attributes should be moved outside of the block.

### Using a Hash of Conditions

Okay, but this a little verbose. To make this a little easier on the eyes, we can use a _hash of conditions_.

```rb
# Update this to reflect whatever my example is
# In Ability
can :read, Item, :active => true, :user_id => user.id
```

### Stacking Authorizations

It is important to only use database columns for these conditions so it can be used for Fetching Records.

If we need to get more granular, we can stack authorizations.

```rb
can :read, Item, active: true
can :read, Item, user_id: user.id
```

It is possible to define multiple abilities for the same resource. Here the user will be able to read projects which are released _OR_ available for preview.

The cannot method takes the same arguments as can and defines which actions the user is unable to perform. This is normally done after a more generic can call.

```rb
can :manage, Item, organization_id: user.organization.id
cannot :destroy, Item, owner_id: user.id
```

We can weave these together to create some find-grained control over what a user can and cannot do.

```rb
# In Ability
can :manage, User, manager_id: user.id
cannot :manage, User, self_managed: true
can :manage, User, id: user.id
```

In this example, the user could manage himself. For others he could not manage self_managed users, otherwise he could manage his employees.

### Fetching Records Based on Authorization

```rb
# current_ability is a method made available by CanCan to your controllers extending ActionController::Base
@items = Item.accessible_by(current_ability)
```

By default, this will scope your query to bring back only the resources that the current user can :read.

If we want to get more specific, we can pass a second argument for the ability we'd like to use.

```rb
@items = Item.accessible_by(current_ability, :update)
```

Remember that block syntax we looked at before? Well, that's cool as long as you're working with Ruby objects. To fetch records from the database, you'll need to supply an SQL string.

```rb
can :update, Item, ["release_date <= ?", Time.now] do |item|
  item.release_date <= Time.now
end
```

You can use scopes too, which is pretty awesome.

```rb
can :read, Item, Item.released do |item|
  item.release_date <= Time.now
end
```

## Pair Practice

<!-- Fill me out -->
