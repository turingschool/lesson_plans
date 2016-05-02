# The Console API

As mentioned above, the console keeps track of all messages posted to it. The ***Console API*** is a collection of methods provided by the global `console` object, which is defined by browsers, as a way to output things into the console.

## Trying Things Out

- Open the dev tools console
- Type `console.log`

The output should look like this:

```
function log() { [native code] }
```

What does the  `native code` section mean?

## Common Console Commands

The most commonly used command is:

#### console.log()

`console.log()` is a statement that takes ones or more expressions and writes their current values to the console.

```javascript
$('#myButton').click(function(){
  console.log("I clicked a button at:", Date.now());
});
```

![console](../assets/debug-log.png)

There are other, neat methods on `console`. Try out the following examples in your console...

#### console.table

```javascript
var browsers = [
	{ name: "Internet Explorer", vendor: "Microsoft", version: "11" },
	{ name: "Chrome", vendor: "Google", version: "31" },
	{ name: "Firefox", vendor: "Mozilla", version: "26" },
	{ name: "Safari", vendor: "Apple", version: "7" },
	{ name: "Opera", vendor: "Opera", version: "18" }
];

console.table( browsers );
```
[example source](http://www.sitepoint.com/three-little-known-development-console-api-methods/)

#### console.assert

```javascript
  console.assert(document.querySelector('.catz'), "Missing 'catz' class")
```

## Resources

[To Learn More Methods](https://github.com/DeveloperToolsWG/console-object/blob/master/api.md)
