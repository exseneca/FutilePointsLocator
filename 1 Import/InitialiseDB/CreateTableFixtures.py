import requests 

def return_fields(ExampleObject):
    key_list = list(ExampleObject.keys())
    output_string = ''
    output_string = output_string + '    '
    output_string = output_string + key_list[0] + ','
    output_string
    for i in range(1, len(key_list)):
        output_string += '\n'
        output_string += '    '
        output_string += key_list[i]
        if i < len(key_list)-1:
            output_string += ','
    return output_string

url = 'https://fantasy.premierleague.com/api/fixtures/'
response = requests.get(url)
if response.status_code != 200:
    print('Bad Request')
else:

    response_json = response.json()[0]
    
    field_list = return_fields(response_json)
    create_table_header = 'create table Import.Fixtures' + '\n(\n'
    create_table_footer = '\n);'

    sql = create_table_header + field_list + create_table_footer 
    file_name = 'CreateTableQueries/CreateTable_Import_Fixtures_raw.sql' 
    f = open(file_name, 'w')
    f.write(sql)
    f.close()


