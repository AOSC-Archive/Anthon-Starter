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

# include <stdio.h>
# include <stdlib.h>

# include "funcs.h"
# include "defs.h"

int run ( char *osimage, char *ostarget,
          img *imginfo, int instform, int verbose_mode, int quiet_mode,
          int will_pause, int will_reboot, int will_verify, int will_extract )
{
    /* Set variables */
    int loader = LOADER_UNKNOWN, ptable = PTABLE_UNKNOWN;
    /* End of setting variables */
    
    /* Initialize the program: checking if resource files work.
     * NOTICE: init() will invoke exit(1) if it detected something wrong.
     */
    init ();
    
    /* Get the info of the system, including system drive, memory, CPU architecture, etc. */
    getsysinfo ( loader, ptable );
    
    /* Before doing anything, backup the important files.
     * Variables are set in getsysinfo().
     */
    backup ( loader, ptable );
    
    /* Extract files from ISO image. */
    extract ( will_extract, osimage, ostarget );
    
    /* Verify the files */
    verify ( will_verify, ostarget );
    
    /* Deploy boot loader.
     * This is a danger operation, so must be careful.
     */
    deploy ( loader, ptable );
    
    /* It seems has finished ^o^ */
    puts ( "Operation finished ^o^" );
    return 0;
}