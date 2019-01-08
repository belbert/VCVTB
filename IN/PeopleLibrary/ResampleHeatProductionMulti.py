import os
import pandas as pd
import traces
from datetime import datetime
from datetime import timedelta

def parse_iso_datetime(value):
    return datetime.strptime(value, "%m/%d/%Y %H:%M")

families = [
            #'3131-0',
            #'3131-2',
            #'3132-2',
            '3133-2',
            '4142-2',
            '5151-1',
            #'6464-0',
            '7474-0',
             ]

for i in range(len(families)):
     path = 'C:\Users/generic\MyProject\NEWPEOPLE/'+families[i]
     os.chdir(path)
     #print os.listdir(os.getcwd())
     subfolders=next(os.walk(path))[1]
     for i in range(len(subfolders)):
         subfolderpath = path+'/'+subfolders[i]
         os.chdir(subfolderpath)
         print os.getcwd()

         df = pd.read_csv('HeatProduction.csv')
         #df['relhum'] = pd.to_numeric(df['relhum'], errors='coerce')
         #df['dewpt'] = pd.to_numeric(df['dewpt'], errors='coerce')
         #df.info()

         list = [str(pd.to_datetime('1/1/2017')+i*timedelta(minutes=10)) for i in range(len(df))]
         pandaslist = pd.Series((list))
         #print pandaslist

         df.insert(2,'Time',pandaslist) # Has to be variable


         df['DayCount']= pd.to_datetime('1/1/2017')+timedelta(days=int(df['DayCount'].get_value(1)-1))# Ask value at position n of DayCount


         df['Time'] = pd.to_datetime(df['Time'])
         df['Time'] = df['Time']-timedelta(days=7)
         df.index = df['Time'] #Set time as the index of the dataframe
         del df['Time']

         #print df
         #Resample to 1minute and do a fill forward without interpolating
         upsampled = df.resample('1Min').ffill()
         upsampled.to_csv('HeatProduction-resampled.csv')
