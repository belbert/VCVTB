%--------------------------------
% FILE STRUCTURE:
% \Input is for non-public input files (eg. containing TUS data)
% \Variables is for public input files (eg. including processed probability data)
% \Output is for public output filesm (eg. avg simulated data etc)
%--------------------------------


%................................
% CONSTANTS
%................................  
NumberOfBins = 48;
MyNumberOfClusters = 7;
MyNumberOfActivities = 5;
MyClusterComposition = zeros(MyNumberOfClusters+1,1);


%................................
% INPUT
%................................  

% Time-use data
RespFile = strcat('Input/MyRespondents.mat');
HouseholdFile = strcat('Input/MyHouseholds.mat');

    %option 1: read and save (slow) 
    [MyRespondents, MyHouseholds] = ReadInput(); 
    save(RespFile,'MyRespondents') 
    save(HouseholdFile,'MyHouseholds')
    
    %option 2: load
    %load(RespFile)
    %load(HouseholdFile)


%appliance data Energy Consumption Survey
ECSFile = 'Input/ECS.mat';
AODFile = 'Variables/MyAOD.mat'; % Appliance Ownership Distribution
ATDFile = 'Variables/MyATD.mat'; % Appliance Type Distribution
ALDFile = 'Variables/MyALD.mat'; % Appliance Label Distribution

    %option 1: read and save (slow)
    ECS = ReadECSInput();
    save(ECSFile,'ECS');
    [MyAOD, MyATD, MyALD] = GetApplianceOwnershipDistribution(ECS);
    save(AODFile,'MyAOD');
    save(ATDFile,'MyATD');
    save(ALDFile,'MyALD');
    
    %option 2: load
    %load(ECSFile);
    %load(AODFile);
    %load(ATDFile);
    %load(ALDFile);
    
    
%light data from weatherfile EnergyPlus
load('Variables/Daylight.mat');

%................................
% ANALYSIS ROUTINES
%................................

%Cluster Probability & Routines
CPDFile = 'Variables/MyCPD.mat'; % Cluster Probability Distribution => probability to behave according a cluster as a function of age, employment and day (for inactive & retired & chidren)
RPDFile = 'Variables/MyRPD.mat'; % Routine Probability Distribution => probability to belong to a routine as a function of age and employment (for fulltime & parttime)
CPRFile = 'Variables/MyCPR.mat'; % Cluster Probability Routine => probability to behave according a cluster as a function of the routine and the day (for fulltime & parttime)

MyCPD = GetClusterProbabilityData(MyRespondents);
[MyRPD,MyCPR] = AnalyseRoutineClusters(MyRespondents);
save(CPDFile,'MyCPD');
save(RPDFile,'MyRPD');
save(CPRFile,'MyCPR');


%................................
% ANALYSIS OCCUPANCY f(CLUSTERS)
%................................

AllSSO = zeros(MyNumberOfClusters+1,3); %Start States Occupancy
AllDPO = zeros(MyNumberOfClusters+1,NumberOfBins,144,3); %Duration Probability Occupancy
AllTPO = zeros(MyNumberOfClusters+1,NumberOfBins,3,3); %Transition Probability Occupancy


%analyse occupancy and personal activities
for MyCluster = 0:MyNumberOfClusters
     disp(MyCluster)
     
    %Select respondents from MyCluster
    [MyRespSelection,MyClusterComposition] = RespondentSelection(MyRespondents,MyCluster,MyClusterComposition);
    
    %Analyse occupancy f(cluster) and add to total array
    [MySSO,MyDPO,MyTPO] = AnalyseOccupancy(MyRespSelection,NumberOfBins,MyCluster);
    AllSSO(MyCluster+1,:) = MySSO(:);
    AllDPO(MyCluster+1,:,:,:) = MyDPO(:,:,:);
    AllTPO(MyCluster+1,:,:,:) = MyTPO(:,:,:);      

    if MyCluster == 0  %(whole dataset selected)      
        % write "global output" => crosstables clusters vs socio-economic features (as txt/fig/eps) 
        [MyCrosstableAge,MyCrosstableEmployment,MyCrosstableIncome] = WriteGlobalOutput(MyRespSelection,MyNumberOfClusters);                 
    end 
end
 
 %................................
 % SAVE VARIABLES
 %................................
 
 %occupancy
 SSOFile = 'Variables/AllSSO.mat';
 save(SSOFile,'AllSSO');
 DPOFile = 'Variables/AllDPO.mat';
 save(DPOFile,'AllDPO');
 TPOFile = 'Variables/AllTPO.mat';
 save(TPOFile,'AllTPO');
 
%SSO = Start State Occupancy: to determine the occupancy state at the very first simulation step.
%DPO = Duration Probability Occupancy: to determine how long an occupancy state will last as a function of the occupancy state, the current timestep and the cluster.
%TPO = Transition Probability Occupancy: to determine the next occupancy state once the previous state has ended. This is a function of the previous occupancy state, the current timestep and the cluster.


