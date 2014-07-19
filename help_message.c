/*
 * Anthon-Starter: Installation helper for AOSC OS series, version 0.2.0
 * Copyright (C) 2014 Anthon Open Source Community
 * This file is a part of Anthon-Starter.
 * 
 * Anthon-Starter is licensed under GNU LGPL: you can redistribute it
 * and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 * 
 * Anthon-Starter is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Anthon-Starter. If not, see
 * <http://www.gnu.org/licenses/>.
 */

# include <stdio.h>

# include "funcs.h"

int help_message ( void )
{
    puts (
"\n\
Usage: ast <command> [<switches>...]\n\
\n\
<Commands>\n\
  install            Install the specify AOSC OS to your computer\n\
  help               Show this help\n\
  startup            Active startup status\n\
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
For any more information, please visit https://anthonos.org/\n\
Report bugs to https://bugs.anthonos.org/\n"
         );
      return 0;
}