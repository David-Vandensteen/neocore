bullet_img_animations:
	.long	bullet_img_anim_IDLE_steps	;* steplist

bullet_img_anim_IDLE_steps:
	.long	bullet_img_0000	;* frame ptr
	.word	0x0000, 0x0000, 0x0005	;* shiftX, shiftY, duration
	.long	bullet_img_0001	;* frame ptr
	.word	0x0000, 0x0000, 0x0005	;* shiftX, shiftY, duration
	.long	bullet_img_0002	;* frame ptr
	.word	0x0000, 0x0000, 0x0005	;* shiftX, shiftY, duration
	.word	0x8000

