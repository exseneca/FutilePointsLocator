create procedure base.CreatePlayerHistory()
language sql
as $$
truncate table base.player_history;
insert into base.player_history
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

$$

