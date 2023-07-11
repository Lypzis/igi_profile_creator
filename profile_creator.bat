@echo off

REM Extract the folder name from the source path
set "folderPath=%~1"
set "folderName=%folderPath:~0,-1%"
for %%I in ("%folderName%") do set "profileName=%%~nxI"

REM Check and delete the profile JAR file from the source folder
if exist "%~1\%profileName%.jar" (
    del "%~1\%profileName%.jar"
)

REM Create the profile JAR in the source folder
pushd "%~1"
jar -cfv .\%profileName%.jar .\%profileName%\
popd

REM Move the profile JAR to the target folder
move "%~1\%profileName%.jar" "%~2\%profileName%.jar"

REM Change directory to the targetprovidercreator folder
pushd "%~2"

REM Execute targetProfile.cmd in the targetprovidercreator folder
call targetProfile.cmd -in %profileName%.jar -out targetProfile.json -change_pwd

REM Move targetProfile.json to the previous folder
move "targetProfile.json" "..\%~nx2\%profileName%\%profileName%"

REM Remove the profile JAR file
del ".\%profileName%.jar"

REM Return to the source folder
popd

REM Change directory back to the source folder
pushd "%~1"

REM Create the profile JAR again in the source folder
jar -cfv .\%profileName%.jar .\%profileName%\

REM Return to the previous folder
popd
