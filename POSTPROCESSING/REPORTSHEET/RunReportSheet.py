import os
import datetime

#Manuele Invoer
#Simulations = ['VentSys2C-HH5151-1-N1', 'VentSys2C-HH4142-2-N1', 'VentSys2C-HH3131-2-N1']

#Folderinvoer path = folder met alle E+ outputfiles
path = '/media/generic/LINDATA/Out/BENCHMARK'
Simulations=next(os.walk(path))[1]
print Simulations
#Simulations = ['VentSys5D-HH-7474-0-N11']
#print subfolders


for i in Simulations:
    SimulationName = i
    print "\nRun ReportSheet for " +SimulationName
    print '------------------------------------------------------------------------------------------------------------'
    os.system(str("python MMVReportSheet.py " + i)) # toggle on/off
    os.system(str("python RegularReportSheet.py " + i)) # toggle on/off
