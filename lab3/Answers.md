#### Part 1: SQL Assignment Answers

** This was only checked on a old version of PostgreSQL from a few years ago -- some changes may be needed **

1. Create a view that contains the total number of medals per country, with schema: `NumberOfMedals(country_name, number_of_medals)` 

        create view NumberOfMedals as 
               select name as country_name, count(Medal) as number_of_medals
               from (
                        (select c.name, Medal from TeamMedals tm inner join Countries c on tm.country_id = c.country_id)
                        union all
                        (select c.name, Medal
                        from IndividualMedals im, Countries c, Players p
                        where im.player_id = p.player_id and p.country_id = c.country_id) 
                    ) as u
                group by name;

        Note that: UNION ALL is critical here.



1. (a) Write a query to join the two tables described above (*R* and *S*) on *C*, such that if a tuple from R and a tuple from S both have
 attribute C set to NULL, then they are joined together. So the result will contain `(a3, 30, 30, d1)` and `(a4, 0, NULL, d2)`.
 (b) Write a query to instead get such tuples padded with NULL, i.e., the output should contain, in addition to the inner join result, `(a4, 0, NULL, NULL)` and `(NULL, NULL, NULL, d2)`.

        (a) select *
        from R, S
        where (R.c = S.c) or (R.c = null and S.c = null);

        (b) select * 
        from R full outer join S on R.c = S.c;

1.  Write a "trigger" to keep the TeamMedals table updated when a new entry is dded to the Results table (don't do anything if the new entry refers to an individual vent). Database systems tend to be very picky about the trigger syntax, so be careful.

        create function UpdateIndividualMedalsFunction() returns trigger as $UpdateIndividualMedals$
        begin
            select is_team_event into teamevent from events e where e.event_id = new.event_id;
            select country_id into countryid from players p where p.player_id = new.player_id;
            if teamevent = 0 then
                insert into IndividualMedals values(new.player_id, new.event_id, new.medal, teamevent, countryid);
            end if;
        return new;
        end;

        $UpdateIndividualMedals$ language plpgsql;
        create trigger UpdateIndividualMedals after insert on results for each row execute procedure UpdateIndividualMedalsFunction();

1. Write a PL/pgSQL procedure to create a list of all "gold medalists" from USA in ATH2004 olympics, output in XML format as follows:

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


        ** It is actually possible to do this in a single SQL query using CASE. **

        DO language plpgsql $$
            DECLARE
            vr record;
            points integer;
            temp integer;

            BEGIN
                FOR vr IN select trim(e.name) as ename, array_agg(trim(p.name)) as array 
                          from results r, events e, players p 
                          where p.country_id = 'USA' and p.player_id = r.player_id and 
                                    e.event_id = r.event_id and e.olympic_id = 'ATH2004'and r.medal = 'GOLD' 
                          group by e.name 
                LOOP
                    RAISE NOTICE '<event> <name> % </name>', vr.ename;
                    points := 0;
                    if array_upper(vr.array, 1) > 1 then
                         raise notice '<players>';
                    end if;
                    RAISE NOTICE '<player> % </player>', array_to_string(vr.array, '</player> <player>');
                    if array_upper(vr.array, 1) > 1 then
                         raise notice '</players>';
                    end if;
                    RAISE NOTICE '</event>';
                END LOOP;

             END
        $$;



---

### Pandas

See the completed Notebook.
http://nbviewer.ipython.org/github/umddb/datascience-fall14/blob/master/lab3/AdvancedPandas-Answers.ipynb
