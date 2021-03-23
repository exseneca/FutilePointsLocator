import requests
import psycopg2
from urllib.error import HTTPError

conn = psycopg2.connect("dbname=FutilePointsLocator user=fplservice")
sql = 'select id from Import.elements;'
cur = conn.cursor()
cur.execute(sql)
result = cur.fetchall()
player_ids = [item[0] for item in result] 
cur.close()

url = 'https://fantasy.premierleague.com/api/element-summary/{}/'

sql = 'truncate table Import.element_history;'
cur = conn.cursor()
cur.execute(sql)
conn.commit()
cur.close()

for player_id in player_ids:
    

    response = requests.get(url.format(player_id))
    if response.status_code != 200:
        raise HTTPError('Bad Request')
    else:

        data = response.json()['history']
        for item in data: 
            schema_declaration = '(' + ', '.join(list(item.keys())) + ')'
            insert_statement = 'INSERT INTO Import.element_history' 
            string_format = '(' + '%s,'*(len(item.keys())-1) + '%s)'

            sql = insert_statement + schema_declaration + ' VALUES ' + string_format + ';'
            query_data = tuple(item.values()) 

            query_data = tuple([str(thing) if isinstance(thing, dict) or isinstance(thing, list) else thing for thing in query_data])
            cur = conn.cursor()
            cur.execute(sql, query_data)
            conn.commit()
            cur.close()

conn.close()