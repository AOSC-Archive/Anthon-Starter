@REM  Anthon-Starter: Installation helper for :Next Linux distribution series.
@REM  This is the main batch file. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off
cls
title 安同开始程序 0.1.2

if not exist %systemdrive%\info.ast (
 echo 警告：找不到配置文件。将缺少部分功能。
 echo 
 echo Warning: Can't load the settings. Some features will be missing.
 echo Wartung: Konfigurationsdatei kann nicht gefunden werden!!!
 ping 127.0.0.1 >nul
 goto eng_main
)

echo Loading...
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\info.ast^|findstr "^1:"') do set lang=%%b
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\info.ast^|findstr "^2:"') do set tarball=%%b
 if "%lang%"=="1 " goto schn_main
 if "%lang%"=="2 " goto tchn_main
 if "%lang%"=="3 " goto eng_main
 if "%lang%"=="4 " goto ger_main



:schn_main
cls
echo ====================＞＞＞欢迎使用安同开始程序＜＜＜====================
echo.
echo 感谢您安装安同OS，在此安同OS全体开发人员预祝您能够愉快地使用安同OS。
echo 开始程序已经准备好了对安装后系统残留的文件进行清扫。
echo.
echo 请按任意键键执行操作，或者您可以关掉此窗口。
pause >nul
goto run

:tchn_main
cls
echo ====================＞＞＞歡迎使用安同開始程式＜＜＜====================
echo.
echo 感謝您安裝安同OS，在此安同OS全部的開發者預祝您能夠愉快地使用安同OS。
echo 開始程式已經準備好了對安裝后系統殘餘文件進行清掃。
echo.
echo 請按下任意按鍵開始操作，或者您也可以關閉窗口。
pause >nul
goto run

:eng_main
cls
title Anthon-Starter 0.1.2
echo =========================＞＞＞Welcome!＜＜＜=========================
echo.
echo Thank you for choosing AnthonOS.
echo Here all the developers wish you have a pleasant trip with AnthonOS.
echo.
echo Now AnthonOS-Starter is ready for trash cleaning.
echo.
echo Press any key to execute, or you can close the window.
pause >nul
goto run

:ger_main
cls
title Anthon-Starter 0.1.2
echo =========================＞＞＞Willkommen!＜＜＜=========================
echo.
echo Danke fur die Installation von Anthon, besten Wunsche von den Entwicklern!
echo Das Programm ist bereit zu saubern all das Durcheinander nach der Installation!
echo.
echo Drucken Sie die Eingabetaste, um die Installation zu starten, oder schliessen Sie das Fenster zum Abbruch! 
pause >nul
goto run


:run
if "%lang%"=="1 " echo 请稍候，安同开始程序正在执行任务……
if "%lang%"=="2 " echo 請稍後，安同開始程式正在執行任務……
if "%lang%"=="3 " echo Please wait while AnthonOS-Starter is cleaning files...
if "%lang%"=="4 " echo Bitte warten, wahrend das Programm arbeitet hart...

if exist %systemdrive%\atosbkup\boot.ini (
 attrib -s -h -r %systemdrive%\boot.ini
 del /f %systemdrive%\boot.ini
 copy %systemdrive%\atosbkup\boot.ini %systemdrive%\
 attrib +s +h +r %systemdrive%\boot.ini
)
if exist %systemdrive%\atosbkup\BCDbckup (
 bcdedit /import %systemdrive%\atosbkup\BCDbckup
)

rd /s /q %systemdrive%\anthon
rd /s /q %systemdrive%\atosbkup
del /f %systemdrive%\grldr
del /f %systemdrive%\grldr.mbr
del /f %systemdrive%\menu.lst
if exist %tarball%tarball.tar.xz del /f %tarball%tarball.tar.xz
del %systemdrive%\info.ast
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon /f
pause
if "%lang%"=="1 " goto finish1
if "%lang%"=="2 " goto finish2
if "%lang%"=="3 " goto finish3
if "%lang%"=="4 " goto finish4
goto finish3

:finish1
cls
echo 操作已完成！感谢您对中国青少年开源事业的支持！
echo.
echo 请按任意键结束本程序。
pause>nul
rd /s /q %systemdrive%\atostemp
exit

:finish2
cls
echo 操作完成！感謝您對中國青少年開源事業的支持！
echo.
echo 請按任意鍵結束本程序。
pause>nul
rd /s /q %systemdrive%\atostemp
exit

:finish3
cls
echo Cleaning has already Finished! Thanks for your support!
echo.
echo Press any key to finish.
pause>nul
rd /s /q %systemdrive%\atostemp
exit

:finish4
cls
echo Gemacht! Danke fur die Unterstutzung!
echo.
echo Drücken Sie eine beliebige Taste...
pause>nul
rd /s /q %systemdrive%\atostemp
exit
