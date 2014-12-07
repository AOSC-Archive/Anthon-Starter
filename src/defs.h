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

/* For getopt_long() */
# define NO_VERIFY 15
# define NO_EXTRACT 16

/* Command line buffer */
# define CMD_BUF 512
/* Length of MD5 checksum lines (including NUL) */
# define MD5SUM_LENGTH 33

/* For fclrprintf() */
# define BLACK       0
# define DARK_BLUE   1
# define DARK_GREEN  2
# define DARK_CYAN   3
# define DARK_RED    4
# define DARK_PURPLE 5
# define DARK_YELLOW 6
# define GREY        7
# define DARK_GREY   8
# define BLUE        9
# define GREEN       10
# define CYAN        11
# define RED         12
# define PURPLE      13
# define YELLOW      14
# define WHITE       15

/* For notify() */
# define SUCC 0
# define INFO 1
# define WARN 2
# define FAIL 3
