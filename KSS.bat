
@if (@CodeSection == @Batch) @then

@echo off

echo ::::::::::::::Preconditions ::::::::::::::::::
echo *Copy PTT folder in Directory/path where KSS installed ex: D:\KSS.
echo *Please DONT TOUCH the system when script is running as KSS operation will effect if any window pop up on screen
echo ::::::::::::::Preconditions END ::::::::::::::::::
echo.



:3

echo.
echo.
echo ************ Fresh Operation Started ****************

echo.
echo.

if exist IMEI.txt del IMEI.txt
if exist KEY.txt del KEY.txt
if exist ITRN.txt del ITRN.txt

findstr "IMEI:-" %CD%\PTT\poc_app_logs*.txt > %CD%\IMEI.txt

findstr "<salt>" %CD%\PTT\kn_up_config_sec_key.xml > %CD%\KEY.txt

findstr "<num-of-iterations>" %CD%\PTT\kn_up_config_sec_key.xml > ITRN.txt

::find "IMEI from Plt:" %CD%\PTT\poc_app_logs*.txt >> Info.txt

for /F "tokens=5 delims= " %%c in (%CD%\IMEI.txt) do (
set IMEI=%%c
)

if [%IMEI%] == [] (
findstr "Plt: " %CD%\PTT\poc_app_logs*.txt > %CD%\IMEI.txt
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

echo IMEI is : %IMEI%
echo Salt Value is : %KEY%
echo Iterations is : %ITRN%

if [%IMEI%] == [] (
echo IMEI value not found in the Log files... please check and rerun it.
exit 
)
if %KEY% == []
(
echo Salt Value not found in the Log files... please check and rerun it.
EXIT
)
if %ITRN% == []
(
echo Iteration value not found in the Log files... please check and rerun it.
EXIT
)

::echo Please check the values %CD%\Info.txt file for Key and IMEI number and enter"
set "dir=%CD%\PTT\kodiakP2T.db"
echo.

::set /p IMEI=IMEI number is : %IMEI%

::set /p SALT=The Salt Value is :%KEY%
::set /p ITR=The number of iterations is :%ITRN%
echo.
echo.

:redo

call :Decryption
call :Encryption
call :NewDB

set /p choice= Decryption
echo.

goto %choice%

:1

echo ************ Decryption is going on ****************
:Decryption
start %CD%\Test_tool\KSS

start /min /wait timeout 4
CScript //nologo //E:JScript "%~F0" "{4}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "{7}"

CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%KEY%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%ITRN%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "{1}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%IMEI%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%dir%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 5

CScript //nologo //E:JScript "%~F0" "{^C}"

EXIT /B 0

:2

echo ************ Encryption is going on ****************
:Encryption
start /min /wait timeout 2
start %CD%\Test_tool\KSS

start /min /wait timeout 4
CScript //nologo //E:JScript "%~F0" "{4}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "{8}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%KEY%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%ITRN%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "{1}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%IMEI%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "%dir%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 10

CScript //nologo //E:JScript "%~F0" "{^C}"
EXIT /B 0
:NewDB
goto redo
EXIT /B 0

@end


WScript.CreateObject("WScript.Shell").SendKeys(WScript.Arguments(0));
