---
title: Auditing and Improving the Security of Rails Applications
length: 90
tags: security, brakeman
status: draft
---

## Learning Goals

* Understand how to use Brakeman to scan for common vulnerabilities
* Get some experience attempting common exploits on an app
* Practice reviewing another codebase for common security flaws.

## Structure

* 10 - match up with pair and install brakeman; get one-another's
  projects running on each machine, or just switch computers
* 15 - First partner attempts to exploit code of second partner.
* 5 - Break
* 15 - Second partner gets to exploit code of first partner.
* 10 - Begin code review 1
* Break
* 5 - Finish code review 1
* 15 - Code review 2
* 5 - Wrapup

### Part 1: Installing and Running Brakeman

Brakeman is a static analysis tool for detecting common security vulnerabilities.
(http://en.wikipedia.org/wiki/Static_program_analysis)[http://en.wikipedia.org/wiki/Static_program_analysis]
It installs as a normal gem:

```
gem "brakeman", :require => false
```

And then you can run the analysis task from the root of your project
with the command: `brakeman`

It's generally useful to save the output to an html file so that we can
read it more easily. We can do this with the `-o` option:

```
brakeman -o scan_output.html
open scan_output.html
```

Get with your pair and:

* Add brakeman to your projects
* Run the reports against each project

### Part 2: Hacker Time

Take 15 minutes each to attempt to exploit
security flaws in your partner's app. You can use the source
code or the output of a brakeman scan to get ideas for attacks to try.

Common things to look for include:

* Un-scoped/Unprotected actions (#edit is protected but #update is not)
* Strong params weaknesses (An endpoint openly accepts nested params)
* Weak ownership checks (A user can view other user's orders or update
  another user's data)

### Part 3: Code Review

Now that you've run brakeman and had some time to attempt to exploit
your partner's app, take turns doing a code review on each other's
projects, focusing on possible security flaws.

Actual vulnerabilities should obviously receive the most attention,
but don't forget to look for possible improvements to existing
security code as well.


### Wrapup

Let's close with a few minutes of discussion.

* What sort of issues did brakeman commonly report?
* What issues if any were you able to exploit in your partner's app?
* What patterns did you find to help you protect yourself against these
  issues?
