# Templating with ERB

View templates are used to inject bits of data into a larger body of text. This
is useful if you want to solve problems like:

* generating nearly identical documents for a set of inputs. For instance, we
could have an array of names of graduating students, a view template for a diploma,
and combine them to generate individual diplomas
* generating web pages where much of the structure (HTML and CSS) is the same
for every user, but some parts are customized. Like a view template for http://google.com
would have the search box and links that everyone sees, but dynamically inject your
username into the top right corner where it shows links to your Google Docs

### Important Terms

* Templating Language: The language used to write up the template. How do we "mark"
points in the standard text where the insertions should take place? The templating
language defines these markers.
* Template: A document written in the templating language. Most templates are primarily
another language (HTML, standard English prose, etc) with small bits of the templating
language inserted
* Templating Engine: The software library that can load up a template, speaks the
templating language, and can "execute" the template by running the instructions
embedded in the template

### Examples

Kind of got the gist of it? Let's look at a few examples:

#### Simple Injection

```erb
<html>
<head><title>Diploma for <%= student.last_name %></head>
<body>
  <h1>Turing School of Software and Design<h1>
  <p><%= student.first_name %> <%= student.last_name %> has graduated.</p>
</body>
</html>
```

In this example we:

* Are using the `ERB` templating language
* Have a template primarily written in HTML with three different ERB injections
* See that an ERB injection starts with `<%=` and ends with `%>`
* See that inside the injection we can use what looks like Ruby code (ie `student.last_name`)

This file is *just* a template. We can't *run* the file, per se. In order to generate
the diplomas we'd need to load up a templating engine.

#### Injection & Non-Injection

Often we want to write some code inside a template that controls the output, but
is itself not part of the output. Look at this version carefully:

```erb
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

Note in this example how we see some slightly different injections. `<%` and `%>`
are used to inject and execute Ruby, but the return value of those instructions
themselves are not output. They are executed and control which paragraph gets
rendered, but the `true` or `false` value from the `if` itself is not output.

## Rendering

There are several libraries which know how to render ERB templates. One of the
easiest is called **Tilt**.

Go over to the [Tilt repository on GitHub](https://github.com/rtomayko/tilt) and
read just the **Basic Usage** section of the README.

Hint: Once you've got Tilt generating a string of HTML for you, you can write it out to a file like this:

```ruby
f = File.new("output.html", "w")
f.write(rendered_string)
f.close
```

## Discovery

It's not exactly easy to understand everything that's going on in that README.
Let's try to stitch together our understanding of ERB, writing templates, and
rendering them with Tilt.

### Challenge

* Start by downloading [this data file](https://www.aggdata.com/download_sample.php?file=ussenator.csv) which contains info on all the current US Senators
* Use ERB and Tilt to render an HTML directory of the information. Each Senator
should have a rendered chunk of HTML like this:

```
<h3>Akaka, Daniel K.</h3>
<ul>
  <li>State: HI</li>
  <li>Party Affiliation: Democrat</li>
  <li>Office Address: 141 HART SENATE OFFICE BUILDING WASHINGTON DC 20510</li>
  <li>Phone Number: (202) 224-6361</li>
  <li><a href='http://akaka.senate.gov,http://akaka.senate.gov/email-senator-akaka.cfm'>Website</li>
</ul>
```

Render the whole directory to an HTML file. Open it in your browser to make sure
it renders correctly!

#### Tips

1: Start small and iterate! Don't try and render the whole data file. Just copy one line out from the data and try to render the HTML for that one line. Once you have that working *then* you can worry about loading all the data from the CSV and iterating through it. Don't try and get everything just right in the formatting the first time -- just get some output going them work with it from there.

2: You're probably going to be "manually testing" by just observing the output. If you'd like an extra challenge, go ahead and try to write tests for the rendering process. But if it seems hard enough already, don't worry about automated tests.

3: Reading CSV files goes like this:

```ruby
CSV.foreach('ussenator.csv', headers: true, header_converters: :symbol) do |row|
  # Now you have access to one row of data that works like a hash:
  puts row[:name]
  puts row[:party]
end
```

#### Extensions

* Can you expand the state abbreviations to their full name (ie `HI` becomes `Hawaii`)?
* Can you group the senators by state? There's be a `<h2>` with the name of the state,
the senators for that state under that heading. All in alphabetical order by state, of course.
* Can you add a party roll-up to the top of the file that looks like this:

```
<h2>Party Affiliations</h2>
<ul>
  * Democrat: 32
  * Independent: 2
  * Republican: 64
</ul>
```

But where the numbers are an accurate count based on the data?

## End Goals

Once you've completed the exercise you should:

* Understand how templating languages, templates, and templating engines work together
* Know how to use ERB's `<%=` and `<%` appropriately
* Remember how to work with CSVs to load/read data
* Have a sweet directory of US Senators :P
