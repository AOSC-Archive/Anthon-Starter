// Test code: Read MBR and then write it into a file. 
#define MBRBKFILE "C:\\mbrdata.bin" //where to store backupfile
#include <windows.h> //OK, WINAPI again...:-)
#include <tchar.h>
#include <stdio.h>
int main(int argc, char* argv[])
{
TCHAR szDevice[MAX_PATH] = _T("\\\\.\\PhysicalDrive0");//MBR is on sda0
HANDLE hDevice = NULL;
hDevice = CreateFile(szDevice,
  GENERIC_READ, 
  FILE_SHARE_READ | FILE_SHARE_WRITE,
  NULL,
  OPEN_EXISTING,
  0,
  NULL); 
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
}
CloseHandle(hDevice);
return 0;
}
