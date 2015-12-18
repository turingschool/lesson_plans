## Decomposing Headcount aka Headcount Pep Talk

### Guiding Principles:

1. __Get feedback__ - includes TDD, test fixtures (speed of tests), running tests, pry,
progress vs. feedback (not outpacing your feedback)
2. __Verify Assumptions__ - includes method type annotations,
_tracing objects through code_, use `fetch` instead of `[]`
3. __Pay Attention to Connections__ - Importance of inter-class interfaces;
what does thing B need? Thing A should return it. Number of files/classes;
verifying connections with tests;


### Specific Tools / Techniques

An example test:

```ruby
class TestEconomicProfile < Minitest::Test
  def test_free_or_reduced_lunch_in_year
    path       = File.expand_path("../data", __dir__)
    repository = DistrictRepository.from_csv(path)
    district   = repository.find_by_name("ACADEMY 20")

    assert_equal 0.125, district.economic_profile.free_or_reduced_lunch_in_year(2012)
  end
end
```

Why it's good:

1. Putting all the pieces together
2. _verifying assumptions_ about what each method takes in
and returns; `fetch` vs `[]` (don't let nils percolate)
3. Starts from a large "sketch" and puts smaller things together

__Other things to expect__

Pattern: working with hashes and arrays:

```ruby
rows.map { |row| [row.fetch(:key), row.fetch(:value)] }.map(&:to_h)
```

### Structure -- Repositories, and the "Things"

* analogy: Turing -> students
* how do the repositories relate to their respective "things"?
* how is the sales engine related to the repositories?
* traveling down the chain: easy
* traveling up the chain: trickier, but doable
* what would a "thing" need to have in order to travel up the chain?
* what would a repository need to have in order to travel up the chain?

### Visual Representation of the Data

* This [online schema designer](http://ondras.zarovi.cz/sql/demo/) can be useful

### Exceptions

```ruby
irb(main):014:0> class UnknownDataError < Exception
irb(main):015:1> end
irb(main):016:0> raise UnknownDataError
UnknownDataError: UnknownDataError
irb(main):019:0> def try_to_get_thing(thing)
irb(main):020:1> h = {a: "b", c: "d"}
irb(main):021:1> value = h.fetch(thing, nil)
irb(main):022:1> if value
irb(main):023:2> value
irb(main):024:2> else
irb(main):025:2* raise UnknownDataError
irb(main):026:2> end
irb(main):027:1> end
=> :try_to_get_thing
irb(main):028:0> try_to_get_thing(:a)
=> "b"
irb(main):029:0> try_to_get_thing(:pizza)
UnknownDataError: UnknownDataError
	from (irb):25:in `try_to_get_thing'
	from (irb):29
	from /usr/local/var/rbenv/versions/2.1.1/bin/irb:11:in `<main>'
```


__Manipulating Hashes:__

```ruby
irb(main):032:0> h
=> {:a=>"b", :c=>"d"}
irb(main):033:0> h.each { |pair| puts pair }
a
b
c
d
=> {:a=>"b", :c=>"d"}
irb(main):034:0> h.each { |pair| puts pair.inspect }
[:a, "b"]
[:c, "d"]
=> {:a=>"b", :c=>"d"}
irb(main):035:0> h.each { |key, value| puts "key: #{key}"; puts "value: #{value} }
irb(main):036:1" }^C
irb(main):036:0> h.each { |key, value| puts "key: #{key}"; puts "value: #{value}" }
key: a
value: b
key: c
value: d
=> {:a=>"b", :c=>"d"}
irb(main):037:0> h = [[:a, "b"], [:c, "d"]]
=> [[:a, "b"], [:c, "d"]]
irb(main):038:0> h = [[:a, "b"], [:c, "d"]].each { |key, value| puts "key: #{key}, value: #{value}" }
key: a, value: b
key: c, value: d
=> [[:a, "b"], [:c, "d"]]
irb(main):039:0> a,b = [1,2]
=> [1, 2]
irb(main):040:0> a
=> 1
irb(main):041:0> b
=> 2
irb(main):042:0> h.each { |pair| puts pair.class.inspect }Array
Array
=> [[:a, "b"], [:c, "d"]]
irb(main):043:0> h
=> [[:a, "b"], [:c, "d"]]
irb(main):044:0> [[:a, "b"], [:c, "d"]].to_h
=> {:a=>"b", :c=>"d"}
irb(main):045:0> h = _
=> {:a=>"b", :c=>"d"}
irb(main):046:0> h.map { |key, value| [key, value.upcase] }
=> [[:a, "B"], [:c, "D"]]
irb(main):047:0> h.map { |key, value| [key, value.upcase] }.to_h
=> {:a=>"B", :c=>"D"}
```