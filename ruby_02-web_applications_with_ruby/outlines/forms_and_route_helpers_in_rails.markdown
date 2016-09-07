---
title: Forms and Route Helpers in Rails
length: 180
tags: forms, routes, helpers, rails
---

## Learning Goals

* construct forms using built-in Rails form helpers
* construct links using built-in Rails helpers
* create user interfaces for CRUD functionality in a Rails app

## Setup

```
$ rails new book_shelf
$ cd book_shelf
$ rails g model Book title:text price:decimal quantity:integer
$ rake db:migrate
```

Let's add a few tools from the console:

```
$ rails c
Book.create(name: "The Lord of the Rings", price: 100.00, quantity: 10)
Book.create(name: "The Catcher and the Rye", price: 15.99, quantity: 10)
Book.create(name: "The Alchemist", price: 20.00, quantity: 10)
Book.create(name: "Charlotte's Web", price: 5.99, quantity: 10)
Book.create(name: "To Kill a Mockingbird", price: 19.99, quantity: 10)
Book.create(name: "One Hundred Years of Solitude", price: 23.99, quantity: 10)
```

## Routes

Add RESTful routes for Books:

```ruby
Rails.application.routes.draw do
  resources :books
end
```

Run `$ rake routes` and look at the output:

```
    Prefix Verb   URI Pattern                    Controller#Action
     books GET    /books(.:format)               books#index
           POST   /books(.:format)               books#create
  new_book GET    /books/new(.:format)           books#new
 edit_book GET    /books/:id/edit(.:format)      books#edit
      book GET    /books/:id(.:format)           books#show
           PATCH  /books/:id(.:format)           books#update
           PUT    /books/:id(.:format)           books#update
           DELETE /books/:id(.:format)           books#destroy
```

Create a controller for Book:

```
$ touch app/controllers/books_controller.rb
```

### Index

Inside of that file:

```ruby
class BooksController < ApplicationController

  def index
    @books = Book.all
  end
end
```

Create a view:

```
$ mkdir app/views/books
$ touch app/views/books/index.html.erb
```

Inside of that file:

```erb
<% @books.each do |book| %>
  <%= book.title %> - <%= book.price %>
<% end %>
```

Start up your server (`rails s`) and navigate to `localhost:3000/books`.

## Route Helpers

We can use the prefixes from our `rake routes` output to generate routes:

```
    Prefix Verb   URI Pattern                    Controller#Action
     books GET    /books(.:format)               books#index
           POST   /books(.:format)               books#create
  new_book GET    /books/new(.:format)           books#new
 edit_book GET    /books/:id/edit(.:format)      books#edit
      book GET    /books/:id(.:format)           books#show
           PATCH  /books/:id(.:format)           books#update
           PUT    /books/:id(.:format)           books#update
           DELETE /books/:id(.:format)           books#destroy
```

If we want to go to `/books`, we can create a link to `books_path`. If we want to go to `/books/new`, we can create a link to `new_book_path`. Notice that we just add on `_path` to the prefix.

Rails also has a link helper that looks like this:

```erb
<%= link_to "Book Index", books_path %>
```

Which will generate the equivalent of:

```erb
<a href="/books">Book Index</a>
```

We can add a link to view individual books with this:

Inside of that file:

```erb
<% @books.each do |tool| %>
  <%= link_to book.title, book_path(book) %>
<% end %>
```

1) What is `book_path(book)`?

### Show

Add a route for show:

```ruby
class BooksController < ApplicationController

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end
end
```

Let's create a view to show the individual book: `$ touch app/views/books/show.html.erb`.

Inside of that file:

```erb
<h1><%= @book.name %> - <%= @book.quantity %></h1>
<h3><%= @book.price %></h3>
```

### New

1) Ok, back to the index (`/books`). How can we create a link to go to a form where we can enter a new book? Let's put that link on our `index.html.erb` page.

This link relies on a new action in our controller, so let's add that:

```ruby
class BooksController < ApplicationController

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end
end
```

Add a `new.html.erb` file in your books views folder.

Inside of that file:

```erb
<%= form_for(@book) do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %>
  <%= f.label :price %>
  <%= f.text_field :price %>
  <%= f.label :quantity %>
  <%= f.text_field :quantity %>
  <%= f.submit %>
<% end %>
```

Let's start up our server and check out this form. If we inspect the elements, where will this form go when we click submit?

### Create

Add a `create` action in the controller:

```ruby
class BooksController < ApplicationController

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to book_path(@book)   # Rails is 'smart' enough to also do => 'redirect_to @book'
    else
      render :new
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :price, :quantity)
  end
end
```

### Edit

Let's go to the show view and add a link to edit. What will this link look like?

Add a route in the controller for edit.

Add a view for edit which contains a `form_for(@book)`. This form looks EXACTLY THE SAME as our `new.html.erb`. What can we do to get rid of duplicated code?

Better question: If we use a partial, how does Rails know which route to use depending on if it's a `new` or an `edit`?

### Update

Add an update method in the controller:

```ruby
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      render :edit
    end
  end
```

### Destroy

Add a link on the book show view to destroy the book:

```erb
<%= link_to "Delete", book_path(@book), method: :delete %>
```

Add a `destroy` action in your controller:

```ruby
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
```
