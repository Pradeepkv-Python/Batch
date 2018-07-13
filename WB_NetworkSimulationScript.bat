@echo off
:: WB script for NETWORK UP/DOWN scenarios for ANDROID
echo ===== Menu =====
echo 1. WIFI and 3G transistions(30 sec UP and 30 sec Down)
echo 2. Network UP/DOWN(with no change in existing connected network)
echo 3. Network UP/DOWN(Alternative UP/DOWN of wifi and 3G network)
echo ================

set /p choice=Please enter your choice (only 1, 2 3) :
::set /p UP=%1
echo.
echo ************ Network Simulation Started ****************



for /L %%g in (1, 1, 1000) do (
echo.
echo ^>^>^>^> Iteration count %%g
if %choice% == 1 (
echo in wifi
call :wifi )

if %choice% == 2 (

call :flight )

if %choice% == 3 (
echo in 3
call :wifi
call :flight )

)
echo *********** FINISHED EXECUTION ***********
EXIT /B 0

:wifi
echo.
echo Wifi Network Turn Off/On
adb shell am start -a android.intent.action.MAIN -n com.android.settings/.wifi.WifiSettings
timeout /T 2
adb shell input keyevent 19 & adb shell input keyevent 23
adb shell input keyevent 4
echo sleep for 30 sec

timeout /T 30
EXIT /B 0 

:flight
echo.
echo Airplane Mode Turn Off/On
adb shell am start -a android.settings.AIRPLANE_MODE_SETTINGS
timeout /T 2
adb shell input keyevent 19 & adb shell input keyevent 23
adb shell input keyevent 4
echo sleep for 30 sec

timeout /T 30
EXIT /B 0 


:data
echo.
echo Data Network Turn Off/On
adb shell am start -n "com.android.settings/.Settings\"\$\"DataUsageSummaryActivity"
timeout /T 2
adb shell input keyevent 4
echo sleep for 10 sec
timeout /T 10
EXIT /B 0 

