create procedure base.CreateFixtures() 
language sql
as
$$
truncate table base.fixtures;
insert into base.fixtures
 (
   id,
   gameweek,
   kickoff_time,
   home_team,
   home_team_id,
   home_team_score,
   away_team,
   away_team_id,
   away_team_score,
   isStarted,
   isFinished,
   minutes,
   home_difficulty,
   away_difficulty
 )
select 
	a.id, 
    a.event as gameweek,
    a.kickoff_time,
    b.name as home_team,
    a.team_h as home_team_id,
    a.team_h_score as home_team_score,
    c.name as away_team,
    a.team_a as away_team_id,
    a.team_a_score as away_team_score,
    case when a.started = True then 1 else 0 end as isStarted,
    case when a.finished = True then 1 else 0 end as isFinished,
    a.minutes as minutes,
    a.team_h_difficulty as home_difficulty,
    a.team_a_difficulty as away_difficulty
from 
	Import.fixtures a 
    	inner join 
        	Import.teams b 
            	on a.team_h = b.id
         inner join
         	Import.teams c 
            	on a.team_a = c.id;
$$
    

 