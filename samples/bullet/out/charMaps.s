.globl asteroid_sprite
asteroid_sprite:
	.word	0x0008	;*8 bytes per strip
	.word	0x0002, 0x0002	;*2 strips of 2 tiles
	.long	asteroid_sprite_Palettes
	.long	asteroid_sprite_Map, asteroid_sprite_Map, asteroid_sprite_Map, asteroid_sprite_Map
asteroid_sprite_Map:
	.word	0x0100,0x0000, 0x0102,0x0000
	.word	0x0101,0x0000, 0x0103,0x0000


.globl player_img
player_img:
	.word	0x0005, 0x0003	;*5 frames, 3 max width
	.long	player_img_Palettes
	.long	player_img_animations	;*ptr to anim data
player_img_0000:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_img_0000_Map, player_img_0000_Map, player_img_0000_Map, player_img_0000_Map	;*ptrs maps data of frame 0
player_img_0001:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_img_0001_Map, player_img_0001_Map, player_img_0001_Map, player_img_0001_Map	;*ptrs maps data of frame 1
player_img_0002:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_img_0002_Map, player_img_0002_Map, player_img_0002_Map, player_img_0002_Map	;*ptrs maps data of frame 2
player_img_0003:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_img_0003_Map, player_img_0003_Map, player_img_0003_Map, player_img_0003_Map	;*ptrs maps data of frame 3
player_img_0004:
	.word	0x0003, 0x0001, 0x0004	;*3 cols of 1 tiles, 4 bytes per strip
	.long	player_img_0004_Map, player_img_0004_Map, player_img_0004_Map, player_img_0004_Map	;*ptrs maps data of frame 4
player_img_0000_Map:
	.word	0x0108,0x0000
	.word	0x0109,0x0000
	.word	0x010a,0x0000
player_img_0001_Map:
	.word	0x010b,0x0000
	.word	0x0109,0x0000
	.word	0x010a,0x0000
player_img_0002_Map:
	.word	0x010c,0x0000
	.word	0x0109,0x0000
	.word	0x010a,0x0000
player_img_0003_Map:
	.word	0x0104,0x0000
	.word	0x0105,0x0000
	.word	0x0106,0x0000
player_img_0004_Map:
	.word	0x010d,0x0000
	.word	0x010e,0x0000
	.word	0x010f,0x0000

.include "assets/gfx/player_img/player_img_anims.s"

.globl bullet_img
bullet_img:
	.word	0x0003, 0x0002	;*3 frames, 2 max width
	.long	bullet_img_Palettes
	.long	bullet_img_animations	;*ptr to anim data
bullet_img_0000:
	.word	0x0002, 0x0001, 0x0004	;*2 cols of 1 tiles, 4 bytes per strip
	.long	bullet_img_0000_Map, bullet_img_0000_Map, bullet_img_0000_Map, bullet_img_0000_Map	;*ptrs maps data of frame 0
bullet_img_0001:
	.word	0x0002, 0x0001, 0x0004	;*2 cols of 1 tiles, 4 bytes per strip
	.long	bullet_img_0001_Map, bullet_img_0001_Map, bullet_img_0001_Map, bullet_img_0001_Map	;*ptrs maps data of frame 1
bullet_img_0002:
	.word	0x0002, 0x0001, 0x0004	;*2 cols of 1 tiles, 4 bytes per strip
	.long	bullet_img_0002_Map, bullet_img_0002_Map, bullet_img_0002_Map, bullet_img_0002_Map	;*ptrs maps data of frame 2
bullet_img_0000_Map:
	.word	0x0110,0x0000
	.word	0x0111,0x0000
bullet_img_0001_Map:
	.word	0x0110,0x0000
	.word	0x0111,0x0000
bullet_img_0002_Map:
	.word	0x0110,0x0000
	.word	0x0111,0x0000

.include "assets/gfx/bullet_img/bullet_img_anims.s"
