@REM  Anthon-Starter: Installation helper for :Next Linux distribution series.
@REM  This is the main batch file. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off
cls
title ��ͬ��ʼ���� 0.1.2

if not exist %systemdrive%\info.ast (
 echo ���棺�Ҳ��������ļ�����ȱ�ٲ��ֹ��ܡ�
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
echo ====================��������ӭʹ�ð�ͬ��ʼ���򣼣���====================
echo.
echo ��л����װ��ͬOS���ڴ˰�ͬOSȫ�忪����ԱԤף���ܹ�����ʹ�ð�ͬOS��
echo ��ʼ�����Ѿ�׼�����˶԰�װ��ϵͳ�������ļ�������ɨ��
echo.
echo �밴�������ִ�в��������������Թص��˴��ڡ�
pause >nul
goto run

:tchn_main
cls
echo ====================�������gӭʹ�ð�ͬ�_ʼ��ʽ������====================
echo.
echo ���x�����b��ͬOS���ڴ˰�ͬOSȫ�����_�l���Aף���܉�����ʹ�ð�ͬOS��
echo �_ʼ��ʽ�ѽ��ʂ���ˌ����b��ϵ�y���N�ļ��M����ߡ�
echo.
echo Ո�������ⰴ�I�_ʼ������������Ҳ�����P�]���ڡ�
pause >nul
goto run

:eng_main
cls
title Anthon-Starter 0.1.2
echo =========================������Welcome!������=========================
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
echo =========================������Willkommen!������=========================
echo.
echo Danke fur die Installation von Anthon, besten Wunsche von den Entwicklern!
echo Das Programm ist bereit zu saubern all das Durcheinander nach der Installation!
echo.
echo Drucken Sie die Eingabetaste, um die Installation zu starten, oder schliessen Sie das Fenster zum Abbruch! 
pause >nul
goto run


:run
if "%lang%"=="1 " echo ���Ժ򣬰�ͬ��ʼ��������ִ�����񡭡�
if "%lang%"=="2 " echo Ո���ᣬ��ͬ�_ʼ��ʽ���ڈ����΄ա���
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
echo ��������ɣ���л�����й������꿪Դ��ҵ��֧�֣�
echo.
echo �밴���������������
pause>nul
rd /s /q %systemdrive%\atostemp
exit

:finish2
cls
echo ������ɣ����x�����Ї��������_Դ�I��֧�֣�
echo.
echo Ո�������I�Y��������
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
echo Dr��cken Sie eine beliebige Taste...
pause>nul
rd /s /q %systemdrive%\atostemp
exit
