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

# include <windows.h>
# include "funcs.h"
# include "defs.h"


int init ( void )
{
    printf ( "( 1 of 6 ) Initializing...  " );
	
	getSystemDrive();
	getAllSytemDrives();
	
	//TODO:get loader version NT5/NT6
	clrprint ( "Done.\n", 10 );
    return 0;
}

void getSystemDrive(void)
{
	TCHAR systemDirectory[MAX_PATH];
	GetSystemDirectory(systemDirectory, MAX_PATH);
	
	printf("SystemDirectory:\t%s\n", systemDirectory);
    
	return 0;
}

void getAllSytemDrives(void)
{
	TCHAR szBuf[100];  
    memset(szBuf,0,100);  
  
    GetLogicalDriveStrings(sizeof(szBuf)/sizeof(TCHAR),szBuf);  
	
	printf("System Drives: ");
	
	TCHAR * s;
    for (s= szBuf;  *s;  s+=strlen(s)+1){  
        LPCTSTR sDrivePath = s;  
        printf("\t%s", sDrivePath);  
    }  
	printf("\n");
	
	return 0;
}

  