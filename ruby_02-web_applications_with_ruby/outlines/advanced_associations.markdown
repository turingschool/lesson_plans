## Advanced Associations

### Warm Up
We've already seen one-to-many, one-to-one, and many-to-many relationships. Create a real world example of each of these (with the database schema and all!).

### Overview
* Using associations (creating new objects)
* Complex associations
* Self referential relationships
* Polymorphic associations
* Work Time!

### Using Associations

Let's say we have the following in our `db/schema.rb`:

```
  create_table "jockeys", force: :cascade do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "age"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end
  
  create_table "jockey_horses", force: :cascade do |t|
    t.integer  "jockey_id"
    t.integer  "horse_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "horses", force: :cascade do |t|
    t.string   "name"
    t.string   "breed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

```

We have a many-to-many relationship between a `Jockey` and a `Horse`. What associations do we need if we want to easily relate a jockey and a horse? Take a second and think about it.

```
class Jockey < ActiveRecord::Base
	has_many :jockey_horses
	has_many :horses, through: :jockey_horses
end

class JockeyHorse < ActiveRecord::Base
	belongs_to :horse
	belongs_to :jockey
end

class Horse < ActiveRecord::Base
	has_many :jockey_horses
	has_many :jockeys, through: :jockey_horses
end
```
How do we test if this is working correctly? I suggest hopping in the Rails console and try to create related objects.

First, let's create a jockey, and see if we can call our association methods on our jockey object. Remember, every association you write is another method you have access to - and you should use the method!! Or else what's the point of going through the trouble to create these associations?

```
jockey = Jockey.create(name: "Penelope", number: 11, age: 24)
jockey.jockey_horses
jockey.horses
```

We can do the same for the other two objects we have (Horse and JockeyHorse). This is just testing to see if we have any broken code - we are not testing that we've related our objects correctly yet. In order to do this, let's create a new `Horse` using the association method our associations have given us.

```
jockey = Jockey.first
jockey.horses.create(name: "Pablo", breen: "Pony")
```
If you read the SQL output of this statement, we'll see that it creates a new `Hores` object, saves it in our database, and automatically sets this horse's `jockey_id` to the jockey's `id` that we've chained this method onto. Now, if we run `jockey.horses`, we should see our horse named "Pablo".

This is exactly what you should be doing within your applications to make use of your associations!

### Complex Associations

ActiveRecord makes two assumptions when you write an association. If one of it's assumptions are false, your association will NOT work.

#### Has Many
Let's say you write `has_many :songs` in an `Artist` class, ActiveRecord is going to expect two things - one is regarding a class name and the other is regarding what the foreign key is called within the related table. With a `has_many` association, ActiveRecord looks for a class called the same name (singular though). If we have:

```
class Artist < ActiveRecord::Base
	has_many :songs
end
```

ActiveRecord needs a `Song` class to exist. It also needs for `artist_id` to be present in the `songs` table (this assumption comes from the name of the class we've defined this association within - in this case `Artist`). If either of these assumptions are not true, we will need to give this association some optional flags. 

Let's pretend we have `author_id` in the `songs` table instead of `artist_id`, we'll need to tell ActiveRecord to look for a different foreign key like so:

```
class Artist < ActiveRecord::Base
	has_many :songs, foreign_key: :author_id
end
```

If we don't have a `Song` class and we have a `Record` class instead, we'll have to tell ActiveRecord to look for this class instead by adding the following:

```
class Artist < ActiveRecord::Base
	has_many :songs, foreign_key: :author_id, class_name: "Record"
end
```

Now, ActiveRecord will be able to find the correct related data when you as a specific artist for it's songs. 

#### Belongs To
Let's say you write `belongs_to :artist` in a `Song` class, ActiveRecord is going to expect two things once again - one is regarding a class name and the other is regarding what the foreign key is called within the table we've defined the `belongs_to` relationship within. Similarly to the `has_many` association, with a `belongs_to` association ActiveRecord looks for a class called the same name. So, if we have:

```
class Song < ActiveRecord::Base
	belongs_to :artist
end
```

ActiveRecord needs an `Artist` class to exist. If we don't have this class defined, let's say we've called it `User` - we'd need to tell ActiveRecord to look for the `User` class when querying instead. 

```
class Song < ActiveRecord::Base
	belongs_to :artist, class_name: "User"
end

```

ActiveRecord also needs `artist_id` to exist within the `songs` table - unless we've specified a different class name, then it will look in that corresponding table. In this specific case, it will look for `artist_id` within the `users` table since we've specified `class_name: "User"`. If we don't have `artist_id` and instead called it `record_id`, we would need to specify what foreign key to look for like so:

```
class Song < ActiveRecord::Base
	belongs_to :artist, class_name: "User", foreign_key: :record_id
end

```

ActiveRecord always makes two assumptions. Sometimes the fields in your database may not be the most easy to read or may not be the most representative of our data. We may have been handed down a database from years and years ago and not be able to change it. We want our associations to be easy to read and follow - so sometimes, we'll need to use `class_name` and `foreign_key` as optional flags. 

A good example might be with a `User` and `Article`. If a user writes an article, we may want to ask an article who it's author is rather than who it's user is. `article.author` is much more readable than `article.user`. 

### Example of Complex Associations
- Teams, Leagues, Users

### Self Referential Relationships
The idea of a self-referential relationship is relatively simple: an instance relates to another instance of the same type.

One very popular example of when this might be used is if you have an application with employees and managers. All managers are also employees and all employees have one manager. 

```
  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.integer  "manager_id"
    t.integer  "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

```

If we have this `employees` table and we want to create associations to both find all of specific `Employee`'s managed employees as well as their manager, we can write the following associations.

```
class Employee < ActiveRecord::Base
  belongs_to :manager, class_name: "Employee"
  has_many :managed_employees, class_name: "Employee", foreign_key: :manager_id
end
```

### Polymorphic Associations
Polymorphic associations are AWESOME. With polymorphic associations, a model can belong to more than one other model, on a single association. Read through the [documentation](http://guides.rubyonrails.org/association_basics.html#polymorphic-associations) before we dive into an example. 

Example: Users, Photos, Articles, Comments

Extra Resources:
* Start with the Rails Guide: http://guides.rubyonrails.org/association_basics.html#polymorphic-associations
* Watch this old video on RailsCasts (RIP): http://railscasts.com/episodes/154-polymorphic-association
* Check out this newer article that says the same things: http://karimbutt.github.io/blog/2015/01/03/step-by-step-guide-to-polymorphic-associations-in-rails/

### Self Joins

```
  create_table "friendships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "user_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
```

If we want to be able to call something like the following:
```
penelope = User.find_by(name: "Penelope")
penelope.followers
penelope.followings
```

We'll need the following associations on our `User` and `Friendship` models.

```
class User < ActiveRecord::Base
  has_many :follower_friendships, class_name: "Friendship", foreign_key: :followee_id
  has_many :followers, through: :follower_friendships

  has_many :following_friendships, class_name: "Friendship", foreign_key: :follower_id
  has_many :followings, through: :following_friendships
end

class Friendship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"
end
```

### Putting it all Together
Work through the [advanced association challenge](https://github.com/case-eee/advanced-association-challenge)
