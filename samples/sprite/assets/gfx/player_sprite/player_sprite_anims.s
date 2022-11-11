player_sprite_animations:
player_sprite_anim_IDLE:
	.word	0x0004, 0x0000	|; 4 steps, 0 repeats
	.long	player_sprite_anim_IDLE_steps, player_sprite_anim_IDLE	|; steplist, link
player_sprite_anim_UP:
	.word	0x0001, 0x0000	|; 1 steps, 0 repeats
	.long	player_sprite_anim_UP_steps, 0x00000000	|; steplist, link
player_sprite_anim_DOWN:
	.word	0x0001, 0x0000	|; 1 steps, 0 repeats
	.long	player_sprite_anim_DOWN_steps, 0x00000000	|; steplist, link

player_sprite_anim_IDLE_steps:
	.long	player_sprite_0000	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration
	.long	player_sprite_0001	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration
	.long	player_sprite_0002	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration
	.long	player_sprite_0001	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration
player_sprite_anim_UP_steps:
	.long	player_sprite_0003	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration
player_sprite_anim_DOWN_steps:
	.long	player_sprite_0004	|;frame ptr
	.word	0x0000, 0x0000, 0x0005	|;shiftX, shiftY, duration

