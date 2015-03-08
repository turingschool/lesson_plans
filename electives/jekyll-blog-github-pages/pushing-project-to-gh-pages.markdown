## Pushing Your Jekyll Project to Github Pages

1) I like for the name of my local repository to match the name of the remote repository. So, let's rename our local Jekyll project from the command line. For the example code below, I'll assume that you named your project folder "my-blog". Instead of "rwarbelow", use your own Github username when you type this command:

```
$ mv my-blog rwarbelow.github.io
```

This will change the name of my project "my-blog" to "rwarbelow.github.io". 

2) Go to your Github account online. In the upper corner, click the `+` link to create a new repository. 

3) Under "Repository Name", type `(your-username).github.io` and click create. That pattern of `username.github.io` is important. Don't change it. Github is looking for that specific name in order to host it using Github Pages. 

4) Copy the line that starts like this:

```
git remote add origin ...
```

and paste it in the terminal window where you're working on your project. 

5) Make sure that you've added (`git add .`) and committed (`git commit -m 'initial commit'`) your files.

6) Type `git push -u origin master`.

7) Navigate to `your-username.github.io`. Magic! You can continue to work on your blog. Make sure that you add and commit your changes and then push to master. Github will automatically run `jekyll build` and host your page. 

* [Jekyll By Example Tutorial](https://www.andrewmunsell.com/tutorials/jekyll-by-example) (super comprehensive)
