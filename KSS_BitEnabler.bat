
@if (@CodeSection == @Batch) @then

@echo off


echo.
echo ************ Bit Enabler and Rehome ****************

echo.
echo 1)Rehome
echo 2)Jitter
echo 3)Ondemand
echo 4)Periodiclogs
echo 5)UIStats
echo 6)Decouple Presence
echo 7)PresenceReduction


::set /p choice=enter choice
::set /p Option=enable or disable? (Applicale only for Decouple and Presence)
echo.
if [%MDN%] == [] (
echo MDN number not entered. Please rerun with MDN number
exit )

if %choice% == Jitter (
					echo ******Jitter*****
					
					call :GetDetails
					call :SearchIP
					call :Putty
					call :CreateMDNFile
					call :CLIADMIN
					call :Jitter
					call :ExitCLI )
if %choice% == Rehome (

					echo ****** Rehome*****
					call :GetDetails
					call :SearchIP
					call :Putty
					call :CLIADMIN
					call :rehome
					call :ExitCLI )

if %choice% == Ondemand (

					echo ****** Ondemand*****
					call :GetDetails
					call :SearchIP
					call :Putty
					call :CreateMDNFile
					call :CLIADMIN
					call :Ondemand
					call :MDNPath
					call :ExitCLI )
if %choice% == Periodiclogs (

					echo ****** PeriodicLogs*****
					call :GetDetails
					call :SearchIP
					call :Putty
					call :CreateMDNFile
					call :CLIADMIN
					call :PeriodicLogs
					call :ExitCLI )
if %choice% == UIStats (

					echo ****** UIStats*****
					call :GetDetails
					call :SearchIP
					call :Putty
					call :CreateMDNFile
					call :CLIADMIN
					call :UIStats
					call :ExitCLI )
				
if %choice% == Decouple (

					echo ****** Decouple*****
					call :GetDetails
					call :SearchIP
					call :Putty
					call :CreateMDNFile
					call :CLIADMIN
					call :Decouple
					call :ExitCLI )
				
if %choice% == Presence (

					echo ****** Presence reduction*****
					call :GetDetails
					call :SearchIP
					call :Putty
					call :CreateMDNFile
					call :CLIADMIN
					call :Presence
					call :MDNPath
					call :Yes
					call :ExitCLI )



echo.
:GetDetails
::pause
::set /p Server=enter the server used : 
::if %choice% == Rehome (
::pause

::set /p POC=enter POC1 or POC2:

 
::set /p MDN=enter MDN : 
set GWIP=10.0.24.64

EXIT /B 0

:SearchIP
findstr "%Server%XDMPrimary" IPandPOCDetails.txt > %CD%\IP.txt
findstr "%Server%%POC%" IPandPOCDetails.txt > %CD%\POC.txt

for /F "tokens=2 delims= " %%c in (%CD%\IP.txt) do (
set IP=%%c
)
for /F "tokens=2 delims= " %%c in (%CD%\POC.txt) do (
set POCID=%%c
)

echo XDM server IP :%IP% 
echo POCID is : %POCID%
echo GWIP is : %GWIP%
if [%IP%] == [] (
echo Getting IP details FAILED.... Please check the IPandPOCDetails file 
exit
)
if [%POCID%] == [] (
echo Getting IP details FAILED.... Please check the IPandPOCDetails file 
exit
)
echo.
del IP.txt POC.txt

EXIT /B 0


:Putty
start cmd
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "C:\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 5
CScript //nologo //E:JScript "%~F0" "ssh kodiak@%GWIP%"
::CScript //nologo //E:JScript "%~F0" "{TAB}"
rem CScript //nologo //E:JScript "%~F0" "22"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2 
rem CScript //nologo //E:JScript "%~F0" "kodiak"
rem CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

CScript //nologo //E:JScript "%~F0" "kodiak"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

start /min /wait timeout 2 
CScript //nologo //E:JScript "%~F0" "ssh kodiak@%IP%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo Establishing SSH connection to %IP%
start /min /wait timeout 2 
CScript //nologo //E:JScript "%~F0" "kodiak"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
rem start /min /wait timeout 2 
rem CScript //nologo //E:JScript "%~F0" "su"
rem CScript //nologo //E:JScript "%~F0" "{ENTER}"
rem start /min /wait timeout 4
rem CScript //nologo //E:JScript "%~F0" "kodiak"
rem CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo Done SSH connection
echo.

EXIT /B 0



:CreateMDNFile

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "rm -f /DGdata/MDN.txt"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo Removed Existing MDN file /DGdata/MDN.txt
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "cat > /DGdata/MDN.txt <<EOF"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "91%MDN%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "EOF"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
echo Created MDN file /DGdata/MDN.txt with %MDN%
echo.
EXIT /B 0


:kill

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "su"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "kodiak"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
echo Killing CLIADMIN if it already opened....
CScript //nologo //E:JScript "%~F0" "killall -u cliadmin"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo.
echo Killed CLIADMIN
EXIT /B 0

:CLIADMIN
start /min /wait timeout 2
call :kill
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "su - cliadmin"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "kodiak"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "8"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 4
::CScript //nologo //E:JScript "%~F0" "kodiak"
::CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo Opened CLIADMIN....
echo.
EXIT /B 0

:rehome

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "3"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "91%MDN%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo Entered %MDN%
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "%POCID%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo Entered %POCID%
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "Y"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

echo Rehome Done...
echo.
EXIT /B 0

:Ondemand

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "4"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

echo Ondemand Option 4 Selected on CLIADMIN....
echo.
EXIT /B 0

:ExitCLI

start /min /wait timeout 5
CScript //nologo //E:JScript "%~F0" "0"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "0"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "99"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "^1exit"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "^1exit"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "^1exit"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

echo Succefully closed the CLIADMIN and All Operations closed.
echo.
echo ***** Thanks for Using Jenkins*****
echo.
EXIT /B 0

:Jitter

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "8"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo Jitter Option 8 Selected on CLIADMIN....
call :1
call :MDNPath
call :Yes

echo Jitter Statistics Enabled...
echo.
EXIT /B 0
:Decouple

start /min /wait timeout 2

CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "10"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo Selected Decouple 10 presence bit in CLIADMIN...
start /min /wait timeout 2
if %Option% == Enable (
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

echo Decouple Bit enabling...wait )

if %Option% == Disable (
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

echo Decouple Bit Disabling....wait)
call :MDNPath
call :Yes

echo Decouple Presence Bit Enable/Disable Done...
echo.

EXIT /B 0

:Presence

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "7"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

echo Selected Presence 7 Reduction bit in CLIADMIN...
start /min /wait timeout 2
if %Option% == Enable (
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

echo Presence Bit enabled... )

if %Option% == Disable (
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}"

echo Presence Bit Disable...)


echo Presence redusction Bit Enable/Disable Done...
echo.
EXIT /B 0

:PeriodicLogs
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "11"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
echo Selected 11 for Periodic Logs on CLIADMIN...
call :1
call :MDNPath

echo MDN path entered....
if %Option% == Enable (
echo.
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "30"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "0"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "Y"
CScript //nologo //E:JScript "%~F0" "{ENTER}" 
echo Periodic logs bit Enabled )

if %Option% == Disable (
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "Y"
CScript //nologo //E:JScript "%~F0" "{ENTER}" 
echo Periodic logs bit Disabled )

echo.
EXIT /B 0

:UIStats
start /min /wait timeout 4
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 4
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 4
CScript //nologo //E:JScript "%~F0" "12"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
echo Selected 12 for UIstats in CLIADMIN
call :1
call :MDNPath

if %Option% == Enable (
echo.
start /min /wait timeout 4
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "Y"
CScript //nologo //E:JScript "%~F0" "{ENTER}" 
start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "Y"
CScript //nologo //E:JScript "%~F0" "{ENTER}" 
echo UI Stats bit Enabled )

if %Option% == Disbale (
echo IN Disable
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "Y"
CScript //nologo //E:JScript "%~F0" "{ENTER}" 
echo UI Stats bit Disabled )

echo.
EXIT /B 0

:1
if %Option% == Enable (
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}" 
echo Bit is Enabling..)

if %Option% == Disable (
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}" 
echo Bit is Disabling.. )

EXIT /B 0
:MDNPath
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "1"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "/DGdata/MDN.txt"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
echo MDN path Enetred ...

if %choice% == Ondemand (
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "2"
CScript //nologo //E:JScript "%~F0" "{ENTER}" )

::if %choice% == Ondemand goto :E
::if %choice% == PeriodicLogs goto :P
::if %choice% == UIStats goto :u
::if %choice% == Jitter goto :Y
::if %choice% == Decouple goto :Y 
::if %choice% == Presence goto :Y
:::Y
::echo entered in

EXIT /B 0

:Yes
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "Y"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
EXIT /B 0


@end

WScript.CreateObject("WScript.Shell").SendKeys(WScript.Arguments(0));
