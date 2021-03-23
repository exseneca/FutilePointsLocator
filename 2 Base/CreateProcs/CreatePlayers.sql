create procedure base.CreatePlayers()
language sql
as $$
truncate table base.players;
insert into base.players 
(
  id,
  position,
  full_name ,
  last_name,
  team,
  team_id,
  squad_number,
  photo,
  minutes,
  goals_scored,
  assists,
  clean_sheets,
  goals_conceded,
  own_goals,
  penalties_saved,
  penalties_missed,
  yellow_cards,
  red_cards,
  saves
)

select
  a.id,
  c.singular_name_short as position,
  concat(a.first_name, ' ', a.second_name) as full_name,
  a.second_name as last_name,
  b.name as team,
  a.team as team_id,
  a.squad_number,
  a.photo,
  a.minutes,
  a.goals_scored,
  a.assists,
  a.clean_sheets,
  a.goals_conceded,
  a.own_goals,
  a.penalties_saved,
  a.penalties_missed,
  a.yellow_cards,
  a.red_cards,
  a.saves
from
	import.elements a 
    	join
        	import.teams b on a.team = b.id
        join
        	import.element_types c on a.element_type = c.id
;
$$