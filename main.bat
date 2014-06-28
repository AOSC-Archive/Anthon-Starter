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
title 安同开始程序 0.1.2
echo  ========================＞＞＞ 欢迎使用安同开始程序 ＜＜＜=========================
echo.
echo 本程序将引导您轻松地从硬盘安装安同开源社区的操作系统发行版：
echo     * AnthonOS, AOSC桌面版；
echo     * CentralPoint, AOSC服务器版；
echo     * IcenowyLinux, AOSC技术架构版；
echo     * AOSC Spins, AOSC派生版本；
echo     * ...
echo.
echo.
echo * 要马上开始安装，请直接敲击 回车 键；
echo * 要查看本程序的版权信息请键入 license 然后回车；
echo * 关于本程序请键入 about 然后回车；
echo * 退出本程序请键入 exit 然后回车。
echo.
set /p cho=选择一个选项：
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
echo 安同开始程序正在检测磁盘...
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
	echo *** 致命错误：安同开始程序无法正常挂载ESP分区，错误代码 %errorlevel%
	echo     为安全起见，程序即将关闭。对此我们深感抱歉。
	echo.
	echo     请访问 http://bugs.anthonos.org 向我们报告这个问题...
	echo.
	echo     按下任意键关闭本程序。
	pause > nul
	goto self_del
)


:detect_gpt_done_cn

cls
echo  =========================＞＞＞ 第 1 步  检查计算机 ＜＜＜=========================
echo.
if "%~2"=="nt5" echo * 探测到您的系统类型为Windows NT5系列（Windows 2k, XP等）
if "%~2"=="nt6" echo * 探测到您的系统类型为Windows NT6系列（Windows Vista, 7, 8等）
if "%gpt_status%"=="1" echo * 探测到您使用了GUID分区表（GPT）
if "%gpt_status%"=="0" echo * 探测到您使用了主引导记录（MBR）
echo.
echo 在安装系统之前，请您注意以下注意事项：
echo.
echo   1. 请【务必】把安装所需文件装入本地硬盘（而不是U盘、移动硬盘、MP3等设备），因此在
echo        您执行下一步之前请拔除所有外接设备；
echo.
echo   2. 安同开源社区所有发行版均只运行在x86_64架构的中央处理器上，请自行查询您的计算机
echo        是否符合要求，安同开始程序暂时不提供自动检查功能；
echo.
echo   3. 请保证您在安装相应版本的系统之前认真地阅读了硬件要求以免使您不快；
echo.
echo   4. 安同开源社区发行版则均遵循 GNU LGPL 协议发布。
echo.
echo.
echo 确认无误后，直接按下回车键继续安装，键入 EXIT 可以退出本程序。
set /p chkcho=→
if /i "%chkcho%"=="EXIT" goto self_del
if "%chkcho%"=="" goto cn_image
:: Or exit, delete the temp files
set chkcho=
goto detect_gpt_done_cn




:cn_image
cls
echo  =========================＞＞＞ 第 2 步  选择文件 ＜＜＜===========================
echo.
echo 请键入您所获取的光盘映像文件的所在位置。
echo   【注意】键入各种非法字符和路径将导致操作失败！
echo.
echo 右键粘贴功能可用；键入 EXIT 可以退出本程序。
set /p file=→
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
echo 安同开始程序正在检验此文件...
%systemdrive%\ast_temp\7z x %file% -o%systemdrive%\ast_temp\ md5sum.ast -y > nul
if not "%errorlevel%"=="0" (
	echo     *** 警告：这不是安同开始程序所支持的文件，错误代码：%errorlevel%
	echo               继续操作将导致意想不到的后果，因此安同开始程序拒绝操作这个文件。
	echo.
	echo         请将问题报告到 http://bugs.anthonos.org/
	echo.
	echo     按下任意键退出安同开始程序。
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
echo     *** 错误：这不是安同开始程序所支持的系统版本！
echo               代系：%imginfo_os%
echo               发行：%imginfo_dist%
echo               版本：%imginfo_ver%
echo               语言：%imginfo_lang%
echo.
echo               继续操作可能发生意想不到的后果，因此安同开始程序将拒绝操作。
echo.
echo         请将问题报告到 http://bugs.anthonos.org/
echo.
echo     按下任意键退出安同开始程序。
pause > nul
goto self_del


:cn_target
cls
echo  =========================＞＞＞ 第 3 步  解压位置 ＜＜＜===========================
echo.
echo 请输入一个解压位置以确保安装程序可以正常释放文件。
echo   直接按下回车键将设定解压位置为%systemdrive%\
echo.
echo   * 输入方式示例：%systemdrive%\  键入 EXIT 可以退出本程序。
set /p location=→
if /i "%location%"=="EXIT" goto self_del
if "%location%"=="" (
	set location=%systemdrive%\
	goto cn_way
)
if not exist %location% goto cn_err2
goto cn_way


:cn_way
cls
echo  =========================＞＞＞ 第 4 步  安装方式 ＜＜＜===========================
echo.
echo 请指定引导到安装程序所使用的启动方式。
echo   【注意】除非您拥有专业知识，否则请使用默认设置“通过NT引导器嵌套引导”！
echo.
echo   * 直接按下回车键设定安装方式为“通过NT引导器嵌套引导”；
if "%gpt_status%"=="0" echo   * 安装方式“通过主引导记录启动”【暂不被支持】；
if "%gpt_status%"=="1" echo   * 输入 write_gpt 并按下回车键设定安装方式为“通过EFI引导启动”；
echo   * 键入 EXIT 并按下回车键可以退出本程序。
set /p instway=→
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
echo  =======================＞＞＞ 第 5 步  准备安装程序 ＜＜＜=========================
echo.
echo 请确认您的设置是否正确：
echo.
echo * 您设定的文件为：%file%
echo       - 代系：AOSC OS%imginfo_os:~2,3%
if "%imginfo_dist%"=="anos" echo       - 发行版本：安同桌面版本
if "%imginfo_dist%"=="ancp" echo       - 发行版本：安同服务器版本 ( CentralPoint )
if "%imginfo_dist%"=="icnl" echo       - 发行版本：安同技术架构版本 ( IcenowyLinux )
if "%imginfo_dist%"=="spin" echo       - 发行版本：AOSC派生版本 ( AOSC Spins )
echo       - 系统版本号：%imginfo_ver%
echo       - 系统语言：%imginfo_lang%
echo.
echo * 您设定的解压路径为：%location%
echo.
if "%instway%"=="edit_present" echo * 您将通过NT引导器嵌套引导安装程序（默认设置）
if "%instway%"=="write_mbr" echo * 您将通过修改主引导记录引导安装程序
if "%instway%"=="write_gpt" echo * 您将通过修改ESP来从EFI引导安装程序
echo.
echo 按下回车键开始准备安装程序，否则请键入 no 然后回车。
echo   键入 EXIT 然后按下回车可以退出本程序。
set /p yesno=→
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
echo  ============================＞＞＞ 准备安装程序中 ＜＜＜===========================
echo          _          _   _                      ____  _             _
echo         / \   _ __ ^| ^|_^| ^|__   ___  _ __      / ___^|^| ^|_ __ _ _ __^| ^|_ ___ _ __
echo        / _ \  '_ \^| __^| '_ \ / _ \^| '_ \ ____\___ \^| __/ _` ^| '__^| __/ _ \ '__^|
echo       / ___ \^| ^| ^| ^| ^|_^| ^| ^| ^| (_) ^| ^| ^| ^|_____^|__) ^| ^|^| (_^| ^| ^|  ^| ^|^|  __/ ^|
echo      /_/   \_\_^| ^|_^|\__^|_^| ^|_^|\___/^|_^| ^|_^|    ^|____/ \__\__,_^|_^|   \__\___^|_^|
echo.
echo  ===================================================================================
echo.
echo 安同开始程序正在努力准备好安装程序。
echo 这个过程需要一些时间，如果您选择泡上一杯咖啡应该是不错的选择。
echo.
echo （第一步，共六步）  备份系统重要位置...


if "%~2"=="nt5" (
	attrib -s -h -r %systemdrive%\boot.ini
	copy %systemdrive%\boot.ini %systemdrive%\ast_bkup
)
if "%~2"=="nt6" bcdedit /export %systemdrive%\ast_bkup\BCDbckup

:: dd if=\\?\Device\Harddisk0\Partition1 of=%systemdrive%\ast_bkup\MBRbckup bs=446 count=1


echo （第二步，共六步）  解压预安装环境内核...
:: While extracting the files in [image_file]/boot/ , the new folder "boot" will be created by 7-Zip too.
:: For some users would install some recovery software (like "One-key Ghost", they will create a folder named "boot" too),
::   we first extract them into %temp%\ and then copy them into ast_strt\ .
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\vmlinuz -y > nul
move %temp%\boot\vmlinuz %systemdrive%\ast_strt\ > nul

echo （第三步，共六步）  解压预安装环境内存盘...
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\initrd -y > nul
move %temp%\boot\initrd %systemdrive%\ast_strt\ > nul

echo （第四步，共六步）  解压操作系统安装文件...
echo         * 本过程耗时较长，请耐心等待。
:: But notice that if we ::ove the folder "live" the kernel won't be able to find it...
%systemdrive%\ast_temp\7z x %file% -o%location% live\live.squashfs -y > nul

echo （第五步，共六步）  校验安装文件...
echo     1 / 3  校验预安装环境内核...
:: Read md5sum.ast
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\vmlinuz') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^4:"') do set md5sum_vmlinuz=%%b
if not %md5sum_buf:~1,33% == %md5sum_vmlinuz:~0,32% (
	echo                       *** 错误: 预安装环境内核校验失败！
	set verify_error=1
)
set md5sum_vmlinuz=
set md5sum_buf=

echo     2 / 3  校验预安装环境内存盘...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\initrd') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^5:"') do set md5sum_initrd=%%b
if not %md5sum_buf:~1,33% == %md5sum_initrd:~0,32% (
	echo                       *** 错误: 预安装环境内存盘校验失败！
	set verify_error=1
)
set md5sum_initrd=
set md5sum_buf=

echo     3 / 3  校验操作系统安装文件...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %location%live\live.squashfs') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^6:"') do set md5sum_squash=%%b
if not %md5sum_buf:~1,33% == %md5sum_squash:~0,32% (
 	echo                       *** 错误: 操作系统安装文件校验失败！
 	set verify_error=1
)
set md5sum_squash=
set md5sum_buf=

if not defined verify_error goto cn_verify_success

echo        *** 映像文件校验失败！继续进行安装可能导致安装失败...
echo            若要继续安装请输入 y 然后按下回车，输入其它字符或回车退出程序。
set /p vercho=            →
if not "%vercho%"=="y" (
	rd /s /q %location%live\
	goto self_del
)

:cn_verify_success


echo （第六步，共六步）  开始部署启动...

if "%instway%"=="write_mbr" (
	set instway=edit_present
	:: goto cn_edit_done
)
if "%instway%"=="write_gpt" (
	mountvol W:\ /s
	if not "%errorlevel%"=="0" (
		echo     *** 致命错误：ESP分区挂载失败！错误代码：%errorlevel%
		echo         为安全起见，安同开始程序将不再对分区表进行操作。
		echo         系统部署方式将更改为：通过NT引导器嵌套引导安装程序（默认设置）。
		mountvol W:\ /d
		if "%~2"=="nt5" goto cn_nt5_ntldr_edit
		if "%~2"=="nt6" goto cn_nt6_bcd_edit
	)
	mkdir W:\AOSC\
	copy %systemdrive%\ast_temp\bootx64.efi W:\AOSC\ > nul
	goto cn_edit_done
)
if "%instway%"=="edit_present" (
	if "%~2"=="nt5" goto cn_nt5_ntldr_edit
	if "%~2"=="nt6" goto cn_nt6_bcd_edit
)


:cn_nt5_ntldr_edit
echo [boot loader] > %systemdrive%\boot.ini
echo timeout=10 >> %systemdrive%\boot.ini
echo default=%systemdrive%\ast_strt\g2ldr.mbr >> %systemdrive%\boot.ini
echo [operating systems] >> %systemdrive%\boot.ini
echo %systemdrive%\WINDOWS="启动原来的 Windows 操作系统" >> %systemdrive%\boot.ini
echo %systemdrive%\ast_strt\g2ldr.mbr="启动 AOSC Live" >> %systemdrive%\boot.ini
echo. >> %systemdrive%\boot.ini
goto cn_edit_done

:cn_nt6_bcd_edit
for /f "delims=" %%i in ('bcdedit /create /d "启动 AOSC Live" /application bootsector') do set uid=%%i
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \ast_strt\g2ldr.mbr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
bcdedit /timeout 10
goto cn_edit_done


:cn_edit_done

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
echo  ==============================＞＞＞ 需要重启 ＜＜＜===============================
echo.
echo 安同开始程序已经准备好了操作系统的安装部署，即将重新启动到安装程序。
echo 请保存好您的工作，按下任意键重新启动您的电脑。
pause > nul
goto before_reboot


:cn_err1
cls
echo  ===============================＞＞＞ 出错啦 ＜＜＜================================
echo.
echo 您输入的这个：%file%
echo 它并不存在！请确认路径是否错误...
echo.
echo 按下任意键返回上一步！
pause > nul
set file=
goto cn_image

:cn_err2
cls
echo  ===============================＞＞＞ 出错啦 ＜＜＜================================
echo.
echo 您输入的这个：%location%
echo 它并不存在！请确认盘符是否错误...
echo.
echo 按下任意键返回上一步！
pause>nul
set location=
goto cn_target







:: //////////English
:en_main
cls
title Anthon-Starter 0.1.2
echo  ==============================＞＞＞ Welcome! ＜＜＜===============================
echo.
echo This program will guide you to complete the processess of installing the AnthonOS
echo from your local hard drive! The following versions are currently supported:
echo     * AnthonOS, The desktop version of AOSC;
echo     * CentralPoint, The server version of AOSC;
echo     * IcenowyLinux, The technical preview version of AOSC;
echo     * AOSC Spins, The derivative version of AOSC;
echo     * ...
echo.
echo.
echo * To start installation, please hit [ENTER];
echo * To view the license about this program, please input "license" and hit [ENTER];
echo * To view the about information, please input "about" and hit [ENTER] ;
echo * If you want to quit, please input "exit" and hit [ENTER];
echo.
set /p cho=Please make a choice:
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
echo We are checking your hard drive...
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
	echo *** FATAL ERROR: Anthon-Starter Program cannot mount ESP partition, error code: %errorlevel%
	echo     For some security reasons, program will now exit. We're really sorry for it.
	echo.
	echo     Please visit http://bugs.anthonos.org to report this problem...
	echo.
	echo     Press any key to exit!
	pause > nul
	goto self_del
)


:detect_gpt_done_en

cls
echo  ===================＞＞＞ Step 1  Checking your computer ＜＜＜====================
echo.
if "%~2"=="nt5" echo * We detected Windows NT5 series on your computer (like Windows 2k, XP)
if "%~2"=="nt6" echo * We detected Windows NT6 series on your computer（like as Windows Vista, 7, 8）
if "%gpt_status%"=="1" echo * We found that you are using GUID Partition Table (GPT)
if "%gpt_status%"=="0" echo * We found that you are using Master Boot Record (MBR)
echo.
echo Before installing please read the folloing instructions carefully: 
echo.
echo   1. Please PUT ALL YOUR INSTALLATION FILES INTO YOUR LOCAL HARD DRIVE 
echo        (NOT U-DISK, Portable hard disk, or MP3 etc...)
echo        PLEASE REMOVE ALL THE PORTABLE DEVICE BEFORE INSTALLING!
echo.
echo   2. All those versions can only run on x86_64 CPU, please check your computer
echo        whether it is meet the requirements, this program currently cannot detect it;
echo.
echo   3. Please check the hardware requirements before installing, otherwise you may
echo        feel unhappy;
echo.
echo   4. All the AOSC distribution are published under GNU LGPL license.
echo.
echo.
echo If everything goes well, please hit [ENTER] to start installation,
echo   or type EXIT to quit. 
set /p chkcho=→
if /i "%chkcho%"=="EXIT" goto self_del
if "%chkcho%"=="" goto en_image
:: Or exit, delete the temp files
set chkcho=
goto detect_gpt_done_en




:en_image
cls
echo  ======================＞＞＞ Step 2  Choosing Files ＜＜＜=========================
echo.
echo Please input the path of the image file which you obtained from our website
echo   【WARNING】Any illegal characters are not accepted here！
echo.
echo You can paste your path by right-clicking your mouse; type EXIT to quit.
set /p file=→
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
echo We are verifying this file...
%systemdrive%\ast_temp\7z x %file% -o%systemdrive%\ast_temp\ md5sum.ast -y > nul
if not "%errorlevel%"=="0" (
	echo     *** WARNING: This file is not supported by the program, error code: %errorlevel%
	echo               It would cause serious problems if you choose to continue.
	echo               So Anthon-Starter will refuse to continue!
	echo         Please report this issue to http://bugs.anthonos.org/
	echo.
	echo     Press any key to quit.
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
echo     *** ERROR: This distribution is not supported！
echo               Generation:   %imginfo_os%
echo               Distribution: %imginfo_dist%
echo               Verion:       %imginfo_ver%
echo               language:     %imginfo_lang%
echo.
echo               It would cause serious problems if you choose to continue.
echo               So Anthon-Starter will refuse to continue!
echo         Please report this issue to http://bugs.anthonos.org/
echo.
echo     Press any key to quit.
pause > nul
goto self_del


:en_target
cls
echo  ==========================＞＞＞ Step 3  Extract ＜＜＜============================
echo.
echo Please input a path where Anthon-Starter can extract its files to.
echo   If you hit [ENTER] without input anything, we will extract to %systemdrive%\
echo.
echo   * e.g.: %systemdrive%\  Type EXIT to quit.
set /p location=→
if /i "%location%"=="EXIT" goto self_del
if "%location%"=="" (
	set location=%systemdrive%\
	goto en_way
)
if not exist %location% goto en_err2
goto en_way


:en_way
cls
echo  ==========================＞＞＞ Step 4  Method ＜＜＜=============================
echo.
echo Please choose a method to boot the installer.
echo   【WARNING】UNLESS YOU KNOW WHAT YOU ARE DOING, OTHERWISE PLEASE SELECT
echo    “boot installer by NT bootloader”！
echo   * Hit [ENTER] directly to choose “boot installer by NT bootloader”;
if "%gpt_status%"=="0" echo   * Type write_mbr to choose “Boot from MBR”;
if "%gpt_status%"=="1" echo   * Type write_gpt to choose “Boot from EFI”;
echo   * Type EXIT to quit.
set /p instway=→
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
echo  =====================＞＞＞ Step 5  Ready to Install ＜＜＜=========================
echo.
echo Please check all you settings before moving to installer: 
echo.
echo * The file you have chosen: %file%
echo       - Generation: AOSC OS%imginfo_os:~2,3%
if "%imginfo_dist%"=="anos" echo       - Distro: AOSC Desktop
if "%imginfo_dist%"=="ancp" echo       - Distro: AOSC Server ( CentralPoint )
if "%imginfo_dist%"=="icnl" echo       - Distro: AOSC Tech preview ( IcenowyLinux )
if "%imginfo_dist%"=="spin" echo       - Distro: AOSC derivative ( AOSC Spins )
echo       - Version:  %imginfo_ver%
echo       - Language: %imginfo_lang%
echo.
echo * And will extract files to %location%
echo.
if "%instway%"=="edit_present" echo * You will boot installer by NT bootloader（default）
if "%instway%"=="write_mbr" echo * You will boot installer by modifying MBR
if "%instway%"=="write_gpt" echo * You will boot installer by modifying ESP to boot from EFI
echo.
echo Hit [ENTER] to continue, otherwise please type "no".
echo   Type EXIT to quit.
set /p yesno=→
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
echo  ============================＞＞＞ Preparing installer ＜＜＜======================
echo          _          _   _                      ____  _             _
echo         / \   _ __ ^| ^|_^| ^|__   ___  _ __      / ___^|^| ^|_ __ _ _ __^| ^|_ ___ _ __
echo        / _ \  '_ \^| __^| '_ \ / _ \^| '_ \ ____\___ \^| __/ _` ^| '__^| __/ _ \ '__^|
echo       / ___ \^| ^| ^| ^| ^|_^| ^| ^| ^| (_) ^| ^| ^| ^|_____^|__) ^| ^|^| (_^| ^| ^|  ^| ^|^|  __/ ^|
echo      /_/   \_\_^| ^|_^|\__^|_^| ^|_^|\___/^|_^| ^|_^|    ^|____/ \__\__,_^|_^|   \__\___^|_^|
echo.
echo  ===================================================================================
echo.
echo We are trying to preparing installer...
echo It may take a while. During this time, why not making a pot of coffee?
echo.
echo (1 of 6)  Backing up ...


if "%~2"=="nt5" (
	attrib -s -h -r %systemdrive%\boot.ini
	copy %systemdrive%\boot.ini %systemdrive%\ast_bkup
)
if "%~2"=="nt6" bcdedit /export %systemdrive%\ast_bkup\BCDbckup

:: dd if=\\?\Device\Harddisk0\Partition1 of=%systemdrive%\ast_bkup\MBRbckup bs=446 count=1


echo (2 of 6)  Decompressing pre-installation environment kernel...
:: While extracting the files in [image_file]/boot/ , the new folder "boot" will be created by 7-Zip too.
:: For some users would install some recovery software (like "One-key Ghost", they will create a folder named "boot" too),
::   we first extract them into %temp%\ and then copy them into ast_strt\ .
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\vmlinuz -y > nul
move %temp%\boot\vmlinuz %systemdrive%\ast_strt\ > nul

echo (3 of 6)  Decompressing pre-installation environment RAM disk...
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\initrd -y > nul
move %temp%\boot\initrd %systemdrive%\ast_strt\ > nul

echo (4 of 6)  Decompressing operating system ...
echo         * It may take much time here, so please wait patiently!
:: But notice that if we ::ove the folder "live" the kernel won't be able to find it...
%systemdrive%\ast_temp\7z x %file% -o%location% live\live.squashfs -y > nul

echo (5 of 6)  Verifying files...
echo     1 / 3  Verifying pre-installation environment kernel...
:: Read md5sum.ast
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\vmlinuz') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^4:"') do set md5sum_vmlinuz=%%b
if not %md5sum_buf:~1,33% == %md5sum_vmlinuz:~0,32% (
	echo                       *** ERROR: pre-installation environment kernel is not correct!
	set verify_error=1
)
set md5sum_vmlinuz=
set md5sum_buf=

echo     2 / 3  Verifying pre-installation environment RAM disk...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\initrd') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^5:"') do set md5sum_initrd=%%b
if not %md5sum_buf:~1,33% == %md5sum_initrd:~0,32% (
	echo                       *** ERROR: pre-installation environment RAM disk is not correct!
	set verify_error=1
)
set md5sum_initrd=
set md5sum_buf=

echo     3 / 3  Verifying operating system...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %location%live\live.squashfs') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^6:"') do set md5sum_squash=%%b
if not %md5sum_buf:~1,33% == %md5sum_squash:~0,32% (
 	echo                       *** ERROR: operating system is not correct!
 	set verify_error=1
)
set md5sum_squash=
set md5sum_buf=

if not defined verify_error goto en_verify_success

echo        *** Failed to verify files！If you choose to continue, you may face errors...
echo            type y to force continue, type other characters to quit.
set /p vercho=            →
if not "%vercho%"=="y" (
	rd /s /q %location%live\
	goto self_del
)

:en_verify_success


echo (6 of 6)  Start deploying boot...

if "%instway%"=="write_mbr" (
	set instway=edit_present
	:: goto en_edit_done
)
if "%instway%"=="write_gpt" (
	mountvol W:\ /s
	if not "%errorlevel%"=="0" (
		echo     *** FATAL ERROR: Failed to mount ESP partition! Error code: %errorlevel%
		echo         For security reasons, Anthon-Starter will not modify your Partition table.
		echo         The deploy method has changed to: boot installer by NT bootloader (default).
		mountvol W:\ /d
		if "%~2"=="nt5" goto en_nt5_ntldr_edit
		if "%~2"=="nt6" goto en_nt6_bcd_edit
	)
	mkdir W:\AOSC\
	copy %systemdrive%\ast_temp\bootx64.efi W:\AOSC\ > nul
	goto en_edit_done
)
if "%instway%"=="edit_present" (
	if "%~2"=="nt5" goto en_nt5_ntldr_edit
	if "%~2"=="nt6" goto en_nt6_bcd_edit
)


:en_nt5_ntldr_edit
echo [boot loader] > %systemdrive%\boot.ini
echo timeout=10 >> %systemdrive%\boot.ini
echo default=%systemdrive%\ast_strt\g2ldr.mbr >> %systemdrive%\boot.ini
echo [operating systems] >> %systemdrive%\boot.ini
echo %systemdrive%\WINDOWS="Start original Windows" >> %systemdrive%\boot.ini
echo %systemdrive%\ast_strt\g2ldr.mbr="Start AOSC Live" >> %systemdrive%\boot.ini
echo. >> %systemdrive%\boot.ini
goto en_edit_done

:en_nt6_bcd_edit
for /f "delims=" %%i in ('bcdedit /create /d "Start AOSC Live" /application bootsector') do set uid=%%i
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \ast_strt\g2ldr.mbr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
bcdedit /timeout 10
goto en_edit_done


:en_edit_done

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
echo  =============================＞＞＞ HERE WE GO ＜＜＜==============================
echo.
echo Anthon-Starter has finished preparing installer, and will soon reboot to installer.
echo Please save all your current data, and then press any key to reboot.
pause > nul
goto before_reboot


:en_err1
cls
echo  ===============================＞＞＞ ERROR! ＜＜＜================================
echo.
echo You typed: %file%
echo That is not exist！Please make sure you have input the right path...
echo.
echo Press any key to back！
pause > nul
set file=
goto en_image

:en_err2
cls
echo  ===============================＞＞＞ ERROR! ＜＜＜================================
echo.
echo You typed: %location%
echo That is not exist! Please make sure you have input the right path...
echo.
echo Press any key to back！
pause>nul
set location=
goto en_target















:cn_about
cls
title 关于安同开始程序 0.1.2
echo                            _          _   _
echo                      AS   / \   _ __ ^| ^|_^| ^|__   ___  _ __
echo                          / _ \  '_ \^| __^| '_ \ / _ \^|'_   \
echo                         / ___ \^| ^| ^| ^| ^|_^| ^| ^| ^| (_) ^| ^| ^| ^|
echo                        /_/   \_\_^| ^|_^|\__^|_^| ^|_^|\___/^|_^| ^|_^|  Do.
echo.
echo                                 安同开始程序 0.1.2
echo                           著作权所有 (C) 2014 安同开源社区
echo.
echo 本软件使用 Apache 许可证第二版版授权。
echo.
echo 参与开发人员：
echo 黎民雍 ^< lmy441900@gmail.com ^>
echo 许皓鸣 ^< 18929292333@163.com ^>
echo 刘子兴 ^< liushuyu011@gmail.com ^>
echo.
echo 获取更多信息，请登录安同开源社区 http://anthonos.org/
echo.
echo 按下任意键返回主屏幕。
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