## Templating with ERB & Intro to Wireframing

---

### Learning Goals
- Review ERB basics
- Understand injection vs non-injection in regards to ERB
- Understand what wireframes are
- Understand why wireframing is important
- Learn how to create a view template from a wireframe
- Introduce wireframing tools

---

### What is a templating language?

Templating languages allow us to create view templates. These are used to inject bits of data into a larger body of text.

### Why do we need a templating language?

We're generating nearly identical documents for a set of inputs and generating web pages where much of the structure (HTML and CSS) is the same for every user, but some parts are customized. ex - facebook, twitter, etc.

---

## What is ERB?

ERB stands for Embedded RuBy. It allows us to create view templates. ERB is part of the Ruby standard library. You do not need to install any other software to use it.

### How does erb know which view template to return?

When you have code like the following:

```ruby
get '/' do
  @artists = Artist.all
  erb :index
end
```

ERB assumes you have a `views` folder within your `app` folder and looks for `index.erb` within that folder. We need to follow this convention, or `erb` won't be able to find the correct view template.

We can also nest view templates to keep our code more organized. Let's say we have `artists` and `songs` and we want different folders within our `views` folder to stay organized (this is very common). If we have code in our controller like the following:

```ruby
get '/' do
  @artists = Artist.all
  erb :'artists/index'
end
```

ERB will look in the `views` folder, then in the `artists` folder within `views`, and look for `index.erb` within that folder. The view it's looking for lives in `app/views/artists/index.erb`. 

---

## Injection vs Non-injection with erb

What's the difference between injection and non-injection with `erb`. Have you noticed that sometimes we interpolate with `<%= %>` and sometimes we just have `<% %>`? 

### Example of Simple injection

```html
<html>
<head><title>Diploma for <%= student.last_name %></head>
<body>
  <h1>Turing School of Software and Design<h1>
  <p><%= student.first_name %> <%= student.last_name %> has graduated.</p>
</body>
</html>
```

### Example of Non-injection

```html
<html>
<head><title>Diploma for <%= student.last_name %></head>
<body>
  <h1>Turing School of Software and Design<h1>
  <% if student.graduated? %>
    <p>This student has graduated.</p>
  <% else %>
    <p>This student needs to get back to work.</p>
  <% end %>
</body>
</html>
```

### Injection vs Non-injection

`<%` and `%>` are used to inject and execute Ruby, but the return value of those instructions themselves are not output

`<%=` and `%>` are used to inject and execute Ruby, and return the value of that output

The difference is what is outputted to the screen.

---

## Wireframing

### What is a wireframe?

- skeletal versions of web pages that indicate the content those pages will contain
- diagrams the page’s structure
- almost a "blueprint" of the final page
- why does it represent a blueprint?
- the data on the page is dynamic (meaning it's not always the same)

Basically, I'll see different content on my Twitter homepage than someone else, but the view template that renders that content is the same.

## Why wireframe?

- it helps inform what data you need available within that view template
- it helps keep us organized (as you can already tell, there are many moving parts to building a web application)
- helps us focus on the content and functionality without getting caught up in the overall design
- you could create a bazillion different wireframes for the same application

---

## When should you wireframe?

You should wireframe BEFORE starting to code. It will help you stay organized and on track. Planning is extremely important when beginning to create a web application and wireframing is the first step.

## Examples

<img src="https://mir-s3-cdn-cf.behance.net/project_modules/hd/a7234913421913.56280d3b3c65d.png" width="550" height="620">

<!--![20% good example](https://mir-s3-cdn-cf.behance.net/project_modules/hd/a7234913421913.56280d3b3c65d.png)-->

<img src="http://creately.com/images/landing-new/wireframe/wireframe-2-large.jpg" width="580" height="600">

<!--![40% twitter](http://creately.com/images/landing-new/wireframe/wireframe-2-large.jpg)-->

<img src="https://static.skillshare.com/uploads/project/c8b8a01fcb0903765428b06c9a03026f/0eb88a2a" width="700" height="650">
<!--![30% restaurant](https://static.skillshare.com/uploads/project/c8b8a01fcb0903765428b06c9a03026f/0eb88a2a)-->

## Example

Let's say we're building an application that allows us to view all the songs we've favorited and the artist that created that song. Where do we start? Wireframes!

We definitely need my favorited songs along with the artist that created the song. These are my two pieces of data - how I choose to display this is completely up to me (or whomever I'm building this application for).

My wireframe might look something like this:

<img src="http://i.imgur.com/ezUAA1d.jpg" width="300" height="400">

**Remember - our wireframes are templates for individual erb pages that are going to render data dynamically (depending on which page is requested from whomever is interacting with our application**

## **Great** wireframing tools:

- Pen & Paper
- Whiteboard
- [Balsamiq](https://balsamiq.com/) 
- [Axure](http://www.axure.com/)
- [Mockingbird](https://gomockingbird.com/home)
- [Lovely Charts](http://lovelycharts.com/)

Pen/paper or a whiteboard is the preferred way unless there's a reason you need to use a wireframing tool. Reasons may include working remotely with a team.

## Practice

Let's build a wireframe.. 

Application: a simple blog
Page: viewing list of articles

- the title of the blog at the top of the page
- a list of articles containing the title and author of each
- each title is a link to the view of that specific article

**Create a wireframe with pen & paper for this specific view.**

Let's build another wireframe..

Application: a simple blog
Page: viewing a specific article

- the title of the blog at the top of the page
- the title of the article
- the body of the article
- the author of the article

**Create a wireframe with pen & paper for this specific view.**


## How do we go from wireframe to view template?

It's much easier to write the code you need to implement a specific view after you have a wireframe. You'll know what data you'll need and a rough idea of what it should look like on the page. In the example above, we know that we need the title of the blog and data about the specific article we're viewing.

**At this point, if you are still unclear about any piece of this material, check in with an instructor. If not, continue on to the second practice application below.**

## Workshop

Work with the code in the [Intro to Wireframing Repo](https://github.com/case-eee/wireframing-example). When finished, create a pull request to this repo with the work you completed. Add pictures of your wireframes. 
