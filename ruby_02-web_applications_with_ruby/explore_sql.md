# Exploring an SQLite3 database

First head to [this gists](https://gist.github.com/rwarbelow/56fe14fe4bd4c9ce0ba8) and download the sqlite3 file.

Navigate to the directory where you save the file and fire up sqlite3 and that database with this command: `sqlite3 chinook_database.sqlite`

you should see an output of something like this:

```
SQLite version 3.8.10.2 2015-05-20 18:17:19
Enter ".help" for usage hints.
sqlite>
```

Now you're inside of the database and you can begin exploring.

First checkout what tables you have by running the tables command: `sqlite3> .tables`

you should see this:

```
sqlite> .tables
albums            employees         invoices          playlists_tracks
artists           genres            media_types       tracks          
customers         invoice_items     playlists  
```

There are 11 tables included in this database.

## Getting Started and Formatting

Now let's try running our first query. Try to pull out all the data (all rows and columns) from the `artists` table.

`sqlite3> SELECT * FROM artists;`

You should now see a bunch of data returned to you.

If you're not happy with the formatting of the output you can see the settings by running the show command: `sqlite3> .show`

the output will look something like this:

```
sqlite> .show
        echo: off
         eqp: off
  explain: off
     headers: off
        mode: list
   nullvalue: ""
      output: stdout
colseparator: "|"
rowseparator: "\n"
       stats: off
       width:
```

You can change these settings by running the command of it;s name. I like to run something like this:

```
sqlite> .headers ON
sqlite> .mode column
sqlite> .width 5 32 32 32 32
sqlite> .show
        echo: off
         eqp: off
  explain: off
     headers: on
        mode: column
   nullvalue: ""
      output: stdout
colseparator: "|"
rowseparator: "\n"
       stats: off
       width: 50
```

Now the output is a little more manageable to look at. Note that running the command `sqlite3> .width 5 32 32 32 32` sets the width of each column. So the first column will now be 5 characters wide and the next 4 columns will be 32 characters wide. Any data value over 5 or 32 characters respectively will be cut off. You may want to change the `.width` for your formatting to fit different queries.

## Querying

Now that we have all that sorted out we can start writing some queries.

### Challenge 1

* return all the data from albums
* return all the data from artists
* return all data from tracks
* return all data from customers
* return all data from employees

=======================================================================================================

### Challenge 2

* return only the artists name from the artists table
* return only the albums title from the albums table
* return only the name and composer from the tracks table
* return the playlists name from the playlists table
* return the customers first names, last names, and state from the customers table
* return the employees first names, last names, titles and reports to from the employees table

=======================================================================================================

### Challenge 3

* return the number of employees in the employees table
* return the number of artists in the artists table
* return the number of customers in the customers table
* return the number of albums in the albums table
* return the number of playlists in the playlists table
* return the number of invoices in the invoices table
* return the number of genres in the genres table

=======================================================================================================

### Challenge 4

* return all columns of data from customers that have the state is 'ON' (The Canadian province Ontario)
* return the name of the customer(s) that have the state of 'AZ'
* return the email of employees with the Title of 'IT Staff'
* return the city and country of all employees
* return the number of customers from the country 'USA'

=======================================================================================================

### Challenge 5

* return all the data from the tracks that have a composer 5 characters long
* return the name from the tracks that have a name of less than 5 characters
* return the number of tracks that have a name of less than 5 characters
* return the name and album id of the tracks that have a name of less than 5 character and the composer is Billy Corgan

=======================================================================================================

### Challenge 6

* return all the data from the artists table in alphabetical order by name
* return all the data from the albums table in reverse alphabetical order by title
* return the name of the tracks in order highest unit price to lowest
* return all the data from invoices in alphabetical order by billing city

=======================================================================================================

### Challenge 7

__As an added challenge - try to return these queries with the headers renamed. For example, for the first of these below we would normally get returned 'Name' and 'Title' as the headers - try to change those to that 'Name' is displayed as 'Artist Name' and 'Album Title'. Try to do that for any  of the following.__

* return the artists name and albums title
* return the tracks name and the albums title
* return the tracks name, the artists name, and the albums title
* return the customers name, the invoices billing address and billing city
* return the customers name, the invoices billing address and billing city, and the invoice items unit price and quantity
* return the name of the playlist and the name of the track

=======================================================================================================

### Challenge 8

* return all the customers that have a first name beginning with 'h'
* return all the customers who have an email address that ends with 'gmail.com'
* return the first name, last name and phone number of the customers who have an 's' anywhere in their first or last name
