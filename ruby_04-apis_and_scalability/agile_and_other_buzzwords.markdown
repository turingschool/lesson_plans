# Agile and Other Buzzwords

## Quick and questionably useful backstory

Dr Winston Royce presented a paper in 1970 titled [Managing the Development of Large Software Systems](https://www.cs.umd.edu/class/spring2003/cmsc838p/Process/waterfall.pdf). The paper questioned the use of sequential or 'waterfall' development in the context of building software. Waterfall style of working would mean teams would have to work in sequential phases - like the team sits down and designs the entire app, then sits down and writes all the code.

Over the next 30 years, a number of methodologies cropped up advocating a more iterative workflow. Instead of trying to figure out the entire roadmap of a project in the first week of starting it, there was more emphasis on collaboration between architects, designers, business stakeholders and programmers throughout the entire development process.

During this period, manufacturing was running into similar, but different, problems. Japanese manufacturing companies, especially Toyota, started developing processes like "kanban" and "continual improvement". Software developers would start to borrow some of these concepts in the 90's.

The complete history of agile developement, and everything that inspired it, is long and messy. [This article has a pretty good summary of the important parts](https://hbr.org/2016/04/the-secret-history-of-agile-innovation).

## Agile & Scrum

In 2001, a group of developers got together and wrote the [Agile Manifesto](http://www.agilemanifesto.org/). This manifesto, and the subsequent Agile Alliance that formed collected many of the methodologies around iterative workflows and codified them in 'twelve principles'.

1. Our highest priority is to satisfy the customer through early and continuous delivery of valuable software.
1. Welcome changing requirements, even late in development. Agile processes harness change for the customer's competitive advantage.
1. Deliver working software frequently, from a couple of weeks to a couple of months, with a preference to the shorter timescale.
1. Business people and developers must work together daily throughout the project.
1. Build projects around motivated individuals. Give them the environment and support they need, and trust them to get the job done.
1. The most efficient and effective method of conveying information to and within a development team is face-to-face conversation.
1. Working software is the primary measure of progress.
1. Agile processes promote sustainable development. The sponsors, developers, and users should be able to maintain a constant pace indefinitely.
1. Continuous attention to technical excellence and good design enhances agility
1. Simplicity--the art of maximizing the amount of work not done--is essential.
1. The best architectures, requirements, and designs emerge from self-organizing teams.
1. At regular intervals, the team reflects on how to become more effective, then tunes and adjusts its behavior accordingly.

These principles have stuck around, and Agile has even developed its own frameworks - the most well known being [Scrum](https://www.scrumalliance.org/why-scrum). You will likely come across some version of Agile in place wherever you work in the software world.

## The Daily Scrum or Stand Up

The concept of a Stand Up is defined in the Scrum Framework as a meeting held daily, usually held in the same location at the same time and strictly time-boxed to last only 15 minutes.

Each team member answers the following questions:

1. What did you do yesterday?
1. What will you do today?
1. Are there any blockers in your way?

In a strict Scrum environment, there is a Scrum Master who runs the meeting and follows up on any blockers.

Daily stand ups are named as such because standing up has a number of benefits, including enforcing shorter meeting lengths and minimizing distractions.

## Work Flows for Submitting Code

Every company has its own set of rules around writing and submitting code. (This is a great thing to ask questions about in a job interview.) The workflow that software consultancy Thoughtbot uses is a pretty good one, in my opinion.

From the [Thoughtbot Playbook](https://playbook.thoughtbot.com/)
>
Code Reviews
>
- Create a local feature branch based off master.
- When feature is complete and tests pass, stage the changes.
- When you've staged the changes, commit them.
- Write a [good commit message](https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message).
- Share your branch.
- Submit a GitHub pull request.
- Ask for a code review in Slack.
- A team member other than the author reviews the pull request. They follow [Code Review guidelines](https://github.com/thoughtbot/guides/tree/master/code-review) to avoid miscommunication.
- They make comments and ask questions directly on lines of code in the GitHub web interface or in Slack.
When satisfied, they comment on the pull request "Ready to merge."
- Rebase interactively. Squash commits like "Fix whitespace" into one or a small number of valuable commit(s). Edit commit messages to reveal intent.
- View a list of new commits.
- View changed files.
- Merge branch into master.
- Delete your remote feature branch.
- Delete your local feature branch.
>
Test-Driven Development moves code failure earlier in the development process. It's better to have a failing test on your development machine than in production. It also allows you to have tighter feedback cycles.
>
> Code reviews that happen right before code goes into master offer similar benefits:
>
- The whole team learns about new code as it is written.
- Mistakes are caught earlier.
- Coding standards are more likely to be established, discussed, and followed.
- Feedback from this style of code review is far more likely to be applied.
- No one forgets context ("Why did we write this?") since it's fresh in the author's mind.

## Project Planning

Given that software development is unpredictable, planning out a project can be difficult. There are as many different styles of 'project kickoff' as there are software companies.

One of the more intense (and often copied) techniques is Google Venture's [Product Design Sprint](http://www.gv.com/sprint/). The five day process looks like this:

###### Monday: Unpack the problem
###### Tuesday: Sketch competing solutions on paper
###### Wednesday: Argue and decide how to turn your ideas into a testable hypothesis
###### Thursday: Hammer out a high-fidelity prototype
###### Friday: Test it with real live humans.

You can see how Thoughtbot uses the Product Design Sprint method [here](https://robots.thoughtbot.com/the-product-design-sprint)

Notice that this is an entire week that doesn't have 'start coding the actual product' in it anywhere. Not every project gets this level of attention, and our [Looking For](https://github.com/turingschool/lesson_plans/blob/master/ruby_04-apis_and_scalability/looking_for_project.markdown) application won't either - but we do need to answer the following question:

1. Define the customer
1. Define the problem we are trying to solve
1. Define the value proposition (no one will be paying us, but why should we spend our valuable time)
1. Define context-specific terms (this will act as a dictionary).
1. Discuss long term and short term goals

Once we define these things, we, as a software team need to plan out our next iteration of work.

1. What functionality or features do we need to have a basic product?
1. What work can we clearly define and get started on?
1. What is our 'first iteration' of work?
