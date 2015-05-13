# Getting Set Up with io.js and Ember

There are many ways to get set up with Node and Ember. This is the way we're recommending at this moment. We're going to work under the assumption that you're using `bash` or `zsh`. If you're using the `fish` shell, [you'll need to muck around with some additional configuration][fish].

[fish]: https://github.com/passcod/nvm-fish-wrapper
[nvm]: https://github.com/creationix/nvm

**Step One**: Install `nvm` using the following command.

```bash
curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash
```

**Step Two**: Install Node—er, we're going to use [io.js][io] instead.

[io]: https://iojs.org/en/index.html

```bash
nvm install iojs
nvm use iojs
```

Alright, cool. Now, listen carefully—we're going to use a different command from this point forward: `npm`, not `nvm`.

Because life is hard, we're going to use a package manager called `npm` to install a different package manager called `bower`. Very few people think this is okay, but it's the way the world works at this moment in time.

```bash
npm install -g bower
```

If you forget the `-g` flag, things are not going to work for you. Why don't you hit the up array right now and make sure you included the `-g`. Got it? Cool.

Okay, we need one more global command. I'm going to let you guess what it installs.

```bash
npm install -g ember-cli
```

Ember CLI is a collection of tools to make working on Ember projects easier. It's a lot like the `rails` command. It's not Ember per se, but it will let you create a new Ember project.

Alright. So, we *should* be good to go at this point. Let's test it and make sure everything works.

```bash
ember new wowowow
```

If all is well, this should look familiar to you Ember CLI will create some folders and install some dependencies on your behalf. You're new project should be in the `wowowow` directory. `cd` in and give it a whirl with `ember server`. Your server should be working on port 4200.

Great.

### The Ember Inspector

We're not done just yet. I mean, we could be, but let's install the [Ember Inspector][insp] as well. Chrome has the best support for the Inspector, but I'll let you choose your own path.

* [Chrome Web Store](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi?hl=en)
* [Firefox Add-on](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/) (This is typically a bit out of date so you may want to consider [building it yourself][ff].)

[insp]: https://github.com/emberjs/ember-inspector
[ff]: https://github.com/emberjs/ember-inspector#firefox\

If you're using Safari or—*gasps*—Internet Explorer, you can use this bookmarklet:

```js
javascript: (function() { var s = document.createElement('script'); s.src = '//ember-extension.s3.amazonaws.com/dist_bookmarklet/load_inspector.js'; document.body.appendChild(s); }());
```
