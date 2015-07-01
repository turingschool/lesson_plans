---
title: Deploying with Docker
length: 180
tags: devops, server, linux, deployment, production, docker
status: Super WIP
---

# Deploying Ruby Applications with Docker

## Intro / Discussion - What is Docker?

* What is heroku doing when we ship our code to it?
* How does heroku prevent our application from negatively
  impacting another user's application (or vice versa)?
* What are the limitations we face when deploying on heroku?

## Virtual Private Servers -- Running Your Own Server in the Cloud

* SSH
* Linux
* Managing Processes / Users

## "Containerization" -- Advantages of Repeatability and Isolation

## Docker Basics -- Dockerfile, Containers, Boot2Docker

## Workshop 1 -- Running a Docker Instance on our Mac

### Step 1 -- Install Boot2Docker VM

Docker targets linux operating systems only, so in order to run it
on our OSX macs, we will need a linux environment handy. Fortunately
the docker team gives us an easy way to accomplish this with the
"Boot2Docker" project.

In a nutshell, boot2docker runs a small VM on our machine which will
serve as a container for our docker packages.

1. Download and run the latest installer from [the releases page](https://github.com/boot2docker/osx-installer/releases).
2. Run configuration script with `boot2docker init`
3. Boot the VM with `boot2docker up`


After the VM boots, it will prompt you to add some configuration variables.
they will look something like:

```
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/mary/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
```

Add those lines to your shell profile (usually `~/.bash_profile`) and reload
it with `source ~/.bash_profile`.

Finally, verify your environment with `boot2docker status`. It should output `running`.

### Step 2 -- Setting Up Our App

Now that we have some dependencies, let's see if we can run an actual app. We'll
use the Blogger application since it's a straightforward but reasonably complicated
Rails app.

Start with a freshly cloned/setup app using the `postgres` branch of blogger, which
is configured to use postgresql as its db:

```
git clone https://github.com/JumpstartLab/blogger_advanced.git blogger-docker
cd blogger-docker
git checkout --track -b postgres origin/postgres
bundle
rake db:setup
```

### Step 3 -- Adding a DockerFile

Next, we need to add a basic `Dockerfile` for our application. The Dockerfile
will tell docker what steps to use to setup the "container" in which our app
will run.

create a file called `Dockerfile` in the app directory, and add this to it:

```
FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /blogger
WORKDIR /blogger
ADD Gemfile /blogger/Gemfile
RUN bundle install
ADD . /blogger
```

### Step 4 -- Adding Additional Services With docker-compose

The Dockerfile we set up in the previous step would get us what we need
in order to just run the ruby portion of our application. But it doesn't
solve the question of dependencies -- specifically our dependency on
Postgres as a database.

For this, we'll use a tool called docker-compose to add a second independent
container running a postgres instance.

Part of the philosophy of docker is to divide our production infrastructure
into independent containers which are isolated from one another.

This is feasible since the containers themselves have much lower overhead than,
say, running another OS VM. Thus, we can afford
to divde our app into a lot of small containers, which is what docker-compose
will help us do.

docker-compose.yml

## Workshop 2 -- Deploying our Docker Image to a Digital Ocean VPS

### Possible Errors

Here's a list of common exceptions you may encounter and ways to fix them.

#### Boot2Docker Cert Issues

After installing and booting your local boot2docker instance, you may get errors
when running any docker commands:

```
An error occurred trying to connect: Get https://192.168.59.103:2376/v1.19/containers/json: x509: certificate is valid for 127.0.0.1, 10.0.2.15, not 192.168.59.103
```

1. Verify you have set up the required env variables requested by `boot2docker shellinit`
2. Try destroying and re-creating the boot2docker instance: `boot2docker delete && boot2docker init && boot2docker up`


## Notes

This is a super WIP. I started working on it during intermission thinking we would
use it for future VPS lessons, but we are going to shelve VPS again for the time
being so I have not devoted the time to finishing it. Leaving the notes here in case we decide to use them
in future.
