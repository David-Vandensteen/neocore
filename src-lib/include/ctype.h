/* # $Id: ctype.h,v 1.2 2001/05/31 08:31:54 fma Exp $ */

#ifndef _CTYPE_H_
#define _CTYPE_H_

#define tolower(c)  ( (c)-'A'+'a' )
#define toupper(c)  ( (c)-'a'+'A' )
#define is_digit(c)	((c) >= '0' && (c) <= '9')
#define isdigit(c)	((c) >= '0' && (c) <= '9')
#define isxdigit(c)	(isdigit(c) || ((toupper(c)>='A') && (toupper(c)<='F')))
#define islower(c)  ((c) >= 'a' && (c) <= 'z')
#define isupper(c)  ((c) >= 'A' && (c) <= 'Z')
#define isascii(c)	((unsigned)(c)<=0177)
#define toascii(c)	((c)&0177)

#endif /* _CTYPE_H_ */
