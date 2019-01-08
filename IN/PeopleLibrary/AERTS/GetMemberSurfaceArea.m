function [MemberSurfaceArea] = GetMemberSurfaceArea(Gender,Age)

MyGender = Gender;
MyAge = Age;

                %Male   Female  Age
SurfaceArea =  [0.29    0.29    0.083; 
                0.33    0.33    0.25;
                0.38    0.38    0.5;
                0.45    0.45    1;
                0.53    0.53    2;
                0.61    0.61    3;
                0.76    1.08    6;
                1.08    1.08    11;
                1.59    1.59    16;
                1.84    1.84    21;
                2.05    1.81    30;
                2.1     1.85    40;
                2.15    1.88    50;
                2.11    1.89    60;
                2.08    1.88    70;
                2.05    1.77    80;
                1.92    1.69    150]; %Source: EPA

for row = 1:size(SurfaceArea,1) % Loop over rijen om juiste leeftijdscategorie te vinden
  if SurfaceArea(row,3) > MyAge   % Als rijwaarde ouder dan leeftijd
  MyAgeRow = row;
   break
  else 
   continue
  end
end

MemberSurfaceArea=SurfaceArea(MyAgeRow,Gender);
