/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014 Anthon Open Source Community
 * This file is a part of Anthon-Starter.
 * 
 * Anthon-Starter is licensed under GNU LGPL: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version.
 * 
 * Anthon-Starter is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Anthon-Starter.
 * If not, see <http://www.gnu.org/licenses/>.
 */

/* int main ( int argc, char **argv ); */

/*
 * chkargs: Check the arguments which is passed to Anthon-Starter.
 */
int chkargs ( int argc, char **argv,
              char *osimage, char *ostarget,
              struct img *imginfo, int instform, int verbose_mode, int quiet_mode,
              int will_pause, int will_reboot, int will_verify, int will_extract );

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
          struct img *imginfo, int instform, int verbose_mode, int quiet_mode,
          int will_pause, int will_reboot, int will_verify, int will_extract );

/*
 * init: Initialize Anthon-Starter.
 */
int init ( void );

/*
 * getsysinfo: Get the system info, such as system drive, CPU architecture, etc.
 */
int getsysinfo ( int loader, int ptable );

/*
 * backup: Backup the important files before we do everything.
 */
int backup ( int loader, int ptable );

/*
 * extract: Extract necessary files to the specified destination, usually from the passed arguments.
 */
int extract ( int will_extract, char *osimage, char *ostarget );

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
int help_message ( void );

/*
 * startup: For startup use.
 */
int startup ();
