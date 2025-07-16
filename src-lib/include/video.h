/* # $Id: video.h,v 1.8 2001/07/18 14:45:57 fma Exp $ */

#ifndef __VIDEO_H__
#define __VIDEO_H__

//-- Includes -----------------------------------------------------------------
#include <stdtypes.h>

#ifdef __cplusplus
	extern "C" {
#endif

//-- Type Definitions ---------------------------------------------------------
typedef struct {
	WORD	color[16];
} PALETTE, *PPALETTE;

typedef struct {
	WORD	block_number;
	WORD	attributes;
} TILE, *PTILE;

typedef struct {
	TILE	tiles[32];
} TILEMAP, *PTILEMAP;

typedef struct {
	WORD	r_offset;
	WORD	g_offset;
	WORD	b_offset;
} FADE_TRIPLET, *PFADE_TRIPLET;

typedef struct {
	FADE_TRIPLET	fade_triplets[16];
} FADER, *PFADER;

typedef struct {
	BYTE	values[1024];
} FADE_TABLE, *PFADE_TABLE;

//-- Exported Variables -------------------------------------------------------
extern volatile WORD	_vbl_flag;
extern volatile DWORD	_vbl_count;
extern WORD				_current_sprite;
extern FADE_TABLE		_fade_to_black;
extern FADE_TABLE		_fade_to_white;
//-- Inline functions ---------------------------------------------------------
extern inline WORD	get_current_sprite(void)
{
	return _current_sprite;
}

extern inline void	set_current_sprite(WORD npos)
{
	_current_sprite = npos;
}

extern inline void inc_current_sprite(short increment)
{
	_current_sprite += increment;
}

//-- Exported Functions -------------------------------------------------------
extern void textout(int x, int y, int pal, int bank, const char *txt);
extern void textoutf(int x, int y, int pal, int bank, const char *fmt, ...);
extern void setpalette(int npal, int nb, const PPALETTE palette);
extern void wait_vbl(void);
extern void clear_fix(void);
extern void clear_spr(void);
extern WORD	write_sprite_data(int x, int y, int xz, int yz, int clipping,
	int nb, const PTILEMAP tilemap);
extern void	change_sprite_pos(int sprite, int x, int y, int clipping);
extern void	change_sprite_zoom(int sprite, int xz, int yz, int nb);
extern void set_pal_bank(int palno);

extern void create_fader(PPALETTE pal, PFADER fader, int nb);
extern void do_fade(int pal_start, PFADER fader, PFADE_TABLE table, int nb,
	int step);
extern void erase_sprites(int nb);

#ifdef __cplusplus
	}
#endif

#endif // __VIDEO_H__
