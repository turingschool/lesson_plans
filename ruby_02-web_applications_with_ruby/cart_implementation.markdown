---
title: Cart Implementation
length: 120
tags: cart, order
---

# Lesson plan in progress...

### Implementation Notes

```erb
<div class="row">
  <% @pokemons.each do |pokemon| %>
    <div class="col-md-3 text-center pokemon-container">
      <%= image_tag(pokemon.image_url, class: "pokemon-image") %>
      <h3><%= pokemon.name %></h3>
      <%= button_to "Capture", captures_path(pokemon_id: pokemon.id) %>
    </div>
  <% end %>
</div>
```

```ruby 
resources :captures, only: [:create]
```

```
$ touch app/controllers/captures_controller.rb
```

```ruby
class CapturesController < ApplicationController
  def create
    redirect_to root_path
  end
end
```

```ruby
class CapturesController < ApplicationController
  def create
    backpack = session[:backpack] || {}
    backpack[params[:pokemon_id]] ||= 1
    backpack[params[:pokemon_id]] += 1
    session[:backpack] = backpack
    redirect_to root_path
  end
end
```

```erb
  <%= session[:backpack] %>
```

```ruby
class CapturesController < ApplicationController
  def create
    pokemon = Pokemon.find(params[:pokemon_id])
    @backpack.add_pokemon(pokemon)
    session[:backpack] = @backpack.contents
    redirect_to root_path
  end
end
```

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_backpack

  def load_backpack
    @backpack = Backpack.new(session[:backpack])
  end
end
```

```ruby
class CapturesController < ApplicationController
  def create
    pokemon = Pokemon.find(params[:pokemon_id])
    @backpack.add_pokemon(pokemon)
    session[:backpack] = @backpack.contents
    flash[:notice] = "You have #{pluralize(@backpack.count_of(pokemon), pokemon.name)} in your backpack."
    redirect_to root_path
  end
end
```

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ActionView::Helpers::TextHelper

  before_action :load_backpack

  def load_backpack
    @backpack = Backpack.new(session[:backpack])
  end
end
```

```ruby
class Backpack
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new
  end

  def add_pokemon(pokemon)
    contents[pokemon.id.to_s] ||= 0
    contents[pokemon.id.to_s] += 1
  end

  def count_of(pokemon)
    contents[pokemon.id.to_s]
  end

  def count_total
    contents.values.sum
  end
end
```

```erb
  Backpack: <%= @backpack.count_total %>

  <% flash.each do |name, msg| %>
    <%= content_tag :div, msg, :id => "flash_#{name}" %>
  <% end %>
```