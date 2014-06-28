@::  Anthon-Starter: Installation helper for AOSC Linux distribution series, version 0.1.2
@::  Copyright (C) 2014 Anthon Open Source Community.
@::  
@::  Licensed under the Apache License, Version 2.0 (the "License");
@::  you may not use this file except in compliance with the License.
@::  You may obtain a copy of the License at
@::  
@::    http://www.apache.org/licenses/LICENSE-2.0
@::  
@::  Unless required by applicable law or agreed to in writing, software
@::  distributed under the License is distributed on an "AS IS" BASIS,
@::  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@::  See the License for the specific language governing permissions and
@::  limitations under the License.





@echo off

:: Check whether the parameters exists (for insurance):
::   %1 : Language
::   %2 : Type of boot loader
if "%~1"=="" exit
if "%~2"=="" exit

:: Define the size of console:
::   Height: 25 lines
::   Width : 85 characters
mode con lines=25 cols=85

:: Judge the language
if "%~1"=="1" goto cn_main
if "%~1"=="2" goto en_main
goto self_del

:: //////////Simplified Chinese
:cn_main
cls
title ��ͬ��ʼ���� 0.1.2
echo  ========================������ ��ӭʹ�ð�ͬ��ʼ���� ������=========================
echo.
echo ���������������ɵش�Ӳ�̰�װ��ͬ��Դ�����Ĳ���ϵͳ���а棺
echo     * AnthonOS, AOSC����棻
echo     * CentralPoint, AOSC�������棻
echo     * IcenowyLinux, AOSC�����ܹ��棻
echo     * AOSC Spins, AOSC�����汾��
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
if /i "%cho%"=="exit" (
	set cho=
	goto self_del
)
set cho=
goto cn_main





:cn_check
cls


:: Detect GPT... init.bat has no power to do it.
echo ��ͬ��ʼ�������ڼ�����...
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
	echo     Ϊ��ȫ��������򼴽��رա��Դ�������б�Ǹ��
	echo.
	echo     ����� http://bugs.anthonos.org �����Ǳ����������...
	echo.
	echo     ����������رձ�����
	pause > nul
	goto self_del
)


:detect_gpt_done_cn

cls
echo  =========================������ �� 1 ��  ������� ������=========================
echo.
if "%~2"=="nt5" echo * ̽�⵽����ϵͳ����ΪWindows NT5ϵ�У�Windows 2k, XP�ȣ�
if "%~2"=="nt6" echo * ̽�⵽����ϵͳ����ΪWindows NT6ϵ�У�Windows Vista, 7, 8�ȣ�
if "%gpt_status%"=="1" echo * ̽�⵽��ʹ����GUID������GPT��
if "%gpt_status%"=="0" echo * ̽�⵽��ʹ������������¼��MBR��
echo.
echo �ڰ�װϵͳ֮ǰ������ע������ע�����
echo.
echo   1. �롾��ء��Ѱ�װ�����ļ�װ�뱾��Ӳ�̣�������U�̡��ƶ�Ӳ�̡�MP3���豸���������
echo        ��ִ����һ��֮ǰ��γ���������豸��
echo.
echo   2. ��ͬ��Դ�������з��а��ֻ������x86_64�ܹ������봦�����ϣ������в�ѯ���ļ����
echo        �Ƿ����Ҫ�󣬰�ͬ��ʼ������ʱ���ṩ�Զ���鹦�ܣ�
echo.
echo   3. �뱣֤���ڰ�װ��Ӧ�汾��ϵͳ֮ǰ������Ķ���Ӳ��Ҫ������ʹ�����죻
echo.
echo   4. ��ͬ��Դ�������а������ѭ GNU LGPL Э�鷢����
echo.
echo.
echo ȷ�������ֱ�Ӱ��»س���������װ������ EXIT �����˳�������
set /p chkcho=��
if /i "%chkcho%"=="EXIT" goto self_del
if "%chkcho%"=="" goto cn_image
:: Or exit, delete the temp files
set chkcho=
goto detect_gpt_done_cn




:cn_image
cls
echo  =========================������ �� 2 ��  ѡ���ļ� ������===========================
echo.
echo �����������ȡ�Ĺ���ӳ���ļ�������λ�á�
echo   ��ע�⡿������ַǷ��ַ���·�������²���ʧ�ܣ�
echo.
echo �Ҽ�ճ�����ܿ��ã����� EXIT �����˳�������
set /p file=��
if /i "%file%"=="EXIT" goto self_del
if "%file%"=="^" goto cn_err1
if "%file%"=="." goto cn_err1
if "%file%"=="*" goto cn_err1
if "%file%"=="/" goto cn_err1
if "%file%"=="\" goto cn_err1
if "%file%"=="," goto cn_err1
if "%file%"=="=" goto cn_err1
if "%file%"=="" goto cn_err1
if not exist %file% goto cn_err1

:: Check if the image file is AOSC Linux distribution...
echo.
echo ��ͬ��ʼ�������ڼ�����ļ�...
%systemdrive%\ast_temp\7z x %file% -o%systemdrive%\ast_temp\ md5sum.ast -y > nul
if not "%errorlevel%"=="0" (
	echo     *** ���棺�ⲻ�ǰ�ͬ��ʼ������֧�ֵ��ļ���������룺%errorlevel%
	echo               �����������������벻���ĺ������˰�ͬ��ʼ����ܾ���������ļ���
	echo.
	echo         �뽫���ⱨ�浽 http://bugs.anthonos.org/
	echo.
	echo     ����������˳���ͬ��ʼ����
	pause > nul
	goto self_del
)

:: Get the information inside the image file...
for /f "tokens=3 delims=: " %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^2:"') do set imginfo_os=%%a
for /f "tokens=4 delims=: " %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^2:"') do set imginfo_dist=%%a
for /f "tokens=5 delims=: " %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^2:"') do set imginfo_ver=%%a
for /f "tokens=6 delims=: " %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^2:"') do set imginfo_lang=%%a
if "%imginfo_dist%"=="anos" goto cn_target
if "%imginfo_dist%"=="ancp" goto cn_target
if "%imginfo_dist%"=="icnl" goto cn_target
if "%imginfo_dist%"=="spin" goto cn_target
:: There must be something interesting...
echo     *** �����ⲻ�ǰ�ͬ��ʼ������֧�ֵ�ϵͳ�汾��
echo               ��ϵ��%imginfo_os%
echo               ���У�%imginfo_dist%
echo               �汾��%imginfo_ver%
echo               ���ԣ�%imginfo_lang%
echo.
echo               �����������ܷ������벻���ĺ������˰�ͬ��ʼ���򽫾ܾ�������
echo.
echo         �뽫���ⱨ�浽 http://bugs.anthonos.org/
echo.
echo     ����������˳���ͬ��ʼ����
pause > nul
goto self_del


:cn_target
cls
echo  =========================������ �� 3 ��  ��ѹλ�� ������===========================
echo.
echo ������һ����ѹλ����ȷ����װ������������ͷ��ļ���
echo   ֱ�Ӱ��»س������趨��ѹλ��Ϊ%systemdrive%\
echo.
echo   * ���뷽ʽʾ����%systemdrive%\  ���� EXIT �����˳�������
set /p location=��
if /i "%location%"=="EXIT" goto self_del
if "%location%"=="" (
	set location=%systemdrive%\
	goto cn_way
)
if not exist %location% goto cn_err2
goto cn_way


:cn_way
cls
echo  =========================������ �� 4 ��  ��װ��ʽ ������===========================
echo.
echo ��ָ����������װ������ʹ�õ�������ʽ��
echo   ��ע�⡿������ӵ��רҵ֪ʶ��������ʹ��Ĭ�����á�ͨ��NT������Ƕ����������
echo.
echo   * ֱ�Ӱ��»س����趨��װ��ʽΪ��ͨ��NT������Ƕ����������
if "%gpt_status%"=="0" echo   * ��װ��ʽ��ͨ����������¼���������ݲ���֧�֡���
if "%gpt_status%"=="1" echo   * ���� write_gpt �����»س����趨��װ��ʽΪ��ͨ��EFI������������
echo   * ���� EXIT �����»س��������˳�������
set /p instway=��
if /i "%instway%"=="EXIT" goto self_del
if "%instway%"=="" (
	set instway=edit_present
	goto cn_ready
)
if "%instway%"=="write_mbr" (
	:: Check if GPT was detected.
	:: if "%gpt_status%"=="1" (
	::	 set instway=
	::	 goto cn_way
	:: )
	::goto cn_ready
	set instway=
	goto cn_way
)
if "%instway%"=="write_gpt" (
	if "%gpt_status%"=="0" (
		set instway=
		goto cn_way
	)
	goto cn_ready
)
set instway=
goto cn_way



:cn_ready
cls
echo  =======================������ �� 5 ��  ׼����װ���� ������=========================
echo.
echo ��ȷ�����������Ƿ���ȷ��
echo.
echo * ���趨���ļ�Ϊ��%file%
echo       - ��ϵ��AOSC OS%imginfo_os:~2,3%
if "%imginfo_dist%"=="anos" echo       - ���а汾����ͬ����汾
if "%imginfo_dist%"=="ancp" echo       - ���а汾����ͬ�������汾 ( CentralPoint )
if "%imginfo_dist%"=="icnl" echo       - ���а汾����ͬ�����ܹ��汾 ( IcenowyLinux )
if "%imginfo_dist%"=="spin" echo       - ���а汾��AOSC�����汾 ( AOSC Spins )
echo       - ϵͳ�汾�ţ�%imginfo_ver%
echo       - ϵͳ���ԣ�%imginfo_lang%
echo.
echo * ���趨�Ľ�ѹ·��Ϊ��%location%
echo.
if "%instway%"=="edit_present" echo * ����ͨ��NT������Ƕ��������װ����Ĭ�����ã�
if "%instway%"=="write_mbr" echo * ����ͨ���޸���������¼������װ����
if "%instway%"=="write_gpt" echo * ����ͨ���޸�ESP����EFI������װ����
echo.
echo ���»س�����ʼ׼����װ���򣬷�������� no Ȼ��س���
echo   ���� EXIT Ȼ���»س������˳�������
set /p yesno=��
if /i "%yesno%"=="EXIT" goto self_del
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
echo  ============================������ ׼����װ������ ������===========================
echo          _          _   _                      ____  _             _
echo         / \   _ __ ^| ^|_^| ^|__   ___  _ __      / ___^|^| ^|_ __ _ _ __^| ^|_ ___ _ __
echo        / _ \  '_ \^| __^| '_ \ / _ \^| '_ \ ____\___ \^| __/ _` ^| '__^| __/ _ \ '__^|
echo       / ___ \^| ^| ^| ^| ^|_^| ^| ^| ^| (_) ^| ^| ^| ^|_____^|__) ^| ^|^| (_^| ^| ^|  ^| ^|^|  __/ ^|
echo      /_/   \_\_^| ^|_^|\__^|_^| ^|_^|\___/^|_^| ^|_^|    ^|____/ \__\__,_^|_^|   \__\___^|_^|
echo.
echo  ===================================================================================
echo.
echo ��ͬ��ʼ��������Ŭ��׼���ð�װ����
echo ���������ҪһЩʱ�䣬�����ѡ������һ������Ӧ���ǲ����ѡ��
echo.
echo ����һ������������  ����ϵͳ��Ҫλ��...


if "%~2"=="nt5" (
	attrib -s -h -r %systemdrive%\boot.ini
	copy %systemdrive%\boot.ini %systemdrive%\ast_bkup
)
if "%~2"=="nt6" bcdedit /export %systemdrive%\ast_bkup\BCDbckup

:: dd if=\\?\Device\Harddisk0\Partition1 of=%systemdrive%\ast_bkup\MBRbckup bs=446 count=1


echo ���ڶ�������������  ��ѹԤ��װ�����ں�...
:: While extracting the files in [image_file]/boot/ , the new folder "boot" will be created by 7-Zip too.
:: For some users would install some recovery software (like "One-key Ghost", they will create a folder named "boot" too),
::   we first extract them into %temp%\ and then copy them into ast_strt\ .
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\vmlinuz -y > nul
move %temp%\boot\vmlinuz %systemdrive%\ast_strt\ > nul

echo ������������������  ��ѹԤ��װ�����ڴ���...
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\initrd -y > nul
move %temp%\boot\initrd %systemdrive%\ast_strt\ > nul

echo �����Ĳ�����������  ��ѹ����ϵͳ��װ�ļ�...
echo         * �����̺�ʱ�ϳ��������ĵȴ���
:: But notice that if we ::ove the folder "live" the kernel won't be able to find it...
%systemdrive%\ast_temp\7z x %file% -o%location% live\live.squashfs -y > nul

echo �����岽����������  У�鰲װ�ļ�...
echo     1 / 3  У��Ԥ��װ�����ں�...
:: Read md5sum.ast
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\vmlinuz') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^4:"') do set md5sum_vmlinuz=%%b
if not %md5sum_buf:~1,33% == %md5sum_vmlinuz:~0,32% (
	echo                       *** ����: Ԥ��װ�����ں�У��ʧ�ܣ�
	set verify_error=1
)
set md5sum_vmlinuz=
set md5sum_buf=

echo     2 / 3  У��Ԥ��װ�����ڴ���...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\initrd') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^5:"') do set md5sum_initrd=%%b
if not %md5sum_buf:~1,33% == %md5sum_initrd:~0,32% (
	echo                       *** ����: Ԥ��װ�����ڴ���У��ʧ�ܣ�
	set verify_error=1
)
set md5sum_initrd=
set md5sum_buf=

echo     3 / 3  У�����ϵͳ��װ�ļ�...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %location%live\live.squashfs') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^6:"') do set md5sum_squash=%%b
if not %md5sum_buf:~1,33% == %md5sum_squash:~0,32% (
 	echo                       *** ����: ����ϵͳ��װ�ļ�У��ʧ�ܣ�
 	set verify_error=1
)
set md5sum_squash=
set md5sum_buf=

if not defined verify_error goto cn_verify_success

echo        *** ӳ���ļ�У��ʧ�ܣ��������а�װ���ܵ��°�װʧ��...
echo            ��Ҫ������װ������ y Ȼ���»س������������ַ���س��˳�����
set /p vercho=            ��
if not "%vercho%"=="y" (
	rd /s /q %location%live\
	goto self_del
)

:cn_verify_success


echo ������������������  ��ʼ��������...
echo %instway%
pause

if "%instway%"=="write_mbr" (
	set instway=edit_present
	:: goto cn_edit_done
)
if "%instway%"=="write_gpt" (
	mountvol W:\ /s
	if not "%errorlevel%"=="0" (
		echo     *** ��������ESP��������ʧ�ܣ�������룺%errorlevel%
		echo         Ϊ��ȫ�������ͬ��ʼ���򽫲��ٶԷ�������в�����
		echo         ϵͳ����ʽ������Ϊ��ͨ��NT������Ƕ��������װ����Ĭ�����ã���
		mountvol W:\ /d
		if "%~2"=="nt5" goto cn_nt5_ntldr_edit
		if "%~2"=="nt6" goto cn_nt6_bcd_edit
	)
	mkdir W:\AOSC\
	copy %systemdrive%\ast_temp\bootx64.efi W:\AOSC\ > nul
	goto cn_edit_done
)
if "%instway%"=="edit_present" (
	echo dbgp03: %instway%
	pause
	if "%~2"=="nt5" goto cn_nt5_ntldr_edit
	if "%~2"=="nt6" goto cn_nt6_bcd_edit
)


:cn_nt5_ntldr_edit
echo [boot loader] > %systemdrive%\boot.ini
echo timeout=10 >> %systemdrive%\boot.ini
echo default=%systemdrive%\ast_strt\g2ldr.mbr >> %systemdrive%\boot.ini
echo [operating systems] >> %systemdrive%\boot.ini
echo %systemdrive%\WINDOWS="����ԭ���� Windows ����ϵͳ" >> %systemdrive%\boot.ini
echo %systemdrive%\ast_strt\g2ldr.mbr="���� AOSC Live" >> %systemdrive%\boot.ini
echo. >> %systemdrive%\boot.ini
goto cn_edit_done

:cn_nt6_bcd_edit
for /f "delims=" %%i in ('bcdedit /create /d "���� AOSC Live" /application bootsector') do set uid=%%i
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \ast_strt\g2ldr.mbr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
bcdedit /timeout 10
goto cn_edit_done


:cn_edit_done
echo cn_edit_done
pause

:: Generate grub.cfg
if "%instway%"=="edit_present" (
	copy %systemdrive%\ast_temp\grub-pc.cfg %systemdrive%\ast_strt\
	ren %systemdrive%\ast_strt\grub-pc.cfg grub.cfg
)
if "%instway%"=="write_mbr" (
	copy %systemdrive%\ast_temp\grub-pc.cfg %systemdrive%\ast_strt\
	ren %systemdrive%\ast_strt\grub-pc.cfg grub.cfg
)
if "%instway%"=="write_gpt" (
	copy %systemdrive%\ast_temp\grub-efi.cfg W:\AOSC\
	ren %systemdrive%\ast_strt\grub-efi.cfg grub.cfg
)


:: Put GRUB to the target
if "%instway%"=="edit_present" (
	copy %systemdrive%\ast_temp\g2ldr.mbr %systemdrive%\ast_strt\
	copy %systemdrive%\ast_temp\g2ldr %systemdrive%\
	copy %systemdrive%\ast_temp\unicode.pf2 %systemdrive%\ast_strt\
)

if "%instway%"=="write_mbr" (
	copy %systemdrive%\ast_temp\g2ldr %systemdrive%\ > nul
	copy %systemdrive%\ast_temp\unicode.pf2 %systemdrive%\ast_strt\ > nul
)

if "%instway%"=="write_gpt" (
	copy %systemdrive%\ast_temp\unicode.pf2 W:\AOSC\ > nul
	mountvol W:\ /d
)

pause
goto cn_finish

:cn_finish
cls
echo  ==============================������ ��Ҫ���� ������===============================
echo.
echo ��ͬ��ʼ�����Ѿ�׼�����˲���ϵͳ�İ�װ���𣬼���������������װ����
echo �뱣������Ĺ�������������������������ĵ��ԡ�
pause > nul
goto before_reboot


:cn_err1
cls
echo  ===============================������ ������ ������================================
echo.
echo ������������%file%
echo ���������ڣ���ȷ��·���Ƿ����...
echo.
echo ���������������һ����
pause > nul
set file=
goto cn_image

:cn_err2
cls
echo  ===============================������ ������ ������================================
echo.
echo ������������%location%
echo ���������ڣ���ȷ���̷��Ƿ����...
echo.
echo ���������������һ����
pause>nul
set location=
goto cn_target







:: //////////English
:en_main
cls
title ��ͬ��ʼ���� 0.1.2
echo  ========================������ ��ӭʹ�ð�ͬ��ʼ���� ������=========================
echo.
echo ���������������ɵش�Ӳ�̰�װ��ͬ��Դ�����Ĳ���ϵͳ���а棺
echo     * AnthonOS, AOSC����棻
echo     * CentralPoint, AOSC�������棻
echo     * IcenowyLinux, AOSC�����ܹ��棻
echo     * AOSC Spins, AOSC�����汾��
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
	goto en_check
)
if "%cho%"=="license" (
	set cho=
	start notepad.exe %systemdrive%\ast_temp\LICENSE
	goto en_main
)
if "%cho%"=="about" (
	set cho=
	goto en_about
)
if /i "%cho%"=="exit" (
	set cho=
	goto self_del
)
set cho=
goto en_main





:en_check
cls


:: Detect GPT... init.bat has no power to do it.
echo ��ͬ��ʼ�������ڼ�����...
mountvol W:\ /s
if "%errorlevel%"=="0" (
	if exist W:\EFI\ (
		set gpt_status=1
		mountvol W:\ /d
		goto detect_gpt_done_en
	) else (
		set gpt_status=0
		mountvol W:\ /d
		goto detect_gpt_done_en
	)
) else (
	echo *** �������󣺰�ͬ��ʼ�����޷���������ESP������������� %errorlevel%
	echo     Ϊ��ȫ��������򼴽��رա��Դ�������б�Ǹ��
	echo.
	echo     ����� http://bugs.anthonos.org �����Ǳ����������...
	echo.
	echo     ����������رձ�����
	pause > nul
	goto self_del
)


:detect_gpt_done_en

cls
echo  =========================������ �� 1 ��  ������� ������=========================
echo.
if "%~2"=="nt5" echo * ̽�⵽����ϵͳ����ΪWindows NT5ϵ�У�Windows 2k, XP�ȣ�
if "%~2"=="nt6" echo * ̽�⵽����ϵͳ����ΪWindows NT6ϵ�У�Windows Vista, 7, 8�ȣ�
if "%gpt_status%"=="1" echo * ̽�⵽��ʹ����GUID������GPT��
if "%gpt_status%"=="0" echo * ̽�⵽��ʹ������������¼��MBR��
echo.
echo �ڰ�װϵͳ֮ǰ������ע������ע�����
echo.
echo   1. �롾��ء��Ѱ�װ�����ļ�װ�뱾��Ӳ�̣�������U�̡��ƶ�Ӳ�̡�MP3���豸���������
echo        ��ִ����һ��֮ǰ��γ���������豸��
echo.
echo   2. ��ͬ��Դ�������з��а��ֻ������x86_64�ܹ������봦�����ϣ������в�ѯ���ļ����
echo        �Ƿ����Ҫ�󣬰�ͬ��ʼ������ʱ���ṩ�Զ���鹦�ܣ�
echo.
echo   3. �뱣֤���ڰ�װ��Ӧ�汾��ϵͳ֮ǰ������Ķ���Ӳ��Ҫ������ʹ�����죻
echo.
echo   4. ��ͬ��Դ�������а������ѭ GNU LGPL Э�鷢����
echo.
echo.
echo ȷ�������ֱ�Ӱ��»س���������װ������ EXIT �����˳�������
set /p chkcho=��
if /i "%chkcho%"=="EXIT" goto self_del
if "%chkcho%"=="" goto en_image
:: Or exit, delete the temp files
set chkcho=
goto detect_gpt_done_en




:en_image
cls
echo  =========================������ �� 2 ��  ѡ���ļ� ������===========================
echo.
echo �����������ȡ�Ĺ���ӳ���ļ�������λ�á�
echo   ��ע�⡿������ַǷ��ַ���·�������²���ʧ�ܣ�
echo.
echo �Ҽ�ճ�����ܿ��ã����� EXIT �����˳�������
set /p file=��
if /i "%file%"=="EXIT" goto self_del
if "%file%"=="^" goto en_err1
if "%file%"=="." goto en_err1
if "%file%"=="*" goto en_err1
if "%file%"=="/" goto en_err1
if "%file%"=="\" goto en_err1
if "%file%"=="," goto en_err1
if "%file%"=="=" goto en_err1
if "%file%"=="" goto en_err1
if not exist %file% goto en_err1

:: Check if the image file is AOSC Linux distribution...
echo.
echo ��ͬ��ʼ�������ڼ�����ļ�...
%systemdrive%\ast_temp\7z x %file% -o%systemdrive%\ast_temp\ md5sum.ast -y > nul
if not "%errorlevel%"=="0" (
	echo     *** ���棺�ⲻ�ǰ�ͬ��ʼ������֧�ֵ��ļ���������룺%errorlevel%
	echo               �����������������벻���ĺ������˰�ͬ��ʼ����ܾ���������ļ���
	echo.
	echo         �뽫���ⱨ�浽 http://bugs.anthonos.org/
	echo.
	echo     ����������˳���ͬ��ʼ����
	pause > nul
	goto self_del
)

:: Get the information inside the image file...
for /f "tokens=3 delims=: " %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^2:"') do set imginfo_os=%%a
for /f "tokens=4 delims=: " %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^2:"') do set imginfo_dist=%%a
for /f "tokens=5 delims=: " %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^2:"') do set imginfo_ver=%%a
for /f "tokens=6 delims=: " %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^2:"') do set imginfo_lang=%%a
if "%imginfo_dist%"=="anos" goto en_target
if "%imginfo_dist%"=="ancp" goto en_target
if "%imginfo_dist%"=="ienl" goto en_target
if "%imginfo_dist%"=="spin" goto en_target
:: There must be something interesting...
echo     *** �����ⲻ�ǰ�ͬ��ʼ������֧�ֵ�ϵͳ�汾��
echo               ��ϵ��%imginfo_os%
echo               ���У�%imginfo_dist%
echo               �汾��%imginfo_ver%
echo               ���ԣ�%imginfo_lang%
echo.
echo               �����������ܷ������벻���ĺ������˰�ͬ��ʼ���򽫾ܾ�������
echo.
echo         �뽫���ⱨ�浽 http://bugs.anthonos.org/
echo.
echo     ����������˳���ͬ��ʼ����
pause > nul
goto self_del


:en_target
cls
echo  =========================������ �� 3 ��  ��ѹλ�� ������===========================
echo.
echo ������һ����ѹλ����ȷ����װ������������ͷ��ļ���
echo   ֱ�Ӱ��»س������趨��ѹλ��Ϊ%systemdrive%\
echo.
echo   * ���뷽ʽʾ����%systemdrive%\  ���� EXIT �����˳�������
set /p location=��
if /i "%location%"=="EXIT" goto self_del
if "%location%"=="" (
	set location=%systemdrive%\
	goto en_way
)
if not exist %location% goto en_err2
goto en_way


:en_way
cls
echo  =========================������ �� 4 ��  ��װ��ʽ ������===========================
echo.
echo ��ָ����������װ������ʹ�õ�������ʽ��
echo   ��ע�⡿������ӵ��רҵ֪ʶ��������ʹ��Ĭ�����á�ͨ��NT������Ƕ����������
echo.
echo   * ֱ�Ӱ��»س����趨��װ��ʽΪ��ͨ��NT������Ƕ����������
if "%gpt_status%"=="0" echo   * ��װ��ʽ��ͨ����������¼���������ݲ���֧�֡���
if "%gpt_status%"=="1" echo   * ���� write_gpt �����»س����趨��װ��ʽΪ��ͨ��EFI������������
echo   * ���� EXIT �����»س��������˳�������
set /p instway=��
if /i "%instway%"=="EXIT" goto self_del
if "%instway%"=="" (
	set instway=edit_present
	goto en_ready
)
if "%instway%"=="write_mbr" (
	:: Check if GPT was detected.
	:: if "%gpt_status%"=="1" (
	::   set instway=
	::	 goto en_way
	:: )
	::goto en_ready
	set instway=
	goto en_way
)
if "%instway%"=="write_gpt" (
	if "%gpt_status%"=="0" (
		set instway=
		goto en_way
	)
	goto en_ready
)
set instway=
goto en_way



:en_ready
cls
echo  =======================������ �� 5 ��  ׼����װ���� ������=========================
echo.
echo ��ȷ�����������Ƿ���ȷ��
echo.
echo * ���趨���ļ�Ϊ��%file%
echo       - ��ϵ��AOSC OS%imginfo_os:~2,3%
if "%imginfo_dist%"=="anos" echo       - ���а汾����ͬ����汾
if "%imginfo_dist%"=="ancp" echo       - ���а汾����ͬ�������汾 ( CentralPoint )
if "%imginfo_dist%"=="ienl" echo       - ���а汾����ͬ�����ܹ��汾 ( IcenowyLinux )
if "%imginfo_dist%"=="spin" echo       - ���а汾��AOSC�����汾 ( AOSC Spins )
echo       - ϵͳ�汾�ţ�%imginfo_ver%
echo       - ϵͳ���ԣ�%imginfo_lang%
echo.
echo * ���趨�Ľ�ѹ·��Ϊ��%location%
echo.
if "%instway%"=="edit_present" echo * ����ͨ��NT������Ƕ��������װ����Ĭ�����ã�
if "%instway%"=="write_mbr" echo * ����ͨ���޸���������¼������װ����
if "%instway%"=="write_gpt" echo * ����ͨ���޸�ESP����EFI������װ����
echo.
echo ���»س�����ʼ׼����װ���򣬷�������� no Ȼ��س���
echo   ���� EXIT Ȼ���»س������˳�������
set /p yesno=��
if /i "%yesno%"=="EXIT" goto self_del
if "%yesno%"=="no" (
	set file=
	set location=
	set instway=
	set yesno=
	goto en_image
)
if "%yesno%"=="" goto en_run
set yesno=
goto en_ready

:en_run
cls
echo  ============================������ ׼����װ������ ������===========================
echo          _          _   _                      ____  _             _
echo         / \   _ __ ^| ^|_^| ^|__   ___  _ __      / ___^|^| ^|_ __ _ _ __^| ^|_ ___ _ __
echo        / _ \  '_ \^| __^| '_ \ / _ \^| '_ \ ____\___ \^| __/ _` ^| '__^| __/ _ \ '__^|
echo       / ___ \^| ^| ^| ^| ^|_^| ^| ^| ^| (_) ^| ^| ^| ^|_____^|__) ^| ^|^| (_^| ^| ^|  ^| ^|^|  __/ ^|
echo      /_/   \_\_^| ^|_^|\__^|_^| ^|_^|\___/^|_^| ^|_^|    ^|____/ \__\__,_^|_^|   \__\___^|_^|
echo.
echo  ===================================================================================
echo.
echo ��ͬ��ʼ��������Ŭ��׼���ð�װ����
echo ���������ҪһЩʱ�䣬�����ѡ������һ������Ӧ���ǲ����ѡ��
echo.
echo ����һ������������  ����ϵͳ��Ҫλ��...


if "%~2"=="nt5" (
	attrib -s -h -r %systemdrive%\boot.ini
	copy %systemdrive%\boot.ini %systemdrive%\ast_bkup
)
if "%~2"=="nt6" bcdedit /export %systemdrive%\ast_bkup\BCDbckup

:: dd if=\\?\Device\Harddisk0\Partition1 of=%systemdrive%\ast_bkup\MBRbckup bs=446 count=1


echo ���ڶ�������������  ��ѹԤ��װ�����ں�...
:: While extracting the files in [image_file]/boot/ , the new folder "boot" will be created by 7-Zip too.
:: For some users would install some recovery software (like "One-key Ghost", they will create a folder named "boot" too),
::   we first extract them into %temp%\ and then copy them into ast_strt\ .
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\vmlinuz -y > nul
move %temp%\boot\vmlinuz %systemdrive%\ast_strt\ > nul

echo ������������������  ��ѹԤ��װ�����ڴ���...
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\initrd -y > nul
move %temp%\boot\initrd %systemdrive%\ast_strt\ > nul

echo �����Ĳ�����������  ��ѹ����ϵͳ��װ�ļ�...
echo         * �����̺�ʱ�ϳ��������ĵȴ���
:: But notice that if we ::ove the folder "live" the kernel won't be able to find it...
%systemdrive%\ast_temp\7z x %file% -o%location% live\live.squashfs -y > nul

echo �����岽����������  У�鰲װ�ļ�...
echo     1 / 3  У��Ԥ��װ�����ں�...
:: Read md5sum.ast
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\vmlinuz') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^4:"') do set md5sum_vmlinuz=%%b
if not %md5sum_buf:~1,33% == %md5sum_vmlinuz:~0,32% (
	echo                       *** ����: Ԥ��װ�����ں�У��ʧ�ܣ�
	set verify_error=1
)
set md5sum_vmlinuz=
set md5sum_buf=

echo     2 / 3  У��Ԥ��װ�����ڴ���...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\initrd') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^5:"') do set md5sum_initrd=%%b
if not %md5sum_buf:~1,33% == %md5sum_initrd:~0,32% (
	echo                       *** ����: Ԥ��װ�����ڴ���У��ʧ�ܣ�
	set verify_error=1
)
set md5sum_initrd=
set md5sum_buf=

echo     3 / 3  У�����ϵͳ��װ�ļ�...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %location%live\live.squashfs') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^6:"') do set md5sum_squash=%%b
if not %md5sum_buf:~1,33% == %md5sum_squash:~0,32% (
 	echo                       *** ����: ����ϵͳ��װ�ļ�У��ʧ�ܣ�
 	set verify_error=1
)
set md5sum_squash=
set md5sum_buf=

if not defined verify_error goto en_verify_success

echo        *** ӳ���ļ�У��ʧ�ܣ��������а�װ���ܵ��°�װʧ��...
echo            ��Ҫ������װ������ y Ȼ���»س������������ַ���س��˳�����
set /p vercho=            ��
if not "%vercho%"=="y" (
	rd /s /q %location%live\
	goto self_del
)

:en_verify_success


echo ������������������  ��ʼ��������...
echo %instway%
pause

if "%instway%"=="write_mbr" (
	set instway=edit_present
	:: goto en_edit_done
)
if "%instway%"=="write_gpt" (
	mountvol W:\ /s
	if not "%errorlevel%"=="0" (
		echo     *** ��������ESP��������ʧ�ܣ�������룺%errorlevel%
		echo         Ϊ��ȫ�������ͬ��ʼ���򽫲��ٶԷ�������в�����
		echo         ϵͳ����ʽ������Ϊ��ͨ��NT������Ƕ��������װ����Ĭ�����ã���
		mountvol W:\ /d
		if "%~2"=="nt5" goto en_nt5_ntldr_edit
		if "%~2"=="nt6" goto en_nt6_bcd_edit
	)
	mkdir W:\AOSC\
	copy %systemdrive%\ast_temp\bootx64.efi W:\AOSC\ > nul
	goto en_edit_done
)
if "%instway%"=="edit_present" (
	echo dbgp03: %instway%
	pause
	if "%~2"=="nt5" goto en_nt5_ntldr_edit
	if "%~2"=="nt6" goto en_nt6_bcd_edit
)


:en_nt5_ntldr_edit
echo [boot loader] > %systemdrive%\boot.ini
echo timeout=10 >> %systemdrive%\boot.ini
echo default=%systemdrive%\ast_strt\g2ldr.mbr >> %systemdrive%\boot.ini
echo [operating systems] >> %systemdrive%\boot.ini
echo %systemdrive%\WINDOWS="����ԭ���� Windows ����ϵͳ" >> %systemdrive%\boot.ini
echo %systemdrive%\ast_strt\g2ldr.mbr="���� AOSC Live" >> %systemdrive%\boot.ini
echo. >> %systemdrive%\boot.ini
goto en_edit_done

:en_nt6_bcd_edit
for /f "delims=" %%i in ('bcdedit /create /d "���� AOSC Live" /application bootsector') do set uid=%%i
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \ast_strt\g2ldr.mbr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
bcdedit /timeout 10
goto en_edit_done


:en_edit_done
echo en_edit_done
pause

:: Generate grub.cfg
if "%instway%"=="edit_present" (
	copy %systemdrive%\ast_temp\grub-pc.cfg %systemdrive%\ast_strt\
	ren %systemdrive%\ast_strt\grub-pc.cfg grub.cfg
)
if "%instway%"=="write_mbr" (
	copy %systemdrive%\ast_temp\grub-pc.cfg %systemdrive%\ast_strt\
	ren %systemdrive%\ast_strt\grub-pc.cfg grub.cfg
)
if "%instway%"=="write_gpt" (
	copy %systemdrive%\ast_temp\grub-efi.cfg W:\AOSC\
	ren %systemdrive%\ast_strt\grub-efi.cfg grub.cfg
)


:: Put GRUB to the target
if "%instway%"=="edit_present" (
	copy %systemdrive%\ast_temp\g2ldr.mbr %systemdrive%\ast_strt\
	copy %systemdrive%\ast_temp\g2ldr %systemdrive%\
	copy %systemdrive%\ast_temp\unicode.pf2 %systemdrive%\ast_strt\
)

if "%instway%"=="write_mbr" (
	copy %systemdrive%\ast_temp\g2ldr %systemdrive%\ > nul
	copy %systemdrive%\ast_temp\unicode.pf2 %systemdrive%\ast_strt\ > nul
)

if "%instway%"=="write_gpt" (
	copy %systemdrive%\ast_temp\unicode.pf2 W:\AOSC\ > nul
	mountvol W:\ /d
)

pause
goto en_finish

:en_finish
cls
echo  ==============================������ ��Ҫ���� ������===============================
echo.
echo ��ͬ��ʼ�����Ѿ�׼�����˲���ϵͳ�İ�װ���𣬼���������������װ����
echo �뱣������Ĺ�������������������������ĵ��ԡ�
pause > nul
goto before_reboot


:en_err1
cls
echo  ===============================������ ������ ������================================
echo.
echo ������������%file%
echo ���������ڣ���ȷ��·���Ƿ����...
echo.
echo ���������������һ����
pause > nul
set file=
goto en_image

:en_err2
cls
echo  ===============================������ ������ ������================================
echo.
echo ������������%location%
echo ���������ڣ���ȷ���̷��Ƿ����...
echo.
echo ���������������һ����
pause>nul
set location=
goto en_target















:cn_about
cls
title ���ڰ�ͬ��ʼ���� 0.1.2
echo                            _          _   _
echo                      AS   / \   _ __ ^| ^|_^| ^|__   ___  _ __
echo                          / _ \  '_ \^| __^| '_ \ / _ \^|'_   \
echo                         / ___ \^| ^| ^| ^| ^|_^| ^| ^| ^| (_) ^| ^| ^| ^|
echo                        /_/   \_\_^| ^|_^|\__^|_^| ^|_^|\___/^|_^| ^|_^|  Do.
echo.
echo                                 ��ͬ��ʼ���� 0.1.2
echo                           ����Ȩ���� (C) 2014 ��ͬ��Դ����
echo.
echo �����ʹ�� Apache ���֤�ڶ������Ȩ��
echo.
echo ���뿪����Ա��
echo ����Ӻ ^< lmy441900@gmail.com ^>
echo ����� ^< 18929292333@163.com ^>
echo ������ ^< liushuyu011@gmail.com ^>
echo.
echo ��ȡ������Ϣ�����¼��ͬ��Դ���� http://anthonos.org/
echo.
echo �����������������Ļ��
pause > nul
set cho=
goto cn_main

:en_about
cls
title About Anthon-Starter 0.1.2
echo                            _          _   _
echo                      AS   / \   _ __ ^| ^|_^| ^|__   ___  _ __
echo                          / _ \  '_ \^| __^| '_ \ / _ \^|'_   \
echo                         / ___ \^| ^| ^| ^| ^|_^| ^| ^| ^| (_) ^| ^| ^| ^|
echo                        /_/   \_\_^| ^|_^|\__^|_^| ^|_^|\___/^|_^| ^|_^|  Do.
echo.
echo                                Anthon-Starter 0.1.2
echo                    Copyright (C) 2014 Anthon Open Source Community
echo.
echo Licensed under the Apache License, Version 2.0.
echo.
echo Developers:
echo Junde Yi ^< lmy441900@gmail.com ^>
echo Haoming Xu ^< 18929292333@163.com ^>
echo Zixing Liu ^< liushuyu011@gmail.com ^>
echo.
echo For more information, please visit http://anthonos.org/
echo.
echo Press any key to return.
pause > nul
set cho=
goto en_main


:before_reboot
:: Generate info.ast for startup.exe
echo # info.ast generated by Anthon-Starter 0.1.2 > %systemdrive%\ast_strt\info.ast
echo. >> %systemdrive%\ast_strt\info.ast
echo %~1 >> %systemdrive%\ast_strt\info.ast
echo %~2 >> %systemdrive%\ast_strt\info.ast
echo %gpt_status% >> %systemdrive%\ast_strt\info.ast
echo %instway% >> %systemdrive%\ast_strt\info.ast
echo %location% >> %systemdrive%\ast_strt\info.ast

copy %systemdrive%\ast_temp\startup.exe %systemdrive%\ast_strt\ > nul

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon-Starter_Startup_Utility /t REG_SZ /d %systemdrive%\ast_strt\startup.exe /f

rd /s /q %systemdrive%\ast_temp
:: shutdown -r -t 00
exit

:self_del
set loader=
set file=
set location=
set instway=
set cho=
set chkcho=
set yesno=
set vercho=

:: ***Here we still have a problem, which cannot let the program delete itself.

rd /s /q %systemdrive%\ast_bkup
rd /s /q %systemdrive%\ast_strt
rd /s /q %systemdrive%\ast_temp

exit