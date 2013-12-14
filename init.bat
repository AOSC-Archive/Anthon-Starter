@REM  Anthon-Starter: Installation helper for :Next Linux distribution series.
@REM  This is the main batch file. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off
mkdir C:\atosbkup
mkdir C:\atostemp
mkdir C:\atosstrt
copy 7z.exe C:\atostemp
copy 7z.dll C:\atostemp
copy tools C:\atostemp
cd /d C:\atostemp
7z e tools
del tools

echo %SystemDrive% >info.ast
pause
