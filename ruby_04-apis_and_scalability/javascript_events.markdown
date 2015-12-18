---
title: Events in Javascript
length: 180
tags: javascript, browser, events, jquery, UI
---

## Events in Javascript

### Big Picture Discussion -- Event Systems as a UI Paradigm

* User Interface "Events" -- why do we care?
* Event-driven programming model
* Event systems as a UI paradigm -- browser, cocoa, android

__Ingredients of an Event System__

So we've agreed that an event-based system is a great fit for UI
programming (it's a great fit for a lot of other models as well).

What goes into a good event system? There are a few key things
we'll want to _know_:

* What _type_ of event happened?
* What thing in the UI was the event targeting?

Think about your experience with JQuery: What are some of the event
types you've encountered thus far? Given what you know about browser
interactions, what are some others that might exist?

Assuming we have all these events occurring in the browser, what things
would we need to be able to do in order to do something useful with
them?

* _Listening_ for events to occur
* _Binding_ some behavior (i.e. __function__) to happen whenever
the event does occur

Now that we have a sense of some of the topics involved, let's look
at some more hands-on applications using JQuery.

As we go, follow along with this [tutorial](https://github.com/mdn/advanced-js-fundamentals-ck/tree/gh-pages/tutorials/04-events).
