 #The Book of VCVTB

A manual to get started with the Ventilation Controls Virtual Test Bed

1) What is VCVTB?
-----------------

VCVTB is an opensource virtual test bed for the accelerated modelling, testing and comparing of single and mixed mode ventilation systems and their control strategies. 
It originated from the doctoral research of ir.arch. Bert Belmans under the supervision of prof.dr.ir.arch Filip Descamps.

2) Why use VCVTB?
-----------------

Although there are programs that can be combined together to get the same job done using cosimulation they don't have a welldefined workflow. VCVTB provides a dedicated holistic approach which saves modellers the timeconsuming task of combining software programs using cosimulation, while still giving full control, by allowing source code level adjustments. In addition VCVTB provides intuitive output. Also, the user model in VCVTB is unique. It allows semi-probabilistic modelling of heat, moisture and carbon dioxide production of semi-probabilistic synthetic users.

3) Hardware Specifications and Software Dependencies
----------------------------------------------------

VCVTB was tested on a workstation with an Intel®Core™ i7-8700K CPU @ 3.70GHz × 12 processor and 32 GB RAM running Ubuntu 18.04.1 LTS 64 bit. 

For an examined case study building (a detached single family house with 11 rooms in a suburban environment) it was possible to run all CFD calculations overnight. After setup, at least 50 AFN simulations could be run during the course of a working day including the automatic generation of tables and graphs. The time per simulation depends on the complexity of the model (number of zones), the complexity of the control strategy used and the window opening time. 

VCVTB was tested with the software dependencies mentioned below.


Python 			(2.7.15rc1) 
pandas 			(0.22.0)
pandas-datareader 	(0.6.0)
plotly 			(3.1.0)
matplotlib 		(2.2.2)
numpy 			(1.15.1)
python-dateutil 	(2.7.3)
scipy 			(0.19.1)
Lazarus-Pascal 		(1.8.2) including LazUtils
SQLAlchemy 		(1.2.10)
mysql 			(14.14 Distrib 5.7.23)
mysql-connector 	(2.1.6)
mysql-utilities 	(1.6.4)
GNU Octave 		(4.4.1)
GNU parallel 		(20161222)
OpenFoam CFD Toolbox 	(3.0.1)
EnergyPlus 		(custom version based on 8.8.0)
Paraview 		(5.4.1)
g++			(7.3.0)
cmake			(3.0)
traces			(0.4.2)

4) Set-up
---------

4.0 Basic Setup

- All files contain generic paths. They should be updated to actual file locations before running VCVTB.
A procedure to automate this is yet to be implemented.

- A local MySQl installation is needed before proceeding. The local mysql folder in which databases are stored should be mounted in VCVTB/2OUT/mysql.

- The behaviour model of Aerts should for now be aquired from the owner. Updated procedures can be found in the VCVTB/1IN/PEOPLE LIBRARY

- The Pascal routines used to generate some of the input and output are based on routines of Daidalos Peutz Bouwfysisch Ingenieursbureau. They are not included in this first build but may be made available in an updated version. These routines read geometric information based on the .DXF12 format and must for now be rebuilt by the user or aquired from the engineering office in question (http://www.daidalospeutz.be). The procedures to generate 3D airflows is included and can be found in VCVTB/4POSTPROCESSING/3DAirflow. 

4.1 Using the Behaviour Model:

Input

The behaviour model is a model to generate energyplus schedules and additional information to allow a better interpretation.

%%supplement

Output 

The output of the people module is a number of .idf files containing schedules for presence, equipment, activity, heat, moisture and carbon dioxide + a Heatproduction.csv file a csv file containing the appliances of the family including their energy rating.

The CombineSchedules.py script combines the seperate idfs for presence, equipment, activity, heat, moisture, carbon dioxide

The ResampleHeatProduction.py script can be used to resample the 10 minute people data from the people model to 1 minute output data for the postprocessing modules. This approach is faster than using the Octave model to generate output data at minute level. The input is te HeatProduction.csv file for a family. The result is a HeatProduction-resampled.csv file

The people folder contains a selection of 7 precreated household types times 20 households per type that were generated using the people model to allow fast simulation. The people model can be used to generate extra households in case this is necessary.

MultiPEOPLE_2_SQL
ParallelPeople


4.2 Using the Airflow Network Model:

Generating Input - Lazarus.

BUILD contains an enhanced version of energyplus for Airflow network simulations


PARAMETRICPREPROCESSOR

The parametric preprocessor folder contains an In and Out folder and a ParametricPreprocessor.py script.
The input file should contain the original idf file with distinct parameter names. The values for these parameters should be defined in the python script. After running the script the output folder contains idf files with all possible combinations

EPW 
	Location to store weather files

OUTSIDE CO2 and CLOTHING csv file

INPUT



	CombinedSchedules folder: Should contain all households to add to the ventilationsystems
	CombinedIDF folder: Temporary folder that is automatically filled and cleaned
	TestEnergyPlus folder:
        SELECTVENTILATIONSYSTEMS folder: BackUp folder with all ventilation systems
	VENTILATIONSYSTEMS folder: Folder with ventilation systems that will be combined in the next run
	
	GenerateEnergyPlusInput.py: This script is used to make combine idfs containing household information with idfs containing ventilation system information. The CombinedIDF folder is uses to store intermediate information. The output is stored in the In folder
	
        CreateRuns.py: This script is used after the GenerateEnergyPlusInput script to generate corresponding python files and a Runfile.txt. The python files contain serial commands to run EnergyPlus simulations and store them in a MySQL database. The Runfile is an input file for GNU parallel that allows parallel execution of multiple simulations using the command ParallelRun.py ("parallel < Runfile.txt") script. Gnu parallels takes care of using all threads of the processor. Once one thread is ready, the next line in the Runfile.txt is executed untill all simulations are ready.

       

OUTPUT
        The Out folder contains the simulation results of all excecuted simulations. A selection of the 	data in this folder is already stored in the MySQL database. However, the data is kept here to 		check for errors. To detect folders containing errors you can use DetectSevereErrors.py. Once 	this is done the oUT folder can be Cleaned using the CleanUp.py script. 

        Power.py This script does a pressure loss calculation for the ductwork and calculates the energy use of the supply and the extract fan. Currently it is only useful for the casestudy. It has yet to be made generally applicable for other configurations of ductwork and fans with other caracteristics using the 3D procedures mentioned above.

FORESTS

We are working on an AI addition to VCVTB to implement random forest based control algorithm for mixed-mode ventilation

4.3 Using the CFD Model:

INPUT

OUTPUT

4.4 Using the Posprocessing Modules and interpreting the results:

	EPLUS_2_SQL.py
	EPLUS_2_SQL_MODES.py
	EPLUS_2_SQL_MODES_AFTER.py
        LAZARUS Airflow script

	BENCHMARK folder
        BOXPLOT folder
	ROBUSTNESS folder

5) Scientific References

VCVTB Builds on reference data and approaches fom the sources below:

[1] D. Aerts, Occupancy and Activity Modelling for Building Energy Demand Simulations, Comparative Feedback and Residential Electricity Demand Characterisation, Phd, Vrije Universiteit Brussel, 2015.

[2] A. Persily, L. de Jonge, Carbon dioxide generation rates for building occupants, Indoor Air 27 (5) (2017) 868–879.

[3] M. S. Owen (Ed.), 2017 ASHRAE Handbook - Fundamentals, W. S. Comstock, Atlanta, si edn., ISBN 1939200571, 2017.

[4] D. M. Hargreaves, N. G. Wright, On the use of the k-e model in commercial CFD software to model the neutral atmospheric boundary layer, Journal of Wind Engineering and Industrial Aerodynamics 95 (5) (2007) 355–369.

[5] J. Minnen, I. Glorieux, T. Pieter van Tienoven, Who works when? Towards a typology of weekly work patterns in Belgium,Time & Society 25 (3) (2016) 652–675.

[6] Food and Agricutural Organization, Human energy requirements: Report of a Joint FAO/WHO/UNU Expert Consultation, Tech. Rep., Food and Agricutural Organization, Rome.

[7] S. Pallin, P. Johansson, C.-E. Hagentoft, Stochastic Modeling of Moisture Supply in Dwellings based on Moisture Production and Moisture Buffering Capacity, Proceedings of Building Simulation 2011: 12th Conference of International Building Performance Simulation Association (2011) 14–16.

[8] L. Braeckevelt, H. Cloots, H. De Kind, E. Hendrickx, BMI Bij Schoolkinderen, Tech. Rep., Agentschap Zorg & Gezondheid Vlaanderen, 2015.

[9] L. Gisle, S. Demarest, Gezondheidsenquête 2013. Rapport 2:Gezondheidsgedrag en leefstijl, Tech. Rep., Wetenschappelijk Instituut Volksgezondheid, Brussels, doi:\bibinfo{doi}{10.1016/j.aqpro.2013.07.003}, 2014.

[10] P. J. Richards, S. E. Norris, Appropriate boundary conditions for computational wind engineering models revisited, Journal of Wind Engineering and Industrial Aerodynamics 99 (4) (2011) 257–266, ISSN 01676105, doi:\bibinfo{doi} {10.1016/j.jweia.2010.12.008}.

[11] S. Reiter, Validation Process for CFD Simulations of Wind Around Buildings, European Built Environment CAE Conference (2008) 1–18.

[12] D. Cóstola, B. Blocken, J. L. Hensen, Overview of pressure coefficient data in building energy simulation and airflow network programs, Building and Environment 44 (10) (2009) 2027–2036,ISSN 03601323, doi:\bibinfo{doi}{10.1016/j.buildenv.2009.02.006}.

[13] M. Orme, M. Liddament, A. Wilson, Numerical Data for Air Infiltration and Natural Ventilation Calculations, Air Infiltration
and Ventilation Centre, Coventry, ISBN 1946075972, 1998.

[14] J. W. Eaton, D. Bateman, S. Hauberg, R. Wehbring, GNU Octave version 4.4.1 manual: a high-level interactive language for
numerical computations, URL https://www.gnu.org/software/octave/doc/v4.4.1/, 2017.

[15] C. G. Henry Weller, M. Janssens, OpenFOAM version 3.0.1:Open source software for computational fluid dynamics (CFD),
URL https://openfoam.org/version/3-0-1/, 2018.

[16] L. Gu, Airflow network modeling in EnergyPlus, in: Proceeding of the 10th International Building Performance Simulation
Association Conference and Exhibition Building Simulation 2007, International Building Performance Simulation Association,Beijing, 964–971, 2007.

[17] M. Schroedter-Homscheidt, The Copernicus Atmosphere Monitoring Service (CAMS) Radiation Service in a nutshell, in: 22nd SolarPACES Conference 2016, Abu Dhabi, 6, doi:\bibinfo{doi}{10.5194/amt-6-2403-2013.}, 2016.

[18] R. Gelaro, W. McCarty, M. J. Surez, R. Todling, A. Molod,L. Takacs, C. A. Randles, A. Darmenov, M. G. Bosilovich,
R. Reichle, K. Wargan, L. Coy, R. Cullather, C. Draper,V. Akella, Santha Buchard, A. Conaty, A. M. da Silva, W. Gu,
G. K. Kim, R. Koster, R. Lucchesi, D. Merkova, J. E. Nielsen,G. Partyka, S. Pawson, W. Putman, M. Rienecker, S. D.
Schubert, M. Sienkiewicz, B. Zhao, The modern-era retrospective analysis for research and applications, version 2 (MERRA-2),
Journal of Climate 30 (14) (2017) 5419–5454, ISSN 08948755,doi:\bibinfo{doi}{10.1175/JCLI-D-16-0758.1}.

[19] U. D. of Energy, EnergyPlus v.8.8 Engineering Reference, U.S.Department of Energy, 2017.

6) Epilogue

7) License Information

VCVTB is licensed under a NonCommercial creative Commons License, CC(nc)
