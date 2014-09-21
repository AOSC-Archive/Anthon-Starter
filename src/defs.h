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

/* Partition table */
# define PTABLE_UNKNOWN 7
# define PTABLE_MBR 1
# define PTABLE_GPT 2

/* Boot loader (OS) type */
# define LOADER_UNKNOWN 7
# define LOADER_NTLDR 1
# define LOADER_BCD 2

/* Installation formula */
# define EDIT_PRESENT 1
# define EDIT_MBR 2
# define EDIT_ESP 3
# define EDIT_DONOT 5

/* */
# define NO_VERIFY 1
# define NO_EXTRACT 1

# define CMD_BUF 512
# define MD5SUM_LENGTH 33
