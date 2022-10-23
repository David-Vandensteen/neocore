bmary_spr_animations:
bmary_spr_anim_IDLE:
	.word	0x000c, 0x0000	|; 12 steps, 0 repeats
	.long	bmary_spr_anim_IDLE_steps, bmary_spr_anim_IDLE	|; steplist, link
bmary_spr_anim_WALK:
	.word	0x0008, 0x0000	|; 8 steps, 0 repeats
	.long	bmary_spr_anim_WALK_steps, bmary_spr_anim_WALK	|; steplist, link

bmary_spr_anim_IDLE_steps:
	.long	bmary_spr_0000	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0001	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0002	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0003	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0004	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0005	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0006	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0007	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0008	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_0009	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_000a	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
	.long	bmary_spr_000b	|;frame ptr
	.word	0xffe7, 0xff94, 0x0006	|;shiftX, shiftY, duration
bmary_spr_anim_WALK_steps:
	.long	bmary_spr_000c	|;frame ptr
	.word	0xffe0, 0xff91, 0x0005	|;shiftX, shiftY, duration
	.long	bmary_spr_000d	|;frame ptr
	.word	0xffe0, 0xff91, 0x0005	|;shiftX, shiftY, duration
	.long	bmary_spr_000e	|;frame ptr
	.word	0xffe0, 0xff91, 0x0005	|;shiftX, shiftY, duration
	.long	bmary_spr_000f	|;frame ptr
	.word	0xffe0, 0xff91, 0x0005	|;shiftX, shiftY, duration
	.long	bmary_spr_0010	|;frame ptr
	.word	0xffe0, 0xff91, 0x0005	|;shiftX, shiftY, duration
	.long	bmary_spr_0011	|;frame ptr
	.word	0xffe0, 0xff91, 0x0005	|;shiftX, shiftY, duration
	.long	bmary_spr_0012	|;frame ptr
	.word	0xffe0, 0xff91, 0x0005	|;shiftX, shiftY, duration
	.long	bmary_spr_0013	|;frame ptr
	.word	0xffe0, 0xff91, 0x0005	|;shiftX, shiftY, duration

