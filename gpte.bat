@REM  Anthon-Starter: Installation helper for :Next Linux distribution series. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off

REM 下面语句作用是将GRUB部署在ESP中
REM 在执行以下语句前需先将grub压缩包置于C:\atostemp中（权限问题）

mountvol W:\ /s
cd /d W:\
if exist boot\grub rd /s /q boot\grub
mkdir boot\grub
cd /d C:\atostemp
7z x grub.7z -oW:\boot\grub -y
copy bootx64.efi W:\
ren W:\bootx64.efi AStarter.efi
copy grub.cfg W:\
mountvol W:\ /d
pause
