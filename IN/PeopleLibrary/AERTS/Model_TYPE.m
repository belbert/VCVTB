%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%~~ MODEL BASED ON HOUSEHOLD TYPES  ~~
%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%----------------------------------------------------------------------------------
% FILE STRUCTURE:
%----------------------------------------------------------------------------------
% \Documentation includes a user manual and some reference data
% \Functions includes all functions that are called by this script
% \Input is for non-public input files (eg. containing TUS data)
% \Variables is for public input files (eg. including processed probability data)
% \Output is for output textfiles and graphs (eg. avg simulated data etc)
% \EnergyPlus is for output textfiles to be included in EnergyPlus
%----------------------------------------------------------------------------------
% APPLIANCES: GetAppliances.m creates a list with owned appliances
%----------------------------------------------------------------------------------
% 1 = HotPlate_Count ; Type 1=Electrical, 2=Induction, 3= Natural gas           /zie opmerkingen onderaan
% 2 = Microwave;                                                                /zie opmerkingen onderaan
% 3 = Oven; Type 1=Electrical ,2= Natural gas, 3=Steam                          /zie opmerkingen onderaan
% 4 = Kettle;                                                                   /
% 5 = CoffeeMaker;                                                              /
% 6 = Toaster;                                                                  /
% 7 = Fridge; Label 1=A+++ - 9=G                                                (GetApplianceConsumption.m)
% 8 = Freezer; Label 1=A+++ - 9=G                                               (GetApplianceConsumption.m)
% 9 = FridgeFreezer; Label 1=A+++ - 9=G                                         (GetApplianceConsumption.m)
% 10 = Dishwasher; Label 1=A+++ - 9=G                                           (GetApplianceConsumption_TypeThree.m)
% 11 = WashingMachine; Label 1=A+++ - 9=G                                       (GetApplianceConsumption_TypeThree.m)
% 12 = Dryer; Label 1=A+++ - 9=G                                                (GetApplianceConsumption_TypeThree.m)
% 13 = PC Type1=LCD 3/200W, 2=Plasma 3/200W, 3=CRT 60/260W,  4=Laptop 15/75W    (GetApplianceConsumption_TypeOne.m)
% 14 = Modem;                                                                   /
% 15 = TV; Type 1=LCD 6/150W, 2=Plasma 0.7/250W, 3=CRT 10/160W                  (GetApplianceConsumption_TypeOne.m)
% 16 = DVD;                                                                     /
% 17 = Radio; 6/30W                                                             (GetApplianceConsumption_TypeOne.m)
% 18 = Light; Type 1=(f<0,2), 2= (f<0,4), 3= (f<0,6), 4= (f<0,8), 5= (f=1)      (GetApplianceConsumption.m)

% Geen strijkijzer in appliances, maar wel strijken -> 1100W                    (GetApplianceConsumption_TypeOne.m)
% Geen stofzuiger in appliances, maar wel stofzuigen -> 800W                    (GetApplianceConsumption_TypeOne.m)
% Als kookplaat & oven = elektrisch -> 2500W anders, 1500W                      (GetApplianceConsumption.m)
% Geen electrical boiler in appliances, maar wel opwarmen afwas                 (GetApplianceConsumption_TypeThree.m)
% Verlichting is ALTIJD aan? 100% wordt omgezet in warmte???

%----------------------------------------------------------------------------------
% TASKS:
%----------------------------------------------------------------------------------
% 1 = Preparing Food   (EnergyConsumption Type Two: power demand constant during fraction of activity)
% 2 = Vacuum Cleaning  (EnergyConsumption Type One: power demand constant during activity)
% 3 = Ironing          (EnergyConsumption Type One: power demand constant during activity)
% 4 = Dishes           (EnergyConsumption Type Three: power demand variable after activity)
% 5 = Laundry          (EnergyConsumption Type Three: power demand variable after activity)

% (EnergyConsumption Type Four: cycles independent of activities: Fridge, Freezer, FridgeFreezer)
% (EnergyConsumption Type Five: artificial Lighting)

%----------------------------------------------------------------------------------
% ACTIVITIES:
%----------------------------------------------------------------------------------
% 1 = Preparing Food
% 2 = Vacuum Cleaning
% 3 = Ironing
% 4 = Doing the dishes
% 5 = Doing Laundry
% 6 = Using a Computer
% 7 = Watching Television
% 8 = Listening to music

%%................................................................................. 
%%INPUT => FOR A QUICK START, ONLY THESE PARAMETERS SHOULD BE ADJUSTED
%%.................................................................................

% For modelling Households
NumberOfRuns = 10; %number of desired simulated households
MyHouseholdCharacteristics = [3 1; 3 2; 1 5; 1 5;];  %household characteristics, see description below to define the correct Household Characteristics Array
                                    
MyNumberOfYoungChildren = 0; %Children excluded from occupancy/activity/moisture simulations
Description = '3131-2';     %This description will be used to create sub-folders with results, and in the names of figures and text-documents
MemberCharacteristics = [1 32;2 32;1 5;1 7]; % gender (1=male,2=female) & age

% For export to EnergyPlus 
MyEnergyPlusOptions.NumberOfZones = 11;     %indicate the number of zones in the EnergyPlus model
MyEnergyPlusOptions.Bedrooms = [11,10,9];   %indicate which zones are bedrooms so the activity level may be adjusted. Master Bedroom First!
MyEnergyPlusOptions.LivingRoom = 4;         %zone number for living room (default location for occupancy/electricity/moisture production)
MyEnergyPlusOptions.Kitchen = 4;            %zone number for kitchen (location for preparing food)
MyEnergyPlusOptions.Bathroom = 8;           %zone number for bathroom (location for taking bath/shower)
MyEnergyPlusOptions.LaundryRoom = 2;        %zone number for laundry room (location for washing machine/tumble dryer/clothes rack). 
                                            % -> if washing machine is located bathroom, the zone number should be set to the same value as the bathroom                                             

%%EXTRA INFO ON HOW TO DEFINE HOUSEHOLD CHARACTERISTICS 
%% - row = member; column1 = Agebin; column2 = employment type 
%% - agebins: 1 = <18; 2=[18-24], 3=[25-39], 4=[40-54], 5=[55-64], 6=[65-75], 7= >75
%% - employment: 1=fulltime, 2=parttime, 3=inactive, 4=retired, 5=school
%% - always order "age" from old to young and "employment" from low to high 
%% - to include multiple members, separate their characteristics using semicolon ";" 
%% - children for whom you wish to get occupancy/activities/moisture production should be added 
%%   as a row in the MyHouseholdCharacteristics array 
%%   * kids up to 18y => [1 5]
%%   * kids between 18 and 25y => [2 5] 
%% - children for whom you DONT wish to get occupancy/activities/moisture production 
%%   (eg. babies or small children) can be included in the "MyNumberOfYoungChildren" variable. They will 
%%   still be included in the total household size, which affects the adult's occupancy/activities
%% - IMPORTANT: children should only be included once! Either in the Household Characteristics 
%%   OR the Number of Young Children
%% - EXAMPLES:
%%   * [6 4]            = one retired adult between 65y and 75y
%%   * [3 1; 3 1]       = two adults between 25y and 39y, both working full-time
%%   * [4 1; 4 3; 1 5]  = two adults between 40y and 54y, one working full-time and one unemployed
%%                        + 1 child between 12y and 18y going to school 


%%.................................................................................  
%%LOAD DATA
%%................................................................................. 

%% LOAD PACKAGES
 MyPath = '/home/bert/BehaviourModel4';
 addpath(genpath(MyPath)); %set this path to your local path, the 'Functions' folder should be available in this folder 
 cd(MyPath);
 %pkg load statistics; 
 %pkg load image;
 disp('Load data...');
 fflush(stdout);

 %%SET VARIABLES (to calculate variables use "Model_Analysis")
 NumberOfBins = 48; %to reduce the matrix size, the 144 10-minute timesteps are divided into X bins, default = 48
 
 %%LOAD RESPONDENTS & HOUSEHOLDS
 RespFile = strcat('Input/MyRespondents.mat'); %individual respondent data
 load(RespFile); 
 HouseholdFile = strcat('Input/MyHouseholds.mat'); %household data
 load(HouseholdFile);

 %%LOAD APPLIANCES
 ECSFile = 'Input/ECS.mat'; %Energy Consumption Survey
 load(ECSFile);
 AODFile = 'Variables/MyAOD.mat'; %Appliance Ownership Distribution (eg. Number of televisions owned)
 load(AODFile);
 ATDFile = 'Variables/MyATD.mat'; %Appliance Type Distribution (eg. Laptop versus desktop computer)
 load(ATDFile);
 ALDFile = 'Variables/MyALD.mat'; %Appliance Label Distribution (eg. Energy Label of Fridge)
 load(ALDFile);
 DaylightFile = 'Variables/Daylight.mat'; %Daylight data from E+ Weatherfile
 load(DaylightFile);
 
 %%LOAD CLUSTERS & ROUTINES
 CPDFile = 'Variables/MyCPD.mat'; %Cluster Probability Distribution => probability to behave according a cluster as a function of age, employment and day (for inactive & retired & children) 
 load(CPDFile);
 RPDFile = 'Variables/MyRPD.mat'; %Routine Probability Distribution => probability to belong to a routine as a function of age and employment (for fulltime & parttime)
 load(RPDFile);
 CPRFile = 'Variables/MyCPR.mat'; %Cluster Probability Routine => probability to behave according a cluster as a function of the routine and the day (for fulltime & parttime)
 load(CPRFile);
 
 %LOAD OCCUPANCY
 SSOFile = 'Variables/AllSSO.mat'; %Start State Occupancy => probability to start in a certain occupancy state at 4AM
 load(SSOFile);
 DPOFile = 'Variables/AllDPO.mat'; %Duration Probability Occupancy (see PhD)
 load(DPOFile);
 TPOFile = 'Variables/AllTPO.mat'; %Transition Probability Occupancy (see PhD)
 load(TPOFile); 

disp('Done!');
fflush(stdout); 
 
%%................................................................................. 
%%ANALYSIS FOR SIMILAR HOUSEHOLDS
%%................................................................................. 

MyHouseholdSize = rows(MyHouseholdCharacteristics) + MyNumberOfYoungChildren;

disp('Start analysis for similar households...');
disp(strcat('Household type = ',Description));
fflush(stdout);

%make new folders 
mkdir(strcat('Input/',Description));
mkdir(strcat('Output/',Description));
mkdir(strcat('Variables/',Description));
mkdir(strcat('EnergyPlus/',Description));

%%SIMILAR HOUSEHOLDS SELECTION
%%from the time-use survey
clear MyHouseholdSelection
HHselectionFile = strcat('Input/',Description,'/MyHouseholdSelection.mat'); 

    %%option 1: get and save selection
    MyHouseholdSelection = HouseholdSelection(MyHouseholds,MyHouseholdSize,MyNumberOfYoungChildren,MyHouseholdCharacteristics); 
    save(HHselectionFile,'MyHouseholdSelection');

    %%option 2: load selection 
    %load(HHselectionFile);

%%from ecs data
clear MyHouseholdSelectionECS
HHselectionECSFile = strcat('Input/',num2str(Description),'/MyHouseholdSelectionECS.mat'); 
    
    %%option 1: get and save selection
    MyHouseholdSelectionECS = HouseholdSelectionECS(ECS,MyHouseholdSize,MyNumberOfYoungChildren,MyHouseholdCharacteristics);
    save(HHselectionECSFile,'MyHouseholdSelectionECS');
    
    %%option 2: load selection
    %load(HHselectionECSFile);

%%LOAD PROBABILITIES
disp('Get probabilities...');
fflush(stdout);

IPDFile = strcat('Variables/',num2str(Description),'/MyIPD.mat');  %Income Probability Distribution
SPAFile = strcat('Variables/',num2str(Description),'/AllSPA.mat'); %Start Probability Activities
DPAFile = strcat('Variables/',num2str(Description),'/AllDPA.mat'); %Duration Probability Activities
SPTFile = strcat('Variables/',num2str(Description),'/AllSPT.mat'); %Start Probability Tasks
DPTFile = strcat('Variables/',num2str(Description),'/AllDPT.mat'); %Duriation Probability Tasks
MPTFile = strcat('Variables/',num2str(Description),'/MyMPT.mat');  %Member Probability Tasks => to assign task to household member

    %%option 1: get and save probabilities
       
    
        %%income:
        disp('income (1/3)');
        fflush(stdout);
        MyIPD = GetIncomeProbabilityDistribution(MyHouseholdSelectionECS);
        save(IPDFile,'MyIPD');

        %%personal activities:
        disp('personal activities (2/3)');
        fflush(stdout);
        [AllSPA,AllDPA] = AnalysePersonalActivities_TYPE(MyHouseholdSelection,MyHouseholdCharacteristics,NumberOfBins);
        save(SPAFile,'AllSPA');
        save(DPAFile,'AllDPA');

        %%tasks:
        disp('tasks (3/3)');
        fflush(stdout);
        [AllSPT,AllDPT,MyMPT,AvgPres] = AnalyseTasks_TYPE(MyHouseholdSelection,MyHouseholdCharacteristics,NumberOfBins);    
        save(SPTFile,'AllSPT');
        save(DPTFile,'AllDPT');
        save(MPTFile,'MyMPT');
    
    %%option 2: load probabilities
    
        %load(IPDFile);
        %load(SPAFile);
        %load(DPAFile);
        %load(SPTFile);
        %load(DPTFile);
        %load(MPTFile);

disp('Done!');
fflush(stdout);
        
%%.................................................................................  
%SIMULATION 
%%................................................................................. 

% SIMULATION   
disp('Start simulation...');
fflush(stdout);
SimFile = strcat('Output/',num2str(Description),'/MySimHouseholds.mat'); 
    
    %%option 1: simulate and save households
    MySimHouseholds = SimulateHouseholds(NumberOfRuns,MyNumberOfYoungChildren,MyHouseholdCharacteristics,MyIPD,MyRPD,MyCPR,MyCPD,AllSSO,AllDPO,AllTPO,AllSPT,AllDPT,AllSPA,AllDPA,MyMPT,MyAOD,MyATD,MyALD,Daylight,Description);
    save(SimFile,'MySimHouseholds');
    
    %%option 2: load simulated household
    %load(SimFile);

disp('Done!');
fflush(stdout);    


%%................................................................................. 
%OUTPUT
%%................................................................................. 


disp('Start writing output...');
fflush(stdout);


    
%Daily aggregated data: figures and text-files (SIM&RAW)
    %%for occupancy:
    %[AvgOccRaw,AvgOccSim] = WriteAvgOccAnnual(MyHouseholdSelection,MySimHouseholds,Description);
    %%for activities:
    %[AvgActRaw,AvgActSim] = WriteAvgActAnnual(MyHouseholdSelection,MySimHouseholds,Description);
    %%for electricity:
    %AvgConsSim = PlotAverageDailyDistribution(MySimHouseholds,Description);

%Distribution of yearly electricity consumption: figures (SIM & RAW)
%Mean = PlotLoadDistribution(MySimHouseholds,MyHouseholdSelectionECS,Description);

%EnergyPlus schedules for occupancy and electricity:
    load('Variables/WeeksAndDays.mat');
    
    %option 1: generate E+ schedules for a random household from simulated households 
    %HH = randi(length(MySimHouseholds)) 
    %%multi-zone model => number of zones and layout should be defined above!!
    %ExportToEnergyPlusCustom(MySimHouseholds,HH,Description,WeeksAndDays,MyEnergyPlusOptions,MemberCharacteristics);
    
    %option 2: generate E+ schedules for all simulated households
    for HHNumber = 1:NumberOfRuns
    HH = HHNumber;  
    HHName = strcat('HH-',Description,'-N',num2str(HH));
    disp('HHName:');
    disp(HHName);
    fflush(stdout);    
    
    %%multi-zone model => number of zones and layout should be defined above!!
    ExportToEnergyPlusCustom(MySimHouseholds,HH,Description,WeeksAndDays,MyEnergyPlusOptions,MemberCharacteristics);
    end

disp('Done!');
fflush(stdout);
