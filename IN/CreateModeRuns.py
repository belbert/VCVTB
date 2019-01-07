#
import os
import glob
import shutil
import stat



#HoofdDirectory
path=os.getcwd()
print path
print'-----------------------------------------------------------------------------------------------------------------'

os.chdir(path+'/In') # Ventilation Systems
simulations = glob.glob('*.idf')


for simulation in simulations: #make a runfile for every simulation
    with open ('Runfile.txt', 'a') as Runfile:
     SimulationName = simulation.strip('.idf')
     Runfile.write('python ' +SimulationName+'.py\n')# <- dit is de inputfile voor GNU Parallels
     position = SimulationName.find('-')
     VentilationSystem = SimulationName[:position].lower()
     System1 = SimulationName[position+1:].lower()
     Family = System1.replace("-","")
     position = Family.find('n')
     FamilyGroup = Family[:position]
     FamilyNumber = Family[position:]
     print 'Family = ' + Family
     print 'Ventilation System = ' + VentilationSystem
     print 'HHGroup = ' + FamilyGroup
     print 'HHNumber = ' + FamilyNumber
     with open (SimulationName+'.py', 'a') as File:
      File.write('#!/usr/bin/env python\n\n')
      File.write('import os\n\n')
      File.write('import os.path\n\n')
      # 1) Run de simulatie in energyplus
      File.write("energypluspath = '/home/generic/EnergyPlus/COMPILED/BUILD/Products' #Location of E+ Program Files\n")
      File.write("os.chdir(energypluspath)\n") 
      
      runstring = "'"+'./energyplus -w /home/generic/EnergyPlus/COMPILED/TestEnergyPlus/Epw/in.epw -d /media/generic/LINDATA/Out/EPW/' + SimulationName + ' -p ' + SimulationName + ' -r ' + '/home/generic/EnergyPlus/COMPILED/TestEnergyPlus/In/'+ simulation +"'"
      File.write('os.system('+runstring+')\n')
      # 2) Controleer de simulatie op fouten
      File.write('#os.system(DetectErrors.py)\n') 
      File.write("os.chdir('/home/generic/EnergyPlus/COMPILED')\n")
      File.write('if os.path.isfile("/media/generic/LINDATA/Out/EPW/' + SimulationName+'/'+SimulationName+'out.csv"):\n') #als er een outputfile bestaat/als er geen fouten zijn.
      File.write('   os.system("python EPLUS_2_SQL_MODES.py '+ SimulationName +'")\n')  # 3) Stop de resultaten in MySQL als de simulatie geen fouten bevat
      #File.write('   os.system("python BENCHMARK3winter.py '+ SimulationName +'")\n')   # 4) Maak een grafiek van de resultaten
      #File.write('   os.system("python BENCHMARK3summer.py '+ SimulationName +'")\n')   # 4) Maak een grafiek van de resultaten
     os.chmod(SimulationName+'.py',stat.S_IRWXU)#Give file executable permissions

     
    

#Shuffle Order of Simulations in Commands.txt, first run N1 FOR ALL systems, then run N2 ... finally run N20

