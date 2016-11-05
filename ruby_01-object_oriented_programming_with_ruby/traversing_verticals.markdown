---
title: Traversing Two Verticals
length: 90
tags: ruby, black-thursday, verticals, self
---


## Traversing Two Verticals

### The Law of Demeter

There's a movie quote:

_Keep your friends close and your enemies closer._

The Law of Demeter is kind of like, _Keep your friends close, but your friends
friends? Screw them._

I know, that was a stretch.

The Law of Demeter essentially states that an object should know about its
adjacent objects but not about the objects that are adjacent to the objects
that are adjacent to it.

So let's diagram out what our Black Thursday should look like. We're going to
take your project but simplify it so that you're only going to be working with
two kinds of objects, merchants and items.

So we have a Sales Engine Class, and it has an Item Repository and a Merchant
Repository, and each Repository then has its own collection of objects.

In this kind of structure, we can envision that when we instantiate a Sales
Engine, it then instantiates the repositories, and then the repositories
create all of the individual objects as needed. We aren't going to talk about
just how that happens, for the purposes of this lesson, let us just assume
that it does happen, and when the dust settles, everything is in place.

So now, one of the basic relationships that we are going to follow is that of
a merchant and its items. A merchant should know what items belong to it,
and an item should be able to find out who its merchant is. That is, the
former should have an array of its item objects, and the latter should be able
to access the object of its merchant.

The important question is, how do we do this? What should each object know
about every single other object?


### Developer, Know Thy _Self_

So how do we get it so that every object we work with knows about the
appropriate objects?

Maybe we could instantiate a new merchant object for each item?

Maybe we could do the same and create an array of item objects for each
merchant?

What happens if we need to change some data after the fact? Do we not have
duplicate items?

We need to structure our code in a way that we can talk across our structures
but we don't want to talk horizontally - when we do that, we start creating a
mesh-like structure.

If we start making things into a mesh, what do you think happens if we ever
have to change our code? Where do we need to make changes if we ever have to
change how a repository works? We'd then have to change code in every single
place that references that repository. Not a big deal if all we have is a
merchant repository and an item repository, right?

But that's not what we are doing here.

We're going to have in the final code, a transaction repository, an invoice
repository, ad nauseum.

So we have to write code that's a little more resilient.

The large idea here is that we have to go up and down the branches of this
tree, as opposed to crossing horizontally.

When we do this, we just need to make sure that individual links list. This makes
our code much more resilient and reusable.



### So how do we test this?

We use Mocks.


```ruby
  def test_invoices_calls_parent
    parent = Minitest::Mock.new
    customer = Customer.new(data, parent)
    parent.expect(:find_invoices, nil, [1])
    customer.invoices
    parent.verify
  end
```

