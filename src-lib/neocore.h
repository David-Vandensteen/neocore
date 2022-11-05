/*
  David Vandensteen
  2018
*/
  // short  ->  2 bytes
  // word   ->  2 bytes
  // dword  ->  4 bytes
  // char   ->  1 byte
  // int    ->  4 bytes
  // byte   ->  1 byte

#ifndef NEOCORE_H
#define NEOCORE_H
#include <DATlib.h>
#include <math.h>

#define NEOCORE_INIT \
  typedef struct bkp_ram_info { \
    WORD debug_dips; \
    BYTE stuff[254]; \
  } bkp_ram_info; \
  bkp_ram_info bkp_data;

#define __ALIGN1__      __attribute__ ((aligned (1)))
#define __ALIGN2__      __attribute__ ((aligned (2)))
#define __ALIGN4__      __attribute__ ((aligned (4)))
#define __ALIGN64__     __attribute__ ((aligned (64)))
#define __ALIGN128__    __attribute__ ((aligned (128)))

#define MULT2              << 1
#define MULT4              << 2
#define MULT8              << 3
#define MULT16             << 4
#define MULT32             << 5
#define MULT64             << 6
#define DIV2               >> 1
#define DIV4               >> 2
#define DIV8               >> 3
#define DIV16              >> 4
#define DIV32              >> 5
#define DIV64              >> 6

#define Y_OFFSCREEN 240
#define X 0
#define Y 1

#define SHRUNK_TABLE_PROP_SIZE    0x2fe

#define JOYPAD            BYTE p1, ps;
#define JOYPAD_READ       p1 = volMEMBYTE(P1_CURRENT); ps = volMEMBYTE(PS_CURRENT);
#define JOYPAD_READ_EDGE  p1 = volMEMBYTE(P1_EDGE); ps = volMEMBYTE(PS_EDGE);
#define JOYPAD_IS_UP      p1&JOY_UP
#define JOYPAD_IS_DOWN    p1&JOY_DOWN
#define JOYPAD_IS_LEFT    p1&JOY_LEFT
#define JOYPAD_IS_RIGHT   p1&JOY_RIGHT
#define JOYPAD_IS_START   ps&P1_START
#define JOYPAD_IS_A       p1&JOY_A
#define JOYPAD_IS_B       p1&JOY_B
#define JOYPAD_IS_C       p1&JOY_C
#define JOYPAD_IS_D       p1&JOY_D

#define LOGGER_ON
#define LOGGER_X_INIT   1
#define LOGGER_Y_INIT   2

#define BOXCOPY(bFrom, bTo)   memcpy(bTo, bFrom, sizeof(Box))

#define FIX(value) value * 65536
#define RAND(value) rand() % value

#define SHRUNK_EXTRACT_X(value) value >> 8
#define SHRUNK_EXTRACT_Y(value) (BYTE)value

#define SPRITE_INDEX_MANAGER_MAX  384
#define PALETTE_INDEX_MANAGER_MAX 256

#define MANUALBOX 0
#define AUTOBOX 1

/*----------------*/
/* REFACTOR      */
/*--------------*/

// init gfx
#define init_gs(gfx_scroller_pointer, scrollerInfo_pointer, paletteInfo_pointer) gfx_scroller_init(gfx_scroller_pointer, scrollerInfo_pointer, paletteInfo_pointer)
#define init_gp(gfx_picture_pointer, pictureInfo_pointer, paletteInfo_pointer) gfx_picture_init(gfx_picture_pointer, pictureInfo_pointer, paletteInfo_pointer)
#define init_gas(gfx_animated_sprite_pointer, spriteInfo_pointer, paletteInfo_pointer) gfx_animated_sprite_init(gfx_animated_sprite_pointer, spriteInfo_pointer, paletteInfo_pointer)
#define init_gasp(gfx_animated_sprite_physic_pointer, spriteInfo_pointer, paletteInfo_pointer, box_width, box_height, box_width_offset, box_height_offset) \
  gfx_animated_sprite_physic_init(gfx_animated_sprite_physic_pointer, \
    spriteInfo_pointer, \
    paletteInfo_pointer, \
    box_width, \
    box_height, \
    box_width_offset, \
    box_height_offset\
  )

#define init_gpp(gfx_picture_physic_pointer, pictureInfo_pointer, paletteInfo_pointer, box_width, box_height, box_width_offset, box_height_offset, autobox_enabled) \
  gfx_picture_physic_init(gfx_picture_physic_pointer, \
    pictureInfo_pointer, \
    paletteInfo_pointer, \
    box_width, \
    box_height, \
    box_width_offset, \
    box_height_offset, \
    autobox_enabled\
  )

// end init gfx

// display gfx
#define display_gas(gfx_animated_sprite_pointer, x, y, anim) gfx_animated_sprite_display(gfx_animated_sprite_pointer, x, y, anim)
#define display_gasp(gfx_animated_sprite_physic_pointer, x, y, anim) gfx_animated_sprite_physic_display(gfx_animated_sprite_physic_pointer, x, y, anim)
#define display_gp(gfx_picture_pointer, x, y) gfx_picture_display(gfx_picture_pointer, x, y)
#define display_gpp(gfx_picture_physic_pointer, x, y) gfx_picture_physic_display(gfx_picture_physic_pointer, x, y)
#define display_gs(gfx_scroller_pointer, x, y) gfx_scroller_display(gfx_scroller_pointer, x, y)
// end display gfx

// get x, get y gfx
#define get_x_gas(gfx_animated_sprite) gfx_animated_sprite.as.posX
#define get_y_gas(gfx_animated_sprite) gfx_animated_sprite.as.posY

#define get_x_gasp(gfx_animated_sprite_physic) gfx_animated_sprite_physic.gfx_animated_sprite.as.posX
#define get_y_gasp(gfx_animated_sprite_physic) gfx_animated_sprite_physic.gfx_animated_sprite.as.posY

#define get_x_gp(gfx_picture) gfx_picture.pic.posX
#define get_y_gp(gfx_picture) gfx_picture.pic.posY

#define get_x_gpp(gfx_picture_physic) gfx_picture_physic.gfx_picture.pic.posX // TODO : test
#define get_y_gpp(gfx_picture_physic) gfx_picture_physic.gfx_picture.pic.posY // TODO : test

#define get_x_gs(gfx_scroller) gfx_scroller.s.scrlPosX
#define get_y_gs(gfx_scroller) gfx_scroller.s.scrlPosY
// end get x, get y gfx

// set x, set y gfx
#define set_x_gasp(gfx_animated_sprite_physic_pointer, x) gfx_animated_sprite_physic_set_position(gfx_animated_sprite_physic_pointer, x, gfx_animated_sprite_physic.gfx_animated_sprite.as.posY) // TODO : test
#define set_y_gasp(gfx_animated_sprite_physic_pointer, y) gfx_animated_sprite_physic_set_position(gfx_animated_sprite_physic_pointer, gfx_animated_sprite_physic.gfx_animated_sprite.as.posX, y) // TODO : test

#define set_x_gs(gfx_scroller_pointer, x) scrollerSetPos(gfx_scroller_pointer.s, x, gfx_scroller_pointer.s.scrlPosY)
#define set_y_gs(gfx_scroller_pointer, x) scrollerSetPos(gfx_scroller_pointer.s, gfx_scroller_pointer.s.scrlPosX, y)
// end set x, set y gfx

// set pos gfx
#define set_pos_gs(gfx_scroller_pointer, x, y) scrollerSetPos(gfx_scroller_pointer.s, x, y) // TODO : test
#define set_pos_gasp(gfx_animated_sprite_physic_pointer, x, y) gfx_animated_sprite_physic_set_position(gfx_animated_sprite_physic_pointer, x, y)

#define set_pos_gp(gfx_picture_pointer, x, y) pictureSetPos(gfx_picture_pointer.pic, x, y)

#define set_pos_gpp(gfx_picture_physic_pointer, x, y) gfx_picture_physic_set_position(gfx_picture_physic_pointer, x, y);
// end set pos gfx

// set animation gfx
#define set_anim_gas(gfx_animated_sprite, anim) aSpriteSetAnim(gfx_animated_sprite.as, anim)
#define set_anim_gasp(gfx_animated_sprite_physic, anim) aSpriteSetAnim(gfx_animated_sprite_physic.gfx_animated_sprite.as, anim)
// end set animation gfx

// move gfx
#define move_gp(gfx_picture_pointer, x, y) pictureMove(gfx_picture_pointer.pic, x, y)
#define move_gpp(gfx_picture_physic_pointer, x, y) gfx_picture_physic_move(gfx_picture_physic_pointer, x, y)
#define move_gas(gfx_animated_sprite, x, y) gfx_animated_sprite_move(gfx_animated_sprite, x, y)
#define move_gasp(gfx_animated_sprite_physic, x, y) gfx_animated_sprite_physic_move(gfx_animated_sprite_physic, x, y)
#define move_gs(gfx_scroller, x, y) gfx_scroller_move(gfx_scroller, x, y)
// end move gfx

// animate gfx
#define update_anim_gas(gfx_animated_sprite_pointer) aSpriteAnimate(gfx_animated_sprite_pointer.as)
#define update_anim_gasp(gfx_animated_sprite_physic_pointer) aSpriteAnimate(gfx_animated_sprite_physic_pointer.gfx_animated_sprite.as)
// end animate gfx

// hide
#define hide_gasp(gfx_animated_sprite_physic_pointer) gfx_animated_sprite_physic_hide(gfx_animated_sprite_physic_pointer)
#define hide_gp(gfx_picture_pointer) pictureHide(gfx_picture_pointer.pic)
#define hide_gpp(gfx_picture_physic_pointer) pictureHide(gfx_picture_physic_pointer.gfx_picture.pic)

//end hide

// show
#define show_gasp(gfx_animated_sprite_physic) gfx_animated_sprite_physic_show(gfx_animated_sprite_physic)
#define show_gp(gfx_picture_pointer) pictureShow(gfx_picture_pointer.pic)
#define show_gpp(gfx_picture_physic_pointer) pictureShow(gfx_picture_physic_pointer.gfx_picture.pic);
// end show

// destroy
#define destroy_gp(gfx_picture_pointer) gfx_picture_destroy(gfx_picture_pointer)
#define destroy_gpp(gfx_picture_physic_pointer) gfx_picture_destroy(gfx_picture_physic_pointer.gfx_picture)
// end destroy

// enable / disable physic TODO

//

// utils
#define init_logger() logger_init()
#define update_joypad_edge() joypad_update_edge()
#define update_joypad() joypad_update()

#define close_vbl() SCClose()
#define init_gpu() gpu_init()

#define get_frame_counter() DAT_frameCounter

enum direction { NONE, UP, DOWN, LEFT, RIGHT };

/**
 * \struct Vec2int
 * \brief content x & y int coordinate
 */
typedef struct Vec2int Vec2int;
struct Vec2int {
  int x;
  int y;
};

/**
 * \struct Vec2short
 * \brief content x & y short coordinate
 */
typedef struct Vec2short Vec2short;
struct Vec2short {
  short x;
  short y;
};

/**
 * \struct Vec2byte
 * \brief content x & y byte coordinate
 */
typedef struct Vec2byte Vec2byte;
struct Vec2byte {
  BYTE x;
  BYTE y;
};

/**
 * \struct Box
 * \brief collider definition
 * * can be init by box_make constructor
 * - 4 vector short points (x, y)
 * - Width & height of the box
 * - Offset for reducing the box
 */
typedef struct Box Box;
struct Box {
  Vec2short p0;       /*!< coordinate 0 of the box (x, y) */
  Vec2short p1;       /*!< coordinate 1 of the box (x, y) */
  Vec2short p2;       /*!< coordinate 2 of the box (x, y) */
  Vec2short p3;       /*!< coordinate 3 of the box (x, y) */
  Vec2short p4;       /*!< coordinate 4 of the box (x, y) */
  short width;        /*!< width of the box */
  short height;       /*!< height of the box */
  short widthOffset;  /*!< width box reducing */
  short heightOffset; /*!< height box reducing */
};

/**
 * \struct GFX_Animated_Sprite
 * \brief DATLib aSprite structure encapsulation
 */
typedef struct GFX_Animated_Sprite GFX_Animated_Sprite;
struct GFX_Animated_Sprite {
  aSprite as;         /*!< - as is aSprite DATLib definition */
  spriteInfo *si;     /*!< - si is a pointer to DATLib spriteInfo structure */
  paletteInfo *pali;  /*!< - pali is a pointer to DATLib paletteInfo structure */
};

/**
 * \struct GFX_Picture
 * \brief DATLib picture structure encapsulation
 */
typedef struct GFX_Picture GFX_Picture;
struct GFX_Picture {
  picture pic;        /*!< - pic is picture DATLib definition */
  pictureInfo *pi;    /*!< - pi is a pointer to DATLib pictureInfo structure */
  paletteInfo *pali;  /*!< - pali is a pointer to DATLib paletteInfo structure */
};

/**
 * \struct GFX_Animated_Sprite_Physic
 * \brief GFX_Animated_Sprite encapsulation with Box
 *
 *  GFX_Animated_Sprite_Physic can be collide with another Box structure
 */
typedef struct GFX_Animated_Sprite_Physic GFX_Animated_Sprite_Physic;
struct GFX_Animated_Sprite_Physic {
  GFX_Animated_Sprite gfx_animated_sprite;  /*!< - GFX_Animated_Sprite */
  Box box;                          /*!< - Box */
  BOOL physic_enabled;              /*!< - enable physic (for collide detection capalities) */
};

/**
 * \struct GFX_Picture_Physic
 * \brief GFX_Picture encapsulation with Box
 *
 *  GFX_Picture_Physic can be collide with another Box structure
 */
typedef struct GFX_Picture_Physic GFX_Picture_Physic;
struct GFX_Picture_Physic {
  GFX_Picture gfx_picture;  /*!< - GFX_Picture */
  Box box;              /*!< - Box */
  BOOL autobox_enabled; /*!< - enable autobox */
  BOOL physic_enabled;  /*!< - enable physic (for collide detection capabilities) */
};

/**
 * \struct GFX_Scroller
 * \brief DATLib scroller structure encapsulation
 */
typedef struct GFX_Scroller GFX_Scroller;
struct GFX_Scroller {
  scroller s;          /*!< - s is a pointer to DATLib scroller struture */
  scrollerInfo *si;    /*!< - si is a pointer to DATLib scrollerInfo structure */
  paletteInfo *pali;   /*!< - pali is a pointer to DATLib paletteInfo structure */
};

  //--------------------------------------------------------------------------//
 //                                  -B                                      //
//--------------------------------------------------------------------------//
/**
 * \brief check if a box is colliding with a box list
 * @param Box* Box pointer
 * @param Box* Box list pointer
 * @param box_max Box quantity
 * \return BYTE the box id collider or 0
 */
BYTE boxes_collide(Box *b, Box *boxes[], BYTE box_max);

/**
 * \brief check if two box is colliding
 * @param Box* box1 pointer
 * @param Box* box2 pointer
 * \return BOOL
 */
BOOL box_collide(Box *b1, Box *b2);

/**
 * @param Box* Box pointer
 * @param width
 * @param height
 * @param width_offset width Box reduce
 * @param height_offset height Box reduce
 */
void box_init(Box *b, short width, short height, short widthOffset, short heightOffset);

/**
 * \brief refresh Box position
 * @param Box* Box pointer
 * @param x
 * @param y
 */
void box_update(Box *b, short x, short y);
// void box_debug_update(picture5 *pics, Box *box); // todo (minor)
// void box_display(picture5 *pics, Box *box, pictureInfo *pi, paletteInfo *pali); // todo (minor)

/**
 *
 */

// todo (minor)
void box_shrunk(Box *b, Box *bOrigin, WORD shrunkValue);
// todo (minor) - deprecated ?
void box_resize(Box *Box, short edge); // todo (minor) - deprecated ?

  //--------------------------------------------------------------------------//
 //                                  -C                                      //
//--------------------------------------------------------------------------//
/**
 *  \brief VRAM Clear
 */
void inline clear_vram();

/**
 * \brief clear sprite index table
 */
void clear_sprite_index_table();

/**
 * \brief clear palette inde table
 */
void clear_palette_index_table();

/**
 * \brief Play CD Audio Track
 * @param track
 */
void cdda_play(BYTE track);

  //--------------------------------------------------------------------------//
 //                                  -F                                      //
//--------------------------------------------------------------------------//
/**
 * @param x
 * @param y
 * @param label
 */
void inline fix_print_neocore(int x, int y, char *label);

/**
 * \brief return estimated free RAM
 */
WORD free_ram_info();


  //--------------------------------------------------------------------------//
 //                                  -G                                      //
//--------------------------------------------------------------------------//

  /*----------------------*/
 /*      -gfx_picture      */
/*----------------------*/
/**
 * @param GFX_Picture* GFX_Picture pointer
 * @param pictureInfo* pointer to DATLib structure
 * @param paletteInfo* pointer to DATLib structure
 */
void gfx_picture_init(GFX_Picture *gfx_picture, pictureInfo *pi, paletteInfo *pali);

/**
 * @param GFX_Picture* GFX_Picture pointer
 * @param x
 * @param y
 */
void gfx_picture_display(GFX_Picture *gfx_picture, short x, short y);

/**
 * \brief hide GFX_Picture
 * @param GFX_Picture* GFX_Picture pointer
 */
void gfx_picture_hide(GFX_Picture *gfx_picture);

/**
 * \brief show GFX_Picture
 * @param GFX_Picture* GFX_Picture pointer
 */
void gfx_picture_show(GFX_Picture *gfx_picture);

/**
 * @param GFX_Picture* GFX_Picture pointer
 * \return BOOL true if GFX_Picture is visible or false
 */
void gfx_picture_is_visible(GFX_Picture *gfx_picture);

/**
 * @param GFX_Picture* GFX_Picture pointer
 * @param x center position
 * @param y center position
 * @param shrunk use shrunk_forge function for make a WORD with width & heigh value
 */
void gfx_image_shrunk_centroid(GFX_Picture *gfx_picture, short center_x, short center_y, WORD shrunk_value);

/**
 * \brief GFX_Picture destroy
 * @param GFX_Picture* GFX_Picture pointer
 */
void gfx_picture_destroy(GFX_Picture *gfx_picture);

  /*----------------------*/
 /*  -gfx_image_physic   */
/*----------------------*/
/**
 * @param GFX_Picture_Physic* GFX_Picture_Physic pointer
 * @param pictureInfo* pointer to DATLib structure
 * @param paletteInfo* pointer to DATLib structure
 * @param width Box width
 * @param height Box height
 * @param width_offset Box offset reduce
 * @param height_offset Box offset reduce
 */
void gfx_picture_physic_init(
  GFX_Picture_Physic *gfx_picture_physic,
  pictureInfo *pi,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
);

/**
 * @param GFX_Picture_Physic* pointer
 * @param x
 * @param y
 */
void gfx_picture_physic_display(GFX_Picture_Physic *gfx_picture_physic, short x, short y);

/**
 * @param GFX_Picture_Physic* pointer
 * @param x offset
 * @param y offset
 */
void gfx_picture_physic_move(GFX_Picture_Physic *gfx_picture_physic, short x_offset, short y_offset);

/**
 * @param GFX_Picture_Physic* pointer
 * @param x
 * @param y
 */
void gfx_picture_physic_set_position(GFX_Picture_Physic *gfx_picture_physic, short x, short y);

// TODO : remove useless
// void gfx_picture_physic_hide(GFX_Picture_Physic *gfx_picture_physic);

/**
 * @param GFX_Picture_Physic* pointer
 * @param shrunk Factor
 */
void gfx_picture_physic_shrunk(GFX_Picture_Physic *gfx_image_physic, WORD shrunk_value); // todo (minor) - shrunk box

  /*----------------------*/
 /* -gfx_animated_sprite */
/*----------------------*/
/**
 * @param GFX_Animated_Sprite_Physic* GFX_Animated_Sprite_Physic pointer
 * @param paletteInfo* pointer to DATLib structure
 * @param witdh of the physic box
 * @param height of the physic box
 * @param width offset to reduce physic box
 * @param height offset to reduce physic box
 */
void gfx_animated_sprite_physic_init(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  spriteInfo *si,
  paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
);

/**
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite pointer
 * @param spriteInfo* spriteInfo pointer to DATLib structure
 * @param paletteInfo* paletteInfo pointer to DATLib structure
 */
void gfx_animated_sprite_init(GFX_Animated_Sprite *gfx_animated_sprite ,spriteInfo *si, paletteInfo *pali);

/**
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite pointer
 * @param x position
 * @param y position
 * @param anim DATLib macro
 */
void gfx_animated_sprite_display(GFX_Animated_Sprite *gfx_animated_sprite, short x, short y, WORD anim);

/**
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite pointer
 * @param x offset
 * @param y offset
 */
#define gfx_animated_sprite_move(gfx_animated_sprite, x_offset, y_offset) aSpriteMove(gfx_animated_sprite.as, x_offset, y_offset)

/**
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite pointer
 * @param x
 * @param y
 */
#define gfx_animated_sprite_set_position(gfx_animated_sprite, x, y) aSpriteSetPos(gfx_animated_sprite.as, x, y)

/**
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite pointer
 */
void gfx_animated_sprite_hide(GFX_Animated_Sprite *gfx_animated_sprite);

/**
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite pointer
 */
void gfx_animated_sprite_show(GFX_Animated_Sprite *gfx_animated_sprite);

/**
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite_Physic pointer
 * @param anim DATLib macro
 */
#define gfx_animated_sprite_physic_set_animation(gfx_animated_sprite_physic, anim) gfx_animated_sprite_set_animation(gfx_animated_sprite_physic.gfx_animated_sprite, anim)

/**
 * \brief refresh animation frame
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite pointer
 */
#define gfx_animated_sprite_animate(gfx_animated_sprite) aSpriteAnimate(gfx_animated_sprite.as)

/**
 * \brief destroy animated sprite
 * @param GFX_Animated_Sprite* GFX_Animated_Sprite pointer
 * \return void
*/
void gfx_animated_sprite_destroy(GFX_Animated_Sprite *gfx_animated_sprite);

  /*------------------------------*/
 /* -gfx_animated_sprite_physic  */
/*------------------------------*/
/**
 * @param GFX_Animated_Sprite_Physic* GFXAnimated_Sprite_Physic pointer
 * @param x
 * @param y
 * @param anim DATLib macro
 */
void gfx_animated_sprite_physic_display(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x, short y, WORD anim);
// void animated_sprite_physic_collide(aSpritePhysic *asp, Box *box); // todo - not implementd ??? needed ???

/**
 * @param GFX_Animated_Sprite_Physic* GFX_Animated_Sprite_Physic pointer
 * @param x
 * @param y
 */
void gfx_animated_sprite_physic_set_position(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x, short y);

/**
 * @param GFX_Animated_Sprite_Physic* GFX_Animated_Sprite_Physic pointer
 * @param x offset
 * @param y offset
 */
void gfx_animated_sprite_physic_move(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, short x_offset, short y_offset);

/**
 * @param GFX_Animated_Sprite_Physic* GFX_Animated_Sprite_Physic pointer
 * @param shrunk use shrunk_forge function for make a WORD with width & heigh value
 */
void gfx_animated_sprite_physic_shrunk(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, WORD shrunk_value); // todo (minor)

/**
 * \brief hide a GFX_Animated_Sprite_Physic
 * @param GFX_Animated_Sprite_Physic* GFX_Animated_Sprite_Physic pointer
 */
void gfx_animated_sprite_physic_hide(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

/**
 * \brief show a GFX_Animated_Sprite_Physic
 * @param GFX_Animated_Sprite_Physic* GFX_Animated_Sprite_Physic pointer
 */
void gfx_animated_sprite_physic_show(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

/**
 * \brief destroy GFX_Animated_Sprite_Physic
 * @param GFX_Animated_Sprite_Physic* GFX_Animated_Sprite_Physic pointer
 */
void gfx_animated_sprite_physic_destroy(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

/**
 * \brief init gpu
 */
void inline gpu_init();

/**
 * @param index
 * \return WORD a proportionnal value (shrink x, y) from an index of precalculated table
 */
WORD        get_shrunk_proportional_table(WORD index);

/**
 * @param index
 */
char        get_sin(WORD index);

/**
 * \brief return max free sprite index
 * \return WORD
 */
WORD        get_max_free_sprite_index();

/**
 * \brief return max sprite index used
 * \return WORD
 */
WORD        get_max_sprite_index_used();

/**
 * \brief return max free palette index
 * \return WORD
 */
WORD      get_max_free_palette_index();

/**
 * \brief return max palette index used
 * \return WORD
 */
 WORD     get_max_palette_index_used();



/**
 * \brief return picture info from GFX_Image
 * @param GFX_Image struct GFX_Image
 * \return struct
*/
#define get_gfx_image_pictureInfo(gfx_image) gfx_image.pi

/**
 * \brief return palette info from GFX_Image
 * @param GFX_Image struct GFX_Image
 * \return struct
*/
#define get_gfx_image_paletteInfo(gfx_image) gfx_image.pali

/**
 * \brief return baseSprite from GFX_Image
 * @param GFX_Image struct GFX_Image
 * \return WORD
*/
#define get_gfx_image_baseSprite(gfx_image) gfx_image.pic.baseSprite

/**
 * \brief return tileWitdh from GFX_Image
 * @param GFX_Image struct GFX_Image
 * \return WORD
*/
#define get_gfx_image_tileWidth(gfx_image) gfx_image.pic.info->tileWidth

/**
 * \brief return posX from GFX_Image
 * @param GFX_Image struct GFX_Image
 * \return short
*/
#define get_gfx_image_position_x(gfx_image) gfx_image.pic.posX

/**
 * \brief return posY from GFX_Image
 * @param GFX_Image struct GFX_Image
 * \return short
*/
#define get_gfx_image_position_y(gfx_image) gfx_image.pic.posY

  /*---------------*/
 /* -gfx_scroller */
/*---------------*/
/**
 * @param GFX_Scroller* Pointer
 * @param scrollerInfo* Pointer to DATLib structure
 * @param paletteInfo* Pointer to DATLib structure
 */
void        gfx_scroller_init(GFX_Scroller *s, scrollerInfo *si, paletteInfo *pali);

/**
 * @param GFX_Scroller* Pointer
 * @param x
 * @param y
 */
void        gfx_scroller_display(GFX_Scroller *s, short x, short y);

/**
 * @param GFX_Scroller* Pointer
 * @param x offset
 * @param y offset
 */
void        gfx_scroller_move(GFX_Scroller *s, short x, short y);

/**
 * \brief GFX_Scroller destroy
 * @param GFX_Scroller* pointer
 */
void       gfx_scroller_destroy(GFX_Scroller *s);

  //--------------------------------------------------------------------------//
 //                                  -I                                      //
//--------------------------------------------------------------------------//

  //--------------------------------------------------------------------------//
 //                                  -J                                      //
//--------------------------------------------------------------------------//
  /*----------*/
 /* -joypad  */
/*----------*/
void        joypad_update();
void        joypad_update_edge();
BOOL        joypad_is_up();
BOOL        joypad_is_down();
BOOL        joypad_is_left();
BOOL        joypad_is_right();
BOOL        joypad_is_start();
BOOL        joypad_is_a();
BOOL        joypad_is_b();
BOOL        joypad_is_c();
BOOL        joypad_is_d();
void inline joypad_debug();

  //--------------------------------------------------------------------------//
 //                                  -L                                       //
//--------------------------------------------------------------------------//
  /*----------*/
 /* -logger  */
/*----------*/
void        logger_init();
void        logger_set_position(WORD _x, WORD _y);
WORD inline logger_info(char *txt);
void inline logger_word(char *label, WORD value);
void inline logger_int(char *label, int value);
void inline logger_dword(char *label, DWORD value);
void inline logger_short(char *label, short value);
void inline logger_byte(char *label, BYTE value);
void inline logger_bool(char *label, BOOL value);
void inline logger_animated_sprite(char *label, GFX_Animated_Sprite *gfx_animated_sprite);
void inline logger_spriteInfo(char *label, spriteInfo *si);
void inline logger_box(char *label, Box *b);
void inline logger_pictureInfo(char *label, pictureInfo *pi);

  //--------------------------------------------------------------------------//
 //                                  -P                                      //
//--------------------------------------------------------------------------//
/**
 * \brief palette destroy
 * @param paletteInfo*
 */
void palette_destroy(paletteInfo* pi);

  //--------------------------------------------------------------------------//
 //                                  -M                                      //
//--------------------------------------------------------------------------//
//void mask_display(picture pic[], Vec2short vec[], BYTE vector_max); // todo (minor) - rename ? (vectorsDisplay)
void mask_update(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max); // todo (minor) - rename ? (vectorsDebug)
// todo (minor) - hardcode point\dot asset

  //--------------------------------------------------------------------------//
 //                                  -V                                      //
//--------------------------------------------------------------------------//
/**
 * \brief init a Vec2int structure
 * @param Vect2int* Pointer
 * @param x
 * @param y
 */
void vec2int_init(Vec2int *vec, int x, int y);

/**
 * \brief init a Vec2short structure
 * @param Vect2short* Pointer
 * @param x
 * @param y
 */
void vec2short_init(Vec2short *vec, short x, short y);

/**
 * \brief init a Vec2byte structure
 * @param Vect2byte* Pointer
 * @param x
 * @param y
 */
void vec2byte_init(Vec2byte *vec, BYTE x, BYTE y);

/**
 * @param Box* Pointer
 * @param Vec2short[] List
 * @param max Quantity list
 */
BOOL vectors_collide(Box *box, Vec2short vec[], BYTE vector_max);

/**
 * @param x Coord 1
 * @param y Coord 1
 * @param x Coord 2
 * @param y Coord 2
 * @param x Coord 3
 * @param y Coord 3
 */
BOOL vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

  //--------------------------------------------------------------------------//
 //                                  -S                                      //
//--------------------------------------------------------------------------//
  /*-----------*/
 /* -shrunk   */
/*-----------*/
/**
 * @param x Center position
 * @param y Center position
 * @param width Tile width
 * @param shrunkX Shrunk width factor
 * \return int
 */
int         shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX);

/**
 * @param x Center position
 * @param y Center position
 * @param width Tile width
 * @param shrunkY Shrunk height factor
 * \return int
 */
int         shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY);

/**
 * @param index Base sprite index
 * @param width Shrunk width factor
 * @param value
 */
void        shrunk(WORD base_sprite, WORD max_width, WORD value);

/**
 * @param x Shrunk width factor
 * @param y Shrunk height factor
 * \return WORD
 */
WORD        shrunk_forge(BYTE xc, BYTE yc);

/**
 * @param addr
 * @param value Shrunk factor
 */
void inline shrunk_addr(WORD addr, WORD shrunk_value);

/**
 * @param addr Address start
 * @param addr Adress end
 * @param value Shrunk factor
 */
WORD        shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

  //--------------------------------------------------------------------------//
 //                                  -W                                      //
//--------------------------------------------------------------------------//
/**
 * @param vbl Number of frames to wait
 */
DWORD inline wait_vbl_max(WORD nb);
#define wait_vbl(); waitVBlank();

#endif
