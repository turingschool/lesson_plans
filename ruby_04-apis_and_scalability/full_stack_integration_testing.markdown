---
title: Full Stack Integration Testing
length: 45
tags: SoA, Services, Testing, Javascript
---

__Notes -- this file contains some notes for a high-level discussion
about integration testing in an SoA environment; currently no hands-on
components added but perhaps we could add something later__

### Discussion

- What is the difference between unit and integration tests?
- What does it mean to write integration tests for a rails app?
- How does this change when we move into an SoA environment?
- What benefits do we get from writing tests? Do these change at
different levels of testing abstraction?


In our SoA discussions thus far we have focused on the idea that the
principles of good O.O. software design can be applied at a higher level
of abstraction to applications in a service architecture.

It turns out that testing in an SoA environment follows many of the same
patterns of escalating abstraction. What were previously our "highest
level" tests (integration tests over a single application) now also
serve as "unit tests" for the functionality of that single component
within the larger infrastructure -- it's tests all the way down.

With this in mind, it's often necessary to add additional testing at an
even _higher_ level of abstraction -- integration tests across the whole
system.

### Context

- [Growing Object-Oriented Software Guided by Tests](http://www.growing-object-oriented-software.com/)
- Staging environments
- Netflix [chaos monkey](http://techblog.netflix.com/2012/07/chaos-monkey-released-into-wild.html)

### Practical techniques

- Test suites external to a single application (example from recent
  Denver.rb: https://github.com/arjunsharma/go_with_rspec)
- Increased regard for test suites as software in their own right
- Additional burdens of Infrastructure-level integration testing
  (deployment, server booting, setup/teardown)
- Tools -- many of the same tools we use for integration testing rails
app will work well (capybara, especially)
- UI testing -- one additional concern in full-stack integration testing
is our UIs, and especially the Javascript that runs them.
- "Headless" Browsers -- Poltergeist, Selenium, etc
