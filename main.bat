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

REM Check whether the parameters exists (for insurance):
REM   %1 : Language
REM   %2 : Type of boot loader
if "%~1"=="" exit
if "%~2"=="" exit

REM Define the size of console:
REM   Height: 25 lines
REM   Width : 85 characters
mode con lines=25 cols=85

REM Judge the language
if "%~1"=="1" goto cn_main
if "%~1"=="2" goto en_main
goto self_del

REM //////////Simplified Chinese
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


REM Detect GPT... init.bat has no power to do it.
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
REM Or exit, delete the temp files
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

REM Check if the image file is AOSC Linux distribution...
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

REM Get the information inside the image file...
for /f "tokens=3 delims=: " %%a in ('findstr /n .* md5sum.ast^|findstr "^2:"') do set imginfo_os=%%a
for /f "tokens=4 delims=: " %%a in ('findstr /n .* md5sum.ast^|findstr "^2:"') do set imginfo_dist=%%a
for /f "tokens=5 delims=: " %%a in ('findstr /n .* md5sum.ast^|findstr "^2:"') do set imginfo_ver=%%a
for /f "tokens=6 delims=: " %%a in ('findstr /n .* md5sum.ast^|findstr "^2:"') do set imginfo_lang=%%a
if "%imginfo_dist%"=="anos" goto cn_target
if "%imginfo_dist%"=="ancp" goto cn_target
if "%imginfo_dist%"=="icnl" goto cn_target
if "%imginfo_dist%"=="spin" goto cn_target
REM There must be something interesting...
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
if "%gpt_status%"=="0" echo   * 输入 write_mbr 并按下回车键设定安装方式为“通过主引导记录启动”；
if "%gpt_status%"=="1" echo   * 输入 write_gpt 并按下回车键设定安装方式为“通过EFI引导启动”；
echo   * 键入 EXIT 并按下回车键可以退出本程序。
set /p instway=→
if /i "%instway%"=="EXIT" goto self_del
if "%instway%"=="" (
	set instway=edit_present
	goto cn_ready
)
if "%instway%"=="write_mbr" (
	REM Check if GPT was detected.
	if "%gpt_status%"=="1" (
		set instway=
		goto cn_way
	)
	goto cn_ready
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
pause
goto self_del

if "%~2"=="nt5" (
	attrib -s -h -r %systemdrive%\boot.ini
	copy %systemdrive%\boot.ini %systemdrive%\ast_bkup
	)
if "%~2"=="nt6" bcdedit /export %systemdrive%\ast_bkup\BCDbckup

REM dd if=\\?\Device\Harddisk0\Partition1 of=%systemdrive%\ast_bkup\MBRbckup bs=446 count=1


echo （第二步，共六步）  解压预安装环境内核...
REM While extracting the files in [image_file]/boot/ , the new folder "boot" will be created too.
REM Because some users would install some recovery software (like "One-key Ghost", 7-Zip will create a folder named "boot" too),
REM   we first extract them into %temp%\ and then copy them into ast_strt.
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\vmlinuz -y > nul
move %temp%\boot\vmlinuz %systemdrive%\ast_strt

echo （第三步，共六步）  解压预安装环境内存盘...
%systemdrive%\ast_temp\7z x %file% -o%temp%\ boot\initrd -y > nul
move %temp%\boot\initrd %systemdrive%\ast_strt

echo （第四步，共六步）  解压操作系统安装文件...
echo         * 本过程耗时较长，请耐心等待。
REM But notice that if we remove the folder "live" the kernel won't be able to find it...
%systemdrive%\ast_temp\7z x %file% -o%location% live\live.squashfs -y > nul

echo （第五步，共六步）  校验安装文件...
echo     1 / 3  校验预安装环境内核...
REM Read md5sum.ast
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\vmlinuz') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum.ast^|findstr "^4:"') do set md5sum_vmlinuz=%%b
if "%md5sum_buf:~0,32%" NEQ "%md5sum_vmlinuz:~0,32%" (
	echo                       *** 错误: 预安装环境内核校验失败！
	set verify_error=1
)
set md5sum_vmlinuz=
set md5sum_buf=

echo     2 / 3  校验预安装环境内存盘...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %systemdrive%\ast_strt\initrd') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum^|findstr "^5:"') do set md5sum_initrd=%%b
if "%md5sum_buf:~0,32%" NEQ "%md5sum_initrd:~0,32%" (
	echo                       *** 错误: 预安装环境内存盘校验失败！
	set verify_error=1
)
set md5sum_initrd=
set md5sum_buf=

echo     3 / 3  校验操作系统安装文件...
for /f "delims=" %%i in ('%systemdrive%\ast_temp\md5sum.exe -b %location%live\live.squashfs') do set md5sum_buf=%%i
for /f "tokens=1* delims=:" %%a in ('findstr /n .* %systemdrive%\ast_temp\md5sum^|findstr "^6:"') do set md5sum_squash=%%b
if "%md5sum_buf:~0,32%" NEQ "%md5sum_squash:~0,32%" (
	echo                       *** 错误: 操作系统安装文件校验失败！
	set verify_error=1
)
set md5sum_squash=
set md5sum_buf=

if "%verify_error%"=="0" goto cn_verify_success

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
	grubinst --grub2 (hd0)
	goto cn_edit_done
)
if "%instway%"=="write_gpt" (
	mountvol W:\ /s
	if not "%errorlevel%"=="0" (
		echo     *** 致命错误：ESP分区挂载失败！错误代码：%errorlevel%
		echo         为安全起见，安同开始程序将不再对分区表进行操作。
		echo         系统部署方式将更改为：通过NT引导器嵌套引导安装程序（默认设置）。
		mountvol W:\ /d
		if "%2"==""nt5"" goto cn_nt5_ntldr_edit
		if "%2"==""nt6"" goto cn_nt6_bcd_edit
	)
	mkdir W:\AOSC\
	copy %systemdrive%\bootx64.efi W:\AOSC\ > nul
	goto cn_edit_done
)


if "%instway%"=="edit_present" (
	if "%~2"=="nt5" goto cn_nt5_ntldr_edit
	if "%~2"=="nt6" goto cn_nt6_bcd_edit
)
REM While setting variables in "if(...)", it doesn't work usually. F**k CMD!
REM So we make this little hack...

:cn_nt5_ntldr_edit
echo [boot loader] > %systemdrive%\boot.ini
echo timeout=10 >> %systemdrive%\boot.ini
echo default=%systemdrive%\ast_strt\g2ldr.mbr >> %systemdrive%\boot.ini
echo [operating systems] >> %systemdrive%\boot.ini
echo %systemdrive%\WINDOWS="启动原来的Windows操作系统" >> %systemdrive%\boot.ini
echo %systemdrive%\ast_strt\g2ldr.mbr="启动安同 GNU/Linux安装程序" >> %systemdrive%\boot.ini
echo. >> %systemdrive%\boot.ini
goto cn_edit_done

:cn_nt6_bcd_edit
for /f "delims=" %%i in ('bcdedit /create /d "启动安同 GNU/Linux 安装程序" /application bootsector') do set uid=%%i
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \ast_strt\g2ldr.mbr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
bcdedit /timeout 10
goto cn_edit_done


:cn_edit_done

REM Generate grub.cfg
if "%instway%"=="edit_present" set g2ldrcfg=%systemdrive%\ast_strt\grub.cfg
if "%instway%"=="write_mbr" set g2ldrcfg=%systemdrive%\ast_strt\grub.cfg
if "%instway%"=="write_gpt" set g2ldrcfg=W:\AOSC\grub.cfg

echo # Grub.cfg generated by Anthon-Starter 0.1.2 > %g2ldrcfg%
echo. >> %g2ldrcfg%
echo set default="1" >> %g2ldrcfg%
echo set gfxmode=1024x768 >> %g2ldrcfg%
echo terminal_output gfxterm >> %g2ldrcfg%
echo set timeout="10" >> %g2ldrcfg%
if "%instway%"=="edit_present" echo loadfont /ast_strt/unicode.pf2 >> %g2ldrcfg%
if "%instway%"=="write_mbr" echo loadfont /ast_strt/unicode.pf2 >> %g2ldrcfg%
if "%instway%"=="write_gpt" echo loadfont /AOSC/unicode.pf2 >> %g2ldrcfg%
echo. >> %g2ldrcfg%
echo menuentry "启动原来的 Windows 操作系统" { >> %g2ldrcfg%
echo   search --set=root --no-floppy /ntldr >> %g2ldrcfg%
echo   chainloader /ntldr >> %g2ldrcfg%
echo   boot >> %g2ldrcfg%
echo } >> %g2ldrcfg%
echo. >> %g2ldrcfg%
echo menuentry "启动安同 GNU/Linux 安装程序" { >> %g2ldrcfg%
echo   search --set=root --no-floppy /ast_strt/vmlinuz >> %g2ldrcfg%
echo   linux /ast_strt/vmlinuz boot=live config quiet noswap noeject rw >> %g2ldrcfg%
echo   initrd /ast_strt/initrd >> %g2ldrcfg%
echo   boot >> %g2ldrcfg%
echo } >> %g2ldrcfg%
echo. >> %g2ldrcfg%
echo menuentry "启动安同 GNU/Linux 安装程序（安全显示设定模式）" { >> %g2ldrcfg%
echo   search --set=root --no-floppy /ast_strt/vmlinuz >> %g2ldrcfg%
echo   linux /ast_strt/vmlinuz boot=live config quiet noswap noeject nomodeset vga=normal rw >> %g2ldrcfg%
echo   initrd /ast_strt/initrd >> %g2ldrcfg%
echo   boot >> %g2ldrcfg%
echo } >> %g2ldrcfg%
echo. >> %g2ldrcfg%


if not "%instway%"=="write_gpt" (
	copy %systemdrive%\ast_temp\g2ldr.mbr %systemdrive\ast_strt\ > nul
	copy %systemdrive%\ast_temp\g2ldr %systemdrive%\ > nul
)

if not "%instway%"=="write_gpt" copy %systemdrive%\ast_temp\unicode.pf2 %systemdrive%\ast_strt\ > nul
if "%instway%"=="write_gpt" copy %systemdrive%\ast_temp\unicode.pf2 W:\AOSC\ > nul

if "%instway%"=="write_gpt" mountvol W:\ /d

pause


:cn_finish
cls
echo  ==============================＞＞＞ 一切就绪 ＜＜＜===============================
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












:en_main
cls
title Anthon-Starter 0.1.2
echo  ==============================＞＞＞ Welcome! ＜＜＜===============================
echo.
echo Not Finished Yet.
pause > nul
goto self_del









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
echo 黎民雍 [ lmy441900@gmail.com ]
echo 许皓鸣 [ 18929292333@163.com ]
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
echo Junde Yi [ lmy441900@gmail.com ]
echo Haoming Xu [ 18929292333@163.com ]
echo.
echo For any information, please visit http://anthonos.org/
echo.
echo Press any key to return.
pause > nul
set cho=
goto en_main


:before_reboot
REM Generate info.ast for startup.exe
echo # info.ast generated by Anthon-Starter 0.1.2 > %systemdrive%\ast_strt\info.ast
echo %~1 >> %systemdrive%\ast_strt\info.ast
echo %location% >> %systemdrive%\ast_strt\info.ast
copy %systemdrive%\ast_temp\startup.exe %systemdrive%\ast_strt\
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon-Starter_Startup_Utility /t REG_SZ /d %systemdrive%\ast_strt\startup.exe /f
rd /s /q %systemdrive%\ast_temp
REM shutdown -r -t 00
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

REM ***Here we have a problem, which cannot let the program delete itself.

rd /s /q %systemdrive%\ast_bkup
rd /s /q %systemdrive%\ast_strt
rd /s /q %systemdrive%\ast_temp
exit