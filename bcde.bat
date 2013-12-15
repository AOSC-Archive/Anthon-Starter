@REM  Anthon-Starter: Installation helper for :Next Linux distribution series. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off
REM //////////////////////////////////////////////////////本程序应该被赋予管理员权限，因为它涉及了对系统磁盘的操作和引导程序的修改。
if "%1"==""1"" (
 title 安同开始程序 0.1.2 [子程序版本号1.1]
 echo 正在执行对NT6.x内核的BOOTMGR引导修改处理...
)
if "%1"==""2"" (
 title 安同開始程式 0.1.2 [Editor V1.1]
 echo 正在執行對NT6.X內核的BOOTMGR引導修改處理...
)
if "%1"==""3"" (
 title Anthon-Starter 0.1.2 [Editor V1.1]
 echo Editing the BOOTMGR...
)
if "%1"==""4"" (
 title Anthon-Starter 0.1.2 [Editor V1.1]
 echo Editing the BOOTMGR...
)

REM //////////////////////////////////////////////////////创建menu.lst文件
echo # 这是安同开始程序创建的menu.lst文件>%systemdrive%\menu.lst
echo default 0 >>%systemdrive%\menu.lst
echo timeout 0 >>%systemdrive%\menu.lst
echo. >>%systemdrive%\menu.lst
echo title Install AnthonOS>>%systemdrive%\menu.lst
echo  kernel /anthon/vmlinuz ro quiet>>%systemdrive%\menu.lst
echo  initrd /anthon/initrd.img >>%systemdrive%\menu.lst
echo  boot >>%systemdrive%\menu.lst

echo %1 >%systemdrive%\info.ast
echo %2 >>%systemdrive%\info.ast

REM //////////////////////////////////////////////////////放置vmlinuz initrd.img和grldr grldr.mbr
copy %systemdrive%\boot\vmlinuz %systemdrive%\anthon >nul
copy %systemdrive%\boot\initrd.img %systemdrive%\anthon >nul
del %systemdrive%\boot\vmlinuz
del %systemdrive%\boot\initrd.img
copy %systemdrive%\atostemp\grldr %systemdrive%\ >nul
copy %systemdrive%\atostemp\grldr.mbr %systemdrive%\ >nul
copy %systemdrive%\atostemp\atosstup %ststemdrive%\ >nul
if not exist %systemdrive%\boot\* rd /s /q %systemdrive%\boot

REM //////////////////////////////////////////////////////修改BCD段，使用了BCDEdit命令。
mkdir %systemdrive%\atosbkup &REM //////////////////////////////////////////////////////操作之前先备份了BCD和MBR
cd /d %systemdrive%\atostemp
cd /d %systemroot%
bcdedit /export %systemdrive%\atosbkup\BCDbckup
bcdedit /timeout 20
for /f "delims=" %%a in ('bcdedit /create /d "安装安同OS" /application bootsector') do set "uid=%%a" &REM //////////这句感谢百度知道网友xxpinqz提供的帮助！
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \grldr.mbr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon /t REG_SZ /d %Systemdrive%\atostemp\atosstup.exe /f

set uid=
exit