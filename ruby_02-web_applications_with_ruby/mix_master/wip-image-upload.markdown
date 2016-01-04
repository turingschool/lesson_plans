# Mix Master Part 7: Image Upload with Paperclip

```
$ git checkout -b 7_image-upload
```

Apps will evolve over time, and you may reach a point where you need to go back and modify a spec to reflect this new functionality. Here's our situation: we want users to be able to upload a photo instead of pasting in a URL to an image for the artist. This is what our spec looks like right now. Put a skip on the sad path case (not shown below) since we have a controller test covering that for right now. 

```ruby
require 'rails_helper'

RSpec.feature "User submits a new artist" do
  scenario "they see the page for the individual artist" do
    artist_name       = "Bob Marley"
    artist_image_path = "http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg"

    visit artists_path
    click_on "New artist"
    fill_in "artist_name", with: artist_name
    fill_in "artist_image_path", with: artist_image_path
    click_on "Create Artist"

    expect(page).to have_content artist_name
    expect(page).to have_css("img[src=\"#{artist_image_path}\"]")
  end
end
```

To test image uploading, we'll ned to change a few lines:

```ruby
require 'rails_helper'

RSpec.feature "User submits a new artist" do
  scenario "they see the page for the individual artist" do
    artist_name        = "Bob Marley"
    fixture_image_path = Rails.root.join('spec', 'support', 'bob_marley.jpg')

    visit artists_path
    click_on "New artist"
    fill_in "artist_name", with: artist_name
    attach_file 'Image', fixture_image_path
    click_on "Create Artist"

    expect(page).to have_content artist_name
    expect(page).to have_css("img[src=\"#{bob_marley.jpg}\"]")
  end
end
```

The line `attach file 'Image', fixture_image_path` is Capybara's way of mimicking a user uploading a file. Run the spec:

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: attach_file 'Image', fixture_image_path
     
     Capybara::FileNotFound:
       cannot attach file, /Users/rwarbelow/Desktop/Coding/Turing/1510/mix_master/spec/support/bob_marley.jpg does not exist
```

Notice that it's telling us that `mix_master/spec/support/bob_marley.jpg does not exist`. We need a file in order to test this out. Go ahead and add a image file with the name `bob_marley.jpg` to your `spec/support` folder. 

Now that we have that file, run the spec again:

```
Failures:

  1) User submits a new artist they see the page for the individual artist
     Failure/Error: attach_file 'Image', fixture_image_path
     
     Capybara::ElementNotFound:
       Unable to find file field "Image"
     # /usr/local/rvm/gems/ruby-2.2.2/gems/capybara-2.5.0/lib/capybara/node/finders.rb:43:in `block in find'
```

Hmm. If we look at our form, we'll see this:

```erb
<%= form_for(@artist) do |f| %>
  <%= render partial: "shared/errors", locals: { target: @artist } %>

  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :image_path %>
  <%= f.text_field :image_path %>

  <%= f.submit %>
<% end %>
```

And our schema looks like this:

```ruby
  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.string   "image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
```

So, right now we're allowing for an `image_path`. Of course we don't have a field for Photo. Let's try changing the form and see what happens:

```erb
<%= form_for(@artist) do |f| %>
  <%= render partial: "shared/errors", locals: { target: @artist } %>

  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :image %>
  <%= f.file_field :image %>

  <%= f.submit %>
<% end %>
```