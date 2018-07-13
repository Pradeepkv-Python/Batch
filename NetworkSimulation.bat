@echo off

echo Please Wait while we configuring the system....

start cmd /K appium -p 4723


if %ERRORLEVEL% NEQ 0 (
echo.
echo *** ERROR ***
echo Appium not started. Please follow the following steps to start
echo.

echo *****************************************************
echo 1. Please dowload and install Node.js software from https://nodejs.org/en/
echo 2. Set Environmetal variable path for Node.js or npm. Ex: C:\Users\pradeep\AppData\Roaming\npm
echo 3. Test 2nd step by typing npm in cmd and observe npm command help. if not, need to repeat 1st and 2nd steps
echo 4. To install Appium type npm install -g appium in cmd prompt
echo 5. To test appium installed or not, please type appium in cmd prompt
echo ***************************************************** )

if %ERRORLEVEL% EQU 0 (
echo.
echo Appium started successfully at remote machine )
timeout /T 10
adb kill-server
start cmd /K  adb -a nodaemon server
REM call adb -a nodaemon server

if %ERRORLEVEL% NEQ 0 (
echo.
echo *** ERROR ***
echo adb server not running. please check adb installed or not. if installed, please execute below command manually. 
echo else, please install and execute the script again.
echo adb -a nodaemon server )
if %ERRORLEVEL% EQU 0 (
echo.
echo adb and appium successfully started at remote machine... )

