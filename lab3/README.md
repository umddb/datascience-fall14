## SQL + Python Pandas: Part 2


### SQL

This assignment covers some of the advanced constructs of SQL. 

- **Views:** A view is the result set of a stored query on the data, which the users can query just as they would query a standard database table. Views are widely used to simplify queries and to restrict access to portions of data. An example of view creation is:

    create view USAPlayers as
        select * 
        from players
        where country_id = 'USA';

We can now use this in any query, e.g., to find `Gold Medals` won by players from USA.

    select *
    from USAPlayers inner join Results on player_id
    where medal = 'GOLD';

See http://www.postgresql.org/docs/9.3/static/sql-createview.html for the PostgreSQL details on creating views.

- **Triggers**: Triggers are used to automatically execute queries or programs in response to certain events on a table or a view in a database.
The trigger event can be an insert, delete, or update on a database table, and the action to be taken is specified as procedural code (similar
to user-defined functions discussed below).

Syntax for triggers varies from system to system; here is the [link to PostgreSQL syntax](http://www.postgresql.org/docs/9.3/static/sql-createtrigger.html).

- **NULLS**: SQL uses this special marker to indicate that a data value does not exist in the database. Although NULLs are necessary, they also
complicate matters significantly, and one needs to be familiar with the *three-valued logic* in order to reason about the effect of NULLs.
[Wikipedia article on NULLs](http://en.wikipedia.org/wiki/Null_%28SQL%29) has many examples of queries that do not behave as expected because of
NULLs.

Let's create and populate two tables: 
        create table R (A char(10), B integer, C integer);
        create table S (C integer, D char(10);
        insert into R values('a1', 15, 15);
        insert into R values('a2', 20, 20);
        insert into R values('a3', 30, 30);
        insert into R values('a4', 0, NULL);
        insert into S values(30, 'd1');
        insert into S values(NULL, 'd2');

You can verify, e.g., that `select avg(B) from R` and `select avg(C) from R` return different answers (i.e., NULLs are ignored rather than
    treated as zeros), or that `select * from R where C = 15 or C != 15` does not return the final row.


- **User-defined Functions and Procedural Code**: Most relational database systems support some procedural language to write tasks that are
difficult to write using SQL alone. For example, PostgreSQL uses PL/pgSQL, Oracle support PL/SQL, and so on. Most of the databases support
multiple such languages. Here are some resources and examples of PostgreSQL functions.
        - http://www.postgresonline.com/journal/archives/58-Quick-Guide-to-writing-PLPGSQL-Functions-Part-1.html
        - http://www.postgresql.org/docs/current/interactive/plpgsql-structure.html
Such a language is especially useful for writing *user-defined functions*, which are used to encapsulate frequently perform logic or tasks. The
standard syntax for writing UDFs is: 

          CREATE FUNCTION ...
          RETURNS ...
                ...
          RETURN ...
See above links for some examples.


#### Assignment Part 1

**Submission instructions:** A template answers file is provided (`sql_submission.txt`), where you should add both your SQL queries as well as the result outputs. The text file should be submitted.

   . Create a view that contains the total number of medals per country, with schema: `NumberOfMedals(country_name, number_of_medals)` 

   . (a) Write a query to join the two tables described above (*R* and *S*) on *C*, such that if a tuple from R and a tuple from S both have
     attribute C set to NULL, then they are joined together. So the result will contain `(a3, 30, 30, d1)` and `(a4, 0, NULL, d2)`.
     (b) Write a query to instead get such tuples padded with NULL, i.e., the output should contain, in addition to the inner join result, `(a4, 0, NULL, NULL)` and `(NULL, NULL, NULL, d2)`.

   .  Write a "trigger" to keep the TeamMedals table updated when a new entry is
   dded to the Results table (don't do anything if the new entry refers to an individual
   vent). Database systems tend to be very picky about the trigger syntax, so be careful.

   . Write a PL/pgSQL procedure to create a list of all "gold medalists" from USA in ATH2004 olympics, output in XML format as follows:
          <medal>
              <event>Event1</event>      
              <player>Player1</player>  
          </medal>
          <medal>
              <event>Event2</event>      
              <players>
                  <player>Player2</player>
                  <player>Player3</player>
                  <player>Player4</player>
              </players>
          </medal>
          ...

---

### Pandas

