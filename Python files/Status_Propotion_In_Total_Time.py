
from pathlib import Path
Path('my_data.db').touch()

import sqlite3
import pandas as pd

conn = sqlite3.connect('my_data.db')
c = conn.cursor()

def delete_table_Inc_Owner():
    c.execute("DROP TABLE Inc_Owner")
    print("Table dropped... ")

def delete_table_Incidents():
    c.execute("DROP TABLE Incidents")
    print("Table dropped... ")
    
def create_table_Inc_Owner():
    c.execute('''CREATE TABLE IF NOT EXISTS Inc_Owner (ticket_nmbr text, STATUS text，assigned_group text, PARENT_SERVICE text, service text, 
              CHANGE_DATE text, TIME_IN_STATUS_BY_OWNER_HRS real)''')
    conn.commit()
    
def create_table_Incidents():
    c.execute('''CREATE TABLE IF NOT EXISTS Incidents (ticket_nmbr text, PARENT_SERVICE text, service text, org_id INTEGER,assigned_group text,
              OPEN_DATE text, CLOSE_DATE text, PRIORITY text, STATUS text，ACTUAL_COMPLETION_HRS real, BUSINESS_COMPLETION_HRS real, AGING real
              CLASS_STRUCTURE_ID INTEGER, class_structure text, CLASSIFICATION_ID INTEGER, classification text, EXTERNAL_SYSTEM text, GLOBAL_TICKET_ID INTEGER
              CLOSURE_CODE text, LAST_MODIFIED_DATE text)''')
    conn.commit()

    
create_table_Inc_Owner() 
create_table_Incidents()

## Import INCIDENTS.csv
df1 = pd.read_csv (r'INCIDENTS.csv')
#print(df1)
df1.to_sql('Incidents', conn, if_exists= 'replace', index = False)

## Import INCIDENT_OWNER_HISTORY.csv
df2 = pd.read_csv (r'INCIDENT_OWNER_HISTORY.csv')
#print(df2)
df2.to_sql('Inc_Owner', conn, if_exists= 'replace', index = False)

## Remove negative times
c.execute('''CREATE TABLE IF NOT EXISTS Incidents_rmvNeg AS
          SELECT * FROM Incidents WHERE ACTUAL_COMPLETION_HRS >= 0''')
          
## Calculte proportion and merge two tables into a new table
c.execute('''CREATE TABLE IF NOT EXISTS T1 AS
            SELECT t1.ticket_nmbr, t1.STATUS, t1.assigned_group, 
          (t1.TIME_IN_STATUS_BY_OWNER_HRS/t2.ACTUAL_COMPLETION_HRS) as proportion,t2.ACTUAL_COMPLETION_HRS
          FROM Inc_Owner t1 JOIN Incidents_rmvNeg t2 on t1.ticket_nmbr = t2.ticket_nmbr group by t1.ticket_nmbr, t1.STATUS
          ''')
c.execute('''SELECT ticket_nmbr, STATUS, assigned_group, proportion, (proportion * ACTUAL_COMPLETION_HRS) as total FROM T1''')
df_full = pd.DataFrame(c.fetchall(), columns=['ticket_nmbr','STATUS','assigned_group','proportion','total_hours_corr_prop'])   

## Case when only accept proportion less than 1
c.execute('''SELECT * FROM T1 WHERE proportion <= 1''')
df = pd.DataFrame(c.fetchall(), columns=['ticket_nmbr','STATUS','assigned_group','proportion','total_hours'])    

print(df_full)
print(df)



