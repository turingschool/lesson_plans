---
title: File I/O and CSVs
tags: csv, files, I/O
length: 90
---

## Learning Goals

* Be able to open and read the contents of a text file on the file system
* Understand the difference between a file and a file handle
* Understand how the cursor works in a file
* Be able to use the `File` class to open a handle and read/write contents
* Be able to use the `CSV` class to open a handle and read/write contents

## Structure

* 5 - Warmup
* 15 - Understanding Terms
* 20 - Exercising Raw Files
* 5 - Progress Checks & Questions
* 10 - CSV in the Raw
* 10 - CSV How-To
* 20 - Creating CSVs

## Lesson

### Warmup

Spend 5 minutes answering the following questions:

1. Why would you want to read files, especially text files, from Ruby?
2. What's the difference between a (regular, real-world) door and a door handle?
How are their jobs related but different?
3. What are CSVs and why are they particularly common for moving data around?

### Understanding Terms & Concepts

Let's spend 15 minutes discussing a few key concepts together:

* Opening a file handle
* Read/Write mode
* Moving the cursor
* Reading the entire contents -- which might be a terrible idea
* Reading line by line
* Writing a line
* Closing a handle

### Exercising Raw Files

Write a program which, when executed, creates a file named "fib.txt". In that
file output the first 30 numbers of the Fibonacci sequence, three numbers per line.
It'd start like this:

```
0, 1, 1,
2, 3, 5,
8, 13, 21,
34, 55, 89,
```

Then, write a second program which reads the `fib.txt` and outputs the lines
in the same top-to-bottom order but reversed left-to-right like this:

```
1, 1, 0,
5, 3, 2,
21, 13, 8,
89, 55, 34,
```

#### Raw File I/O Notes

```
# Opening a Read Handle
handle = File.open("filename.txt", "r")

# Reading a whole file
handle.read

# Rewind back to the beginning
handle.rewind

# Read a single line
handle.readline

# Read a collection (array) of lines
handle.readlines

# Read one line at a time with a block
handle.each_line do |line|
  puts "A line: #{line}"
end

# Opening a Write Handle
writer = File.open("output.txt", "w")

# Write a line
writer.write("My text.\n")

# Flush output but keep the handle open
writer.flush

# Close the handle and flush
writer.close
```

### Working with CSVs

#### In the Raw

Let's start CSVs by *not* using the CSV library. Work on this for 10 minutes:

* Get [customers.csv](https://raw.githubusercontent.com/turingschool-examples/sales_engine/master/data/customers.csv)
* Write a program that's able to open this file and prints all rows where the
customer last name starts with an `N`

#### CSV How-To

* CSVs are specialized text files
* You don't have to use the CSV library at all, but you should
* CSVs typically have *headers*

```ruby
csv = CSV.open('customers.csv')
csv.each do |row|
  puts row[2]
end
```

```ruby
csv = CSV.open('customers.csv', headers: true)
csv.each do |row|
  puts row["last_name"]
end
```

```ruby
CSV.foreach('customers.csv', headers: true, header_converters: :symbol) do |row|
  puts row[:last_name]
end
```

```ruby
CSV.open('newfile.csv', 'w') do |csv|
  csv << ["a string", "another string"]  
end  
```

#### Creating CSVs

Finally, write a program which can load the `customers.csv` and outputs
26 new files: each containing the customers with a shared first letter of their last name. So you'll output `customers_a.csv`, `customers_b.csv`, etc.

#### Sample Output From CSV Varieties

```
Raw file I/O:

  "id,first_name,last_name,created_at,updated_at\n"
  "1,Joey,Ondricka,2012-03-27 14:54:09 UTC,2012-03-27 14:54:09 UTC\n"
  "2,Cecelia,Osinski,2012-03-27 14:54:10 UTC,2012-03-27 14:54:10 UTC\n"
  "3,Mariah,Toy,2012-03-27 14:54:10 UTC,2012-03-27 14:54:10 UTC\n"

CSV file I/O:

  ["1", "Joey", "Ondricka", "2012-03-27 14:54:09 UTC", "2012-03-27 14:54:09 UTC"]
  ["2", "Cecelia", "Osinski", "2012-03-27 14:54:10 UTC", "2012-03-27 14:54:10 UTC"]
  ["3", "Mariah", "Toy", "2012-03-27 14:54:10 UTC", "2012-03-27 14:54:10 UTC"]

CSV file with Headers:

  #<CSV::Row "id":"1" "first_name":"Joey" "last_name":"Ondricka" "created_at":"2012-03-27 14:54:09 UTC" "updated_at":"2012-03-27 14:54:09 UTC">
  #<CSV::Row "id":"2" "first_name":"Cecelia" "last_name":"Osinski" "created_at":"2012-03-27 14:54:10 UTC" "updated_at":"2012-03-27 14:54:10 UTC">
  #<CSV::Row "id":"3" "first_name":"Mariah" "last_name":"Toy" "created_at":"2012-03-27 14:54:10 UTC" "updated_at":"2012-03-27 14:54:10 UTC">

CSV file with headers and symbol keys:

  #<CSV::Row id:"1" first_name:"Joey" last_name:"Ondricka" created_at:"2012-03-27 14:54:09 UTC" updated_at:"2012-03-27 14:54:09 UTC">
  #<CSV::Row id:"2" first_name:"Cecelia" last_name:"Osinski" created_at:"2012-03-27 14:54:10 UTC" updated_at:"2012-03-27 14:54:10 UTC">
  #<CSV::Row id:"3" first_name:"Mariah" last_name:"Toy" created_at:"2012-03-27 14:54:10 UTC" updated_at:"2012-03-27 14:54:10 UTC">
```
