## Pushing Your Jekyll Project to Github Pages

1) Go to your Github account online. In the upper corner, click the `+` link to create a new repository. 

2) Under "Repository Name", type `(your-username).github.io` and click create. That pattern of `username.github.io` is important. Don't change it. Github is looking for that specific name in order to host it using Github Pages. 

3) Copy the line that starts like this:

```
git remote add origin ...
```

and paste it in the terminal window where you're working on your project. 

4) Make sure that you've added (`git add .`) and committed (`git commit -m 'initial commit'`) your files.

5) Type `git push -u origin master`.

6) Navigate to `yourusername.github.io`. Magic! You can continue to work on your blog. Make sure that you add and commit your changes and then push to master. Github will automatically run `jekyll build` and host your page. 
