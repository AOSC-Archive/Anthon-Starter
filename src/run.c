/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014-2015 Anthon Open Source Community
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

# include "ast.h"

int run ( char *osimage, char *ostarget,
          img *imginfo, int instform, int verbose_mode, int quiet_mode,
          int will_pause, int will_reboot, int will_verify, int will_extract )
{
    /* Set variables */
    int loader = LOADER_UNKNOWN, ptable = PTABLE_UNKNOWN;
    char *systemdrive = malloc ( 4 );
    /* End of setting variables */
    
    /* Initialize the program: checking if resource files work.
     * NOTICE: init() will invoke exit(1) if it detected something wrong.
     */
    init ( imginfo, osimage, ostarget );
    
    /* Get the info of the system, including system drive, memory, CPU architecture, etc. */
    getsysinfo ( &loader, &ptable, systemdrive, ostarget );
    
    /* Before doing anything, backup the important files.
     * Variables are set in getsysinfo().
     */
    backup ( systemdrive, loader, ptable );
    
    /* Extract files from ISO image. */
    if ( will_extract )
        extract ( will_extract, osimage, ostarget );
    else /* --no-extract */
        notify ( WARN, "Will not extract the files." );
    
    /* Verify the files */
    if ( will_verify )
        verify ( will_verify, ostarget );
    else /* --no-verify */
    {
        if ( will_extract )
            notify ( WARN, "Will not verify the files." );
        else /* --no-extract --no-verify */
            notify ( WARN, "Files are not extracted, skip verifying." );
    }
    
    /* Deploy boot loader.
     * This is a danger operation, so must be careful.
     */
    deploy ( loader, ptable );
    
    /* will_* */
    if ( will_pause )
    {
        if ( will_reboot ) /* --pause --reboot */
        {
            notify ( SUCC, "Operation finished ^o^\n    Press any key to reboot..." );
            /* NOTICE: --quiet will disable this pause. */
            if ( quiet_mode == 0 )
                system ( "pause > nul" ); /* FIXME */
            /* system ( "shutdown -r -t 00" ); */
        }
        else /* --pause */
        {
            notify ( SUCC, "Operation finished ^o^\n    Press any key to exit..." );
            if ( quiet_mode == 0 )
                system ( "pause > nul" ); /* FIXME */
        }
    }
    else
    {
        if ( will_reboot ) /* --reboot */
        {
            notify ( SUCC, "Operation finished ^o^\n    Now rebooting the system..." );
            /* system ( "shutdown -r -t 00" ); */
        }
        else
        {
            notify ( SUCC, "Operation finished ^o^" );
        }
    }
    
    take ( systemdrive );
    return 0;
}
