**_The procedure is awaiting updates_**

The procedure below is a simplified representation of the necessary steps for a complete VCVTB simulation. Specific details per module will be added dropwise.

Simplified presentation of the calculation steps
---------

Preparation and PreProcessing
------------

1) Create a CAD drawing using the appropriate* drawing conventions. Make sure to include AFN objects to automatically generate an airflow network in step 2.

2) Use the VCVTB PreProcessing tools to generate geometrical AFN input for EnergyPlus and to generate geometrical input for OpenFoam. 

3) Create people in Octave using the behaviour module. Use GNU Parallel to batch create family libraries in parallel. Depending on the amount of families that you need this can take a while. It might be interesting to create a library of families for future use. While you wait you can review the paper that was still on your desk.

4) Use CombineSchedules.py to make a single file that includes peopleschedules, activityschedules, CO2schedules... from the output of the behaviour module.

5) Revise the auto-created EnergyPlus .idf file with the AFN. Adjust default material layers, flow exponents and flow coefficients to your liking. Make other adjustments or add extra EnergyPlus components where necessary.

6) Revise the OpenFOAM input, make adjustments and use the OpenFOAM Module to automatically create a mesh and to generate a pressure distribution on the facade for various wind directions. (Waiting can be exciting, but I advise you to go to sleep. These calculations can take a night.)

7) Good morning, grab a coffee and use the provided scripts to extract Cp values from the OpenFoam Model into EnergyPlus .idf format. If you followed the drawing guidelines this should be a matter of seconds.

8) Create EMS Control scripts for the ventilation systems you want to investigate.

AFN Calculations 
------------
9) Make sure that all input files are in the correct folders. If they are you can use GenerateEnergyPlusInput.py to create a mixed input file containing people, Cp values, AFN network components, control systems... and a Command.txt File for running

10) Run.py *** > Runs all idf's in Commands.txt in parallel using GNU Parallel. You can specify the numbers of threads to use. Without further specification all threads are used. 

11) After running use DetectSevereErrors.py to Generate a list with crashed simulations. Mostly errors are due to convergence issues, adapt the AFN convergence limits and rerun the crashed simulations if required.

PostProcessing
------------
If everything went well you are ready to start postprocessing using the postprocessing scripts.
 

Note:
------------

1) VCVTB mixes the simulation order automatically to quickly have output for different ventilation strategy/family combinations. If you have other requirements you have to adjust it in the code. EnergyPlus AFN Calculations are executed in the order specified in the run.txt file

-------------------------------------------------------------------------------------------

2) Use the following rules to run GNU parallel externally

For example:

- parallel < xxx.txt                 #Runs a simulation on all available threads
- parallel --eta < xxx.txt 		#Runs a simulation with an estimated runtime (not very precise)
- parallel --jobs 2 < xxx.txt	#Runs a simulation with a maximum number of parallel jobs e.g. to avoid thermal throttling/shutdown

- If you don't define a number of jobs, the maximal amount of available threads will be used (example 1)
- If the amount of commands in command.txt is larger than the available number of threads, they are put in a waiting list in simulation order. If one thread has finished its current job, the next command in the waiting list will start on this thread. Therefore all resources are always used in an efficient way (never idle).
