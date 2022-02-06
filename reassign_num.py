#from pathlib import Path
#Path('my_data.db').touch()
import sqlite3
import pandas as pd
conn = sqlite3.connect('my_data.db')
c = conn.cursor()

def delete_table():
    c.execute("DROP TABLE Inc_Owner")
    print("Table dropped... ")

def create_table():
    c.execute('''CREATE TABLE IF NOT EXISTS Inc_Owner (ticket_nmbr text, STATUS text，assigned_group text, PARENT_SERVICE text, service text, CHANGE_DATE text, TIME_IN_STATUS_BY_OWNER_HRS real)''')
    conn.commit()

def convert_to_pandas():
    dfr = pd.DataFrame(c.fetchall(), columns=['ticket_nmbr','Reassigned_num'])    
    print (dfr)

create_table()
dfr = pd.read_csv (r'C:\Users\Yiqi Huang\Desktop\Candev competition\INCIDENT_OWNER_HISTORY.csv')
print(dfr)
dfr.to_sql('Inc_Owner', conn, if_exists= 'replace', index = False)

## Create a new table that only record the tickets have distinct assigned groups
c.execute('''  
CREATE TABLE IF NOT EXISTS shorter AS
SELECT ticket_nmbr,assigned_group FROM Inc_Owner WHERE ticket_nmbr IN (
    SELECT ticket_nmbr
    FROM Inc_Owner
    GROUP BY ticket_nmbr
    HAVING COUNT(distinct assigned_group) > 1)
          ''')
          

## Calculate the numbers of distinct assigned groups, 
## and subtract 1 due to the first group is not considered as "reassigned" 
c.execute('''  
SELECT ticket_nmbr ,count(DISTINCT assigned_group)-1 AS Reassigned_num
FROM shorter 
GROUP BY ticket_nmbr''' )

    
convert_to_pandas()

