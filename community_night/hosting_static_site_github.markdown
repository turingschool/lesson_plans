---
title: Hosting a Static Site with Github Pages
tags: git, github, github-pages
---

Disclaimer: This tutorial is written for Mac users. If you are not on a Mac, you might want to consider using [Nitrous.io](http://nitrous.io) which provides a cloud-based development environment. 

## Basic Hosting with Index.html

1) Sign up for a free Github account at [https://github.com/](https://github.com/). Check your email and confirm your account.

2) Click on the `+` button in the upper right-hand corner. 

3) Under "Repository Name", type `(your-username).github.io`. 

4) From the command line, navigate to a folder where you want to save your project. 

5) From the command line:

```
$ git clone https://github.com/your-username/your-username.github.io
$ cd your-username.github.io
$ touch index.html
```

6) Open up `index.html` and add some basic html:

```html
<html>
<head>
  <meta charset="UTF-8">
  <title>My Page</title>
</head>
<body>
  <h1>Hello, world.</h1>
</body>
</html>
```

7) Add, commit, and push your changes:

```
$ git add .
$ git commit -m 'initial commit'
$ git push -u origin master
```

8) Navigave to `your-username.github.io`. Magic! 

### Other Things

Right now, your site is bare and ugly. You might consider adding more content to your index.html. Want to learn HTML? Try [Codecademy's HTML/CSS track](http://www.codecademy.com/en/tracks/web).

If you know HTML already, you may want to use [Bootstrap](http://getbootstrap.com/) for styling. 

## A More Advanced Blog: Using Jekyll 

First things first:

* Do you have Ruby on your computer? Type `ruby --version` from the command line. If you do, you're good to go. If not, we recommend [RVM](http://rvm.io/). 
* Do you have the bundler gem installed? If not, type `gem install bundler` from the command line. 

1) `gem install jekyll`

2) `mkdir (your-username).github.io`

3) `cd (your-username).github.io`

4) `touch _config.yml`, then inside that file:

```yml
title: [Insert Title Here]
email: [Insert Email Here]
description: [Insert content Here]
twitter_username: [Insert Twitter Handle Here]
github_username:  [Insert Github Username Here]
```

Want to get fancy with your _config.yml file? Check out the possible Jekyll configurations [here](http://jekyllrb.com/docs/configuration/). 

5) `touch index.md`, then inside of that file:

```html
---
layout: default
---

{% for post in site.posts %}
  <div class="row-fluid">
    <div class="span12">
      <h2>{{ post.title }}</h2>
      <h4>{{ post.date | date: "%m-%d-%Y" }}</h4>
      <p>
        <a href="{{ post.url }}">Read</a>
      </p>
    </div>
  </div>
{% endfor %}

```

6) `mkdir _includes`. This folder will be used for reusable pieces of html (like a header or a footer).

7) `touch _includes/header.html`, then inside of that file:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>{{ site.title }}</title>
    <link href="/css/bootstrap.css" rel="stylesheet">
    <style>
      body {
        padding-top: 60px;
      }
    </style>
  </head>
  <body>
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="brand" href="#">{{ site.title }}</a>
          <div class="nav-collapse collapse">
            <ul class="nav">
              <li class="active"><a href="/">Home</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="container">
```

8) `touch _includes/footer.html`, then inside of that file:

```html
    </div>
  </body>
</html>
```

9) `mkdir _layouts`

10) `touch _layouts/default.html`, then inside of that file:

```html
{% include header.html %}

{{ content }}

{% include footer.html %}
```

11) `touch _layouts/post.html`, then inside of that file:

```html
{% include header.html %}

<h1>{{ page.title }}</h1>
<p>{{ page.date }}</p>
{{ content }}

{% include footer.html %}
```

12) `jekyll build`: this command won't change anything about your files or folders but you should see some sort of "success" message. 

13) `mkdir _posts`

14) `touch _posts/2015-03-04-my-first-post.md`, then inside of that file:

```
---
title: My First Post
layout: post
---

Put some text here.

### Here is a heading

Write some stuff about that heading.
```

The name of the files inside of post must follow this format: `YYYY-MM-DD-your-title.md`

15) `mkdir css`

16) Download the Bootstrap css file and save it as `css/bootstrap.css`

17) run `jekyll serve --watch`

18) go to `localhost:4000` in your browser

19) `git init`

20) On Github.com, click on the `+` button in the upper right-hand corner. 

21) Under "Repository Name", type `(your-username).github.io`. 

22) Copy the line that starts with `git remote add origin ...` and paste that in the command line. 

23) `git add .`

24) `git commit -m 'initial commit'`

25) `git push -u origin master`

26) Navigave to `your-username.github.io`. Magic! 

## Other Stuff

* Want to format your date? Capitalize your post titles? Truncate titles? Check out the [Liquid Filters](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers).

* Thanks to Andrew Munsell's [very comprehensive Jekyll tutorial](https://www.andrewmunsell.com/tutorials/jekyll-by-example/tutorial).
