
@if (@CodeSection == @Batch) @then

@echo off

echo.
echo.
if not exist PTT\PTT (
echo Please copy PTT folder to start Operation 
echo.
echo.
goto skip )

if exist IMEI.txt del IMEI.txt
if exist KEY.txt del KEY.txt
if exist ITRN.txt del ITRN.txt

echo Seraching values to Enter in KSS Window .... ... .. .
echo.


findstr "IMEI:-" %CD%\PTT\PTT\poc_app_logs*.txt > %CD%\IMEI.txt

findstr "<salt>" %CD%\PTT\PTT\kn_up_config_sec_key.xml > %CD%\KEY.txt

findstr "<num-of-iterations>" %CD%\PTT\PTT\kn_up_config_sec_key.xml > ITRN.txt


::find "IMEI from Plt:" %CD%\PTT\poc_app_logs*.txt >> Info.txt

for /F "tokens=7 delims= " %%c in (%CD%\IMEI.txt) do (
set IMEI=%%c
)

if [%IMEI%] == [] (
findstr "Plt: " %CD%\PTT\PTT\poc_app_logs*.txt > %CD%\IMEI.txt
for /F "tokens=8 delims= " %%c in (%CD%\IMEI.txt) do (
set IMEI=%%c
goto next
)
)
:next
for /F "tokens=3 delims=^<^>" %%c in (%CD%\KEY.txt) do (

set KEY=%%c
)

for /F "tokens=3 delims=^<^>" %%c in (%CD%\ITRN.txt) do (
set ITRN=%%c
)
echo.

echo ****** Got below values to Enter in KSS Window *******
echo.
echo IMEI is : %IMEI%
echo Salt Value is : %KEY%
echo Iterations is : %ITRN%
echo before IMEI

::echo Please check the values %CD%\Info.txt file for Key and IMEI number and enter"
set "dir=%CD%\PTT\PTT\kodiakP2T.db"

::set /p IMEI=IMEI number is : %IMEI%

::set /p SALT=The Salt Value is :%KEY%
::set /p ITR=The number of iterations is :%ITRN%


::echo at choice

::call :Decryption )


::echo in choice 2
::call :Encryption )

::call :NewDB

set /p choice= enter choice:


::Decryption

echo.
echo.

if %Choice% == Decryption (
echo ************ Decryption Started ****************
pause
start %CD%\Test_tool\KSS
echo.
echo Started KSS on Remote Machine.....
echo.

start /min /wait timeout 4
CScript //nologo //E:JScript "%~F0" "{4}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 3

CScript //nologo //E:JScript "%~F0" "{7}"

CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%KEY%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo.
echo Salt value entered.....
echo.
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%ITRN%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo.
echo Iterations value entered.....
echo.
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "{1}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%IMEI%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo.
echo IMEI value entered.....
echo.

start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%dir%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 5

echo.
echo path %dir% entered.....

CScript //nologo //E:JScript "%~F0" "{^C}"
echo.
echo DECRYPTION IS DONE. Please check Shared folder \\Hs-wb-dt\ptt\PTT
echo.

EXIT /B 0 )

::Encryption
if %Choice% == Encryption (
echo ************ Encryption is going on ****************
start /min /wait timeout 2
start %CD%\Test_tool\KSS

echo Launched KSS...
start /min /wait timeout 4
CScript //nologo //E:JScript "%~F0" "{4}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 3

CScript //nologo //E:JScript "%~F0" "{8}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%KEY%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

echo Salt value entered....

CScript //nologo //E:JScript "%~F0" "%ITRN%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
echo Iterations value entered....

CScript //nologo //E:JScript "%~F0" "{1}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%IMEI%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

echo IMEI value entered....

CScript //nologo //E:JScript "%~F0" "%dir%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 4
echo path %dir% entered.....

echo.
echo ENCRYPTION IS DONE. Please check Shared folder \\Hs-wb-dt\ptt\PTT
echo.

EXIT /B 0 )


:skip
@end


WScript.CreateObject("WScript.Shell").SendKeys(WScript.Arguments(0));
