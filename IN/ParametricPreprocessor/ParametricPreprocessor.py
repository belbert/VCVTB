import itertools
import os
import glob
import shutil
import stat

#MainDirectory
path=os.getcwd()
print path
print'-----------------------------------------------------------------------------------------------------------------'

os.chdir(path+'/In') # Folder with Ventilation Systems
inputfile = glob.glob('*.idf')


OWS = [8] 			# Te hoge windsnelheid -> sluit ramen o.w.v. veiligheid, slaande deuren etc.
AWS = [3] 			# Te lage windsnelheid -> thermische trek = onvoldoende om CO2 weg te ventileren -> helpen met fan C
OT = [10] 		        # Te lage buitentemperatuur -> koude tocht = oncomfortabel -> D
WOF0004 = [0.05,0.1,0.2] 	# LIVING 	Window opening factor 0004
WOF0010 = [0.05,0.1,0.2] 	# SLPKVOOR	Window opening factor 0004
WOF0012 = [0.05,0.1,0.2] 	# ACHTER	Window opening factor 0004
WOF0013 = [0.05,0.1,0.2] 	# OUDERS	Window opening factor 0013
#WOF0014 = [0.05,0.1,0.2,0.3] 	# NACHTHAL Window opening factor 0014

'''OWS = [8] 			#Outdoor Wind Speed
AWS = [2,3] 			#Average 10 min outdoor wind speed
OT = [10,11,12] 		#Outdoor temperature
WOF0004 = [0.05,0.1,0.2,0.3] 	#Window opening factor 0004
WOF0010 = [0.05,0.1,0.2,0.3] 	#Window opening factor 0004
WOF0012 = [0.05,0.1,0.2,0.3] 	#Window opening factor 0004
WOF0013 = [0.05,0.1,0.2,0.3] 	#Window opening factor 0013
WOF0014 = [0.05,0.1,0.2,0.3] 	#Window opening factor 0014'''
i = 0

for parametercomb in itertools.product(OWS, AWS, OT, WOF0004, WOF0010,WOF0012, WOF0013):#, WOF0014):
 
   with open(path+'/In/'+inputfile[0], 'U') as f:
 
       newText=f.read()
 
       while '$OWS' in newText:
        newText=newText.replace('$OWS', str(parametercomb[0]))
 
       while '$AWS' in newText:
        newText=newText.replace('$AWS', str(parametercomb[1]))
 
       while '$OT' in newText:
        newText=newText.replace('$OT', str(parametercomb[2]))

       while '$WOF0004' in newText:
        newText=newText.replace('$WOF0004', str(parametercomb[3]))

       while '$WOF0010' in newText:
        newText=newText.replace('$WOF0010', str(parametercomb[4]))

       while '$WOF0012' in newText:
        newText=newText.replace('$WOF0012', str(parametercomb[5]))

       while '$WOF0013' in newText:
        newText=newText.replace('$WOF0013', str(parametercomb[6]))

       while '$WOF0014' in newText:
        newText=newText.replace('$WOF0014', str(parametercomb[7]))

   os.chdir(path+'/Out')

   with open(inputfile[0].strip('.idf')+str(i)+'.idf', "w") as f:
    f.write(newText)

   i=i+1
