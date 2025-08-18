/* # $Id: stdlib.h,v 1.6 2001/07/27 08:00:43 fma Exp $ */

#ifndef __STDLIB_H__
#define __STDLIB_H__

//-- Includes -----------------------------------------------------------------
#include <stdtypes.h>

#ifdef __cplusplus
	extern "C" {
#endif

//-- Exported Functions -------------------------------------------------------
extern void*	memcpy(void *dest, const void *src, size_t count);
extern void*	memmove(void *dest, const void *src, size_t count);
extern void*	memset(void *dest, int ch, size_t count);
extern int 		memcmp(const void * cs,const void * ct,size_t count);

extern char*	strcpy(char * dest,const char *src);
extern char*	strncpy(char * dest,const char *src,size_t count);
extern char*	strcat(char * dest, const char * src);
extern char*	strncat(char *dest, const char *src, size_t count);
extern int		strcmp(const char * cs,const char * ct);
extern int		strncmp(const char * cs,const char * ct,size_t count);
extern char*	strchr(const char * s, int c);
extern char*	strrchr(const char * s, int c);
extern size_t	strlen(const char * s);
extern size_t	strnlen(const char * s, size_t count);
extern size_t	strspn(const char *s, const char *accept);
extern char*	strpbrk(const char * cs,const char * ct);
extern char*	strtok(char * s,const char * ct);
extern char*	strstr(const char * s1,const char * s2);

extern void		srand(DWORD seed);
extern DWORD	rand(void);

#ifdef __cd__
extern void*	malloc(size_t size);
extern void		free(void *ptr);
extern void*	calloc(size_t nitems, size_t size);
extern void*	realloc(void *ptr, size_t size);
extern void*  	memalign(size_t align, size_t bytes);
#endif

#ifdef __cplusplus
	}
#endif

#endif // __STDLIB_H__
