/* $Id: stdtypes.h,v 1.3 2001/07/26 14:42:56 fma Exp $ */

#ifndef __STDTYPES_H__
#define __STDTYPES_H__

//-- Defines ------------------------------------------------------------------
#define __NEOGEO__

#define NULL	0

#define TRUE	1
#define FALSE	0

#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

#define __PACKED__		__attribute__ ((packed))
#define __ALIGN16__		__attribute__ ((aligned (16)))
#define __ALIGN32__		__attribute__ ((aligned (32)))
#define __NORETURN__	__attribute__ ((noreturn))
#define __CONSTRUCTOR__	__attribute__ ((constructor))
#define __DESTRUCTOR__	__attribute__ ((destructor))

//-- Type Definitions ---------------------------------------------------------
typedef unsigned char		BYTE, *PBYTE;
typedef unsigned short		WORD, *PWORD;
typedef unsigned int		DWORD, *PDWORD;
typedef unsigned long long	UQUAD, *PUQUAD;
typedef long long			INT64;
typedef unsigned int		BOOL, *PBOOL;

typedef unsigned int		size_t;

#endif	// __STDTYPES_H__
