function [Presence,Equipment,Moisture,ActivityLevel,CO2Level] = GetCustomSchedules(Households,HH,EnergyPlusOptions,Description,MemberCharacteristics)
  HouseholdSize = Households(HH).CountWithoutKids;
  HouseholdCharacteristics = Households(HH).HouseholdCharacteristics;
  %MemberCharacteristics = [1 34;2 34; 1 3; 1 5]; % gender (1=male,2=female) & age
  AdultHouseholdChars = GetAdultHouseholdCharacteristics(HouseholdCharacteristics);
  NumberOfAdults = rows(AdultHouseholdChars);
  NumberOfWeeks = 54; %extra week before and after year
  NumberOfDays = (NumberOfWeeks * 7)-1;
  MyDescription = Description;
  HHName = strcat('HH-',MyDescription,'-N',num2str(HH));
  
  HeatProductionFile = strcat('EnergyPlus/',MyDescription,'/',HHName,'/HeatProduction.csv'); %#TOEGEVOEGD
  fid_HeatProduction = fopen(HeatProductionFile,'w');%# 
  TSEP = 0;
  PeopleHeader = '';
  for Member = 1:HouseholdSize
  PeopleHeader = strcat(PeopleHeader,num2str(Member),',');
  end
  
  fprintf(fid_HeatProduction,'%s\r\n',strcat('DayCount,TS,TimeStep,',PeopleHeader,'Living,Kitchen,Laundry,Bathroom,ElecFood,ElecVaccuum,ElecIron,ElecDishes,ElecLaundry,ElecPC,ElecTV,ElecMusic,ElecBath,ElecStandby,ElecFridge,ElecLights,Bath,Dishes,Food,Laundry'));%#
  
  
  % INPUT indicate the E+ zone number for each type of room
  % -------------------------------------------------------
  MyNumberOfZones = EnergyPlusOptions.NumberOfZones;
  %fflush(stdout);
  LivingRoom = EnergyPlusOptions.LivingRoom;
  Kitchen = EnergyPlusOptions.Kitchen;
  LaundryRoom = EnergyPlusOptions.LaundryRoom;
  Bedrooms = EnergyPlusOptions.Bedrooms;
  Bathroom = EnergyPlusOptions.Bathroom;
  % -------------------------------------------------------
 
  Presence      = zeros(MyNumberOfZones, 144, NumberOfDays); %Number of people in the zone
  Equipment     = zeros(MyNumberOfZones, 144, NumberOfDays);
  Moisture      = zeros(MyNumberOfZones, 144, NumberOfDays);
  ActivityLevel = zeros(MyNumberOfZones, 144, NumberOfDays); %ActivityLevel of the Zone 
  CO2Level      = zeros(MyNumberOfZones, 144, NumberOfDays); %CO2Level of the Zone 
  
  
  for DayCount = 1:NumberOfDays %(54weeks*7days)-1 = 377days
    %disp(DayCount);
    %fflush(stdout);
    for TS = 1:144 % 24h*60min/10min=144
      [LocalTS,LocalDayCount] = ConvertGlobalToLocalTime(TS,DayCount); 
      CurrentTime = datestr(Unix2String((TS-1)*10*60),'HH:MM'); %TS1=00:00h-00:09h, TS144=23:50h-23:59h   
      TSEP = TS*10; %TimeStep EPlus > Minute level timestep instead of 10min
      MemberPlace = ''; %Initiate empty place string
      
      %PRESENCE (on member level)
      %get member occupancy data
      for Member = 1:HouseholdSize
        
        MemberEmployment = HouseholdCharacteristics(Member,2);                  % Get employment of the member
        MemberAge = MemberCharacteristics(Member,2);                            % Get age of the member
        MemberSex = MemberCharacteristics(Member,1);                            % Get gender of the member
        MyMemberSurfaceArea = GetMemberSurfaceArea(MemberSex,MemberAge);        % Get Dubois Surface Area of the member
        %MemberMetToWatt = 58.2; Most common used assumption
        MemberBMR = GetBMR(MemberSex,MemberAge);                                % Get Basal metabolic rate of the member
        MemberMetToWatt = MemberBMR*11.6;                                       % Convert Basal metabolic rate of the member to W
                
        %Clear Member presence in all rooms
                
        Occupancy = Households(HH).Occupancy(Member,LocalTS,LocalDayCount); % Get member occupancy
        if (Occupancy == 1) %awake & at home
          
          MemberActivities = [Households(HH).Activity(Member,:,LocalTS,LocalDayCount)];
          
          
          Food = Households(HH).Activity(Member,1,LocalTS,LocalDayCount);
          %Cleaning = Households(HH).Activity(Member,2,LocalTS,LocalDayCount);
          %Ironing = Households(HH).Activity(Member,3,LocalTS,LocalDayCount);
          Dishes = Households(HH).Activity(Member,4,LocalTS,LocalDayCount);
          Laundry = Households(HH).Activity(Member,5,LocalTS,LocalDayCount);
          %Computer = Households(HH).Activity(Member,6,LocalTS,LocalDayCount);
          %Television = Households(HH).Activity(Member,7,LocalTS,LocalDayCount);
          %Music = Households(HH).Activity(Member,8,LocalTS,LocalDayCount);
          Bath = Households(HH).Activity(Member,9,LocalTS,LocalDayCount);
          
          if (Food == 1)
            Presence(Kitchen,TS,DayCount) = Presence(Kitchen,TS,DayCount) + 1;
            Place = Kitchen;
          elseif (Dishes == 1)
            Presence(Kitchen,TS,DayCount) = Presence(Kitchen,TS,DayCount) + 1; 
            Place = Kitchen;
          elseif (Laundry == 1)
            Presence(LaundryRoom,TS,DayCount) = Presence(LaundryRoom,TS,DayCount) + 1;
            Place = LaundryRoom;
          elseif (Bath == 1)
            Presence(Bathroom,TS,DayCount) = Presence(Bathroom,TS,DayCount) + 1;
            Place = Bathroom;
          else   
            Presence(LivingRoom,TS,DayCount) = Presence(LivingRoom,TS,DayCount) + 1;
            Place = LivingRoom;
          end  
          
        elseif (Occupancy == 2) %sleeping
          Sleeping = 1;          
          if MemberEmployment < 5 %adult
            MyBedroom = Bedrooms(1); %select master bedroom
          else  
            KidsNumber = Member - NumberOfAdults; %get tracking number of the child to decide which bedroom
            NumberOfBedrooms = columns(Bedrooms);
            MyBedroom = Bedrooms(min(KidsNumber+1,NumberOfBedrooms)); %select second bedroom 
          end  
          %disp(MyBedroom);
          fflush(stdout);
          Presence(MyBedroom,TS,DayCount) = Presence(MyBedroom,TS,DayCount) + 1;
          Place = MyBedroom;
         
        else
          Place = 0;
        end %Occupancy
        
        MemberPlace = strcat(MemberPlace,num2str(Place),',');  
        
        %-----------------------------------------------------------------------
        
        if Place ~= 0 %If member is somewhere in the building
        
          
          
          if Occupancy == 2 % Member Asleep
            
            [ALevelMet,ALevelCO2] = GetMemberMetabolism(MemberSex,MemberAge,10,MemberBMR);%Activity 10 = Sleeping
          
          else              % Member Awake
          
          IdleALevel = 10; % Start with Idle ActivityLevel = 0.95 Met for people that are present
          [ALevelMet,ALevelCO2] = GetMemberMetabolism(MemberSex,MemberAge,IdleALevel,MemberBMR); % Start met idle ALevel
          
          %zoek activiteit die door member wordt uitgevoerd met hoogste activitylevel
             for Act = 1:size(MemberActivities)
               if MemberActivities(1,Act)== 1                                      %Haal metabolisme op als activiteit wordt uitgevoerd
                 [ActMet,ActCO2] = GetMemberMetabolism(MemberSex,MemberAge,Act,MemberBMR);   
                 if ActMet > ALevelMet %Update metabolisme indien zwaardere activiteit gevonden
                   ALevelMet = ActMet;
                   ALevelCO2 = ActCO2;
                 end
               end
             end
          end
        
        
        ActivityLevel(Place,TS,DayCount) = ActivityLevel(Place,TS,DayCount) + ALevelMet * MemberMetToWatt; %Raise Activity Level Zone with Activity Level Member 
        
                  
        %CO2 production based on Metabolism 
        CO2Level(Place,TS,DayCount) = CO2Level(Place,TS,DayCount)+ALevelCO2; %Raise CO2 Level of Zone with CO2 Level Member 
        
               
        
        end   
        
        %-----------------------------------------------------------------------
        
      end %Member
      
      for Pl = 1:MyNumberOfZones
        if Presence(Pl,TS,DayCount) > 0
        ActivityLevel(Pl,TS,DayCount)=ActivityLevel(Pl,TS,DayCount)/Presence(Pl,TS,DayCount);

        end
      end
    
      
      
     
      %MOISTURE AND ELECTRICITY (on household level)
      %get moisture production data
      MoistFood = Households(HH).MoistureProduction(1,LocalTS,LocalDayCount); %MoistFood = Households(HH).EnergyConsumption(1,LocalTS,LocalDayCount);
      MoistDishes = Households(HH).MoistureProduction(4,LocalTS,LocalDayCount); %MoistDishes = Households(HH).EnergyConsumption(4,LocalTS,LocalDayCount);
      MoistLaundry = Households(HH).MoistureProduction(5,LocalTS,LocalDayCount); %MoistLaundry = Households(HH).EnergyConsumption(5,LocalTS,LocalDayCount);
      MoistBath = Households(HH).MoistureProduction(9,LocalTS,LocalDayCount); %MoistBath = Households(HH).EnergyConsumption(9,LocalTS,LocalDayCount);

      %get energy consumption data
      ElecFood = Households(HH).EnergyConsumption(1,LocalTS,LocalDayCount);  
      ElecVaccuum = Households(HH).EnergyConsumption(2,LocalTS,LocalDayCount);
      ElecIron = Households(HH).EnergyConsumption(3,LocalTS,LocalDayCount);
      ElecDishes = Households(HH).EnergyConsumption(4,LocalTS,LocalDayCount);
      ElecLaundry = Households(HH).EnergyConsumption(5,LocalTS,LocalDayCount);
      ElecPC = Households(HH).EnergyConsumption(6,LocalTS,LocalDayCount);
      ElecTV = Households(HH).EnergyConsumption(7,LocalTS,LocalDayCount);
      ElecMusic = Households(HH).EnergyConsumption(8,LocalTS,LocalDayCount);
      ElecBath = Households(HH).EnergyConsumption(9,LocalTS,LocalDayCount);
      ElecStandby = Households(HH).EnergyConsumption(10,LocalTS,LocalDayCount);
      ElecFridge = Households(HH).EnergyConsumption(11,LocalTS,LocalDayCount);
      ElecLights = Households(HH).EnergyConsumption(12,LocalTS,LocalDayCount)*0.1; %10% sensible heat gain
      
        

      %add to room
      Equipment(LivingRoom,TS,DayCount) = Equipment(LivingRoom,TS,DayCount) + ElecVaccuum + ElecIron + ElecPC + ElecTV + ElecMusic + ElecStandby + ElecLights;
      Equipment(Kitchen,TS,DayCount) = Equipment(Kitchen,TS,DayCount) + ElecFood + ElecDishes + ElecFridge; 
      Moisture(Kitchen,TS,DayCount) = Moisture(Kitchen,TS,DayCount) + MoistFood + MoistDishes; 
      Equipment(LaundryRoom,TS,DayCount) = Equipment(LaundryRoom,TS,DayCount) + ElecLaundry;
      Moisture(LaundryRoom,TS,DayCount) = Moisture(LaundryRoom,TS,DayCount) + MoistLaundry;
      Equipment(Bathroom,TS,DayCount) = Equipment(Bathroom,TS,DayCount) + ElecBath;
      Moisture(Bathroom,TS,DayCount) = Moisture(Bathroom,TS,DayCount) + MoistBath;
      
      printstring=strcat(
      num2str(DayCount),',',
      num2str(TSEP-9),',',
      CurrentTime,',',
      MemberPlace,
      num2str(Equipment(LivingRoom,TS,DayCount)),',',
      num2str(Equipment(Kitchen,TS,DayCount)),',',
      num2str(Equipment(LaundryRoom,TS,DayCount)),',',
      num2str(Equipment(Bathroom,TS,DayCount)),',',
      num2str(ElecFood),',',
      num2str(ElecVaccuum),',',
      num2str(ElecIron),',',
      num2str(ElecDishes),',',
      num2str(ElecLaundry),',',
      num2str(ElecPC),',',
      num2str(ElecTV),',',
      num2str(ElecMusic),',',
      num2str(ElecBath),',',
      num2str(ElecStandby),',',
      num2str(ElecFridge),',',
      num2str(ElecLights),',',
      num2str(MoistBath),',',
      num2str(MoistDishes),',',
      num2str(MoistFood),',',
      num2str(MoistLaundry)
      );    
      %fprintf(fid_HeatProduction,'%s\r\n',printstring);%#
             
      %for minute = 1:9
      %IntermediateTime = datestr(Unix2String((TS-1)*10*60+minute*60),'HH:MM');  
      %printstring=[printstring,char(10),strcat(
      %num2str(DayCount),',',
      %num2str(TSEP-9+minute),',',
      %IntermediateTime,',',
      %MemberPlace,
      %num2str(Equipment(LivingRoom,TS,DayCount)),',',
      %num2str(Equipment(Kitchen,TS,DayCount)),',',
      %num2str(Equipment(LaundryRoom,TS,DayCount)),',',
      %num2str(Equipment(Bathroom,TS,DayCount)),',',
      %num2str(ElecFood),',',
      %num2str(ElecVaccuum),',',
      %num2str(ElecIron),',',
      %num2str(ElecDishes),',',
      %num2str(ElecLaundry),',',
      %num2str(ElecPC),',',
      %num2str(ElecTV),',',
      %num2str(ElecMusic),',',
      %num2str(ElecBath),',',
      %num2str(ElecStandby),',',
      %num2str(ElecFridge),',',
      %num2str(ElecLights),',',
      %num2str(MoistBath),',',
      %num2str(MoistDishes),',',
      %num2str(MoistFood),',',
      %num2str(MoistLaundry)
      %)];
      %fprintf(fid_HeatProduction,'%s\r\n',printstring);%#
      %end
      
      fprintf(fid_HeatProduction,'%s\r\n',printstring);%#

    end %timestep
  end %daycount
  fclose(fid_HeatProduction);%#
  
 
    disp('Done HeatProduction!');%#
end %function  