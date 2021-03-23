create table base.fixtures
(
  	id int primary key,
	gameweek int,
  	kickoff_time timestamp,
  	home_team varchar(20),
  	home_team_id int,
  	home_team_score int,
  	away_team varchar(20),
  	away_team_id int,
  	away_team_score int,
    isStarted int,
  	isFinished int,
  	minutes int,
    home_difficulty int,
    away_difficulty int
 );

create table base.players 
(
  id int primary key,
  position varchar(3),
  full_name varchar(50),
  last_name varchar(50),
  team varchar(20),
  team_id int,
  squad_number int,
  photo varchar(20),
  minutes int,
  goals_scored int,
  assists int,
  clean_sheets int,
  goals_conceded int,
  own_goals int,
  penalties_saved int,
  penalties_missed int,
  yellow_cards int,
  red_cards int,
  saves int
);

create table base.teams
(
  id int primary key,
  name varchar(20),
  short_name varchar(20),
  strength int
);



 create table base.player_history 
(
  player_id int,
  player_name varchar(50),
  player_last_name varchar(50),
  position varchar(10),
  team varchar(50),
  team_id int,
  opponent_team varchar(20),
  opponent_team_id int,
  fixture_id int,
  kickoff_time timestamp,
  IsHome int,
  home_score int,
  away_score int,
  round int,
  round_desc int,
  minutes int,
  started int,
  played int,
  goals_scored int,
  assists int,
  clean_sheets int,
  goals_conceded int,
  own_goals int,
  penalties_saved int,
  penalties_missed int,
  yellow_cards int,
  red_cards int,
  saves int
);




create table Base.motm
(
  	player_id int, 
  	player_name varchar(50),
  	player_team varchar(50),
  	home_team varchar(50),
    away_team varchar(50)
);



drop table base.player_history_points;
create table base.player_history_points 
(
  player_id int,
  player_name varchar(50),
  player_last_name varchar(50),
  position varchar(10),
  team varchar(50),
  team_id int,
  opponent_team varchar(20),
  opponent_team_id int,
  fixture_id int,
  kickoff_time timestamp,
  IsHome int,
  home_score int,
  away_score int,
  round int,
  round_desc int,
  minutes int,
  started int,
  played int,
  goals_scored int,
  assists int,
  clean_sheets int,
  goals_conceded int,
  own_goals int,
  penalties_saved int,
  penalties_missed int,
  yellow_cards int,
  red_cards int,
  saves int,
  starting_points int,
  sub_points int,
  goal_scored_points int,
  assist_points int,
  clean_sheet_points int,
  penalty_save_points int,
  penalty_miss_points int,
  goals_conceded_points int,
  own_goal_points int,
  yellow_card_points int,
  red_card_points int,
  motm_points int,
  total_points int
);



