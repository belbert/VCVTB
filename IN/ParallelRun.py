#!/usr/bin/env python
import os
path = os.getcwd()
print path
energypluspath = '/home/generic/EnergyPlus/COMPILED/BUILD/Products' #Location of E+ Program Files
print energypluspath
os.chdir(energypluspath) 
print os.getcwd()
#parallelruncommand = 'parallel --jobs 6 < '+path+'/Commands.txt'
parallelruncommand = 'parallel < '+path+'/Commands.txt'
print parallelruncommand
os.system(parallelruncommand)
