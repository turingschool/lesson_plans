---
title: ActiveRecord Callbacks and Transactions
length: 120
tags: ruby, rails, activerecord, models
---

## Learning Goals

* Understand the callbacks that ActiveRecord makes available to trigger an action at various points in an object's lifecycle
* Understand some of the basic principles of when to use callbacks and when not to use callbacks in your code
* Understand how ActiveRecord transactions work and when to use them

## Structure

* 10 - Warm Up and Discussion
* 15 - Full Group Instruction: Callbacks
* 5 - Break
* 15 - Full Group Instruction: Callbacks (Continued)
* 10 - Full Group Instruction: Transactions
* 5 - Break
* 50 - Pair Practice
* 10 - Wrap Up

## Warm Up

Start a gist (or you can use your notebook) and answer the following question:

* What are some strategies you've used in the past to normalize data your receive from users?
* What are some difficulties you've had with these strategies?
* Have you used callbacks before? If so, what were your experiences?

## Lecture: Callbacks

Callbacks are helper methods that get called at certain points in the life-cycle of your ActiveRecord object.

```rb
before_destroy { self.update_attribute(:deleted_at, Time.now); false }
```

Callbacks can take one of three forms.

* Method references using a symbol
* Callback objects using a block
* Inline methods using a proc

If you're not using a block syntax for defining a callback, then the access level for a callback should alway be *protected* or *private*.

If a callback returns `false` (actual `false`, not falsey), execution is halted. No further callbacks will be executed. `.save` will return false and `.save!` will raise an exception.

Ruby's implicit returning can potentially bite you here. If your objects aren't saving (in this example) for some reason. Make sure that you're not accidentally returning `false`.

### Advantages of Callbacks

* Everything is in one place, which helps readability

### Disadvantages of Callbacks

* Everything is in one place, which is a code smell that you may be violating the Single Responsibility Principle
* Excessive use of callbacks could make for some heavy classes

### Available Callbacks

#### Save (`:create` and `:update`) callbacks

* `before_validation`
* `after_validation`
* `before_save`
* `around_save`
* `before_create` (for new records) and `before_update` (for existing records)
* `around_create` (for new records) and `around_update` (for existing records)
* `after_create` (for new records) and `after_update` (for existing records)
* `after_save`

Getting specific with `:on`:

```rb
before_validation :some_callback, on: :create
after_save :some_callback, on: :update
```

### Destroy Callbacks

* `before_destroy`
* `around_destroy` executes a `DELETE` database statement on `yield`
* `after_destroy` is called after record has been removed (read-only)

## When to Use Callbacks

Short answer: _Sparingly_

**The Golden Rule of Callbacks**: You should only use a callback when it deals with the model instance you're currently working with.

Your callbacks should not have additional responsibilities like saving files, sending emails, etc.

#### Example: Normalizing Data

You can use callback to clean-up attribute formatting:

```rb
class PhoneNumber < ActiveRecord::Base
  before_validation on: :create do
    self.number = number.gsub(/[^0-9]/, "")
  end
end
```

_Scrabble-Web_ had a good example of when to use this: downcasing a word as it came into the model and before it was saved to the database.

You can also call callbacks conditionally:

```rb
class Order < ActiveRecord::Base
  before_save :normalize_card_number, :if => :paid_with_card?
end
```

#### Example: Creating Special Tokens

You can use callbacks to generate special tokens like invite codes:

```rb
class User
  before_create :create_invite_code, on: :create

  private

  def create_invite_code
    invite_code = SecureRandom.base64
  end
end
```

It's important to keep SRP in mind when using callbacks. ActiveRecord callbacks shouldn't give your models un-modelly responsibilities.

#### Example: Paranoia

What if we never *really* wanted to delete a record, but just want to mark it as deleted?

```rb
class FacebookAccount < ActiveRecord::Base
  before_destroy do
    self.update_attribute(:deleted_at, Time.current)
    false
  end
end
```

You can circumvent this with `delete_all`, which skips the whole "talking to the model" bit and goes directly to wiping it out of the database.

You can also create scopes to then return only the active or only the "deleted" records from the database.

#### Example: Cleaning Up

Stretching a bit—and really poking at the bounds of breaking SRP—you can use callbacks to clean-up after your model after they leave this Earth.

```rb
def destroy_attached_files
  Paperclip.log("Deleting attachments.")
  each_attachment do |name, attachment|
    attachment.send(:flush_deletes)
  end
end
```

### The tl;dr on Callbacks

* Limit your use of ActiveRecord callbacks to commands that operate on the object itself.
* Avoid unexpected side effects in your callbacks.
* Consider the context of the command to determine whether to use a controller action or another Ruby object.

## Lecture: Transactions

Reference: [Jumpstart Lab Tutorial on Transactions](http://tutorials.jumpstartlab.com/topics/models/transactions.html)

Transactions are protective blocks where SQL statements are only permanent if they can all succeed as one atomic action.

```rb
ActiveRecord::Base.transaction do
  david.withdrawal(100)
  mary.deposit(100)
end
```

You can call `#transaction` or `ActiveRecord::Base` or any ActiveRecord Model (e.g. `Account`).

### Transaction Callbacks

There are two types of callbacks associated with committing and rolling back transactions: after_commit and after_rollback.

* `after_commit` callbacks are called on every record saved or destroyed within a transaction immediately after the transaction is committed.
* `after_rollback` callbacks are called on every record saved or destroyed within a transaction immediately after the transaction or save point is rolled back.

If either of those fail, then neither will happen.

## Pair Practice

Work through the steps below with your pair.

1. Create a repository and submit a pull request on [Today](https://github.com/turingschool/today) with a link to your fresh new repository.
1. Argue briefly about which testing framework and templating language to us.
1. Start a new Rails project with your preferred testing framework (e.g. Rspec or Minitest) and templating language (e.g. ERB or HAML).
1. Create an account model. This model should have an account holder's name, an account number, a routing number, and starting balanace of $1000.
1. Create a callback on the account model that removes all spaces and dashes from the routing number before validations.
  * Validations should probably make sure the routing number consists only of digits.
  * Write a test first to make sure this actually works.
1. Create a callback on the account model that removes all spaces and dashes from the account number before validations. Same rules as before.
1. Because we're emulating a bank, we're probably going to have to interact with some kind of legacy FORTRAN or COBOL system that demands that account holder's names be all uppercase. Let's set up a callback that upcases the name before saving it to the database.
1. Set up a transaction to move money from one account to another.
  * The transaction should not go through unless both accounts exist.
  * The transaction also shouldn't go through if it would overdraw the account we're transferring from.
  * Write a test to make sure you're not crazy.
1. Add a `deleted_at` column to your account model. This column should default to `nil`.
1. Implement a `before_destroy` callback that sets `deleted_at` to `Time.now`. (Make sure you return `false` so that you don't actually delete the account.)
1. Update your transaction to make sure you cannot transfer funds to or from a "deleted" account.

### Extensions

* Create a controller and view for a web interface to transfer funds between two accounts.
  * Two account numbers and the amount to transfer should be fine. Our legacy FORTRAN mainframe will take care of the rest.
  * You can use a drop-down menu of all of the existing accounts or just a text input if you're feeling fancy.
* Create a scope that returns all of the active accounts and a scope that returns all of the closed accounts.
* Create a model for tracking transfers. It should have columns for the accounts transferred from and to as well as the amount.
  * Add it to the transaction. This model should not be created/save to the database unless the transaction was successful.
  * Set up the relationships:
    * Accounts should have many transactions.
    * Each transaction to belong to the two accounts involved.
    * Accounts should be able related to all of the other accounts they've done business with using a `:has_many` … `:through`

## Wrap-Up

Take a look at one other group's code. Did they take a different approach than you? If so, what do you like and/or dislike about their approach? If not, why do you think you both chose the same strategy?
