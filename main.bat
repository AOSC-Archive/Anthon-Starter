@REM  Anthon-Starter: Installation helper for :Next Linux distribution series.
@REM  This is the main batch file. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off
title Anthon Open Source Community - Junde Studio
:language
cls
echo                    ====＞＞＞Choose your language:＜＜＜====
echo                    [                                       ]
echo                    [       1:  简体中文                    ]
echo                    [       2:  English                     ]
echo                    [                                       ]
echo                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
set /p lang=Input the number:
if "%lang%"=="1" goto cn_main
if "%lang%"=="2" goto en_main
set lang=
goto language










REM //////////SimplifiedChinese
:cn_main
cls
title 安同开始程序 0.1.2
echo ====================＞＞＞欢迎使用安同开始程序＜＜＜====================
echo.
echo 本程序将引导您轻松地从硬盘安装安同GNU/Linux桌面版
echo （或是社区合作项目IcenowyLinux）
echo.
echo * 要马上开始安装，请直接敲击回车键；
echo * 要查看本程序的版权信息请键入 license 然后回车；
echo * 关于本程序请键入 about 然后回车；
echo * 退出本程序请键入 exit 然后回车。
echo.
set /p cho=选择一个选项：
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
if "%1"==""nt5"" (
 set loader=NT5.x[Win2k/XP]
 goto cn_chkgpt
)
if "%1"==""nt6"" (
 set loader=NT6.x[WinVista+]
 goto cn_chkgpt
)

echo 没有探测到引导器或者参数错误，为安全起见，程序将退出。
echo 您可以附加一个loader参数来强制设置引导器。
echo 如果您使用的是WindowsNT/2k/XP系统：anthon_win.exe nt5
echo 如果您使用的是WindowsVista/7系统：anthon_win.exe nt6
echo.
echo 详见安同开源社区相关帖子 http://jds.forum.anthonos.org/
pause
exit



:cn_chkgpt
mountvol W:\ /s
if "%ERRORLEVEL%"=="1" (
	echo.
	echo GPT引导分区挂载失败！为了安全起见，程序将退出...
	echo 您可以询问您的计算机管理员了解情况。
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
echo ====================＞＞＞第1步  选择文件＜＜＜====================
echo.
echo 探测到您的系统为：%loader%
if "%gpt_status%"=="0" echo 探测到您的分区表为：MBR（主引导记录）
if "%gpt_status%"=="1" echo 探测到您的分区表为：GPT（GUID分区表）
echo.
echo 请键入您所获取的光盘映像文件的所在位置（可以用鼠标拖到这里）：
echo 注意：键入各种非法字符和路径将导致操作失败！
set /p file=—＞
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
echo ====================＞＞＞第2步  解压位置＜＜＜====================
echo.
echo 请键入您想要把这些文件解压到哪里？
echo 直接 [回车] 将设定为系统%systemdrive%\盘。输入示例：%systemdrive%\
set /p location=—＞
if "%location%"=="" set location=%systemdrive%\
if not exist %location% goto cn_err2 &REM //////////////////////////////////////////////////////没有这个文件的时候跳转至相应错误提示
goto cn_goingon


:cn_goingon
cls
echo ====================＞＞＞第3步  准备安装程序＜＜＜====================
echo.
echo 您设定的文件为：%file%
echo 您设定的解压路径为：%location%
echo.
echo 确定吗？ [回车] 开始准备安装程序，否则请键入 no 然后回车。
set /p yesno=—＞
if "%yesno%"=="no" (
 set file=
 set location=
 set yesno=
 goto cn_inst
) &REM //////////////////////////////////////////////////////万一打错了，可以回复重新开始
echo 安同开始程序正在努力准备好安装程序。
echo 这个过程需要一些时候。请耐心等待。
title 安同开始程序 0.1.2                    0％解压内核...
7z x %file% -o%systemdrive%\ boot\vmlinuz -y >nul
title 安同开始程序 0.1.2                    15％解压预安装环境...
7z x %file% -o%systemdrive%\ boot\initrd.img -y >nul
title 安同开始程序 0.1.2                    25％解压操作系统安装包...
7z x %file% -o%location% tarball.tar.xz -y >nul
title 安同开始程序 0.1.2                    80％开始部署启动...


title 安同开始程序 0.1.2                    82％部署启动...



if not exist %systemdrive%\boot\* rd /s /q %systemdrive%\boot &REM ///////////这句有病，不能运作，原因暂时未知。

title 安同开始程序 0.1.2                    95％部署启动...


:cn_finish
title 安同开始程序 0.1.2
cls
echo ====================＞＞＞就绪啦＜＜＜====================
echo.
echo 安同开始程序已经准备好了操作系统的安装部署，即将重新启动到安装程序。
echo 请保存好您的工作，按下任意键重新启动您的电脑。
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
echo ====================＞＞＞出错啦＜＜＜====================
echo.
echo 您输入的这个文件并不存在！请确认路径是否错误...
echo.
echo 按下任意键返回上一步！
pause>nul
set file=
goto cn_inst

:cn_err2
cls
echo ====================＞＞＞出错啦＜＜＜====================
echo.
echo 您输入的这个盘符并不存在！请确认盘符是否错误...
echo.
echo 按下任意键返回上一步！
pause>nul
set location=
goto cn_extr












REM //////////English
:en_main
cls
title Anthon-Starter 0.1.2
echo =========================＞＞＞Welcome!＜＜＜=========================
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
echo ====================＞＞＞Step 1: Choose The File＜＜＜====================
echo.
echo Auto detecting your boot loader: %loader%
echo Please input the path of the image file (You can also drag here).
echo Warning: Any illegal character is NOT allowed!
set /p file=—＞
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
echo ====================＞＞＞Step 2: Extraction Path＜＜＜====================
echo.
echo Where do you want to extract the files?
echo Will auto set the path to %systemdrive%\ if pressed [Enter] . Example: %systemdrive%\
set /p location=—＞
if "%location%"=="" set location=%systemdrive%\
if not exist %location% goto en_err2
goto en_exec


:eng_exec
cls
echo ====================＞＞＞Step 3: Running＜＜＜====================
echo.
echo The image file is %file%
echo The location is %location%
echo.
echo Are you sure? Press [Enter] to execute immediately.
echo Or you can input 'no' to give up.
set /p yesno=—＞
if "%yesno%"=="no" (
 set file=
 set location=
 set yesno=
 goto eng_inst
)
echo Anthon-Starter is loading files.
echo Will take a few minutes. Please wait patiently...
title Anthon-Starter 0.1.2                    0％Extracting Kernel...
7z x %file% -o%systemdrive%\ boot\vmlinuz -y >nul
title Anthon-Starter 0.1.2                    15％Entracting PE...
7z x %file% -o%systemdrive%\ boot\initrd.img -y >nul
title Anthon-Starter 0.1.2                    25％Extracting OS package...
7z x %file% -o%location% tarball.tar.xz -y >nul
title Anthon-Starter 0.1.2                    80％Deploying...




title Anthon-Starter 0.1.2                    82％Deploying...


title Anthon-Starter 0.1.2                    95％Deploying...



:en_finish
title Anthon-Starter 0.1.2
cls
echo =========================＞＞＞Ready!＜＜＜=========================
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
echo =========================＞＞＞ Error... ＜＜＜=========================
echo.
echo Can't find the image file. Please check if the path is right!
echo.
echo Press any key to return...
pause>nul
set file=
goto en_inst

:en_err2
cls
echo =========================＞＞＞ Error... ＜＜＜=========================
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
echo %systemdrive%\grldr="启动安同OS安装程序" >>%systemdrive%\boot.ini
echo %Systemroot%="启动原来的Windows操作系统" >>%systemdrive%\boot.ini
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
echo %systemdrive%\grldr="啟動安同OS開始程式" >>%systemdrive%\boot.ini
echo %Systemroot%="啟動之前的Windows作業系統" >>%systemdrive%\boot.ini
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
title 关于安同开始程序 0.1.1
echo                                   AS 安同 Do.
echo.
echo                               安同开始程序0.1.2
echo                          安同开源社区-俊德工作室 出品
echo.
echo 本程序为自由软件；您可依据自由软件基金会所发表的GNU通用公共授权条款规定，就本程序再为发布与／或修改；无论您依据的是本授权的第二版或（您自行选择的）任一日后发行的版本。
echo.
echo 感谢以下参与编写本程序的人员：
echo 以俊德 [lmy441900@gmail.com]
echo ruojiner [ruojiner@163.com]
echo.
echo 获取更多信息，请登录安同开源社区 http://forum.anthonos.org/
echo.
echo 按下任意键返回主屏幕。
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

