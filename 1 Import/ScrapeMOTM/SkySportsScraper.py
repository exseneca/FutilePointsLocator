import requests
from bs4 import BeautifulSoup
from string import digits
import pandas as pd
import psycopg2

def return_soup_text(url):
    response = requests.get(url)
    print(response.status_code)
    if response.status_code != 200:
       raise TypeError('Bad request ')
    return BeautifulSoup(response.text, features='html.parser')


def return_match_urls():
    url = 'http://www.skysports.com/premier-league-results'
    soup = return_soup_text(url)
    match_link_tags = soup.find_all('a',class_='matches__link')
    match_link_urls = [match_link_tag['href'] for match_link_tag in match_link_tags]
    return match_link_urls

def clean_after_colon(s):
    return s[s.index(':')+1:].strip()

def remove_sub_extra(s):
    punctuation = '().'
    to_remove = str.maketrans('', '', digits + punctuation)
    return s.translate(to_remove).strip()

def return_match_info(url):

    print('getting match info for: {}'.format(url))
    print('')

    match_info = {}

    soup = return_soup_text(url)
    fact_box = soup.find('div', class_='sdc-article-factbox')

    # get teams, first all b tags
    all_b_tags = fact_box.find_all('b')

    # home team
    home_team_b_tag = all_b_tags[0]
    home_team = home_team_b_tag.get_text().replace(':','').strip()
    match_info['home_team'] = home_team
    # away team
    away_team_b_tag = all_b_tags[2]
    away_team = away_team_b_tag.get_text().replace(':','').strip()
    match_info['away_team'] = away_team
    # get subs and motm 
    fact_lines = fact_box.get_text().split('\n')



    subs_list = list(filter(lambda item: 'subs:' in item.lower() or 'subs used:' in item.lower(), fact_lines))
    home_subs = list(map(remove_sub_extra,clean_after_colon(subs_list[0]).split(',')))
    away_subs = list(map(remove_sub_extra,clean_after_colon(subs_list[1]).split(',')))



    motm_txt = list(filter(lambda item: 'man of the match:' in item.lower(), fact_lines))[0]
    motm = clean_after_colon(motm_txt)
    match_info['motm'] = motm
    match_info['home_subs'] = home_subs
    match_info['away_subs'] = away_subs
    print(match_info)
    return match_info 


def expand_subs(match_info):
    def expand(match_info, subs, IsHome):
            match_location = 'home' if IsHome else 'away'
            for i in range(0, len(subs)):
                match_info[match_location + '_sub_' + str(i+1)] = subs[i]

    home_subs = match_info['home_subs']
    expand(match_info, home_subs, True)
    del match_info['home_subs']

    away_subs = match_info['away_subs']
    expand(match_info, away_subs, False)
    del match_info['away_subs']
    return match_info


played_matches = return_match_urls()  
all_match_info = []

for url in played_matches:

    try:
        match_info = return_match_info(url)
        match_info = expand_subs(match_info)
        print(match_info)
        all_match_info.append(match_info)

    except:
        print('Couldnt extract match :)')


fields = ['home_team', 'away_team', 'motm', 'home_sub_1', 'home_sub_2', 'home_sub_3', 'away_sub_1', 'away_sub_2', 'away_sub_3']
df = pd.DataFrame(data=all_match_info, columns=fields)


conn = psycopg2.connect("dbname=FutilePointsLocator user=fplservice")
cursor = conn.cursor()
cursor.execute('TRUNCATE TABLE Import.skyscrape')
for index, row in df.iterrows():
    cursor.execute('INSERT INTO Import.skyscrape (id, home_team, away_team, motm, home_sub_1, home_sub_2, home_sub_3, away_sub_1, away_sub_2, away_sub_3) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',
                    (index, row.home_team, row.away_team, row.motm, row.home_sub_1, row.home_sub_2, row.home_sub_3, row.away_sub_1, row.away_sub_2, row.away_sub_3))
conn.commit()
cursor.close()