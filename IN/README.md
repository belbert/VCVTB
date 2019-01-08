Procedure
-------------------------------------------------------------------------------------------
Windows or Linux
-------------------------------------------------------------------------------------------

1) Create people in Octave      > Use GNU Parallel to batch create families in parallel

2) CombineSchedules.py          > Combines peopleschedules, activityschedules, CO2schedules...

3) Create EMS Control scripts  > E+ inputfile zonder schedules

4) GenerateEnergyPlusInput.py 	> Creates Mixed input files and a Command.txt File

-------------------------------------------------------------------------------------------
Linux
-------------------------------------------------------------------------------------------

5) Run.py *** 			> Run all idf's in Commands.txt in parallel using GNU Parallel. You can specify the numbers of threads to use. Without further specification all threads are used. 

6) DetectSevereErrors.py 	> Generates a list with crashed simulations (Mostly errors are due to convergence issues, adapt the relaxation factors of the crashed simulations)

7) Create Graphs using PostProcessing Modules
    
-------------------------------------------------------------------------------------------
***
HOW TO BATCH RUN E+ IN PARALLEL
-------------------------------------------------------------------------------------------

1) Put all .idf files, .epw files and external schedules in the EnergyPlus Folder

-------------------------------------------------------------------------------------------

2) Create a command.txt file containing all desired idf-epw combinations (automated in python)

A command consists of three parts:

	A) It allways starts with './energyplus' to run energyplus

	B) It contains a middle section with extra options

		-w = location of the weatherfile
		-d = location of the output directory
		-p = output prefix

	C) It allways ends with the .idf input file

For example: ./energyplus -w in.epw -d ~/Documents/EnergyPlus/1 -p in1 -r in1.idf

Note:

> List all commands in the desired simulation order! The first command will be executed first
> Make sure that you avoid overwriting output from different simulations by defining an output folder (and prefix)

-------------------------------------------------------------------------------------------

3) Launch GNUParallel to run the commands in commands.txt in parallel

For example:

parallel < commands.txt                 #Runs a simulation on all available threads
parallel --eta < commands.txt 		#Runs a simulation with an estimated runtime (not very precise)
parallel --jobs 2 < commands.txt	#Runs a simulation with a maximum number of parallel jobs e.g. to avoid thermal throttling/shutdown

Note: 

> If you don't define a number of jobs, the maximal amount of available threads will be used (example 1)
> If the amount of commands in command.txt is bigger than the available number of threads, they are put in a waiting list in simulation order
  If one thread has finished its current job, the next command in the waiting list will start on this thread. Therefore all resources are used in the most efficient way.
