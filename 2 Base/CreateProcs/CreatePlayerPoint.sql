create procedure base.CreatePlayerHistoryPoints()
language sql 
as $$
truncate table base.player_history_points;
insert into base.player_history_points
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
  a.player_id,
  a.player_name,
  a.player_last_name,
  a.position,
  a.team,
  a.team_id,
  a.oppenent_team,
  a.opponent_team_id,
  a.fixture_id,
  a.kickoff_time,
  a.IsHome,
  a.home_score,
  a.away_score,
  a.round,
  a.round_desc,
  a.minutes,
  a.started,
  a.played,
  a.goals_scored,
  a.assists,
  a.clean_sheets,
  a.goals_conceded,
  own_goals,
  a.penalties_saved,
  a.penalties_missed,
  a.yellow_cards,
  a.red_cards,
  a.saves,
  case when started = 1 then 2 else 0 end as starting_points,
  case when started = 0 and played = 1 then 1 else 0 end as sub_points,
  case 
  	when a.position in ('GKP', 'DEF') then a.goals_scored*7
    when a.position = 'MID' then a.goals_scored*6
    when a.position = 'FWD' then a.goals_scored*5
  end as goal_scored_points,
  a.assists*3 as assist_points,
  case 
  	when a.position = 'GKP' and a.clean_sheets > 0 and minutes >= 60 then 7
    when a.position = 'DEF' and a.clean_sheets > 0 and minutes >= 60 then 5
    else 0
  end as clean_sheet_points,
  a.penalties_saved*5 as penalty_save_points,
  a.penalties_missed*(-3) as penalty_miss_points,
  case when a.goals_conceded > 1 and a.position in ('GKP', 'DEF') then a.goals_conceded*(-1) else 0 end as goals_conceded_points,
  a.own_goals*(-2) as own_goal_points,
  a.yellow_cards*(-1) as yellow_card_points,
  a.red_cards*(-3) as red_card_points,
  case when b.player_name is not null then 3 else 0 end motm_points,
  null as total_points
from
	base.player_history a 
        left join base.motm b 
        on a.team = case when a.ishome = 1 then b.home_team else b.away end 
        and a.oppenent_team = case when a.ishome = then b.away_team else b.home_team end
        and a.player_name = b.player_last_name

update base.player_history_points
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
  red_card_points + 
  motm_points
);
$$