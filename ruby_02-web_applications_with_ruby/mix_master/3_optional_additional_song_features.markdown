# Mix Master: Optional Additional Song Functionality

```
$ git checkout -b additional-song-functionality
```

Implement the spec and functionality for one or more of these user stories:

##### Easy

```
As a user
Given that an artist exists in the database
When I visit the individual artist page
And I click "New song"
And I click "Create Song"
Then I should see "Title cannot be blank" on the page
```

This first user story will also force (encourage?) you to drop down to the model level to test your validations. 

```
As a user
Given that a song exists in the database
When I visit that song's show page
And I click on "Edit"
And I fill in a new title
And I click on "Update Song"
Then I should see the song's updated name
Then I should see a link to the song artist's individual page
```

##### Hard(er, but not super tricky)

```
As a user
Given that an artist and that artist's associated songs exist in the database
When I visit the individual artist page
And I click "View songs"
Then I should see the song titles for that specific artist sorted alphabetically
And each title should link to the individual song page
```

You'll want to check out the [FactoryGirl Documentation](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md) in order to figure out how to set up factories that have associations. 

```
As a user
Given that songs exist in the database
When I visit the songs index ('/songs')
Then I should see the titles of all songs in the database sorted alphabetically
And the titles should each link the individual song page
```

##### Just a Bit Harder

```
As a user
Given that an artist and a song for that artist exist in the database
When I visit the artist's song index ('/artists/1/songs')
And I click on "Delete"
Then I should be back on whatever page I was on before (the artist's song index page)
And I should not see the the song title
```

The above functionality should also exist if the user starts at the songs index `'/songs'` and clicks delete. The redirect should in that case be back to the songs index, not the artist's song index. 

```
$ git add .
$ git commit
```

Depending on how confident you are that your branch works, you may or may not choose to merge back into master and push to Heroku. 

```
$ git checkout master
$ git merge additional_song_functionality
$ git push heroku master
$ heroku run rake db:migrate
```

If you're unsure about your work, you might just commit to this branch, then check out master (and NOT merge) and move on. 

### On to [Mix Master Part 4: Implementing Playlists](/ruby_02-web_applications_with_ruby/mix_master/4_implementing_playlists.markdown)
