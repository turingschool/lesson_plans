---
title: Building a VPS
length: 180
tags: devops, vps
status: draft
---

## Discussion

* Overview of servers -- dedicated, metal, VPS
* Walk through what a VPS is and isn't
* Key concepts of UNIX: ssh, users, groups, ownership, path, sudo
* Review the steps to setting up a server

### Key Components for a Rails Server

* Linux
* Ruby
* PostgreSQL
* Rails and supporting gems
* NGINX with Passenger

## Tutorial

### First Login

You should get an email with the root credentials for your server. You can login by:

* opening your terminal
* running `ssh root@youripaddress`
* enter the password from the email
* you're in!

### Creating a New User

Doing everything as `root` is a bad idea. With great power comes great responsibility. Power is great, but that's a little too much responsibility. Let's create a user that can access that power when it needs to, but acts like a regular user the rest of the time.

I've named this user `deploy`, but you can name it anything you'd like.

```sh
# Make a new user
sudo adduser deploy

# The server is going to ask you a bunch of questions. Just hit enter to each.

# Give that user administrative privileges
sudo adduser deploy sudo

# Switch to your new user
su deploy
```

We are no longer `root`. We're now logged in as `deploy`.

We can connect to our server as the `deploy` user. Right now, we're back to using a password. Let's install our SSH keys for our new user so we can avoid entering a password.

You can find the public key you use for GitHub at `http://github.com/yourusername.keys`
or on your file system it's typically in `~/.ssh/id_rsa.pub`.

Once you have your key you need to add it to `authorized_keys` file on your server:

```sh
cd ~
mkdir .ssh
nano .ssh/authorized_keys
# Paste in your public key and exit with ctrl-q
```

If done correctly, you should now be able to log out of the vps (by running `exit` at the command line) and log in again without being prompted for your password.

### Using a Package Manager to Install Basic Packages

A Package Manager is a piece of software that automates the process of discovering and installing other software packages. Without a package manager, we would have to search out the individual installation instructions for eache piece of software we'd like to install, often having to manually build them from source as well.

Working on our own machines, we've frequently used Homebrew in this capacity. On Linux, the most popular package manager is called `apt-get`. We'll be using it throughout this tutorial.

First, let's update our package repository and then we'll install some of the necessary packages to get rocking and rolling with downloading the rest of our setup.

```
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
```

### Setting Up Git

Okay, so now we have `git`. Let's configure it.

```
git config --global user.name "Your Name"
git config --global user.email your-email@address.com
```

### Installing Ruby

```sh
# Download RVM
curl -L https://get.rvm.io | bash -s stable

# Load RVM into your current environment
source ~/.rvm/scripts/rvm

# Load RVM into your future environments
echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc

# Install the latest version of Ruby
rvm install 2.1.3

# Switch to your new Ruby and set it as the default
rvm use 2.1.3 --default

# Make sure you have the version of Ruby you think you do
ruby -v
```

We probably don't need to download documentation for each gem on our server, so let's turn that off now.

```
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
```

### Hello World

At this point, we could fire up a Rails server and access it over the Internet.

Let's install Rails with `gem install rails` and then create a new Rails project with `rails new <application-name>`.

If we try to run our application, we'll actually get an error. We need to have a JavaScript runtime installed alongside our application. Use a text editor to add the following to your `Gemfile` (like `vim Gemfile` or `nano Gemfile`):

```rb
gem 'execjs'
gem 'therubyracer'
```

Run `bundle install` and you should be ready to run `rails s` to start up your server. If that was successful, then head over to your IP address and port 3000 and you should see the default Rails starting page. Congratulations, your Rails application is on the Internet.

### Installing PostgreSQL

First, we'll install PostgreSQL.

```sh
sudo apt-get install postgresql postgresql-contrib libpq-dev
```

Installing PostgreSQL created a new user on our machine—conveniently named `postgres`. Let's switch over to that user real quick.

```sh
sudo su - postgres
psql
```

Those commands switched us to the `postgres` user on our server and then dropped us into the PostgreSQL prompt (psql). Now that we're the `postgres` user, let's create a user in PostgreSQL (how meta).

First, set a password for the database using `\password`.

```sh
create role deployment with createdb login password 'password1';
```

Hit <kbd>Control-D</kbd> to exit.

The third argument is the username for my PostgreSQL user. The last argument is a terrible, terrible password.

Type `exit` and you'll be dropped out of the `postgres` user and back into `deploy`.

Let's go make sure this actually works. To check, we'll pop back into that Rails application we made a few minutes ago and edit the `database.yml` to look something like this:

```yml
development:
  adapter: postgresql
  encoding: unicode
  database: myapp_development
  host: localhost
  pool: 5
  username: deployment
  password: password1

test:
  adapter: postgresql
  encoding: unicode
  database: myapp_test
  host: localhost
  pool: 5
  username: deployment
  password: password1

production:
  adapter: postgresql
  encoding: unicode
  database: myapp
  host: localhost
  pool: 5
  username: deployment
  password: password1
```

Also, don't forget to add `gem 'pg'` to your Gemfile.

You'll probably want to change `myapp` to the name of your application.

We're only testing things out, so let's rely on our old friend, the scaffold generator.

```sh
rails g scaffold Article title:string body:text
rake db:create db:migrate
```

Fire up the Rails server and try it out. It's now hooked up to the database.

### Putting the Web in Our Webserver

So, we have a server, but it's not really a web server yet. Let's put the _web_ in our web server.

Ideally, we'd like to be sure we're not installing something horrible on our brand new servers, so we're going to grab some key's to confirm we're getting the software we think we are.

```sh
# Install Phusion's PGP key to verify packages
gpg --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
gpg --armor --export 561F9B9CAC40B2F7 | sudo apt-key add -
```

We also want the ability to install Ubuntu packages over HTTP.

```sh
# Add HTTPS support to APT
sudo apt-get install apt-transport-https
```

Now, let's download Passenger.

```sh
# Add the passenger repository
sudo sh -c "echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' >> /etc/apt/sources.list.d/passenger.list"
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get update

# Install nginx and passenger
sudo apt-get install nginx-full passenger
```

Right on. Now let's fire up this server.

```sh
sudo service nginx start
```

We have Nginx installed and running, but it needs to know a little bit about our Ruby setup before we can move forward.

So, let's go do that.

But first, let's make sure we know where our installation of Ruby is hiding.

```sh
which ruby
```

For you Vim, enthusiasts out there:

```
sudo vim /etc/nginx/nginx.conf
```

For those of you allergic to Vim, you can use nano:

```sh
sudo nano /etc/nginx/nginx.conf
```

We're looking for the settings for Phusion Passenger. If you're using Vim, you can skip down to the settings by typing `/Phusion`. We want to uncomment the line with `passenger_root` to enable Passenger. We also want to use the Ruby we installed with RVM as the `passenger_ruby`. When all is said and done, that section should look something like this:

```sh
##
# Phusion Passenger config
##
# Uncomment it if you installed passenger or passenger-enterprise
##

passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
passenger_ruby /home/deploy/.rvm/wrappers/ruby-2.1.3/ruby;
```

Let's restart our server.

```sh
sudo service nginx restart
```

Let's configure Nginx to know about our new Rails application.

Using either `vim` or `nano`, edit `/etc/nginx/sites-enabled/default` with `sudo`.

```sh
sudo vim /etc/nginx/sites-enabled/default
```

Replace `example-app` with the name of your application. Notice that we link to the `public` folder in our Rails application.

```
server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;

        server_name mydomain.com;
        passenger_enabled on;
        rails_env    production;
        root         /home/deploy/example-app/public;

        # redirect server error pages to the static page /50x.html
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
}
```

We're almost ready to go. Let's setup our production database.

```sh
rake db:create db:migrate RAILS_ENV="production"
```

We also need to set a production secret in `config/secrets.yml`. For our little "Hello World" application, we'll just replace `<%= ENV["SECRET_KEY_BASE"] %>` with a static value. Generally, you want to keep secret keys out of version control and store them in the environment.

You can read more about setting environment variables in Phusion Passenger [here](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#env_vars_passenger_apps).

## Addenda

### Restarting your application

When you deploy or otherwise need to restart your app, you can do so by touching a file called `tmp/restart.txt` from the application's root directory. Passenger (the app server) watches for this file to update, and whenver it does, reboots the app. (Note: if your app doesn't have a `tmp` directory on production you will need to make it.) EG:

```
cd ~/path/to/my/app
touch tmp/restart.txt
```

### An Aside: Making Logging into Your Server Easier

Trying to remember your server's IP address. I always forget to prefix the IP address with the username. You can actually make this a lot easier on yourself by setting up a shortcut on your local machine.

From your home directory:

```sh
vim .ssh/config
```

Add the following to the buffer:

```sh
host ocean
    hostname <Server IP Address>
    port 22
    user deploy
```

Now you can connect with `ssh ocean` and it will just work.

### Disabling the Root User

(Talk about how disable the root user.)

### Setting Up and Installing an SSH Key

SSH keys allow us to log in to remote servers without having to use a password. You use an SSH key when you push to Github (usually).

The way it works is that you create a private key on your machine. From that private key, you generate a public key. You can hand out your public key—umm, publicly. Only your private key can generate that public key. When you connect to a server, your private key shows that it can generate one of the public keys on file and—if that's successful—you're allowed to log in.

We can create a new public key, or we can just use the one you have on file at Github. To view your public key, go to your Github profile and add `.keys` to the end of it. Let's say—hypothetically—that your username is `stevekinney`. You could go to `http://github.com/stevekinney.keys` to retrieve the public key that Github has on file for you.

You can now go to your Digital Ocean profile and add your public key.

If for some reason, you opted not to use an SSH you'll receive an email with the IP address and the password for the `root` user. Otherwise, you're ready to log in to your server.

`root` is the master user and can do pretty much anything on the system.

Let's log in as `root`:

```sh
ssh root@<your-digital-ocean-ip-address>
```

If all went well, you should now be logged into your brand new server on the Internet.

### Hackpad from the Past

During a previous class we put together these notes: https://hackpad.com/Provisioning-a-VPS-RgXRnvmZJcO
