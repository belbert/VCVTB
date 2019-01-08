EXTRA INFO ON HOW TO DEFINE HOUSEHOLD CHARACTERISTICS in Model_TYPE.m 
------------------------------------------------------

- row = member; column1 = Agebin; column2 = employment type 
- agebins: 1 = <18; 2=[18-24], 3=[25-39], 4=[40-54], 5=[55-64], 6=[65-75], 7= >75
- employment: 1=fulltime, 2=parttime, 3=inactive, 4=retired, 5=school
- always order "age" from old to young and "employment" from low to high 
- to include multiple members, separate their characteristics using semicolon ";" 
- children for whom you wish to get occupancy/activities/moisture production should be added as a row in the MyHouseholdCharacteristics array 
* kids up to 18y => [1 5]
* kids between 18 and 25y => [2 5] 

- children for whom you DONT wish to get occupancy/activities/moisture production 
(eg. babies or small children) can be included in the "MyNumberOfYoungChildren" variable. They will still be included in the total household size, which affects the adult's occupancy/activities

IMPORTANT: children should only be included once! Either in the Household Characteristics 
OR the Number of Young Children

EXAMPLES:

--------
- [6 4]            = one retired adult between 65y and 75y
- [3 1; 3 1]       = two adults between 25y and 39y, both working full-time
- [4 1; 4 3; 1 5]  = two adults between 40y and 54y, one working full-time and one unemployed + 1 child between 12y and 18y going to school 


Adaptions and Additions to the Aerts Behaviour Model

New Modules/functions:
----------------------

- ExportToEnergyPlusCustom.m
- GetCustomSchedules.m
- GetMemberMetabolism.m
- GetMemberSurfaceArea.m
- GetMoistureProduction.m
- CheckAvailability.m
- GetApplianceCount.m

Updated Modules:
----------------
- Model_Analysis.m 
- Model_Type.m 
- AnalysePersonalActivitys_TYPE.m
- AnalyseTask_Type.m
- AssignTaskToIndividual.m
- CheckActivitiesCompatibilities.m
- CheckTaskCompatibility.m
- CheckCompatibilities.m
- ExportToEnergyPlusIntervalOneZone.m
- GetApplianceConsumption.m --> Limit number of appliances, Fix appliance Labels
- GetApplianceOwnershipDistribution.m
- GetAppliances.m --> Added linking
- GetClusterNonWorking.m
- GetClusterWorking.m
- GetEnergyConsumption.m
- GetHouseholdActivityPattern.m
- GetHouseholdOccupancyPattern.m
- HouseHoldSelection.m
- HouseHoldSelectionECS.m
- GetMemberType.m
- GetRoutineAgeBin.m
- GetRoutineCluster.m
- GetWeightedData.m
- PlotAverageDailyDistribution.m
- PloatLoadDistribution.m
- ReadActivityFile.m
- ReadECSInput.m
- SimulateHouseholds
- SimulateActivities.m
- SimulateOccupancy.m
- SimulateTasks.m
- WriteAvgActAnnual.m
- WriteAvgOccAnnual.m
- WriteGlobalOutput.m
