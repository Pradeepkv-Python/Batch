
@if (@CodeSection == @Batch) @then

@echo off
SET a = "1,1,1"
SET b = "IOS;11"

echo Starting KSS on Remote Machine.....
start /min /wait timeout 5

start %CD%\Test_tool\KSS
echo.

echo Started KSS on Remote Machine.....
echo.

start /min /wait timeout 5
CScript //nologo //E:JScript "%~F0" "{4}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2

start /min /wait timeout 5
CScript //nologo //E:JScript "%~F0" "{4}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 3

start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "{1}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 2
echo In contact management....

for /L %%G in (2000021000,1,2000021010) do (
echo Adding contact started....
echo name : %%G
echo number : %%G
start /min /wait timeout 2
CScript //nologo //E:JScript "%~F0" "{1}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "%%G"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "%%G"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{1}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{2}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "{1}"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "%a%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "%b%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

start /min /wait timeout 1
CScript //nologo //E:JScript "%~F0" "%2%"
CScript //nologo //E:JScript "%~F0" "{ENTER}"
start /min /wait timeout 1

echo Addedd contact successfully
)
@end
WScript.CreateObject("WScript.Shell").SendKeys(WScript.Arguments(0));

