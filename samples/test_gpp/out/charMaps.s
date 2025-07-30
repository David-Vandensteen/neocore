.globl asteroid_asset
asteroid_asset:
	.word	0x0008	;*8 bytes per strip
	.word	0x0002, 0x0002	;*2 strips of 2 tiles
	.long	asteroid_asset_Palettes
	.long	asteroid_asset_Map, asteroid_asset_Map, asteroid_asset_Map, asteroid_asset_Map
asteroid_asset_Map:
	.word	0x0100,0x0000, 0x0102,0x0000
	.word	0x0101,0x0000, 0x0103,0x0000

