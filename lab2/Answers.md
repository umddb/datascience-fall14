### SQL 
Write SQL queries for the following.

   1. Write a query to find the three medalists and their winning times for `110m Hurdles Men` at 2000 Olympics.

           select p.name, r.result 
           from players p, events e, results r 
           where p.player_id = r.player_id and e.event_id = r.event_id and 
                    e.name = '110m Hurdles Men' and e.olympic_id = 'SYD2000';

   1. Count the total number of players whose names start with a vowel ('A', 'E', 'I', 'O', 'U'). (Hint: Use "in" and "substr").

   `select count(*) from players where substr(name, 1, 1) in  ('A', 'E', 'O', 'I', 'U');`

   1. For how many events at the 2000 Olympics, the result of the event is noted in 'points'?

   `select count(*) from events where olympic_id = 'SYD2000' and result_noted_in = 'points';


   1. For 2000 Olympics, find the 5 countries with the smallest values of ``number-of-medals/population''.

            ********* Query below only counts among the countries that have at least one medal

            with temp as (
                select c.name, count(*)/cast(c.population as float) as ratio
                 from results r, events e, countries c, players p 
                 where e.event_id = r.event_id and e.olympic_id = 'SYD2000' and p.country_id = c.country_id and r.player_id = p.player_id
                 group by c.name, c.population
            ) 
            select name
            from temp t1
            where 5 > (select count(*) from temp t2 where t2.ratio < t1.ratio);

   1. Write a query to find the number of players per country. The output should be a table with two attributes: `country_name`, `num_players`.

            select c.name as country_name, count(*) as num_players
            from countries c inner join players p on c.country_id = p.country_id
            group by c.name;

   1. Write a query to list all players whose names end in 'd', sorted first by their Country ID in ascending order, and second by their Birthdate in descending order.

            select *
            from players
            where trim(name) like '%d'
            order by country_id asc, birthdate desc;

   1. For 2004 Olympics, generate a list - *(birthyear, num-players, num-gold-medals)* - containing the years in which the players were born, the number of players born in each year, and the number of gold medals won by the players born in each year.

            select extract(year from birthdate) as birthyear, count(medal), count(distinct players.player_id)
            from players, results, events
            where players.player_id = results.player_id and medal= 'GOLD' and 
                    events.event_id = results.event_id and events.olympic_id = 'ATH2004'
            group by extract(year from birthdate);

   1. Report all *individual events* where there was a tie in the score, and two or more players got awarded a Gold medal. The 'Events' table contains information about
   whether an event is individual or not (Hint: Use `group by` and `having`).

        select name, olympic_id
        from events 
        where is_team_event = 0 and event_id in (
            select event_id
            from results
            where medal like '%GOLD%'
            group by event_id 
            having count(medal) > 1
        );

   1. Write a query to find the absolute differences between the gold medal and silver medal winners for all Butterfly events (Men and Women) at the Athens Olympics. The output should be: `event_id`, `difference`, where `difference` = time taken by silver medalist - time taken by gold medalist

        select e.name, e.event_id, r2.result - r1.result as difference
        from events e, results r1, results r2
        where e.name like '%Butterfly%' and r1.event_id = r2.event_id and r1.event_id = e.event_id
                and r1.medal = 'GOLD' and r2.medal = 'SILVER';

   1. To complement the IndividualMedals table we created above, create a team medals table, with schema:

    `TeamMedals(country_id, event_id, medal, result)`

    The TeamMedals table should only contain one entry for each country for each team event. Fortunately for us, 
    two teams from the same country can't compete in a team event. The information about whether an
    event is a team event is stored in the `events` table.

            drop table TeamMedals;
           create table TeamMedals as 
               select distinct country_id, e.event_id, medal, result
               from results r, events e, players p
               where r.event_id = e.event_id and r.player_id = p.player_id and is_team_event = 1;



   1. Say we want to find the number of players in each country born in 1975. The following query works, but doesn't list
   countries with 0 players born in 1975 (we would like those countries in the output with 0 as the second column). 
   Confirm that replacing `inner join` with `left outer join` doesn't work. How would you fix the query (while still using `left outer join`)?

              select c.name, count(p.name)
              from countries c inner join players p on c.country_id = p.country_id
              where extract(year from p.birthdate) = 1975
              group by c.name;

    Answer: This comes down to when the predicate (year = 1975) is applied. The LOJ will produce the tuples we want (e.g., 'Costa Rica', NULL), but
    they get filtered out by the `where` clause. The trick is to push the predicate into the join.

              select c.name, count(p.name)
              from countries c left outer join players p on c.country_id = p.country_id
                            and extract(year from p.birthdate) = 1975
              group by c.name;


---

### Pandas

Submit an IPython notebook that does the following.
   * Load the provided three CSV files (players.csv, countries.csv, events.csv)


   * Count the total number of players whose names start with a vowel ('A', 'E', 'I', 'O', 'U'). (Hint: See [Extracting Substrings](http://pandas.pydata.org/pandas-docs/stable/basics.html#extracting-substrings))


   * Find players from 'USA' whose names start with 'A'. 


   * Construct a dataframe with two columns: `country_name`, `num_players`. Use `groupby`.
                                              

   * Convert the above left outer join query (last question in the SQL assignment) into pandas equivalent. See http://pandas.pydata.org/pandas-docs/stable/merging.html for details on how to do outer joins in pandas.



---

### Avro

We have provided you with a `countries.avro` file which contains information about countries in a serialized form, created using 
`serialize_countries.pl`. Your task is to write a python script, called `count.py`, to read the data into a DataFrame, count the 
number of countries with population over 10000000 using pandas, and print the count. The script should be submitted.

```
import avro.schema
from avro.datafile import DataFileReader, DataFileWriter
from avro.io import DatumReader, DatumWriter

import pandas as pd
import numpy as np

reader = DataFileReader(open("countries.avro", "r"), DatumReader())

df = pd.DataFrame(columns=('name', 'country_id', 'area_sqkm', 'population'))

for country in reader:
    df = df.append(country, ignore_index=True)

reader.close()

print 'Number of countries with population over 10000000 = ', df[df['population'] > 10000000].groupby('country_id').size().sum()
```
