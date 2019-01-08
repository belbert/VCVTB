#
import os
import time
import glob
import shutil


#HoofdDirectory
path=os.getcwd()
print path
print'-----------------------------------------------------------------------------------------------------------------'


subfolders=next(os.walk(path))[1]
#print subfolders
for i in subfolders:
    os.chdir(path + '/' +i)
    CleanUp = glob.glob('*')
    for filename in CleanUp:
       if not filename.endswith('out.csv'):
          os.remove(filename) #only keep files ending in out.csv
    print glob.glob('*')
   
