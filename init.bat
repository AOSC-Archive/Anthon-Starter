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





@echo off
title Anthon Open Source Community
mode con lines=25 cols=85
:language
cls
echo                 ====  请选择语言 / Please choose your language  ====
echo                 [                                                  ]
echo                 [             输入 1 选用简体中文。                ]
echo                 [         To use English please input 2.           ]
echo                 [                                                  ]
echo                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
set /p lang=→
if "%lang%"=="" (
	set lang=
	goto language
)

cls
if "%lang%"=="1" (
	title 正在装载程序...
	echo.
	echo                                         你好。
	echo.
	echo 正在装载程序...
	goto check
)
if "%lang%"=="2" (
	title Initializing...
	echo.
	echo                                        Hello.
	echo.
	echo Initializing...
	goto check
)
set lang=
goto language


:check
REM Check if files have exist.
if exist %systemdrive%\ast_temp\ rd /s /q %systemdrive%\ast_temp
if exist %systemdrive%\ast_strt\ rd /s /q %systemdrive%\ast_strt
if exist %systemdrive%\ast_bkup\ (
	REM ***WHAT IF SOMEONE START THE PROGRAM WHEN OS CRASHED?
	ren %systemdrive%\ast_bkup ast_bkup_00
	rd /s /q %systemdrive%\ast_bkup
	)

REM Now begins initializing...
mkdir C:\ast_bkup > nul
mkdir C:\ast_temp > nul
mkdir C:\ast_strt > nul
copy .\7z.exe C:\ast_temp > nul
copy .\7z.dll C:\ast_temp > nul
copy .\misc C:\ast_temp > nul
cd /d C:\ast_temp > nul
7z e .\misc > nul
del .\misc > nul

REM Check the type of loader ( OS )
if exist %systemdrive%\boot.ini set loader=nt5
if exist %systemdrive%\Windows\boot\ set loader=nt6

REM GO YOU!
start .\main.exe %lang% %loader%

REM WHAT IF SOMEONE CLICK 'NO' WHEN UAC NOTIFIES?
if "%errorlevel%"=="5" (
	if "%lang%"=="1" (
		echo   注意：您拒绝了安同开始程序的提升权限，安同开始程序将无法运行。
		echo         按任意键退出本程序。
		)
	if "%lang%"=="2" (
		echo Attention: You've refused the elevated permission requirement of Anthon-Starter!
		echo            Anthon-Starter cannot run successfully.
		echo Press any key to exit the program.
	)
pause > nul
rd /s /q %systemdrive%\ast_strt
rd /s /q %systemdrive%\ast_bkup
rd /s /q %systemdrive%\ast_temp
set lang=
exit
)

if "%errorlevel%"=="0" exit

REM There must be something wrong when error code isn't 0...
if "%lang%"=="1" (
	echo   *** 程序装载期间发生了致命的错误，安同开始程序无法运行。
	echo   *** 错误代码：%errorlevel%
	echo.
	echo       请访问 http://bugs.anthonos.org 向我们报告这个问题...
	echo.
	echo 按任意键退出本程序。
	)
if "%lang%"=="2" (
	echo   *** An error occurred when initializing and Anthon-Starter cannot run.
	echo   *** Error code: %errorlevel%
	echo.
	echo       Please visit http://bugs.anthonos.org to report this problem!
	echo   Press any key to exit.
	)
pause > nul
rd /s /q %systemdrive%\ast_strt
rd /s /q %systemdrive%\ast_bkup
rd /s /q %systemdrive%\ast_temp
set lang=
exit
