function [Metabolism,CO2Production] = GetMemberMetabolism(Gender,Age,Activity,MemberBMR)

MyGender = Gender;
MyAge = Age;
MyActivity = Activity;
MyMemberBMR = MemberBMR;

if MyGender == 1 %Male

% Get Metabolism based on Activity and Age Sources: FAO Report & Compendium of Physical Activities

MetValue = [2.5 ; % 1 Food
            2.3 ; % 2 Vacuum
            1.8 ; % 3 Iron
            2.5 ; % 4 Dishes
            2.3 ; % 5 Laundry
            1.2 ; % 6 PC
            1.2 ; % 7 TV
            1.2 ; % 8 Music
            2.0 ; % 9 Bathing 1.5, Showering 2 
            0.8]; % 10 Sleeping 
                        
Metabolism = MetValue(MyActivity,1);
%% agebins: 1 = <18; 2=[18-24], 3=[25-39], 4=[40-54], 5=[55-64], 6=[65-75], 7= >75
%Get CO2 generation rate based on Age and Met Value

CO2Production = MyMemberBMR*Metabolism*(275.15/101.3)*0.000179*0.001; % @ 22°C, 101.3kPa , L/s -> m/s , Respiratory Coefficient RQ=0.85

else %Female

% Get Metabolism based on Activity and Age

MetValue = [2.5 ; % 1 Food
            2.3 ; % 2 Vacuum
            1.8 ; % 3 Iron
            2.5 ; % 4 Dishes
            2.3 ; % 5 Laundry
            1.2 ; % 6 PC
            1.2 ; % 7 TV
            1.2 ; % 8 Music
            2.0 ; % 9 Bathing 1.5, Showering 2 
            0.8]; % 10 Sleeping 

Metabolism = MetValue(MyActivity,1);

CO2Production = MyMemberBMR*Metabolism*(275.15/101.3)*0.000179*0.001; % @ 22°C, 101.3kPa , L/s -> m/s , Respiratory Coefficient RQ=0.85

end