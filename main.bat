@REM  Anthon-Starter: Installation helper for :Next Linux distribution series. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off

REM Check the parameters(%1 is language; %2 is loader type)
REM Parameters will be added extra "" in Windows, so you see """".
if "%1"=="" exit
if "%2"=="" exit

if "%1"==""1"" goto cn_main
if "%2"==""2"" goto en_main
goto self_del

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
	goto cn_check
)
if "%cho%"=="license" (
	set cho=
	start notepad.exe %systemdrive%\ast_temp\LICENSE
	goto cn_main
)
if "%cho%"=="about" (
	set cho=
	goto cn_about
)
if "%cho%"=="exit" (
	set cho=
	goto self_del
)
set cho=
goto cn_main





:cn_check
cls
echo =====================�������� 1 ��  �������������====================
echo.
if "%2"==""nt5"" echo * ̽�⵽����ϵͳ����ΪWindows NT5ϵ�У�Windows 2k, XP�ȣ�
if "%2"==""nt6"" echo * ̽�⵽����ϵͳ����ΪWindows NT6ϵ�У�Windows Vista, 7, 8�ȣ�
echo.
echo �ڰ�װϵͳ֮ǰ������ע������ע�����
echo   1. ����ذѰ�װ�����ļ�װ�뱾��Ӳ�̣�������U�̡��ƶ�Ӳ�̡�MP3���豸����
echo   2. ��ͬ��Դ�������з��а��ֻ������x86_64�ܹ������봦�����ϣ������в�ѯ����
echo        ������Ƿ����Ҫ�󣬰�ͬ��ʼ������ʱ���ṩ�Զ���鹦�ܣ�
echo   3. ��ͬ��Դ�������з��а�Ҫ���������в�����2GB�ڴ�ļ���������У��������
echo        �������л��������ٵ������
echo   4. ��������ѭGNU GPL���֤��������ͬ��Դ�������а������ѭGNU LGPL������
echo.
echo ȷ������������ y ������װ��ֱ�Ӱ��»س������������ַ��˳���ͬ��ʼ����
set /p chkcho=��
if "%chkcho%"=="y" goto cn_image
REM Delete the temp files
goto self_del




:cn_image
cls
echo =====================�������� 2 ��  ѡ���ļ�������======================
echo.
echo �����������ȡ�Ĺ���ӳ���ļ�������λ�á�
echo   ��ע�⡿������ַǷ��ַ���·�������²���ʧ�ܣ�
echo �Ҽ�ճ�����ܿ��ã����� EXIT �����˳�������
set /p file=��
if "%file%"=="EXIT" goto self_del
if "%file%"=="^" goto cn_err1
if "%file%"=="." goto cn_err1
if "%file%"=="*" goto cn_err1
if "%file%"=="/" goto cn_err1
if "%file%"=="\" goto cn_err1
if "%file%"=="," goto cn_err1
if "%file%"=="=" goto cn_err1
if "%file%"=="" goto cn_err1
if not exist %file% goto cn_err1
goto cn_target


:cn_target
cls
echo =====================�������� 3 ��  ��ѹλ�ã�����======================
echo.
echo ������һ����ѹλ����ȷ����װ������������ͷ��ļ���
echo   ֱ�Ӱ��»س������趨��ѹλ��Ϊ%systemdrive%\
echo.
echo   * ���뷽ʽʾ����%systemdrive%\  ���� EXIT �����˳�������
set /p location=��
if "%location%"=="EXIT" goto self_del
if "%location%"=="" (
	set location=%systemdrive%\
	goto cn_way
)
if not exist %location% goto cn_err2
goto cn_way


:cn_way
cls
echo =====================�������� 4 ��  ��װ��ʽ������======================
echo.
echo ��ָ����������װ������ʹ�õ�������ʽ��
echo   ��ע�⡿������ӵ��רҵ֪ʶ��������ʹ��Ĭ�����á�ͨ��NT������Ƕ����������
echo.
echo   * ֱ�Ӱ��»س����趨��װ��ʽΪ��ͨ��NT������Ƕ����������
echo   * ���� write_mbr �����»س����趨��װ��ʽΪ��ͨ����������¼��������
echo   * ���� EXIT �����»س��������˳�������
set /p instway=��
if "%instway%"=="EXIT" goto self_del
if "%instway%"=="" (
	set instway=edit_present
	goto cn_ready
)
if "%instway%"=="write_mbr" goto cn_ready
set instway=
goto cn_way



:cn_ready
cls
echo ====================�������� 5 ��  ׼����װ���򣼣���====================
echo.
echo ��ȷ�����������Ƿ���ȷ��
echo * ���趨���ļ�Ϊ��%file%
echo * ���趨�Ľ�ѹ·��Ϊ��%location%
if "%instway%"=="edit_present" echo * ����ͨ��NT������Ƕ��������װ����Ĭ�����ã�
if "%instway%"=="write_mbr" echo * ����ͨ���޸���������¼������װ����
echo.
echo ���»س�����ʼ׼����װ���򣬷�������� no Ȼ��س���
echo   ���� EXIT Ȼ���»س������˳�������
set /p yesno=��
if "%yesno%"=="no" (
	set file=
	set location=
	set instway=
	set yesno=
	goto cn_image
)
if "%yesno%"=="EXIT" goto self_del
if "%yesno%"=="" goto cn_run
set yesno=
goto cn_ready

:cn_run
cls
echo ========================������׼����װ�����У�����========================
echo ��ͬ��ʼ��������Ŭ��׼���ð�װ����
echo ���������ҪһЩʱ�������ĵȴ���
echo.
echo  00�� ����ϵͳ��Ҫλ��...

if "%2"==""nt5"" (
	attrib -s -h -r %systemdrive%\boot.ini
	copy %systemdrive%\boot.ini %systemdrive%\ast_bkup
	)
if "%2"==""nt6"" bcdedit /export %systemdrive%\ast_bkup\BCDbckup

dd if=\\?\Device\Harddisk0\Partition1 of=%systemdrive%\ast_bkup\MBRbckup bs=512 count=1

REM /*******************************RESEARCHING...*/
REM echo  10����У�鰲װ�ļ�...
REM wget http://mirror.anthonos.org/junde-studio/sha_image_aosc.txt
REM sha256sum --check sha_image_aosc.txt > nul
REM if not "%errorlevel%"=="0" (
REM 	echo        *** ӳ���ļ�У��ʧ�ܣ��������а�װ���ܵ��°�װʧ��... ������룺%errorlevel%
REM 	echo            ������װ������ y Ȼ���»س������������ַ���س��˳�����
REM 	set /p vercho=           ��
REM 	if not "%vercho%"=="y" goto self_del
REM )

echo  30�� ��ѹԤ��װ�����ں�...
REM While extracting the files in [image_file]/boot/ , the new folder 'boot' will be created too.
REM For some users will install some recovery software (like One-key Ghost, it'll create a folder named 'boot' too),
REM   we first extract them into %temp%\ and then copy them into ast_strt.
7z x %file% -o%temp%\ boot\vmlinuz -y > nul
move %temp%\boot\vmlinuz %systemdrive%\ast_strt

echo  45�� ��ѹԤ��װ�����ڴ���...
7z x %file% -o%temp%\ boot\initrd -y > nul
move %temp%\boot\initrd %systemdrive%\ast_strt

echo  55�� ��ѹ����ϵͳ��װ�ļ�...
echo         * �����̺�ʱ�ϳ��������ĵȴ���
7z x %file% -o%location% squash -y >nul

echo  85�� ��ʼ��������...

if "%instway%"=="edit_present" (
	if "%2"==""nt5"" goto cn_nt5_ntldr_edit
	if "%2"==""nt6"" goto cn_nt6_bcd_edit
)
if "%instway%"=="write_mbr" (
	grubinst --grub2 (hd0)
	goto edit_done
)

REM While setting variable in an "if(...)", it doesn't work. F**k CMD!
REM So we make this little hack...

:cn_nt5_ntldr_edit
echo [boot loader] > %systemdrive%\boot.ini
echo timeout=10 >> %systemdrive%\boot.ini
echo default=%systemdrive%\g2ldr >> %systemdrive%\boot.ini
echo [operating systems] >> %systemdrive%\boot.ini
echo %systemdrive%\WINDOWS="����ԭ����Windows����ϵͳ" >> %systemdrive%\boot.ini
echo %systemdrive%\g2ldr="������ͬ GNU/Linux��װ����" >> %systemdrive%\boot.ini
echo. >> %systemdrive%\boot.ini
goto edit_done
	
:cn_nt6_bcd_edit
for /f "delims=" %%i in ('bcdedit /create /d "������ͬ GNU/Linux ��װ����" /application bootsector') do set uid=%%i
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \g2ldr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
bcdedit /timeout 10
goto edit_done


:edit_done

echo  90�� ���ڲ�������...����ɵ�һ����������

if "%1"==""1"" (
	echo # Grub.cfg generated by Anthon-Starter 0.1.2 > %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
	echo set default="1" >> %systemdrive%\ast_strt\grub.cfg
	echo set gfxmode=1024x768 >> %systemdrive%\ast_strt\grub.cfg
	echo terminal_output gfxterm >> %systemdrive%\ast_strt\grub.cfg
	echo set timeout="10" >> %systemdrive%\ast_strt\grub.cfg
	echo loadfont /ast_strt/unicode.pf2 >> %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
	echo menuentry "����ԭ���� Windows ����ϵͳ" { >> %systemdrive%\ast_strt\grub.cfg
	echo   search --set=root --no-floppy /ntldr >> %systemdrive%\ast_strt\grub.cfg
	echo   chainloader /ntldr >> %systemdrive%\ast_strt\grub.cfg
	echo   boot >> %systemdrive%\ast_strt\grub.cfg
	echo } >> %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
	echo menuentry "������ͬ GNU/Linux ��װ����" { >> %systemdrive%\ast_strt\grub.cfg
	echo   search --set=root --no-floppy /ast_strt/vmlinuz >> %systemdrive%\ast_strt\grub.cfg
	echo   linux /ast_strt/vmlinuz boot=live config quiet noswap noeject rw >> %systemdrive%\ast_strt\grub.cfg
	echo   initd /ast_strt/initrd >> %systemdrive%\ast_strt\grub.cfg
	echo   boot >> %systemdrive%\ast_strt\grub.cfg
	echo } >> %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
	echo menuentry "������ͬ GNU/Linux ��װ���򣨰�ȫ��ʾ�趨ģʽ��"{ >> %systemdrive%\ast_strt\grub.cfg
	echo   search --set=root --no-floppy /ast_strt/vmlinuz >> %systemdrive%\ast_strt\grub.cfg
	echo   linux /ast_strt/vmlinuz boot=live config quiet noswap noeject nomodeset vga=normal rw >> %systemdrive%\ast_strt\grub.cfg
	echo   initd /ast_strt/initrd >> %systemdrive%\ast_strt\grub.cfg
	echo   boot >> %systemdrive%\ast_strt\grub.cfg
	echo } >> %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
)
if "%2"==""2"" (
	echo # Grub.cfg generated by Anthon-Starter 0.1.2 > %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
	echo set default="1" >> %systemdrive%\ast_strt\grub.cfg
	echo set gfxmode=1024x768 >> %systemdrive%\ast_strt\grub.cfg
	echo terminal_output gfxterm >> %systemdrive%\ast_strt\grub.cfg
	echo set timeout="10" >> %systemdrive%\ast_strt\grub.cfg
	echo loadfont /ast_strt/unicode.pf2 >> %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
	echo menuentry "Start Windows Operating System" { >> %systemdrive%\ast_strt\grub.cfg
	echo   search --set=root --no-floppy /ntldr >> %systemdrive%\ast_strt\grub.cfg
	echo   chainloader /ntldr >> %systemdrive%\ast_strt\grub.cfg
	echo   boot >> %systemdrive%\ast_strt\grub.cfg
	echo } >> %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
	echo menuentry "Start Anthon GNU/Linux Installer" { >> %systemdrive%\ast_strt\grub.cfg
	echo   search --set=root --no-floppy /ast_strt/vmlinuz >> %systemdrive%\ast_strt\grub.cfg
	echo   linux /ast_strt/vmlinuz boot=live config quiet noswap noeject rw >> %systemdrive%\ast_strt\grub.cfg
	echo   initd /ast_strt/initrd >> %systemdrive%\ast_strt\grub.cfg
	echo   boot >> %systemdrive%\ast_strt\grub.cfg
	echo } >> %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
	echo menuentry "������ͬ GNU/Linux ��װ���򣨰�ȫ��ʾ�趨ģʽ��"{ >> %systemdrive%\ast_strt\grub.cfg
	echo   search --set=root --no-floppy /ast_strt/vmlinuz >> %systemdrive%\ast_strt\grub.cfg
	echo   linux /ast_strt/vmlinuz boot=live config quiet noswap noeject nomodeset vga=normal rw >> %systemdrive%\ast_strt\grub.cfg
	echo   initd /ast_strt/initrd >> %systemdrive%\ast_strt\grub.cfg
	echo   boot >> %systemdrive%\ast_strt\grub.cfg
	echo } >> %systemdrive%\ast_strt\grub.cfg
	echo. >> %systemdrive%\ast_strt\grub.cfg
)
echo  95�� ���ڲ�������...����ɵڶ�����������

copy %systemdrive%\ast_temp\g2ldr %systemdrive%\
copy %systemdrive%\ast_temp\unicode.pf2 %systemdrive%\ast_strt\

echo 100�� ���ڲ�������...����ɵ�������������
pause


:cn_finish
cls
echo =======================������������������=======================
echo.
echo ��ͬ��ʼ�����Ѿ�׼�����˲���ϵͳ�İ�װ���𣬼���������������װ����
echo �뱣������Ĺ�������������������������ĵ��ԡ�
pause>nul
goto before_reboot


:cn_err1
cls
echo =======================������������������=======================
echo.
echo �����������ļ��������ڣ���ȷ��·���Ƿ����...
echo.
echo ���������������һ����
pause>nul
set file=
goto cn_image

:cn_err2
cls
echo =======================������������������=======================
echo.
echo �����������̷��������ڣ���ȷ���̷��Ƿ����...
echo.
echo ���������������һ����
pause>nul
set location=
goto cn_target












:en_main
cls
title Anthon-Starter 0.1.2
echo =========================������Welcome!������=========================
echo.
echo We haven't finished it yet!
pause > nul
exit









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
echo Press any key to return.
pause >nul
set cho=
goto en_main


:before_reboot
echo %1 > %systemdrive%\ast_strt\info.ast
echo %location% >> %systemdrive%\ast_strt\info.ast
copy %systemdrive%\ast_temp\startup.exe %systemdrive%\ast_strt\
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon-Starter_Startup_Utility /t REG_SZ /d %systemdrive%\ast_strt\startup.exe /f
rd /s /q %systemdrive%\ast_temp
REM shutdown -r -t 00
exit

:self_del
set ptable=
set loader=
set file=
set location=
set instway=
set freesize=
set cho=
set chkcho=
set yesno=
set vercho=

REM ***Here we have a problem, which cannot let the program delete itself.

rd /s /q %systemdrive%\ast_bkup
rd /s /q %systemdrive%\ast_strt
rd /s /q %systemdrive%\ast_temp
exit