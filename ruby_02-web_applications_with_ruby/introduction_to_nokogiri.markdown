# Introduction to Nokogiri

## Learning Goals

* Become familiar with the library Nokogiri
* Practice using Nokogiri to fetch and navigate through HTML
* Practice using CSS-style selectors to find HTML content

## Fundamentals

### Installing Nokogiri

Install some Xcode compilers and nokogiri in your terminal:

```plain
$ xcode-select --install
$ gem update --system
$ brew tap homebrew/versions && brew install apple-gcc42
$ brew link --force apple-gcc42
$ ln -nsf $(which gcc-4.2) /usr/bin/gcc-4.2
$ gem install nokogiri -- --use-system-libraries=true --with-xml2-include=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include/libxml2/
```

It includes some C extensions, so it might take a little while to install
(it will say _building native extensions_).
If there are problems with the gem install, it's because something in your environment is not
configured correctly. Read through [Nokogiri's installation instructions](http://nokogiri.org/tutorials/installing_nokogiri.html)
for help.

### An Experiment

In your browser pull up http://www.denverpost.com/frontpage . See the Headlines
down the left column? Let's use Nokogiri to fetch them into our Ruby program (aka 'scrape' them).

Put the following in a Ruby file:

```ruby
require 'nokogiri'
require 'net/http'
require 'pry'

# get the HTML from the website
uri  = URI("http://www.denverpost.com/frontpage")
body = Net::HTTP.get(uri)

# parse it and use CSS selectors to find all links in list elements
document = Nokogiri::HTML(body)

# pry at the bottom so we can play with it
binding.pry
puts 'done'
```

Run that file and you should get a pry prompt. Inside that prompt we can now
interact with the `document` that Nokogiri parsed for us.

Try running `document.inspect` and you'll get the sense that the object is huge.

You can find a [cheat sheet with some common Nokogiri patterns here](http://cheat.errtheblog.com/s/nokogiri).

Try this at your prompt which should output the title of the page:

```
pry(main)> document.at_css('title').text
=> "Front Page - The Denver Post"
```

Ta-da, you're navigating HTML!

### CSS Selectors

When we work with Nokogiri we are most often going to be searching for elements
(or "nodes") within the document. There are multiple ways to search through the
elements, but we'll favor CSS Selectors.

You've seen the main CSS selectors before:

* `.the_class_name` looks for nodes with the CSS class `the_class_name`
* `#the_id` looks for nodes with the CSS ID `the_id`

There are two primary methods that you'll use on a Nokogiri document:

* `.at_css` returns the first node that matches the CSS selector
* `.css` returns all the nodes that match the selector

So if you're looking for just one thing, you want `.at_css`. Looking for a list,
use `.css`.

And recall that the CSS selectors can be nested. For instance:

```
nodes = document.css('#region2 li a')
```

Grabs me all the `a` (aka links) which are inside `li` elements that are inside
the div with the ID `region2`.

Since we used `.css` this is a collection.

* How many nodes are there?
* Can you turn it into an array of the `text` of each node?
* Can you print those out to the screen as a simple Markdown unordered list?
* Can you add the URL after each article in the list, so it'd look like this:

```
* Article Title 1: http://denverpost.com/article1
* Article Title 2: http://denverpost.com/article2
...
```

### Caveats

There's one big gotcha: Nokogiri does not execute JavaScript. The document that
you're interacting with is the plain HTML that the server sends back when you
make the request.

Many modern sites, like the Denver Post, use JavaScript to dynamically inject content.
That means that the content isn't in the original HTML, there's just a reference
to the JavaScript which the browser executes to fetch and insert additional content.

If you want to interact with the results of JavaScript, you're going to need a
"headless browser" with a "JavaScript runtime" like PhantomJS.

## Practice

Let's practice by loading a specific article. Select a specific article URL from the front page
and use it in your program. When we run the program it should output a summary
of the one article like this:

```
Title: Colorado lawmakers finish session with little progress on top issues
Posted: 05/10/2016 07:30:38 PM MDT
Word Count: 976
```

You'll have to calculate the word count by fetching all the paragraphs.

### Extension

Return to the front page. Can you output a summary like the above for all the
top-ten articles? Fetch the list from the front page, then iterate through the
list loading and working with each article document on its own.
