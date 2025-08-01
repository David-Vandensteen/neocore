.globl asteroid_sprite
asteroid_sprite:
	.word	0x0008	;*8 bytes per strip
	.word	0x0002, 0x0002	;*2 strips of 2 tiles
	.long	asteroid_sprite_Palettes
	.long	asteroid_sprite_Map, asteroid_sprite_Map_FlipX, asteroid_sprite_Map_FlipY, asteroid_sprite_Map_FlipXY
asteroid_sprite_Map:
	.word	0x0100,0x0000, 0x0102,0x0000
	.word	0x0101,0x0000, 0x0103,0x0000
asteroid_sprite_Map_FlipX:
	.word	0x0101,0x0001, 0x0103,0x0001
	.word	0x0100,0x0001, 0x0102,0x0001
asteroid_sprite_Map_FlipY:
	.word	0x0102,0x0002, 0x0100,0x0002
	.word	0x0103,0x0002, 0x0101,0x0002
asteroid_sprite_Map_FlipXY:
	.word	0x0103,0x0003, 0x0101,0x0003
	.word	0x0102,0x0003, 0x0100,0x0003


.globl player_sprite
player_sprite:
	.word	0x0005, 0x0003	;*5 frames, 3 max width
	.long	player_sprite_Palettes
	.long	player_sprite_animations	;*ptr to anim data
player_sprite_0000:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_sprite_0000_Map, player_sprite_0000_Map, player_sprite_0000_Map, player_sprite_0000_Map	;*ptrs maps data of frame 0
player_sprite_0001:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_sprite_0001_Map, player_sprite_0001_Map, player_sprite_0001_Map, player_sprite_0001_Map	;*ptrs maps data of frame 1
player_sprite_0002:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_sprite_0002_Map, player_sprite_0002_Map, player_sprite_0002_Map, player_sprite_0002_Map	;*ptrs maps data of frame 2
player_sprite_0003:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_sprite_0003_Map, player_sprite_0003_Map, player_sprite_0003_Map, player_sprite_0003_Map	;*ptrs maps data of frame 3
player_sprite_0004:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_sprite_0004_Map, player_sprite_0004_Map, player_sprite_0004_Map, player_sprite_0004_Map	;*ptrs maps data of frame 4
player_sprite_0000_Map:
	.word	0x0108,0x0000
	.word	0x0109,0x0000
	.word	0x010a,0x0000
player_sprite_0001_Map:
	.word	0x010b,0x0000
	.word	0x0109,0x0000
	.word	0x010a,0x0000
player_sprite_0002_Map:
	.word	0x010c,0x0000
	.word	0x0109,0x0000
	.word	0x010a,0x0000
player_sprite_0003_Map:
	.word	0x0104,0x0000
	.word	0x0105,0x0000
	.word	0x0106,0x0000
player_sprite_0004_Map:
	.word	0x010d,0x0000
	.word	0x010e,0x0000
	.word	0x010f,0x0000

.include "assets/gfx/player_sprite/player_sprite_anims.s"
