## Basic SQL + Python Pandas

The goal of this assignment to introduce you to SQL and the similar functionality provided by Python Pandas library.

---

### SQL

We will use the open source PostgreSQL database system for this assignment. 

#### Setting up PostgreSQL on the virtual machine

PostgreSQL is already installed on your virtual machine. The current version of PostgreSQL is 9.3.5. You will find the detailed documentation at:
http://www.postgresql.org/docs/9.3/static/index.html

Following steps will get you started with creating a database and populating
it with a small Olympics dataset.

   1. You will be using PostgreSQL in a client-server mode. 
   Recall that the server is a continuously running process that listens on a specific port (the actual port would
   differ, and you can usually choose it when starting the server). In order to connect to the server, the client
   will need to know the port. The client and server are often on different machines, but
   for you, it may be easiest if they are on the same machine. 

   Using the **psql** client is the easiest -- it provides
   a commandline access to the database. But there are other clients too. We will assume **psql** here.

   Important: The server should be already started on your virtual machine -- you do not need to start it. However, the following two help pages discuss how to start the
   server: [Creating a database cluster](http://www.postgresql.org/docs/current/static/creating-cluster.html) and [Starting the
   server](http://www.postgresql.org/docs/current/static/server-start.html)

   2. PostgreSQL server has a default superuser called **postgres**. You can do everything under that
   username, or you can create a different username for yourself. If you run a command (say createdb) without
   any options, it uses the same username that you are logged in under. However, if you haven't created a
   PostgreSQL user with that name, the command will fail. You can either create a user (by logging in as the superuser),
   or run everything as a superuser (typically with the option: **-U postgres**).

   For our purposes, we will create a user with superuser priveledges:

   `sudo -u postgres createuser -s terrapin`

   3. After the server has started, the first step is to **create** a database, using the **createdb** command.
   PostgreSQL automatically creates one database for its own purpose, called **postgres**. It is preferable 
   you create a different database for your data. Here are more details on **createdb**: 
   http://www.postgresql.org/docs/current/static/tutorial-createdb.html

   We will create a database called **olympics**.

   `createdb olympics`

   4. Once the database is created, you can connect to it. There are many ways to connect to the server. The
   easiest is to use the commandline tool called **psql**. Start it by:

   `psql olympics`

    **psql** takes quite a few other options: you can specify different user, a specific port,
     another server etc. See documentation: http://www.postgresql.org/docs/current/static/app-psql.html


Now you can start using the database. 
    
   - The psql program has a number of internal commands that are not SQL commands; such commands are often client and database specific. For psql, they begin with the
   backslash character: `\`. For example, you can get help on the syntax of various PostgreSQL SQL commands by typing: `\h`.

   - `\d`: lists out the tables in the database.

   - All commands like this can be found at:  http://www.postgresql.org/docs/current/static/app-psql.html. `\?` will also list them out.

   - To populate the database using the provided olympics dataset, use the following: `\i populate.sql`. For this to work, the `populate.sql` file must be in the same directory as the one where you started psql. This commands creates the tables, and inserts the tuples. We will discuss the schema of the dataset in the next section.

#### Olympics Dataset

The dataset contains the details of the 2000 and 2004 Summer Olympics, for a subset of the games
(**swimming** and **athletics**). More specifically,
it contains the information about players, countries, events, and results. It only contains the medals information
(so no heats, and no players who didn't win a medal).
The schema of the tables should be self-explanatory (see the **populate.sql** file). 
The data was collected from http://www.databaseolympics.com/ and Wikipedia.

Some things to note: 
   - The birth-date information was not available in the database, and that field was populated randomly.

   - Be careful with the team events; the information about medals is stored by player, and a single team event gold gets translated into usually 4, but upto 6-7 **medal** entries in the Results table (for SWI and ATH events).

   - If two players tie in an event, they are both awarded the same medal, and the next medal is skipped (ie., there are events without any silver medals, but two gold medals). This is more common in Gymnastics (the dataset does not contain that data anyway, but does have a few cases like that).

   - The **result** for a match is reported as a **float** number, and its interpretation is given in the corresponding **events** table. There are three types: **seconds** (for time), **points** (like in Decathlon), **meters** (like in long jump).

You can load the database in psql using: 

`\i populate.sql`

You may have to give an explicit path for populate.sql (tab-autocomplete works well in psql).

#### Introduction to SQL

Queries in psql must be terminated with a semicolon. After populating the database, you can test it by 
running simple queries like: 

`select * from olympics;`

Some resources for SQL:
   - The website for CMSC 424 (http://www.cs.umd.edu/class/spring2012/cmsc424-0101/) contains my slides for SQL, along with a set of sample queries.
   - You can also look at an undergraduate textbook. Keep in mind the syntax of the commands can slightly vary, especially commands that use any advanced features.
   - There are numerous online resource. PostgreSQL manual is a good place for introduction to SQL.  http://sqlzoo.net also has many examples.

Here are some example queries on the olympics dataset and the SQL for them.

   - Report the total number of medals won by M. Phelps over both olympics.

   `select * from players where name like '%Phelps%';`

   See that M. Phelps ID is PHELPMIC01.

   `select count(medal) from results where player_id = 'PHELPMIC01'; `

   - Find the country with the highest population density (population/area-sqkm).
   
         select name 
         from countries 
         where population/area_sqkm = (select max(population/area_sqkm) from countries);
   
       Note that using a nested "subquery" (which first finds the maximum value of the density) as above is the most compact way to write this query.
   
   - What was the duration of the 2004 Olympics (use startdate and enddate to find this) ? 
   
         select olympic_id, enddate - startdate + 1
         from olympics o 
         where o.year = 2004;
   
   There are many interesting and useful functions on the "date" datatype. See:  http://www.postgresql.org/docs/current/interactive/functions-datetime.html

   - Create a new table that records the medals for individual sports.

         create table IndividualMedals as
         select r.player_id, e.event_id, medal, result
         from results r, events e
         where r.event_id = e.event_id and is_team_event = 0;
       
   
   - Write a query to add a new column called `country_id` to the IndividualMedals table (created during the assignment). 

     `alter table IndividualMedals add country_id char(3);`

   - Initially the `country_id` column in the IndividualMedals table would be listed as empty.  Write a query to **update** the table to set it appropriately.
   
         update IndividualMedals im
         set country_id = (select country_id
         from players p
         where p.player_id = im.player_id);


   - **(WITH)** In many cases you might find it easier to create temporary tables, especially
   for queries involving finding "max" or "min". This also allows you to break down
   the full query and makes it easier to debug. It is preferable to use the WITH construct
   for this purpose. The syntax appears to differ across systems, but here is the link
   to PostgreSQL: http://www.postgresql.org/docs/9.0/static/queries-with.html

   Following query finds the player who had the most Gold medals over the two olympics.

         with temp1 as (
               select player_id, count(medal) as num_golds
               from results
               where medal like '%GOLD%'
               group by player_id)
         select players.name 
         from players, temp1 
         where temp1.player_id = players.player_id and temp1.num_golds = (select max(num_golds) from temp1);


   - **(LIMIT)** PostgreSQL allows you to limit the number of results displayed which 
   is useful for debugging etc. Here is an example:

   `select * from Players limit 5;`

   - **(Set operations)** Find players who won team medals but no individual medals.

         (select player_id from results)
         except
         (select player_id from IndividualMedals);

---

#### Assignment Part 1
Write SQL queries for the following.

   1. Write a query to find the three medalists and their winning times for ``110m Hurdles Men'' at 2000 Olympics.

   1. Count the total number of players whose names start with a vowel ('A', 'E', 'I', 'O', 'U'). (Hint: Use "in" and "substr").

   1. For how many events at the 2000 Olympics, the result of the event is noted in 'points'?

   1. For 2000 Olympics, find the 5 countries with the smallest values of ``number-of-medals/population''.

   1. Write a query to find the number of players per country. The output should be a table with two attributes: `country_name`, `num_players`.

   1. Write a query to list all players whose names end in 'd', sorted first by their Country ID in ascending order, and second by their Birthdate in descending order.

   1. For 2004 Olympics, generate a list - *(birthyear, num-players, num-gold-medals)* - containing the years in which the players were born, the number of players born in each year, and the number of gold medals won by the players born in each year.

   1. Report all *individual events* where there was a tie in the score, and two or more players got awarded a Gold medal. The 'Events' table contains information about
   whether an event is individual or not (Hint: Use `group by` and `having`).

   1. Write a query to find the absolute differences between the gold medal and silver medal winners for all Butterfly events (Men and Women) at the Athens Olympics. The
   output should be: `event_id`, `difference`, where `difference` = time taken by silver medalist - time taken by gold medalist

   1. To complement the IndividualMedals table we created above, create a team medals table, with schema:

    `TeamMedals(country_id, event_id, medal, result)`

    The TeamMedals table should only contain one entry for each country for each team event. Fortunately for us, 
    two teams from the same country can't compete in a team event. The information about whether an
    event is a team event is stored in the `events` table.

   1. Say we want to find the number of players in each country born in 1975. The following query works, but doesn't list
   countries with 0 players born in 1975 (we would like those countries in the output with 0 as the second column). 
   Confirm that replacing `inner join` with `left outer join` doesn't work. How would you fix the query (while still using `left outer join`)?

              select c.name, count(p.name)
              from countries c inner join players p on c.country_id = p.country_id
              where extract(year from p.birthdate) = 1975
              group by c.name;

**Submission instructions:** A template answers file is provided (`sql_submission.txt`), where you should add both your SQL queries as well as the result outputs. The text file should be submitted.


---

### Pandas

(Source: [Pandas Documentation](http://pandas.pydata.org/pandas-docs/stable/index.html))
**pandas** is a Python package providing fast, flexible, and expressive data structures designed to make working with *relational* or *labeled* data both easy and intuitive.
**pandas** is well suited for many different kinds of data, including tabular data with heterogeneously-typed columns, ordered and
unordered time series data, and arbitrary matrix data with row and column labels.

The two primary data structures of pandas are: **Series (1-dimensional)** and **DataFrame (2-dimensional)**.

**pandas** documentation contains many details and also a [10 min tutorial](http://pandas.pydata.org/pandas-docs/stable/10min.html).
Another useful resource would be the [Comparison with SQL](http://pandas.pydata.org/pandas-docs/stable/comparison_with_sql.html).

We have created a small notebook using the Olympics data that goes over some basic functionality of pandas: 
http://nbviewer.ipython.org/github/umddb/datascience-fall14/blob/master/lab2/Pandas_Getting_Started.ipynb

#### Assignment Part 2
Submit an IPython notebook that does the following.
   * Load the provided three CSV files (players.csv, countries.csv, events.csv)
   * Count the total number of players whose names start with a vowel ('A', 'E', 'I', 'O', 'U'). (Hint: See [Extracting Substrings](http://pandas.pydata.org/pandas-docs/stable/basics.html#extracting-substrings))
   * Find players from 'USA' whose names start with 'A'. 
   * Construct a dataframe with two columns: `country_name`, `num_players`. Use `groupby`.
   * Convert the above left outer join query (last question in the SQL assignment) into pandas equivalent. See http://pandas.pydata.org/pandas-docs/stable/merging.html for details on how to do outer joins in pandas.

---

### Avro

[Apache Avro](http://avro.apache.org/docs/current/gettingstartedpython.html) is a data serialization system that uses JSON-based schemas, and is increasingly used to exchange data between systems and programs. Similar other technologies
include **protocol buffers** (from Google) and Apache Thrift (originally from Facebook). All of these require explicitly defined schemas, and support many different
languages.
Protocol buffers are the oldest among these three and are primarily used for
messaging, whereas the other two support richer data structures and remote procedure calls as well.

#### Installing Avro
Lab2 contains the avro package: `avro-1.7.7.tar.gz`; otherwise you can download it from the link above.

   - To install, in terminal: `tar xvf avro-1.7.7.tar.gz`, followed by `cd avro-1.7.7`, followed by `sudo python setup.py install`
   - Confirm it is installed by running `python`, and `import avro` (should not raise ImportError)

#### Defining a Schema
Avro schemas are defined in JSON. The following is an example schema for one of the Olympics tables (also provided as `country.avsc`).

         {
             "namespace": "olympics.avro",
             "type": "record",
             "name": "Country",
             "fields": [
                 {"name": "country_id",  "type": "string"},
                 {"name": "name", "type": "string"},
                 {"name": "area_sqkm", "type": "int"},
                 {"name": "population", "type": "int"},
                 {"name": "description", "type": ["string", "null"]}
             ]
         }

The last field is an example of an optional field, since it can be a string as well as null. See [Avro Schema
Declaration](http://avro.apache.org/docs/current/spec.html#schemas) for much more detail.

#### Assignment Part 3

We have provided you with a `countries.avro` file which contains information about countries in a serialized form, created using 
`serialize_countries.pl`. Your task is to write a python script, called `count.py`, to read the data into a DataFrame, count the 
number of countries with population over 10000000 using pandas, and print the count. The script should be submitted.
