/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014 Anthon Open Source Community
 * This file is a part of Anthon-Starter.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
 
# define MBRBKFILE "C:\\ast_bkup\\mbrdata.bin" //where to store backupfile
# include <windows.h> //OK, WINAPI again...:-)
# include <tchar.h>
# include <stdio.h>
 //# include "funcs.h"
 # include "defs.h"
 # include "clrprintf.h"
int bkmbr();
int status;
int bkgpt();
int bkldr(int loader);

int backup ( int loader, int ptable )
{
    system ("@echo off");
    /*ERROR handling*/
    if (ptable == PTABLE_UNKNOWN) {
       clrprintf(RED,"[E]");
       clrprintf( YELLOW,"The type of your partition table is not known. \n To prevent from misbehaving, program will now exit! \n" );
       return 2;
    }
    if (loader == LOADER_UNKNOWN){
       clrprintf(RED,"[E]");
       clrprintf( YELLOW,"The type of your bootloader is not known. \n To prevent from misbehaving, program will now exit! \n" );
       return 2;
    }
    /*backup Starts here!*/
    //Start back up MBR!
    if (ptable == PTABLE_MBR) {
        printf("Backing up MBR ... \n");
        status = bkmbr();
        if ( status != 0 ) {
            clrprintf(RED,"[E]");
            printf ( " Failed to backup MBR!!! Error code: %d",status );
            return 2;
        }else{
            clrprintf(GREEN," [S] MBR was backed up successfully.");
        }
    }
    //End of backing up MBR
    //Back up GPT
    if (ptable == PTABLE_GPT) {
        //code goes here!
        status = bkgpt();
        if ( status != 0 ) {
            clrprintf(RED,"[E]");
            printf ( " Failed to backup GPT!!! Error code: %d",status );
            return 2;
    }
}
    if ( (bkldr (loader)) != 0 ) {
        return 2;
    }
    return 0;
}

int bkmbr()
{
TCHAR szDevice[MAX_PATH] = _T("\\\\.\\PhysicalDrive0");//MBR is on sda0
HANDLE hDevice = NULL;
hDevice = CreateFile(szDevice,GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL); 
if (hDevice == INVALID_HANDLE_VALUE) // cannot open the drive,usually caused by permissions(UAC)
{
   printf("ERROR! Cannot access the drive!");  //Man! Rerun this program with Admin privilege!!!Don't forget to turn off your anti-virus!!!
   return 2;
}
BYTE mbr[0x200] = {0};
DWORD dwBeRead = 0;
BOOL bRet = ReadFile(hDevice, &mbr, 0x200, &dwBeRead, NULL);
if(bRet && dwBeRead)
{
  FILE *fp = fopen(MBRBKFILE, "wb+");//Write to file
  if(fp)
  {
  int iBeWrite = fwrite(&mbr, sizeof(BYTE), 0x200, fp);
  fclose(fp);
  printf("MBR data was saved to %s",MBRBKFILE);//Complete!!!And you'll find the file ended with "55 AA"(In hex).If not, that's means backup process failed.
 }
}
else
{
 DWORD err = GetLastError();
 return err;
}
CloseHandle(hDevice);
return 0;
}

int bkgpt() {
    //code goes here
    int errcode;
    clrprintf (CYAN,"[I]");
    printf (" Mounting ESP partition...");
    errcode = system ("mountvol W:\\ /s");
    if ( errcode != 0) {
        clrprintf(RED,"Failed! \n");
        clrprintf (RED,"[E]");
        puts ( " Failed to mount ESP partition!" );
        return errcode;
    }else{
        clrprintf(GREEN,"Done!");
    }
    errcode = (system ("copy /B W:\\EFI\\Boot\\bootx64.efi %systemdrive%\\ast_bkup\\"));
    if ( errcode!= 0) {
        clrprintf (RED,"[E]");
        puts ( " Failed to backup EFI file!" );
        return errcode;
    }
    errcode = system ("mountvol W:\\ /d");
    if ( errcode != 0) {
        clrprintf (RED,"[E]");
        puts ( " Failed to unmount ESP partition!" );
        return errcode;
    }
    clrprintf (GREEN,"[S]");
    puts ( " EFI file has been backed up!" );
    return 0;
}

int bkldr( int loader ) {
    switch ( loader ) 
    {
        case LOADER_BCD:
        {
        clrprintf (CYAN,"[I]");
        puts ( " Backing up BCD..." );
            if ( (system ( "bcdedit /export %systemdrive%\\ast_bkup\\BCDbckup" ) ) != 0 ) {
            clrprintf (RED,"[E]");
            puts ( " Failed to backup bootloader!" );
            return 2;
            }else{ 
            clrprintf (GREEN,"[S]");
            puts ( " bootloader has been backed up!" );
            return 0;
            }
        break;
        }
        case LOADER_NTLDR:
        {
        clrprintf (CYAN,"[I]");
        puts ( " Backing up NTLDR..." );
        if ( (system ( "attrib -s -h -r %systemdrive%\\boot.ini && copy %systemdrive%\\boot.ini %systemdrive%\\ast_bkup\\ && attrib +s +h +r %systemdrive%\\boot.ini" ) ) != 0 ) {
            clrprintf (RED,"[E]");
            puts ( " Failed to backup bootloader!" );
            return 2;
            }else{ 
            clrprintf (GREEN,"[S]");
            puts ( " bootloader has been backed up!" );
            return 0;
            }
        
        }
        default:
        {
        clrprintf (YELLOW,"[!] An internal error was encountered! \n  Please report it to us.");
        return 3;
        }
    } 
    return 0;
}