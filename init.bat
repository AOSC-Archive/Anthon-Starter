@REM  Anthon-Starter: Installation helper for AOSC Linux distribution series, version 0.1.2
@REM  Copyright 2014 Anthon Open Source Community.
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
:language
cls
echo                      ====������Choose your language:������====
echo                      [                                       ]
echo                      [       1:  ��������                    ]
echo                      [       2:  English                     ]
echo                      [                                       ]
echo                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
set /p lang=Input the number:
if "%lang%"=="" (
	set lang=
	goto language
)

cls
if "%lang%"=="1" (
	title ����װ�س���...
	echo.
	echo                                       ��á�
	echo.
	echo ����װ�س���...
	goto check
)
if "%lang%"=="2" (
	title Initializing...
	echo.
	echo                                       Hello.
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

if exist %systemdrive%\boot.ini set loader=nt5
if exist %systemdrive%\Windows\boot\ set loader=nt6


start .\main.exe %lang% %loader%
REM WHAT IF SOMEONE CLICK 'NO' WHEN UAC NOTIFIES?
if "%errorlevel%"=="5" (
	if "%lang%"=="1" (
		echo   ע�⣺���ܾ��˰�ͬ��ʼ���������Ȩ�ޣ���ͬ��ʼ�����޷����С�
		echo         ��������˳�������
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

if "%lang%"=="1" (
	echo   *** ����װ���ڼ䷢���������Ĵ��󣬰�ͬ��ʼ�����޷����С�
	echo   *** ������룺%errorlevel%
	echo   ��������˳�������
	)
if "%lang%"=="2" (
	echo   *** An error occurred when initializing and Anthon-Starter cannot run.
	echo   *** Error code: %errorlevel%
	echo   Press any key to exit.
	)
pause > nul
rd /s /q %systemdrive%\ast_strt
rd /s /q %systemdrive%\ast_bkup
rd /s /q %systemdrive%\ast_temp
set lang=
exit