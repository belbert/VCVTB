function Availability = CheckAvailability(AllOccupancySequence, Member, Tbegin, Tend)                      
    if Tbegin > 0
        Duration = Tend - Tbegin + 1;
        Present = AllOccupancySequence(Member,Tbegin); %Get occupancynumber 1=at home and awake,2=away or 3=asleep
        Timestep = Tbegin;

        if Present == 1 %at home and awake at beginning of task
            AvailableTS = 1;
            while ((Present == 1) && (Timestep < Tend)) %Loop over duration of task
                Timestep = Timestep + 1;
                Occupancy = AllOccupancySequence(Member,Timestep); %Changed, this was (Member,Tbegin) Get occupancystate for every timestep of task to check if still available
                if Occupancy ~= 1 % If member went outside or went to bed
                   Present = 0;                   
                else
                    AvailableTS = AvailableTS + 1;
                end
            end
        else %Not at home or awake at beginning of task	
            AvailableTS = 0;
        end %if 

        Availability = AvailableTS / Duration;
    else
        Availability = 0;
    end
end %check availability