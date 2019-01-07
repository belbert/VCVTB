@echo off
SET THEFILE=airflow.exe
echo Linking %THEFILE%
C:\lazarus\fpc\3.0.2\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections    --entry=_mainCRTStartup    -o airflow.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
