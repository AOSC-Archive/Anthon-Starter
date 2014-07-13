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

/* int main ( int argc, char **argv, char **envp ); */

/*
 * chkargs: Check the arguments which is passed to Anthon-Starter.
 */
int chkargs ( int argc, char **argv );

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
int run ();

/*
 * init: Initialize Anthon-Starter.
 */
int init ();

/*
 * getsysinfo: Get the system info, such as system drive, CPU architecture, etc.
 */
int getsysinfo ( char **envp );

/*
 * backup: Backup the important files before we do everything.
 */
int backup ();

/*
 * extract: Extract necessary files to the specified destination, usually from the passed arguments.
 */
int extract ();

/*
 * verify: Verify the files that was extracted just now to ensure validity.
 */
int verify ();

/*
 * deploy: Deploy the boot loader.
 */
int deploy ();

/*
 * before_reboot: Release startup utility and do something necessary...
 */
int before_reboot ();

/*
 * help_message: Show help messages.
 */
int help_message ( void );

/*
 * startup: For startup use.
 */
int startup ();
