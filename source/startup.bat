@REM  Anthon-Starter: Installation helper for AOSC Linux distribution series, version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community.
@REM  
@REM  Licensed under the Apache License, Version 2.0 (the "License");
@REM  you may not use this file except in compliance with the License.
@REM  You may obtain a copy of the License at
@REM  
@REM    http://www.apache.org/licenses/LICENSE-2.0
@REM  
@REM  Unless required by applicable law or agreed to in writing, software
@REM  distributed under the License is distributed on an "AS IS" BASIS,
@REM  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM  See the License for the specific language governing permissions and
@REM  limitations under the License.





@echo off & setlocal
cls
title Anthon Open Source Community

if not exist %systemdrive%\ast_strt\info.ast (
	echo 警告：找不到配置文件。将缺少部分功能。
	echo Warning: Can't load the settings. Some features will not be availble.
	set lang=na
	set location=na
	ping 127.0.0.1 >nul
	goto skip_read_info
)

cls
echo Loading...
REM Read the configuration data
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_strt\info.ast^|findstr "^3:"') do set lang=%%b
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_strt\info.ast^|findstr "^4:"') do set loader=%%b
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_strt\info.ast^|findstr "^5:"') do set gpt_status=%%b
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_strt\info.ast^|findstr "^6:"') do set instway=%%b
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_strt\info.ast^|findstr "^7:"') do set location=%%b
REM Check if the backup files exist
:skip_read_info
if not exist %systemdrive%\ast_bkup\ (
	if "%lang:~0,-1%"=="1" echo   *** 警告：找不到备份文件。
	if "%lang:~0,-1%"=="2" echo   *** Warning: Cannot find backup file.
	pause
)

if "%lang:~0,-1%"=="1" goto cn_main
if "%lang:~0,-1%"=="2" goto en_main


:cn_main
cls
title 安同开始程序 0.1.2
echo ====================＞＞＞欢迎使用安同开始程序＜＜＜====================
echo.
echo 感谢您安装安同开源社区发行版。
echo 现在安同开始程序已经准备好了对安装后系统残留文件的清扫。
echo.
echo 请按任意键执行操作，或者您可以关掉此窗口。
pause > nul
goto run

:en_main
cls
title Anthon-Starter 0.1.2
echo =========================＞＞＞ Welcome! ＜＜＜=========================
echo.
echo Thank you for installing AOSC distribution.
echo Here we hope that you'll have a pleasant trip with it.
echo.
echo Now Anthon-Starter is ready for trash cleaning.
echo.
echo Press any key to execute, or you can close the window.
pause > nul
goto run



:run
if "%lang:~0,-1%"=="1" echo 请稍候，安同开始程序正在执行任务……
if "%lang:~0,-1%"=="2" echo Please wait while Anthon-Starter is cleaning files...

if exist %systemdrive%\ast_bkup\boot.ini (
	attrib -s -h -r %systemdrive%\boot.ini
	del /f %systemdrive%\boot.ini
	copy %systemdrive%\ast_bkup\boot.ini %systemdrive%\
	attrib +s +h +r %systemdrive%\boot.ini
)
if exist %systemdrive%\ast_bkup\BCDbckup (
	bcdedit /import %systemdrive%\ast_bkup\BCDbckup
)

rd /s /q %systemdrive%\ast_bkup\
rd /s /q %systemdrive%\ast_temp\
del /f %systemdrive%\g2ldr
rd /s /q %location%live\

REM AHHHHHHH!!! WHO HELP ME TO FINISH HERE!!

reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon-Starter_Startup_Utility /f
if "%lang:~0,-1%"=="1" goto finish1
if "%lang:~0,-1%"=="2" goto finish2
goto finish2

:finish1
cls
echo 操作已完成！感谢您对安同 GNU/Linux 的支持！
echo.
echo 请按任意键结束本程序。
pause > nul
rd /s /q %systemdrive%\ast_strt
exit

:finish2
cls
echo Cleaning has already finished! Thanks for your support!
echo.
echo Press any key to finish.
pause > nul
rd /s /q %systemdrive%\ast_strt
exit
