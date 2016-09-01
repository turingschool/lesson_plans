# Mix Master Part 6: Testing Your Controllers

Earlier, we wrote a few feature tests for "sad paths"; specifically if a song was missing a title, or an artist was missing a name, etc. When you start building large projects, you'll find that having feature tests to cover failure paths tends slow down your test suite since those tests use a headless browser to mimick user interaction.

A controller test should check for things such as:

* status (success, failure, redirect)
* instance variable assignment
* content of a flash message
* redirection to correct path
* rendering of correct template

Check out the Rails Docs for [Controller Testing](http://guides.rubyonrails.org/testing.html#functional-tests-for-your-controllers) (keep in mind these use MiniTest in the examples) or the RSpec [Controller Specs](https://www.relishapp.com/rspec/rspec-rails/docs/controller-specs) documentation.

Keep in mind: controllers (and their tests) should be relatively straightforward. Most of your logic (if you have logic) should live in models and be tested using model specs.

Let's write a few controller tests. We'll start with a simple controller test for the `index` action of the `ArtistsController`.

```
$ git checkout -b 6_controller-tests
```

For this test, we'll need at least one artist in the database in order to check that the instance variable contains an array of all saved artists:

```
$ mkdir spec/controllers
$ touch spec/controllers/artists_controller_spec.rb
```

Then inside that file:

```ruby
require 'rails_helper'

RSpec.describe ArtistsController, type: :controller do
  describe "GET #index" do
    it "assigns all artists as @artists and renders the index template" do
      artist = create(:artist)

      get(:index)

      expect(assigns(:artists)).to eq([artist])
      expect(response).to render_template("index")
    end
  end
end
```

Conventionally, the string for the describe is the HTTP method and the controller action name (ie `GET #index`).

In this spec above, we create the artist, then use the built-in `get` method which accepts a symbol of the controller action (`:index` in this case), then check to make sure that the instance variable `@artists` equals `[artist]` (an array of the one artist we have in the database). `assigns(:artists)` is the syntax used in a controller test in order to access an instance variable that is created in the controller action. Then we check to make sure that the index template was rendered.

Since this spec looks for functionality that we've previously implemented, this test should automatically pass.

Let's add a few more:

```ruby
require 'rails_helper'

RSpec.describe ArtistsController, type: :controller do
  describe "GET #index" do
    it "assigns all artists as @artists and renders index template" do
      artist = create(:artist)

      get(:index)

      expect(assigns(:artists)).to eq([artist])
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "assigns the requested artist as @artist and renders the show template" do
      artist = create(:artist)
      get(:show, {:id => artist.to_param})
      expect(assigns(:artist)).to eq(artist)
      expect(response).to render_template("show")
    end
  end
end
```

This one is only slightly different. First, we create the artist using FactoryGirl. Next, we use the `get` method which accepts a parameter of the action name as a symbol (`:show`) and any parameters we want to pass to the controller. In this case, since we're looking at the show view, we want to send a specific ID of an artist. We do that with this line: `{:id => artist.to_param}`. `artist.to_param` by default will pass back the artist's ID.

Run the spec. This functionality is already implemented, so it should also pass.

#### Your Turn

Write controller specs for `GET #new`, `GET #edit`.

Once you're done, check the examples below:

```ruby
  describe "GET #new" do
    it "assigns a new artist as @artist" do
      get :new
      expect(assigns(:artist)).to be_a_new(Artist)
    end
  end

  describe "GET #edit" do
    it "assigns the requested artist as @artist" do
      artist = create(:artist)
      get :edit, {:id => artist.to_param}
      expect(assigns(:artist)).to eq(artist)
    end
  end
```

Let's write a spec for `POST #create` happy path. There are a few things we'll want to check for in the `create` action:

* was the artist created?
* did the instance variable get assigned?
* was it properly redirected to the artist show page?

Here's what that spec will look like:

```ruby
  describe "POST #create" do
    context "with valid params" do
      it "creates a new artist" do
        expect {
          post :create, {:artist => attributes_for(:artist)}
        }.to change(Artist, :count).by(1)
      end

      it "assigns a newly created artist as @artist" do
        post :create, {:artist => attributes_for(:artist)}
        expect(assigns(:artist)).to be_a(Artist)
        expect(assigns(:artist)).to be_persisted
      end

      it "redirects to the created artist" do
        post :create, {:artist => attributes_for(:artist)}
        expect(response).to redirect_to(Artist.last)
      end
    end
  end
```

Let's go over a few things:

* `attributes_for` is a FactoryGirl method that returns a hash of attributes for a given object. If you stick a `byebug` in one of your tests and call `attributes_for(:artist)`, you'll get something like this:

```ruby
{:name=>"9 Artist", :image_path=>"http://cps-static.rovicorp.com/3/JPG_400/MI0003/146/MI0003146038.jpg"}
```

* `expect {}.to change().by()` is RSpec syntax for checking the difference between before the block is executed and after. Here, we're wrapping the `post :create` inside of the expect block so that we can check the difference in `Artist.count`.

* `be_persisted` is an RSpec method that checks to make sure the object was persisted into the database (ie -- assigned an ID number).

* `expect(response).to redirect_to(Artist.last)` checks that the redirect is going to the last artist. This is the same as saying `artist_path(Artist.last)`.

Run `rspec`. Everything should pass.

Now let's get into where controller tests can become powerful in order to cut down on the time taken by sad path feature tests. Instead of testing invalid attributes in a feature test, we can do that through the controller. However, we will miss out on ensuring that a descriptive message to the user shows up on the view. There are a few ways to deal with this, and we'll discuss them later. Let's add a second context block to our previous `POST #create` spec to describe what happens when someone tries to create an artist with invalid parameters:

```ruby
  describe "POST #create" do
    context "with valid params" do
      it "creates a new artist" do
        expect {
          post :create, {:artist => attributes_for(:artist)}
        }.to change(Artist, :count).by(1)
      end

      it "assigns a newly created artist as @artist" do
        post :create, {:artist => attributes_for(:artist)}
        expect(assigns(:artist)).to be_a(Artist)
        expect(assigns(:artist)).to be_persisted
      end

      it "redirects to the created artist" do
        post :create, {:artist => attributes_for(:artist)}
        expect(response).to redirect_to(Artist.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved artist as @artist" do
        post :create, {:artist => attributes_for(:artist, name: nil)}
        expect(assigns(:artist)).to be_a_new(Artist)
      end

      it "re-renders the 'new' template" do
        post :create, {:artist => attributes_for(:artist, name: nil)}
        expect(response).to render_template("new")
      end
    end
  end
```

This should look pretty straightforward. Take a few minutes to play around with this set of specs. Use `byebug` and change certain expectations to see what breaks.

#### Your Turn

Write controller specs for `PUT #update` for both valid attributes and invalid attributes for an `artist`. When you finish, check your work with the example below:

```ruby
describe "PUT #update" do
    context "with valid params" do
      it "updates the requested artist" do
        artist = create(:artist)
        put :update, {:id => artist.to_param, :artist => attributes_for(:artist, name: "New name")}
        artist.reload
        expect(artist.name).to eq("New name")
      end

      it "assigns the requested artist as @artist" do
        artist = create(:artist)
        put :update, {:id => artist.to_param, :artist => attributes_for(:artist, name: "New name")}
        expect(assigns(:artist)).to eq(artist)
      end

      it "redirects to the artist" do
        artist = create(:artist)
        put :update, {:id => artist.to_param, :artist => attributes_for(:artist, name: "New name")}
        expect(response).to redirect_to(artist)
      end
    end

    context "with invalid params" do
      it "assigns the artist as @artist" do
        artist = create(:artist)
        put :update, {:id => artist.to_param, :artist => attributes_for(:artist, name: nil)}
        expect(assigns(:artist)).to eq(artist)
      end

      it "re-renders the 'edit' template" do
        artist = create(:artist)
        put :update, {:id => artist.to_param, :artist => attributes_for(:artist, name: nil)}
        expect(response).to render_template("edit")
      end
    end
  end
```

Finally, we'll finish up with writing a controller spec for deleting an artist:

```ruby
  describe "DELETE #destroy" do
    it "destroys the requested artist" do
      artist = create(:artist)
      expect {
        delete :destroy, {:id => artist.to_param}
      }.to change(Artist, :count).by(-1)
    end

    it "redirects to the artists list" do
      artist = create(:artist)
      delete :destroy, {:id => artist.to_param}
      expect(response).to redirect_to(artists_path)
    end
  end
```

#### Your Turn

Write controller specs for `PlaylistsController POST #create` and `PlaylistsController PUT #update`. Be sure to write a sad path to account for a playlist with a missing title. These tests won't automatically pass (unless you implemented sad path functionality on your own), so you'll need to use the error messages to drive out that behavior.

Make sure to commit your work! Use proper commit message manners. All tests should be passing.

### Life Raft

If you've messed things up, you can clone down the [6_controller-tests](https://github.com/rwarbelow/mix_master/tree/6_controller-tests) of `mix_master` which is complete up to this point in the tutorial.

```
$ git add .
$ git commit
$ git checkout master
$ git merge 6_controller-tests
$ git push heroku master
```

### On to [Mix Master Part 7: Implementing Users](/ruby_02-web_applications_with_ruby/mix_master/7_implementing_users.markdown)
