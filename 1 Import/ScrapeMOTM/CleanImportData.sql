select 
	a.home_team,
    b.name
from
	import.SkyScrape a
    left join 
    import.Teams b 
    on case 
    	when a.home_team = 'Manchester City'  then 'Man City'
        when a.home_team = 'Tottenham' 		  then 'Spurs'
        when a.home_team = 'Sheffield United' then 'Sheffield Utd'
        when a.home_team = 'Sheff Utd'        then 'Sheffield Utd'
        when a.home_team = 'Wolvea'           then 'Wolves'
        when a.home_team = 'Palace'           then 'Crystal Palace'
        when a.home_team = 'Leeds United'     then 'Leeds'
       else a.home_team end = b.name
    	