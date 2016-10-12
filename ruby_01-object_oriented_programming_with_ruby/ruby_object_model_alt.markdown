# Ruby Object Model
## Learning Goals
* Use tools to map out relationship between Ruby classes and modules
* Define `binding` and describe how Ruby uses bindings to manage use methods defined in superclasses.
* Describe how Singleton methods and class work
* Describe the syntax for distinguishing local variables, instance variables, class variables, and constants.

## Investigative Methods
These three methods can help you investigate the relationships between classes and modules. All methods are run on the class (i.e. `String`, `Hash`)

* `.ancestors`: returns a list of modules included/prepended in mod (including mod itself). See [docs](https://ruby-doc.org/core-2.3.1/Module.html#method-i-ancestors).
* `.included_modules`: returns a list of the modules included in mod. See [docs](https://ruby-doc.org/core-2.2.3/Module.html#method-i-included_modules).
* `.superclass`: returns the superclass of the class. See [docs](https://ruby-doc.org/core-2.3.1/Class.html#method-i-superclass).

## Mapping Ruby's Object Model
### Definitions and Rules
* `Classes`: store instance methods, have a superclass pointer
* `Instance`: store instance variables, have a class pointer
* `Classes` are also instances (of Class)
* `Classes` can only inherit from one other class (its 'superclass')
* `Classes` can include multiple Modules.
* `Modules` can be mixed-in to multiple classes (mixins)

#### Exercises
Using `.ancestors`, `.included_modules`, and `.superclass`, map out the ancestors and superclasses of Modules and Classes of these several commonly-used Ruby classes: Hash, Array, String, Fixnum, Bignum, and Float.

#### Extension
Read Camilo Reyes' ["Understanding the Object Model."](https://www.sitepoint.com/understanding-object-model/)

## Bindings
When you invoke a method on an instance, Ruby follows a pattern for locating the definition of that method.

* Start by going to its class
* Look to that class's included_modules
* Until you find the method, go to the superclass
* Once you find it, create a scope for that object

After Ruby traverses modules and superclasses and locates the source of a method, a scope is created called a `Binding`. [Binding](https://ruby-doc.org/core-2.2.0/Binding.html) is an actual Ruby class that captures the context in which code is executed. The binding retains the context for future use, including relevant variables, methods, the value of self (the instance in which they are operating), and some other contextual details.

``` ruby
class PersonSuperclass
  def get_name
    @name
  end

  def get_binding
    binding
  end
end

class Person < PersonSuperclass
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_initial
    get_name[0]
  end
end

joshs_name = "Josh"
josh = Person.new(joshs_name)
josh.get_name                 # => "Josh"
josh.get_initial              # => "J"
josh.get_binding              # => #<Binding:0x007f879cc62250>
josh.get_binding.eval('self') # => #<Person:0x007fe6348454f0 @name="Josh">
```

As this example shows, you can access the binding by calling `binding`.

#### Exercises
* Create a superclass for PersonSuperclass and a new method in that class that returns its binding. Make sure it is accessible from an instance of Person.
* Experiment with bindings and articulate two new things you've learned about how they work.

#### Check for Understanding
Define Ruby's `binding`.

## Singleton Methods and Eigenclasses
Ruby also allows us to define so-called 'singleton methods' to describe methods only accessible to single objects.

Ruby manages this information through the 'Singleton' class or Eigenclass, two words for the same thing. 'Eigen' is German for "one’s own".

``` ruby
class SingletonTest
  def self.method_one
    "I am class method, 'method_one'"
  end

  def method_two
    "I am instance method 'method_two'"
  end
end

st = SingletonTest.new
st.method_one
#=> NoMethodError: undefined method `method_one' for #<SingletonTest:0x007fb0f524dc60>

st.method_two
#=> "I am instance method, 'method_two'"

st.class.method_one
#=> "I am class method, 'method_one'"
```

#### Exercises
* Describe how the code snippet below is an example of creating a singleton method. Copy this code and try to access the Singleton method. This technique may be helpful: `instance.eigenclass.instance_methods.grep(/method_one/)`
* Describe one scenario in which you would use a singleton method. 

#### Check for Understanding
Define what Ruby's singleton method does, how the Singleton class/Eigenclass manages these methods.

## Variables
Now that we know about scopes and bindings, it will also be helpful to have some language to describe the variables available to us.

* `Instance variables` (`@name`) begin with @. Uninitialized instance variables have the value nil and produce warnings with the -w option.
* `Class variables` (`@@possible_names`) begin with @@ and must be initialized before they can be used in method definitions.
* `Local variables` (`name`) begin with a lowercase letter or `_`. The scope of a local variable ranges from class, module, def, or do to the corresponding end or from a block's opening brace to its close brace {}.
* `Constants` (`BIBLICAL_NAMES`) begin with an uppercase letter. Constants defined within a class or module can be accessed from within that class or module, and those defined outside a class or module can be accessed globally.

## Formative Assessment
Test your understanding of this material with this quiz: [http://quiz-ruby-object-model.herokuapp.com/](http://quiz-ruby-object-model.herokuapp.com/).
