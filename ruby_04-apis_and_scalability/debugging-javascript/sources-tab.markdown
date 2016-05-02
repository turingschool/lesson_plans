# Using the Sources Tab

![console](../assets/debug-sources.png)

The sources tab allows you to see source files for a website and set breakpoints in your javascript code.

![using the sources](http://g.recordit.co/W9zWeVG5aq.gif)

As the demo above shows, you can set breakpoints from the browser. You can also use the command `debugger` anywhere in your client-side code to trigger a breakpoint when the debugger is hit.

Breakpoints cause the code to stop in place, which allows you see and play around with the code in the exact state where the breakpoint was hit.

Another excellent trick is using Pause on Caught Exceptions.

* Pause on Caught Exception
  ![howitlooks](http://i.stack.imgur.com/ItvZj.png)

Doing this will tell the browser to set a breakpoint anywhere that something goes 'wrong' in your code, but where the exception was caught and didn't show an error.

It's fun doing this on websites you didn't write...
