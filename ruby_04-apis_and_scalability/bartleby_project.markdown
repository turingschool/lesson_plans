# Bartleby

## The Project

Bartleby is a note-taking application inspired by the [Notes][] application on OS X as well as [Notational Velocity][nv] and its child, [nvALT][].

[Notes]: https://www.apple.com/osx/apps/?cid=wwa-us-kwg-mac#notes
[nv]: http://notational.net/
[nvALT]: http://brettterpstra.com/projects/nvalt/

Ideally, we'd like the application to do the following:

- Have a sidebar with a list of all of the notes in a given directory.
- Allow the user to edit a specific note.
- Allow the user to save the changes of that note to the filesystem.
- Preview Markdown as HTML.
- Word and character counts that live update as you edit each note.

We'll also try to add a subset of the following features:

- Let the user filter the list of files by their content.
- Allow pull in the title and URL of the active tab in their favorite browser.
- Allow the user to publish the current markdown file as gist on Github.
- Allow the user to export a Markdown file as HTML.

### A Word of Caution

Not only is this a brand new project, but we're going to do something that hasn't really been done too many times in the past. We'll be wading through plenty of uncharted waters and have to figure out a lot of the solutions on our own. The hope is that you'll have the foundation of something worth talking about at the end of the project, but the main goal is to learn a ton.

### Pre-Work

You'll be expected to have reviewed the following materials by Monday.

1. [Building Desktop Applications with Node and Electron](https://www.youtube.com/watch?v=rbSvc8_BHaw)
1. [Getting Started with Electron](https://vimeo.com/155240396)
1. [Building Real-Time Applications with Ember](https://www.youtube.com/watch?v=nfGORL8ebn8) (We probably won't have any real-time features, but Electron's main process will broadcast events.)

## Requirements

Since this is [terra incognita][], a big part of the project will be documenting our travels. One of the goals of this project is strengthen your portfolio and there is no better way to do that than to showcase your expertise in an area that not may other people know about. In addition to programming, you'll be writing a blog post. The post will consist of a few components:

1. An introduction to what both Ember and Electron are and how they work at a high level
1. Some of the philosophies behind Ember and Electron and why you do or do not believe a good choice for this project
1. A particular technical problem that you encounter and how you solved it (or your efforts to solve it, if you didn't end up solving it)
1. A post-mortum on what went well and what you would improve upon if you were to continue working on this project or if you started over

Each section is worth 15 points for a total of 60 points.

**Important Note**: It's easy to complain how stuff is hard in a blog post. Not only is that not particularly helpful to anyone who reads your post, it turns out that most open source software is created by humans and humans have a tendency to feel really bad when you complain about their donated efforts.

[terra incognita]: http://www.merriam-webster.com/dictionary/terra%20incognita

---------

## Rubric

### Blog Post (60 Points - 15 points per section)

### Participation (30 points)
  * 30: Developer participated daily in courses and stand ups with the group. Developer worked on multiple features or one feature that instructor feels is exceptionally difficult.
  * 20: Developer was absent for 1 lesson, did not participate actively in lessons and peer reviews. Developer worked on one or two 'easier' features.
  * 0: Developer was absent for > 1 lesson, did not participate actively in lessons and peer reviews. Did not deliver or almost deliver any features.

### Risk Taking and Creativity (60 points)

Instructor/Developer will select one feature in the project to review for this section of the rubric.

  * 60: Developers pushed themselves and their team by taking risks which is demonstrated by a delivered feature. Developers explored concepts and technologies outside the scope of the curriculum.
  * 50: Developers pushed themselves and their team by taking risks which is demonstrated by an almost delivered feature. Developers explored concepts and technologies outside the scope of the curriculum.
  * 30: Developers attempted to implement extensions using technologies not covered in class but it did not result in a delivered feature.
  * 10: Developers but did not build any features.

#### Extension (20 points)

  * Developer contributes to or creates an NPM module/library.
