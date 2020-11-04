@echo off
setlocal enabledelayedexpansion
color 70
for /f "delims=" %%i in ('dir /b *.in') do (
set m=%%i
if /i "!m:~0,1!" == "a" ( set a=1 ) else (
rename "%%i" "a%%i"
)
)
for /f "delims=" %%i in ('dir /b *.out') do (
set m=%%i
if /i "!m:~0,1!" == "a" ( set a=1 ) else (
rename "%%i" "a%%i"
)
)
echo Finished
pause