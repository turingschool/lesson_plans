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


## Key Terms & Concepts

* OAuth
* Brokering trust
* User, Consumer, and Provider
* Token
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
