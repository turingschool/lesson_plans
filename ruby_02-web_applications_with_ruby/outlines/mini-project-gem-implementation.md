---
title: MiniProject Extension Implementation

tags: gem, pagination, rails tools, rails, mailer, bootstrap, code climate, continuous integration, hound
---



### Goals

* Increase comfort reading new documentation and problem solving
* Learn a new gem
* Practice refactoring and reviewing code


#### Intro:

  Today's goal is to practice implementing new gems into our projects, and become more confident reading documentation and solving problems/bugs.

  This lesson will be broken into two major parts. The first part of today's workshop will be practicing reading, comprehending and reviewing code. The second part of today's lesson will be taking on challenge. The challenge will be implementing and familiarizing yourself with new gems.



### Part 1: Read, Comprehend, Review

Reading more and more code allows you to practice comprehending things faster. The more you read code, particularly code you did not write, the better you will be at understanding code. Today we are going to practice reading code that others wrote, and reviewing that code. There are many good blog posts about what to look for when reviewing code, and other techniques and tactics to help.

We are going to spend ~25 minutes on each persons code reviewing and refactoring things along the way. The goal for this session should be to better familiarize yourself with the new codebase and to practice reviewing code.

One blog post I like about reviewing code is [Kevin London's post: Code Review Best Practices](https://www.kevinlondon.com/2015/05/05/code-review-best-practices.html). Kevin lays our a nice and solid base for things to do and look for in code review sessions. Some particular things he points out that I would like you to keep in mind for this session are:

### Technical:

* __Single Responsibility Principle__: The idea that a class should have one-and-only-one responsibility. Harder than one might expect. I usually apply this to methods too. If we have to use “and” to finish describing what a method is capable of doing, it might be at the wrong level of abstraction.

* __Code duplication__: I go by the “three strikes” rule. If code is copied once, it’s usually okay although I don’t like it. If it’s copied again, it should be refactored so that the common functionality is split out.

* __Method names__: Naming things is one of the hard problems in computer science. If a method is named get_message_queue_name and it is actually doing something completely different like sanitizing HTML from the input, then that’s an inaccurate method name. And probably a misleading function.

* __Variable names__: foo or bar are probably not useful names for data structures. e is similarly not useful when compared to exception. Be as verbose as you need (depending on the language). Expressive variable names make it easier to understand code when we have to revisit it later.

* __Test coverage__: I like to see tests for new features. Are the tests thoughtful? Do they cover the failure conditions? Are they easy to read? How fragile are they? How big are the tests? Are they slow?

* __Testing at the right level__: When I review tests I’m also making sure that we’re testing them at the right level. In other words, are we as low a level as we need to be to check the expected functionality?


### Soft Skill:

#### How to handle code reviews:
From Kevin London's Blog Post: Code Review best Practices-


I find that the human parts of the code review offer as many challenges as reviewing the code. I’m still learning how to handle this part too. Here are some approaches that have worked for me when discussing code:

* __Ask questions__: How does this method work? If this requirement changes, what else would have to change? How could we make this more maintainable?

* __Compliment / reinforce good practices__: One of the most important parts of the code review is to reward developers for growth and effort. Few things feel better than getting praise from a peer. I try to offer as many positive comments as possible.

* __Discuss in person for more detailed points__: On occasion, a recommended architectural change might be large enough that it’s easier to discuss it in person rather than in the comments. Similarly, if I’m discussing a point and it goes back and forth, I’ll often pick it up in person and finish out the discussion.

* __Explain reasoning__: I find it’s best both to ask if there’s a better alternative and justify why I think it’s worth fixing. Sometimes it can feel like the changes suggested can seem nit-picky without context or explanation.

* __Make it about the code__: It’s easy to take notes from code reviews personally, especially if we take pride in our work. It’s best, I find, to make discussions about the code than about the developer. It lowers resistance and it’s not about the developer anyway, it’s about improving the quality of the code.

* __Suggest importance of fixes__: I tend to offer many suggestions, not all of which need to be acted upon. Clarifying if an item is important to fix before it can be considered done is useful both for the reviewer and the reviewee. It makes the results of a review clear and actionable.


### Part 2: Discovering new Gems

When trying to implement a new tool/gem into your app, your approach to the situation should be methodical. The first things to do when trying to implement a new Gem or tool is to read about it. Read the documentation thoroughly. The documentation should be your first stop in trying to learn about a gem. Sometimes a gems documentation is lacking and then we may want to move onto other resources such as stackoverflow to learn more.

I suggest reading the documentation before you do anything else. Read about installation, configuration, implementation. Once you've read through it all and have a very rough, general understanding of things. Start again and start putting the gem into your project.

Head over [here - to a list of gems and other resources](https://github.com/turingschool/resources/blob/master/rails_gems_and_other_resources.markdown) and pick a gem that sounds interesting and or useful to your app.

* Each pair should pick a different gem and spend the first 5-10 minutes reading the documentation and familiarizing themselves with the gem.

* Once you make it through some of the documentation and feel like you can summarize it to your pair please briefly summarize what you understand to your pair.

* Now, flip a coin, rock-paper-scissors, pair.sample, or do whatever it is you want to do to do to pick who goes first, but together I want you to pair on implementing the gem into your project. You should have at least 45 minutes per pair, so please keep an eye on the time and make sure you allot enough time per project.

* Please note: Some of these gems may require a bit of extra work to see them working correctly. For example, if you're implementing a paginator, you may want to create a hundred rows of seed data so you can see it all paginated. Or if you're implementing HoundCI you will need to submit a pull request to see Hound do it's thing.

If you make it through both partners gems and you still have time - take the opportunity to learn even more helpful tools and start implementing another gem from the list.
