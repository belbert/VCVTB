function MoistureProduction = GetMoistureProduction(AllActivitySequences,MyEnergyConsumption,MyCycleConsumption)
  %TO DO: currently moisture production is modeled for one day. Production that goes beyond midnight is not copied to the next day
  % could be done by making yearly moisture production loop instead of daily loop
  
  NumberOfActivities = 9;
  EvaporationHeat = 2257000; %heat of evaporation of water in J/kg
  MoistureProduction = zeros(NumberOfActivities,144);
  
  %moisture data - 1st col = kg production/event - 2nd col = duration in timesteps of 10 minutes
  %MoistureData = [0.13   3 ; %breakfast = 0.273 kg in 3TS (=30 minutes)
                  %0.25   3 ; %lunch
                  %0.47   3 ; %dinner
                  %0.2    12; %dishwasher
                  %0.1     6 ; %dishes by hand
                  %0.0     1;  %washing machine => CURRENTLY ASSUMED NO MOISTURE PRODUCTION
                  %0.1     18; %tumble drying
                  %2.3     60; %air drying  
                  %0.3     1]; %bath/shower
                  
    MoistureData = [0.13   3 ; %breakfast = 0.273 kg in 3TS (=30 minutes)
                    0.25   3 ; %lunch
                    0.47   3 ; %dinner
                    0.2    12; %dishwasher
                    0.1    6 ; %dishes by hand
                    0.0    1;  %washing machine => CURRENTLY ASSUMED NO MOISTURE PRODUCTION
                    0.0    18; %tumble drying
                    1.25   60; %air drying  
                    0.2    1]; %bath/shower
                              
  for Activity = 1:NumberOfActivities
    for Timestep = 2:144
      
      %initialize data
      DurationTS = 1;
      Production = 0;
      
      %PREPARING FOOD => moisture production DURING activity 
      if Activity == 1 
        CurrentStatus = sum(AllActivitySequences(:,Activity,Timestep));
        PreviousStatus = sum(AllActivitySequences(:,Activity,Timestep-1));
        if (CurrentStatus > 0) && (PreviousStatus == 0)  
        %activity started => cycle through the duration of the moisture production and add to array
          
          %calculate moisture production as function of meal type (kg/event applied to 0.5h)
          if Timestep <= 42 %before 10:30 = breakfast
            DurationTS = MoistureData(1,2); %duration in timesteps
            Production = MoistureData(1,1)/DurationTS*EvaporationHeat/600; %production in Watt
          elseif Timestep <= 62 %between 10:30 and 15:30 = lunch
            DurationTS = MoistureData(2,2); %duration in timesteps
            Production = MoistureData(2,1)/DurationTS*EvaporationHeat/600; %production in Watt
          else %dinner
            DurationTS = MoistureData(3,2); %duration in timesteps
            Production = MoistureData(3,1)/DurationTS*EvaporationHeat/600; %production in Watt
          end           
        end  
      end %preparing food
      
      %DOING DISHES => moisture production comes AFTER the activity
      if Activity == 4
        CurrentStatus = sum(AllActivitySequences(:,Activity,Timestep));
        PreviousStatus = sum(AllActivitySequences(:,Activity,Timestep-1));
        if (CurrentStatus == 0) && (PreviousStatus > 0) %activity ended
          %check electricity consumption to see if dishwasher was used
          EnergyConsumption = MyEnergyConsumption(Activity,Timestep); %energy consumption for dishwasher
          if EnergyConsumption > 0 %dishwasher used  
            %calculate production dishwasher
            DurationTS = MoistureData(4,2); %duration in timesteps
            Production = MoistureData(4,1)/DurationTS*EvaporationHeat/600; %production in Watt               
          else %dishes by hand
            %calculate production hand dishes
            DurationTS = MoistureData(5,2); %duration in timesteps
            Production = MoistureData(5,1)/DurationTS*EvaporationHeat/600; %production in Watt            
          end
        end     
      end %doing dishes
      
      %DOING LAUNDRY => moisture production comes AFTER the activity
      if Activity == 5
        % for this activity there are three options: 
        %(1) washing machine => no moisture production, 
        %(2) tumble dryer => low moisture production or 
        %(3) air drying => high moisture production
        % the applicable option will be deducted from the energy consumption that was calculated earlier
        
        CurrentStatus = sum(AllActivitySequences(:,Activity,Timestep));
        PreviousStatus = sum(AllActivitySequences(:,Activity,Timestep-1));
        if (CurrentStatus == 0) && (PreviousStatus > 0) %activity ended
          EnergyConsumption = MyEnergyConsumption(Activity,Timestep); %energy consumption for dishwasher
          EnergyConsumptionWashingMachine = MyCycleConsumption(Activity,1,1); %energy consumption of the tumble dryer at first timestep of the cycle
          EnergyConsumptionTumbleDryer = MyCycleConsumption(Activity,2,1); %energy consumption of the tumble dryer at first timestep of the cycle       
          if EnergyConsumption == EnergyConsumptionWashingMachine
            DurationTS = MoistureData(6,2); %duration in timesteps
            Production = MoistureData(6,1)/DurationTS*EvaporationHeat/600; %production in Watt  
          elseif EnergyConsumption == EnergyConsumptionTumbleDryer %tumble dryer        
            DurationTS = MoistureData(7,2); %duration in timesteps
            Production = MoistureData(7,1)/DurationTS*EvaporationHeat/600; %production in Watt             
          else %air drying
            DurationTS = MoistureData(8,2); %duration in timesteps
            Production = MoistureData(8,1)/DurationTS*EvaporationHeat/600; %production in Watt             
          end 
        end % if (CurrentStatus == 0) &&    
      end %doing laundry 
      
      %TAKING A BATH OR SHOWER
      if Activity == 9
        CurrentStatus = sum(AllActivitySequences(:,Activity,Timestep));                           %%% AH toevoeging
        PreviousStatus = sum(AllActivitySequences(:,Activity,Timestep-1));                        %%% AH toevoeging
        if (CurrentStatus > 0) && (PreviousStatus == 0) %activity ended                           %%% AH toevoeging
          DurationTS = MoistureData(9,2); %duration in timesteps
          Production = MoistureData(9,1)/DurationTS*EvaporationHeat/600; %production in Watt
        end                                                                                       %%% AH toevoeging
      end %bath/shower
      
      %ADD MOISTURE PRODUCTION TO ARRAY
      for t = 1:DurationTS
        if (Timestep+t-1) <= 144
          %MoistureProduction(Activity,Timestep+t-1) = MoistureProduction(Activity,Timestep) + Production;
          MoistureProduction(Activity,Timestep+t-1) = MoistureProduction(Activity,Timestep+t-1) + Production;
        end  
      end
      
    end %for timestep  
  end %for activity
end %function