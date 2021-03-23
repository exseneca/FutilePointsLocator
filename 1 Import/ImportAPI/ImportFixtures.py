import requests
import psycopg2

conn = psycopg2.connect("dbname=FutilePointsLocator user=fplservice")

url = 'https://fantasy.premierleague.com/api/fixtures/'
response = requests.get(url)


if response.status_code != 200:
    print('Bad Request')
else:
    response_json = response.json()[0]
    data = response_json

    sql = 'truncate table Import.Fixtures;'
    cur = conn.cursor()
    cur.execute(sql)
    conn.commit()
    cur.close()
    print('Inserting data for: Fixtures')
    print(data)
    for item in data: 
        schema_declaration = '(' + ', '.join(list(item.keys())) + ')'
        insert_statement = 'INSERT INTO Import.Fixtures' 
        string_format = '(' + '%s,'*(len(item.keys())-1) + '%s)'

        sql = insert_statement + schema_declaration + ' VALUES ' + string_format + ';'
        query_data = tuple(item.values()) 

        query_data = tuple([str(thing) if isinstance(thing, dict) or isinstance(thing, list) else thing for thing in query_data])
        cur = conn.cursor()
        cur.execute(sql, query_data)
        conn.commit()
        cur.close()

conn.close()