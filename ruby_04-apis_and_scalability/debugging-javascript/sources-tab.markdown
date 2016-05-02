# Using the Sources Tab

![console](../assets/debug-sources.png)

The sources tab allows you to see source files for a website and set breakpoints in your javascript code.

If the javascript files in the sources tab look all crammed together - you can use the dev tools to [prettify the obfuscated](https://developers.google.com/web/tools/chrome-devtools/debug/readability/pretty-print?hl=en) javascript files.

## Pausing RunTime

![using the sources](http://g.recordit.co/W9zWeVG5aq.gif)

As the demo above shows, you can set breakpoints from the browser by clicking the line number next to the code from the sources tab. 

You can also use the command `debugger` anywhere in your client-side code to trigger a breakpoint when the debugger is hit.

Breakpoints cause the code to stop in place, which allows you see and play around with the code in the exact state where the breakpoint was hit.

## Pause on Caught Exceptions

Another excellent trick is using Pause on Caught Exceptions.

![howitlooks](http://i.stack.imgur.com/ItvZj.png)

Doing this will tell the browser to set a breakpoint anywhere that something goes 'wrong' in your code, but where the exception was caught and didn't show an error.

It's fun doing this on websites you didn't write...
