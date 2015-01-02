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
# include "config.h"
#ifndef PACKAGE_VERSION
#define PACKAGE_VERSION "unknown"
#endif
int info ()
{
  printf ("Copyright (C) 2014-2015 Anthon Open Source Community \n");
    printf ("Anthon-Starter %s \n\n",PACKAGE_VERSION);
    //printf ("Compiled with %s on %s, targetting %s. \n",%compiler%,%builder%,%host%);
     printf ("This program is free software: you can redistribute it and/or modify \n\
     it under the terms of the GNU General Public License as published by \n\
     the Free Software Foundation, either version 2 of the License, or \n\
     (at your option) any later version.\n");
  return 0;
}
