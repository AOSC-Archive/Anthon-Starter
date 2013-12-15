@REM  Anthon-Starter: Installation helper for :Next Linux distribution series. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off

if "%1"=="1" goto cn_main
if "%1"=="2" goto en_main





REM //////////SimplifiedChinese
:cn_main
cls
title ��ͬ��ʼ���� 0.1.2
echo ====================��������ӭʹ�ð�ͬ��ʼ���򣼣���====================
echo.
echo ���������������ɵش�Ӳ�̰�װ��ͬGNU/Linux�����
echo ����������������ĿIcenowyLinux��
echo.
echo * Ҫ���Ͽ�ʼ��װ����ֱ���û��س�����
echo * Ҫ�鿴������İ�Ȩ��Ϣ����� license Ȼ��س���
echo * ���ڱ���������� about Ȼ��س���
echo * �˳������������ exit Ȼ��س���
echo.
set /p cho=ѡ��һ��ѡ�
if "%cho%"=="" (
 set cho=
 goto cn_chkldr
)
if "%cho%"=="license" (
 set cho=
 start notepad.exe .\LICENSE
 goto cn_main
)
if "%cho%"=="about" (
 set cho=
 goto cn_about
)
if "%cho%"=="exit" (
 set cho=
 exit
)
set cho=
goto cn_main


:cn_chkldr
if "%1"=="" (
 if exist %systemdrive%\boot.ini (
  set loader=NT5.x[Win2k/XP]
  goto cn_chkgpt
 )
 if exist %systemdrive%\Windows\boot\ (
  set loader=NT6.x[WinVista+]
  goto cn_chkgpt
 )
)



:cn_chkgpt
mountvol W:\ /s
if "%ERRORLEVEL%"=="1" (
	echo.
	echo GPT������������ʧ�ܣ�Ϊ�˰�ȫ����������˳�...
	echo ������ѯ�����ļ��������Ա�˽������
	pause
	exit
)
if "%ERRORLEVEL%"=="9009" (
	set gpt_status=0
	goto cn_inst
)
set gpt_status=1
goto cn_inst





:cn_inst
cls
echo ====================��������1��  ѡ���ļ�������====================
echo.
echo ̽�⵽����ϵͳΪ��%loader%
if "%gpt_status%"=="0" echo ̽�⵽���ķ�����Ϊ��MBR����������¼��
if "%gpt_status%"=="1" echo ̽�⵽���ķ�����Ϊ��GPT��GUID������
echo.
echo �����������ȡ�Ĺ���ӳ���ļ�������λ�ã�����������ϵ������
echo ע�⣺������ַǷ��ַ���·�������²���ʧ�ܣ�
set /p file=����
if "%file%"=="^" goto cn_err1
if "%file%"=="." goto cn_err1
if "%file%"=="*" goto cn_err1
if "%file%"=="/" goto cn_err1
if "%file%"=="\" goto cn_err1
if "%file%"=="," goto cn_err1
if "%file%"=="=" goto cn_err1
if "%file%"=="" goto cn_err1
if not exist %file% goto cn_err1
goto cn_extr


:cn_extr
cls
echo ====================��������2��  ��ѹλ�ã�����====================
echo.
echo ���������Ҫ����Щ�ļ���ѹ�����
echo ֱ�� [�س�] ���趨Ϊϵͳ%systemdrive%\�̡�����ʾ����%systemdrive%\
set /p location=����
if "%location%"=="" set location=%systemdrive%\
if not exist %location% goto cn_err2 &REM //////////////////////////////////////////////////////û������ļ���ʱ����ת����Ӧ������ʾ
goto cn_goingon


:cn_goingon
cls
echo ====================��������3��  ׼����װ���򣼣���====================
echo.
echo ���趨���ļ�Ϊ��%file%
echo ���趨�Ľ�ѹ·��Ϊ��%location%
echo.
echo ȷ���� [�س�] ��ʼ׼����װ���򣬷�������� no Ȼ��س���
set /p yesno=����
if "%yesno%"=="no" (
 set file=
 set location=
 set yesno=
 goto cn_inst
) &REM //////////////////////////////////////////////////////��һ����ˣ����Իظ����¿�ʼ
echo ��ͬ��ʼ��������Ŭ��׼���ð�װ����
echo ���������ҪһЩʱ�������ĵȴ���
title ��ͬ��ʼ���� 0.1.2                    0����ѹ�ں�...
7z x %file% -o%systemdrive%\ boot\vmlinuz -y >nul
title ��ͬ��ʼ���� 0.1.2                    15����ѹԤ��װ����...
7z x %file% -o%systemdrive%\ boot\initrd.img -y >nul
title ��ͬ��ʼ���� 0.1.2                    25����ѹ����ϵͳ��װ��...
7z x %file% -o%location% tarball.tar.xz -y >nul
title ��ͬ��ʼ���� 0.1.2                    80����ʼ��������...


title ��ͬ��ʼ���� 0.1.2                    82����������...



if not exist %systemdrive%\boot\* rd /s /q %systemdrive%\boot &REM ///////////����в�������������ԭ����ʱδ֪��

title ��ͬ��ʼ���� 0.1.2                    95����������...


:cn_finish
title ��ͬ��ʼ���� 0.1.2
cls
echo ====================������������������====================
echo.
echo ��ͬ��ʼ�����Ѿ�׼�����˲���ϵͳ�İ�װ���𣬼���������������װ����
echo �뱣������Ĺ�������������������������ĵ��ԡ�
pause>nul
set lang=
set file=
set location=
set yesno=
set loader=
REM shutdown -r -t 00

exit


:cn_err1
cls
echo ====================������������������====================
echo.
echo �����������ļ��������ڣ���ȷ��·���Ƿ����...
echo.
echo ���������������һ����
pause>nul
set file=
goto cn_inst

:cn_err2
cls
echo ====================������������������====================
echo.
echo �����������̷��������ڣ���ȷ���̷��Ƿ����...
echo.
echo ���������������һ����
pause>nul
set location=
goto cn_extr












REM //////////English
:en_main
cls
title Anthon-Starter 0.1.2
echo =========================������Welcome!������=========================
echo.
echo Now Anthon GNU/Linux will be installed to your computer with Anthon-Starter
echo (or IcenowyLinux)
echo.
echo * To install right now press [Enter] ;
echo * To read the license of this programme, input 'license' and press [Enter] ;
echo * For more information of this programme, input 'about' and press [Enter] ;
echo * To exit the programme, input 'exit' and press [Enter] .
echo.
set /p cho=Choose an option:
if "%cho%"=="" (
 set cho=
 goto en_check
)
if "%cho%"=="license" (
 set cho=
 start notepad.exe .\LICENSE
 goto english
)
if "%cho%"=="about" (
 set cho=
 goto en_about
)
if "%cho%"=="exit" (
 set cho=
 exit
)
set cho=
goto english


:en_check



:en_inst
cls
echo ====================������Step 1: Choose The File������====================
echo.
echo Auto detecting your boot loader: %loader%
echo Please input the path of the image file (You can also drag here).
echo Warning: Any illegal character is NOT allowed!
set /p file=����
if "%file%"=="^" goto en_err1
if "%file%"=="." goto en_err1
if "%file%"=="*" goto en_err1
if "%file%"=="/" goto en_err1
if "%file%"=="\" goto en_err1
if "%file%"=="," goto en_err1
if "%file%"=="=" goto en_err1
if "%file%"=="" goto en_err1
if not exist %file% goto en_err1
goto en_extr


:en_extr
cls
echo ====================������Step 2: Extraction Path������====================
echo.
echo Where do you want to extract the files?
echo Will auto set the path to %systemdrive%\ if pressed [Enter] . Example: %systemdrive%\
set /p location=����
if "%location%"=="" set location=%systemdrive%\
if not exist %location% goto en_err2
goto en_exec


:eng_exec
cls
echo ====================������Step 3: Running������====================
echo.
echo The image file is %file%
echo The location is %location%
echo.
echo Are you sure? Press [Enter] to execute immediately.
echo Or you can input 'no' to give up.
set /p yesno=����
if "%yesno%"=="no" (
 set file=
 set location=
 set yesno=
 goto eng_inst
)
echo Anthon-Starter is loading files.
echo Will take a few minutes. Please wait patiently...
title Anthon-Starter 0.1.2                    0��Extracting Kernel...
7z x %file% -o%systemdrive%\ boot\vmlinuz -y >nul
title Anthon-Starter 0.1.2                    15��Entracting PE...
7z x %file% -o%systemdrive%\ boot\initrd.img -y >nul
title Anthon-Starter 0.1.2                    25��Extracting OS package...
7z x %file% -o%location% tarball.tar.xz -y >nul
title Anthon-Starter 0.1.2                    80��Deploying...




title Anthon-Starter 0.1.2                    82��Deploying...


title Anthon-Starter 0.1.2                    95��Deploying...



:en_finish
title Anthon-Starter 0.1.2
cls
echo =========================������Ready!������=========================
echo.
echo Now Anthon GNU/Linux has been already deployed!
echo And will restart to the installer immediately.
echo.
echo Please save your work and press any key to restart.
pause>nul
set lang=
set file=
set location=
set yesno=
set loader=
REM shutdown -r -t 00

exit


:en_err1
cls
echo =========================������ Error... ������=========================
echo.
echo Can't find the image file. Please check if the path is right!
echo.
echo Press any key to return...
pause>nul
set file=
goto en_inst

:en_err2
cls
echo =========================������ Error... ������=========================
echo.
echo Can't load the path.
echo 'There must be something wrong with it.'
echo.
echo Press any key to return...
pause>nul
set location=
goto en_extr







:nt5_cn

attrib -s -h -r %systemdrive%\boot.ini
mkdir %systemdrive%\atosbkup
cd /d %systemdrive%\atostemp
cd ..
copy %systemdrive%\boot.ini %systemdrive%\atosbkup
del /f %systemdrive%\boot.ini
echo [boot loader] >%systemdrive%\boot.ini
echo timeout=10 >>%systemdrive%\boot.ini
echo default=%systemdrive%\grldr >>%systemdrive%\boot.ini
echo [operating systems] >>%systemdrive%\boot.ini
echo %systemdrive%\grldr="������ͬOS��װ����" >>%systemdrive%\boot.ini
echo %Systemroot%="����ԭ����Windows����ϵͳ" >>%systemdrive%\boot.ini
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon /t REG_SZ /d %Systemdrive%\atostemp\atosstup.exe /f
goto cn_finish


:nt5_tradchn
attrib -s -h -r %systemdrive%\boot.ini
mkdir %systemdrive%\atosbkup
cd /d %systemdrive%\atostemp
cd ..
copy %systemdrive%\boot.ini %systemdrive%\atosbkup
del /f %systemdrive%\boot.ini
echo [boot loader] >%systemdrive%\boot.ini
echo timeout=10 >>%systemdrive%\boot.ini
echo default=%systemdrive%\grldr >>%systemdrive%\boot.ini
echo [operating systems] >>%systemdrive%\boot.ini
echo %systemdrive%\grldr="���Ӱ�ͬOS�_ʼ��ʽ" >>%systemdrive%\boot.ini
echo %Systemroot%="����֮ǰ��Windows���Iϵ�y" >>%systemdrive%\boot.ini
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon /t REG_SZ /d %Systemdrive%\atostemp\atosstup.exe /f
goto tradchn_finish


:nt5_eng
attrib -s -h -r %systemdrive%\boot.ini
mkdir %systemdrive%\atosbkup
cd /d %systemdrive%\atostemp
cd ..
copy %systemdrive%\boot.ini %systemdrive%\atosbkup
del /f %systemdrive%\boot.ini
echo [boot loader] >%systemdrive%\boot.ini
echo timeout=10 >>%systemdrive%\boot.ini
echo default=%systemdrive%\grldr >>%systemdrive%\boot.ini
echo [operating systems] >>%systemdrive%\boot.ini
echo %systemdrive%\grldr="Start AnthonOS Installer" >>%systemdrive%\boot.ini
echo %Systemroot%="Start the Windows before" >>%systemdrive%\boot.ini
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon /t REG_SZ /d %Systemdrive%\atostemp\atosstup.exe /f
goto eng_finish
pause


:nt5_ger
attrib -s -h -r %systemdrive%\boot.ini
mkdir %systemdrive%\atosbkup
cd /d %systemdrive%\atostemp
cd ..
copy %systemdrive%\boot.ini %systemdrive%\atosbkup
del /f %systemdrive%\boot.ini
echo [boot loader] >%systemdrive%\boot.ini
echo timeout=10 >>%systemdrive%\boot.ini
echo default=%systemdrive%\grldr >>%systemdrive%\boot.ini
echo [operating systems] >>%systemdrive%\boot.ini
echo %systemdrive%\grldr="Starten sie Anthon Installer" >>%systemdrive%\boot.ini
echo %Systemroot%="Starten sie Windows" >>%systemdrive%\boot.ini
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon /t REG_SZ /d %Systemdrive%\atostemp\atosstup.exe /f
goto ger_finish



:nt6
mkdir %systemdrive%\atostemp
copy grldr %systemdrive%\atostemp >nul
copy grldr.mbr %systemdrive%\atostemp >nul
copy atosstup.exe %systemdrive%\atostemp >nul
start bcde.exe %lang% %location%
if "%lang%"=="1" goto cn_finish
if "%lang%"=="2" goto tradchn_finish
if "%lang%"=="3" goto eng_finish
if "%lang%"=="4" goto ger_finish


:cn_about
cls
title ���ڰ�ͬ��ʼ���� 0.1.1
echo                                   AS ��ͬ Do.
echo.
echo                               ��ͬ��ʼ����0.1.2
echo                          ��ͬ��Դ����-���¹����� ��Ʒ
echo.
echo ������Ϊ������������������������������������GNUͨ�ù�����Ȩ����涨���ͱ�������Ϊ�����룯���޸ģ����������ݵ��Ǳ���Ȩ�ĵڶ����������ѡ��ģ���һ�պ��еİ汾��
echo.
echo ��л���²����д���������Ա��
echo �Կ��� [lmy441900@gmail.com]
echo ruojiner [ruojiner@163.com]
echo.
echo ��ȡ������Ϣ�����¼��ͬ��Դ���� http://forum.anthonos.org/
echo.
echo �����������������Ļ��
pause >nul
set cho=
goto cn_main

:en_about
cls
title About Anthon-Starter 0.1.2
echo                                    AS Anthon Do.
echo.
echo                               AnthonOS-Starter 0.1.2
echo                    By Junde Studio - Anthon Open Source Community
echo.
echo This program is free software; you can redistribute it and/ormodify it under the terms of the GNU General Public Licenseas published by the Free Software Foundation; either version 2of the License, or (at your option) any later version.
echo.
echo Thanks for the following people involved in the preparation of the program:
echo Junde Yi [lmy441900@gmail.com]
echo ruojiner [ruojiner@163.com]
echo.
echo For any information, please visit http://forum.anthonos.org/
echo.
echo Press any key to return...
pause >nul
set cho=
goto en_main

