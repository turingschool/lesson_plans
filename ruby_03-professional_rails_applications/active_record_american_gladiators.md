### Structure

* Code Challenges (90 minutes)
* Solutions (30 minutes)

### Instructions

Requires Ruby 2.3 and Rails 4


Fork and clone: https://github.com/turingschool-examples/storedom

```bash
$ cd storedom
$ git checkout active_record_american_gladiator
$ bundle && bundle update && rake db:{drop,create,migrate,seed}
```

Run your tests using the `rspec` command. You should see one failing test with the remainder skipped. You will only need to edit code in this spec file: `./spec/active_record_american_gladiator_spec.rb`. Do not change code in the models to get the tests to pass.

Update _only_ the code between the `#Changeable Start` and `#Changeable End` tags. Leave the rest of the code the same.

#### Failing Tests

For the tests that are failing, get them to pass.

#### Passing Tests

For the tests that are passing, you need to refactor them to using more efficient ActiveRecord techniques.

Some of the challenges are quite... uhh... challenging. There are links to resources that are commented out to help find solutions.

It's highly recommended that you become familiar with the [ActiveRecord Querying page](http://guides.rubyonrails.org/active_record_querying.html) on the Rails Guides, particularly for upcoming projects.

### Hints

Solutions use the following techniques:

* `.unscoped`
* `.joins`
* `.includes`
* Queries using conditionals across multiple tables
* Queries using `.select`
  * Show that when you use `AS` you have access to that as a method on the object. eg `Item.select("items.*, count(order_items.item_id) AS items_count").joins(:order_items).group("items.id").map(&:items_count)` would return an array of `items_count` for each item. See the Atlasphere example.
* Finding solutions to problems not covered in documentation
  * Build your queries slowly, adding pieces one at a time.
  * Read the ActiveRecord Querying page on the Rails Guides to learn the language to use in your Google searches.
  * Break down the problem for Atlasphere:
    * Most popular items are the items that appear most frequently on orders. In SQL terms this is the `COUNT` and in ActiveRecord `count`.
    * We need to keep a running tally for each item. In SQL we can use `GROUP BY` and in ActiveRecord `group`.
    * We know we keep track of ordered items in the `order_items` table.
    * In English, we want to `Order items by the number of times an item appears in the order_items table using ActiveRecord.`. This is too specific for a Google search.
    * Let's make it Google-able. We can substitute `number of times` with `count` since that's an ActiveRecord term. And let's remove the specific nouns from our sentence and use broader terms that describe our relationships. `Order by count on association rails` should yield promising results.

### Resources

* [Possible Solutions](https://gist.github.com/jmejia/1a07f1300d7a1d13f97d)
