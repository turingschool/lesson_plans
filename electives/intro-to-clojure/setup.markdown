## Setting up a Basic Clojure Dev Environment

Setting up your development machine to write clojure code
is pretty easy, but there are a few dependencies we'll
need to set up:

1. Java (Clojure is hosted on java so we'll need to have it installed)
2. Leiningen (a Clojure build tool, similar to Bundler in Ruby)


### 1. Java

First, check to see if you already have Java installed. Do this by running
`java -version` in your terminal.

If you see something like this:

```
worace @ Guinevere-2 / lesson_plans / master ➸  java -version
java version "1.7.0_80-ea"
Java(TM) SE Runtime Environment (build 1.7.0_80-ea-b04)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b07, mixed mode)
```

Including a version of __1.7 or greater__, then you are good to go.
Skip to step 2.

If you don't have java installed, or if your computer has a version older
than 1.7 installed, go to this website:

http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

And download the appropriate JDK (Java Development Kit) installer for your operating system.

When the download finishes, go through the installation instructions.

Finally, confirm everything worked by running `java -version` again.

### 2. Leiningen

[Leiningen](http://leiningen.org/) is a build tool and dependency manager for Clojure,
somewhat similar to Bundler in ruby. We'll use it to generate clojure projects, manage
dependencies, run a REPL, and run our code.

Fortunately it can be installed pretty easy using Homebrew:

```
brew install leiningen
```

You can confirm this worked by running `which lein` in your terminal.
You should see a filepath pointing to the program just installed by homebrew

### 3. Using the Clojure REPL

The Clojure REPL allows us to interactively run Clojure code. For many developers,
it's an integral part of their experience developing with Clojure. Let's try
it out:

```
lein repl
```

### 4. Clojure Fundamentals

Now that we have some tooling set up, let's look at the basic building blocks of
the Clojure Language.

Use your REPL to follow along with the examples in this tutorial: https://github.com/turingschool/lesson_plans/blob/master/electives/intro-to-clojure/02-writing-clojure-code.markdown

### 5. Creating a Minimal Clojure Project

Let's poke around in a simple Clojure project. Leiningen serves as our tool for
generating new Clojure projects, somewhat similarly to the generator tasks in a Rails
project.

Create a playground project using leiningen like this:

```
lein new my-first-clj
```

`cd` into your newly created directory and let's take a look around.

```
cd my-first-clj
tree .
.
├── LICENSE
├── README.md
├── doc
│   └── intro.md
├── project.clj
├── resources
├── src
│   └── my_first_clj
│       └── core.clj
└── test
    └── my_first_clj
        └── core_test.clj

6 directories, 6 files
```

## Starting a Basic ClojureScript Project

Now that we've installed those tools, we're ready to actually make a clojure
project.

For this demo, we'll actually be writing Clojure..._script_ which is a version
of clojure that compiles our code into Javascript so we can run it in the browser.

Don't worry -- Clojurescript features all the same exciting features of clojure
(immutable data types, functional programming) as its JVM-based sibling.

Additionally, we'll be using a library called [Quil](http://quil.info/) to do
some graphics programming.

### 1. Generating the project

We'll use leiningen's `new` command to start our project, like so:

```
lein new quil-cljs hello-quil
```

This will generate a new project scaffold for us with the appropriate dependencies
including:

* Clojurescript (for compiling clojure code into Javascript)
* Quil (our graphics library)
* A basic `index.html` file for viewing our project

### 2. Start our project build

Unlike Ruby, Clojure is a "compiled" language. To begin this process we can run:

```
lein cljsbuild auto
```

This will compile the clojure source files into JS, and also watch for us to save the files and update
the compiled files appropriately.

Once this starts, open the index.html file in your browser:

```
open index.html
```

You should see some sweet Quil action!


