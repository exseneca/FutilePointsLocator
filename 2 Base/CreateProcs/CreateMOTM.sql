update import.skyscrape
	set home_team = 'Leeds',
    away_team = 'Fulham'
where id = 148;

update import.skyscrape
set away_team = 'Aston Villa'
where home_team = 'West Ham' and away_team = 'Away Team';

update import.skyscrape 
set away_team = 'Brighton'
where home_team = 'Leicester' and away_team = 'Away Team';


truncate table base.motm;

with initialPass as (
select 
	replace(a.motm, '.', '') as motm,
	b.full_name,
  	case 
    	when a.home_team = 'Manchester City'  then 'Man City'
        when a.home_team = 'Tottenham' 		  then 'Spurs'
        when a.home_team = 'Sheffield United' then 'Sheffield Utd'
        when a.home_team = 'Sheff Utd'        then 'Sheffield Utd'
        when a.home_team = 'Wolvea'           then 'Wolves'
        when a.home_team = 'Palace'           then 'Crystal Palace'
        when a.home_team = 'Leeds United'     then 'Leeds'
  		when a.home_team = 'West Ham United'  then 'West Ham'
       else a.home_team end as home_team,
  case 
    	when a.away_team = 'Manchester City'  then 'Man City'
        when a.away_team = 'Tottenham' 		  then 'Spurs'
        when a.away_team = 'Sheffield United' then 'Sheffield Utd'
        when a.away_team = 'Sheff Utd'        then 'Sheffield Utd'
        when a.away_team = 'Wolvea'           then 'Wolves'
        when a.away_team = 'Palace'           then 'Crystal Palace'
        when a.away_team = 'Leeds United'     then 'Leeds'
  		when a.away_team = 'West Ham United'  then 'West Ham'
       else a.away_team end as away_team,
  		b.id as player_id
from 
	import.skyscrape a 
    left join  
    base.players b 
    on replace(a.motm, '.', '') = translate(b.full_name, 'é,ï,ç,ú,ö,ø,í,ü,ã','e,i,c,u,o,o,i,u,a')
        or replace(a.motm, '.', '') = translate(b.last_name, 'é,ï,ç,ú,ö,ø,í,ü','e,i,c,u,o,o,i,u')

),
players_translated as 
(
	select 
  		translate(full_name, 'é,ï,ç,ú,ö,ø,í,ü','e,i,c,u,o,o,i,u') as full_name,
 		translate(last_name, 'é,ï,ç,ú,ö,ø,í,ü','e,i,c,u,o,o,i,u') as last_name,
  		team,
  		id
  	from
  		base.players
),
secondpass as 
(
select 
  case when position('(' in motm) > 0 then trim(substring(motm, 0, position('(' in motm))) else motm end as motm,
  b.full_name,
  a.home_team,
  a.away_team,
  b.id as player_id
from
	initialPass a 
    left join
    	players_translated b 
        	on case when position('(' in motm) > 0 then trim(substring(motm, 0, position('(' in motm))) else motm end  = b.full_name
where a.full_name is null
),
thirdpass as 
(
select 
	a.motm,
  	c.full_name,
    a.home_team,
    a.away_team,
    c.player_id
from secondPass a
	left join
    	(select
         	case when hist.isHome = 1 then hist.team else hist.opponent_team end as home_team,
            case when hist.isHome = 1 then hist.opponent_team else hist.team end as away_team,
         	b.full_name,
         	hist.player_id
         from 
          base.player_history hist 
        left join 
    	players_translated b 
        	on   hist.player_id = b.id
         where 
         	hist.minutes > 0

         ) c
        on 
                a.home_team = c.home_team
                and a.away_team = c.away_team
                and (
                  left(a.motm, 5) = left(c.full_name, 5)
                  and
                  right(a.motm, 5) = right(c.full_name, 5)
                )
    where a.full_name is null
),
fourthpass as 
(
select 
	a.motm,
  	c.full_name,
    a.home_team,
    a.away_team,
    c.player_id
from thirdpass a
	left join
    	(select
         	case when hist.isHome = 1 then hist.team else hist.opponent_team end as home_team,
            case when hist.isHome = 1 then hist.opponent_team else hist.team end as away_team,
         	b.full_name,
         	hist.player_id
         from 
          base.player_history hist 
        left join 
    	players_translated b 
        	on   hist.player_id = b.id
         where 
         	hist.minutes > 0

         ) c
        on 
                a.home_team = c.home_team
                and a.away_team = c.away_team
                and (
                  --left(a.motm, 5) = left(c.full_name, 5)
                  --or
                  right(a.motm, 5) = right(c.full_name, 5)
                )
    where a.full_name is null
),
fifthpass as 
(
select 
	a.motm,
  	c.full_name,
    a.home_team,
    a.away_team,
  	c.id as player_id
from thirdpass a
	left join
    	(select
         	case when hist.isHome = 1 then hist.team else hist.opponent_team end as home_team,
            case when hist.isHome = 1 then hist.opponent_team else hist.team end as away_team,
         	b.full_name,
         b.id
         from 
          base.player_history hist 
        left join 
    	players_translated b 
        	on   hist.player_id = b.id
         where 
         	hist.minutes > 0

         ) c
        on 
                a.home_team = c.home_team
                and a.away_team = c.away_team
                and (
                  left(a.motm, 4) = left(c.full_name, 4)
                  --or
                  --right(a.motm, 5) = right(c.full_name, 5)
                )
   where a.full_name is null
  
  )

insert into base.motm
select 
	player_id,
    b.full_name,
    b.team,
    a.home_team,
    a.away_team
from 
(
  select * from initialpass where full_name is not null
  union all select * from secondpass where full_name is not null
  union all select * from thirdpass where full_name is not null
  union all select * from fourthpass where full_name is not null
  union all select * from fifthpass where full_name is not null
 ) a 
 join base.players b 
 on a.player_id = b.id
 join base.fixtures c 
 on a.home_team = c.home_team
 and a.away_team = c.away_team
 ;

-- delete rogue rows 
delete from base.motm where home_team = 'Leicester' and away_team = 'Burnley' and player_id = 87;
delete from base.motm where home_team = 'Man City' and away_team = 'Liverpool' and player_id = 276;
delete from base.motm where id in
(
  select max(id) from base.motm where home_team = 'Arsenal' and away_team = 'Chelsea'
);


-- insert rows unable to scrape 
insert into base.motm (player_id, player_name, player_team,  home_team, away_team)
select a.player_id, b.full_name, b.team, a.home_team, a.away_team
from
(
select 254 as player_id, 'Liverpool' as home_team, 'Leeds' as away_team
union all
select 251, 'Chelsea', 'Liverpool'
union all
select 276, 'Man City', 'Arsenal'
union all 
select 360, 'Sheffield Utd', 'Fulham'
union all 
select 388, 'West Brom', 'Spurs'
union all 
select 68, 'West Ham', 'Brighton'
union all 
select 235, 'Crystal Palace', 'Leicester'
union all
select 24, 'Brighton', 'Arsenal'
 ) a 
 join base.players b on a.player_id = b.id;



