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

# include <stdio.h>
# include <stdlib.h>
# include <stdarg.h>
# include <string.h>
# include <unistd.h>
# include <getopt.h>
# include <signal.h>
# include <time.h>
# include <conio.h>
# include <windows.h>
# include <tchar.h>

# include "funcs.h"
# include "defs.h"

/* Global variables */
int always_yes,
    verbose_mode,
    quiet_mode;
