---
title: Models, Databases, and Relationships

tags: models, databases, relationships, rails, migrations, activerecord
---

# Models, Databases, and Relationships

## Goals

* create a Rails migration that creates a table or modifies a table
* set up relationships in a Rails migration with foreign key fields
* set up relationships between models using ActiveRecord

## Lesson

### Warmup: Migration Review (15 minutes)

* In your own words, what is a migration?
* What are some things that we can do with a migration?
* What is the relationship between a migration, our database, and our schema?
* What does `rake db:rollback` do? When **wouldn't** I want to use it?

### Migrations in Rails

#### Creating a Migration in Rails (15 minutes)

Similar to our Sinatra apps using ActiveRecord, we're able to create a migration in Rails using a generator. Unlike our Sinatra app, if we're careful from the command line we can get all/most of the fields we need pre-populated in our migration. Follow along or watch:

1. `rails new turing_stables -T --database=postgresql --skip-spring --skip-turbolinks`: create a new rails app without minitest, spring, or turbolinks, using a postgres db.
1. Open `database.yml` to see what we have.
1. `rails g migration CreateHorses name`: create a migration to make a `horses` table that has a name column. Double check the migration to make sure it has everything that we want.
1. `rake db:create`
1. `rake db:migrate`: Migrate. Let's take a look at the schema to see that it has what we expect.
1. `rails g migration CreateStables name location`: create a migration to make a `stables` table.
1. `rails c`: Check to see what we have available to us in our console. Why can't we create anything?
1. `touch app/models/horse.rb`
1. `touch app/models/stable.rb`
1. `rails c`: Create a stable. Create a horse. Why don't we have any relationship? (yes, we need a `has_many`/`belongs_to`, but our DB relationship needs to exist first - Try without the migration first to demonstrate)
1. `rails g migration AddStableToHorses stable:references`: in order to add a foreign key that's indexed. Check the migration to see what we have.
1. `rake db:migrate`
1. `rails c`: Try to create a horse using `stable.horses.create(name: "George")`. Why aren't we able to do this? Call `stable.horses` to verify.
1. Edit `stable.rb` to give us the relationship to horses.
1. `rails c`: Now try to create a new horse related to the stable we have. Works? Great. Try to call `stable.horses`. Works? Great. Find the horse. Try to call `horse.stable`. Why doesn't this work?
1. Edit `horse.rb` to give us the relationship to stables.
1. `rails c`: Can we find our stable if we have an instance of horse? Great!

#### Drafting a Schema (15 minutes)

What would happen if we added riders to our application? How would they be related to horses?

With a partner:

* Draw the tables/columns that you would need to add riders and their relationship to horses to our app.
* Draft a schema that shows this relationship.
* Write out the commands that I could use to add these tables/relationships to my DB.

Share.

Resource outlining how to create a migration from the command line [here](http://guides.rubyonrails.org/active_record_migrations.html#creating-a-migration). Be careful, the docs point out that you can create a join table with some special properties using AR shortcuts. Don't do it. Instead, let's create our join table with references. More information on why not to use has_and_belongs_to_many [here](http://blog.flatironschool.com/why-you-dont-need-has-and-belongs-to-many/).

### Etsy

#### Draft Schema for Etsy (15 minutes)

* By yourself, try to draft a schema for Etsy. Be sure to include store, items, and categories.
* Share with a partner.
* Share.

#### Creating a new project (15 minutes)

What arguments do we need to pass `rails new` to create our new Etsy clone? All run it together.

#### Practice (30 minutes)

With a partner, implement the schema that we discussed.

* Create/run the migrations.
* Add the models.
* Add some data so you can see it in the rails console.

#### Share (15 minutes)

### Homework

Then this afternoon/evening complete the [Rails Basics Challenge](https://github.com/turingschool/challenges/blob/master/models_databases_relationships_routes_controllers_oh_my.markdown)
