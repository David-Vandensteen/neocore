bullet_img_animations:
bullet_img_anim_IDLE:
	.word	0x0003, 0x0000	|; 3 steps, 0 repeats
	.long	bullet_img_anim_IDLE_steps, 0x00000000	|; steplist, link

bullet_img_anim_IDLE_steps:
	.long	bullet_img_0000	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration
	.long	bullet_img_0001	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration
	.long	bullet_img_0002	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration

