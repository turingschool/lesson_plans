---
title: Getting Started with OAuth
length: 90
tags: rails, security, authentication, OAuth
---

## Warmup

Begin by answering the following questions:

1. Why do we use passwords?
2. What does it mean to say we then *trust* the service provider?
3. Why does having more and more systems with logins make the average person
*less* secure?
4. How does OAuth help?
5. Why is OAuth advantageous for a startup business?

## Tutorial: Getting Started With OAuth

Authentication is a ubiquitous problem in web applications. So
ubiquitous, in fact, that we might be inclined to think of ways
to "outsource" the problem of authentication to an external provider.

Solving these problems is one of the major focuses of OAuth. Using OAuth,
we can allow users to authenticate with our app via a 3rd-party service
provider (often a large online or social media service).

In this tutorial, we'll discuss the ideas behind OAuth, and walk
through an example of implementing it in a project.

### Benefits of OAuth

There are a lot of potential advantages to outsourcing our Authentication
via Oauth.

__Removing Security Complexities__

Authentication is a tricky problem with a high cost of failure. It can often be tedious
to re-implement on one application after another, but any small mistake
can still have dire consequences.

With OAuth, the user never has to provide sensitive credentials to our application.
Instead, they send these details to the OAuth provider (e.g. Google), who sends
us an authentication token and some basic details on the user's behalf.

Since the provider stores the user's actual credentials, we no longer have to worry about the
security considerations of storing and encrypting user passwords.

__Service Authorization / Authentication__

ANother benefit of having users authenticate with OAuth is that it gives us
authenticated access (on their behalf) to any APIs available from the OAuth
provider. API Providers frequently limit your access to their platform, and
having a user authenticate with the provider can get you access to more
resources or to an additional volume of requests.

This can be a big help with API rate limiting, for example, since each authenticated user will usually
be allowed their own supply of requests.

### Disadvantages of OAuth

Like everything in technology, using OAuth isn't without tradeoffs. Often the benefits
outweigh the costs, but let's look at a few things to be aware of.

__Loss of Control__

With OAuth, we're no longer entirely in control of the user's login process. We
might like to collect additional information in the signup process that the
3rd party doesn't provide to us, or design our own onboarding flow, but with OAuth
we'll be locked into whatever our provider makes available.

__Account Requirement__

This one may seem obvious, but if we're using OAuth with twitter, then our users
will be required to have a twitter account in order to use the app. Many services
are so ubiquitous these days that this may not be a large disadvantage, but it is
something to be aware of.

Particularly, we may want to consider our target userbase when determining which
OAuth provider to rely on. If your app is a hip social network for tweens, requiring
users to log in with LinkedIn may not be the best choice.

__Data Duplication__

One challenge OAuth imposes on our application design is deciding how much data
to copy from the external service and where to store it. Do we duplicate the user's
basic profile info into a table in our own DB? Or just read it from the API whenever
we need it? These types of dilemmas are very common when dealing with remote data, and
OAuth data is no exception.


## Key Terms & Concepts

* Brokering trust
* (Encryption) Key & Secret

## Discussion Plan

1. Discuss OAuth at a high level including issues of trust, passwords, and
users' security considerations
2. Discuss why/how OAuth came about and how to recognize it
3. Walk through the OAuth flow
4. Outline the necessary steps to be an OAuth consumer
5. Discuss what it'd look like to be an OAuth provider
6. Take a quick look at OmniAuth

## Resources

* [OAuth](http://en.wikipedia.org/wiki/OAuth) on Wikipedia
* [Understanding OAuth](http://lifehacker.com/5918086/understanding-oauth-what-happens-when-you-log-into-a-site-with-google-twitter-or-facebook) on LifeHacker
* [OmniAuth](https://github.com/intridea/omniauth) for integration in Ruby web apps
* [Oauth 1.0 Diagram (from MashApe's oauth bible)](http://puu.sh/2pJ4y)
* [Oauth Bible](http://oauthbible.com/) - lots of in-depth info about different oauth versions and components
* [Edge Cases Podcast #36](http://edgecasesshow.com/036-zenos-paradox-of-authentication.html) - Good in-depth discussion of the evolution of Oauth and the pros and cons of using it.
* [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) -- Oauth provider gem
