#!/usr/bin/env python

import os

import os.path

energypluspath = '/home/generic/EnergyPlus/COMPILED/BUILD/Products' #Location of E+ Program Files
os.chdir(energypluspath)
os.system('./energyplus -w /home/generic/EnergyPlus/COMPILED/TestEnergyPlus/Epw/in.epw -d /media/generic/LINDATA/Out/EPW/VentSys2H21-HH-3131-0-N21 -p VentSys2H21-HH-3131-0-N21 -r /home/generic/EnergyPlus/COMPILED/TestEnergyPlus/In/VentSys2H21-HH-3131-0-N21.idf')
#os.system(DetectErrors.py)
os.chdir('/home/generic/EnergyPlus/COMPILED')
if os.path.isfile("/media/generic/LINDATA/Out/EPW/VentSys2H21-HH-3131-0-N21/VentSys2H21-HH-3131-0-N21out.csv"):
   os.system("python EPLUS_2_SQL_MODES.py VentSys2H21-HH-3131-0-N21")
