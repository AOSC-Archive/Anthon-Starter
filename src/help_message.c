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

# include "ast.h"

int help_message ( char *progname ) /* "progname" is argv[0] */
{
    printf (
"Usage: %s <Command> [<Switches>...]\n\
\n\
<Commands>\n\
  install            Install the specified AOSC OS Live environment\
                       to your computer\n\
  help               Show this help\n\
  startup            Active startup (to clean up trashes)\n\
\n\
<Switches>\n\
  --live=, -l        Set the location of ISO image\n\
  --form=, -f        Set the installation method of boot loader\n\
                       Available parameters:\n\
                         edit: Edit the present NT loader (default)\n\
                         mbr: Edit the MBR\n\
                         gpt: Edit the ESP\n\
                         nodeploy: DO NOT deploy boot loader\n\
  --pause, -p        Automatically pause after operation\n\
  --reboot, -r       Automatically reboot the system\n\
  --no-verify        DO NOT verify the files (Not recommend)\n\
  --no-extract       DO NOT extract the files (Not recommend)\n\
  --help, -h         Show help messages\n\
\n\
Report bugs to https://bugs.anthonos.org/\n", progname );
      return 0;
}
