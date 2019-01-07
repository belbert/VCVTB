#
import os
import glob
import shutil


#HoofdDirectory
path=os.getcwd()
print path
print'-----------------------------------------------------------------------------------------------------------------'

if not os.path.exists('CombinedIDF'):
    os.mkdir('CombinedIDF')

os.chdir(path+'/CombinedSchedules') # People
families = glob.glob('*.idf')

os.chdir(path+'/VENTILATIONSYSTEMS') # Ventilation Systems
ventilationsystems = glob.glob('*.idf')


#os.chdir(path+'/CombinedIDF')
os.chdir(path+'/In')

for ventilationsystem in ventilationsystems:
    for family in families:
        path2= path+'/VENTILATIONSYSTEMS/'+ventilationsystem
        path1 = path + '/CombinedSchedules/' + family
        with open(path2,'rb') as ventilationsystemfile:
            with open(path1, 'rb') as familyfile:
                with open(ventilationsystem.strip('.idf')+ '-' +family.strip('.idf')+'.idf', 'wb') as outfile:  # outputfile
                    shutil.copyfileobj(familyfile, outfile)
                    shutil.copyfileobj(ventilationsystemfile, outfile)

#Shuffle Order of Simulations in Commands.txt, first run N1 FOR ALL systems, then run N2 ... finally run N20
'''
for family in families:
    for ventilationsystem in ventilationsystems:
        with open ('Commands.txt', 'a') as commands:
            #string = './energyplus -w in.epw -d ~/Documents/Products/'+ventilationsystem.strip('.idf')+ '-' +family.strip('.idf')+' -p '+ventilationsystem.strip('.idf')+ '-' +family.strip('.idf')+' -r '+ventilationsystem.strip('.idf')+ '-' +family+'\n'
           string = './energyplus -w /home/generic/EnergyPlus/COMPILED/TestEnergyPlus/Epw/in.epw -d /media/generic/LINDATA/Out/EPW/' + ventilationsystem.strip('.idf') + '-' + family.strip('.idf') + ' -p ' + ventilationsystem.strip('.idf') + '-' + family.strip('.idf') + ' -r ' + '/home/generic/EnergyPlus/COMPILED/TestEnergyPlus/In/'+ventilationsystem.strip('.idf') + '-' + family + '\n'

           commands.write(string)

#./energyplus -w /home/generic/EnergyPlus/COMPILED/TestEnergyPlus/Epw/FinalRunPeriodDiffCST.epw -d /media/ARCHmeet/Out/VentSys0D-HH-3131-2-N20 -p VentSys0D-HH-3131-2-N20 -r /home/generic/EnergyPlus/COMPILED/TestEnergyPlus/In/VentSys0D-HH-3131-2-N20.idf
'''
