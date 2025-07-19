bmary_spr_animations:
	.long	bmary_spr_anim_IDLE_steps	;* steplist
	.long	bmary_spr_anim_WALK_steps	;* steplist
	.long	bmary_spr_anim_TEST_steps	;* steplist
	.long	bmary_spr_anim_TEST2_steps	;* steplist

bmary_spr_anim_IDLE_steps:
	.long	bmary_spr_0000	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0001	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0002	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0003	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0004	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0005	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0006	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0007	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0008	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_0009	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_000a	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.long	bmary_spr_000b	;* frame ptr
	.word	0xffe7, 0xff94, 0x0006	;* shiftX, shiftY, duration
	.word	0x0200
	.word	0x0000
	.long	bmary_spr_anim_IDLE_steps
bmary_spr_anim_WALK_steps:
	.long	bmary_spr_000c	;* frame ptr
	.word	0xffe0, 0xff91, 0x0005	;* shiftX, shiftY, duration
	.long	bmary_spr_000d	;* frame ptr
	.word	0xffe0, 0xff91, 0x0005	;* shiftX, shiftY, duration
	.long	bmary_spr_000e	;* frame ptr
	.word	0xffe0, 0xff91, 0x0005	;* shiftX, shiftY, duration
	.long	bmary_spr_000f	;* frame ptr
	.word	0xffe0, 0xff91, 0x0005	;* shiftX, shiftY, duration
	.long	bmary_spr_0010	;* frame ptr
	.word	0xffe0, 0xff91, 0x0005	;* shiftX, shiftY, duration
	.long	bmary_spr_0011	;* frame ptr
	.word	0xffe0, 0xff91, 0x0005	;* shiftX, shiftY, duration
	.long	bmary_spr_0012	;* frame ptr
	.word	0xffe0, 0xff91, 0x0005	;* shiftX, shiftY, duration
	.long	bmary_spr_0013	;* frame ptr
	.word	0xffe0, 0xff91, 0x0005	;* shiftX, shiftY, duration
	.word	0x0200
	.word	0x0001
	.long	bmary_spr_anim_WALK_steps
bmary_spr_anim_TEST_steps:
	.long	bmary_spr_0000	;* frame ptr
	.word	0x0000, 0x0000, 0x003c	;* shiftX, shiftY, duration
	.long	bmary_spr_0001	;* frame ptr
	.word	0x0000, 0x0000, 0x003c	;* shiftX, shiftY, duration
	.long	bmary_spr_0002	;* frame ptr
	.word	0x0000, 0x0000, 0x003c	;* shiftX, shiftY, duration
	.word	0x0300, 0x0002
	.word	0x0003
	.long	bmary_spr_anim_TEST2_steps
bmary_spr_anim_TEST2_steps:
	.long	bmary_spr_0011	;* frame ptr
	.word	0xfff8, 0xfff8, 0x0014	;* shiftX, shiftY, duration
	.long	bmary_spr_0012	;* frame ptr
	.word	0xfff8, 0xfff8, 0x0014	;* shiftX, shiftY, duration
	.long	bmary_spr_0013	;* frame ptr
	.word	0xfff8, 0xfff8, 0x0014	;* shiftX, shiftY, duration
	.word	0x0300, 0x0003
	.word	0x0002
	.long	bmary_spr_anim_TEST_steps

