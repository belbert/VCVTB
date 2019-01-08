#
import os
import glob
import shutil

#Main Directory
path=os.getcwd()
print path
print'--------------'

#Get SubDirectories
folders=next(os.walk(path))[1]


for folder in folders:

    print folder+':'
    folderpath = path+'/'+folder
    os.chdir(folderpath) #Change directory to current folder
    #print os.getcwd()+'\n'

    sub=os.getcwd()
    subfolders = next(os.walk(sub))[1]


    for subfolder in subfolders:
        print '    ' + subfolder
        subfolderpath = path+'/'+folder+'/'+subfolder
        #print subfolderpath
        os.chdir(subfolderpath)
# Combine idfs in folder

        with open(str(subfolder)+'_Combined.txt', 'wb') as wfd:
           for idf in glob.glob('*.idf'):
              with open(idf,'rb') as fd:
                   shutil.copyfileobj(fd,wfd)

# Replace text

        with open(str(subfolder)+'_Combined.txt') as wfd:
            newText = wfd.read().replace('Z11', 'SLPKOUDERS')
            newText = newText.replace('Z10', 'SLPKACHTER')
            newText = newText.replace('Z9', 'SLPKVOOR')
            newText = newText.replace('Z8', 'BADKAMER')
            newText = newText.replace('Z7', 'WCBOVEN')
            newText = newText.replace('Z6', 'BUREAU')
            newText = newText.replace('Z5', 'NACHTHAL')
            newText = newText.replace('Z4', 'LIVING')
            newText = newText.replace('Z3', 'WCBENEDEN')
            newText = newText.replace('Z2', 'BERGING')
            newText = newText.replace('Z1', 'HAL')
            newText = newText.replace('ZONE Work Eff. Schedule', 'work eff sch')
            newText = newText.replace('ZONE Clothing Schedule', 'clothing sch')
            newText = newText.replace('ZONE Air velocity Schedule', 'air velo sch')

# Schrijf aangepaste tekst
        os.chdir(path) #Change directory to main folder
        if not os.path.exists('CombinedSchedules'):
            os.mkdir('CombinedSchedules')
        os.chdir(path+'/CombinedSchedules')
        with open(str(subfolder)+'.idf', "w") as wfd:
            wfd.write(newText)
