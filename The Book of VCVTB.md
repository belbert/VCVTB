The Book of VCVTB - An Overview of Functionalities and Dependencies
-----------------
VCVTB = Ventilation Controls Virtual Test Bed

1.0 What is VCVTB?
-----------------

VCVTB is an opensource EnergyPlus based virtual test bed. It is the translation of a holistic approach for the accelerated modelling, testing and comparing of single and mixed mode ventilation systems and their control strategies. 
It originated from the doctoral research of ir. arch. Bert Belmans under the supervision of prof. dr. ir. arch Filip Descamps.

2.0 Why was VCVTB created?
-----------------
When studying the overall performance of new and existing buildings, modellers need tools to simultaneously consider building energy use as well as user related aspects such as thermal comfort and indoor air quality. VCVTB focusses on a part of this, namely the balance between (auxiliary) energy use (of fans), indoor air quality and user comfort. It was created to study the potential of complex mixed-mode ventilation systems to decrease auxiliary energy use by reappraising the value of natural ventilation and focusing on adaptive comfort. Although there are state of the art programs that can be combined to get a similar job done using co-simulation, they usually don't have a straightforward workflow and researchers must come up with their own custom solutions. This puts a huge brake on further research. In the research field, there was a demand for dedicated simulation tools to stimulate application-oriented research. VCVTB attempts to answer this demand by providing a dedicated holistic approach which saves modellers the time consuming task of combining software programs for BEM and AFN modelling using co-simulation. Moreover, the user model in VCVTB is unique. It allows semi-probabilistic modelling of heat, moisture and carbon dioxide production of synthetic users. In addition VCVTB provides intuitive output. It generates report sheets, comparative tables and 3D airflow drawings. Finally, because VCVTB is an open source tool, researchers can make their own adjustments. By opening up the platform we hope to stimulate further research into mixed-mode ventilation strategies.

3.0 Hardware Specifications and Software Dependencies
----------------------------------------------------

VCVTB was tested on a workstation with an Intel®Core™ i7-8700K CPU @ 3.70GHz × 12 processor and 32 GB RAM running Ubuntu 18.04.1 LTS 64 bit. 

For an examined case study building (a detached single family house with 11 rooms in a suburban environment) it was possible to run all CFD calculations overnight. After setup, at least 50 AFN simulations could be run during the course of a working day including the automatic generation of tables and graphs. The time per simulation mainly depends on the complexity of the model (number of zones), the complexity of the control strategy used and window control schedules. 

----------------------------------------------------

VCVTB was tested with the software dependencies mentioned below.


- Python 			(2.7.15rc1) 
- pandas 			(0.22.0)
- pandas-datareader 	(0.6.0)
- plotly 			(3.1.0)
- matplotlib 		(2.2.2)
- numpy 			(1.15.1)
- python-dateutil 	(2.7.3)
- scipy 			(0.19.1)
- Lazarus-Pascal 		(1.8.2) including LazUtils
- SQLAlchemy 		(1.2.10)
- mysql 			(14.14 Distrib 5.7.23)
- mysql-connector 	(2.1.6)
- mysql-utilities 	(1.6.4)
- GNU Octave 		(4.4.1)
- GNU parallel 		(20161222)
- OpenFoam CFD Toolbox 	(3.0.1)
- EnergyPlus 		(custom version based on 8.8.0)
- Paraview 		(5.4.1)
- g++			(7.3.0)
- cmake			(3.0)
- traces			(0.4.2)

4.0 Workflow
---------

4.1 Points of Attention
---------

- For now all files contain generic paths. They should be updated to actual file locations before running VCVTB.
A procedure to automate this is yet to be implemented.

- A local MySQL installation is needed before proceeding. The local mysql folder in which databases are stored should be mounted in VCVTB/OUT/mysql.

- The original behaviour model of Aerts should for now be aquired from the owner. Updated procedures can be found in the VCVTB/IN/PEOPLE LIBRARY

- The Pascal routines used to generate some of the input and output are based on routines of Daidalos Peutz Bouwfysisch Ingenieursbureau. They are not included in this first build but may be made available in an updated version. These routines read geometric information based on the .DXF12 format. For now similar routines must be rebuilt by the user. The pascal procedure to generate 3D airflows is included in VCVTB/POSTPROCESSING/3DAirflow. However, since it refers to the forementioned routines dependencies must be changed.

4.2 PreProcessing Modules: (Pascal, Python)
---------
**_This section is awaiting updates_**

4.3 CFD Module: (OpenFOAM)
---------
**_This section is awaiting updates_**

4.4 Behaviour Module: (GNU Octave)
---------
**_This section is awaiting updates_**

The behaviour model is a model that generates EnergyPlus compatible user behaviour schedules for multizone airflow network based IAQ simulations. It additionally generates a list of household appliances and their performance labels. It is based on the semi-probabilistic behaviour model of Aerts [1]. It includes activity related sensible heat rates and moisture generation rates based on Pallin [7] and it includes metabolic sensible and latent heat gain rates and carbon dioxide generation rates for building occupants based on Persily [2]. The activity of users is derived semi-probabilistically based on time-use surveys. Depending on the activity, a location, used devices and a metabolism are simulated for every occupant.

The output of the behaviour module is a number of .idf files containing schedules for presence, equipment, activity, heat, moisture and carbon dioxide + a Heatproduction.csv file and a .csv file containing the appliances of a specific family, including their energy rating.

The CombineSchedules.py script combines the seperate idfs for presence, equipment, activity, heat, moisture, carbon dioxide to a single .idf input.

The ResampleHeatProduction.py script can be used to resample the 10 minute people data from the people model to 1 minute output data for the postprocessing modules. This approach is faster than using the Octave model to generate output data at minute level. The input of this module is a HeatProduction.csv file for a family. The result is a HeatProduction-resampled.csv file.

The people model can be used to generate a library of households with variable user characteristics and various appliances with fixed or varying energy performance ratings. 

MultiPEOPLE_2_SQL
ParallelPeople

4.5 Airflow Network Based EnergyPlus Calculation Engine: (Custom EnergyPlus Build)
---------
**_This section is awaiting updates_**

**_A custom EnergyPlus version and an overview of changes made to the original code can be found in the VCVTB/CORE folder._**

- BEM-AFN Input is generated using the Lazarus PreProcessing modules.
- A .csv file with outside CO2 levels should be included to run a simulation
- A clothing .csv file (clo) should be included to run a simulation

PARAMETRICPREPROCESSOR

The parametric preprocessor folder contains an In and Out folder and a ParametricPreprocessor.py script.
The input file should contain the original idf file with distinct parameter names. The values for these parameters should be defined in the python script. After running the script the output folder contains idf files with all possible combinations

EPW 

Location to store weather files

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

4.6 PostProcessing Modules and Results: (MySQL, Python, Pascal)
---------
**_This section is awaiting updates_**

- /POSTPROCESSING/REPORTSHEET: VCVTB Report Sheets
- /POSTPROCESSING/3DAIRFLOW: 3D DXF Airflow Drawings
- /POSTPROCESSING/COMPARATIVETABLE: VCVTB Comparative Tables
	
4.7 Forests Module
---------
**_This section is awaiting updates_**

We are working on an addition to implement random forest based control algorithms into VCVTB. Random forests is an ensemble learning method from the field of artificial intelligence.

5.0 Limitations
-----------------
**_This section is awaiting updates, references should be included_**

*"All models are wrong, but some are useful" (G. Box)*

Although we believe that the VCVTB methodology may be useful to the field of simulation-based ventilation research, it does have its limitations. An airflow network approach is a simplified representation of reality in which predicted conditions in nodes can approximate the indoor environment but can never fully match it. 

- VCVTB makes assumptions for flow coefficients and flow exponents based on values that can be found in the scientific literature to create a functional EnergyPlus model. It is the responsibility of the user to evaluate these assumptions on the basis of the specific characteristics of the studied project.
- Unless the studied building has a very simple geometry and there are few obstacles in the environment, AFN calculations should always be used in combination with a detailed pressure distribution on the building envelope. VCVTB uses simulations in OpenFOAM for this purpose. To use VCVTB in practice CFD generated wind pressure coefficients should be validated with monitoring data.
- In addition to the above, to make accurate predictions it is necessary to use sufficiently fine weather data for stochastic environmental factors such as the wind.
- Unless detailed users are simulated with some degree of stochasticity in their behaviour, predictions are only very general approximations and insufficiently reliable. VCVTB has a semi-probabilistic model to take this into account, however, it needs to be explored in more detail and it must be supplemented with other sources of pollution.
- It would be advisable to model window opening behaviour on the basis of a stochastich algorithm or on measurement data. At the moment VCVTB does not have such a module. In the research field there are stochastic models that are suitable for EnergyPlus that could be implemented in due course.
- Although VCVTB's operation was tested using long-term monitoring data from a case study, further validation is needed to improve and consolidate the software. Feel free to participate.
- An AFN approach is not suitable for modelling large open spaces or atria. For such spaces the mixed-mode approach is not applicable. The modeller must decide for himself whether it is acceptable to split a large space into sub-compartments or to switch to a (combined AFN-) CFD approach.
-There are indications in the literature that airflownetwork models are also less suitable for modelling single-sided ventilation. However, modified models are also available
- ...

A different kind of limitation is that I am a self-learned programmer. Therefore, it is likely that not all functions are implemented equally efficiently and that additional comments are needed. My apologies for that. However, the current implementation gets the work done for which it was designed. For the time being I am satisfied with that, but there will certainly be changes and updates.

6.0 Licensing
-----------------

VCVTB is pending for a NonCommercial creative Commons License.
Feel free to use and adapt the code, but please make a reference. It is greatly appreciated.
For now you can refer to this github page, once a paper is accepted, please refer to the paper.

Don't forget to include the below EnergyPlus reference if you are planning to redistribute adapted versions.

-----------------

EnergyPlus, Copyright (c) 1996-2019, The Board of Trustees of the University of Illinois, The Regents of the University of California, through Lawrence Berkeley National Laboratory (subject to receipt of any required approvals from the U.S. Dept. of Energy), Oak Ridge National Laboratory, managed by UT-Battelle, Alliance for Sustainable Energy, LLC, and other contributors. All rights reserved.

NOTICE: This Software was developed under funding from the U.S. Department of Energy and the U.S. Government consequently retains certain rights. As such, the U.S. Government has been granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, distribute copies to the public, prepare derivative works, and perform publicly and display publicly, and to permit others to do so.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

(1) Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

(2) Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

(3) Neither the name of the University of California, Lawrence Berkeley National Laboratory, the University of Illinois, U.S. Dept. of Energy nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

(4) Use of EnergyPlus(TM) Name. If Licensee (i) distributes the software in stand-alone form without changes from the version obtained under this License, or (ii) Licensee makes a reference solely to the software portion of its product, Licensee must refer to the software as "EnergyPlus version X" software, where "X" is the version number Licensee obtained under this License and may not use a different name for the software. Except as specifically required in this Section (4), Licensee shall not use in a company name, a product name, in advertising, publicity, or other promotional activities any name, trade name, trademark, logo, or other designation of "EnergyPlus", "E+", "e+" or confusingly similar designation, without the U.S. Department of Energy's prior written consent.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

7.0 Scientific References
-----------------

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
