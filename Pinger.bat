@echo off
setlocal EnableDelayedExpansion

:: Enable ANSI
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: Purple tones
set C0=%ESC%[35m
set C1=%ESC%[95m
set C2=%ESC%[35;1m
set C3=%ESC%[95;1m
set RESET=%ESC%[0m

:: BANNER
echo %C1%============================================%RESET%
echo %C3%             I P   P I N G E R%RESET%
echo %C1%============================================%RESET%
echo.

:: SET TARGET
:SETTARGET
set /p TARGET=%C0%Enter IP or Hostname:%RESET% 
if "%TARGET%"=="" goto SETTARGET

set /p BYTES=%C0%Enter byte size (default 32):%RESET%
if "%BYTES%"=="" set BYTES=32

set IDX=0
set COUNT=0
set TIMEOUTS=0

:: MAIN LOOP
:PINGLOOP
set /a IDX=(IDX+1) %% 4
set /a COUNT+=1
if !IDX!==0 set COL=%C0%
if !IDX!==1 set COL=%C1%
if !IDX!==2 set COL=%C2%
if !IDX!==3 set COL=%C3%

:: Grab reply line
for /f "delims=" %%L in ('ping -n 1 -l %BYTES% -w 1 %TARGET% ^| findstr /c:"Reply from"') do (
    echo !COL!%%L!RESET!
    title P: !COUNT!  T: !TIMEOUTS!
    goto PINGLOOP
)

:: If no reply, it's a timeout
set /a TIMEOUTS+=1
echo !COL!Request timed out.!RESET!
title P: !COUNT!  T: !TIMEOUTS!
goto PINGLOOP
