function [Count,Type,Label] = GetApplianceCount(Appliance,Resp,ECS)
    Count = 0;
    Type = 0;
    Label = 0;
    if Appliance == 1
        Count = ECS(Resp).HotPlate_Count ;
        Type = ECS(Resp).HotPlate_Type;
    elseif Appliance == 2
        Count = ECS(Resp).Microwave;
    elseif Appliance == 3
        Count = ECS(Resp).Oven_Count;
        Type = ECS(Resp).Oven_Type;
    elseif Appliance == 4
        Count = ECS(Resp).Kettle;
    elseif Appliance == 5
        Count = ECS(Resp).CoffeeMaker;
    elseif Appliance == 6
        Count = ECS(Resp).Toaster;
    elseif Appliance == 7
        Count = ECS(Resp).Fridge_Count;
        Label = ECS(Resp).Fridge_Label;
    elseif Appliance == 8
        Count = ECS(Resp).Freezer_Count;
        Label = ECS(Resp).Freezer_Label;
    elseif Appliance == 9
        Count = ECS(Resp).FridgeFreezer_Count;
        Label = ECS(Resp).FridgeFreezer_Label;
    elseif Appliance == 10 
        Count = ECS(Resp).Dishwasher;
        Label = ECS(Resp).Dishwasher_Label;
    elseif Appliance == 11
        Count = ECS(Resp).WashingMachine;
        Label = ECS(Resp).WashingMachine_Label;
    elseif Appliance == 12
        Count = ECS(Resp).Dryer;
        Label = ECS(Resp).Dryer_Label;
    elseif Appliance == 13
        Count = ECS(Resp).PC_Count;
        Type = ECS(Resp).PC_Type;
    elseif Appliance == 14
        Count = ECS(Resp).Modem;
    elseif Appliance == 15
        Count = ECS(Resp).TV_Count;
        Type = ECS(Resp).TV_Type;
    elseif Appliance == 16
        Count = ECS(Resp).DVD;
    elseif Appliance == 17
        Count = ECS(Resp).Radio;
    elseif Appliance == 18
        Count = ECS(Resp).Light_Count;
        Type = ECS(Resp).Light_Type;
    end
    if Count > 5
        Count = 5; %max number of appliances owned = 5 
    end
end