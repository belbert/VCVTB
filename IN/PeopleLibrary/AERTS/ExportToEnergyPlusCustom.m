function ExportToEnergyPlusCustom(Households,HH,Description,WeeksAndDays,EnergyPlusOptions,MemberCharacteristics)
    HHsize = Households(HH).CountWithoutKids;
    MyDescription = Description;
    HHName = strcat('HH-',MyDescription,'-N',num2str(HH));
    
    %INPUT
    %-------------------------------------------------------------------------------
    NumberOfZones = EnergyPlusOptions.NumberOfZones; %indicate the number of zones in the EnergyPlus model
    Bedrooms = EnergyPlusOptions.Bedrooms;   %indicate which zones are bedrooms so the activity level may be adjusted
    HeatGainsAwake = 126; %Watt = 1.2 met 1 met = 58W/m2 -> mean = 1,8m2 > 1 met = 104.4
    HeatGainsSleeping = 83; %Watt = 0.8 met
    FirstSundayInWeatherfile = 6; %in our weatherfile, the first sunday occurs on January 6th 
    %-------------------------------------------------------------------------------
    
    [MyPresence,MyEquipment,MyMoisture,MyActivity,MyCO2] = GetCustomSchedules(Households,HH,EnergyPlusOptions,MyDescription,MemberCharacteristics);
    disp('custom schedules loaded');
    fflush(stdout);
    ElecDesignLoad = max(MyEquipment(:)); %internal gains will be calculated as a fraction 
    MoistDesignLoad = max(MyMoisture(:)); %moisture gains (latent heat) will be calculated as a fraction 
    CO2DesignLoad = max(MyCO2(:)); %W
    
    PeopleFile = strcat('EnergyPlus/',MyDescription,'/',HHName,'_MyPeopleSchedule.idf');
    EquipmentFile = strcat('EnergyPlus/',MyDescription,'/',HHName,'_MyEquipmentSchedule.idf');
    MoistureFile = strcat('EnergyPlus/',MyDescription,'/',HHName,'_MyMoistureSchedule.idf');
    ActivityFile = strcat('EnergyPlus/',MyDescription,'/',HHName,'_MyActivitySchedule.idf');
    CO2File = strcat('EnergyPlus/',MyDescription,'/',HHName,'_MyCO2Schedule.idf');

    %INITIATE FILES
    fid_People = fopen(PeopleFile,'w');
    fid_Equipment = fopen(EquipmentFile,'w'); 
    fid_Moisture = fopen(MoistureFile,'w'); 
    fid_Activity = fopen(ActivityFile,'w'); 
    fid_CO2 = fopen(CO2File,'w'); 
    
    %WRITE CONSTANT ACTIVITY SCHEDULES <<< NOT USED ANYMORE, REPLACED BY VARYING SCHEDULE
    %dayzone
    fprintf(fid_People,'%s\r\n','Schedule:Constant,');
    fprintf(fid_People,'%s\r\n','ActivityScheduleDay,');
    fprintf(fid_People,'%s\r\n','Activity Level Type,');
    fprintf(fid_People,'%s\r\n',char(strcat(num2str(HeatGainsAwake),';'))); 
    %nightzone
    fprintf(fid_People,'%s\r\n','Schedule:Constant,');
    fprintf(fid_People,'%s\r\n','ActivityScheduleNight,');
    fprintf(fid_People,'%s\r\n','Activity Level Type,');
    fprintf(fid_People,'%s\r\n',char(strcat(num2str(HeatGainsSleeping),';'))); 
    
       
    for Zone = 1:NumberOfZones
    disp('Zone:');
    disp(Zone);
    fflush(stdout);
    
      %WRITE PEOPLE OBJECT
      fprintf(fid_People,'%s\r\n','People,');
      fprintf(fid_People,'%s\r\n',char(strcat('Z',num2str(Zone),'-people,')));
      fprintf(fid_People,'%s\r\n',char(strcat('Z',num2str(Zone),',')));
      fprintf(fid_People,'%s\r\n',char(strcat('MyPeopleSchedule-Z',num2str(Zone),',')));
      fprintf(fid_People,'%s\r\n','People,');
      fprintf(fid_People,'%s\r\n',char(strcat(num2str(HHsize),',')));
      fprintf(fid_People,'%s\r\n',',');
      fprintf(fid_People,'%s\r\n',',');
      fprintf(fid_People,'%s\r\n','0.4,');
      fprintf(fid_People,'%s\r\n','autocalculate,');
      %-----------------------------------------------------------------------------------
      %REPLACED BY CALCULATED ACTIVITY SCHEDULE THAT TAKES USER AGE AND GENDER INTO ACCOUNT
      %-----------------------------------------------------------------------------------
      %if sum(ismember(Bedrooms,Zone)) == 1 %if the current zone is a bedroom => use night schedule for activity level
        %fprintf(fid_People,'%s\r\n','ActivityScheduleNight,');
      %else %if the current zone is NOT a bedroom => use day schedule for activity level
        %fprintf(fid_People,'%s\r\n','ActivityScheduleDay,');
      %end
      %-----------------------------------------------------------------------------------
      fprintf(fid_People,'%s\r\n',char(strcat('MyActivitySchedule-Z',num2str(Zone),',')));
      fprintf(fid_People,'%s\r\n','0.0,'); % Set CO2 people to zero, people as a CO2 source are introduced using ZoneContaminantSourceAndSink:CarbonDioxide objects
      %fprintf(fid_People,'%s\r\n','0.0000000382,');
      fprintf(fid_People,'%s\r\n','No,');
      fprintf(fid_People,'%s\r\n','ZoneAveraged,');
      fprintf(fid_People,'%s\r\n',',');
      fprintf(fid_People,'%s\r\n','ZONE Work Eff. Schedule,');
      fprintf(fid_People,'%s\r\n','ClothingInsulationSchedule,');
      fprintf(fid_People,'%s\r\n',',');
      fprintf(fid_People,'%s\r\n','ZONE Clothing Schedule,');
      fprintf(fid_People,'%s\r\n','ZONE Air velocity Schedule,');
      fprintf(fid_People,'%s\r\n','Fanger;');
      
      %WRITE EQUIPMENT OBJECT
      fprintf(fid_Equipment,'%s\r\n','ElectricEquipment,');
      fprintf(fid_Equipment,'%s\r\n',char(strcat('Z',num2str(Zone),'-electric,')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat('Z',num2str(Zone),',')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat('MyEquipmentSchedule-Z',num2str(Zone),',')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat('EquipmentLevel,')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(ElecDesignLoad),',')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat(',')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat(',')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat(',')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat('0.5,'))); %add half of sensible heat as a fraction radiant
      fprintf(fid_Equipment,'%s\r\n',char(strcat(',')));
      fprintf(fid_Equipment,'%s\r\n',char(strcat('General;')));
      
      %WRITE MOISTURE OBJECT
      fprintf(fid_Moisture,'%s\r\n','ElectricEquipment,');
      fprintf(fid_Moisture,'%s\r\n',char(strcat('Z',num2str(Zone),'-moisture,')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat('Z',num2str(Zone),',')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat('MyMoistureSchedule-Z',num2str(Zone),',')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat('EquipmentLevel,')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(MoistDesignLoad),',')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat(',')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat(',')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat('1,')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat('0,')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat('0,')));
      fprintf(fid_Moisture,'%s\r\n',char(strcat('General;')));  
  
      %WRITE CO2 SOURCE OBJECTS TO ZONES TO MIMIC PEOPLE CO2 GENERATION
      fprintf(fid_CO2,'%s\r\n','ZoneContaminantSourceAndSink:CarbonDioxide,');
      fprintf(fid_CO2,'%s\r\n',char(strcat('Z',num2str(Zone),'-CO2,')));
      fprintf(fid_CO2,'%s\r\n',char(strcat('Z',num2str(Zone),',')));
      fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(CO2DesignLoad),',')));
      fprintf(fid_CO2,'%s\r\n',char(strcat('MyCO2Schedule-Z',num2str(Zone),';')));
            
      %WRITE SCHEDULE:DAY:INTERVAL
      DayCount = FirstSundayInWeatherfile; %weeks start on Sunday, so first 6 days will be discarted
      for MyWeek = 1:53
          for MyDay = 1:7
              DayCount = DayCount + 1;
              if DayCount <= 365+FirstSundayInWeatherfile
                %PRESENCE print daystamp
                fprintf(fid_People,'%s\r\n',char(strcat('!-',MyDescription,'-Household',num2str(HH))));
                fprintf(fid_People,'%s\r\n','Schedule:Day:Interval,');
                fprintf(fid_People,'%s\r\n',char(strcat('MyPeopleSchedule-Z',num2str(Zone),'-Day',num2str(DayCount-FirstSundayInWeatherfile),','))); 
                fprintf(fid_People,'%s\r\n','Fraction,');
                fprintf(fid_People,'%s\r\n','No,');             

                %IG EQUIPMENT print daystamp   
                fprintf(fid_Equipment,'%s\r\n',char(strcat('!-',MyDescription,'-Household',num2str(HH))));
                fprintf(fid_Equipment,'%s\r\n','Schedule:Day:Interval,');
                fprintf(fid_Equipment,'%s\r\n',char(strcat('MyEquipmentSchedule-Z',num2str(Zone),'-Day',num2str(DayCount-FirstSundayInWeatherfile),','))); 
                fprintf(fid_Equipment,'%s\r\n','Fraction,');
                fprintf(fid_Equipment,'%s\r\n','No,');
  
                %MOISTURE print daystamp   
                fprintf(fid_Moisture,'%s\r\n',char(strcat('!-',MyDescription,'-Household',num2str(HH))));
                fprintf(fid_Moisture,'%s\r\n','Schedule:Day:Interval,');
                fprintf(fid_Moisture,'%s\r\n',char(strcat('MyMoistureSchedule-Z',num2str(Zone),'-Day',num2str(DayCount-FirstSundayInWeatherfile),','))); 
                fprintf(fid_Moisture,'%s\r\n','Fraction,');
                fprintf(fid_Moisture,'%s\r\n','No,');
                
                %ACTIVITY print daystamp
                fprintf(fid_Activity,'%s\r\n',char(strcat('!-',MyDescription,'-Household',num2str(HH))));
                fprintf(fid_Activity,'%s\r\n','Schedule:Day:Interval,');
                fprintf(fid_Activity,'%s\r\n',char(strcat('MyActivitySchedule-Z',num2str(Zone),'-Day',num2str(DayCount-FirstSundayInWeatherfile),','))); 
                fprintf(fid_Activity,'%s\r\n','Activity Level Type,');
                fprintf(fid_Activity,'%s\r\n','No,');
                
                %CO2 print daystamp
                fprintf(fid_CO2,'%s\r\n',char(strcat('!-',MyDescription,'-Household',num2str(HH))));
                fprintf(fid_CO2,'%s\r\n','Schedule:Day:Interval,');
                fprintf(fid_CO2,'%s\r\n',char(strcat('MyCO2Schedule-Z',num2str(Zone),'-Day',num2str(DayCount-FirstSundayInWeatherfile),','))); 
                fprintf(fid_CO2,'%s\r\n','Fraction,');
                fprintf(fid_CO2,'%s\r\n','No,');
  
                for TS = 1:144 %TS1=00:00h-00:09h, TS144=23:50h-23:59h   
                  %PEOPLE  
                  if TS == 1
                  PreviousNOP = MyPresence(Zone,144,DayCount-1); %previous number of people in zone 
                  else
                  PreviousNOP = MyPresence(Zone,TS-1,DayCount); %previous number of people in zone
                  end
                  CurrentNOP = MyPresence(Zone,TS,DayCount);  %current number of people in zone
                  PreviousFOP = PreviousNOP/HHsize; %for people schedule in E+, a fraction is required => divide by household size
                  CurrentFOP = CurrentNOP/HHsize; %for people schedule in E+, a fraction is required => divide by household size
                
                  if (PreviousFOP ~= CurrentFOP) %&& (TS ~= 144) %if there is a change in the number of people, write a set of lines to the the compact schedule 
                      TimeStamp = datestr(Unix2String((TS-1)*10*60),'HH:MM');
                      fprintf(fid_People,'%s\r\n',char(strcat('Until:',{' '},TimeStamp,',')));
                      fprintf(fid_People,'%s\r\n',char(strcat(num2str(PreviousFOP),',')));
                  end
                  if TS == 144
                      fprintf(fid_People,'%s\r\n',char(strcat('Until:',{' '},'24:00,')));
                      fprintf(fid_People,'%s\r\n',char(strcat(num2str(CurrentFOP),';'))); %if it is the last timestep of the day => end with semicolon (end of object in E+)
                  end
                
                  %EQUIPMENT
                  if TS == 1
                  PreviousEquipment = MyEquipment(Zone,144,DayCount-1);
                  else
                  PreviousEquipment = MyEquipment(Zone,TS-1,DayCount);
                  end
                  CurrentEquipment = MyEquipment(Zone,TS,DayCount);
                  PreviousFractionEquipment = PreviousEquipment/ElecDesignLoad; %similar to "people", the equipment level is a fraction of the design load. 
                  CurrentFractionEquipment = CurrentEquipment/ElecDesignLoad;

                  if (PreviousFractionEquipment ~= CurrentFractionEquipment) %&& (TS ~= 144)
                    TimeStamp = datestr(Unix2String((TS-1)*10*60),'HH:MM');
                    fprintf(fid_Equipment,'%s\r\n',char(strcat('Until:',{' '},TimeStamp,',')));
                    fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(PreviousFractionEquipment),',')));
                  end
                  if TS == 144
                    fprintf(fid_Equipment,'%s\r\n',char(strcat('Until:',{' '},'24:00,')));
                    fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(CurrentFractionEquipment),';')));
                  end
                
                  %MOISTURE
                  if TS == 1
                  PreviousMoist = MyMoisture(Zone,144,DayCount-1); %previous moisture production in zone
                  else
                  PreviousMoist = MyMoisture(Zone,TS-1,DayCount); %previous moisture production in zone
                  end
                  CurrentMoist = MyMoisture(Zone,TS,DayCount);  %current moisture production in zone
                  PreviousFractionMoist = PreviousMoist/MoistDesignLoad;
                  CurrentFractionMoist = CurrentMoist/MoistDesignLoad;
                
                  if (PreviousFractionMoist ~= CurrentFractionMoist) %&& (TS ~= 144)
                    TimeStamp = datestr(Unix2String((TS-1)*10*60),'HH:MM');
                    fprintf(fid_Moisture,'%s\r\n',char(strcat('Until:',{' '},TimeStamp,',')));
                    fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(PreviousFractionMoist),',')));
                  end
                  if TS == 144
                    fprintf(fid_Moisture,'%s\r\n',char(strcat('Until:',{' '},'24:00,')));
                    fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(CurrentFractionMoist),';')));
                  end
                  
                  %ACTIVITY
                  ActivityDesignLoad = 1; %RETAINED, EQUAL TO 1 TO KEEP UNIFORMITY
                  if TS == 1
                  PreviousActivity = MyActivity(Zone,144,DayCount-1); %previous Activity in zone
                  else
                  PreviousActivity = MyActivity(Zone,TS-1,DayCount); %previous Activity in zone
                  end
                  CurrentActivity = MyActivity(Zone,TS,DayCount);  %current Activity in zone
                  PreviousFractionActivity = PreviousActivity/ActivityDesignLoad;
                  CurrentFractionActivity = CurrentActivity/ActivityDesignLoad;
                
                  if (PreviousFractionActivity ~= CurrentFractionActivity) %&& (TS ~= 144)
                    TimeStamp = datestr(Unix2String((TS-1)*10*60),'HH:MM');
                    fprintf(fid_Activity,'%s\r\n',char(strcat('Until:',{' '},TimeStamp,',')));
                    fprintf(fid_Activity,'%s\r\n',char(strcat(num2str(PreviousFractionActivity),',')));
                  end
                  if TS == 144
                    fprintf(fid_Activity,'%s\r\n',char(strcat('Until:',{' '},'24:00,')));
                    fprintf(fid_Activity,'%s\r\n',char(strcat(num2str(CurrentFractionActivity),';')));
                  end
                  
                  
                  %CO2
                  if TS == 1
                  PreviousCO2 = MyCO2(Zone,144,DayCount-1); %previous CO2 in zone
                  else
                  PreviousCO2 = MyCO2(Zone,TS-1,DayCount); %previous CO2 in zone
                  end
                  CurrentCO2 = MyCO2(Zone,TS,DayCount);  %current CO2 in zone
                  PreviousFractionCO2 = PreviousCO2/CO2DesignLoad;
                  CurrentFractionCO2 = CurrentCO2/CO2DesignLoad;
                
                  if (PreviousFractionCO2 ~= CurrentFractionCO2) %&& (TS ~= 144)
                    TimeStamp = datestr(Unix2String((TS-1)*10*60),'HH:MM');
                    fprintf(fid_CO2,'%s\r\n',char(strcat('Until:',{' '},TimeStamp,',')));
                    fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(PreviousFractionCO2),',')));
                  end
                  if TS == 144
                    fprintf(fid_CO2,'%s\r\n',char(strcat('Until:',{' '},'24:00,')));
                    fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(CurrentFractionCO2),';')));
                  end
                  
                  
                end %for ts
              end %if daycount
          end %for day
      end %for week
    
      %SCHEDULE:WEEK:DAILY
      DayCount = 0;
      for MyWeek = 1:53
        %PEOPLE
        fprintf(fid_People,'%s\r\n','Schedule:Week:Daily,');
        fprintf(fid_People,'%s\r\n',char(strcat('MyPeopleSchedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        %EQUIPMENT
        fprintf(fid_Equipment,'%s\r\n','Schedule:Week:Daily,');
        fprintf(fid_Equipment,'%s\r\n',char(strcat('MyEquipmentSchedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        %MOISTURE
        fprintf(fid_Moisture,'%s\r\n','Schedule:Week:Daily,');
        fprintf(fid_Moisture,'%s\r\n',char(strcat('MyMoistureSchedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        %ACTIVITY
        fprintf(fid_Activity,'%s\r\n','Schedule:Week:Daily,');
        fprintf(fid_Activity,'%s\r\n',char(strcat('MyActivitySchedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        %CO2
        fprintf(fid_CO2,'%s\r\n','Schedule:Week:Daily,');
        fprintf(fid_CO2,'%s\r\n',char(strcat('MyCO2Schedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
       
       
        for MyDay = 1:7
            DayCount = DayCount + 1;
            DayCount = min(DayCount,365);
            fprintf(fid_People,'%s\r\n',char(strcat('MyPeopleSchedule-Z',num2str(Zone),'-Day',num2str(DayCount),',')));
            fprintf(fid_Equipment,'%s\r\n',char(strcat('MyEquipmentSchedule-Z',num2str(Zone),'-Day',num2str(DayCount),',')));  
            fprintf(fid_Moisture,'%s\r\n',char(strcat('MyMoistureSchedule-Z',num2str(Zone),'-Day',num2str(DayCount),','))); 
            fprintf(fid_Activity,'%s\r\n',char(strcat('MyActivitySchedule-Z',num2str(Zone),'-Day',num2str(DayCount),','))); 
            fprintf(fid_CO2,'%s\r\n',char(strcat('MyCO2Schedule-Z',num2str(Zone),'-Day',num2str(DayCount),','))); 
        end
        
        for MySpecialDay = 1:5 %use sunday for all special days (Holiday, Summer Design Day, Winter Design Day, Custom Day1, Custom Day2)
            Sunday = (MyWeek-1)*7 + 1;
            Sunday = min(Sunday,365);
            if MySpecialDay < 5
                %day
                fprintf(fid_People,'%s\r\n',char(strcat('MyPeopleSchedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),',')));
                fprintf(fid_Equipment,'%s\r\n',char(strcat('MyEquipmentSchedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),',')));
                fprintf(fid_Moisture,'%s\r\n',char(strcat('MyMoistureSchedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),','))); 
                fprintf(fid_Activity,'%s\r\n',char(strcat('MyActivitySchedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),','))); 
                fprintf(fid_CO2,'%s\r\n',char(strcat('MyCO2Schedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),','))); 
            else %last one ends with semicolon
                %day
                fprintf(fid_People,'%s\r\n',char(strcat('MyPeopleSchedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),';')));
                fprintf(fid_Equipment,'%s\r\n',char(strcat('MyEquipmentSchedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),';'))); 
                fprintf(fid_Moisture,'%s\r\n',char(strcat('MyMoistureSchedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),';'))); 
                fprintf(fid_Activity,'%s\r\n',char(strcat('MyActivitySchedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),';'))); 
                fprintf(fid_CO2,'%s\r\n',char(strcat('MyCO2Schedule-Z',num2str(Zone),'-Day',num2str(min(Sunday,365)),';'))); 
            end
        end
      end
    
      %SCHEDULE:YEAR
      %PEOPLE
      %day
      fprintf(fid_People,'%s\r\n','Schedule:Year,');
      fprintf(fid_People,'%s\r\n',char(strcat('MyPeopleSchedule-Z',num2str(Zone),',')));
      fprintf(fid_People,'%s\r\n','Fraction,');

      %EQUIPMENT
      fprintf(fid_Equipment,'%s\r\n','Schedule:Year,');
      fprintf(fid_Equipment,'%s\r\n',char(strcat('MyEquipmentSchedule-Z',num2str(Zone),',')));
      fprintf(fid_Equipment,'%s\r\n','Fraction,');
    
      %MOISTURE
      fprintf(fid_Moisture,'%s\r\n','Schedule:Year,');
      fprintf(fid_Moisture,'%s\r\n',char(strcat('MyMoistureSchedule-Z',num2str(Zone),',')));
      fprintf(fid_Moisture,'%s\r\n','Fraction,');
      
      %ACTIVITY
      fprintf(fid_Activity,'%s\r\n','Schedule:Year,');
      fprintf(fid_Activity,'%s\r\n',char(strcat('MyActivitySchedule-Z',num2str(Zone),',')));
      fprintf(fid_Activity,'%s\r\n','Activity Level Type,');
      
      %CO2
      fprintf(fid_CO2,'%s\r\n','Schedule:Year,');
      fprintf(fid_CO2,'%s\r\n',char(strcat('MyCO2Schedule-Z',num2str(Zone),',')));
      fprintf(fid_CO2,'%s\r\n','Fraction,');
    
      for MyWeek = 1:53
        BeginDay = WeeksAndDays((MyWeek-1)*7+1,1);
        BeginMonth = WeeksAndDays((MyWeek-1)*7+1,2);
        EndDay = WeeksAndDays(MyWeek*7,1);
        EndMonth = WeeksAndDays(MyWeek*7,2);
        
        %PEOPLE
        fprintf(fid_People,'%s\r\n',char(strcat('MyPeopleSchedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        fprintf(fid_People,'%s\r\n',char(strcat(num2str(BeginDay),',')));
        fprintf(fid_People,'%s\r\n',char(strcat(num2str(BeginMonth),',')));
        if MyWeek < 53   
            fprintf(fid_People,'%s\r\n',char(strcat(num2str(EndDay),',')));  
            fprintf(fid_People,'%s\r\n',char(strcat(num2str(EndMonth),',')));
        else
            fprintf(fid_People,'%s\r\n',char(strcat(num2str(31),','))); 
            fprintf(fid_People,'%s\r\n',char(strcat(num2str(12),';'))); %last week: end with semicolon
        end
        
        %EQUIPMENT
        fprintf(fid_Equipment,'%s\r\n',char(strcat('MyEquipmentSchedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(BeginDay),',')));
        fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(BeginMonth),',')));
        if MyWeek < 53   
            fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(EndDay),',')));  
            fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(EndMonth),',')));
        else
            fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(31),','))); 
            fprintf(fid_Equipment,'%s\r\n',char(strcat(num2str(12),';'))); %last week: end with semicolon
        end
        
        %MOISTURE
        fprintf(fid_Moisture,'%s\r\n',char(strcat('MyMoistureSchedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(BeginDay),',')));
        fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(BeginMonth),',')));
        if MyWeek < 53   
            fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(EndDay),',')));  
            fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(EndMonth),',')));
        else
            fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(31),','))); 
            fprintf(fid_Moisture,'%s\r\n',char(strcat(num2str(12),';'))); %last week: end with semicolon
        end
        
        %ACTIVITY
        fprintf(fid_Activity,'%s\r\n',char(strcat('MyActivitySchedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        fprintf(fid_Activity,'%s\r\n',char(strcat(num2str(BeginDay),',')));
        fprintf(fid_Activity,'%s\r\n',char(strcat(num2str(BeginMonth),',')));
        if MyWeek < 53   
            fprintf(fid_Activity,'%s\r\n',char(strcat(num2str(EndDay),',')));  
            fprintf(fid_Activity,'%s\r\n',char(strcat(num2str(EndMonth),',')));
        else
            fprintf(fid_Activity,'%s\r\n',char(strcat(num2str(31),','))); 
            fprintf(fid_Activity,'%s\r\n',char(strcat(num2str(12),';'))); %last week: end with semicolon
        end
        
        %CO2
        fprintf(fid_CO2,'%s\r\n',char(strcat('MyCO2Schedule-Z',num2str(Zone),'-Week',num2str(MyWeek),',')));
        fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(BeginDay),',')));
        fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(BeginMonth),',')));
        if MyWeek < 53   
            fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(EndDay),',')));  
            fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(EndMonth),',')));
        else
            fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(31),','))); 
            fprintf(fid_CO2,'%s\r\n',char(strcat(num2str(12),';'))); %last week: end with semicolon
        end
        
      end
        
    end
    
    %CLOSE FILES
    fclose(fid_People);
    fclose(fid_Equipment);
    fclose(fid_Moisture);
    fclose(fid_Activity);
    fclose(fid_CO2);

  
end