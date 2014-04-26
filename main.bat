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

REM Check the parameters(%1 is language; %2 is loader type)
REM Parameters will be added extra "" in Windows, so you see """".
if "%1"=="" exit
if "%2"=="" exit

if "%1"==""1"" goto cn_main
if "%2"==""2"" goto en_main
goto self_del

REM //////////Simplified Chinese
:cn_main
cls
title ��ͬ��ʼ���� 0.1.2
echo ====================��������ӭʹ�ð�ͬ��ʼ���򣼣���====================
echo.
echo ���������������ɵش�Ӳ�̰�װ��ͬ��Դ�����Ĳ���ϵͳ���а棺
echo     * AnthonOS, AOSC����棻
echo     * CentralPoint, AOSC�������棻
echo     * IcenowyLinux, AOSC�����ܹ��棻
echo     * ...
echo.
echo.
echo * Ҫ���Ͽ�ʼ��װ����ֱ���û� �س� ����
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


REM Detect GPT...
REM   For init.bat has no power to do it...
mountvol W:\ /s
if "%errorlevel%"=="0" (
	if exist W:\EFI\ (
		set gpt_status=1
		mountvol W:\ /d
		goto detect_gpt_done_cn
	) else (
		set gpt_status=0
		mountvol W:\ /d
		goto detect_gpt_done_cn
	)
) else (
	echo *** �������󣺰�ͬ��ʼ�����޷���������ESP������������� %errorlevel%
	echo     Ϊ��ȫ��������򼴽��رա��Դ�������б�Ǹ��
	echo.
	echo     �뽫������ⱨ�������������
	echo         http://bugs.anthonos.org
	echo     �����Ǳ����������...
	echo.
	echo     ����������رձ�����
	pause > nul
	goto self_del
)


:detect_gpt_done_cn


echo =====================�������� 1 ��  �������������====================
echo.
if "%2"==""nt5"" echo * ̽�⵽����ϵͳ����ΪWindows NT5ϵ�У�Windows 2k, XP�ȣ�
if "%2"==""nt6"" echo * ̽�⵽����ϵͳ����ΪWindows NT6ϵ�У�Windows Vista, 7, 8�ȣ�
if "%gpt_status%"=="1" echo * ̽�⵽��ʹ����GUID������GPT��
if "%gpt_status%"=="0" echo * ̽�⵽��ʹ������������¼��MBR��
echo.
echo �ڰ�װϵͳ֮ǰ������ע������ע�����
echo.
echo   1. �� *���* �Ѱ�װ�����ļ�װ�뱾��Ӳ�̣�������U�̡��ƶ�Ӳ�̡�MP3���豸����
echo.
echo   2. ��ͬ��Դ�������з��а��ֻ������x86_64�ܹ������봦�����ϣ������в�ѯ����
echo        ������Ƿ����Ҫ�󣬰�ͬ��ʼ������ʱ���ṩ�Զ���鹦�ܣ�
echo.
echo   3. �뱣֤���ڰ�װ��Ӧ�汾��ϵͳ֮ǰ������Ķ���Ӳ��Ҫ������ʹ�����죻
echo.
echo   4. ��������ѭApache 2.0���֤��������ͬ��Դ�������а������ѭGNU LGPL������
echo.
echo.
echo ȷ������������ y ������װ��ֱ�Ӱ��»س������������ַ��˳���ͬ��ʼ����
set /p chkcho=��
if "%chkcho%"=="y" goto cn_image
REM Or exit, delete the temp files
goto self_del




:cn_image
cls
echo =====================�������� 2 ��  ѡ���ļ�������======================
echo.
echo �����������ȡ�Ĺ���ӳ���ļ�������λ�á�
echo   ��ע�⡿������ַǷ��ַ���·�������²���ʧ�ܣ�
echo.
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
if "%gpt_status%"=="0" echo   * ���� write_mbr �����»س����趨��װ��ʽΪ��ͨ����������¼��������
if "%gpt_status%"=="1" echo   * ���� write_gpt �����»س����趨��װ��ʽΪ��ͨ��EFI������������
echo   * ���� EXIT �����»س��������˳�������
set /p instway=��
if "%instway%"=="EXIT" goto self_del
if "%instway%"=="" (
	set instway=edit_present
	goto cn_ready
)
if "%instway%"=="write_mbr" goto cn_ready
if "%instway%"=="write_gpt" goto cn_ready
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
if "%instway%"=="write_gpt" echo * ����ͨ���޸�ESP����EFI������װ����
echo.
echo ���»س�����ʼ׼����װ���򣬷�������� no Ȼ��س���
echo   ���� EXIT Ȼ���»س������˳�������
set /p yesno=��
if "%yesno%"=="EXIT" goto self_del
if "%yesno%"=="no" (
	set file=
	set location=
	set instway=
	set yesno=
	goto cn_image
)
if "%yesno%"=="" goto cn_run
set yesno=
goto cn_ready

:cn_run
cls
echo ========================������׼����װ�����У�����========================
echo.
echo    _          _   _                      ____  _             _            
echo    / \   _ __ | |_| |__   ___  _ __      / ___|| |_ __ _ _ __| |_ ___ _ __ 
echo   / _ \ | '_ \| __| '_ \ / _ \| '_ \ ____\___ \| __/ _` | '__| __/ _ \ '__|
echo  / ___ \| | | | |_| | | | (_) | | | |_____|__) | || (_| | |  | ||  __/ |   
echo /_/   \_\_| |_|\__|_| |_|\___/|_| |_|    |____/ \__\__,_|_|   \__\___|_|   
echo.
echo.
echo ��ͬ��ʼ��������Ŭ��׼���ð�װ����
echo ���������ҪһЩʱ�䣬�����ѡ������һ������Ӧ���ǲ����ѡ��
echo.
echo ����һ������XX����  ����ϵͳ��Ҫλ��...

if "%2"==""nt5"" (
	attrib -s -h -r %systemdrive%\boot.ini
	copy %systemdrive%\boot.ini %systemdrive%\ast_bkup
	)
if "%2"==""nt6"" bcdedit /export %systemdrive%\ast_bkup\BCDbckup

dd if=\\?\Device\Harddisk0\Partition1 of=%systemdrive%\ast_bkup\MBRbckup bs=446 count=1


echo ���ڶ�������XX����  ��ѹԤ��װ�����ں�...
REM While extracting the files in [image_file]/boot/ , the new folder 'boot' will be created too.
REM For some users will install some recovery software (like One-key Ghost, it'll create a folder named 'boot' too),
REM   we first extract them into %temp%\ and then copy them into ast_strt.
7z x %file% -o%temp%\ boot\vmlinuz -y > nul
move %temp%\boot\vmlinuz %systemdrive%\ast_strt

echo ������������XX����  ��ѹԤ��װ�����ڴ���...
7z x %file% -o%temp%\ boot\initrd -y > nul
move %temp%\boot\initrd %systemdrive%\ast_strt

echo �����Ĳ�����XX����  ��ѹ����ϵͳ��װ�ļ�...
echo         * �����̺�ʱ�ϳ��������ĵȴ���
7z x %file% -o%location% live\live.squashfs -y >nul

echo ����һ������XX����  У�鰲װ�ļ�...
echo     1 / 3  У��Ԥ��װ�����ں�...
7z x %file% -o%systemdrive%\ast_temp md5sum
for /f "delims=" %%i in ('md5sum.exe -b %systemdrive%\ast_strt\vmlinuz') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum^|findstr "^1:"') do set md5sum_vmlinuz=%%b
if "%md5sum_buf:~0,32%" NEQ "%md5sum_vmlinuz%" (
	echo                       *** ����: Ԥ��װ�����ں�У��ʧ�ܣ�
	set verify_error=1
)
set md5sum_vmlinuz=
set md5sum_buf=

echo     2 / 3  У��Ԥ��װ�����ڴ���...
for /f "delims=" %%i in ('md5sum.exe -b %systemdrive%\ast_strt\initrd') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum^|findstr "^2:"') do set md5sum_initrd=%%b
if "%md5sum_buf:~0,32%" NEQ "%md5sum_initrd%" (
	echo                       *** ����: Ԥ��װ�����ڴ���У��ʧ�ܣ�
	set verify_error=1
)
set md5sum_initrd=
set md5sum_buf=

echo     3 / 3  У�����ϵͳ��װ�ļ�...
for /f "delims=" %%i in ('md5sum.exe -b %location%live\live.squashfs') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum^|findstr "^3:"') do set md5sum_squash=%%b
if "%md5sum_buf:~0,32%" NEQ "%md5sum_squash%" (
	echo                       *** ����: ����ϵͳ��װ�ļ�У��ʧ�ܣ�
	set verify_error=1
)
set md5sum_squash=
set md5sum_buf=

if "%verify_error%"=="0" goto verify_success

echo        *** ӳ���ļ�У��ʧ�ܣ��������а�װ���ܵ��°�װʧ��...
echo            ��Ҫ������װ������ y Ȼ���»س������������ַ���س��˳�����
set /p vercho=            ��
if not "%vercho%"=="y" (
	rd /s /q %location%live\
	goto self_del
)

:verify_success


echo �����岽����XX����  ��ʼ��������...

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
echo default=%systemdrive%\ast_strt\g2ldr.mbr >> %systemdrive%\boot.ini
echo [operating systems] >> %systemdrive%\boot.ini
echo %systemdrive%\WINDOWS="����ԭ����Windows����ϵͳ" >> %systemdrive%\boot.ini
echo %systemdrive%\ast_strt\g2ldr.mbr="������ͬ GNU/Linux��װ����" >> %systemdrive%\boot.ini
echo. >> %systemdrive%\boot.ini
goto edit_done

:cn_nt6_bcd_edit
for /f "delims=" %%i in ('bcdedit /create /d "������ͬ GNU/Linux ��װ����" /application bootsector') do set uid=%%i
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \ast_strt\g2ldr.mbr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
bcdedit /timeout 10
goto edit_done


:edit_done

echo  ������������XX����  ���ڲ�������...

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
echo   initrd /ast_strt/initrd >> %systemdrive%\ast_strt\grub.cfg
echo   boot >> %systemdrive%\ast_strt\grub.cfg
echo } >> %systemdrive%\ast_strt\grub.cfg
echo. >> %systemdrive%\ast_strt\grub.cfg
echo menuentry "������ͬ GNU/Linux ��װ���򣨰�ȫ��ʾ�趨ģʽ��"{ >> %systemdrive%\ast_strt\grub.cfg
echo   search --set=root --no-floppy /ast_strt/vmlinuz >> %systemdrive%\ast_strt\grub.cfg
echo   linux /ast_strt/vmlinuz boot=live config quiet noswap noeject nomodeset vga=normal rw >> %systemdrive%\ast_strt\grub.cfg
echo   initrd /ast_strt/initrd >> %systemdrive%\ast_strt\grub.cfg
echo   boot >> %systemdrive%\ast_strt\grub.cfg
echo } >> %systemdrive%\ast_strt\grub.cfg
echo. >> %systemdrive%\ast_strt\grub.cfg


copy %systemdrive%\ast_temp\g2ldr.mbr %systemdrive\ast_strt\ > nul
copy %systemdrive%\ast_temp\g2ldr %systemdrive%\ > nul
copy %systemdrive%\ast_temp\unicode.pf2 %systemdrive%\ast_strt\ > nul


pause


:cn_finish
cls
echo =======================������������������=======================
echo.
echo ��ͬ��ʼ�����Ѿ�׼�����˲���ϵͳ�İ�װ���𣬼���������������װ����
echo �뱣������Ĺ�������������������������ĵ��ԡ�
pause > nul
goto before_reboot


:cn_err1
cls
echo =======================������������������=======================
echo.
echo �����������ļ��������ڣ���ȷ��·���Ƿ����...
echo.
echo ���������������һ����
pause > nul
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
echo Not Finished Yet.
pause > nul
goto self_del









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