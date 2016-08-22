---
title: Dev Environment Setup
---

Before we can do much programming, we need to make sure our machines
are properly configured with a functional Development environment.
Let's walk through this process now to make sure we have what we need.

Here are the basics we're going to go over:

* A text editor. Developers need to work with text in a different way than
your average MS Word user. We'll want a text editor designed for software
development.
* A system "Terminal" for interacting with our machine from the command
line. Fortunately OS X already ships with one.
* OS X "Command Line Tools" -- these are some system dependencies needed for
some of the tools we will use.
* HomeBrew -- This is a "package manager" for installing other developer-related
programs. You can think of it as the "App Store for nerds."
* Git (An application for handling "version control" of our software projects)
* The Ruby programming language -- version 2.2 in particular -- as well as a Ruby "Version Manager" to allow
us to install other versions as needed

### Text Editor

If you don't already have a favorite text editor, we recommend using [Visual Studio Code](https://code.visualstudio.com/
).

#### Setting Up Terminal Access for Visual Studio Code

One of the things you'll do frequently is open an entire folder (like when working on a project) in your text editor. Let's get that setup:

Visit this [link](https://code.visualstudio.com/docs/setup/osx) and follow the instructions within.


### Terminal

The terminal is a textual interface to your computer. Before Graphical User
Interfaces were invented, this was the only way one could interact with a computer.

Nowadays, developers still prefer this interface due to its power, flexibility,
and speed.

A Terminal allows you to navigate around folders (called directories) and run programs.
For example, when we run `ruby`, we are running that program from the terminal.

To launch the terminal, open Spotlight using `Command-Spacebar`, type "terminal", then enter.

If this is all new for you, see [Terminal and Editor](https://github.com/turingschool/curriculum/blob/master/source/academy/workshops/terminal_and_editor.markdown)

### XCode & Command Line Tools

XCode is a huge suite of development tools published by Apple. If we wanted to develop
software for the Apple Ecosystem (iPhone apps, Mac OS Apps, etc), we would use XCode as our editor.
But even if we aren't working in this ecosystem, XCode provides some system dependencies that we'll
want to have available.

You'll want to install it before attempting to install anything else.

1. Install XCode from the Apple App Store
2. Open the application after installing and agree to the SLA terms
3. Open `terminal` and run `xcode-select --install`, enter your user password

Now you should have the underlying tools we need to move forward.

### Homebrew

[Homebrew](http://brew.sh) is a package management system that makes it easy
to install hundreds of open source projects and compile them from source
for maximum performance on your machine.

Open the Terminal then run the homebrew installation script:

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

It will ask you for your password. This is the password to log in to your account on the computer.
It needs this because it installs its packages in a place that all users of this computer can access.

#### Verifying Homebrew

When it has completed the installation run `brew doctor` and it should tell you that everything is fine:

```shell
brew doctor
Your system is ready to brew.
```

#### Modifying your PATH

If you got a warning from Homebrew about your path, do the following:

```shell
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

Now run `brew doctor` again and the warning should be gone.

__Aside: `PATH`:__

Your `PATH` is a system configuration
property which tells your computer which places to look for underlying programs
when you want to run a command.

For example, when we type `ruby` at the command line to run a ruby program, our `PATH`
will help the system know where on the system to find ruby. By adding this directory
to our `PATH`, we're telling the system how to find the various applications we will
install using Homebrew

__Aside: `~/.bash_profile`__

When we use our terminal, we're actually using a program called a "Shell" to interact
with the underlying Operating System. Specifically, we're using a shell called [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)).

The file `~/.bash_profile` contains settings and commands to help us configure the shell,
so when we have a bit of configuration code such as setting our `PATH`, it often goes
in our `~/.bash_profile`.

### Git

[Git](http://git-scm.com/) is the version control system of choice in the Ruby community.
XCode installed an older version of Git for you, but let's update it.

```shell
brew install git
==> Downloading http://git-core.googlecode.com/files/git-1.8.3.4.tar.gz
########################################################### 100.0%
```

#### Configuring Git

If you haven't used git before (don't worry, we'll be covering its usage in future classes),
we'll want to configure it with some basic information about us.

We can tell git to configure itself using the `git config` command from our terminal.
Additionally, we're setting "global" configurations for git, so we'll use the `--global` flag
when we provide it with a new piece of configuration.

Tell git your Name and Email address by using the following commands, substituting your
own name and email:

```
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

### [RVM](http://rvm.io)

As the Ruby language has evolved over the years, new versions have been
released containing new features and various upgrades. The first version,
released in 1995, was 0.95, and as of this writing we're at 2.2.3.

To some extent programs written for one version of Ruby will run just fine on another version,
but sometimes you'll encounter incompatibilities, such that a program needs
to be run with a specific version of Ruby.

For this reason, we'd like to be able to install and manage multiple versions on our system.
This is precisely the job RVM handles.

#### Installation

Similar to Homebrew, RVM provides a script to get everything installed. Run this in your Terminal:

```shell
curl -L https://get.rvm.io | bash -s stable
```

#### Loading / Post-Install

Look for the line in the output from the RVM installation that starts with

```shell
To start using RVM you need to run `source ...`
```

Copy the command inside of the backticks (don't include the backticks), paste it into your terminal window, and hit enter.

Check if it got installed correctly by checking the version.

```
rvm --version
```

It should give you a version number rather than an error message.

### Ruby

Now that we have RVM installed, we're going to use it to install a specific
version of Ruby: Ruby 2.3.0.

If you need another version it'll be same procedure, just replace "2.3.0" in the instructions with whichever version you want.

Install it with:

```shell
rvm install 2.3.0
```

#### Setting the Default Version

You can tell rvm which Ruby version you want to use by default:

```shell
rvm use 2.3.0 --default
```

#### Requirements

There are *several* additional libraries that gems will often rely on. RVM makes installing those easy, too. Run this command:

```shell
rvm requirements
```

It'll figure out what needs to be installed and install it. If prompted for your password, use your computer login password.

### Folder Structure

Now, let's create a folder structure to store all of your code. We can start by
moving to our home folder, and then creating a Turing folder.

```
$ cd ~
$ mkdir turing
```

__A few notes:__

* `cd` stands for "change directory", and moves us to a specific place on the filesystem,
similar to using the GUI Finder to browse directories on the machine
* `~` is a shortcut for our "home directory". It will be in a place like
`/Users/<your-user-name>`
* `mkdir` stands for "make directory", and it allows us to create new folders on the machine

At this point, we want to enter the directory we have created, and then we will
create ourselves a directory for the first module. We call this new directory
1module, so we can use tab complete more easily.

```
cd turing
mkdir 1module
```

Now that this is complete, you can now get to your first module folder from
anywhere through the terminal by typing:

```
cd ~/turing/1module
```

__Try It:__ Move to your home directory using `cd ~`. Then use `cd` to navigate back
to your `1module` directory.


