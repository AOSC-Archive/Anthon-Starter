@REM  Anthon-Starter: Installation helper for :Next Linux distribution series. Version 0.1.2
@REM  Copyright (C) 2014 Anthon Open Source Community - Junde Studio. 
@REM  Tencent QQ Group: 292606292
@REM
@REM  This software is under GNU Genereal Public License 3 and WITHOUT ANY WARRANTY.
@REM  So you know it...            


@echo off
REM //////////////////////////////////////////////////////������Ӧ�ñ��������ԱȨ�ޣ���Ϊ���漰�˶�ϵͳ���̵Ĳ���������������޸ġ�
if "%1"==""1"" (
 title ��ͬ��ʼ���� 0.1.2 [�ӳ���汾��1.1]
 echo ����ִ�ж�NT6.x�ں˵�BOOTMGR�����޸Ĵ���...
)
if "%1"==""2"" (
 title ��ͬ�_ʼ��ʽ 0.1.2 [Editor V1.1]
 echo ���ڈ��Ќ�NT6.X�Ⱥ˵�BOOTMGR�����޸�̎��...
)
if "%1"==""3"" (
 title Anthon-Starter 0.1.2 [Editor V1.1]
 echo Editing the BOOTMGR...
)
if "%1"==""4"" (
 title Anthon-Starter 0.1.2 [Editor V1.1]
 echo Editing the BOOTMGR...
)

REM //////////////////////////////////////////////////////����menu.lst�ļ�
echo # ���ǰ�ͬ��ʼ���򴴽���menu.lst�ļ�>%systemdrive%\menu.lst
echo default 0 >>%systemdrive%\menu.lst
echo timeout 0 >>%systemdrive%\menu.lst
echo. >>%systemdrive%\menu.lst
echo title Install AnthonOS>>%systemdrive%\menu.lst
echo  kernel /anthon/vmlinuz ro quiet>>%systemdrive%\menu.lst
echo  initrd /anthon/initrd.img >>%systemdrive%\menu.lst
echo  boot >>%systemdrive%\menu.lst

echo %1 >%systemdrive%\info.ast
echo %2 >>%systemdrive%\info.ast

REM //////////////////////////////////////////////////////����vmlinuz initrd.img��grldr grldr.mbr
copy %systemdrive%\boot\vmlinuz %systemdrive%\anthon >nul
copy %systemdrive%\boot\initrd.img %systemdrive%\anthon >nul
del %systemdrive%\boot\vmlinuz
del %systemdrive%\boot\initrd.img
copy %systemdrive%\atostemp\grldr %systemdrive%\ >nul
copy %systemdrive%\atostemp\grldr.mbr %systemdrive%\ >nul
copy %systemdrive%\atostemp\atosstup %ststemdrive%\ >nul
if not exist %systemdrive%\boot\* rd /s /q %systemdrive%\boot

REM //////////////////////////////////////////////////////�޸�BCD�Σ�ʹ����BCDEdit���
mkdir %systemdrive%\atosbkup &REM //////////////////////////////////////////////////////����֮ǰ�ȱ�����BCD��MBR
cd /d %systemdrive%\atostemp
cd /d %systemroot%
bcdedit /export %systemdrive%\atosbkup\BCDbckup
bcdedit /timeout 20
for /f "delims=" %%a in ('bcdedit /create /d "��װ��ͬOS" /application bootsector') do set "uid=%%a" &REM //////////����л�ٶ�֪������xxpinqz�ṩ�İ�����
bcdedit /set %uid:~2,38% device partition=%systemdrive%
bcdedit /set %uid:~2,38% path \grldr.mbr
bcdedit /displayorder %uid:~2,38% /addlast
bcdedit /default %uid:~2,38%
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Anthon /t REG_SZ /d %Systemdrive%\atostemp\atosstup.exe /f

set uid=
exit