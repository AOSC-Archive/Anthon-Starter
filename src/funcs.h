/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2012-2015 Anthon Open Source Community
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

/* int main ( int argc, char **argv ); */

/*
 * chkargs: Check the arguments which is passed to Anthon-Starter.
 */
int chkargs ( int argc, char **argv,
              char **p_osimg_tgt, /* Including "osimage" and "ostarget" */
              img *imginfo, int *instform, int *verbose_mode, int *quiet_mode,
              int *will_pause, int *will_reboot, int *will_verify, int *will_extract );

/*
 * run: Including
 *        - init
 *        - getsysinfo
 *        - backup
 *        - extract
 *        - verify
 *        - deploy
 *        - before_reboot
 *      That means, it invokes the functions that run.
 */
int run ( char *osimage, char *ostarget,
          img *imginfo, int instform, int verbose_mode, int quiet_mode,
          int will_pause, int will_reboot, int will_verify, int will_extract );

/*
 * init: Initialize Anthon-Starter.
 */
int init ( img *imginfo, char *osimage, char *ostarget );

/*
 * getsysinfo: Get the system info, such as system drive, CPU architecture, etc.
 */
int getsysinfo ( int *loader, int *ptable, char *systemdrive, char *ostarget );

/*
 * backup: Backup the important files before we do everything.
 */
int backup ( char *systemdrive, int loader, int ptable );

/*
 * extract: Extract necessary files to the specified destination, usually from the passed arguments.
 */
int extract ( int will_extract, char *systemdrive, char *osimage, char *ostarget );

/*
 * verify: Verify the files that was extracted just now to ensure validity.
 */
int verify ( int will_verify, char *ostarget );

/*
 * deploy: Deploy the boot loader.
 */
int deploy ( int loader, int ptable );

/*
 * help_message: Show help messages.
 */
int help_message ( char *progname );

/*
 * startup: For startup use.
 */
int startup ();

/*
 * fclrprintf: Output colourful texts to stream, only for Windows.
 */
void fclrprintf ( FILE *stream, WORD color, char* format, ... );

/*
 * clrprintf: Output colourful texts to stdout, a macro of fclrprintf
 */
# define clrprintf(color,fmt,...) fclrprintf(stdout,color,fmt,##__VA_ARGS__)

/*
 * notify: Using clrprintf() and vprintf() to output messages easily.
 */
void notify ( int TNotice, char *format, ... );

/*
 * take: To take specify pointer's memory easily.
 */
// int take ( void *ptr );
//# define take(ptr) if(ptr!=NULL){free(ptr);ptr=NULL;}

/*
 * oops: Proceed with signals
 */
void oops ( int signo );

/*
 * md5sum: To verify specify file's md5 sum.
 */
int md5sum ( char *rtn, char *file );

/*
 * duplicate: Make a duplicate from src to dest
 */
int duplicate ( const char *src, char *dest );

