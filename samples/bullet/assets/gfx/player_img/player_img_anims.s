player_img_animations:
	.long	player_img_anim_IDLE_steps	;* steplist
	.long	player_img_anim_UP_steps	;* steplist
	.long	player_img_anim_DOWN_steps	;* steplist

player_img_anim_IDLE_steps:
	.long	player_img_0000	;* frame ptr
	.word	0x0000, 0x0000, 0x0005	;* shiftX, shiftY, duration
	.long	player_img_0001	;* frame ptr
	.word	0x0000, 0x0000, 0x0005	;* shiftX, shiftY, duration
	.long	player_img_0002	;* frame ptr
	.word	0x0000, 0x0000, 0x0005	;* shiftX, shiftY, duration
	.word	0x0200
	.word	0x0000
	.long	player_img_anim_IDLE_steps
player_img_anim_UP_steps:
	.long	player_img_0003	;* frame ptr
	.word	0x0000, 0x0000, 0x0005	;* shiftX, shiftY, duration
	.word	0x8000
player_img_anim_DOWN_steps:
	.long	player_img_0004	;* frame ptr
	.word	0x0000, 0x0000, 0x0005	;* shiftX, shiftY, duration
	.word	0x8000

