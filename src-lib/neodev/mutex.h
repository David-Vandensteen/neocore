/* $Id: mutex.h,v 1.5 2001/07/18 14:45:57 fma Exp $ */

#ifndef __MUTEX_H__
#define __MUTEX_H__

//-- Includes -----------------------------------------------------------------
#include <task.h>

#ifdef __cplusplus
	extern "C" {
#endif

//-- Defines ------------------------------------------------------------------

// Maximum number of mutexes
#ifndef MAX_MUTEX
#define MAX_MUTEX	16
#endif

//-- Type Definitions ---------------------------------------------------------
typedef unsigned int MUTEX;
typedef unsigned int *PMUTEX;

//-- Exported Functions -------------------------------------------------------

// Create a mutex
extern PMUTEX	mutex_create(void);

// Destroy a mutex
extern void		mutex_destroy(PMUTEX mutex);

// Take a mutex
extern void		mutex_take(PMUTEX mutex);

// Release mutex
extern void		mutex_release(PMUTEX mutex);

// Release all mutexes owned by a task
extern void		mutex_clean(PTASK task);

#ifdef __cplusplus
	}
#endif

#endif // __MUTEX_H__
