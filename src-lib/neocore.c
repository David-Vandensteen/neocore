/*
  David Vandensteen
*/

#include <DATlib.h>
#include <input.h>
#include <stdio.h>
#include <neocore.h>
#include <math.h>

  //--------------------------------------------------------------------------//
 //                             DEFINE                                       //
//--------------------------------------------------------------------------//

#define NEOCORE_INIT \
  typedef struct bkp_ram_info { \
    WORD debug_dips; \
    BYTE stuff[254]; \
  } bkp_ram_info; \
  bkp_ram_info bkp_data;

#define JOYPAD_INIT_P1       BYTE neocore_joypad_p1, neocore_joypad_ps;
#define JOYPAD_READ_P1       neocore_joypad_p1 = volMEMBYTE(P1_CURRENT); neocore_joypad_ps = volMEMBYTE(PS_CURRENT);
#define JOYPAD_READ_EDGE_P1  neocore_joypad_p1 = volMEMBYTE(P1_EDGE); neocore_joypad_ps = volMEMBYTE(PS_EDGE);
#define JOYPAD_IS_UP_P1      neocore_joypad_p1&JOY_UP
#define JOYPAD_IS_DOWN_P1    neocore_joypad_p1&JOY_DOWN
#define JOYPAD_IS_LEFT_P1    neocore_joypad_p1&JOY_LEFT
#define JOYPAD_IS_RIGHT_P1   neocore_joypad_p1&JOY_RIGHT
#define JOYPAD_IS_START_P1   neocore_joypad_ps&P1_START
#define JOYPAD_IS_A_P1       neocore_joypad_p1&JOY_A
#define JOYPAD_IS_B_P1       neocore_joypad_p1&JOY_B
#define JOYPAD_IS_C_P1       neocore_joypad_p1&JOY_C
#define JOYPAD_IS_D_P1       neocore_joypad_p1&JOY_D

#define X 0
#define Y 1

#define LOG_X_INIT   1
#define LOG_Y_INIT   2

#define SPRITE_INDEX_MANAGER_MAX  384
#define PALETTE_INDEX_MANAGER_MAX 256

#define USE_PALETTE_MANAGER_INDEX_SPRITE_TYPE 0
#define USE_PALETTE_MANAGER_INDEX_FIX_TYPE 1

#define USE_PALETTE_MANAGER_INDEX_RESERVED_FOR_FIX ((const paletteInfo*) 1)
#define USE_PALETTE_MANAGER_INDEX_FREE ((const paletteInfo*) NULL)
#define USE_PALETTE_MANAGER_INDEX_SYSTEM_RESERVED ((const paletteInfo*) 2)

  //--------------------------------------------------------------------------//
 //                             STATIC                                       //
//--------------------------------------------------------------------------//

static Adpcm_player adpcm_player;
static BOOL is_init = false;
static BOOL joypad_edge_mode = false;
static WORD display_gfx_with_sprite_id = DISPLAY_GFX_WITH_SPRITE_ID_AUTO;
static WORD log_bank = 0;
static WORD log_palette_id = 0;

static void init_adpcm_player() {
  adpcm_player.state = IDLE;
  adpcm_player.remaining_frame = 0;
}

static BOOL sprite_index_manager_status[SPRITE_INDEX_MANAGER_MAX];
static const paletteInfo *palette_index_manager_status[PALETTE_INDEX_MANAGER_MAX];

static BOOL collide_point(short x, short y, Position vec[], BYTE vector_max);

static const WORD shrunk_table_prop[] = {
  0x000, 0x001, 0x002, 0x003, 0x004, 0x005, 0x006, 0x007, 0x008, 0x009,
  0x00a, 0x00b, 0x00c, 0x00d, 0x00e, 0x00f, 0x010, 0x111, 0x112, 0x113,
  0x114, 0x115, 0x116, 0x117, 0x118, 0x119, 0x11a, 0x11b, 0x11c, 0x11d,
  0x11e, 0x11f, 0x120, 0x121, 0x222, 0x223, 0x224, 0x225, 0x226, 0x227,
  0x228, 0x229, 0x22a, 0x22b, 0x22c, 0x22d, 0x22e, 0x22f, 0x230, 0x231,
  0x232, 0x333, 0x334, 0x335, 0x336, 0x337, 0x338, 0x339, 0x33a, 0x33b,
  0x33c, 0x33d, 0x33e, 0x33f, 0x340, 0x341, 0x342, 0x343, 0x444, 0x445,
  0x446, 0x447, 0x448, 0x449, 0x44a, 0x44b, 0x44c, 0x44d, 0x44e, 0x44f,
  0x450, 0x451, 0x452, 0x453, 0x454, 0x555, 0x556, 0x557, 0x558, 0x559,
  0x55a, 0x55b, 0x55c, 0x55d, 0x55e, 0x55f, 0x560, 0x561, 0x562, 0x563,
  0x564, 0x565, 0x666, 0x667, 0x668, 0x669, 0x66a, 0x66b, 0x66c, 0x66d,
  0x66e, 0x66f, 0x670, 0x671, 0x672, 0x673, 0x674, 0x675, 0x676, 0x777,
  0x778, 0x779, 0x77a, 0x77b, 0x77c, 0x77d, 0x77e, 0x77f, 0x780, 0x781,
  0x782, 0x783, 0x784, 0x785, 0x786, 0x787, 0x888, 0x889, 0x88a, 0x88b,
  0x88c, 0x88d, 0x88e, 0x88f, 0x890, 0x891, 0x892, 0x893, 0x894, 0x895,
  0x896, 0x897, 0x898, 0x999, 0x99a, 0x99b, 0x99c, 0x99d, 0x99e, 0x99f,
  0x9a0, 0x9a1, 0x9a2, 0x9a3, 0x9a4, 0x9a5, 0x9a6, 0x9a7, 0x9a8, 0x9a9,
  0xaaa, 0xaab, 0xaac, 0xaad, 0xaae, 0xaaf, 0xab0, 0xab1, 0xab2, 0xab3,
  0xab4, 0xab5, 0xab6, 0xab7, 0xab8, 0xab9, 0xaba, 0xbbb, 0xbbc, 0xbbd,
  0xbbe, 0xbbf, 0xbc0, 0xbc1, 0xbc2, 0xbc3, 0xbc4, 0xbc5, 0xbc6, 0xbc7,
  0xbc8, 0xbc9, 0xbca, 0xbcb, 0xccc, 0xccd, 0xcce, 0xccf, 0xcd0, 0xcd1,
  0xcd2, 0xcd3, 0xcd4, 0xcd5, 0xcd6, 0xcd7, 0xcd8, 0xcd9, 0xcda, 0xcdb,
  0xcdc, 0xddd, 0xdde, 0xddf, 0xde0, 0xde1, 0xde2, 0xde3, 0xde4, 0xde5,
  0xde6, 0xde7, 0xde8, 0xde9, 0xdea, 0xdeb, 0xdec, 0xded, 0xeee, 0xeef,
  0xef0, 0xef1, 0xef2, 0xef3, 0xef4, 0xef5, 0xef6, 0xef7, 0xef8, 0xef9,
  0xefa, 0xefb, 0xefc, 0xefd, 0xefe, 0xfff
};

static const char sin_table[] = {
  32,34,35,37,38,40,41,43,44,46,47,48,50,51,52,53,
  55,56,57,58,59,59,60,61,62,62,63,63,63,64,64,64,
  64,64,64,64,63,63,63,62,62,61,60,59,59,58,57,56,
  55,53,52,51,50,48,47,46,44,43,41,40,38,37,35,34,
  32,30,29,27,26,24,23,21,20,18,17,16,14,13,12,11,
  9,8,7,6,5,5,4,3,2,2,1,1,1,0,0,0,
  0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,8,
  9,11,12,13,14,16,17,18,20,21,23,24,26,27,29,30
};

static BOOL collide_point(short x, short y, Position vec[], BYTE vector_max) {
  BYTE i = 0, j = 0;
  for (i = 0; i < vector_max; i++) {
    j = i + 1;
    if (j == vector_max) { j = 0; }
    if (nc_math_vector_is_left( // foreach edge vector check if dot is  left
        x,
        y,
        vec[i].x, vec[i].y,
        vec[j].x, vec[j].y
      )
    ) { return false; } // if dot is left of the current vector, we return now (collide is impossible)
  }
  return true;
}

static void init_shadow_system() {
  if (is_init == false) {
    nc_system_init();
    is_init = true;
  }
}

static int log_x = LOG_X_INIT;
static int log_y = LOG_Y_INIT;

static int log_x_default = LOG_X_INIT;
static int log_y_default = LOG_Y_INIT;

#define set_log_x(x) (log_x = (x))
#define set_log_y(y) (log_y = (y))
#define reset_log_position() \
  do { \
    log_x = LOG_X_INIT; \
    log_y = LOG_Y_INIT; \
  } while(0)

static void init_sprite_manager_index() {
  WORD i = 0;
  for (i = 0; i < SPRITE_INDEX_MANAGER_MAX; i++) sprite_index_manager_status[i] = false;
  // Reserve sprite 0
  sprite_index_manager_status[0] = true;
}

static void set_sprite_manager_index(WORD index, WORD max) {
  WORD i = index;
  for (i = index; i < index + max; i++) sprite_index_manager_status[i] = true;
}

static void set_free_sprite_manager_index(WORD index, WORD max) {
  WORD i = index;
  for (i = index; i < index + max; i++) sprite_index_manager_status[i] = false;
}

static WORD use_sprite_manager_index(WORD max) {
  WORD i, j;
  WORD found;

  // Quick check: if we don't have enough free sprites, return early
  if (nc_sprite_manager_get_max_free_index() < max) {
    return SPRITE_INDEX_NOT_FOUND; // Return proper error code instead of 0
  }

  // Start from sprite 1 since sprite 0 is reserved
  for (i = 1; i <= SPRITE_INDEX_MANAGER_MAX - max; i++) {
    if (!sprite_index_manager_status[i]) {
      found = 1;
      for (j = i + 1; j < i + max; j++) {
        if (sprite_index_manager_status[j]) {
          found = 0;
          i = j; // Skip ahead to avoid redundant checks
          break;
        }
        found++;
      }
      if (found == max) {
        set_sprite_manager_index(i, max);
        return i;
      }
    }
  }
  return SPRITE_INDEX_NOT_FOUND; // Return proper error code instead of 0
}

static void init_palette_manager_index() {
  WORD i = 0;

  // Reserve palettes 0 and 1 for system (never allocatable)
  palette_index_manager_status[0] = USE_PALETTE_MANAGER_INDEX_SYSTEM_RESERVED;
  palette_index_manager_status[1] = USE_PALETTE_MANAGER_INDEX_SYSTEM_RESERVED;

  // Reserve palettes 2-16 for fix layer (allocatable for fix)
  for (i = 2; i <= 16; i++) {
    palette_index_manager_status[i] = USE_PALETTE_MANAGER_INDEX_RESERVED_FOR_FIX;
  }
}

static void set_palette_manager_index(const paletteInfo *pi, WORD index) {
  WORD i = index;
  for (i = index; i < index + pi->count; i++) palette_index_manager_status[i] = pi;
}

static void set_free_palette_index_manager(const paletteInfo *pi) {
  WORD i = 0;
  for (i = 0; i <PALETTE_INDEX_MANAGER_MAX; i++) {
    if (palette_index_manager_status[i] == pi) {
      palette_index_manager_status[i] = USE_PALETTE_MANAGER_INDEX_FREE;
    }
  }
}

static WORD use_palette_manager_index(const paletteInfo *pi, WORD type) {
  if (type == USE_PALETTE_MANAGER_INDEX_SPRITE_TYPE) {
    WORD i, j = 0;
    WORD found = 0;
    for (i = 0; i < PALETTE_INDEX_MANAGER_MAX; i++) {
      if (palette_index_manager_status[i] == pi) {
        return i;
      } else {
        if (palette_index_manager_status[i] == USE_PALETTE_MANAGER_INDEX_FREE) {
          for (j = i; j < i + pi->count; j++) {
            if (palette_index_manager_status[j] == USE_PALETTE_MANAGER_INDEX_FREE) {
              found++;
              if (found >= pi->count) {
                set_palette_manager_index(pi, i);
                return i;
              }
            }
          }
        } else {
          found = 0;
        }
      }
    }
    return 0; // TODO : no zero return
  } else if (type == USE_PALETTE_MANAGER_INDEX_FIX_TYPE) {
    // For FIX_TYPE, use only the reserved palette indices (2-16, excluding system palettes 0-1)
    WORD i, j = 0;
    WORD found = 0;

    // Check if palette is already allocated
    for (i = 2; i <= 16; i++) {
      if (palette_index_manager_status[i] == pi) {
        return i;
      }
    }

    // Find available space in reserved indices (2-16)
    for (i = 2; i <= 16 - pi->count + 1; i++) {
      found = 0;
      for (j = i; j < i + pi->count; j++) {
        if (palette_index_manager_status[j] == USE_PALETTE_MANAGER_INDEX_RESERVED_FOR_FIX) {
          // Reserved but not allocated to a specific palette
          found++;
        } else if (palette_index_manager_status[j] == USE_PALETTE_MANAGER_INDEX_FREE) {
          // Completely free (shouldn't happen in reserved range normally)
          found++;
        } else {
          // Already allocated to another palette
          break;
        }
      }

      if (found >= pi->count) {
        set_palette_manager_index(pi, i);
        return i;
      }
    }

    return 0; // No space available in reserved range
  }
  return 0; // Default fallback
}

NEOCORE_INIT
JOYPAD_INIT_P1

  //--------------------------------------------------------------------------//
 //                                   GFX                                    //
//--------------------------------------------------------------------------//

void nc_gpu_shrunk_centroid_gfx_picture(
  GFX_Picture *gfx_picture,
  short center_x,
  short center_y,
  WORD shrunk_value
  ) {
  nc_shrunk(
    gfx_picture->pictureDAT.baseSprite,
    gfx_picture->pictureDAT.info->tileWidth, shrunk_value
  );
  pictureSetPos(
    &gfx_picture->pictureDAT,
    nc_shrunk_centroid_get_translated_x(
      center_x,
      gfx_picture->pictureInfoDAT->tileWidth,
      nc_shrunk_extract_x(shrunk_value)
    ),
    nc_shrunk_centroid_get_translated_y(
      center_y,
      gfx_picture->pictureInfoDAT->tileHeight,
      nc_shrunk_extract_y(shrunk_value)
    )
  );
}

  /*------------------*/
 /*  GFX INIT        */
/*------------------*/
void nc_gfx_init_physic_picture(
  GFX_Physic_Picture *gfx_picture_physic,
  const pictureInfo *pi,
  const paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
) {
  init_shadow_system();
  nc_gfx_init_picture(&gfx_picture_physic->gfx_picture, pi, pali);
  gfx_picture_physic->autobox_enabled = autobox_enabled;
  if (gfx_picture_physic->autobox_enabled) {
    nc_physic_init_box(&gfx_picture_physic->box, box_witdh, box_height, box_width_offset, box_height_offset);
  }
}

void nc_gfx_init_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo
  ) {
  init_shadow_system();
  gfx_picture->paletteInfoDAT = paletteInfo;
  gfx_picture->pictureInfoDAT = pictureInfo;
  gfx_picture->pixel_height = pictureInfo->tileHeight * 32;
  gfx_picture->pixel_width = pictureInfo->tileWidth * 32;
}

void nc_gfx_init_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo
  ) {
  init_shadow_system();
  gfx_animated_sprite->spriteInfoDAT = spriteInfo;
  gfx_animated_sprite->paletteInfoDAT = paletteInfo;
};

void nc_gfx_init_animated_physic_sprite(
    GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
    const spriteInfo *spriteInfo,
    const paletteInfo *paletteInfo,
    short box_witdh,
    short box_height,
    short box_width_offset,
    short box_height_offset
  ) {
  init_shadow_system();
  nc_physic_init_box(
    &gfx_animated_sprite_physic->box,
    box_witdh,
    box_height,
    box_width_offset,
    box_height_offset
  );
  gfx_animated_sprite_physic->physic_enabled = true;
  nc_gfx_init_animated_sprite(
    &gfx_animated_sprite_physic->gfx_animated_sprite,
    spriteInfo,
    paletteInfo
  );
}

void nc_gfx_init_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo
  ) {
  init_shadow_system();
  gfx_scroller->scrollerInfoDAT = scrollerInfo;
  gfx_scroller->paletteInfoDAT = paletteInfo;
}

  /*------------------*/
 /*  GFX DESTROY     */
/*------------------*/

void nc_gfx_destroy_scroller(GFX_Scroller *gfx_scroller) {
  set_free_sprite_manager_index(gfx_scroller->scrollerDAT.baseSprite, 21);
  nc_gpu_shrunk(gfx_scroller->scrollerDAT.baseSprite, 21, 0xFFF);
  clearSprites(gfx_scroller->scrollerDAT.baseSprite, 21);
}

void nc_gfx_destroy_picture(GFX_Picture *gfx_picture) {
  pictureHide(&gfx_picture->pictureDAT);
  set_free_sprite_manager_index(
    gfx_picture->pictureDAT.baseSprite,
    gfx_picture->pictureInfoDAT->tileWidth
  );
  nc_gpu_shrunk(gfx_picture->pictureDAT.baseSprite, gfx_picture->pictureInfoDAT->tileWidth, 0xFFF);
  clearSprites(gfx_picture->pictureDAT.baseSprite, gfx_picture->pictureInfoDAT->tileWidth);
}

void nc_gfx_destroy_animated_sprite(GFX_Animated_Sprite *animated_sprite) {
  aSpriteHide(&animated_sprite->aSpriteDAT);
  set_free_sprite_manager_index(
    animated_sprite->aSpriteDAT.baseSprite,
    animated_sprite->spriteInfoDAT->maxWidth
  );
  nc_gpu_shrunk(animated_sprite->aSpriteDAT.baseSprite, animated_sprite->aSpriteDAT.tileWidth, 0xFFF);
  clearSprites(animated_sprite->aSpriteDAT.baseSprite, animated_sprite->aSpriteDAT.tileWidth);
}

void nc_gfx_destroy_animated_physic_sprite(GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic) {
  nc_gfx_destroy_animated_sprite(&gfx_animated_sprite_physic->gfx_animated_sprite);
}

void nc_gfx_destroy_physic_picture(GFX_Physic_Picture *gfx_picture_physic) {
  nc_gfx_destroy_picture(&gfx_picture_physic->gfx_picture);
}

  /*------------------*/
 /*  GFX DISPLAY     */
/*------------------*/

void nc_gfx_display_with_sprite_id(WORD sprite_id) {
  display_gfx_with_sprite_id = sprite_id;
}

WORD nc_gfx_display_physic_picture(GFX_Physic_Picture *gfx_picture_physic, short x, short y) {
  WORD sprite_index = nc_gfx_display_picture(&gfx_picture_physic->gfx_picture, x, y);
  if (gfx_picture_physic->autobox_enabled) {
    nc_physic_update_box(&gfx_picture_physic->box, x, y);
  }
  return sprite_index;
}

WORD nc_gfx_display_picture(GFX_Picture *gfx_picture, short x, short y) {
  WORD palette_index = use_palette_manager_index(gfx_picture->paletteInfoDAT, USE_PALETTE_MANAGER_INDEX_SPRITE_TYPE);
  WORD sprite_index;

  if (display_gfx_with_sprite_id != DISPLAY_GFX_WITH_SPRITE_ID_AUTO) {
    sprite_index = display_gfx_with_sprite_id;
    set_sprite_manager_index(sprite_index, gfx_picture->pictureInfoDAT->tileWidth);
    display_gfx_with_sprite_id = DISPLAY_GFX_WITH_SPRITE_ID_AUTO; // Reset after use
  } else {
    sprite_index = use_sprite_manager_index(gfx_picture->pictureInfoDAT->tileWidth);
    if (sprite_index == SPRITE_INDEX_NOT_FOUND) {
      return SPRITE_INDEX_NOT_FOUND; // Return error if no sprite available
    }
  }

  pictureInit(
    &gfx_picture->pictureDAT,
    gfx_picture->pictureInfoDAT,
    sprite_index,
    palette_index,
    x,
    y,
    FLIP_NONE
  );
  palJobPut(
    palette_index,
    gfx_picture->paletteInfoDAT->count,
    gfx_picture->paletteInfoDAT->data
  );
  return sprite_index;
}

WORD nc_gfx_display_animated_sprite(
  GFX_Animated_Sprite *animated_sprite,
  short x,
  short y,
  WORD anim
  ) {
  WORD palette_index = use_palette_manager_index(animated_sprite->paletteInfoDAT, USE_PALETTE_MANAGER_INDEX_SPRITE_TYPE);
  WORD sprite_index;

  if (display_gfx_with_sprite_id != DISPLAY_GFX_WITH_SPRITE_ID_AUTO) {
    sprite_index = display_gfx_with_sprite_id;
    set_sprite_manager_index(sprite_index, animated_sprite->spriteInfoDAT->maxWidth);
    display_gfx_with_sprite_id = DISPLAY_GFX_WITH_SPRITE_ID_AUTO; // Reset after use
  } else {
    sprite_index = use_sprite_manager_index(animated_sprite->spriteInfoDAT->maxWidth);
    if (sprite_index == SPRITE_INDEX_NOT_FOUND) {
      return SPRITE_INDEX_NOT_FOUND; // Return error if no sprite available
    }
  }

  aSpriteInit(
    &animated_sprite->aSpriteDAT,
    animated_sprite->spriteInfoDAT,
    sprite_index,
    palette_index,
    x,
    y,
    anim,
    FLIP_NONE,
    AS_FLAG_DISPLAY
  );
  palJobPut(
    palette_index,
    animated_sprite->paletteInfoDAT->count,
    animated_sprite->paletteInfoDAT->data
  );
  aSpriteSetAnim(&animated_sprite->aSpriteDAT, anim);
  return sprite_index;
}

WORD nc_gfx_display_animated_physic_sprite(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x,
  short y,
  WORD anim
  ) {
  WORD sprite_index = nc_gfx_display_animated_sprite(
    &gfx_animated_sprite_physic->gfx_animated_sprite,
    x,
    y,
    anim
  );
  nc_physic_update_box(&gfx_animated_sprite_physic->box, x, y);
  nc_update_animation_gfx_animated_sprite_physic(gfx_animated_sprite_physic);
  return sprite_index;
}

WORD nc_gfx_display_scroller(GFX_Scroller *gfx_scroller, short x, short y) {
  WORD palette_index = use_palette_manager_index(gfx_scroller->paletteInfoDAT, USE_PALETTE_MANAGER_INDEX_SPRITE_TYPE);
  WORD sprite_index;

  if (display_gfx_with_sprite_id != DISPLAY_GFX_WITH_SPRITE_ID_AUTO) {
    sprite_index = display_gfx_with_sprite_id;
    set_sprite_manager_index(sprite_index, 21);
    display_gfx_with_sprite_id = DISPLAY_GFX_WITH_SPRITE_ID_AUTO; // Reset after use
  } else {
    sprite_index = use_sprite_manager_index(21);
  }

  scrollerInit(
    &gfx_scroller->scrollerDAT,
    gfx_scroller->scrollerInfoDAT,
    sprite_index,
    palette_index,
    x,
    y
  );
  palJobPut(
    palette_index,
    gfx_scroller->paletteInfoDAT->count,
    gfx_scroller->paletteInfoDAT->data
  );
  return sprite_index;
}

  /*-----------------------*/
 /*  GFX INIT DISPLAY     */
/*-----------------------*/

WORD nc_gfx_init_and_display_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y,
  WORD anim
) {
  nc_gfx_init_animated_sprite(gfx_animated_sprite, spriteInfo, paletteInfo);
  return nc_gfx_display_animated_sprite(gfx_animated_sprite, x, y, anim);
}

WORD nc_gfx_init_and_display_animated_physic_sprite(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  WORD anim
) {
  nc_gfx_init_animated_physic_sprite(
    gfx_animated_sprite_physic,
    spriteInfo,
    paletteInfo,
    box_witdh,
    box_height,
    box_width_offset,
    box_height_offset
  );
  return nc_gfx_display_animated_physic_sprite(gfx_animated_sprite_physic, x, y, anim);
}

WORD nc_gfx_init_and_display_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
) {
  nc_gfx_init_picture(gfx_picture, pictureInfo, paletteInfo);
  return nc_gfx_display_picture(gfx_picture, x, y);
}

WORD nc_gfx_init_and_display_physic_picture(
  GFX_Physic_Picture *gfx_picture_physic,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
) {
  nc_gfx_init_physic_picture(
    gfx_picture_physic,
    pictureInfo,
    paletteInfo,
    box_witdh,
    box_height,
    box_width_offset,
    box_height_offset,
    autobox_enabled
  );
  return nc_gfx_display_physic_picture(gfx_picture_physic, x, y);
}

WORD nc_gfx_init_and_display_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
) {
  nc_gfx_init_scroller(gfx_scroller, scrollerInfo, paletteInfo);
  return nc_gfx_display_scroller(gfx_scroller, x, y);
}

  /*------------------*/
 /*  GFX VISIBILITY  */
/*------------------*/

void nc_gfx_hide_picture(GFX_Picture *gfx_picture) { pictureHide(&gfx_picture->pictureDAT); }

void nc_gfx_hide_physic_picture(GFX_Physic_Picture *gfx_picture_physic) {
  pictureHide(&gfx_picture_physic->gfx_picture.pictureDAT);
}

void nc_gfx_hide_animated_physic_sprite(GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic) {
  aSpriteHide(&gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT);
  clearSprites(
    gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT.baseSprite,
    gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT.tileWidth
  );
}

void nc_gfx_hide_animated_sprite(GFX_Animated_Sprite *animated_sprite) {
  aSpriteHide(&animated_sprite->aSpriteDAT);
  clearSprites(animated_sprite->aSpriteDAT.baseSprite, animated_sprite->aSpriteDAT.tileWidth);
}

void nc_gfx_show_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite) {
  aSpriteShow(&gfx_animated_sprite->aSpriteDAT);
}

void nc_gfx_show_animated_physic_sprite(GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic) {
  aSpriteShow(&gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT);
}

void nc_gfx_show_picture(GFX_Picture *gfx_picture) { pictureShow(&gfx_picture->pictureDAT); }

void nc_gfx_show_physic_picture(GFX_Physic_Picture *gfx_picture_physic) {
  pictureShow(&gfx_picture_physic->gfx_picture.pictureDAT);
}

  /*------------------*/
 /*  GFX POSITION    */
/*------------------*/

/* GFX POSITION GETTER */

void nc_gfx_get_animated_sprite_position(GFX_Animated_Sprite *gfx_animated_sprite, Position *position) {
  position->x = gfx_animated_sprite->aSpriteDAT.posX;
  position->y = gfx_animated_sprite->aSpriteDAT.posY;
}

void nc_gfx_get_animated_physic_sprite_position(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  Position *position
  ) {
  position->x = gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT.posX;
  position->y = gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT.posY;
}

void nc_gfx_get_picture_position(GFX_Picture *gfx_picture, Position *position) {
  position->x = gfx_picture->pictureDAT.posX;
  position->y = gfx_picture->pictureDAT.posY;
}

void nc_gfx_get_physic_picture_position(GFX_Physic_Picture *gfx_picture_physic, Position *position) {
  position->x = gfx_picture_physic->gfx_picture.pictureDAT.posX;
  position->y = gfx_picture_physic->gfx_picture.pictureDAT.posY;
}

void nc_gfx_get_scroller_position(GFX_Scroller *gfx_scroller, Position *position) {
  position->x = gfx_scroller->scrollerDAT.scrlPosX;
  position->y = gfx_scroller->scrollerDAT.scrlPosY;
}

/* GFX POSITION SETTER */

void nc_gfx_set_scroller_position(GFX_Scroller *gfx_scroller, short x, short y) {
  scrollerSetPos(&gfx_scroller->scrollerDAT, x, y);
}

void nc_gfx_set_animated_sprite_position(GFX_Animated_Sprite *gfx_animated_sprite, short x, short y) {
  aSpriteSetPos(&gfx_animated_sprite->aSpriteDAT, x, y);
}

void nc_gfx_set_picture_position(GFX_Picture *gfx_picture, short x, short y) {
  pictureSetPos(&gfx_picture->pictureDAT, x, y);
}

void nc_gfx_set_physic_picture_position(GFX_Physic_Picture *gfx_picture_physic, short x, short y) {
  pictureSetPos(&gfx_picture_physic->gfx_picture.pictureDAT, x, y);
  if (gfx_picture_physic->autobox_enabled) nc_physic_update_box(&gfx_picture_physic->box, x, y);
}

void nc_gfx_set_animated_physic_sprite_position(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x,
  short y
  ) {
  aSpriteSetPos(
    &gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT,
    x,
    y
  );
  nc_physic_update_box(&gfx_animated_sprite_physic->box, x, y);
}

/* GFX POSITION MOVE*/

void nc_gfx_move_physic_picture(GFX_Physic_Picture *gfx_picture_physic, short x_offset, short y_offset) {
  pictureMove(&gfx_picture_physic->gfx_picture.pictureDAT, x_offset, y_offset);
  if (gfx_picture_physic->autobox_enabled) {
    nc_physic_update_box(
      &gfx_picture_physic->box,
      gfx_picture_physic->gfx_picture.pictureDAT.posX,
      gfx_picture_physic->gfx_picture.pictureDAT.posY
    );
  }
}

void nc_gfx_move_animated_physic_sprite(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x_offset,
  short y_offset
  ) {
  aSpriteMove(&gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT, x_offset, y_offset);
  nc_physic_update_box(
    &gfx_animated_sprite_physic->box,
    gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT.posX,
    gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT.posY
  );
}

void nc_gfx_move_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x_offset,
  short y_offset
  ) {
  aSpriteMove(&gfx_animated_sprite->aSpriteDAT, x_offset, y_offset);
}

void nc_gfx_move_picture(GFX_Picture *gfx_picture, short x, short y) {
  pictureMove(&gfx_picture->pictureDAT, x, y);
}

void nc_gfx_move_scroller(GFX_Scroller *gfx_scroller, short x, short y) {
  scrollerSetPos(
    &gfx_scroller->scrollerDAT,
    gfx_scroller->scrollerDAT.scrlPosX + x,
    gfx_scroller->scrollerDAT.scrlPosY + y
  );
}

  /*-------------------*/
 /*  GFX ANIMATION    */
/*-------------------*/

void nc_gfx_set_animated_sprite_animation(GFX_Animated_Sprite *gfx_animated_sprite, WORD anim) {
  aSpriteSetAnim(&gfx_animated_sprite->aSpriteDAT, anim);
}

void nc_gfx_set_animated_sprite_animation_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  WORD anim
  ) {
  aSpriteSetAnim(&gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT, anim);
}

void nc_gfx_update_animated_sprite_animation(GFX_Animated_Sprite *gfx_animated_sprite) {
  aSpriteAnimate(&gfx_animated_sprite->aSpriteDAT);
}

void nc_gfx_update_animated_physic_sprite_animation(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic
  ) {
  aSpriteAnimate(&gfx_animated_sprite_physic->gfx_animated_sprite.aSpriteDAT);
}

  /*-------------------*/
 /*  GFX DESTROY      */
/*-------------------*/

  //--------------------------------------------------------------------------//
 //                                   GPU                                    //
//--------------------------------------------------------------------------//

void nc_gpu_init() {
  backgroundColor(0x7000); // todo (minor) - macro with some colors ...
  clearFixLayer();
  initGfx();
  volMEMWORD(0x400002) = 0xffff;  // debug text white
  LSPCmode = 0x1c00;              // autoanim speed
  init_sprite_manager_index();
  init_palette_manager_index();
}

void nc_gpu_clear_display() {
  WORD i = 0;
  const WORD sprite_max = 380;

  clearFixLayer();
  clearSprites(1, sprite_max);
  disableIRQ();

  /* Clear shrunk registers */
  for (i = 1; i <= sprite_max; i++) {
    SC234Put(VRAM_SHRINK_ADDR(i), 0xFFF);  /* No shrinking */
  }

  enableIRQ();
  nc_update();
}

  /*------------------------------*/
 /* GPU VBL                      */
/*------------------------------*/

void nc_gpu_update() {
  init_shadow_system();
  SCClose();
  nc_gpu_wait_vbl();
  nc_sound_update_adpcm_player();
  nc_joypad_update(0);
}

DWORD nc_gpu_wait_vbl_max(WORD nb) {
  WORD i = 0;
  for (i = 0; i <= nb; i++) waitVBlank();
  return DAT_frameCounter;
}

  /*------------------------------*/
 /* GPU SPRITE INDEX MANAGEMENT  */
/*------------------------------*/

void nc_sprite_manager_clear_table() { init_sprite_manager_index(); }

WORD nc_sprite_manager_get_free_index() {
  WORD i;
  // Start from sprite 1 since sprite 0 is reserved
  for (i = 1; i < SPRITE_INDEX_MANAGER_MAX; i++) {
    if (sprite_index_manager_status[i] == false) {
      return i;
    }
  }
  return SPRITE_INDEX_NOT_FOUND; // TODO : no zero return
}

WORD nc_sprite_manager_get_max_free_index() {
  WORD i, max = 0;
  // Start from sprite 1 since sprite 0 is reserved
  for (i = 1; i < SPRITE_INDEX_MANAGER_MAX; i++) {
    if (sprite_index_manager_status[i] != true) max++;
  }
  return max;
}

WORD nc_sprite_manager_get_max_used_index() {
  WORD i, max = 0;
  // Start from sprite 1 since sprite 0 is reserved and always marked as used
  for (i = 1; i < SPRITE_INDEX_MANAGER_MAX; i++) {
    if (sprite_index_manager_status[i] != false) max++;
  }
  return max;
}

  /*---------------*/
 /* GPU PALETTE   */
/*---------------*/

void nc_palette_manager_clear_table() { init_palette_manager_index(); }
void nc_palette_manager_unset_palette_info(const paletteInfo* paletteInfo) { set_free_palette_index_manager(paletteInfo); }

WORD nc_palette_manager_get_max_free_index() {
  WORD i, max = 0;
  for (i = 0; i < PALETTE_INDEX_MANAGER_MAX; i++) {
    if (palette_index_manager_status[i] == USE_PALETTE_MANAGER_INDEX_FREE) max++;
  }

  return max;
}

WORD nc_palette_manager_get_max_used_index() {
  WORD i, max = 0;
  for (i = 0; i < PALETTE_INDEX_MANAGER_MAX; i++) {
    if (palette_index_manager_status[i] != USE_PALETTE_MANAGER_INDEX_FREE) max++;
  }

  return max;
}

void nc_palette_manager_read_rgb16(BYTE palette_number, BYTE palette_index, RGB16 *rgb_color) {
  WORD packed_color = nc_get_palette_packed_color16(palette_number, palette_index);
  nc_palette_color16_to_rgb16(packed_color, rgb_color);
}

void nc_palette_color16_to_rgb16(WORD packed_color, RGB16 *rgb_color) {
  rgb_color->dark = (packed_color >> 12) & 0xF;
  rgb_color->r = (packed_color >> 8) & 0xF;
  rgb_color->g = (packed_color >> 4) & 0xF;
  rgb_color->b = packed_color & 0xF;
}

  /*--------------*/
 /* GPU shrunk   */
/*--------------*/

WORD nc_gpu_get_shrunk_proportional_table(WORD index) { return shrunk_table_prop[index]; } // todo (minor) - rename shrunk_proportional_table
void nc_gpu_shrunk_addr(WORD addr, WORD shrunk_value) { SC234Put(addr, shrunk_value); }

WORD nc_gpu_shrunk_forge(BYTE xc, BYTE yc) { // todo (minor) - xcF, ycFF
  //F FF - x (hor) , y (vert)
  // vertical shrinking   8 bits
  // horizontal shrinking 4 bits
  WORD value = 0;
  value = xc << 8;
  value += yc;

  return value;
}

WORD nc_gpu_shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value) {
  WORD cur_addr = addr_start;
  while (cur_addr < addr_end) {
    SC234Put(cur_addr, shrunk_value);
    cur_addr++;
  }

  return addr_end;
}

void nc_gpu_shrunk(WORD base_sprite, WORD max_width, WORD value) {
  nc_gpu_shrunk_range(0x8000 + base_sprite, 0x8000 + base_sprite + max_width, value);
}

int nc_gpu_get_shrunk_centroid_translated_x_position(short centerPosX, WORD tileWidth, BYTE shrunkX) {
  FIXED newX = nc_fix(centerPosX);
  newX -= (shrunkX + 1) * nc_fix((nc_bitwise_multiplication_8(tileWidth)) / 0x10);
  return nc_fix_to_int(newX);
}

int nc_gpu_get_shrunk_centroid_translated_y_position(short centerPosY, WORD tileHeight, BYTE shrunkY) {
  FIXED newY = nc_fix(centerPosY);
  newY -= shrunkY * nc_fix((nc_bitwise_multiplication_8(tileHeight)) / 0xFF);
  return nc_fix_to_int(newY);
}

  //--------------------------------------------------------------------------//
 //                                MATH                                      //
//--------------------------------------------------------------------------//

char nc_math_sin(WORD index) { return sin_table[index]; }

void nc_math_byte_to_hex(BYTE value, char *hexchar) {
  sprintf(hexchar, "%02X", value);
}

void nc_math_word_to_hex(WORD value, char *hexchar) {
  sprintf(hexchar, "%04X", value);
}

  //--------------------------------------------------------------------------//
 //                                PHYSIC                                    //
//--------------------------------------------------------------------------//

BYTE nc_physic_collide_boxes(Box *box, Box *boxes[], BYTE box_max) {
  BYTE rt = false;
  BYTE i = 0;
  for (i = 0; i < box_max; i++) {
  if(
      box->p1.x >= boxes[i]->p0.x
          &&
      box->p0.x <= boxes[i]->p1.x
          &&
      box->p3.y >= boxes[i]->p0.y
          &&
      box->p0.y <= boxes[i]->p3.y
    ) { rt = i + 1; }
  }
  return rt;
}

BOOL nc_physic_collide_box(Box *box1, Box *box2) { // todo - return a frixion vector
  if(
      box1->p1.x >= box2->p0.x
          &&
      box1->p0.x <= box2->p1.x
          &&
      box1->p3.y >= box2->p0.y
          &&
      box1->p0.y <= box2->p3.y
    ) {
      return true;
    } else { return false; }
}

void nc_physic_init_box(Box *box, short width, short height, short widthOffset, short heightOffset) {
  box->width = width;
  box->height = height;
  box->widthOffset = widthOffset;
  box->heightOffset = heightOffset;
}

void nc_physic_update_box(Box *box, short x, short y) {
  box->p0.x = x + box->widthOffset;
  box->p0.y = y + box->heightOffset;

  box->p1.x = box->p0.x + box->width;
  box->p1.y = box->p0.y;

  box->p2.x = box->p1.x;
  box->p2.y = box->p1.y + box->height;

  box->p3.x = box->p0.x;
  box->p3.y = box->p2.y;

  box->p4.x = box->p0.x + nc_bitwise_division_2((box->p1.x - box->p0.x));
  box->p4.y = box->p0.y + nc_bitwise_division_2((box->p3.y - box->p0.y));
}

void nc_physic_shrunk_box(Box *box, Box *bOrigin, WORD shrunkValue) {
  // todo (minor) - optim.
  // if i can read the shrunk VRAM value, i can compute the origin box...
  // todo (minor) - improve precision
  // todo (minor) - consider box offsets
  BYTE shrunk_x = nc_shrunk_extract_x(shrunkValue);
  BYTE pix_step_x = (nc_bitwise_division_16(bOrigin->width));
  BYTE trim_x = nc_bitwise_division_2((15 - shrunk_x) * pix_step_x);

  int trim_y;
  FIXED shrunk_y = nc_fix(nc_shrunk_extract_y(shrunkValue));
  FIXED pix_step_y = nc_fix((float)bOrigin->height / (float)256); // todo (minor) - hmmm !!! float
  FIXED shrunk_y_multiplicator = nc_fix_sub(nc_fix(255), shrunk_y);
  shrunk_y_multiplicator = fmul(shrunk_y_multiplicator, pix_step_y);
  trim_y = nc_fix_to_int(shrunk_y_multiplicator);
  trim_y =  nc_bitwise_division_2(trim_y);
  trim_y += 1;

  box->p0.x = bOrigin->p0.x + trim_x - (nc_bitwise_division_2(bOrigin->width));
  box->p0.y = bOrigin->p0.y + trim_y - (nc_bitwise_division_2(bOrigin->height));

  box->p1.x = bOrigin->p1.x - trim_x - (nc_bitwise_division_2(bOrigin->width));
  box->p1.y = bOrigin->p1.y + trim_y - (nc_bitwise_division_2(bOrigin->height));

  box->p2.x = bOrigin->p2.x - trim_x - (nc_bitwise_division_2(bOrigin->width));
  box->p2.y = bOrigin->p2.y - trim_y - (nc_bitwise_division_2(bOrigin->height));

  box->p3.x = bOrigin->p3.x + trim_x - (nc_bitwise_division_2(bOrigin->width));
  box->p3.y = bOrigin->p3.y - trim_y - (nc_bitwise_division_2(bOrigin->height));

  box->p4.x = box->p0.x + nc_bitwise_division_2((box->p1.x - box->p0.x));
  box->p4.y = box->p0.y + nc_bitwise_division_2((box->p3.y - box->p0.y));
}

void nc_physic_resize_box(Box *box, short edge) {
  box->p0.x -= edge;
  box->p0.y -= edge;

  box->p1.x += edge;
  box->p1.y -= edge;

  box->p2.x += edge;
  box->p2.y += edge;

  box->p3.x -= edge;
  box->p3.y += edge;
}

void nc_physic_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max) {
  BYTE i = 0;
  for (i = 0; i < vector_max; i++) {
    vec[i].x = x + offset[i].x;
    vec[i].y = y + offset[i].y;
  }
}

  //--------------------------------------------------------------------------//
 //                                SOUND                                     //
//--------------------------------------------------------------------------//

  //---------
 //    CDDA
//-----------

void nc_sound_play_cdda(BYTE track) {
  init_shadow_system();
  disableIRQ();
  asm(
    "loop_track_%=:              \n\t"
    "move.b  %0,%%d0             \n\t"
    "tst.b   0x10F6D9            \n\t"
    "beq.s   loop_track_%=       \n\t"
    "jsr     0xC0056A"
    :
    : "d"(track)
    : "d0"
  );
  enableIRQ();
}

void nc_sound_pause_cdda() {
  disableIRQ();
  asm(" move.w #0x200,%d0");
  asm(" jsr  0xC0056A");
  enableIRQ();
}

void nc_sound_resume_cdda() {
  disableIRQ();
  asm(" move.w #0x300,%d0");
  asm(" jsr  0xC0056A");
  enableIRQ();
}

  //--------
 //  ADPCM
//----------

void nc_sound_stop_adpcm() {
  #define Z80_ADPCM_STOP (0x18)
  (*((PBYTE)0x320000)) = Z80_ADPCM_STOP;
}

  //----------------------------------------------------------------------------//
 //                                  JOYPAD                                    //
//----------------------------------------------------------------------------//

void nc_joypad_set_edge_mode(BOOL actived) { joypad_edge_mode = actived; }

void nc_joypad_debug(BYTE id) {
  if (id == 0) {
    JOYPAD_READ_P1
  } else {
    // JOYPAD_READ_P2 // TODO
  }
  if (nc_joypad_is_start(id))  {  nc_log_print(10, 11,  "JOYPAD START"); }
  if (nc_joypad_is_up(id))     {  nc_log_print(10, 11,  "JOYPAD UP   "); }
  if (nc_joypad_is_down(id))   {  nc_log_print(10, 11,  "JOYPAD DOWN "); }
  if (nc_joypad_is_left(id))   {  nc_log_print(10, 11,  "JOYPAD LEFT "); }
  if (nc_joypad_is_right(id))  {  nc_log_print(10, 11,  "JOYPAD RIGHT"); }
  if (nc_joypad_is_a(id))      {  nc_log_print(10, 11,  "JOYPAD A    "); }
  if (nc_joypad_is_b(id))      {  nc_log_print(10, 11,  "JOYPAD B    "); }
  if (nc_joypad_is_c(id))      {  nc_log_print(10, 11,  "JOYPAD C    "); }
  if (nc_joypad_is_d(id))      {  nc_log_print(10, 11,  "JOYPAD D    "); }
}

void nc_joypad_update(BYTE id) {
  if (id == 0 && joypad_edge_mode == false) { JOYPAD_READ_P1 };
  if (id == 0 && joypad_edge_mode == true) { JOYPAD_READ_EDGE_P1 };
  // if (id = 1) JOYPAD_READ_P2; TODO
}

BOOL nc_joypad_is_up(BYTE id)     { return (JOYPAD_IS_UP_P1 && id == 0)     ? (true) : (false); }
BOOL nc_joypad_is_down(BYTE id)   { return (JOYPAD_IS_DOWN_P1 && id == 0)   ? (true) : (false); }
BOOL nc_joypad_is_left(BYTE id)   { return (JOYPAD_IS_LEFT_P1 && id == 0)   ? (true) : (false); }
BOOL nc_joypad_is_right(BYTE id)  { return (JOYPAD_IS_RIGHT_P1 && id == 0)  ? (true) : (false); }
BOOL nc_joypad_is_start(BYTE id)  { return (JOYPAD_IS_START_P1 && id == 0)  ? (true) : (false); }
BOOL nc_joypad_is_a(BYTE id)      { return (JOYPAD_IS_A_P1 && id == 0)      ? (true) : (false); }
BOOL nc_joypad_is_b(BYTE id)      { return (JOYPAD_IS_B_P1 && id == 0)      ? (true) : (false); }
BOOL nc_joypad_is_c(BYTE id)      { return (JOYPAD_IS_C_P1 && id == 0)      ? (true) : (false); }
BOOL nc_joypad_is_d(BYTE id)      { return (JOYPAD_IS_D_P1 && id == 0)      ? (true) : (false); }

  //----------------------------------------------------------------------------//
 //                                  UTIL                                      //
//----------------------------------------------------------------------------//

DWORD nc_math_frame_to_second(DWORD frame) {
  return frame / 60;
}

DWORD nc_math_second_to_frame(DWORD second) {
  return second * 60;
}

void nc_system_init() {
  nc_sound_init_adpcm();
  nc_gpu_init();
}

void nc_system_reset() {
  nc_joypad_set_edge_mode(false);
  nc_gpu_clear_display();
  nc_sprite_manager_clear_table();
  nc_palette_manager_clear_table();
  nc_system_init();
  nc_update();
}

void nc_math_get_relative_position(Position *position, Box box, Position world_coord) {
  position->x = world_coord.x - box.p0.x;
  position->y = nc_math_negative(world_coord.y - box.p3.y);
}

void nc_gpu_pause(BOOL (*exitFunc)()) {
  nc_joypad_update(0);
  while(!exitFunc()) {
    nc_joypad_update(0);
    nc_gpu_wait_vbl();
  }
}

void nc_gpu_sleep(DWORD frame) {
  nc_gpu_wait_vbl_max(frame);
}

BOOL nc_gpu_each_frame(DWORD frame) {
  if (frame == 0) return true;
  return (nc_gpu_get_frame_number() % frame == 0) ? true : false;
}

void nc_log_print(int x, int y, char *label) { fixPrint(x, y, 0, log_bank, label); }

WORD nc_system_get_free_ram_info() {
  // $000000  $0FFFFF    Vector Table, 68k program (.PRG files), 68k RAM
  // $100000  $00F2FF    WORKRAM_USER  User RAM/Work RAM
  int addr_end = 0x0FFFF, addr_used = 0x0FFFF;
  int used = null;
  for (addr_used = addr_used; addr_used > 0; addr_used--) {
    if (volMEMBYTE(addr_used)) used++;
  }
  return addr_end - used;
}

  /*---------------*/
 /* UTIL LOGGER   */
/*---------------*/

void nc_log_init() {
  init_shadow_system();
  log_x = LOG_X_INIT;
  log_y = LOG_Y_INIT;
  log_x_default = LOG_X_INIT;
  log_y_default = LOG_Y_INIT;
  clearFixLayer();
}

WORD nc_log_get_x_position() { return log_x; }
WORD nc_log_get_y_position() { return log_y; }

void nc_log_set_position(WORD _x, WORD _y) {
  log_x = _x + 1;
  log_y = _y + 2;
  log_x_default = log_x;
  log_y_default = log_y;
}

void nc_log_next_line() {
  log_y++;
  log_x = log_x_default;
}

WORD nc_log_info(char *text, ...) {
  char buffer[256];
  char line_buffer[32];
  va_list args;
  char *line_start;
  char *newline_pos;
  int line_len;

  va_start(args, text);
  vsprintf(buffer, text, args);
  va_end(args);

  // Check if text contains \n and handle line by line
  if (strchr(buffer, '\n') != NULL) {
    line_start = buffer;
    while ((newline_pos = strchr(line_start, '\n')) != NULL) {
      // Copy the line without the \n
      line_len = newline_pos - line_start;
      strncpy(line_buffer, line_start, line_len);
      line_buffer[line_len] = '\0';

      // Print the line
      fixPrintf(log_x, log_y, log_palette_id, log_bank, "%s", line_buffer);

      // Move to next line
      log_y++;
      log_x = log_x_default;

      // Move to next line in buffer
      line_start = newline_pos + 1;
    }

    // Handle remaining text after last \n (if any)
    if (*line_start != '\0') {
      fixPrintf(log_x, log_y, log_palette_id, log_bank, "%s", line_start);
      log_x += strlen(line_start);
    }
  } else {
    // No \n, just print and advance log_x
    fixPrintf(log_x, log_y, log_palette_id, log_bank, "%s", buffer);
    log_x += strlen(buffer);
  }

  return strlen(text);
}

WORD nc_log_info_line(char *text, ...) {
  char buffer[256];
  va_list args;
  va_start(args, text);
  vsprintf(buffer, text, args);
  va_end(args);
  fixPrintf(log_x, log_y, log_palette_id, log_bank, "%s", buffer);

  // Always advance to next line
  nc_log_next_line();

  return strlen(text);
}

void nc_log_word(WORD value) {
  fixPrintf(log_x, log_y, log_palette_id, log_bank, "%04d", value);
  log_x += 4;
}

void nc_log_int(int value) {
  fixPrintf(log_x, log_y, log_palette_id, log_bank, "%08d", value);
  log_x += 8;
}

void nc_log_dword(DWORD value) {
  fixPrintf(log_x, log_y, log_palette_id, log_bank, "%08d", value);
  log_x += 8;
}

void nc_log_short(short value) {
  fixPrintf(log_x, log_y, log_palette_id, log_bank, "%02d", value);
  log_x += 2;
}

void nc_log_byte(BYTE value) {
  fixPrintf(log_x, log_y, log_palette_id, log_bank, "%02d", value);
  log_x += 2;
}

void nc_log_bool(BOOL value) {
  fixPrintf(log_x, log_y, log_palette_id, log_bank, "%01d", value);
  log_x += 1;
}

void nc_log_spriteInfo(spriteInfo *si) {
  nc_log_info_line("PALCOUNT : %04d", si->palInfo->count);
  nc_log_info_line("FRAMECOUNT : %04d", si->frameCount);
  nc_log_info("MAXWIDTH : %04d", si->maxWidth);
}

void nc_log_box(Box *b) {
  nc_log_info_line("P0X: %d", (short)b->p0.x);
  nc_log_info_line("P0Y: %d", (short)b->p0.y);
  nc_log_info_line("");
  nc_log_info_line("P1X: %d", (short)b->p1.x);
  nc_log_info_line("P1Y: %d", (short)b->p1.y);
  nc_log_info_line("");
  nc_log_info_line("P2X: %d", (short)b->p2.x);
  nc_log_info_line("P2Y: %d", (short)b->p2.y);
  nc_log_info_line("");
  nc_log_info_line("P3X: %d", (short)b->p3.x);
  nc_log_info_line("P3Y: %d", (short)b->p3.y);
  nc_log_info_line("");
  nc_log_info_line("P4X: %d", (short)b->p4.x);
  nc_log_info_line("P4Y: %d", (short)b->p4.y);
  nc_log_info("");
  nc_log_info_line("WIDTH: %d", b->width);
  nc_log_info_line("HEIGHT: %d", b->height);
  nc_log_info_line("");
  nc_log_info_line("WIDTH OFFSET: %d", b->widthOffset);
  nc_log_info("HEIGHT OFFSET: %d", b->heightOffset);
}

void nc_log_pictureInfo(pictureInfo *pi) {
  nc_log_info_line("TILEWIDTH : %04d", (WORD)pi->tileWidth);
  nc_log_info("TILEHEIGHT : %04d", (WORD)pi->tileHeight);
}

void nc_log_palette_info(paletteInfo *paletteInfo) {
  char buffer[16];
  BYTE i = 0;
  for (i = 0; i < 16; i++) {
    sprintf(buffer, "0x%01X : 0x%04X", i, (unsigned int)paletteInfo[i].data);
    nc_log_info_line(buffer);
  }
}

void nc_log_packed_color16(WORD packed_color) {
  char hexpacket_color[5];
  char buffer[24];
  nc_math_word_to_hex(packed_color, hexpacket_color);
  sprintf(buffer, "PACKED COLOR 0x%04X", packed_color);
  nc_log_info(buffer);
}

void nc_log_rgb16(RGB16 *color) {
  char dark[3], r[3], g[3], b[3];
  char buffer[32];
  nc_math_byte_to_hex(color->dark, dark);
  nc_math_byte_to_hex(color->r, r);
  nc_math_byte_to_hex(color->g, g);
  nc_math_byte_to_hex(color->b, b);
  sprintf(buffer, "RGB DARK: %1X, R: %1X, G: %1X, B: %1X", color->dark, color->r, color->g, color->b);
  nc_log_info(buffer);
}

void nc_fix_set_bank(WORD bank) {
  log_bank = bank;
}

void nc_fix_set_palette_id(WORD palette) {
  log_palette_id = palette;
}

WORD nc_palette_set_info(const paletteInfo *paletteInfo, WORD palette_index) {
  set_palette_manager_index(paletteInfo, palette_index);
  palJobPut(palette_index, paletteInfo->count, paletteInfo->data);
  return palette_index;
}

WORD nc_fix_load_palette_info(const paletteInfo *palette_info) {
  WORD palette_index = use_palette_manager_index(palette_info, USE_PALETTE_MANAGER_INDEX_FIX_TYPE);
  if (palette_index != 0) {
    palJobPut(palette_index, palette_info->count, palette_info->data);
  }
  return palette_index;
}

BOOL nc_fix_unload_palette_info(const paletteInfo *palette_info) {
  WORD i, j;

  // Check if the palette is allocated in the fix layer range (2-16)
  for (i = 2; i <= 16; i++) {
    if (palette_index_manager_status[i] == palette_info) {
      // Found the palette, now free all its indices
      for (j = i; j < i + palette_info->count && j <= 16; j++) {
        if (palette_index_manager_status[j] == palette_info) {
          palette_index_manager_status[j] = USE_PALETTE_MANAGER_INDEX_RESERVED_FOR_FIX;
        }
      }
      return 1; // TRUE
    }
  }
  return 0; // FALSE - palette not found
}

BOOL nc_fix_unload_palette_id(WORD palette_id) {
  const paletteInfo *pi;
  WORD i;

  // Check if palette_id is in valid fix layer range (2-16)
  if (palette_id < 2 || palette_id > 16) {
    return 0; // FALSE - invalid range
  }

  // Check if the palette slot is actually allocated (not system reserved or already free)
  if (palette_index_manager_status[palette_id] == USE_PALETTE_MANAGER_INDEX_SYSTEM_RESERVED ||
      palette_index_manager_status[palette_id] == USE_PALETTE_MANAGER_INDEX_RESERVED_FOR_FIX) {
    return 0; // FALSE - not allocated or system reserved
  }

  // Get the palette info pointer to know how many consecutive indices to free
  pi = palette_index_manager_status[palette_id];
  if (pi == USE_PALETTE_MANAGER_INDEX_FREE) {
    return 0; // FALSE - already free
  }

  // Free all consecutive indices belonging to this palette
  for (i = palette_id; i < palette_id + pi->count && i <= 16; i++) {
    if (palette_index_manager_status[i] == pi) {
      palette_index_manager_status[i] = USE_PALETTE_MANAGER_INDEX_RESERVED_FOR_FIX;
    }
  }

  return 1; // TRUE
}

/*---------------*/
 /* SOUND         */
/*---------------*/

void nc_sound_init_adpcm() {
  init_adpcm_player();
}

Adpcm_player *nc_sound_get_adpcm_player() {
  return &adpcm_player;
}

void nc_sound_set_adpcm_remaining_frame(DWORD frame) {
  adpcm_player.remaining_frame += frame;
  adpcm_player.state = PLAYING;
}

void nc_sound_update_adpcm_player() {
  if (adpcm_player.remaining_frame != 0) {
    adpcm_player.state = PLAYING;
    adpcm_player.remaining_frame -= 1;
  }

  if (adpcm_player.remaining_frame > 0 && adpcm_player.state != IDLE) {
    adpcm_player.state = PLAYING;
    adpcm_player.remaining_frame -= 1;
  }

  if (adpcm_player.remaining_frame == 0) adpcm_player.state = IDLE;
}

  /*---------------*/
 /* UTIL VECTOR   */
/*---------------*/

BOOL nc_math_vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y) {
  BOOL rt = false;
  short vectorD[2] = {v2x - v1x, v2y - v1y};
  short vectorT[2] = {x - v1x, y -v1y};
  short d = vectorD[X] * vectorT[Y] - vectorD[Y] * vectorT[X];
  (d > 0) ? (rt = false) : (rt = true);
  return rt;
}

BOOL nc_math_vectors_is_collide(Box *box, Position vec[], BYTE vector_max) {
  BOOL p0 = false, p1 = false, p2 = false, p3 = false, p4 = false;
  p0 = collide_point(box->p0.x, box->p0.y, vec, vector_max);
  p1 = collide_point(box->p1.x, box->p1.y, vec, vector_max);
  p2 = collide_point(box->p2.x, box->p2.y, vec, vector_max);
  p3 = collide_point(box->p3.x, box->p3.y, vec, vector_max);
  p4 = collide_point(box->p4.x, box->p4.y, vec, vector_max);
  return (p0 || p1 || p2 || p3 || p4);
}

//--------------------------------------------------------------------------//
//                           LEGACY FUNCTIONS                              //
//--------------------------------------------------------------------------//

// Legacy GFX Init functions - for backward compatibility
void nc_init_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo
) {
  nc_gfx_init_animated_sprite(gfx_animated_sprite, spriteInfo, paletteInfo);
}

void nc_init_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
) {
  nc_gfx_init_animated_physic_sprite(gfx_animated_sprite_physic, spriteInfo, paletteInfo, box_witdh, box_height, box_width_offset, box_height_offset);
}

void nc_init_gfx_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo
) {
  nc_gfx_init_picture(gfx_picture, pictureInfo, paletteInfo);
}

void nc_init_gfx_picture_physic(
  GFX_Picture_Physic *gfx_picture_physic,
  const pictureInfo *pi,
  const paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
) {
  nc_gfx_init_physic_picture(gfx_picture_physic, pi, pali, box_witdh, box_height, box_width_offset, box_height_offset, autobox_enabled);
}

void nc_init_gfx_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo
) {
  nc_gfx_init_scroller(gfx_scroller, scrollerInfo, paletteInfo);
}

// Legacy GFX Display functions - for backward compatibility
void nc_display_gfx_with_sprite_id(WORD sprite_id) {
  nc_gfx_display_with_sprite_id(sprite_id);
}

WORD nc_display_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x,
  short y,
  WORD anim
) {
  return nc_gfx_display_animated_sprite(gfx_animated_sprite, x, y, anim);
}

WORD nc_display_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x,
  short y,
  WORD anim
) {
  return nc_gfx_display_animated_physic_sprite(gfx_animated_sprite_physic, x, y, anim);
}

WORD nc_display_gfx_picture(GFX_Picture *gfx_picture, short x, short y) {
  return nc_gfx_display_picture(gfx_picture, x, y);
}

WORD nc_display_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x, short y) {
  return nc_gfx_display_physic_picture(gfx_picture_physic, x, y);
}

WORD nc_display_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y) {
  return nc_gfx_display_scroller(gfx_scroller, x, y);
}

// Legacy GFX Init & Display functions - for backward compatibility
WORD nc_init_display_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y,
  WORD anim
) {
  return nc_gfx_init_and_display_animated_sprite(gfx_animated_sprite, spriteInfo, paletteInfo, x, y, anim);
}

WORD nc_init_display_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  WORD anim
) {
  return nc_gfx_init_and_display_animated_physic_sprite(gfx_animated_sprite_physic, spriteInfo, paletteInfo, x, y, box_witdh, box_height, box_width_offset, box_height_offset, anim);
}

WORD nc_init_display_gfx_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
) {
  return nc_gfx_init_and_display_picture(gfx_picture, pictureInfo, paletteInfo, x, y);
}

WORD nc_init_display_gfx_picture_physic(
  GFX_Picture_Physic *gfx_picture_physic,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
) {
  return nc_gfx_init_and_display_physic_picture(gfx_picture_physic, pictureInfo, paletteInfo, x, y, box_witdh, box_height, box_width_offset, box_height_offset, autobox_enabled);
}

WORD nc_init_display_gfx_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
) {
  return nc_gfx_init_and_display_scroller(gfx_scroller, scrollerInfo, paletteInfo, x, y);
}

// Legacy GFX Visibility functions - for backward compatibility
void nc_hide_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite) {
  nc_gfx_hide_animated_sprite(gfx_animated_sprite);
}

void nc_hide_gfx_picture(GFX_Picture *gfx_picture) {
  nc_gfx_hide_picture(gfx_picture);
}

void nc_hide_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic) {
  nc_gfx_hide_physic_picture(gfx_picture_physic);
}

void nc_hide_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic) {
  nc_gfx_hide_animated_physic_sprite(gfx_animated_sprite_physic);
}

void nc_show_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite) {
  nc_gfx_show_animated_sprite(gfx_animated_sprite);
}

void nc_show_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic) {
  nc_gfx_show_animated_physic_sprite(gfx_animated_sprite_physic);
}

void nc_show_gfx_picture(GFX_Picture *gfx_picture) {
  nc_gfx_show_picture(gfx_picture);
}

void nc_show_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic) {
  nc_gfx_show_physic_picture(gfx_picture_physic);
}

// Legacy Vector functions - for backward compatibility
BOOL nc_vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y) {
  return nc_math_vector_is_left(x, y, v1x, v1y, v2x, v2y);
}

BOOL nc_vectors_collide(Box *box, Position vec[], BYTE vector_max) {
  return nc_math_vectors_is_collide(box, vec, vector_max);
}

// Legacy Math functions - for backward compatibility
DWORD nc_frame_to_second(DWORD frame) {
  return nc_math_frame_to_second(frame);
}

DWORD nc_second_to_frame(DWORD second) {
  return nc_math_second_to_frame(second);
}

// PHYSIC LEGACY COMPATIBILITY FUNCTIONS

BYTE nc_collide_boxes(Box *box, Box *boxes[], BYTE box_max) {
  return nc_physic_collide_boxes(box, boxes, box_max);
}

BOOL nc_collide_box(Box *box1, Box *box2) {
  return nc_physic_collide_box(box1, box2);
}

void nc_init_box(Box *box, short width, short height, short widthOffset, short heightOffset) {
  nc_physic_init_box(box, width, height, widthOffset, heightOffset);
}

void nc_update_box(Box *box, short x, short y) {
  nc_physic_update_box(box, x, y);
}

void nc_shrunk_box(Box *box, Box *bOrigin, WORD shrunkValue) {
  nc_physic_shrunk_box(box, bOrigin, shrunkValue);
}

void nc_resize_box(Box *box, short edge) {
  nc_physic_resize_box(box, edge);
}

// MATH LEGACY COMPATIBILITY FUNCTIONS

void nc_byte_to_hex(BYTE value, char *hexchar) {
  nc_math_byte_to_hex(value, hexchar);
}

void nc_word_to_hex(WORD value, char *hexchar) {
  nc_math_word_to_hex(value, hexchar);
}

char nc_sin(WORD index) {
  return nc_math_sin(index);
}

void nc_set_joypad_edge_mode(BOOL actived) {
  nc_joypad_set_edge_mode(actived);
}

void nc_update_joypad(BYTE id) {
  nc_joypad_update(id);
}

void nc_debug_joypad(BYTE id) {
  nc_joypad_debug(id);
}

void nc_set_position_log(WORD _x, WORD _y) {
  nc_log_set_position(_x, _y);
}

void nc_push_remaining_frame_adpcm_player(DWORD frame) {
  nc_sound_set_adpcm_remaining_frame(frame);
}

Adpcm_player *nc_get_adpcm_player() {
  return nc_sound_get_adpcm_player();
}

void nc_get_relative_position(Position *position, Box box, Position world_coord) {
  nc_math_get_relative_position(position, box, world_coord);
}

void nc_init_system() {
  nc_system_init();
}

void nc_reset() {
  nc_system_reset();
}

void nc_pause(BOOL (*exitFunc)()) {
  nc_gpu_pause(exitFunc);
}

void nc_sleep(DWORD frame) {
  nc_gpu_sleep(frame);
}

void nc_update() {
  nc_gpu_update();
}

BOOL nc_each_frame(DWORD frame) {
  return nc_gpu_each_frame(frame);
}

WORD nc_free_ram_info() {
  return nc_system_get_free_ram_info();
}

void nc_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max) {
  nc_physic_update_mask(x, y, vec, offset, vector_max);
}

void nc_print(int x, int y, char *label) {
  nc_log_print(x, y, label);
}

//==========================================================================//
//                           LEGACY FUNCTIONS                               //
//==========================================================================//
// All legacy functions are grouped here for backward compatibility
// These functions maintain the old API and wrap the modern implementations

// Legacy GFX Shrunk Centroid functions
void nc_shrunk_centroid_gfx_picture(
  GFX_Picture *gfx_picture,
  short center_x,
  short center_y,
  WORD shrunk_value
  ) {
  nc_gpu_shrunk(
    gfx_picture->pictureDAT.baseSprite,
    gfx_picture->pictureDAT.info->tileWidth, shrunk_value
  );
  pictureSetPos(
    &gfx_picture->pictureDAT,
    nc_gpu_get_shrunk_centroid_translated_x_position(
      center_x,
      gfx_picture->pictureInfoDAT->tileWidth,
      nc_shrunk_extract_x(shrunk_value)
    ),
    nc_gpu_get_shrunk_centroid_translated_y_position(
      center_y,
      gfx_picture->pictureInfoDAT->tileHeight,
      nc_shrunk_extract_y(shrunk_value)
    )
  );
}

// Legacy GFX Destroy functions
void nc_destroy_gfx_scroller(GFX_Scroller *gfx_scroller) {
  nc_gfx_destroy_scroller(gfx_scroller);
}

void nc_destroy_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic) {
  nc_gfx_destroy_physic_picture(gfx_picture_physic);
}

void nc_destroy_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic) {
  nc_gfx_destroy_animated_physic_sprite(gfx_animated_sprite_physic);
}

void nc_destroy_gfx_picture(GFX_Picture *gfx_picture) {
  nc_gfx_destroy_picture(gfx_picture);
}

void nc_destroy_gfx_animated_sprite(GFX_Animated_Sprite *animated_sprite) {
  nc_gfx_destroy_animated_sprite(animated_sprite);
}

// Legacy GFX Position Getter functions
void nc_get_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, Position *position) {
  nc_gfx_get_animated_sprite_position(gfx_animated_sprite, position);
}

void nc_get_position_gfx_animated_sprite_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  Position *position
  ) {
  nc_gfx_get_animated_physic_sprite_position(gfx_animated_sprite_physic, position);
}

void nc_get_position_gfx_picture(GFX_Picture *gfx_picture, Position *position) {
  nc_gfx_get_picture_position(gfx_picture, position);
}

void nc_get_position_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic, Position *position) {
  nc_gfx_get_physic_picture_position(gfx_picture_physic, position);
}

void nc_get_position_gfx_scroller(GFX_Scroller *gfx_scroller, Position *position) {
  nc_gfx_get_scroller_position(gfx_scroller, position);
}

// Legacy GFX Position Setter functions
void nc_set_position_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y) {
  nc_gfx_set_scroller_position(gfx_scroller, x, y);
}

void nc_set_position_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x,
  short y
  ) {
  nc_gfx_set_animated_sprite_position(gfx_animated_sprite, x, y);
}

void nc_set_position_gfx_picture(GFX_Picture *gfx_picture, short x, short y) {
  nc_gfx_set_picture_position(gfx_picture, x, y);
}

void nc_set_position_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic, short x, short y) {
  nc_gfx_set_physic_picture_position(gfx_picture_physic, x, y);
}

void nc_set_position_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x,
  short y
  ) {
  nc_gfx_set_animated_physic_sprite_position(gfx_animated_sprite_physic, x, y);
}

// Legacy GFX Position Move functions
void nc_move_gfx_picture_physic(
  GFX_Picture_Physic *gfx_picture_physic,
  short x_offset,
  short y_offset
  ) {
  nc_gfx_move_physic_picture(gfx_picture_physic, x_offset, y_offset);
}

void nc_move_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x_offset,
  short y_offset
  ) {
  nc_gfx_move_animated_physic_sprite(gfx_animated_sprite_physic, x_offset, y_offset);
}

void nc_move_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x_offset,
  short y_offset
  ) {
  nc_gfx_move_animated_sprite(gfx_animated_sprite, x_offset, y_offset);
}

void nc_move_gfx_picture(GFX_Picture *gfx_picture, short x, short y) {
  nc_gfx_move_picture(gfx_picture, x, y);
}

void nc_move_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y) {
  nc_gfx_move_scroller(gfx_scroller, x, y);
}

// Legacy GFX Animation functions
void nc_set_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, WORD anim) {
  nc_gfx_set_animated_sprite_animation(gfx_animated_sprite, anim);
}

void nc_set_animation_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  WORD anim
  ) {
  nc_gfx_set_animated_sprite_animation_physic(gfx_animated_sprite_physic, anim);
}

void nc_update_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite) {
  nc_gfx_update_animated_sprite_animation(gfx_animated_sprite);
}

void nc_update_animation_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic
  ) {
  nc_gfx_update_animated_physic_sprite_animation(gfx_animated_sprite_physic);
}

// Legacy GPU functions
DWORD nc_wait_vbl_max(WORD nb) {
  WORD i = 0;
  for (i = 0; i <= nb; i++) waitVBlank();
  return DAT_frameCounter;
}

// Legacy GPU Shrunk functions
WORD nc_get_shrunk_proportional_table(WORD index) {
  return shrunk_table_prop[index];
}

void nc_shrunk_addr(WORD addr, WORD shrunk_value) {
  SC234Put(addr, shrunk_value);
}

WORD nc_shrunk_forge(BYTE xc, BYTE yc) {
  //F FF - x (hor) , y (vert)
  // vertical shrinking   8 bits
  // horizontal shrinking 4 bits
  WORD value = 0;
  value = xc << 8;
  value += yc;

  return value;
}

WORD nc_shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value) {
  WORD cur_addr = addr_start;
  while (cur_addr < addr_end) {
    SC234Put(cur_addr, shrunk_value);
    cur_addr++;
  }

  return addr_end;
}

void nc_shrunk(WORD base_sprite, WORD max_width, WORD value) {
  nc_gpu_shrunk_range(0x8000 + base_sprite, 0x8000 + base_sprite + max_width, value);
}

int nc_shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX) {
  FIXED newX = nc_fix(centerPosX);
  newX -= (shrunkX + 1) * nc_fix((nc_bitwise_multiplication_8(tileWidth)) / 0x10);
  return nc_fix_to_int(newX);
}

int nc_shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY) {
  FIXED newY = nc_fix(centerPosY);
  newY -= shrunkY * nc_fix((nc_bitwise_multiplication_8(tileHeight)) / 0xFF);
  return nc_fix_to_int(newY);
}

// Legacy Palette functions
void nc_destroy_palette(const paletteInfo* paletteInfo) {
  set_free_palette_index_manager(paletteInfo);
}

void nc_read_palette_rgb16(BYTE palette_number, BYTE palette_index, RGB16 *rgb_color) {
  WORD packed_color = nc_get_palette_packed_color16(palette_number, palette_index);
  nc_palette_color16_to_rgb16(packed_color, rgb_color);
}

void nc_packet_color16_to_rgb16(WORD packed_color, RGB16 *rgb_color) {
  rgb_color->dark = (packed_color >> 12) & 0xF;
  rgb_color->r = (packed_color >> 8) & 0xF;
  rgb_color->g = (packed_color >> 4) & 0xF;
  rgb_color->b = packed_color & 0xF;
}

// Legacy Sound functions
void nc_play_cdda(unsigned char track) {
  nc_sound_play_cdda(track);
}
