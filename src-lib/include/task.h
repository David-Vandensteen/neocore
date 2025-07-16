/* $Id: task.h,v 1.8 2001/07/18 14:45:57 fma Exp $ */

#ifndef __TASK_H__
#define __TASK_H__

//-- Include ------------------------------------------------------------------
#include <stdarg.h>
#include <stdtypes.h>

#ifdef __cplusplus
	extern "C" {
#endif

//-- Defines ------------------------------------------------------------------

// Maximum number of tasks
#ifndef MAX_TASKS
#define MAX_TASKS	16
#endif

// Stack size for all tasks
#ifndef STACK_SIZE
#define STACK_SIZE	1024
#endif

// Task states
#define TASK_TERMINATED	0
#define TASK_RUNNING	1
#define TASK_SUSPENDED	2

// Task enumeration criterias

// Enumerate tasks that match tag1
#define TASKENUM_TAG1	1
// Enumerate tasks that match tag2
#define TASKENUM_TAG2	2
// Enumerate tasks that match both tags
#define TASKENUM_BOTH	3
// Enumerate tasks that match the state
#define TASKENUM_STATE	4
// Enumerate that match all attributes
#define TASKENUM_ALL	7
// Enumerate all tasks
#define TASKENUM_NONE	0

// Macro to make 'text' identifiers
#define MAKE_ID(a,b,c,d)     (((a)<<24) | ((b)<<16) | ((c)<<8) | (d))

// Mailbox error codes
#define MAILBOX_OK			0
#define MAILBOX_NO_MESSAGE	1
#define MAILBOX_CANT_POST	2

//-- Type definitions ---------------------------------------------------------

// CPU context structure
typedef struct __PACKED__ {
	DWORD	a7;
	DWORD	pc;
	WORD	sr;
	DWORD	d0;
	DWORD	d1;
	DWORD	d2;
	DWORD	d3;
	DWORD	d4;
	DWORD	d5;
	DWORD	d6;
	DWORD	d7;
	DWORD	a0;
	DWORD	a1;
	DWORD	a2;
	DWORD	a3;
	DWORD	a4;
	DWORD	a5;
	DWORD	a6;
} CPU_CONTEXT, *PCPU_CONTEXT;

// Mailbox structure
typedef struct {
	void	*from;
	DWORD	data1;
	DWORD	data2;
} MAILBOX, *PMAILBOX;

// Task structure
typedef struct _TASK {
	// CPU context of the task
	CPU_CONTEXT		context;
	
	// State of the task (Terminated, running, suspended)
	DWORD			state;

	// Priority (can only be defined when the task is created)
	DWORD			prio;
	
	// User tag for the task (1). Can be used with task_enum.
	DWORD			tag1;
	
	// User tag for the task (2). Can be used with task_enum.
	DWORD			tag2;

	// Task "mailbox" for inter-task communication
	MAILBOX			mailbox;
	
	// Pointer to user shared data structure
	void			*data;

	// Stack reserved for the task
	BYTE			stack[STACK_SIZE];

	// Pointer to next task
	struct _TASK	*next;
} TASK, *PTASK;

typedef BOOL (*TASKENUM_CALLBACK)(PTASK task, void *user_data);

//-- Exported variables -------------------------------------------------------

extern PTASK	_current_task;
extern PTASK	first_task;

//-- Exported functions -------------------------------------------------------

// Task functions
extern PTASK	task_create(void *task_addr, DWORD prio, DWORD tag1,
	DWORD tag2, int nb_args, ...);
extern void		task_suspend(PTASK task);
extern void		task_resume(PTASK task);
extern void		task_kill(PTASK task);
extern void		task_exec(void);
extern void		task_enum(DWORD what, DWORD state, DWORD tag1, DWORD tag2,
	void *user_data, TASKENUM_CALLBACK callback);
extern void		task_sleep(DWORD ntimes);

//-- Imported functions -------------------------------------------------------

// Task -> System context switch
void    _release_timeslice(void);

//-- Inline mailbox functions -------------------------------------------------
extern inline DWORD	post_message(PTASK from, PTASK to, DWORD data1, DWORD data2)
{
	if (to->mailbox.from != NULL)
		return MAILBOX_CANT_POST;
	
	to->mailbox.from = from;
	to->mailbox.data1 = data1;
	to->mailbox.data2 = data2;
	
	return MAILBOX_OK;
}

extern inline void	post_message_wait(PTASK from, PTASK to, DWORD data1,
	DWORD data2)
{
	while(to->mailbox.from)
		_release_timeslice();
	
	to->mailbox.from = from;
	to->mailbox.data1 = data1;
	to->mailbox.data2 = data2;
}

extern inline DWORD	peek_message(PTASK myself, PTASK *from, PDWORD pdata1,
	PDWORD pdata2)
{
	if (!myself->mailbox.from)
		return MAILBOX_NO_MESSAGE;
	
	if (from != NULL)
		*from = myself->mailbox.from;
	
	if (pdata1 != NULL)
		*pdata1 = myself->mailbox.data1;
	
	if (pdata2 != NULL)
		*pdata2 = myself->mailbox.data2;
	
	return MAILBOX_OK;
}

extern inline DWORD	read_message(PTASK myself, PTASK *from, PDWORD pdata1,
	PDWORD pdata2)
{
	if (!myself->mailbox.from)
		return MAILBOX_NO_MESSAGE;
	
	if (from != NULL)
		*from = myself->mailbox.from;
	
	if (pdata1 != NULL)
		*pdata1 = myself->mailbox.data1;
	
	if (pdata2 != NULL)
		*pdata2 = myself->mailbox.data2;

	myself->mailbox.from = NULL;
	
	return MAILBOX_OK;
}

extern inline void	read_message_wait(PTASK myself, PTASK *from, PDWORD pdata1,
	PDWORD pdata2)
{
	while (!myself->mailbox.from)
		_release_timeslice();
	
	if (from != NULL)
		*from = myself->mailbox.from;
	
	if (pdata1 != NULL)
		*pdata1 = myself->mailbox.data1;
	
	if (pdata2 != NULL)
		*pdata2 = myself->mailbox.data2;

	myself->mailbox.from = NULL;
}

#ifdef __cplusplus
	}
#endif

#endif	// __TASK_H__
