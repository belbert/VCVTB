program airflow;

{ dxf to dxf geeft nog errors }
{ $APPTYPE Console}

uses
  CSVRoutines in '.\generic\VCVTB\4POSTPROCESSING\3DAIRFLOW\routines\CSVRoutines',
  BasicRoutines in '.\generic\VCVTB\4POSTPROCESSING\3DAIRFLOW\routines\BasicRoutines',
  EuterpeRoutines in '.\generic\VCVTB\4POSTPROCESSING\3DAIRFLOW\routines\EuterpeRoutines',
  SysUtils, StrUtils, Math ;

TYPE FileType = (IDF,DXF,RAD) ;

VAR FileNaam, OutputFileNaam             : Benaming           ;
    BoxLogical                           : Benaming           ;
    MySlope, MyOrientation               : Float              ;
    MinimalSlopeDifference               : Float              ;
    MinimalOrientDifference              : Float              ;
    GridSize                             : Float              ;
    CloseSlope, CloseOrient              : Float              ;
    SlopeGrid, OrientGrid, Rectangular   : Boolean            ;
    Nr1, Nr2, Nr3                        : Integer            ;
    NumAdjustedPlanes                    : Integer            ;
    PlaneTypeName                        : Benaming           ;
    CommandLine                          : Boolean            ;
    I, J, K, IStart, IStop, IStartStep, IStopStep              : Integer            ;
    MaxDifference                        : Float              ;
    MyBuilding                           : Building           ;
    Invoer, Uitvoer                      : TextFile           ;
    Strict                               : Boolean            ;
    InputFileType, OutputFileType        : FileType           ;
    CSVInvoer, CSVUitvoer                : Text               ;
    CSVFile                              : EPlusCSVFile       ;

    Separator                            : Char               ;

    LinkageMassFlowRate12                : EPlusVariable      ;
    LinkageMassFlowRate21                : EPlusVariable      ;
    WindDirection                        : EPlusVariable      ;

BEGIN   { Airflow }

  CommandLine      := FALSE ;
  Strict := True ;

  IF (AnsiContainsStr(DateTimeToStr(Now), '2018') = TRUE ) THEN
  BEGIN

    { input analysis }
    IF (CommandLine and ((Caps(ParamStr(1)) = 'HELP') OR (ParamCount <> 5) ))
    THEN
      BEGIN
        writeln ('Format conversion    ') ;
        writeln ('Parameterstring 1: input  : filename of file containing geometry, ') ;
        writeln ('                            without extension') ;
        writeln ('Parameterstring 2: input  : versionnumber (integer) ') ;
        writeln ('Parameterstring 3: input  : in case of rad output file: ') ;
        writeln ('                            box or nobox') ;
        writeln ('                   allowed: box or nobox, any value if no rad output file ') ;
        writeln ('Parameterstring 4: input  : file type of input file ') ;
        writeln ('                   allowed: DXF IDF ') ;
        writeln ('Parameterstring 5: input  : file type of output file ') ;
        writeln ('                   allowed: DXF IDF RAD ') ;
        writeln ;
        writeln ('The length of every layername is limited to 26 characters (DXF 12) ') ;
        writeln ('SurfaceLayername = ZoneName-BoundaryZone(-SurfaceType(-ConstructionName))') ;
        writeln ('WindowLayerName  = ZoneName-WINDOW(-ConstructionName(-FrameAndDividerName(-ShadingControlName)))') ;
        writeln ('ShadingLayerName = SHADING(-TransmittanceScheduleName)') ;
        writeln ('SurfaceType = W(ALL), R(OOF), C(EILING), F(LOOR), S(URFACE) ') ;
        writeln ('In addition to checkCad, airflow draws airflows,') ;
        writeln ('searches the base surface of windows, and adds the numbering system of all plane types.') ;
        writeln ;
        writeln ('Make sure that all files are closed before running translate.') ;

      END
    ELSE
      BEGIN
        WITH MyBuilding DO
        BEGIN
          IF CommandLine
          THEN
            BEGIN
              FileName := ParamStr(1) ;
              VersionNumber := StrToInt(ParamStr(2)) ;
              BoxLogical := ParamStr(3) ;
              IF (Caps(ParamStr(4)) = 'IDF') THEN InputFileType := IDF ELSE
                IF (Caps(ParamStr(4)) = 'DXF') THEN InputFileType := DXF ELSE BEGIN writeln ('Invalid input file type') ; readln ; END ;
              IF (Caps(ParamStr(5)) = 'IDF') THEN OutputFileType := IDF ELSE
                IF (Caps(ParamStr(5)) = 'DXF') THEN OutputFileType := DXF ELSE
                  IF (Caps(ParamStr(5)) = 'RAD') THEN OutputFileType := RAD ELSE BEGIN writeln ('Invalid output file type') ; readln ; END ;
            END
          ELSE
            BEGIN
              FileName := '.\generic\VCVTB\4POSTPROCESSING\3DAIRFLOW\routines\IN\Test' ;
              VersionNumber  :=1;
              BoxLogical := 'nobox' ;
              InputFileType := IDF ;
              OutputFileType := DXF ;
            END ;

          { checking files }

          writeln ('Checking files ...') ;

          {$I+}
          try
            IF InputFileType = DXF THEN AssignFile(Invoer, DXFFileName) ;
            IF InputFileType = IDF THEN AssignFile(Invoer, IDFFileName) ;
            Reset(Invoer);
            Close(Invoer)
          except
            Writeln('Error IOResult: ', IOResult);
            Writeln (FileName, InputFileType, ' not accessible.') ;
            readln ;
          end;
          {$I-}

          {$I+}
          try
            IF OutputFileType = DXF THEN AssignFile(Uitvoer, DXFFileName) ;
            IF OutputFileType = IDF THEN AssignFile(Uitvoer, IDFFileName) ;
            IF OutputFileType = RAD THEN AssignFile(Uitvoer, RADFileName) ;
            Rewrite(Uitvoer);
            Close(Uitvoer)
          except
            Writeln('Error IOResult: ', IOResult);
            Writeln (FileName, InputFileType, ' not accessible.') ;
            readln ;
          end;
          {$I-}



          { reading input file }

          IF (InputFileType = DXF)
          THEN
            BEGIN
              Writeln ('Reading input file ... ', DXFFileName) ;
              ReadPlanesDXF ;
              CreatePlaneTypology ;

              writeln ('Check voids = ', CheckVoids:10:0) ;
              writeln ('Check voids = Start Checking coplanarity of Surfaces') ;
              FOR K := 1 TO NumSurfaces DO Surfaces[K].CheckCoplanarity(Strict) ;
              writeln ('Check voids = Start Checking coplanarity of Windows') ;
              FOR K := 1 TO NumWindows DO Windows[K].CheckCoplanarity(Strict) ;
              writeln ('Check voids = Start Checking coplanarity of ShadingSurfaces') ;
              FOR K := 1 TO NumShadingSurfaces DO ShadingSurfaces[K].CheckCoplanarity(Strict) ;
              FOR K := 1 TO NumShadingSurfaces DO writeln (ShadingSurfaces[K].TransmittanceScheduleName) ;

            END
          ELSE
            IF (InputFileType = IDF)
            THEN
              BEGIN
                writeln;
                writeln ('Input file = IDF') ;
                writeln;
                writeln ('Read planes ... ') ;
                writeln ('--------------- ') ;
                writeln;
                ReadPlanesIDF ; {mist planevariablecreation!!!}
                writeln;
                writeln ('Read zones ... ') ;
                writeln ('-------------- ') ;
                ReadZonesIDF ;
                writeln ('List zones ... ') ;
                writeln ('-------------- ') ;
                ListZones ;
                writeln ('Read constructions ... ') ;
                writeln ('---------------------- ') ;
                ReadConstructionsIDF ;
                ListConstructions ;
                readln ;
                {writeln ('Create Plane Typology ...') ;
                writeln ('------------------------- ') ;
                writeln;
                CreatePlaneTypology ; {#hier loopt iets mis! Hoort deze procedure hier te staan of ontbreekt er een procedure voor deze procedure} }

                { input analysis _____________________________________________________ }

          { reading CSV Eplus results file }

          writeln ('Reading CSV Eplus results file ...') ;
          BEGIN
          IStartStep                   := 1; {start timestep}
          IStopStep                    := 1000; {stop timestep}
          Separator                    := ',' ;
          CSVFile.FileName :=  FileName + IntToStr(VersionNumber) +'.csv' ;
          end;

          {$I+}

          try

            AssignFile(CSVInvoer, CSVFile.FileName) ;
            Reset(CSVInvoer);
            Close (CSVInvoer) ;
            except
            Writeln('Error IOResult: ', IOResult);
            Writeln (CSVFile.FileName, ' not accessible.') ;
            readln ;
            end;
          {$I-}

          { Kpeil results file }
          try
            AssignFile(Uitvoer, FileName + '_Airflow.csv') ;
            Rewrite(Uitvoer);
          except
            Writeln('Error IOResult: ', IOResult);
            Writeln (FileName + '_KLevel.csv not accessible.') ;
            readln ;
          end;

          WITH CSVFile DO
          BEGIN

          writeln ('Reading eplus variables from file ', FileName) ;
          ReadEPlusVariables ;
          writeln ('Extracting zone properties from file ...') ;
          ExtractZoneProperties ;
          writeln ('Selecting eplus variables from file ...') ;

          Writeln('NumVariables= ',NumVariables);
          For I := 1 to NumVariables Do
          begin
          Writeln(Variables[I].Name);
          end;
          Writeln;

          WindDirection := Select('Site Wind Direction', 'Environment').Subset(IStartStep,IStopStep) ;
          MinWindDirection := WindDirection.Minimum(1,10);
          MaxWindDirection := WindDirection.Maximum(1,10);
          MedianWindDirection := WindDirection.Median(1,10);

          If (MedianWindDirection<MaxWindDirection) and (MedianWindDirection>MinWindDirection)
          then
          AverageWindDirection := (MinWindDirection+Maxwinddirection)/2
          else
          AverageWindDirection := ((MinWindDirection+Maxwinddirection)/2)+180;



          For I := 1 to NumPlanes Do
          begin

          LinkageMassFlowRate12 := Select('AFN Linkage Node 1 to Node 2 Mass Flow Rate', Caps(Planes[I].Name)).Subset(IStartStep,IStopStep) ;
          LinkageMassFlowRate21 := Select('AFN Linkage Node 2 to Node 1 Mass Flow Rate', Planes[I].Name).Subset(IStartStep,IStopStep);

            IF  LinkageMassFlowRate12.Available OR  LinkageMassFlowRate21.Available THEN
            BEGIN

            Writeln(Caps(Planes[I].Name));
            Writeln('---------------');
            Planes[I].MaxMassFlowRate12 := LinkageMassFlowRate12.Maximum(1,10);
            Planes[I].MaxMassFlowRate21 := LinkageMassFlowRate21.Maximum(1,10);
            Planes[I].MeanMassFlowRate12 := LinkageMassFlowRate12.AverageWithoutZeros(1,10);
            Planes[I].MeanMassFlowRate21 := LinkageMassFlowRate21.AverageWithoutZeros(1,10);

          Writeln(I,': ',Planes[I].MaxMassFlowRate12:3:3,', ',Planes[I].MaxMassFlowRate21:3:3);


              END
          ELSE

          Writeln(Caps(Planes[I].Name));
          Writeln('---------------');
          Writeln('Unavailable');
          Writeln;
          Writeln(I,': ',Planes[I].MaxMassFlowRate12:3:3,', ',Planes[I].MaxMassFlowRate21:3:3);

          end;
          {(leegmaken)}
          Writeln;
          end;




         { input analysis _____________________________________________________ }

         {#read EIO-File}

         writeln ('Reading CSV Eplus EIO file ...') ;
          BEGIN
          IStartStep                   := 1; {start timestep}
          IStopStep                    := 1000; {stop timestep}
          Separator                    := ',' ;
          CSVFile.FileName :=  FileName + IntToStr(VersionNumber) +'.eio' ;
          end;

          {$I+}

          try
            writeln ('Assigning ...') ;
            AssignFile(CSVInvoer, CSVFile.FileName) ;
            writeln ('Assigning ...') ;
            Reset(CSVInvoer);
            writeln ('Assigning ...') ;
            Close (CSVInvoer) ;
            writeln ('Assigning ...') ;
            except
            Writeln('Error IOResult: ', IOResult);
            Writeln (CSVFile.FileName, ' not accessible.') ;
            readln ;
            end;
          {$I-}

          WITH CSVFile DO
          BEGIN

          writeln ('Reading eplus eio file ', FileName) ;
          ReadEPlusVariables ;
          Writeln;
          end;

          {#end of reading EIO-File}

          {-------------------------------------------------------------------}




                WritePlanesDXF; {toegevoegd}
                readln();
                writeln ('Check Voids') ;
                writeln ('----------- ') ;
                {CheckVoids ;}
              END ;
            {ELSE
              BEGIN
                writeln ('Unsupported file format (string 1).') ;
                readln ;
              END ;  }
          writeln ('Planes = ', NumPlanes:10 ,' Surfaces = ', NumSurfaces:10, ' Windows = ', NumWindows:10, ' Shading Surfaces = ', NumShadingSurfaces:10) ;
          writeln ('Press ENTER ... ') ;
          readln ;
        END ;
        writeln ('Input file read ..., writing outputfile') ;

        {----------------------------------------------------------------------------------------------------------------------}

        { writing output file }
        {WITH MyBuilding DO
        BEGIN

          IF (OutputFileType = DXF)
          THEN
            BEGIN
              writeln ('Writing dxf ', DXFFileName, ' Press ENTER ...' )  ; readln ;
              WriteBuildingDXF ;
              writeln ('End writing dxf')  ;
            END
          ELSE
            IF (OutputFileType = RAD)
            THEN
              BEGIN
                IF (BoxLogical = 'box')
                THEN WriteRadBoxes
                ELSE
                  IF (BoxLogical = 'nobox')
                  THEN WriteRadPlanes
                  ELSE
                    BEGIN
                      writeln ('Specify writerad box or nobox option') ;
                      readln ;
                    END
              END
            ELSE
              IF (OutputFileType = IDF)
              THEN
                BEGIN
                  WriteIDF  ;
                  AddComponentsIDF ;
                END
              ELSE
                BEGIN
                  writeln ('Unsupported output file format (string 5).') ;
                  readln ;
                END ;

      END;}
      writeln ('End of format conversion ... Press ENTER') ;
      readln ;
    END ;
  END ;
END. { Airflow }


