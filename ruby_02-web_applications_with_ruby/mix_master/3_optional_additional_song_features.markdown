# Mix Master: Optional Additional Song Functionality

```
$ git checkout -b additional-song-functionality
```

Implement the spec and functionality for one or all of these three user stories:

##### Easy

```
As a user
Given that an artist exists in the database
When I visit the individual artist page
And I click "New song"
And I select an artist
And I click "Create Song"
Then I should see "Title cannot be blank" on the page
```

This first user story will also force (encourage?) you to drop down to the model level to test your validations. 

##### Hard(er)

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

If you're stuck, check out the [song-functionality branch of the MixMaster repo](https://github.com/rwarbelow/mix_master/tree/song-functionality) at this point of completion. Keep in mind: this code is not *the answer*; it's just one way of doing it. If you find a way that you can justify as being better, do it! 

```
$ git add .
$ git commit
```

Depending on how confident you are that your branch works, you may or may not choose to merge back into master.

```
$ git checkout master
$ git merge additional_song_functionality
$ git push heroku master
$ heroku run rake db:migrate
```