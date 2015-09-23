Testing Small Datasets and Edge Cases
=====================================

The fictional story of Luigio, a plumber by day (it's a family business), and a developer by night...

Chapter 1: Paying the Price
---------------------------

Luigio decides to work on [Headcount](https://github.com/turingschool-examples/headcount),
to improve his programming skills.
He decides to test his code, because he is tired of breaking things and realizing it until they get into production,
take down the server, and cost his client a million dollar bills.

While working on Headcount, Luigio has to parse 17 CSV files,
it like 2 seconds to run a single test, b/c he's parsing 81k lines.
While waiting for the test, he gets bored, checks Twitter, looks at his watch,
daydreams of waterparks. Then he looks up 10 minutes later.
He pays this price on every test! :(

Poor Luigio (everyone say, "awww, poor Luigio")


Chapter 2: Fixturing the problem
--------------------------------

He travels to see the Guru Papa Smurf, who says, "I see your pain, and here's the solution:
Fixtures, go make another directory with all the same files, but each file has 4 lines in it...
that's 68 lines of code. Why Parse 81k lines of code when you could parse 68?"

And this made sense to Luigio, so he went home and he made a directory called `test/fixtures`,
where he copied all the files over and then deleted everything except for the first four lines.
And his test suite was fast.

Chapter 3: Living on the Edge Cases
-----------------------------------

Luigio realizes there's a bug in his code, and he wants to test it.
First, he opens CSV files in Excel, and cross references them, and matches the names across 17 files,
and it is painful, because that's a lot of data, and he has to keep scrolling left and right, and switching between files and such.
He pays that cost, and he eventually determines that there is no way to test this edge case with the 4 rows that he has.

So, he decides to add some more data, he puts 7 lines into that test file, and it includes the edge case that he wants to test.

And then he runs his test suite, and gets 4 failures.
"But wait!?!" Luigio thinks in consternation. He furrows his brow and shouts at the ceiling
"I didn't touch those other tests!!!" But yet they are failing.

He digs in with pry, and looks around, he follows the data back to the source, and checks each case,
he adds an if statement to decide whether to pry based on whether this is the example that is failing,
and eventually he arrives at a conclusion: When he added the row,
a different district became the most free-lunched district in all of Colorado.
The failure is corret, the new answer is the correct answer now that he's added this extra data.

So, Luigio sighs and updates his test, frustrated that it took him an hour to figure out that the test's expectation was wrong.

Then, Luigio realizes there's a bug in his code, and he wants to test it.
First, he opens CSV files in Excel, and cross references them, and matches the names across 17 files,
and it is painful, because that's a lot of data, and he has to keep scrolling left and right, and switching between files and such.
He pays that cost, and he eventually determines that there is no way to test this edge case with the 7 rows that he has.

He starts to add some extra rows... but remembering the pain from last time, he did this,
he instead decides to travel to see the Guru Gandalf Grey, the White.


Chapter 4: A Desert, a Mountain, an Elevator, Some Advice, an Elevator, a Mountain, a Desert, a Beer, a magic cat
-----------------------------------------------------------------------------------------------------------------

After a 3 month journey, through the sandy deserts, with the beating sun staining his neck red and dusty.
Luigio reaches the the unclimbable mountain (fortunately, it had an elevator, which was much appreciated after that desert).
At the peak of the mountain, in a Lotus position, sits Guru Gandalf Grey, the White.

"Help me, Guru" pleads Luigio as he recounts his lamentable situation.

The Guru ponders the situation for an hour, stroking his beard and presumably not daydreaming about other shit. And then he speaks.

"What if all your tests were independent so that one couldn't fuck up the others?", he asks rhetorically (fkn know-it-all).
"What if you could see all the data from the test itself?" His faux ignorance is getting annoying to Luigio.

"Get to the point, guru", says Luigio with an aire of patience that barely conceals his annoyance
(it was a long fucking trek across that desert).

"You need..." he begins, slowly... (the anticipation is killing Luigio).
"...mocks and stubs" he concludes.  And then Luigio decides to take a pomodoro break.

...5 minutes later, Luigio rejoined the Guru...

"I don't know what that means", he says, "Please explain, what _is_ this 'mocks and stubs' you speak of?"

"Well" says GGGtW, "how are you getting that data out of that CSV file?"
"I have a `CsvLoader` class", explains Luigio. "So I say"

```ruby
def find_by_name(name)
  loader = CsvLoader.new(path_to_data_directory)
  data   = loader.parse_that_thing_with_the_lunches
  District.new(name, loader)
end
```

"Ahh, I see", says GGGtW, "Wouldn't it be brilliant?" (he's quite full of himself),
"If you could choose the data that it returns, from within your test? Then it wouldn't need to talk to CSVs at all!"

"What would that look like?" Luigio asks.

"Maybe something like this", he says, after quickly checking the [documentation](https://github.com/seattlerb/minitest),
you can say that the `CsvLoader` methods should return the data you want them to have.
So, instead of going and getting them out of a CSV, you can just give back the answer you want!
But that means that you need to pass in the instance of `CsvLoader`,
because otherwise you won't have access to the loader that you need to stub."

```ruby
require 'minitest/mock'

# ...

def test_something_about_lunches
  csv_loader = CsvLoader.new(path)
  repository = DistrictRepository.new(csv_loader)
  data       = {
    "ACADEMY 20" => {
      economic_profile: {lunch_thing: 123}
    }
  }
  csv_loader.stub :parse_that_thing_with_the_lunches, data do
    assert_dqual 123, repository.find_by_name("Academy 20")
                                .economic_profile
                                .something_about_lunches
  end
end
```

Luigio nods in acknowledgement. "What about those mocks?" he asks.
"Similar idea", says GGGtW. "You give it an object that might be the CsvLoader...
but it's not! It's a fucking doppleganger CsvLoader. It's got all the same methods.
Your code doesn't realize it's not really pulling the data from a CSV...
But it's not, it's calling the methods we defined on it.
It's like living in the matrix... You want to be a kung-fu master?
You want to fly a helicopter? Just load it on in."

"Uhhhhhmmmmm...", Luigio blinks his eyes rapidly for a moment, in an attempt to
make sense of the metaphor, and finally asks "can you give me an example, Guru?"

With an exasperated sigh (eff off, guru, we're trying), the guru writes the new test:


```ruby
def test_something_about_lunches
  data = {
    "ACADEMY 20" => {
      economic_profile: {lunch_thing: 123}
    }
  }
  not_really_a_csv_loader = MockLoader.new(data)
  repository = DistrictRepository.new(not_really_a_csv_loader)
  assert_dqual 123, repository.find_by_name("Academy 20")
                              .economic_profile
                              .something_about_lunches
end
```

"What's that MockLoader?" Luigio wonders aloud, so the guru writes it, too.

```ruby
class MockLoader
  def initialize(data)
    @data = data
  end

  def something_about_lunches
    @data
  end

  # and all the other methods that the CsvLoader has
end
```

Luigio takes these ideas with him, back down the elevator of the unclimbable mountain,
and across the sweaty sun-beaten desert for three months, until he returns to his apartment,
where he sits on the couch, sighs, has a beer, and pets his cat that is still alive.
Inexplicably, given that Luigio hasn't fed it in 6 months.
Even more inexplicably, it's willing to let him pet it, despite his gross neglect.
And even more inexplicably, it's sitting and letting him pet it rather than whining about food,
as cats are wont to do, even when they haven't been starving for 6 months.


Chapter 5: Mocked by the Tests
------------------------------

In the morning, he went to his code-base and implemented the ideas that the Guru had suggested.
He moved the `CsvLoader` to his `DistrictRepository`'s `initialize` method, so that he could pass it in.
He made a `MockLoader`, so that he could choose what data it should return.
He updated his tests to tell the mock loader what to return,
and then he went to work at his day-job, fixing toilets and sinks.

Luigio was basically happy with his solution.
But it took a long fucking time to implement, because everything that he did,
he had to deal with the MockLoader, giving it the methods, etc and so on.

"Why do I keep having to talk about the repositories and all the keys to go all the way from the top of the
`DistrictRepository` down to the bottom of the `EconomicProfile`?" he said with exasperation.

So... he decides to travel to see a new guru.


Chapter 6, the final chapter: Enlightenment
-------------------------------------------

Luigio travels to see the Guru Josh Cheek, the incredibly wise, compassionate, intelligent, charming,
handsome, and humble instructor at the Turing School of Software and Design
(5 out of 5 students whose grade depended on their answer agree with this description).

Guru Josh Cheek looks at the situation Luigio is in and says
"that's not too bad, really, but yeah, there's a better way".

"What is it?" Luigio asked frantically (he only had 8 minutes to figure out the answer).

"Settle down, Luigio. Open your mind, and notice that there is always something making your code painful.
And then take that painful thing... and remove it from the code."

"What is painful? Asked Luigio"

"Your csvs are painful.
Your loader is painful.
Needing to go through the full object graph to get down to the economic profile,
the thing you're actually interested in testing... that's painful, Luigio."

"Give me an example, Guru", Luigio said, in an attempt to prod him towards actionable content before lunch.

"Show me your code, Luigio", which Luigio did, and the Guru refactored:

```ruby
# And the Guru refactored that code, from this:
def test_something_about_lunches
  data = {
    "ACADEMY 20" => {
      economic_profile: {lunch_thing: 123}
    }
  }
  not_really_a_csv_loader = MockLoader.new(data)
  repository = DistrictRepository.new(not_really_a_csv_loader)
  assert_dqual 123, repository.find_by_name("Academy 20")
                              .economic_profile
                              .something_about_lunches
end

# into this:
def test_something_about_lunches
  assert_dqual 123, EconomicProfile.new({lunch_thing: 123})
                                   .something_about_lunches
end
```

"What about the code that uses this?" asked Luigio,
"What about my District?", and the guru showed him.

```ruby
class District
  # And the Guru refactored that code, from this:
  def economic_profile
    @economic_profile ||= EconomicProfile.new(loader)
  end

  # into this:
  attr_accessor :economic_profile
  def initialize(name, data)
    @name             = name
    @economic_profile = EconomicProfile.new(data[:economic_profile])
  end
end
```

"And my `DistrictRepository`?"

```ruby
class DistrictRepository
  # And the Guru refactored that code, from this:
  def initialize(loader)
    @loader = loader
  end

  def find_by_name(name)
    District.new(name, @csv_loader)
  end

  # into this:
  def initialize(districts_data)
    @districts_by_name = districts_data.map { |name, district_data|
      [name.upcase, District.new(name, district_data)]
    }.to_h
  end

  def find_by_name(name)
    @districts_by_name[name.upcase]
  end
end
```


And then Luigio went to lunch to contemplate the words of the great Guru.
But first... He gave the guru a second round of applause for a last-minute
lesson that he taught, even though he didn't really agree with the ideas
that he was supposed to teach (Guru Papa Smurf and GGGtW have some good ideas,
and they're widely held and advocated and used by people who are excited about testing,
but they just make everything so complicated and so hard,
and the great insight of TDD is that when things are hard, you need to refactor
until the hard part has been pushed up into the context of the caller,
which makes the tests super easy to writes, and makes the code flexible enough
to be used in contexts that were never considered)
Hugs and hearts to all y'all!!!
