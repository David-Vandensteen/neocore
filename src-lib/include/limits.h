/* # $Id: limits.h,v 1.2 2001/05/28 14:27:58 fma Exp $ */

#ifndef _LIMITS_H_
#define _LIMITS_H_

// Number of bits in a `char'.
#undef CHAR_BIT
#define CHAR_BIT 8

// Maximum length of a multibyte character.
#ifndef MB_LEN_MAX
#define MB_LEN_MAX 1
#endif

// Minimum and maximum values a `signed char' can hold.
#undef SCHAR_MIN
#define SCHAR_MIN (-128)
#undef SCHAR_MAX
#define SCHAR_MAX 127

// Maximum value an `unsigned char' can hold.  (Minimum is 0).
#undef UCHAR_MAX
#define UCHAR_MAX 255

// Minimum and maximum values a `char' can hold.
#ifdef __CHAR_UNSIGNED__
#undef CHAR_MIN
#define CHAR_MIN 0
#undef CHAR_MAX
#define CHAR_MAX 255
#else
#undef CHAR_MIN
#define CHAR_MIN (-128)
#undef CHAR_MAX
#define CHAR_MAX 127
#endif

// Minimum and maximum values a `signed short int' can hold.
#undef SHRT_MIN
#define SHRT_MIN (-32768)
#undef SHRT_MAX
#define SHRT_MAX 32767

//Maximum value an `unsigned short int' can hold.  (Minimum is 0).
#undef USHRT_MAX
#define USHRT_MAX 65535

// Minimum and maximum values a `signed int' can hold.
#undef INT_MAX
#define INT_MAX 2147483647
#undef INT_MIN
#define INT_MIN (-INT_MAX-1)

// Maximum value an `unsigned int' can hold.  (Minimum is 0).
#undef UINT_MAX
#define UINT_MAX (INT_MAX * 2U + 1)

// Minimum and maximum values a `signed long int' can hold.
   (Same as `int').  */
#undef LONG_MAX
#define LONG_MAX 2147483647
#undef LONG_MIN
#define LONG_MIN (-LONG_MAX-1)

// Maximum value an `unsigned long int' can hold.  (Minimum is 0).
#undef ULONG_MAX
#define ULONG_MAX (LONG_MAX * 2UL + 1)

// Minimum and maximum values a `signed long long int' can hold.
#undef LONG_LONG_MAX
#define LONG_LONG_MAX 9223372036854775807LL
#undef LONG_LONG_MIN
#define LONG_LONG_MIN (-LONG_LONG_MAX-1)

// Maximum value an `unsigned long long int' can hold.  (Minimum is 0).
#undef ULONG_LONG_MAX
#define ULONG_LONG_MAX (LONG_LONG_MAX * 2ULL + 1)

#endif // _LIMITS_H_
