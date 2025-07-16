/* # $Id: stdio.h,v 1.4 2001/07/13 14:02:57 fma Exp $ */

#ifndef __STDIO_H__
#define __STDIO_H__

//-- Includes -----------------------------------------------------------------
#include <stdtypes.h>
#include <stdarg.h>

#ifdef __cplusplus
	extern "C" {
#endif

//-- Exported Functions -------------------------------------------------------
extern int vsprintf(char *buf, const char *fmt, va_list args);
extern int sprintf(char * buf, const char *fmt, ...);

#ifdef __cplusplus
	}
#endif

#endif // __STDIO_H__
