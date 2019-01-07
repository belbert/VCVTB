#!/usr/bin/env python
import os
import glob

path=os.getcwd()
print '----------------------------------------------------------------'
print 'Running from '+ path
print '----------------------------------------------------------------'
outputpath = '/media/generic/LINDATA/Out/EPW/'
print 'Looking for outputfiles in ' + outputpath
print '----------------------------------------------------------------'
Products = next(os.walk(outputpath))[1] #Maak een lijst met de outputfolders
print Products

if os.path.exists('/home/generic/EnergyPlus/COMPILED/TestEnergyPlus/Errorsepw.txt'):
    os.remove('/home/generic/EnergyPlus/COMPILED/TestEnergyPlus/Errorsepw.txt')



with open('Errorsepw.txt','a') as Errors:
    for folder in Products:
        print folder
        found = False
        with open(outputpath+'/'+folder+'/'+folder+'out.err') as errorfile:
            for line in errorfile:
                if 'EnergyPlus Completed Successfully' in line:
                    found = True
        if not found:
           Errors.write('Simulation '+folder+' Contains Errors! \n')
           print '> Simulation '+folder+' Contains Errors!'

print '----------------------------------------------------------------'
print '> A list of all simulations containing severe errors can be found at /home/generic/Documents/Errors.txt'
