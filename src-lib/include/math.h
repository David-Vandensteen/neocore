/* # $Id: math.h,v 1.5 2001/07/13 14:02:57 fma Exp $ */

#ifndef __MATH_H__
#define __MATH_H__

#ifdef __cplusplus
	extern "C" {
#endif

//-- Type Definitions ---------------------------------------------------------
typedef int FIXED;

//-- Imported Variables -------------------------------------------------------
extern const FIXED _cos_tbl[512];
extern const FIXED _tan_tbl[256];

//-- Inline Functions ---------------------------------------------------------
extern FIXED inline itofix(int x)
{ 
   return x << 16;
}
//------------------------------------------------------------------------------
extern int inline fixtoi(FIXED x)
{ 
   return (x >> 16) + ((x & 0x8000) >> 15);
}
//------------------------------------------------------------------------------
extern FIXED inline ftofix(double x)
{ 
	if (x > 32767.0)
	{
		return 0x7FFFFFFF;
	}

	if (x < -32767.0)
	{
		return -0x7FFFFFFF;
	}

	return (long)(x * 65536.0 + (x < 0 ? -0.5 : 0.5)); 
}
//------------------------------------------------------------------------------
extern double inline fixtof(FIXED x)
{ 
	return (double)x / 65536.0; 
}
//------------------------------------------------------------------------------
extern FIXED inline fcos(int x)
{
	return _cos_tbl[x & 0x1FF];
}
//------------------------------------------------------------------------------
extern FIXED inline fsin(int x)
{ 
	return _cos_tbl[(x - 0x80) & 0x1FF];
}
//------------------------------------------------------------------------------
extern FIXED inline ftan(int x)
{ 
	return _tan_tbl[x & 0xFF];
}
//------------------------------------------------------------------------------
extern FIXED inline fadd(FIXED x, FIXED y)
{
	FIXED result = x + y;

	if (result >= 0)
	{
		if ((x < 0) && (y < 0))
		{
			return -0x7FFFFFFF;
		}
	
		return result;
	}
	else
	{
		if ((x > 0) && (y > 0))
		{
			return 0x7FFFFFFF;
		}

		return result;
	}
}
//------------------------------------------------------------------------------
extern FIXED inline fsub(FIXED x, FIXED y)
{
	FIXED	result = x - y;

	if (result >= 0)
	{
		if ((x < 0) && (y > 0))
		{
			return -0x7FFFFFFF;
		}

		return result;
	}
	else
	{
		if ((x > 0) && (y < 0))
		{
			return 0x7FFFFFFF;
		}

		return result;
	}
}

//-- Exported Functions -------------------------------------------------------
extern FIXED fmul(FIXED a, FIXED b);
extern FIXED fmuli(FIXED a, WORD b);
extern DWORD ifmuli(FIXED a, WORD b);

#ifdef __cplusplus
	}
#endif

#endif // __MATH_H__
