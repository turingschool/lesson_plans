---
title: Handling File Uploads
length: 90
tags: files, carrierwave, paperclip, rails
status: draft
---

## Learning Goals

* Understand how file data is sent through an HTML form
* Understand how and why applications store file metadata in the database
* Build experience with both CarrierWave and PaperClip libraries

## Structure

* 5 - Warmup
* 20 - Lecture: HTTP, Files, and Databases
* 5 - Break
* 25 - Dig In: Using CarrierWave
* 5 - Break
* 20 - Dig In: Using PaperClip
* 5 - Questions & Recap

## Warmup

Answer the following questions to get started thinking about file uploads:

```
1. When you submit a file to upload, how does that data get to the server?
2. Why do you think Heroku doesn't allow file uploads?
3. Both CarrierWave and Paperclip nest the files uploaded into folders, one file
per folder. Why would they do that?
4. Why do both libraries need database migrations to add columns to the database?
5. Have you used CarrierWave, Paperclip, or both? If both, do you have a preference?
```

## Lecture: HTTP, Files, and Databases

We'll start with a full-group lecture/discussion:

* How HTTP Multipart works
* Heroku and the Write-Only File System
* Sending Files to S3
* The Problem with Filenames
* File Metadata in the Database
* History of Paperclip & Carrierwave

## Dig In: CarrierWave

* Clone the Storedom application at https://github.com/turingschool-examples/storedom
* Add functionality (controller actions, form) to allow adding an Item through the web interface
* Make a Git commit, then start a feature branch named `carrierwave`
* Now add CarrierWave to the application: https://github.com/carrierwaveuploader/carrierwave
* Add an image upload to the Item creation
* Make sure it works correctly!
* Commit your changes to the feature branch

## Dig In: Paperclip

Let's add a totally separate file upload to the same Storedom app.

* Checkout the `master` branch then checkout a branch named `paperclip`
* Implement [Paperclip](https://github.com/thoughtbot/paperclip) to handle the
same file uploads
* Make sure it works
* Commit your Changes

## Bonus

If you have extra time, experiment with the built in image cropping, resizing,
and resampling tools from each library. You'll need to have imagemagick and rmagick
installed. Installing them can be tricky, but hopefully this will work:

```
$ brew update
$ brew install imagemagick
$ gem install rmagick
```

Then add `rmagick` to the `Gemfile`, bundle, and configure it following the
directions of the attachment library.

## Corrections & Improvements for Next Time
