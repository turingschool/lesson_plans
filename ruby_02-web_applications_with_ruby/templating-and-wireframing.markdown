## Templating with ERB & Intro to Wireframing

---

## Learning Goals
- Review ERB basics
- Understand injection vs non-injection in regards to ERB
- Understand what wireframes are
- Understand why wireframing is important
- Learn how to create a view template from a wireframe
- Introduce wireframing tools

---

### What is a templating language?

* allows us to create view templates
* these are used to inject bits of data into a larger body of text

---

### Why do we need a templating language?

* generating nearly identical documents for a set of inputs
* generating web pages where much of the structure (HTML and CSS) is the same
for every user, but some parts are customized. ex - facebook, twitter, etc.

---

## What is ERB?

---

## ERB

- Embedded RuBy
- Allows us to create view templates
- ERB is part of the Ruby standard library. You do not need to install any other software to use it.

---

### How does erb know which view template to return?


--- 

## ERB

when you have code like the following:

```
get '/' do
  @artists = Artist.all
  erb :index
end
```

erb ASSUMES you have a views folder.. and looks for `index.erb` within that folder

---

## Nesting view templates with erb

```
get '/' do
  @artists = Artist.all
  erb :'artists/index'
end
```

erb will look in the views folder, then in the artists folder within views, and look for `index.erb` within 'views/artists'

---

## Injection vs Non-injection with erb

---
### Simple injection

```
<html>
<head><title>Diploma for <%= student.last_name %></head>
<body>
  <h1>Turing School of Software and Design<h1>
  <p><%= student.first_name %> <%= student.last_name %> has graduated.</p>
</body>
</html>
```

---

### Injection & Non-injection

```
<html>
<head><title>Diploma for <%= student.last_name %></head>
<body>
  <h1>Turing School of Software and Design<h1>
  <% if student.graduated? %>
    <p><%= student.first_name %> <%= student.last_name %> has graduated.</p>
  <% else %>
    <p><%= student.first_name %> <%= student.last_name %> needs to get back to work.</p>
  <% end %>
</body>
</html>
```

---

### Injection vs Non-injection

`<%` and `%>`
are used to inject and execute Ruby, but the return value of those instructions themselves are not output

`<%=` and `%>`
are used to inject and execute Ruby, and return the value of that output


---

## Wireframing

---

### What is a wireframe? 

---

![40% restaurant](https://static.skillshare.com/uploads/project/c8b8a01fcb0903765428b06c9a03026f/0eb88a2a)

---

### What is a wireframe?

- skeletal versions of web pages that indicate the content those pages will contain
- diagrams the page’s structure
- almost a "blueprint" of the final page
- why does it represent a blueprint?

---

![50% twitter](http://creately.com/images/landing-new/wireframe/wireframe-2-large.jpg)

--- 

## Why wireframe?

- it helps inform what data you need available within that view template
- it helps keep us organized (as you can already tell, there are many moving parts to building a web application)
- helps us focus on the content and functionality without getting caught up in the overall design
- you could create a bazillion different wireframes for the same application

---

## When should you wireframe?

---

![25% good example](https://mir-s3-cdn-cf.behance.net/project_modules/hd/a7234913421913.56280d3b3c65d.png)

---

## Example

We're building an application that allows us to view all the songs we've favorited and the artist that created that song

Where do we start?

---

## Practice

---

## Let's build a wireframe.. 

### Application: a simple blog
### Page: viewing list of articles

- the title of the blog at the top of the page
- a list of articles containing the title and author of each
- each title is a link to the view of that specific article

---

## Let's build another wireframe..

### Application: a simple blog
### Page: viewing a specific article

- the title of the blog at the top of the page
- the title of the article
- the body of the article
- the author of the article

---

## How do we go from wireframe to view template?

---

## Practice

- [Intro to Wireframing Repo](https://github.com/case-eee/wireframing-example)

---

## Practice

1. Create a wireframe
2. Create corresponding view template to render that wireframe

---

## **Great** wireframing tools:

- Pen & Paper
- Whiteboard
- [Balsamiq](https://balsamiq.com/) 
- [Axure](http://www.axure.com/)
- [Mockingbird](https://gomockingbird.com/home)
- [Lovely Charts](http://lovelycharts.com/)

---