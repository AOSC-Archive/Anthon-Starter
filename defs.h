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

/* Yes or no */
# define NO 0
# define YES 1

/* Partition table */
# define PTABLE_UNKNOWN 4
# define PTABLE_MBR 5
# define PTABLE_GPT 6

/* Boot loader (OS) type */
# define LOADER_UNKNOWN 7
# define LOADER_NTLDR 8
# define LOADER_BCD 9

/* Installation formula */
# define EDIT_PRESENT 10
# define EDIT_MBR 11
# define EDIT_ESP 12
# define EDIT_DONOT 13

/* */
# define NO_VERIFY 15
# define NO_EXTRACT 16

/* Identification numbers for different distributions */
# define ANOS 25
# define ANCP 26
# define ICNL 27
# define SPIN 28
# define UNKN 29
