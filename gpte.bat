@REM  Anthon-Starter: Installation helper for :Next Linux distribution series.
@REM  This is the main batch file. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off

REM ������������ǽ�GRUB������ESP��
REM ��ִ���������ǰ���Ƚ�grubѹ��������C:\atostemp�У�Ȩ�����⣩

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
