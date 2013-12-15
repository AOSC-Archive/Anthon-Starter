@REM  Anthon-Starter: Installation helper for :Next Linux distribution series. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off
title Anthon Open Source Community - Junde Studio
:language
cls
echo                    ====£¾£¾£¾Choose your language:£¼£¼£¼====
echo                    [                                       ]
echo                    [       1:  ¼òÌåÖĞÎÄ                    ]
echo                    [       2:  English                     ]
echo                    [                                       ]
echo                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
set /p lang=Input the number:
if "%lang%"=="" (
	set lang=
	goto language
)

title Initializing...

mkdir C:\atosbkup
mkdir C:\atostemp
mkdir C:\atosstrt
copy .\7z.exe C:\atostemp
copy .\7z.dll C:\atostemp
copy .\tools C:\atostemp
cd /d C:\atostemp
7z e .\tools
del .\tools

echo %SystemDrive% >info.ast
start .\main.bat %lang%
