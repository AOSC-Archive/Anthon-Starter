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
  install            Install the specified AOSC OS Live environment\n\
                       to your computer\n\
  help               Show this help\n\
  startup            Active startup (to clean up trashes)\n\
\n\
<Switches>\n\
  --live=, -l        Set the location of ISO image\n\
  --output, -o       Set the location where Live environment file\n\
                       should be put\n\
  --form=, -f        Set the installation method of boot loader\n\
                       Available parameters:\n\
                         edit: Edit the present NT loader (default)\n\
                         mbr: Edit the MBR (Only for machines have MBR)\n\
                         gpt: Edit the ESP (Only for machines have GPT)\n\
                         nodeploy: DO NOT deploy boot loader (not recommend)\n\
  --pause, -p        Automatically pause after operation\n\
  --reboot, -r       Reboot the system after operation\n\
  --no-verify        DO NOT verify the files (not recommend)\n\
  --no-extract       DO NOT extract the files (not recommend)\n\
  --help, -h         Show help messages\n\
\n\
Report bugs to https://bugs.anthonos.org\n\
            or https://github.com/AOSC-Dev/Anthon-Starter/issues\n", progname );
      return 0;
}
