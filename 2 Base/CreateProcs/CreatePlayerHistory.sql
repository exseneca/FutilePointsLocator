create procedure base.CreatePlayerHistory()
language sql
as $$
truncate table base.player_history;
with table1 as 
(
select 
  a.element as player_id,
  b.full_name as player_name,
  b.last_name as player_last_name,
  b.position,
  b.team,
  b.team_id,
  c.name as oppenent_team,
  a.opponent_team as opponent_team_id,
  a.fixture as fixture_id,
  a.kickoff_time,
  case when a.was_home = True then 1 else 0 end as IsHome,
  a.team_h_score as home_score,
  a.team_a_score as away_score,
  a.round,
  row_number() over (partition by a.element order by kickoff_time desc) as round_desc,
  a.minutes,
  case when a.minutes >= 90 then 1 else 0 end started,
  case when a.minutes > 0 then 1 else 0 end played,
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
 	Import.element_history a 
    	join
        	Base.players b  
            	on a.element = b.id
        join
        	Base.teams c 
            	on a.opponent_team = c.id
)
insert into base.player_history 
(
  player_id,
  player_name,
  player_last_name,
  position,
  team,
  team_id,
  oppenent_team,
  opponent_team_id,
  fixture_id,
  kickoff_time,
  IsHome,
  home_score,
  away_score,
  round,
  round_desc,
  minutes,
  started,
  played,
  goals_scored,
  assists,
  clean_sheets,
  goals_conceded,
  own_goals,
  penalties_saved,
  penalties_missed,
  yellow_cards,
  red_cards,
  saves,
  starting_points,
  sub_points,
  goal_scored_points,
  assist_points,
  clean_sheet_points,
  penalty_save_points,
  penalty_miss_points,
  goals_conceded_points,
  own_goal_points,
  yellow_card_points,
  red_card_points,
  total_points
)
select 
  player_id,
  player_name,
  player_last_name,
  position,
  team,
  team_id,
  oppenent_team,
  opponent_team_id,
  fixture_id,
  kickoff_time,
  IsHome,
  home_score,
  away_score,
  round,
  round_desc,
  minutes,
  started,
  played,
  goals_scored,
  assists,
  clean_sheets,
  goals_conceded,
  own_goals,
  penalties_saved,
  penalties_missed,
  yellow_cards,
  red_cards,
  saves,
  case when started = 1 then 2 else 0 end as starting_points,
  case when started = 0 and played = 1 then 1 else 0 end as sub_points,
  case 
  	when position in ('GKP', 'DEF') then goals_scored*7
    when position = 'MID' then goals_scored*6
    when position = 'FWD' then goals_scored*5
  end as goal_scored_points,
  assists*3 as assist_points,
  case 
  	when position = 'GKP' and clean_sheets > 0 and minutes >= 60 then 7
    when position = 'DEF' and clean_sheets > 0 and minutes >= 60 then 5
    else 0
  end as clean_sheet_points,
  penalties_saved*5 as penalty_save_points,
  penalties_missed*(-3) as penalty_miss_points,
  case when goals_conceded > 1 and position in ('GKP', 'DEF') then goals_conceded*(-1) else 0 end as goals_conceded_points,
  own_goals*(-2) as own_goal_points,
  yellow_cards*(-1) as yellow_card_points,
  red_cards*(-3) as red_card_points,
  null as total_points
from
	table1;
    
update base.player_history 
set total_points = 
(
  starting_points +
  sub_points + 
  goal_scored_points +
  assist_points +
  clean_sheet_points +
  penalty_save_points +
  penalty_miss_points +
  goals_conceded_points +
  own_goal_points +
  yellow_card_points +
  red_card_points
);

$$

