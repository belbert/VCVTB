# EnergyPlus Calculation Core

- This folder includes a folder with a compiled custom version of EnergyPlus that is compatible with VCVTB. 
- This folder includes a separate folder containing the changed source files.

# Changes in AirflowNetworkBalaceManager.cc
-----

1) ManageAirflowNetworkBalance() was changed to have updated input on AirflowNetwork:Distribution:Component:Duct and AirflowNetwork:MultiZone:Surface:Crack components in every calculation step.

2) CalcAirflowNetworkHeatBalance() was changed to allow flow inversion. Real64 reverseflow was added.

3) AirflowNetwork:MultiZone:Surface:Crack object was adjusted to allow modelling of self-regulating trickle vents. Fixed flow coefficient and flow exponent input was replaced with scheduled input.

4) AirflowNetwork:Distribution:Component:Duct was adjusted to allow a scheduled hydraulic diameter and cross section. This makes it possible to redirect airflows within a duct system. By adjusting schedules it becomes possible to mimic the operation of a control valve (completely open/ partly closed).

5) The singularity check was set less strict

if ( MA( ( i - 1 ) * AirflowNetworkNumOfNodes + i ) < 1.0e-6 ) {...} was set to
if ( MA( ( i - 1 ) * AirflowNetworkNumOfNodes + i ) < 1.0e-15 ) {...}
				

# Changes in DataEnvironment.cc 
-----

1) updated function WindSpeedAt( Real64 const Z ) in DataEnvironment.cc:
The standard Energylus Windspeed profile was replaced with an Atmospheric Boudary Layer (ABL) Profile

K = 0.41;
z0 = 0.03;
zground = 0;
Uref = WindSpeed;
zref = 10;
Ustar=(K*Uref)/std::log((zref+z0)/z0);
LocalWindSpeed = (Ustar/K)*std::log((Z-zground+z0)/z0);

# Changes in .idd
-----

Maximum numer of iterations in AirflowNetwork:SimulationControl was increased to 300000
---------------------------------------------------------------------------------------

AirflowNetwork:SimulationControl,
N1 , \field Maximum Number of Iterations
      \type integer
      \units dimensionless
      \default 500
      \minimum> 10
      \maximum 300000
      \note Determines the maximum number of iterations used to converge on a solution. If this limit
      \note is exceeded, the program terminates.

AirflowNetwork:MultiZone:Surface:Crack was updated to allow scheduled input
---------------------------------------------------------------------------------------

AirflowNetwork:MultiZone:Surface:Crack,
      \min-fields 3
      \memo This object specifies the properties of airflow through a crack.
 A1 , \field Name
      \required-field
      \type alpha
      \reference SurfaceAirflowLeakageNames
      \note Enter a unique name for this object.
 N1 , \field Air Mass Flow Coefficient at Reference Conditions
      \type real
      \required-field
      \units kg/s
      \minimum> 0
      \note Enter the air mass flow coefficient at the conditions defined
      \note in the Reference Crack Conditions object.
      \note Defined at 1 Pa pressure difference across this crack.
 N2 , \field Air Mass Flow Exponent
      \type real
      \units dimensionless
      \minimum 0.5
      \maximum 1.0
      \default 0.65
      \note Enter the air mass flow exponent for the surface crack.
 A2 ; \field Reference Crack Conditions
      \type object-list
      \object-list ReferenceCrackConditions
      \note Select a AirflowNetwork:MultiZone:ReferenceCrackConditions name associated with
      \note the air mass flow coefficient entered above.

AirflowNetwork:Distribution:Component:Duct was updated to allow scheduled input
---------------------------------------------------------------------------------------

AirflowNetwork:Distribution:Component:Duct,
      \min-fields 8
      \memo This object defines the relationship between pressure and air flow through the duct.
 A1 , \field Name
      \required-field
      \type alpha
      \reference AirflowNetworkComponentNames
      \note Enter a unique name for this object.
 N1 , \field Duct Length
      \required-field
      \type real
      \units m
      \minimum> 0.0
      \note Enter the length of the duct.
 A2 , \field Hydraulic Diameter
      \required-field
      \type object-list
      \object-list ScheduleNames
      \note Enter the hydraulic diameter of the duct.
      \note Hydraulic diameter is defined as 4 multiplied by cross section area divided by perimeter
 A3 , \field Cross Section Area
      \required-field
      \type object-list
      \object-list ScheduleNames
      \note Enter the cross section area of the duct.
 N2 , \field Surface Roughness
      \type real
      \units m
      \default 0.0009
      \minimum> 0.0
      \note Enter the inside surface roughness of the duct.
 N3 , \field Coefficient for Local Dynamic Loss Due to Fitting
      \type real
      \units dimensionless
      \default 0.0
      \minimum 0.0
      \note Enter the coefficient used to calculate dynamic losses of fittings (e.g. elbows).
 N4 , \field Heat Transmittance Coefficient (U-Factor) for Duct Wall Construction
      \note conduction only
      \type real
      \units W/m2-K
      \minimum> 0.0
      \default 0.943
      \note Default value of 0.943 is equivalent to 1.06 m2-K/W (R6) duct insulation.
 N5 , \field Overall Moisture Transmittance Coefficient from Air to Air
      \type real
      \units kg/m2
      \minimum> 0.0
      \default 0.001
      \note Enter the overall moisture transmittance coefficient
      \note including moisture film coefficients at both surfaces.
 N6 , \field Outside Convection Coefficient
      \note optional. convection coefficient calculated automatically, unless specified
      \type real
      \units W/m2-K
      \minimum> 0.0
 N7 ; \field Inside Convection Coefficient
      \note optional. convection coefficient calculated automatically, unless specified
      \type real
      \units W/m2-K
      \minimum> 0.0

EnergyManagementSystem:Program class was extended
---------------------------------------------------------------------------------------

EnergyManagementSystem:Program,
       \extensible:1 - repeat last field, remembering to remove ; from "inner" fields.
       \memo This input defines an Erl program
       \memo Each field after the name is a line of EMS Runtime Language
       \min-fields 2
  A1 , \field Name
       \required-field
       \type alpha
       \reference ErlProgramNames
       \note no spaces allowed in name
  A2 , \field Program Line 1
       \begin-extensible
       \type alpha
       \required-field
  A3 , \field Program Line 2
       \type alpha
  A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, \note fields as indicated
  A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30, A31, A32, A33, A34, \note fields as indicated
  A35, A36, A37, A38, A39, A40, A41, A42, A43, A44, A45, A46, A47, A48, A49, \note fields as indicated
  A50, A51, A52, A53, A54, A55, A56, A57, A58, A59, A60, A61, A62, A63, A64, \note fields as indicated
  A65, A66, A67, A68, A69, A70, A71, A72, A73, A74, A75, A76, A77, A78, A79, \note fields as indicated
  A80, A81, A82, A83, A84, A85, A86, A87, A88, A89, A90, A91, A92, A93, A94, \note fields as indicated
  A95, A96, A97, A98, A99, A100, A101, A102, A103, A104, A105, A106, A107, A108,   \note fields as indicated
  A109, A110, A111, A112, A113, A114, A115, A116, A117, A118,A119,A120,A121,A122, \note fields as indicated
  A123, A124, A125, A126, A127, A128, A129, A130, A131, A132, \note fields as indicated
  A133, A134, A135, A136, A137, A138, A139, A140, A141, A142, \note fields as indicated
  A143, A144, A145, A146, A147, A148, A149, A150, A151, A152, \note fields as indicated
  A153, A154, A155, A156, A157, A158, A159, A160, A161, A162, \note fields as indicated
  A163, A164, A165, A166, A167, A168, A169, A170, A171, A172, \note fields as indicated
  A173, A174, A175, A176, A177, A178, A179, A180, A181, A182, \note fields as indicated
  A183, A184, A185, A186, A187, A188, A189, A190, A191, A192, \note fields as indicated
  A193, A194, A195, A196, A197, A198, A199, A200, A201, A202, \note fields as indicated
  A203, A204, A205, A206, A207, A208, A209, A210, A211, A212, \note fields as indicated
  A213, A214, A215, A216, A217, A218, A219, A220, A221, A222, \note fields as indicated
  A223, A224, A225, A226, A227, A228, A229, A230, A231, A232, \note fields as indicated
  A233, A234, A235, A236, A237, A238, A239, A240, A241, A242, \note fields as indicated
  A243, A244, A245, A246, A247, A248, A249, A250, A251, A252, \note fields as indicated
  A253, A254, A255, A256, A257, A258, A259, A260, A261, A262, \note fields as indicated
  A263, A264, A265, A266, A267, A268, A269, A270, A271, A272, \note fields as indicated
  A273, A274, A275, A276, A277, A278, A279, A280, A281, A282, \note fields as indicated
  A283, A284, A285, A286, A287, A288, A289, A290, A291, A292, \note fields as indicated
  A293, A294, A295, A296, A297, A298, A299, A300, A301, A302, \note fields as indicated
  A303, A304, A305, A306, A307, A308, A309, A310, A311, A312, \note fields as indicated
  A313, A314, A315, A316, A317, A318, A319, A320, A321, A322, \note fields as indicated
  A323, A324, A325, A326, A327, A328, A329, A330, A331, A332, \note fields as indicated
  A333, A334, A335, A336, A337, A338, A339, A340, A341, A342, \note fields as indicated
  A343, A344, A345, A346, A347, A348, A349, A350, A351, A352, \note fields as indicated
  A353, A354, A355, A356, A357, A358, A359, A360, A361, A362, \note fields as indicated
  A363, A364, A365, A366, A367, A368, A369, A370, A371, A372, \note fields as indicated
  A373, A374, A375, A376, A377, A378, A379, A380, A381, A382, \note fields as indicated
  A383, A384, A385, A386, A387, A388, A389, A390, A391, A392, \note fields as indicated
  A393, A394, A395, A396, A397, A398, A399, A400, A401, A402, \note fields as indicated
  A403, A404, A405, A406, A407, A408, A409, A410, A411, A412, \note fields as indicated
  A413, A414, A415, A416, A417, A418, A419, A420, A421, A422, \note fields as indicated
  A423, A424, A425, A426, A427, A428, A429, A430, A431, A432, \note fields as indicated
  A433, A434, A435, A436, A437, A438, A439, A440, A441, A442, \note fields as indicated
  A443, A444, A445, A446, A447, A448, A449, A450, A451, A452, \note fields as indicated
  A453, A454, A455, A456, A457, A458, A459, A460, A461, A462, \note fields as indicated
  A463, A464, A465, A466, A467, A468, A469, A470, A471, A472, \note fields as indicated
  A473, A474, A475, A476, A477, A478, A479, A480, A481, A482, \note fields as indicated
  A483, A484, A485, A486, A487, A488, A489, A490, A491, A492, \note fields as indicated
A493, A494, A495, A496, A497, A498, A499, A500, A501, A502; \note fields as indicated
