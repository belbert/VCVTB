import datetime
import numpy as np
import plotly
from scipy.stats import norm
from plotly import tools
import plotly.graph_objs as go
# import mysql.connector as mysql
# import MySQLdb as mysql
import pandas as pd
import pandas_datareader.data as web
from sqlalchemy import create_engine, MetaData, Table, select
import sys

# ======================================================================================================================
#Show arguments for debugging purposes
# ======================================================================================================================
#print "This is the name of the script: ", sys.argv[0]
#print "Number of arguments: ", len(sys.argv)
#print "The arguments are: ", str(sys.argv)
# ======================================================================================================================

SimulationName = sys.argv[1]
print "SimulationName = " + SimulationName
StartTime = datetime.date(2017, 6, 15)
EndTime = datetime.date(2017, 7, 1)
ElapsedTime = EndTime-StartTime

# ======================================================================================================================
# Divide page in top, bottom and center zone
# ======================================================================================================================
# PAPER
# ======================================================================================================================
# SELECT SYSTEM AND FAMILY
# ======================================================================================================================
#SimulationName = 'VentSys2C-HH5151-1-N1'
position = SimulationName.find('-')
VentilationSystem = SimulationName[:position].lower()
#System1 = 'iaqsimulation'
#System2 = 'modeldorien'
System1 = SimulationName[position+1:].lower()
Family = System1.replace("-","")
print 'Family = ' + Family
print 'Ventilation System = ' + VentilationSystem
#print 'Family = ' + Family
position = Family.find('n')
FamilyGroup = Family[:position]
FamilyNumber = Family[position:]
print 'HHGroup = ' + FamilyGroup
print 'HHNumber = ' + FamilyNumber
NumberOfChildren = int(FamilyGroup[-1:])
NumberOfAdults = len(FamilyGroup.strip('hh')[:-1])/2 #remove children (last character) and remove 'hh', divide the remaining number of characters in the string by two to get the number of adults
People = list()
for i in range(0, NumberOfAdults):
    People.append('Adult'+str(i+1))
for i in range(0, NumberOfChildren):
    People.append('Child'+str(i+1))
print People

#Manual OverridePeople
#People=['Adult1', 'Adult2', 'Child1']
PeopleQuery = "DateTime, " + str(People)[1:-1].replace("'","") #strip square brackets and hyphens from list to make MySQL accept the query
FamilyName = str(FamilyGroup + FamilyNumber).upper()

#Manual Override Family
#FamilyGroup = 'hh51511'
#FamilyName = 'hh51511n1'


# ======================================================================================================================
#Add module to aggregate data if the data size explodes (TO DO)
# ======================================================================================================================

print 'Selecting TimeFrame:', StartTime,'--->', EndTime
#Title = '<b>BENCHMARK REPORT <b>'+System1+'-'+System2+' ('+FamilyName+')'
Title = '<b>'+SimulationName+'   '+StartTime.strftime("%d-%m-%Y")+u' \u2b0c '.encode('utf-8')+EndTime.strftime("%d-%m-%Y")

pixwidth = 2480#3508
pixheight = 3508#2480
#pixwidth = 1600#3508
#pixheight = 1600*3508/2480#2480
pixtop = 300
pixright = 100
pixleft = 200
pixbottom = 200
pixpad = 10

# Legend Position
xlegend=1
ylegend=0.26

lencolorbars = 0.25
widthcolorbars = 20  #pixels

TotalHeight = 1
TopHeight = 0.175
BottomHeight = 0.25
Spacing = 0.05
WidthFraction = 0.97

IntermediateHeight = Spacing/2
CenterHeight = TotalHeight-TopHeight-BottomHeight-Spacing

# TOP
TopWidthFactor = [1/float(3), 1/float(3), 1/float(3), 0, 0, 0, 0, 0, 0, 0]
TopSpacingDivider = [0.5, 0.5]
TotalColumnSpacing = 0.15

# CENTER
HeightFactorGraphs = [1/float(9), 1/float(9), 1/float(9), 1/float(9), 1/float(9), 1/float(9), 1/float(9),1/float(9), 1/float(36), 0, 0]
GraphSpacers = [0,1/float(8),1/float(8),1/float(8),1/float(8),1/float(8),1/float(8),1/float(8),1/float(8)] #KEEP FIRST ELEMENT ZERO!
RowSpacingFactorCenter = 0.15

# BOTTOM
RowSpacingFactorHM = 0.1


# ======================================================================================================================
# IMPORT FAMILY DATA FROM MYSQL
# ======================================================================================================================
#print 'IMPORTING FAMILY DATA FROM MYSQL'
#engine = create_engine('mysql+mysqlconnector://root:password@127.0.0.1/'+Family)
#with engine.connect() as conn:
    #query = """SELECT DateTime FROM `%s` WHERE DateTime BETWEEN '%s' AND '%s'""" % (System1, StartTime, EndTime)
    #rows = conn.execute("SELECT * FROM family")
    #family = pd.DataFrame([[ij for ij in i] for i in rows])

# ======================================================================================================================
# IMPORT VENTILATION SYSTEM DATA FROM MYSQL
# ======================================================================================================================
print 'IMPORTING VENTILATION SYSTEM DATA FROM MYSQL'
#engine = create_engine('mysql+mysqlconnector://root:password@127.0.0.1/family')
engine = create_engine('mysql+mysqlconnector://root:password@127.0.0.1/'+VentilationSystem)
with engine.connect() as conn:

# GET IAQDATA SYSTEM 1
    query = """SELECT * FROM `%s` WHERE DateTime BETWEEN '%s' AND '%s'""" % (System1, StartTime, EndTime)
    rows = conn.execute(query)
    metadata = MetaData(conn) #retrieve metadata
    t = Table(System1, metadata, autoload=True)
    columns = [m.key for m in t.columns]
    iaqsystem1 = pd.DataFrame([[ij for ij in i] for i in rows])
    iaqsystem1.columns = columns #assign mysql column names to pandas columns

# GET IAQDATA SYSTEM 2
    query = """SELECT * FROM `%s` WHERE DateTime BETWEEN '%s' AND '%s'""" % (System1, StartTime, EndTime)
    rows = conn.execute(query)
    metadata = MetaData(conn)
    t = Table(System1, metadata, autoload=True)
    columns = [m.key for m in t.columns]
    iaqsystem2 = pd.DataFrame([[ij for ij in i] for i in rows])
    iaqsystem2.columns = columns #assign mysql column names to pandas columns

# ======================================================================================================================
# IMPORT FAMILY DATA FROM MYSQL
# ======================================================================================================================

engine = create_engine('mysql+mysqlconnector://root:password@127.0.0.1/'+FamilyGroup.upper())
with engine.connect() as conn:
    query1 = ("""SELECT * FROM `%s` WHERE DateTime BETWEEN '%s' AND '%s'""") % (FamilyName, StartTime, EndTime)
    rows = conn.execute(query1)
    metadata = MetaData(conn)
    t = Table(FamilyName, metadata, autoload=True)
    columns = [m.key for m in t.columns]
    df = pd.DataFrame([[ij for ij in i] for i in rows])
    df.columns = columns  # assign mysql column names to pandas columns

# ======================================================================================================================
# DEFINE COLORS
# ======================================================================================================================

ColorEnvironment='rgb(255, 255, 255)'
ColorEntrance='rgb(185, 180, 155)'
ColorStorage='rgb(90, 135, 40)'
ColorToiletDs='rgb(130, 160, 185)'
ColorLiving='rgb(255, 195, 35)'
ColorHal='rgb(140, 105, 80)'
ColorOffice='rgb(250, 130, 40)'
ColorToiletUs='rgb(100, 145, 130)'
ColorBathroom='rgb(0, 140, 155)'
ColorBedroomFront='rgb(205, 70, 125)'
ColorBedroomBack='rgb(160, 65, 95)'
ColorMasterBedroom='rgb(200, 20, 50)'

ColorTemperature='rgb(255, 0, 0)'
ColorRelativeHumidity='rgb(0, 0, 255)'
ColorCO2='rgb(100, 0, 150)'

# ======================================================================================================================
# PREPARE HEATMAPS
# ======================================================================================================================

Activities = ['ElecFood','ElecVacuum','ElecIron','ElecDishes','ElecPC','ElecTV','ElecMusic','ElecStandby','ElecFridge','ElecLights'] #heat
MoistureProduction = ['Bath','Food','Dishes']
#CO2Production = ['CO2','CO22','CO23','CO24']
CO2Production = ['CO2GainsPeopleMasterBedroom','CO2GainsPeopleLiving']
Temperatures = ['TLiving','RHLiving','CO2Living']
VentilationMode = ['MMVFLAG']
ZoneStep = float(1/11)

z = []
z2 = []
z3 = []
z4 = []
z5 = []

print len(df.DateTime)
print len(iaqsystem1.DateTime)

for act in range (0, len(Activities)):
    new_row = []
    for i in range(0, len(df.DateTime)-1):
        new_row.append(df[Activities[act]][i])
    z.append(list(new_row))

for act in range (0, len(MoistureProduction)):
    new_row2 = []
    for i in range(0, len(df.DateTime)-1):
        new_row2.append(df[MoistureProduction[act]][i])
    z2.append(list(new_row2))

for p in range (0, len(CO2Production)):
    new_row3 = []
    for i in range(0, len(iaqsystem1.DateTime)-1):
        new_row3.append(iaqsystem1[CO2Production[p]][i])
    z3.append(list(new_row3))

for p in range (0, len(People)):
    new_row4 = []
    for i in range(0, len(df.DateTime)-1):
        new_row4.append(df[People[p]][i])
    z4.append(list(new_row4))

for flag in range (0, len(VentilationMode)):
    new_row5 = []
    for i in range(0, len(iaqsystem1.DateTime)-1):
        new_row5.append(iaqsystem1[VentilationMode[flag]][i])
    z5.append(list(new_row5))

Activities = ['Food','Vacuum','Iron','Dishes','PC','TV','Music','Standby','Fridge','Lights']
CO2Production = ['Bedroom','Living']
VentilationMode = ['Mode']


# ======================================================================================================================
# ADD TRACES BOTTOM = HEATMAPS
# ======================================================================================================================

trace1 = go.Heatmap(z=z, x=df.DateTime, y=Activities, xaxis='x1', yaxis='y1', legendgroup='group',showlegend=False, showscale =False,
        colorbar=dict(title='Sensible', x=1.0, y=0, yanchor='bottom', thickness=widthcolorbars, len=lencolorbars),
        # RED HEAT Let first 10% (0.1) of the values have color rgb(0, 0, 0)
        colorscale=[[0, 'rgb(255, 255, 255)'], [0.1, 'rgb(255, 160, 160)'],[1.0, 'rgb(255, 0, 0)']]
        )

trace2 = go.Heatmap(z=z2, x=df.DateTime, y=MoistureProduction, xaxis='x1', yaxis='y2', legendgroup='group',showlegend=False, showscale = False,
        colorbar=dict(title='Latent', x=1.05, y=0, yanchor='bottom', len=lencolorbars, thickness=widthcolorbars),
        # BLUE MOISTURE
        colorscale=[[0, 'rgb(255, 255, 255)'],[1.0, 'rgb(0, 0, 255)']]
        )

trace3 = go.Heatmap(z=z3, x=df.DateTime, y=CO2Production, xaxis='x1', yaxis='y3', legendgroup='group',showlegend=False, showscale = False,
        colorbar=dict(title='CO2', x=1.10, y=0, yanchor='bottom', thickness=widthcolorbars, len=lencolorbars),
        # BLACK CO2
        colorscale=[[0, 'rgb(255, 255, 255)'],[1.0, 'rgb(100, 0, 150)']]
        )

trace4 = go.Heatmap(z=z4, x=df.DateTime, y=People, xaxis='x1', yaxis='y4', legendgroup='group',showlegend=False,showscale =False,
        colorbar=dict(title='Room', x=1.15, y=0, yanchor='bottom', thickness=widthcolorbars,
                        #tick0=0,
                        #dtick=1,
                        tickmode='array',
                        tickvals=[11/24.0,33/24.0,55/24.0,77/24.0,99/24.0,121/24.0,143/24.0,165/24.0,187/24.0,209/24.0,231/24.0,253/24.0],
                        ticktext=['Out','Entrance','Storage','Toilet DS','Living','Hal','Office','Toilet US','Bathroom','Bedroom Front','Bedroom Back','Master Bedroom'],
                        ticks='',
                        len=lencolorbars#''=invisible,Outside
                        #showticklabels='False',
                        #tickmode='array',# 'auto','linear','array'
                        #tickvals='list',
                        #ticktext='list'
                        #len = 1, #sets the length of the colorbar

                       ),
        colorscale=[  # Vervangen door discrete colorscale, elke zone krijgt een kleur die in alle grafieken terugkomt step = 1/#zones


        [0, 'rgb(255, 255, 255)'],  # Z0 OUTSIDE / NOT AT HOME
        [1/12.0, 'rgb(255, 255, 255)'],

        [1/12.0, 'rgb(185, 180, 155)'],  # Z1 ENTRANCE
        [2/12.0, 'rgb(185, 180, 155)'],

        [2/12.0, 'rgb(90, 135, 40)'],  # Z2 STORAGE
        [3/12.0, 'rgb(90, 135, 40)'],

        [3/12.0, 'rgb(130, 160, 185)'],  # Z3 WC DOWNSTAIRS
        [4/12.0, 'rgb(130, 160, 185)'],

        [4/12.0, 'rgb(255, 195, 35)'],  # Z4 Living
        [5/12.0, 'rgb(255, 195, 35)'],

        [5/12.0, 'rgb(140, 105, 80)'],  # Z5 HAL
        [6/12.0, 'rgb(140, 105, 80)'],

        [6.0/12, 'rgb(250, 130, 40)'],  # Z6 OFFICE
        [7.0/12, 'rgb(250, 130, 40)'],

        [7/12.0, 'rgb(100, 145, 130)'],  # Z7 WC UPSTAIRS
        [8/12.0, 'rgb(100, 145, 130)'],

        [8/12.0, 'rgb(0, 140, 155)'],  # 8 BATHROOM
        [9/12.0, 'rgb(0, 140, 155)'],

        [9/12.0, 'rgb(205, 70, 125)'],  # 9 BEDROOM FRONT
        [10/12.0, 'rgb(205, 70, 125)'],

        [10/12.0, 'rgb(160, 65, 95)'],   # 10 BEDROOM BACK
        [11/12.0, 'rgb(160, 65, 95)'],

        [11/12.0, 'rgb(200, 20, 50)'],  # 11 MASTER BEDROOM
        [1, 'rgb(200, 20, 50)']

                      ]
        )

trace68 = go.Heatmap(z=z5, x=df.DateTime, y=VentilationMode, xaxis='x1', yaxis='y32', legendgroup='group',showlegend=False, showscale = False,
        # BLACK CO2
        colorscale=[[0, 'rgb(220, 220, 220)'],[1.0, 'rgb(0, 0, 0)']]
        )

# ======================================================================================================================
# ADD TRACES TOP = HISTOGRAMS
# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# PREPARE CUMULATIVE DISTRIBUTIONS
# ----------------------------------------------------------------------------------------------------------------------
CumT = iaqsystem1['TLiving'].values.tolist()
N1=len(CumT)
X1 = np.sort(CumT)
F1 = np.array(range(N1))/float(N1)

CumT2 = iaqsystem2['TMasterBedroom'].values.tolist()
N12=len(CumT2)
X12 = np.sort(CumT2)
F12 = np.array(range(N12))/float(N12)

# ----------------------------------------------------------------------------------------------------------------------

CumRH = iaqsystem1['RHLiving'].values.tolist()
N2=len(CumRH)
X2 = np.sort(CumRH)
F2 = np.array(range(N2))/float(N2)

CumRH2 = iaqsystem2['RHMasterBedroom'].values.tolist()
N22=len(CumRH2)
X22 = np.sort(CumRH2)
F22 = np.array(range(N22))/float(N22)

# ----------------------------------------------------------------------------------------------------------------------

#CumCO2 = iaqsystem1['CO2Living'].values.tolist()
CumCO2 = (iaqsystem1['CO2Living']-iaqsystem1['CO2Environment']).values.tolist()
N3=len(CumCO2)
X3 = np.sort(CumCO2)
F3 = np.array(range(N3))/float(N3)

#CumCO22 = iaqsystem2['CO2MasterBedroom'].values.tolist()
CumCO22 = (iaqsystem2['CO2MasterBedroom']-iaqsystem1['CO2Environment']).values.tolist()
N32=len(CumCO22)
X32 = np.sort(CumCO22)
F32 = np.array(range(N32))/float(N32)


# ----------------------------------------------------------------------------------------------------------------------

# x=x2 RETRIEVE

# TRACE TEMPERATURE HISTOGRAM VENTILATION SYSTEM 1
trace5 = go.Histogram(x=CumT, xbins=dict(start=15,end=35,size=1), marker=dict(color=ColorLiving), opacity=1, xaxis='x2', yaxis='y5', name='RH [%]', legendgroup='group', showlegend=False, histnorm='probability')
# TRACE TEMPERATURE HISTOGRAM VENTILATION SYSTEM 2
trace6 = go.Histogram(x=CumT2, xbins=dict(start=15,end=35,size=1), y=[1], marker=dict(color=ColorMasterBedroom),  opacity=0.5, xaxis='x2', yaxis='y6', name='CO<sub>2 [ppm]', legendgroup='group',showlegend=False, histnorm='probability')
# TRACE CUMULATIVE TEMPERATURE DATA VENTILATION SYSTEM 1
trace7 = go.Scatter(x=X1, y=F1, xaxis='x6', yaxis='y7', name='T [C]', legendgroup='group',showlegend=False, line=dict(color=ColorLiving))
# TRACE CUMULATIVE TEMPERATURE DATA VENTILATION SYSTEM 2
trace18 = go.Scatter(x=X12, y=F12, xaxis='x6', yaxis='y7', name='T [C]', legendgroup='group',showlegend=False, line=dict(color=ColorMasterBedroom))

# ----------------------------------------------------------------------------------------------------------------------
# x=x3

# TRACE RH HISTOGRAM VENTILATION SYSTEM 1
trace8 = go.Histogram(x=CumRH, xbins=dict(start=0,end=100,size=1), marker=dict(color=ColorLiving), opacity=1, xaxis='x3', yaxis='y8', name='RH', legendgroup='group', showlegend=False, histnorm='probability')
# TRACE RH HISTOGRAM VENTILATION SYSTEM 2
trace9 = go.Histogram(x=CumRH2, xbins=dict(start=0,end=100,size=1), marker=dict(color=ColorMasterBedroom), opacity=0.5, xaxis='x3', yaxis='y9', name='CO<sub>2', legendgroup='group', showlegend=False, histnorm='probability')
# TRACE CUMULATIVE RH DATA VENTILATION SYSTEM 1
trace10 = go.Scatter(x=X2, y=F2, xaxis='x7', yaxis='y10', name='T', legendgroup='group', showlegend=False, line=dict(color=ColorLiving))
# TRACE CUMULATIVE RH DATA VENTILATION SYSTEM 2
trace19 = go.Scatter(x=X22, y=F22, xaxis='x7', yaxis='y10', name='T', legendgroup='group', showlegend=False, line=dict(color=ColorMasterBedroom))

# ----------------------------------------------------------------------------------------------------------------------
# x=x4
# TRACE CO2 HISTOGRAM VENTILATION SYSTEM 1
trace14 = go.Histogram(x=CumCO2, xbins=dict(start=0,end=1500,size=25), marker=dict(color=ColorLiving), opacity=1, xaxis='x4', yaxis='y14', name='T', legendgroup='group', showlegend=False, histnorm='probability')
# TRACE CO2 HISTOGRAM VENTILATION SYSTEM 2
trace15 = go.Histogram(x=CumCO22, xbins=dict(start=0,end=1500,size=25), marker=dict(color=ColorMasterBedroom), opacity=0.5, xaxis='x4', yaxis='y15', name='T', legendgroup='group', showlegend=False, histnorm='probability')
# TRACE CUMULATIVE CO2 DATA VENTILATION SYSTEM 1
trace16 = go.Scatter(x=X3, y=F3, xaxis='x8', yaxis='y16', name='T', legendgroup='group', showlegend=False, line=dict(color=ColorLiving))
# TRACE CUMULATIVE CO2 DATA VENTILATION SYSTEM 2
trace20 = go.Scatter(x=X32, y=F32, xaxis='x8', yaxis='y16', name='T', legendgroup='group', showlegend=False, line=dict(color=ColorMasterBedroom))


# ======================================================================================================================
# ADD TRACES MIDDLE
# x=x

#EXTRACTION
trace11 = go.Scatter(x=iaqsystem1.DateTime, y=3600*iaqsystem1.StorageExt, xaxis='x', yaxis='y11', name='Storage', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorStorage, mode='none',hoverinfo='none')
trace25 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.StorageExt+iaqsystem1.ToiletDsExt), xaxis='x', yaxis='y11', name='ToiletDs', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorToiletDs, mode='none',hoverinfo='none')
trace26 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.StorageExt+iaqsystem1.ToiletDsExt+iaqsystem1.LivingExt), xaxis='x', yaxis='y11', name='Living', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorLiving, mode='none',hoverinfo='none')
trace27 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.StorageExt+iaqsystem1.ToiletDsExt+iaqsystem1.LivingExt+iaqsystem1.OfficeExt), xaxis='x', yaxis='y11', name='Office', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorOffice, mode='none',hoverinfo='none')
trace28 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.StorageExt+iaqsystem1.ToiletDsExt+iaqsystem1.LivingExt+iaqsystem1.OfficeExt+iaqsystem1.ToiletUsExt), xaxis='x', yaxis='y11', name='ToiletUs', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorToiletUs, mode='none',hoverinfo='none')
trace29 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.StorageExt+iaqsystem1.ToiletDsExt+iaqsystem1.LivingExt+iaqsystem1.OfficeExt+iaqsystem1.ToiletUsExt+iaqsystem1.BathroomExt), xaxis='x', yaxis='y11', name='Bathroom', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorBathroom, mode='none',hoverinfo='none')
trace30 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.StorageExt+iaqsystem1.ToiletDsExt+iaqsystem1.LivingExt+iaqsystem1.OfficeExt+iaqsystem1.ToiletUsExt+iaqsystem1.BathroomExt+iaqsystem1.BedroomFrontExt), xaxis='x', yaxis='y11', name='Bedroom Front', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorBedroomFront, mode='none',hoverinfo='none')
trace31 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.StorageExt+iaqsystem1.ToiletDsExt+iaqsystem1.LivingExt+iaqsystem1.OfficeExt+iaqsystem1.ToiletUsExt+iaqsystem1.BathroomExt+iaqsystem1.BedroomFrontExt+iaqsystem1.BedroomBackExt), xaxis='x', yaxis='y11', name='Bedroom Back', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorBedroomBack, mode='none',hoverinfo='none')
trace32 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.StorageExt+iaqsystem1.ToiletDsExt+iaqsystem1.LivingExt+iaqsystem1.OfficeExt+iaqsystem1.ToiletUsExt+iaqsystem1.BathroomExt+iaqsystem1.BedroomFrontExt+iaqsystem1.BedroomBackExt+iaqsystem1.MasterBedroomExt), xaxis='x', yaxis='y11', name='Master Bedroom', legendgroup='group', showlegend=False, fill='tonexty', fillcolor=ColorMasterBedroom, mode='none')


#PULSION
trace12 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.LivingSup), xaxis='x', yaxis='y12', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorLiving, mode='none',hoverinfo='none')
trace21 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.LivingSup+iaqsystem1.OfficeSup), xaxis='x', yaxis='y12', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorOffice, mode='none',hoverinfo='none')
trace22 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.LivingSup+iaqsystem1.OfficeSup+iaqsystem1.BedroomFrontSup), xaxis='x', yaxis='y12', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorBedroomFront, mode='none',hoverinfo='none')
trace23 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.LivingSup+iaqsystem1.OfficeSup+iaqsystem1.BedroomFrontSup+iaqsystem1.BedroomBackSup), xaxis='x', yaxis='y12', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorBedroomBack, mode='none',hoverinfo='none')
trace24 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(iaqsystem1.LivingSup+iaqsystem1.OfficeSup+iaqsystem1.BedroomFrontSup+iaqsystem1.BedroomBackSup+iaqsystem1.MasterBedroomSup), xaxis='x', yaxis='y12', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorMasterBedroom, mode='none')

#NATURAL SUPPLY = NS (ramen/cracks)
NSLIVING=iaqsystem1.W1IN+iaqsystem1.W2IN+iaqsystem1.W3IN+iaqsystem1.W4IN+iaqsystem1.W5IN+iaqsystem1.W6IN+iaqsystem1.W7IN+iaqsystem1.W16IN+iaqsystem1.W37IN+iaqsystem1.W38IN+iaqsystem1.VENTLIVINGIN
NSOFFICE=iaqsystem1.W8IN+iaqsystem1.W9IN+iaqsystem1.VENTBUREAUIN
NSBEDROOMFRONT=iaqsystem1.W10IN+iaqsystem1.VENTSLPKVOORIN
NSBATHROOM=iaqsystem1.W11IN
NSBEDROOMBACK=iaqsystem1.W12IN+iaqsystem1.VENTSLPKACHTERIN
NSMASTERBEDROOM=iaqsystem1.W13IN+iaqsystem1.VENTSLPKOUDERSIN
NSHAL=iaqsystem1['W14-1IN'] +iaqsystem1['W14-2IN']+iaqsystem1['W14-3IN']+iaqsystem1['W14-4IN']+iaqsystem1['W15-1IN']+iaqsystem1['W15-2IN']+iaqsystem1['W15-3IN']+iaqsystem1['W15-4IN']
NSENTRANCE=iaqsystem1.W39IN+iaqsystem1.W40IN

#Entrance
trace40 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorEntrance, mode='none',hoverinfo='none')
#Storage
trace41 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE*0), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorStorage, mode='none',hoverinfo='none')
#ToiletDs
trace42 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE*0), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorToiletDs, mode='none',hoverinfo='none')
#Living
trace43 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE+NSLIVING), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorLiving, mode='none',hoverinfo='none')
#Hal
trace44 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE+NSLIVING+NSHAL), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorHal, mode='none',hoverinfo='none')
#Office
trace45 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE+NSLIVING+NSHAL+NSOFFICE), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorOffice, mode='none',hoverinfo='none')
#ToiletUs
trace46 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE*0), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorToiletUs, mode='none',hoverinfo='none')
#Bathroom
trace47 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE+NSLIVING+NSHAL+NSOFFICE+NSBATHROOM), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorBathroom, mode='none',hoverinfo='none')
#BedroomFront
trace48 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE+NSLIVING+NSHAL+NSOFFICE+NSBATHROOM+NSBEDROOMFRONT), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorBedroomFront, mode='none',hoverinfo='none')
#BedroomBack
trace49 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE+NSLIVING+NSHAL+NSOFFICE+NSBATHROOM+NSBEDROOMFRONT+NSBEDROOMBACK), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorBedroomBack, mode='none',hoverinfo='none')
#MasterBedroom
trace50 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NSENTRANCE+NSLIVING+NSHAL+NSOFFICE+NSBATHROOM+NSBEDROOMFRONT+NSBEDROOMBACK+NSMASTERBEDROOM), xaxis='x', yaxis='y24', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorMasterBedroom, mode='none',hoverinfo='none')

#NATURAL EXTRACT = NE (ramen/cracks)
#OUTGOING FLOW THROUGH WINDOWS
NELIVING=iaqsystem1.W1OUT+iaqsystem1.W2OUT+iaqsystem1.W3OUT+iaqsystem1.W4OUT+iaqsystem1.W5OUT+iaqsystem1.W6OUT+iaqsystem1.W7OUT+iaqsystem1.W16OUT+iaqsystem1.W37OUT+iaqsystem1.W38OUT+iaqsystem1.VENTLIVINGOUT
NEOFFICE=iaqsystem1.W8OUT+iaqsystem1.W9OUT+iaqsystem1.VENTBUREAUOUT
NEBEDROOMFRONT=iaqsystem1.W10OUT+iaqsystem1.VENTSLPKVOOROUT
NEBATHROOM=iaqsystem1.W11OUT
NEBEDROOMBACK=iaqsystem1.W12OUT+iaqsystem1.VENTSLPKACHTEROUT
NEMASTERBEDROOM=iaqsystem1.W13OUT+iaqsystem1.VENTSLPKOUDERSOUT
NEHAL=iaqsystem1['W14-1OUT']+iaqsystem1['W14-2OUT']+iaqsystem1['W14-3OUT']+iaqsystem1['W14-4OUT']+iaqsystem1['W15-1OUT']+iaqsystem1['W15-2OUT']+iaqsystem1['W15-3OUT']+iaqsystem1['W15-4OUT']
NEENTRANCE=iaqsystem1.W39OUT+iaqsystem1.W40OUT

#Entrance
trace51 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorEntrance, mode='none',hoverinfo='none')
#Storage
trace52 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE*0), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorStorage, mode='none',hoverinfo='none')
#ToiletDs
trace53 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE*0), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorToiletDs, mode='none',hoverinfo='none')
#Living
trace54 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE+NELIVING), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorLiving, mode='none',hoverinfo='none')
#Hal
trace55 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE+NELIVING+NEHAL), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorHal, mode='none',hoverinfo='none')
#Office
trace56 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE+NELIVING+NEHAL+NEOFFICE), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorOffice, mode='none',hoverinfo='none')
#ToiletUs
trace57 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE*0), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorToiletUs, mode='none',hoverinfo='none')
#Bathroom
trace58 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE+NELIVING+NEHAL+NEOFFICE+NEBATHROOM), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorBathroom, mode='none',hoverinfo='none')
#BedroomFront
trace59 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE+NELIVING+NEHAL+NEOFFICE+NEBATHROOM+NEBEDROOMFRONT), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorBedroomFront, mode='none',hoverinfo='none')
#BedroomBack
trace60 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE+NELIVING+NEHAL+NEOFFICE+NEBATHROOM+NEBEDROOMFRONT+NEBEDROOMBACK), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorBedroomBack, mode='none',hoverinfo='none')
#MasterBedroom
trace61 = go.Scatter(x=iaqsystem1.DateTime, y=3600*(NEENTRANCE+NELIVING+NEHAL+NEOFFICE+NEBATHROOM+NEBEDROOMFRONT+NEBEDROOMBACK+NEMASTERBEDROOM), xaxis='x', yaxis='y25', name='T', legendgroup='group', showlegend=False, fill='tonexty',fillcolor=ColorMasterBedroom, mode='none',hoverinfo='none')




#T/RH/CO2 LIVING
trace13 = go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem1.TLiving.round(1), xaxis='x', yaxis='y13', name='T', legendgroup='group', showlegend=True, line=dict(color=ColorTemperature))
trace33 = go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem1.RHLiving.round(2), xaxis='x', yaxis='y20', name='RH', legendgroup='group', showlegend=True, line=dict(color=ColorRelativeHumidity))
trace34 = go.Scatter(x=iaqsystem1.DateTime, y=(iaqsystem1.CO2Living-iaqsystem1.CO2Environment).round(0), xaxis='x', yaxis='y21', name='CO<sub>2', legendgroup='group', showlegend=True, line=dict(color=ColorCO2), fill='tonexty')

#T/RH/CO2 BEDROOM
trace17 = go.Scatter(x=iaqsystem2.DateTime, y=iaqsystem2.TMasterBedroom.round(1), xaxis='x', yaxis='y17', name='T', legendgroup='group', showlegend=False, line=dict(color=ColorTemperature))
trace35 = go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem2.RHMasterBedroom.round(2), xaxis='x', yaxis='y18', name='RH', legendgroup='group', showlegend=False, line=dict(color=ColorRelativeHumidity))
trace36 = go.Scatter(x=iaqsystem1.DateTime, y=(iaqsystem2.CO2MasterBedroom-iaqsystem1.CO2Environment).round(0), xaxis='x', yaxis='y19', name='CO<sub>2', legendgroup='group', showlegend=False, line=dict(color=ColorCO2), fill='tonexty')
#trace37 = go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem1.CO2MasterBedroom.round(0), xaxis='x', yaxis='y19', name='CO2', legendgroup='group', showlegend=False, line=dict(color='black'))


trace62 = go.Scatter(x=iaqsystem2.DateTime, y=iaqsystem1.WindDirection, xaxis='x', yaxis='y26', name='WD', legendgroup='group', showlegend=False, line=dict(color='rgb(25, 95, 120)'))
trace63= go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem1.WindDirection, xaxis='x', yaxis='y27', name='WD2', legendgroup='group', showlegend=False, line=dict(color='rgb(25, 95, 120)'),hoverinfo='none')
trace67 = go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem1.WindSpeed, xaxis='x', yaxis='y31', name='WS', legendgroup='group', showlegend=False, line=dict(color='lightblue'), fill='tonexty')

#Ext Temp
trace64 = go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem1.TEnvironment, xaxis='x', yaxis='y22', name='T', legendgroup='group', showlegend=False, line=dict(color=ColorTemperature))

#Ext RH
trace65 = go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem1.RHEnvironment, xaxis='x', yaxis='y23', name='RH', legendgroup='group', showlegend=False, line=dict(color=ColorRelativeHumidity))

#Ext RH
trace66 = go.Scatter(x=iaqsystem1.DateTime, y=iaqsystem1.CO2Environment, xaxis='x', yaxis='y30', name='CO<sub>2', legendgroup='group', showlegend=False, line=dict(color=ColorCO2), fill='tonexty')

data = [
        trace1,     # Heatmap Sensible
        trace2,     # Heatmap Latent
        trace3,     # Heatmap CO2
        trace4,     # Heatmap Room
        trace5,     # Temp Histogram Ventilation System 1
        trace6,     # Temp Histogram Ventilation System 2
        trace7,     # Cumulative T ventilation System 1
        trace8,     # RH Histogram Ventilation System 1
        trace9,     # RH Histogram Ventilation System 2
        trace10,    # Cumulative RH ventilation System 1
        trace11,    # Middle
        trace12,    # Middle
        trace13,    # Middle
        trace14,    # CO2 Histogram Ventilation System 1
        trace15,    # CO2 Histogram Ventilation System 2
        trace16,    # Cumulative CO2 ventilation System 1
        trace17,    # middle
        trace18,    # Cumulative T ventilation System 2
        trace19,    # Cumulative RH ventilation System 2
        trace20,    # Cumulative CO2 ventilation System 2
        trace21,    # Cumulative CO2 ventilation System 2
        trace22,    # Cumulative CO2 ventilation System 2
        trace23,    # Cumulative CO2 ventilation System 2
        trace24,    # Cumulative CO2 ventilation System 2
        trace25,    # Cumulative CO2 ventilation System 2
        trace26,    # Cumulative CO2 ventilation System 2
        trace27,    # Cumulative CO2 ventilation System 2
        trace28,    # Cumulative CO2 ventilation System 2
        trace29,    # Cumulative CO2 ventilation System 2
        trace30,    # Cumulative CO2 ventilation System 2
        trace31,    # Cumulative CO2 ventilation System 2
        trace32,    # Cumulative CO2 ventilation System 2
        trace33,    # Cumulative CO2 ventilation System 2
        trace34,    # Cumulative CO2 ventilation System 2
        trace35,    # Cumulative CO2 ventilation System 2
        trace36,    # Cumulative CO2 ventilation System 2
        #trace37,    # Cumulative CO2 ventilation System 2
        trace40,    # Natural Supply Entrance
        #trace41,    # Natural Supply Storage
        #trace42,    # Natural Supply ToiletDs
        trace43,    # Natural Supply Living
        trace44,    # Natural Supply Hal
        trace45,    # Natural Supply Office
        #trace46,    # Natural Supply ToiletUs
        trace47,    # Natural Supply Bathroom
        trace48,    # Natural Supply Bedroom Front
        trace49,    # Natural Supply Bedroom Back
        trace50,    # Natural Supply Master Bedroom
     trace51,    # Natural Supply Entrance
        #trace52,    # Natural Supply Storage
        #trace53,    # Natural Supply ToiletDs
     trace54,    # Natural Supply Living
     trace55,    # Natural Supply Hal
     trace56,    # Natural Supply Office
        #trace57,    # Natural Supply ToiletUs
     trace58,    # Natural Supply Bathroom
     trace59,    # Natural Supply Bedroom Front
     trace60,    # Natural Supply Bedroom Back
     trace61,    # Natural Supply Master Bedroom
     trace62,    # Natural Supply Master Bedroom
     trace63,    # Natural Supply Master Bedroom
     trace64,  # Outside Temperature
     trace65,  # Outside Relative Humidity
     trace66,
     trace67,   
     trace68,   
        ]


# ======================================================================================================================
# DISTRIBUTE TOP
# ======================================================================================================================
# Use TopHeight fully = 1 row
# Divide Topwidth

NumTopColumns = np.count_nonzero(TopWidthFactor)
ColumnSpacing = TotalColumnSpacing/(NumTopColumns-1)
ColumnWidth = WidthFraction-TotalColumnSpacing
Column = dict()
for i in range(0,NumTopColumns):
    Column[i+1] = ColumnWidth*TopWidthFactor[i]

# ======================================================================================================================
# DISTRIBUTE BOTTOM (HEATMAPS)
# ======================================================================================================================

TotalBottomHeight = BottomHeight
NumHMs = 5
HMRows = float(len(Activities)+len(MoistureProduction)+len(CO2Production)+len(People)+len(VentilationMode))

TotalRowSpacing = RowSpacingFactorHM*TotalBottomHeight
RowSpacing = (TotalRowSpacing/(NumHMs-1))
HMRowHeight = (TotalBottomHeight-TotalRowSpacing)/HMRows

HeightOne = float(len(Activities))*HMRowHeight
HeightTwo = float(len(MoistureProduction))*HMRowHeight
HeightThree = float(len(CO2Production))*HMRowHeight
HeightFour = float(len(People))*HMRowHeight
HeightFive = float(len(VentilationMode))*HMRowHeight

print ''
print '0', HeightOne
print HeightOne+RowSpacing, HeightOne+RowSpacing+HeightTwo
print HeightOne+RowSpacing+HeightTwo+RowSpacing, HeightOne+RowSpacing+HeightTwo+RowSpacing+HeightThree
print HeightOne+RowSpacing+HeightTwo+RowSpacing+HeightThree+RowSpacing,HeightOne+RowSpacing+HeightTwo+RowSpacing+HeightThree+RowSpacing+HeightFour
print HeightOne+RowSpacing+HeightTwo+RowSpacing+HeightThree+RowSpacing+HeightFour+RowSpacing,HeightOne+RowSpacing+HeightTwo+RowSpacing+HeightThree+RowSpacing+HeightFour+RowSpacing+HeightFive
print ''

# ======================================================================================================================
# DISTRIBUTE CENTER
# ======================================================================================================================

TotalHeightCenter = CenterHeight
RowSpacingCenter = RowSpacingFactorCenter*TotalHeightCenter
NumGraphs = np.count_nonzero(HeightFactorGraphs)

GraphHeight = (TotalHeightCenter-RowSpacingCenter)/NumGraphs

StartCenterHeight = BottomHeight+IntermediateHeight

HeightGraph = dict()

StartGraph = dict()
StopGraph =  dict()
StartGraph[0]= StartCenterHeight
StopGraph[0]= StartCenterHeight

for i in range(0,NumGraphs):

    StartGraph[i+1] = StopGraph[i]+GraphSpacers[i]*RowSpacingCenter #start van eerste grafiek = stop vorige grafiek + graphspacers
    StopGraph[i+1] = StopGraph[i]+GraphSpacers[i]*RowSpacingCenter+(TotalHeightCenter-RowSpacingCenter)*HeightFactorGraphs[i]

    print 'StartGraph ', i, ' ', StartGraph[i]
    print 'StopGraph ', i, ' ', StopGraph[i]
    #print (StopGraph[i]-StartGraph[i])*pixheight
    print ''



# ======================================================================================================================
# DEFINE LAYOUT
# ======================================================================================================================

layout = go.Layout(

    width=pixwidth,
    height=pixheight,
    margin=go.Margin(l=pixleft, r=pixright, b=pixbottom, t=pixtop, pad=pixpad),
    #paper_bgcolor='#7f7f7f',#
    #plot_bgcolor='#c7c7c7',#
    legend=dict(x=xlegend, y=ylegend),
    showlegend=False,
    title=Title,
    titlefont={"size": 40, "family": "Georgia, georgia"},
    barmode='overlay',
    font=dict( # family="Droid Serif, serif",
        family="Georgia, georgia",
        color='#635F5D',
        size=24),

    # ------------------------------------------------------------------------------------------------------------------

    # Time Bottom
    xaxis=dict(title='', domain=[0, WidthFraction], type='date', tickformat='%d/%m %H:%M', ticklen=8, tickangle=45, ticks='outside', nticks=24, showgrid=True),

    # Histogram T
    xaxis2=dict(title='T', position=TotalHeight-TopHeight-pixpad/float(pixheight), domain=[0, Column[1]], ticklen=8, tickangle=45, ticks='outside', nticks=24, showgrid=False, range=[15,35],showline=True),

    # Histogram RH
    xaxis3=dict(title='RH', position=TotalHeight-TopHeight-pixpad/float(pixheight), domain=[Column[1]+ColumnSpacing, Column[1]+ColumnSpacing+Column[2]], ticklen=8, tickangle=45, ticks='outside', nticks=24, showgrid=False, range=[0,100],showline=True),

    # Histogram CO2
    xaxis4=dict(title='CO<sub>2', position=TotalHeight-TopHeight-pixpad/float(pixheight), domain=[Column[1]+2*ColumnSpacing+Column[2], Column[1]+2*ColumnSpacing+Column[2]+Column[3]], ticklen=8, tickangle=45, ticks='outside', nticks=24, showgrid=False, range=[0,1000],showline=True),

    # Time Center
    #xaxis5=dict(title='', domain=[0, WidthFraction], type='date', position=StartCenterHeight-pixpad/float(pixheight), tickformat='%d/%m %H:%M', ticklen=8, tickangle=45, ticks='outside', nticks=24, showgrid=False),

    # Cumulative T
    xaxis6=dict(title='', position=TotalHeight, overlaying='x2',side='top', domain=[0, Column[1]], ticklen=8, tickangle=45, ticks='outside', dtick=0.5, nticks=24, showgrid=False,showline=True),

    # Cumulative RH
    xaxis7=dict(title='Cumulative', position=TotalHeight, overlaying='x3',side='top', domain=[Column[1]+ColumnSpacing, Column[1]+ColumnSpacing+Column[2]], ticklen=8, tickangle=45, ticks='outside', dtick=5, showgrid=False,showline=True),

    # Cumulative CO2
    xaxis8=dict(title='', position=TotalHeight, overlaying='x4',side='top', domain=[Column[1]+2*ColumnSpacing+Column[2], Column[1]+2*ColumnSpacing+Column[2]+Column[3]], ticklen=8, tickangle=45, ticks='outside', nticks=24, showgrid=False,showline=True),

    # DataTable
    xaxis9=dict(title='', position=StopGraph[6], domain=[Column[1], WidthFraction], ticklen=8, tickangle=45, showticklabels=False, ticks='', showgrid=False,showline=False),



    #print (StopGraph[5]-StartGraph[5])*pixheight
#print (((StopGraph[5]-StartGraph[5])*pixheight)/pixwidth)*pixwidth

    # ------------------------------------------------------------------------------------------------------------------
    # HEATMAPS Y-position
    # ------------------------------------------------------------------------------------------------------------------

    #
    yaxis=dict(title='', domain=[0, HeightOne], ticks='outside', ticklen=8, zeroline=False),
    #
    yaxis2=dict(title='', domain=[HeightOne+RowSpacing, HeightOne+RowSpacing+HeightTwo], anchor='x1', ticks='outside', ticklen=8, zeroline=False),
    # CO2
    yaxis3=dict(title='', domain=[HeightOne+RowSpacing+HeightTwo+RowSpacing, HeightOne+RowSpacing+HeightTwo+RowSpacing+HeightThree], anchor='x1', ticks='outside', ticklen=8, zeroline=False),
    # People
    yaxis4=dict(title='', domain=[HeightOne+RowSpacing+HeightTwo+RowSpacing+HeightThree+RowSpacing,HeightOne+RowSpacing+HeightTwo+RowSpacing+HeightThree+RowSpacing+HeightFour], anchor='x1', ticks='outside', ticklen=8, zeroline=False),
  
    # ------------------------------------------------------------------------------------------------------------------
    # TOP ROW Y-position
    # ------------------------------------------------------------------------------------------------------------------

    #T
    yaxis5=dict(title='Histograms %',     domain=[TotalHeight-TopHeight, TotalHeight-(pixpad)/float(pixheight)],    anchor='x2', ticklen=8,                     side='left',    showgrid=False, ticks='outside',           showticklabels=True,   dtick=0.1,  zeroline=False,showline=True),
    #
    yaxis6=dict(title='',     domain=[TotalHeight-TopHeight, TotalHeight-(pixpad)/float(pixheight)],    anchor='x2', ticklen=8, overlaying='y5',    side='left',    showgrid=False, ticks='',           showticklabels=False,   dtick=0.1,   zeroline=False),
    #
    yaxis7=dict(title='',      domain=[TotalHeight-TopHeight, TotalHeight-(pixpad)/float(pixheight)],    anchor='x2', ticklen=8, overlaying='y5',    side='right',   showgrid=False, ticks='outside',    showticklabels=True,    dtick=0.1,  zeroline=False, range=[0,1],showline=True),

    #  -----------------------------------------------------------------------------------------------------------------

    #RH
    yaxis8=dict(title='',    domain=[TotalHeight-TopHeight, TotalHeight-(pixpad)/float(pixheight)],    anchor='x3', ticklen=8,                     side='left',    showgrid=False, ticks='outside',           showticklabels=True,   dtick=0.1,  zeroline=False,showline=True ),
    #
    yaxis9=dict(title='',    domain=[TotalHeight-TopHeight, TotalHeight-(pixpad)/float(pixheight)],    anchor='x3', ticklen=8, overlaying='y8',    side='left',    showgrid=False, ticks='',           showticklabels=False,   dtick=0.1,   zeroline=False, ),
    #
    yaxis10=dict(title='',     domain=[TotalHeight-TopHeight,TotalHeight-(pixpad)/float(pixheight)],     anchor='x3', ticklen=8, overlaying='y8',    side='right',   showgrid=False, ticks='outside',    showticklabels=True,    dtick=0.1,  zeroline=False, range=[0,1],showline=True),

    # ------------------------------------------------------------------------------------------------------------------

    # CO2 range=[300,1500]
    yaxis14=dict(title='',      domain=[TotalHeight-TopHeight, TotalHeight-(pixpad)/float(pixheight)],    anchor='x4', ticklen=8,                     side='left',    showgrid=False, ticks='outside',           showticklabels=True,   dtick=0.1,  zeroline=False,showline=True),
    #
    yaxis15=dict(title='',  domain=[TotalHeight-TopHeight, TotalHeight-(pixpad)/float(pixheight)],    anchor='x4', ticklen=8, overlaying='y14',   side='left',    showgrid=False, ticks='',           showticklabels=False,   dtick=0.1,  zeroline=False),
    #
    yaxis16=dict(title='Cumulative Density Function %',     domain=[TotalHeight-TopHeight, TotalHeight-(pixpad)/float(pixheight)],    anchor='x4', ticklen=8, overlaying='y14',   side='right',   showgrid=False, ticks='outside',    showticklabels=True,    dtick=0.1,  zeroline=False, range=[0,1],showline=True),

    # ------------------------------------------------------------------------------------------------------------------
    # Center Y-Position
    # ------------------------------------------------------------------------------------------------------------------
  # Fans
    #
    yaxis11=dict(title='Q<sub>MEx</sub>', domain=[StartGraph[3], StopGraph[3]], anchor='x1', ticklen=8,side='left', showticklabels=True, showgrid=False,ticks='outside',dtick=100, zeroline=True, range=[0,450]),
    #
    yaxis12=dict(title='Q<sub>MS</sub>', domain=[StartGraph[4], StopGraph[4]], anchor='x1', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=100, zeroline=True, range=[0,450]),
    #
    yaxis24=dict(title='Q<sub>NS</sub>', domain=[StartGraph[6], StopGraph[6]], anchor='x1', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=100, zeroline=True, range=[0,450]),
    #
    yaxis25=dict(title='Q<sub>NEx</sub>', domain=[StartGraph[5], StopGraph[5]], anchor='x1', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=100, zeroline=True, range=[0,450]),
    #
    yaxis26=dict(title='WD',domain=[StartGraph[7], StopGraph[7]], anchor='x1', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=60, zeroline=False, range=[0, 360]),
    #
    yaxis27=dict(title='',domain=[StartGraph[7], StopGraph[7]], position=1, overlaying='y26', ticklen=8, side='left', showticklabels=False, showgrid=False, ticks='outside', dtick=72, zeroline=False, range=[0,360]),
    #
    yaxis31=dict(title='WS',domain=[StartGraph[7], StopGraph[7]], position=1, overlaying='y26', ticklen=8, side='right', showticklabels=True, showgrid=False, ticks='outside', dtick=2, zeroline=False,showline=True, range=[0,10]),
    #
    yaxis28=dict(title='T<sub>Env', domain=[StartGraph[6], StopGraph[6]], anchor='x1', overlaying='y24', ticklen=8, side='right', showticklabels=True, showgrid=False, ticks='outside', dtick=5, zeroline=True,),
    #
    yaxis29=dict(title='RH<sub>Env', domain=[StartGraph[5], StopGraph[5]], anchor='x1', overlaying='y25', ticklen=8, side='right', showticklabels=True, showgrid=False, ticks='outside', dtick=10, zeroline=True, range=[0, 100]),
    #
    yaxis32=dict(title='', domain=[StartGraph[9], StopGraph[9]], anchor='x1', ticks='outside', ticklen=8, zeroline=False),

    #
    yaxis13=dict(title='T<sub>Liv',domain=[StartGraph[2], StopGraph[2]], anchor='x1', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=5, zeroline=False, range=[15, 30]),
    #
    yaxis20=dict(title='',domain=[StartGraph[2], StopGraph[2]], position=1, overlaying='y13', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=10, zeroline=False, range=[20,70]),
    #
    yaxis21=dict(title='RH/CO<sub>2',domain=[StartGraph[2], StopGraph[2]], position=1, overlaying='y13', ticklen=8, side='right', showticklabels=True, showgrid=False, ticks='outside', dtick=200, zeroline=False,showline=True, range=[0,1000]),

    #
    yaxis17=dict(title='T<sub>Bed', domain=[StartGraph[1], StopGraph[1]], anchor='x1', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=5, zeroline=False, range=[15, 30]),

    yaxis18=dict(title='', domain=[StartGraph[1], StopGraph[1]], position=1, overlaying='y17', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=10, zeroline=False, range=[20,70]),

    yaxis19=dict(title='RH/CO<sub>2', domain=[StartGraph[1], StopGraph[1]], position=1, overlaying='y17', ticklen=8, side='right', showticklabels=True, showgrid=False, ticks='outside', dtick=200, zeroline=False,showline=True, range=[0,1000]),

    #Tabel
    yaxis22=dict(title='T<sub>Ext', domain=[StartGraph[8], StopGraph[8]], anchor='x1', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=5, zeroline=False),

    
    yaxis23=dict(title='', domain=[StartGraph[8], StopGraph[8]], position=1, overlaying='y22', ticklen=8, side='left', showticklabels=True, showgrid=False, ticks='outside', dtick=25, zeroline=False, range=[0, 100]),

    yaxis30=dict(title='RH/CO<sub>2', domain=[StartGraph[8], StopGraph[8]], position=1, overlaying='y22', ticklen=8, side='right', showticklabels=True, showgrid=False, ticks='outside', dtick=50, zeroline=False, showline=True, range=[300,500]),


    # ------------------------------------------------------------------------------------------------------------------
    # Add Markup
    # ------------------------------------------------------------------------------------------------------------------


    shapes=[
        # --------------------------------------------------------------------------------------------------------------
        # HISTOGRAM T x = x2
        # --------------------------------------------------------------------------------------------------------------
        #{'type': 'rect', 'xref': 'x2', 'yref': 'y7', 'x0': 15, 'y0': -0.3, 'x1': 16, 'y1': 0, 'fillcolor': 'red', 'opacity': 0.5, 'line': {'width': 0}},

        #{'type': 'rect', 'xref': 'x2', 'yref': 'y7', 'x0': 16, 'y0': -0.3, 'x1': 25, 'y1': 0, 'fillcolor': 'green', 'opacity': 0.5, 'line': {'width': 0}},

        #{'type': 'rect', 'xref': 'x2', 'yref': 'y7', 'x0': 25, 'y0': -0.3, 'x1': 26.5, 'y1': 0, 'fillcolor': 'yellow', 'opacity': 0.5, 'line': {'width': 0, }},

        #{'type': 'rect', 'xref': 'x2', 'yref': 'y7', 'x0': 26.5, 'y0': -0.3, 'x1': 28, 'y1': 0, 'fillcolor': 'orange', 'opacity': 0.5, 'line': {'width': 0, }},

        #{'type': 'rect', 'xref': 'x2', 'yref': 'y7', 'x0': 28, 'y0': -0.3, 'x1': 35, 'y1': 0, 'fillcolor': 'red', 'opacity': 0.5, 'line': {'width': 0, }},

        {'type': 'line', 'xref': 'x2', 'yref': 'y7', 'x0': 25.5, 'y0': 0, 'x1': 25.5, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot',}},

        {'type': 'line', 'xref': 'x2', 'yref': 'y7', 'x0': 26, 'y0': 0, 'x1': 26, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot',}},

        {'type': 'line', 'xref': 'x2', 'yref': 'y7', 'x0': 27, 'y0': 0, 'x1': 27, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot',}},

        # --------------------------------------------------------------------------------------------------------------
        # HISTOGRAM RH x = x3
        # --------------------------------------------------------------------------------------------------------------

        #{'type': 'rect', 'xref': 'x3', 'yref': 'y10', 'x0': 0, 'y0': -0.3, 'x1': 20, 'y1': 0, 'fillcolor': 'red', 'opacity': 0.5, 'line': {'width': 0}},

        #{'type': 'rect', 'xref': 'x3', 'yref': 'y10', 'x0': 20, 'y0': -0.3, 'x1': 30, 'y1': 0, 'fillcolor': 'orange', 'opacity': 0.5, 'line': {'width': 0}},

        #{'type': 'rect', 'xref': 'x3', 'yref': 'y10', 'x0': 30, 'y0': -0.3, 'x1': 60, 'y1': 0, 'fillcolor': 'green', 'opacity': 0.5, 'line': {'width': 0}},

        #{'type': 'rect', 'xref': 'x3', 'yref': 'y10', 'x0': 60, 'y0': -0.3, 'x1': 70, 'y1': 0, 'fillcolor': 'orange', 'opacity': 0.5, 'line': {'width': 0}},

        #{'type': 'rect', 'xref': 'x3', 'yref': 'y10', 'x0': 70, 'y0': -0.3, 'x1': 100, 'y1': 0, 'fillcolor': 'red', 'opacity': 0.5, 'line': {'width': 0}},

        {'type': 'line', 'xref': 'x3', 'yref': 'y10', 'x0': 20, 'y0': 0, 'x1': 20, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot'}},

        {'type': 'line', 'xref': 'x3', 'yref': 'y10', 'x0': 25, 'y0': 0, 'x1': 25, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot'}},

        {'type': 'line', 'xref': 'x3', 'yref': 'y10', 'x0': 30, 'y0': 0, 'x1': 30, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot'}},

        {'type': 'line', 'xref': 'x3', 'yref': 'y10', 'x0': 50, 'y0': 0, 'x1': 50, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot'}},

        {'type': 'line', 'xref': 'x3', 'yref': 'y10', 'x0': 60, 'y0': 0, 'x1': 60, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot'}},

        {'type': 'line', 'xref': 'x3', 'yref': 'y10', 'x0': 70, 'y0': 0, 'x1': 70, 'y1': 1, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot', }},

        # --------------------------------------------------------------------------------------------------------------
        # HISTOGRAM CO2 x = x4 (IDA1 = < 400, IDA2 < 600<, IDA3 < 1000) in principe boven buitenconcentratie
        # --------------------------------------------------------------------------------------------------------------

        #{'type': 'rect', 'xref': 'paper', 'yref': 'paper', 'x0': (Column[1]+2*ColumnSpacing+Column[2]), 'y0': TotalHeight-TopHeight-2*pixpad/float(pixheight), 'x1': (Column[1]+2*ColumnSpacing+Column[2])+((Column[1]+2*ColumnSpacing+Column[2]+Column[3])-(Column[1]+2*ColumnSpacing+Column[2]))*450/float(1500), 'y1': TotalHeight-TopHeight-pixpad/float(pixheight), 'fillcolor': 'green', 'opacity': 0.5, 'line': {'width': 0}},

        #{'type': 'rect', 'xref': 'x4', 'yref': 'y16', 'x0': 0, 'y0': -0.3, 'x1': 400, 'y1': 0, 'fillcolor': 'green', 'opacity': 0.5, 'line': {'width': 0}},

        {'type': 'line', 'xref': 'x4', 'yref': 'y16', 'x0': 400, 'y0': -0.3, 'x1': 400, 'y1': 7, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot'}},

        #{'type': 'rect', 'xref': 'x4', 'yref': 'y16', 'x0': 400, 'y0': -0.3, 'x1': 600, 'y1': 0, 'fillcolor': 'orange', 'opacity': 0.5, 'line': {'width': 0}},

        {'type': 'line', 'xref': 'x4', 'yref': 'y16', 'x0': 600, 'y0': -0.3, 'x1': 600, 'y1': 7, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot'}},

        #{'type': 'rect', 'xref': 'x4', 'yref': 'y16', 'x0': 600, 'y0': -0.3, 'x1': 1000, 'y1': 0,'fillcolor': 'red', 'opacity': 0.5, 'line': {'width': 0}},

        {'type': 'line', 'xref': 'x4', 'yref': 'y16', 'x0': 1000, 'y0': -0.3, 'x1': 1000, 'y1': 7, 'line': {'color': 'black', 'width': 1, 'dash': 'dashdot'}},

        #{'type': 'rect', 'xref': 'x4', 'yref': 'y16', 'x0': 1000, 'y0': -0.3, 'x1': 3000, 'y1': 0, 'fillcolor': 'red', 'opacity': 0.8, 'line': {'width': 0}}


    ],

    # table text


)







# plot Heatmap
# -----------------------------------------------------------------------------------------------------------------------

fig = go.Figure(data=data, layout=layout)
plotly.offline.plot(fig,filename='/media/generic/LINDATA/Graphs/Monthly/May/'+SimulationName+'-'+StartTime.strftime("%d-%m-%Y")+'.html', auto_open=False)
#plotly.offline.plot(fig,image_filename='/home/generic/EnergyPlus/COMPILED/GRAPHS/'+SimulationName, image='svg', image_width=2480, image_height=3508)
#plotly.offline.plot(fig,filename='C:\Users/generic\Downloads\Compare.svg', auto_open=False, image='svg', image_width=2480, image_height=3508,image_filename='Compare')
