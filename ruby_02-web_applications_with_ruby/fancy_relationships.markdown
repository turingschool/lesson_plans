# Fancy Relationships

We've talked at length about 1-to-1, 1-to-many, and many-to-many relationships.

Good news: those are the only kinds of relationships we can implement at the
database level.

Bad news: we can use them in unusual ways to do some *fancy* things.

## Learning Goals

* Understand the concept of a self-referential relationship
* Be able to implement a self-referential relationship
* Know how to read the ActiveRecord relationship API
* Understand the concept of a polymorphic relationship
* Be able to implement a polymorphic relationship

## Self-Referential Relationship

The idea of a self-referential relationship is relatively simple: an instance
relates to another instance of the same type.

One of the canonical examples is an employee/manager relationship:

* You'd start with an `Employee` model and `employees` table
* Each row of that table represents one employee
* Each employee at the company has a manger
* Each row of the table has a `manager_id`
* That `manager_id` points to the `id` of another row in the table

Ya follow? Every employee has a manager and every manager is an employee. So
you can build out the whole org chart in just one table.

### Documentation

We need to figure out just how to put this into practice. If you said that an
employee `belongs_to :manager` then later try `some_employee.manager`, AR is going
to look for a manager in the `managers` table. But you need it to look in the `employees` table!

Not all answers are on StackOverflow. And where do those randos get their information
from? The docs!

* Google for `activerecord relationships api`
* Click the first link which will take you to `ActiveRecord::Associations::ClassMethods` API
* Scroll past the pages and pages of explanation to find the documentation for the `belongs_to` method
* Skim/read through until you get to the `Options` heading
* Read through the various options to figure out what would be useful here
* Check out the examples in the yellow box
* Sketch in a plain text file (you don't need an app) what your `Employee` model
with relationships would look like
* Compare with a neighbor

Extensions / Thinking Deeper:

* How would you know if the employee is the CEO?
* For a given employee, how could you find their manager's manager?
* What would happen if employees are broken into departments, how might your approach and schema change?

### Challenge

Build a new Rails application that's capable of organizing a binary tree using
self-referential relationships. Make it work like this:

```ruby
> root = Node.create(:value => 10)
> root.left
=> nil
> root.insert(5)
> root.left
=> <Node value: 5>
> root.insert(2)
> root.left
=> <Node value: 5>
> root.left.left
=> <Node value: 2>
> root.insert(6)
> root.left.right
=> <Node value: 6>
> root.count
=> 4
> root.max
=> <Node value: 10>
> root.min
=> <Node value: 2>
```

You'll use some TDD to get this figured out, right?

#### Extension

Can you display the data of a tree in a reasonable/readable way in HTML? Your best
bet is probably hacking around with some tables and manipulating colspans. If you
can get just like 5 levels of the tree displaying well that's a pretty good victory.

If you're really nuts, figure out how to delete a node that has no child nodes.
Then figure out how to delete a node that's in the middle of the tree.

## Polymorphic Relationships

That was fun, eh? Let's look at a second type of relationship problem:

* Your app allows users to post articles (tracked in the `articles` table)
* Your app allows users to post photos (tracked in the `photos` table)
* You want their friends to be able to post comments on articles and photos

What's so tricky?

* Comments will get stored in a `comments` table
* To associate with an article, the comment would `belongs_to` an article
* For that `belongs_to` it would have a foreign key `article_id`
* To associate with a photo, the comment would `belongs_to` a photo
* For that `belongs_to` it would have a foreign key `photo_id`

But that doesn't quite make sense. A single comment can't be attached to both a
photo and an article. What about when we allow them to post videos? Add a `video_id`
column?

In this situation you'd want to use a polymorphic relationship. There are a ton
of blog posts and videos to teach you about polymorphic relationships -- so let's
take advantage of some of them:

* Start with the Rails Guide: http://guides.rubyonrails.org/association_basics.html#polymorphic-associations
* Watch this old video on RailsCasts (RIP): http://railscasts.com/episodes/154-polymorphic-association
* Check out this newer article that says the same things: http://karimbutt.github.io/blog/2015/01/03/step-by-step-guide-to-polymorphic-associations-in-rails/

### Challenge

We don't need a complicated app to exercise this functionality. Let's roll with
the comment example to make this work:

```ruby
> art = Article.new(:title => "First Article")
> art.comments
=> []
> comment = art.comments.create(:body => "I love this!")
> comment.article.title
=> "First Article"
> photo = Photo.new(:title => "Beautiful photo")
> photo.comments
=> []
> comment2 = photo.comments.create(:body => "Serious FOMO")
> comment2.photo.title
=> "Beautiful title"
> comment.photo
=> ((something bad because it does not relate to a photo))
> comment2.photo
=> ((something bad because it does not relate to a article))
```
