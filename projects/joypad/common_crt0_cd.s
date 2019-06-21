	* ++====================================================================++
	* || common_crt0_cd.s - C Run Time Startup Code for Neo Geo CD			||
	* ++--------------------------------------------------------------------++
	* || $Id: common_crt0_cd.s,v 1.5 2001/07/13 14:46:31 fma Exp $			||
	* ++--------------------------------------------------------------------++
	* || This is the startup code needed by programs compiled with GCC		||
	* ++--------------------------------------------------------------------||
	* || BGM: The Cranberries - Saving Grace								||
	* ++====================================================================++

********************** Exported Symbols **********************
	.globl	_start
	.globl	atexit

********************** Imported Symbols **********************
	.globl	__do_global_ctors
	.globl	__do_global_dtors
	.globl	main
	.globl	memset
	.globl	__bss_start	
	.globl	_end
	.globl	_vbl_flag
	.globl	_sbrk_base1
	.globl	_sbrk_base2

********************** Program Start *************************

	.long	0x10F300, 0xC00402, 0xC00408, 0xC0040E
	.long	0xC00414, 0xC00426, 0xC00426, 0xC00426
	.long	0xC0041A, 0xC00420, 0xC00426, 0xC00426
	.long	0xC00426, 0xC00426, 0xC00426, 0xC0042C
	.long	0xC00522, 0xC00528, 0xC0052E, 0xC00534
	.long	0xC0053A, 0xC004F2, 0xC004EC, 0xC004E6
	.long	0xC004E0, IRQ1,     IRQ2,     IRQ3
	.long	DUMMY,	  DUMMY,    DUMMY,    DUMMY
	.long	TRAP00,	  TRAP01,	TRAP02,	  TRAP03
	.long	TRAP04,	  TRAP05,   TRAP06,   TRAP07
	.long   TRAP08,   TRAP09,   TRAP10,   TRAP11
	.long	TRAP12,   TRAP13,   TRAP14,   TRAP15
	.long	0xC00426, 0xC00426, 0xC00426, 0xC00426
	.long	0xC00426, 0xC00426, 0xC00426, 0xC00426
	.long	0xC00426, 0xC00426, 0xC00426, 0xC00426
	.long	0xC00426, 0xC00426, 0xC00426, 0xC00426
	
	.ascii	"NEO-GEO"
	.byte	CDDA_FLAG
	.word	GUID
	.long	0x0
	.long	DEBUG_DIPS
	.word	0x0
	.word	LOGO_START
	.long	_jp_config
	.long	_us_config
	.long	_sp_config

	jmp		ENTRY_POINT1
	jmp		ENTRY_POINT2
	jmp		ENTRY_POINT3
	jmp		ENTRY_POINT4

	.align	4

* Dummy exception routine
_dummy_exc_handler:
	rte

	.align	4

* Dummy sub-routine
_dummy_config_handler:
	rts

	.align	4

* Standard IRQ1 handler
_irq1_handler:
	move.w	#2, 0x3C000C
	rte

	.align	4

* Standard IRQ2 handler
_irq2_handler:
	move.w	#1, _vbl_flag
	tst.b	0x10FD80
	bmi.s	0f
	jmp		0xC00438
	
0:
	movem.l	d0-d7/a0-a6,-(sp)
	move.b	d0, 0x300001
	jsr		0xC0044A
	movem.l	(sp)+, d0-d7/a0-a6
	move.w	#4, 0x3C000C
	rte

	.align	4

* Standard IRQ3 handler
_irq3_handler:
	move.w	#1, 0x3C000C
	rte

	.align	4

* Dummy atexit (does nothing for now)
atexit:
	moveq	#0, d0
	rts

	.align	4

* Entry point of our program
_start:
	* Setup stack pointer and 'system' pointer
	lea		0x10F300, a7
	lea		0x108000, a5

	* Reset watchdog
	move.b	d0, 0x300001
	
	* Flush interrupts
	move.b	#7, 0x3C000C
	
	* Enable manual reset (A+B+C+START or SELECT)
	bclr	#7, 0x10FD80
	
	* Enable interrupts
	move.w	#0x2000, sr
	
	* Stop CDDA
	move.w	#0x0200, d0
	jsr		0xc0056a

	* Initialize base pointers for malloc
	move.l	#0x120000, _sbrk_base2
	move.l	#_end, d0
	add.l	#32, d0
	and.l	#0xFFFFFF0, d0
	move.l	d0, _sbrk_base1
	
	* Initialize BSS section
	move.l	#_end, d0
	sub.l	#__bss_start, d0
	move.l	d0, -(a7)
	clr.l	-(a7)
	pea		__bss_start
	jbsr	memset	

	* Jump to main
	jbsr	main

	* Call global destructors
	jbsr	__do_global_dtors

	* For CD systems, return to CD Player

	jmp		0xC0055E

	.align	4

