---
title: Intro to CSV
tags: csv
---

# What is a CSV?

* comma-separated value file
* allows data to be saved in a simple, structured format
* spreadsheets generally are csv files

# What can you do with CSVs in Ruby?

Clone [this](https://gist.github.com/rwarbelow/78c486f1be0967f0cb5d) gist with the following command:

`git clone https://gist.github.com/rwarbelow/78c486f1be0967f0cb5d csv-practice`

* in pry:
* `require 'csv'`
* `CSV.read('filename.csv')`
* Ruby stores each table row as an array
* every value that is read in by Ruby comes in as a string

## Reading the file line-by-line

```ruby
csv = CSV.open('csv-practice.csv')
csv.each do |row|
	puts row[2]
end
```

```ruby
csv = CSV.open('csv-practice.csv', headers: true)
csv.each do |row|
	puts row["last_name"]
end
```

```ruby
CSV.foreach('csv-practice.csv', headers: true, header_converters: :symbol) do |row|
  puts row[:last_name]
end
```

## Writing to a CSV

```ruby
CSV.open('newfile.csv', 'w') do |csv|
	csv << ["a string", "another string"]  
end  
```

## In Pairs

Follow [this](http://www.sitepoint.com/guide-ruby-csv-library-part/) tutorial.

### Taught by Rachel
