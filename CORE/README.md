# EnergyPlus Calculation Core

- This folder includes a folder with a compiled custom version of EnergyPlus that is compatible with VCVTB. 
- This folder includes a separate folder containing the changed source files.

# Changes in AirflowNetworkBalaceManager.cc
-----

1) ManageAirflowNetworkBalance() was changed to have updated input on AirflowNetwork:Distribution:Component:Duct and AirflowNetwork:MultiZone:Surface:Crack components in every calculation step.

2) CalcAirflowNetworkHeatBalance() was changed to allow flow inversion.

3) AirflowNetwork:MultiZone:Surface:Crack object was adjusted to allow modelling of self-regulating trickle vents. Fixed flow coefficient and flow exponent input was replaced with scheduled input.

4) AirflowNetwork:Distribution:Component:Duct was adjusted to allow a scheduled hydraulic diameter and cross section. This makes it possible to redirect airflows within a duct system. By adjusting schedules it becomes possible to mimic the operation of a control valve (completely open/ partly closed).

5) The singularity check was set less strict

if ( MA( ( i - 1 ) * AirflowNetworkNumOfNodes + i ) < 1.0e-6 ) {...} was set to
if ( MA( ( i - 1 ) * AirflowNetworkNumOfNodes + i ) < 1.0e-15 ) {...}
				

# Changes in DataEnvironment.cc 
-----

1) updated function WindSpeedAt( Real64 const Z ) in DataEnvironment.cc:
The standard Energylus Windspeed profile was replaced with an Atmospheric Boudary Layer (ABL) Profile

- K = 0.41;
- z0 = 0.03;
- zground = 0;
- Uref = WindSpeed;
- zref = 10;
- Ustar=(K*Uref)/std::log((zref+z0)/z0);
- LocalWindSpeed = (Ustar/K)*std::log((Z-zground+z0)/z0);

# Changes in .idd
-----

Maximum number of iterations in AirflowNetwork:SimulationControl was increased to 300000
---------------------------------------------------------------------------------------

AirflowNetwork:SimulationControl,
N1 , \field Maximum Number of Iterations
-       \type integer
-       \units dimensionless
-       \default 500
-       \minimum> 10
-       \maximum 300000
-       \note Determines the maximum number of iterations used to converge on a solution. If this limit
-       \note is exceeded, the program terminates.

AirflowNetwork:MultiZone:Surface:Crack was updated to allow scheduled input
---------------------------------------------------------------------------------------

AirflowNetwork:MultiZone:Surface:Crack,
-       \min-fields 3
-       \memo This object specifies the properties of airflow through a crack.
A1 , \field Name
-       \required-field
-       \type alpha
-       \reference SurfaceAirflowLeakageNames
-       \note Enter a unique name for this object.
N1 , \field Air Mass Flow Coefficient at Reference Conditions
-       \type real
-       \required-field
-       \units kg/s
-       \minimum> 0
-       \note Enter the air mass flow coefficient at the conditions defined
-       \note in the Reference Crack Conditions object.
-       \note Defined at 1 Pa pressure difference across this crack.
N2 , \field Air Mass Flow Exponent
-       \type real
-       \units dimensionless
-       \minimum 0.5
-       \maximum 1.0
-       \default 0.65
-       \note Enter the air mass flow exponent for the surface crack.
A2 ; \field Reference Crack Conditions
-       \type object-list
-       \object-list ReferenceCrackConditions
-      \note Select a AirflowNetwork:MultiZone:ReferenceCrackConditions name associated with
-      \note the air mass flow coefficient entered above.

AirflowNetwork:Distribution:Component:Duct was updated to allow scheduled input
---------------------------------------------------------------------------------------

AirflowNetwork:Distribution:Component:Duct,
-      \min-fields 8\\
-      \memo This object defines the relationship between pressure and air flow through the duct.
 A1 , \field Name
-      \required-field
-      \type alpha
-      \reference AirflowNetworkComponentNames
-      \note Enter a unique name for this object.
 N1 , \field Duct Length
-      \required-field
-      \type real
-      \units m
-     \minimum> 0.0
-      \note Enter the length of the duct.
 A2 , \field Hydraulic Diameter
-      \required-field
-      \type object-list
-      \object-list ScheduleNames
-      \note Enter the hydraulic diameter of the duct.
-      \note Hydraulic diameter is defined as 4 multiplied by cross section area divided by perimeter
 A3 , \field Cross Section Area
-      \required-field
-      \type object-list
-      \object-list ScheduleNames
-      \note Enter the cross section area of the duct.
 N2 , \field Surface Roughness
-      \type real
-      \units m
-      \default 0.0009
-      \minimum> 0.0
      \note Enter the inside surface roughness of the duct.
 N3 , \field Coefficient for Local Dynamic Loss Due to Fitting
-      \type real
-      \units dimensionless
-      \default 0.0
-      \minimum 0.0
-      \note Enter the coefficient used to calculate dynamic losses of fittings (e.g. elbows).
 N4 , \field Heat Transmittance Coefficient (U-Factor) for Duct Wall Construction
-      \note conduction only
-      \type real
-      \units W/m2-K
-      \minimum> 0.0
-      \default 0.943
-      \note Default value of 0.943 is equivalent to 1.06 m2-K/W (R6) duct insulation.
 N5 , \field Overall Moisture Transmittance Coefficient from Air to Air
-      \type real
-      \units kg/m2
-      \minimum> 0.0
-      \default 0.001
-      \note Enter the overall moisture transmittance coefficient
-      \note including moisture film coefficients at both surfaces.
 N6 , \field Outside Convection Coefficient
-      \note optional. convection coefficient calculated automatically, unless specified
-      \type real
-      \units W/m2-K
-      \minimum> 0.0
 N7 ; \field Inside Convection Coefficient
-      \note optional. convection coefficient calculated automatically, unless specified
-      \type real
-      \units W/m2-K
-      \minimum> 0.0

EnergyManagementSystem:Program class was extended
---------------------------------------------------------------------------------------

EnergyManagementSystem:Program,
-       \extensible:1 - repeat last field, remembering to remove ; from "inner" fields.
-       \memo This input defines an Erl program
-       \memo Each field after the name is a line of EMS Runtime Language
-       \min-fields 2
  A1 , \field Name
-       \required-field
-       \type alpha
-       \reference ErlProgramNames
-       \note no spaces allowed in name
  A2 , \field Program Line 1
-       \begin-extensible
-       \type alpha
-       \required-field
  A3 , \field Program Line 2
-       \type alpha
  A4 <--> A502; \note fields as indicated
