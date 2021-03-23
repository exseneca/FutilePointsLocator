import requests
import psycopg2

conn = psycopg2.connect("dbname=FutilePointsLocator user=fplservice")

#cur.execute('insert into Import.phases (id, name, start_event, stop_event) values (%s, %s, %s, %s)',
#(1, 'blah', 0, 0)
#)
#conn.commit()

url = 'https://fantasy.premierleague.com/api/bootstrap-static/'
response = requests.get(url)
if response.status_code != 200:
    raise TypeError('Bad Request')
else:
    response_json = response.json()
    key_list = list(response_json.keys())
    key_list.remove('game_settings')
    key_list.remove('total_players')
    key_list.remove('element_stats')
    for key in key_list:
        data = response_json[key]
        
        sql = 'truncate table Import.' + key + ';'
        cur = conn.cursor()
        cur.execute(sql)
        conn.commit()
        cur.close()
        print('Inserting data for: ' + key)
        for item in data: 
            schema_declaration = '(' + ', '.join(list(item.keys())) + ')'
            insert_statement = 'INSERT INTO Import.' + key + ' ' 
            string_format = '(' + '%s,'*(len(item.keys())-1) + '%s)'

            sql = insert_statement + schema_declaration + ' VALUES ' + string_format + ';'
            query_data = tuple(item.values()) 

            query_data = tuple([str(thing) if isinstance(thing, dict) or isinstance(thing, list) else thing for thing in query_data])
            cur = conn.cursor()
            cur.execute(sql, query_data)
            conn.commit()
            cur.close()

conn.close()