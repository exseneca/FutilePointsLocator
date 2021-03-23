create table Import.events
(
  id int primary key,
  name varchar(50),
  deadline_time timestamp without time zone,
  average_entry_score int,
  finished bool,
  data_checked bool,
  highest_scoring_entry int,
  deadline_time_epoch bigint,
  deadline_time_game_offset int,
  highest_score int,
  is_previous bool,
  is_current bool,
  is_next bool,
  chip_plays varchar(1000),
  most_selected int,
  most_transferred_in int,
  top_element int,
  top_element_info varchar(1000),
  transfers_made int,
  most_captained int,
  most_vice_captained int
);
create table Import.teams
(
  code int,
  draw int,
  form varchar(50),
  id int primary key,
  loss int,
  name varchar(50),
  played int,
  points int,
  position 0,
  short_name varchar(5),
  strength int,
  team_division varchar(5),
  unavailable bool,
  win int,
  strength_overall_home int,
  strength_overall_away int,
  strength_attack_home int,
  strength_attack_away int,
  strength_defence_home int,
  strength_defence_away int,
  pulse_id int
  
);

create table Import.element_types
(
    id int,
    plural_name varchar(50),
    plural_name_short varchar(50),
    singular_name varchar(50),
    singular_name_short varchar(50),
    squad_select int,
    squad_min_play int,
    squad_max_play int,
    ui_shirt_specific bool,
    sub_positions_locked varchar(50),
    element_count int
);


create table Import.elements
(
    chance_of_playing_next_round int,
    chance_of_playing_this_round int,
    code int,
    cost_change_event int,
    cost_change_event_fall int,
    cost_change_start int,
    cost_change_start_fall int,
    dreamteam_count int,
    element_type int,
    ep_next varchar(10),
    ep_this varchar(10),
    event_points int,
    first_name varchar(50),
    form varchar(10),
    id int,
    in_dreamteam bool,
    news varchar(2000),
    news_added timestamp without time zone,
    now_cost int,
    photo varchar(20),
    points_per_game varchar(10),
    second_name varchar(50),
    selected_by_percent varchar(10),
    special bool,
    squad_number int,
    status varchar(10),
    team int,
    team_code int,
    total_points int,
    transfers_in int,
    transfers_in_event int,
    transfers_out int,
    transfers_out_event int,
    value_form varchar(20),
    value_season varchar(20),
    web_name varchar(50),
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
    saves int,
    bonus int,
    bps int,
    influence varchar(10),
    creativity varchar(10),
    threat varchar(10),
    ict_index varchar(10),
    influence_rank int,
    influence_rank_type int,
    creativity_rank int,
    creativity_rank_type int,
    threat_rank int,
    threat_rank_type int,
    ict_index_rank int,
    ict_index_rank_type int,
    corners_and_indirect_freekicks_order int,
    corners_and_indirect_freekicks_text varchar(10),
    direct_freekicks_order int,
    direct_freekicks_text varchar(10),
    penalties_order int,
    penalties_text varchar(10)
);


create table Import.phases
(
    id int,
    name varchar(50),
    start_event int,
    stop_event int
);


create table Import.Fixtures
(
    code int,
    event int,
    finished bool,
    finished_provisional bool,
    id int,
    kickoff_time timestamp without time zone,
    minutes int,
    provisional_start_time bool,
    started bool,
    team_a int,
    team_a_score int,
    team_h int,
    team_h_score int,
    stats varchar(max),
    team_h_difficulty int,
    team_a_difficulty int,
    pulse_id int
);

create table Import.element_history
(
    element int,
    fixture int,
    opponent_team int,
    total_points int,
    was_home bool,
    kickoff_time timestamp without time zone,
    team_h_score int,
    team_a_score int,
    round int,
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
    saves int,
    bonus int,
    bps int,
    influence varchar(10),
    creativity varchar(10),
    threat varchar(10),
    ict_index varchar(10),
    value int,
    transfers_balance int,
    selected int,
    transfers_in int,
    transfers_out int
);

drop table IMport.SkyScrape;
create table Import.SkyScrape
( 
  id int primary key,
  home_team varchar,
  away_team varchar,
  motm varchar,
  home_sub_1 varchar,
  home_sub_2 varchar,
  home_sub_3 varchar,
  away_sub_1 varchar,
  away_sub_2 varchar,
  away_sub_3 varchar
);