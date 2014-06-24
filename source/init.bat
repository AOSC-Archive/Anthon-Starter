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
:detectlang
for /f "eol=! skip=2 tokens=3" %%i in ('reg query "HKCU\Control Panel\International" /v "sLanguage"') do set "plang=%%i"    @rem echo %%i
    if "%plang%" == "CHS" (
        set lang=1
        goto language
    )
    if "%plang%" == "ENU" (
        set lang=2
        goto language
    )
    if "%plang%" == "CHT" (
        goto language
    )
    )
set lang=
goto language

:language
cls
echo                 ====  ��ѡ������ / Please choose your language  ====
echo                 [                                                  ]
echo                 [             ���� 1 ѡ�ü������ġ�                ]
echo                 [         To use English please input 2.           ]
echo                 [                                                  ]
echo                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.

if "%lang%"=="" (
        set /p lang=��
)

cls
if "%lang%"=="1" (
	title ����װ�س���...
	echo.
	echo                                         ���á�
	echo.
	echo ����װ�س���...
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
 REM ***WHAT IF SOMEONE START THE PROGRAM MANY TIMES?
  if exist %systemdrive%\ast_bkup_00\ (
      rd /s /q %systemdrive%\ast_bkup_00
  ) 
if exist %systemdrive%\ast_bkup\ (
	REM ***WHAT IF SOMEONE START THE PROGRAM WHEN OS CRASHED?
	ren %systemdrive%\ast_bkup ast_bkup_00
	rd /s /q %systemdrive%\ast_bkup
	)

REM Now begins initializing...
mkdir C:\ast_bkup > nul
mkdir C:\ast_temp > nul
mkdir C:\ast_strt > nul
if not exist .\7z.exe (
    if "%lang%"=="2" (
        echo Error: 7z.exe was not found. And Anthon-Starter cannot run successfully. 
        echo         Program will now exit! Press any key to exit!
        pause>nul
        cls
        exit
)
    if "%lang%"=="1" (
        echo Error: 7z.exe 不存在. 安同开始程序将不能运行. 
        echo          按任意键退出!
        pause>nul
        cls
        exit
)
)
copy .\7z.exe C:\ast_temp > nul
if not exist .\7z.dll (
    if "%lang%"=="1" (
        echo Error: 7z.dll was not found. And Anthon-Starter cannot run successfully. 
        echo         Program will now exit! Press any key to exit!
        pause>nul
        cls
        exit
)
    if "%lang%"=="2" (
        echo Error: 7z.dll 不存在. 安同开始程序将不能运行. 
        echo          按任意键退出!
        pause>nul
        cls
        exit
)
)
copy .\7z.dll C:\ast_temp > nul
if not exist misc (
     if "%lang%"=="2" (
        echo Error: misc was not found. And Anthon-Starter cannot run successfully. 
        echo       Program will now exit! Press any key to exit!
        pause>nul
        cls
        exit
)
    if "%lang%"=="1" (
        echo 错误: misc 不存在. 安同开始程序将不能运行. 
        echo     按任意键退出!
        pause>nul
        cls
        exit
)
)
copy .\misc C:\ast_temp > nul
cd /d C:\ast_temp > nul
7z e .\misc > nul
del .\misc > nul


REM Check the type of loader ( OS )
if exist %systemdrive%\boot.ini set loader=nt5
if exist %systemdrive%\Windows\boot\ set loader=nt6
REM CHECK IF 7Z HAVE GENERATED "main.exe"
if not exist .\main.exe (
    if "%lang%"=="1" (
        echo   错误:程序在运行时发生问题,不能继续! 错误代码：%errorlevel%  按任意键退出本程序。
    )
    if "%lang%"=="2" (
        echo   Error: A FATAL error occurred while running, so the program cannot continue! 
        echo   The error code is ：%errorlevel%
        echo   Press any key to exit the program.
    )
    pause>nul
    exit
 )
REM GO YOU!
start .\main.exe %lang% %loader%

REM WHAT IF SOMEONE CLICK 'NO' WHEN UAC NOTIFIES?
if "%errorlevel%"=="5" (
	if "%lang%"=="1" (
		echo   ע�⣺���ܾ��˰�ͬ��ʼ����������Ȩ�ޣ���ͬ��ʼ�������޷����С�
		echo         ���������˳���������
		)
	if "%lang%"=="2" (
		echo   Attention: You've refused the permission elevating requirement of Anthon-Starter!
		echo              Anthon-Starter cannot run successfully.
		echo   Press any key to exit the program.
	)
pause > nul
goto dist_clean
)

if "%errorlevel%"=="0" exit

REM There must be something wrong when error code isn't 0...
if "%lang%"=="1" (
	echo   *** ����װ���ڼ䷢���������Ĵ��󣬰�ͬ��ʼ�����޷����С�
	echo   *** �������룺%errorlevel%
	echo.
	echo       ������ http://bugs.anthonos.org �����Ǳ�����������...
	echo.
	echo ���������˳���������
	)
if "%lang%"=="2" (
	echo   *** An error occurred when initializing and Anthon-Starter cannot run successfully.
	echo   *** Error code: %errorlevel%
	echo.
	echo       Please visit http://bugs.anthonos.org to report this problem!
	echo.
	echo   Press any key to exit.
	)
pause > nul
goto dist_clean
:dist_clean
rd /s /q %systemdrive%\ast_strt
rd /s /q %systemdrive%\ast_bkup
rd /s /q %systemdrive%\ast_temp
set lang=
exit
