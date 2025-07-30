/*
  David Vandensteen
*/

  //--------------------------------------------------------------------------//
 //                             DEFINE                                       //
//--------------------------------------------------------------------------//

#ifndef NEOCORE_H
#define NEOCORE_H

#include <DATlib.h>
#include <math.h>

#define SHRUNK_TABLE_PROP_SIZE 0x2fe

#define MANUALBOX 0
#define AUTOBOX 1

enum Direction { NONE, UP, DOWN, LEFT, RIGHT };
enum Sound_state { IDLE, PLAYING };

  //--------------------------------------------------------------------------//
 //                          STRUCTURE                                       //
//--------------------------------------------------------------------------//

/**
 * @brief 2D position coordinates
 * @details Simple coordinate pair using signed 16-bit values for Neo Geo display positioning
 *
 * @struct Position
 * @var Position::x
 * Horizontal coordinate in pixels (signed, can be negative for off-screen positioning)
 * @var Position::y
 * Vertical coordinate in pixels (signed, can be negative for off-screen positioning)
 *
 * @note Coordinates are in pixels, origin at top-left of Neo Geo display (320x224)
 * @since 1.0.0
 */
typedef struct Position { short x; short y; } Position;
typedef char Hex_Color[3]; // TODO : useless ?

//void mask_display(picture pic[], Position vec[], BYTE vector_max); // todo (minor) - rename ? (vectorsDisplay)
void nc_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max); // todo (minor) - rename ? (vectorsDebug)
typedef char Hex_Packed_Color[5]; // TODO : useless ?

/**
 * @brief Collision detection bounding box
 * @details Axis-aligned bounding box with 5 corner points and dimension information for physics collision detection
 *
 * @struct Box
 * @var Box::p0 Top-left corner position
 * @var Box::p1 Top-right corner position
 * @var Box::p2 Bottom-right corner position
 * @var Box::p3 Bottom-left corner position
 * @var Box::p4 Center point (automatically calculated)
 * @var Box::width Box width in pixels
 * @var Box::height Box height in pixels
 * @var Box::widthOffset Horizontal offset from sprite origin
 * @var Box::heightOffset Vertical offset from sprite origin
 *
 * @note Corner points are calculated by nc_update_box() based on position and offsets
 * @warning Manual modification of corner points will be overwritten by nc_update_box()
 * @since 1.0.0
 *
 * @see nc_update_box(), nc_collide_box(), nc_init_box()
 */
typedef struct Box {
  Position p0;
  Position p1;
  Position p2;
  Position p3;
  Position p4;
  short width;
  short height;
  short widthOffset;
  short heightOffset;
} Box;

/**
 * @brief Animated sprite graphics object
 * @details Wrapper for DATlib animated sprite with associated palette information
 *
 * @struct GFX_Animated_Sprite
 * @var GFX_Animated_Sprite::aSpriteDAT DATlib animated sprite data structure
 * @var GFX_Animated_Sprite::spriteInfoDAT Pointer to sprite metadata (frame count, dimensions, etc.)
 * @var GFX_Animated_Sprite::paletteInfoDAT Pointer to palette information for sprite rendering
 *
 * @note spriteInfoDAT and paletteInfoDAT must remain valid during object lifetime
 * @since 1.0.0
 *
 * @see nc_init_gfx_animated_sprite(), nc_display_gfx_animated_sprite()
 */
typedef struct GFX_Animated_Sprite {
  aSprite aSpriteDAT;
  const spriteInfo *spriteInfoDAT;
  const paletteInfo *paletteInfoDAT;
} GFX_Animated_Sprite;

typedef struct GFX_Picture {
  picture pictureDAT;
  const pictureInfo *pictureInfoDAT;
  const paletteInfo *paletteInfoDAT;
  WORD pixel_height;
  WORD pixel_width;
} GFX_Picture;

typedef struct GFX_Animated_Sprite_Physic {
  GFX_Animated_Sprite gfx_animated_sprite;
  Box box;
  BOOL physic_enabled;
} GFX_Animated_Sprite_Physic;

typedef struct GFX_Picture_Physic {
  GFX_Picture gfx_picture;
  Box box;
  BOOL autobox_enabled;
  BOOL physic_enabled;
} GFX_Picture_Physic;

typedef struct GFX_Scroller {
  scroller scrollerDAT;
  const scrollerInfo *scrollerInfoDAT;
  const paletteInfo *paletteInfoDAT;
} GFX_Scroller;

typedef struct Adpcm_player {
  enum Sound_state state;
  DWORD remaining_frame;
} Adpcm_player;

/**
 * @brief Neo Geo RGB color representation with darkness level
 * @details 16-bit color format using 4-bit fields for dark, red, green, and blue components.
 *          Matches Neo Geo hardware color format for direct palette manipulation.
 *
 * @struct RGB16
 * @var RGB16::dark Darkness level (0-15, where 0=darkest, 15=brightest)
 * @var RGB16::r Red component intensity (0-15)
 * @var RGB16::g Green component intensity (0-15)
 * @var RGB16::b Blue component intensity (0-15)
 *
 * @note Bit-field layout matches Neo Geo palette hardware format
 * @warning Bit-field packing is compiler-dependent - use with consistent compiler settings
 * @since 2.8.0
 *
 * @see nc_rgb16_to_packed_color16(), nc_packet_color16_to_rgb16()
 */
typedef struct RGB16 {
  BYTE dark : 4, r : 4, g : 4, b : 4;
} RGB16;

  //--------------------------------------------------------------------------//
 //                                   GFX                                    //
//--------------------------------------------------------------------------//

  /*------------------*/
 /*  GFX INIT        */
/*------------------*/

/**
 * @brief Initialize an animated sprite graphics object
 * @details Sets up a GFX_Animated_Sprite structure for rendering animated sprites on Neo Geo hardware.
 *          Automatically handles DATlib integration and prepares the sprite for display.
 *
 * @param[out] gfx_animated_sprite Pointer to GFX_Animated_Sprite structure to initialize
 * @param[in] spriteInfo Pointer to DATlib sprite information (must not be NULL)
 * @param[in] paletteInfo Pointer to DATlib palette information (must not be NULL)
 *
 * @note Calls init_shadow_system() internally to prepare Neo Geo graphics subsystem
 * @warning spriteInfo and paletteInfo must remain valid during object lifetime
 * @since 1.0.0
 *
 * @see nc_display_gfx_animated_sprite(), nc_destroy_gfx_animated_sprite()
 */
void nc_init_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo
);

void nc_init_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
);

/**
 * @brief Initialize a picture graphics object
 * @details Sets up a GFX_Picture structure for rendering static images on Neo Geo hardware.
 *          Automatically calculates pixel dimensions and prepares for display.
 *
 * @param[out] gfx_picture Pointer to GFX_Picture structure to initialize
 * @param[in] pictureInfo Pointer to DATlib picture information (must not be NULL)
 * @param[in] paletteInfo Pointer to DATlib palette information (must not be NULL)
 *
 * @note Calls init_shadow_system() internally and calculates pixel_width/pixel_height automatically
 * @warning pictureInfo and paletteInfo must remain valid during object lifetime
 * @since 1.0.0
 *
 * @see nc_display_gfx_picture(), nc_destroy_gfx_picture()
 */
void nc_init_gfx_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo
);

void nc_init_gfx_picture_physic(
  GFX_Picture_Physic *gfx_picture_physic,
  const pictureInfo *pi,
  const paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
);

void nc_init_gfx_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo
);

  /*------------------*/
 /*  GFX DISPLAY     */
/*------------------*/

void nc_display_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x,
  short y,
  WORD anim
);

void nc_display_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x,
  short y,
  WORD anim
);

void nc_display_gfx_picture(GFX_Picture *gfx_picture, short x, short y);
void nc_display_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x, short y);
void nc_display_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);

  /*-----------------------*/
 /*  GFX INIT DISPLAY     */
/*-----------------------*/

void nc_init_display_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y,
  WORD anim
);

void nc_init_display_gfx_animated_sprite_physic(
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
);

void nc_init_display_gfx_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
);

void nc_init_display_gfx_picture_physic(
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
);

void nc_init_display_gfx_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
);

  /*------------------*/
 /*  GFX VISIBILITY  */
/*------------------*/

void nc_hide_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void nc_hide_gfx_picture(GFX_Picture *gfx_picture);
void nc_hide_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);
void nc_hide_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

void nc_show_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);
void nc_show_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);
void nc_show_gfx_picture(GFX_Picture *gfx_picture);
void nc_show_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);

  /*------------------*/
 /*  GFX POSITION    */
/*------------------*/

/* GFX POSITION GETTER */

void nc_get_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, Position *position);
void nc_get_position_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  Position *position
);
void nc_get_position_gfx_picture(GFX_Picture *gfx_picture, Position *position);
void nc_get_position_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, Position *position);
void nc_get_position_gfx_scroller(GFX_Scroller *gfx_scroller, Position *position);

/* GFX POSITION SETTER */

void nc_set_position_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x, short y);

void nc_set_position_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x,
  short y
);

void nc_set_position_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);
void nc_set_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, short x, short y);
void nc_set_position_gfx_picture(GFX_Picture *gfx_picture, short x, short y);

/* GFX POSITION MOVE*/

void nc_move_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, short x_offset, short y_offset);

void nc_move_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  short x_offset,
  short y_offset
);

void nc_move_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x_offset,
  short y_offset
);

void nc_move_gfx_picture(GFX_Picture *gfx_picture, short x, short y);
void nc_move_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);

  /*-------------------*/
 /*  GFX SHRUNK       */
/*-------------------*/

#define nc_shrunk_extract_x(value) value >> 8
#define nc_shrunk_extract_y(value) (BYTE)value

void nc_shrunk_centroid_gfx_picture(
  GFX_Picture *gfx_picture,
  short center_x,
  short center_y,
  WORD shrunk_value
);

  /*-------------------*/
 /*  GFX ANIMATION    */
/*-------------------*/

void nc_set_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, WORD anim);

void nc_set_animation_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic,
  WORD anim
);

void nc_update_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void nc_update_animation_gfx_animated_sprite_physic(
  GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic
);

  /*-------------------*/
 /*  GFX DESTROY      */
/*-------------------*/

void nc_destroy_gfx_scroller(GFX_Scroller *gfx_scroller);
void nc_destroy_gfx_picture(GFX_Picture *gfx_picture);
void nc_destroy_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

void nc_destroy_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic);
void nc_destroy_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

  //--------------------------------------------------------------------------//
 //                                   GPU                                    //
//--------------------------------------------------------------------------//

void nc_init_gpu();
void nc_clear_vram();

  /*------------------------------*/
 /* GPU VBL                      */
/*------------------------------*/

/**
 * @brief Wait for vertical blank interrupt
 * @details Synchronizes with Neo Geo display refresh (60Hz NTSC / 50Hz PAL).
 *          Essential for smooth animation and preventing screen tearing.
 *
 * @note This is a macro that expands to waitVBlank() from DATlib
 * @warning Blocking operation - execution pauses until next VBL
 * @since 1.0.0
 *
 * @see nc_wait_vbl_max(), nc_update()
 */
#define nc_wait_vbl() waitVBlank();
void nc_update();
DWORD nc_wait_vbl_max(WORD nb);

  /*------------------------------*/
 /* GPU SPRITE INDEX MANAGEMENT  */
/*------------------------------*/

void nc_clear_sprite_index_table();
WORD nc_get_max_free_sprite_index();
WORD nc_get_max_sprite_index_used();

  /*---------------*/
 /* GPU PALETTE   */
/*---------------*/

void nc_destroy_palette(const paletteInfo* paletteInfo);
void nc_clear_palette_index_table();
WORD nc_get_max_free_palette_index();
WORD nc_get_max_palette_index_used();
void nc_read_palette_rgb16(BYTE palette_number, BYTE palette_index, RGB16 *rgb_color);
void nc_packet_color16_to_rgb16(WORD packed_color, RGB16 *rgb_color);

/**
 * @brief Convert RGB16 color structure to packed 16-bit color
 * @details Packs RGB16 structure into Neo Geo hardware palette format (16-bit word).
 *          Bit layout: [DARK:4][RED:4][GREEN:4][BLUE:4]
 *
 * @param color RGB16 structure with color components
 * @return 16-bit packed color value for Neo Geo palette
 *
 * @note Each component is masked to 4 bits for safety
 * @warning Evaluates color parameter multiple times - avoid side effects
 * @since 2.8.0
 *
 * @see nc_packet_color16_to_rgb16(), nc_set_palette_by_rgb16()
 */
#define nc_rgb16_to_packed_color16(color) \
  ((((color.dark) & 0xF) << 12) | (((color.r) & 0xF) << 8) | (((color.g) & 0xF) << 4) | ((color.b) & 0xF))

/**
 * @brief Set palette entry using packed 16-bit color
 * @details Directly writes to Neo Geo palette memory at calculated hardware address.
 *          Palette memory starts at 0x400000 with specific addressing scheme.
 *
 * @param palette_number Palette number (0-255)
 * @param palette_index Color index within palette (0-15)
 * @param color Packed 16-bit color value
 *
 * @note Uses do-while(0) pattern for safe macro expansion
 * @warning Direct hardware access - ensure valid palette parameters
 * @since 2.8.0
 *
 * @see nc_set_palette_by_rgb16(), nc_get_palette_packed_color16()
 */
#define nc_set_palette_by_packed_color16(palette_number, palette_index, color) \
  do { \
    int address = 0x400000 | ((palette_number) << 5) | ((palette_index) << 1); \
    volMEMWORD(address) = (color); \
  } while (0)

/**
 * @brief Set palette entry using RGB16 color structure
 * @details Convenience macro that converts RGB16 to packed format and sets palette entry.
 *          Combines nc_rgb16_to_packed_color16() and nc_set_palette_by_packed_color16().
 *
 * @param palette_number Palette number (0-255)
 * @param palette_index Color index within palette (0-15)
 * @param color RGB16 structure with color components
 *
 * @note More convenient than manual conversion for RGB16 colors
 * @warning Direct hardware access - ensure valid parameters
 * @since 2.8.0
 *
 * @see nc_rgb16_to_packed_color16(), nc_set_palette_by_packed_color16()
 */
#define nc_set_palette_by_rgb16(palette_number, palette_index, color) \
  do { \
    WORD packed_color = nc_rgb16_to_packed_color16(color); \
    nc_set_palette_by_packed_color16(palette_number, palette_index, packed_color); \
  } while (0)

#define nc_get_palette_packed_color16(palette_number, palette_index) \
  ({ \
    int address = 0x400000 | ((palette_number) << 5) | ((palette_index) << 1); \
    volMEMWORD(address); \
  })

#define nc_set_palette_backdrop_by_packed_color16(packed_color) \
  do { \
    int address = 0x401FFE; \
    volMEMWORD(address) = (packed_color); \
  } while (0)

#define nc_set_palette_backdrop_by_rgb16(color) \
  do { \
    WORD packed_color = nc_rgb16_to_packed_color16(color); \
    nc_set_palette_backdrop_by_packed_color16(packed_color); \
  } while (0)

  /*--------------*/
 /* GPU shrunk   */
/*--------------*/

WORD nc_get_shrunk_proportional_table(WORD index);
int nc_shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX);
int nc_shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY);
void nc_shrunk(WORD base_sprite, WORD max_width, WORD value);
WORD nc_shrunk_forge(BYTE xc, BYTE yc);
void nc_shrunk_addr(WORD addr, WORD shrunk_value);
WORD nc_shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

  //--------------------------------------------------------------------------//
 //                                MATH                                      //
//--------------------------------------------------------------------------//

/**
 * @brief Fast division by 2 using bit shifting
 * @details Divides value by 2 using right bit shift for optimal performance on 68k processor
 *
 * @param value Value to divide (any integer type)
 * @return value / 2
 *
 * @note Equivalent to (value / 2) but faster on Neo Geo hardware
 * @warning For signed values, behavior with negative numbers follows arithmetic right shift
 * @since 1.0.0
 */
#define nc_bitwise_division_2(value) (value >> 1)

/**
 * @brief Fast division by 4 using bit shifting
 * @param value Value to divide
 * @return value / 4
 * @note Optimized for Neo Geo 68k processor
 * @since 1.0.0
 */
#define nc_bitwise_division_4(value) (value >> 2)

/**
 * @brief Fast division by 8 using bit shifting
 * @param value Value to divide
 * @return value / 8
 * @note Optimized for Neo Geo 68k processor
 * @since 1.0.0
 */
#define nc_bitwise_division_8(value) (value >> 3)
#define nc_bitwise_division_16(value) (value >> 4)
#define nc_bitwise_division_32(value) (value >> 5)
#define nc_bitwise_division_64(value) (value >> 6)
#define nc_bitwise_division_128(value) (value >> 7)
#define nc_bitwise_division_256(value) (value >> 8)

#define nc_bitwise_multiplication_2(value) (value << 1)
#define nc_bitwise_multiplication_4(value) (value << 2)
#define nc_bitwise_multiplication_8(value) (value << 3)
#define nc_bitwise_multiplication_16(value) (value << 4)
#define nc_bitwise_multiplication_32(value) (value << 5)
#define nc_bitwise_multiplication_64(value) (value << 6)
#define nc_bitwise_multiplication_128(value) (value << 7)
#define nc_bitwise_multiplication_256(value) (value << 8)

/**
 * @brief Generate random number within specified range
 * @details Uses standard rand() function with modulo operation for range limiting
 *
 * @param range Maximum value (exclusive) - result will be 0 to range-1
 * @return Random number from 0 to range-1
 *
 * @warning Use srand() to seed random number generator before first use
 * @note Distribution may not be perfectly uniform for ranges that don't divide evenly into RAND_MAX
 * @since 1.0.0
 */
#define nc_random(range) rand() % range

/**
 * @brief Get minimum of two values
 * @details Safe macro implementation that evaluates arguments only once
 *
 * @param a First value to compare
 * @param b Second value to compare
 * @return Smaller of the two values
 *
 * @note Works with any comparable type (int, float, etc.)
 * @since 1.0.0
 */
#define nc_min(a,b) ((a) < (b) ? (a) : (b))

/**
 * @brief Get maximum of two values
 * @details Safe macro implementation that evaluates arguments only once
 *
 * @param a First value to compare
 * @param b Second value to compare
 * @return Larger of the two values
 *
 * @note Works with any comparable type (int, float, etc.)
 * @since 1.0.0
 */
#define nc_max(a,b) ((a) > (b) ? (a) : (b))

/**
 * @brief Get absolute value of a number
 * @details Optimized implementation using bitwise operations for negative numbers
 *
 * @param num Number to get absolute value of
 * @return Absolute value of num
 *
 * @warning May have side effects if num is a function call or expression with side effects
 * @note Uses two's complement arithmetic for negative number handling
 * @since 1.0.0
 */
#define nc_abs(num) ((num) < 0 ? ~(num) + 1 : (num))
#define nc_negative(num) -num

#define nc_fix(num) num * 65536
#define nc_fix_to_int(num) fixtoi(num)
#define nc_int_to_fix(num) itofix(num)
#define nc_fix_add(num1, num2) fadd(num1, num2)
#define nc_fix_sub(num1, num2) fsub(num1, num2)
#define nc_fix_mul(num1, num2) fmul(num1, num2)
#define nc_cos(num) fcos(num)
#define nc_tan(num) ftan(num)

void nc_byte_to_hex(BYTE value, char *hexchar);
void nc_word_to_hex(WORD value, char *hexchar);
char nc_sin(WORD index);

  //--------------------------------------------------------------------------//
 //                                PHYSIC                                    //
//--------------------------------------------------------------------------//

/**
 * @brief Copy one bounding box to another
 * @details Efficiently copies all data from source box to destination box using memcpy
 *
 * @param box_src Source box to copy from
 * @param box_dest Destination box to copy to
 *
 * @note This is a macro that expands to memcpy for performance
 * @warning No bounds checking - ensure both parameters are valid Box pointers
 * @since 1.0.0
 */
#define nc_copy_box(box_src, box_dest) memcpy(box_dest, box_src, sizeof(Box))

/**
 * @brief Test collision between one box and an array of boxes
 * @details Checks if the given box collides with any box in the provided array.
 *          Returns the index of the first colliding box found.
 *
 * @param[in] box Box to test for collisions (must not be NULL)
 * @param[in] boxes Array of box pointers to test against (must not be NULL)
 * @param[in] box_max Number of boxes in the array
 *
 * @return Index of first colliding box, or NONE if no collision detected
 * @retval 0-255 Index of colliding box
 * @retval NONE No collision found
 *
 * @warning No NULL pointer validation - caller must ensure valid pointers
 * @note Uses nc_collide_box() internally for individual collision tests
 * @since 1.0.0
 *
 * @see nc_collide_box(), NONE
 */
BYTE nc_collide_boxes(Box *box, Box *boxes[], BYTE box_max);

/**
 * @brief Test collision between two bounding boxes
 * @details Performs axis-aligned bounding box (AABB) collision detection using
 *          corner points p0, p1, and p3 for overlap testing.
 *
 * @param[in] box1 First bounding box (must not be NULL)
 * @param[in] box2 Second bounding box (must not be NULL)
 *
 * @return true if boxes overlap, false otherwise
 * @retval true Boxes are overlapping or touching
 * @retval false Boxes are completely separate
 *
 * @warning No NULL pointer validation - caller must ensure valid pointers
 * @note Algorithm checks for overlap in both X and Y axes simultaneously
 * @since 1.0.0
 *
 * @see nc_collide_boxes(), nc_update_box()
 */
BOOL nc_collide_box(Box *box1, Box *box2);

/**
 * @brief Initialize a bounding box with dimensions and offsets
 * @details Sets up box dimensions and offset values. Corner points are not calculated
 *          until nc_update_box() is called with position coordinates.
 *
 * @param[out] box Pointer to Box structure to initialize (must not be NULL)
 * @param[in] width Box width in pixels
 * @param[in] height Box height in pixels
 * @param[in] widthOffset Horizontal offset from sprite origin
 * @param[in] heightOffset Vertical offset from sprite origin
 *
 * @note Corner points (p0-p4) are not set - call nc_update_box() to calculate positions
 * @warning No NULL pointer validation - caller must ensure valid box pointer
 * @since 1.0.0
 *
 * @see nc_update_box()
 */
void nc_init_box(Box *box, short width, short height, short widthOffset, short heightOffset);

/**
 * @brief Update bounding box corner positions based on world coordinates
 * @details Calculates all corner points (p0-p4) based on the given position and
 *          the box's stored dimensions and offsets.
 *
 * @param[in,out] box Pointer to Box structure to update (must not be NULL)
 * @param[in] x World X coordinate for box positioning
 * @param[in] y World Y coordinate for box positioning
 *
 * @note Automatically calculates center point (p4) using bitwise division for performance
 * @warning No NULL pointer validation - caller must ensure valid box pointer
 * @since 1.0.0
 *
 * @see nc_init_box(), nc_collide_box()
 */
void nc_update_box(Box *box, short x, short y);

void nc_shrunk_box(Box *box, Box *bOrigin, WORD shrunkValue);
void nc_resize_box(Box *Box, short edge); // todo (minor) - deprecated ?

  //--------------------------------------------------------------------------//
 //                                SOUND                                     //
//--------------------------------------------------------------------------//

  //---------
 //    CDDA
//-----------

void nc_play_cdda(BYTE track);
void nc_pause_cdda();
void nc_resume_cdda();
#define nc_stop_cdda() nc_pause_cdda()

  //--------
 //  ADPCM
//----------

void nc_stop_adpcm();

  //----------------------------------------------------------------------------//
 //                                  JOYPAD                                    //
//----------------------------------------------------------------------------//

void nc_set_joypad_edge_mode(BOOL actived);
void nc_update_joypad(BYTE id);
void nc_joypad_update(BYTE id);

BOOL nc_joypad_is_up(BYTE id);
BOOL nc_joypad_is_down(BYTE id);
BOOL nc_joypad_is_left(BYTE id);
BOOL nc_joypad_is_right(BYTE id);
BOOL nc_joypad_is_start(BYTE id);
BOOL nc_joypad_is_a(BYTE id);
BOOL nc_joypad_is_b(BYTE id);
BOOL nc_joypad_is_c(BYTE id);
BOOL nc_joypad_is_d(BYTE id);

void nc_debug_joypad(BYTE id);

  //----------------------------------------------------------------------------//
 //                                  UTIL                                      //
//----------------------------------------------------------------------------//

DWORD nc_frame_to_second(DWORD frame);
DWORD nc_second_to_frame(DWORD second);
void nc_init_system();
void nc_reset();
// Position nc_get_relative_position(Box box, Position world_coord); // TODO
void nc_pause(BOOL (*exitFunc)());
void nc_sleep(DWORD frame);
BOOL nc_each_frame(DWORD frame);
void nc_print(int x, int y, char *label);
WORD nc_free_ram_info();
#define nc_get_frame_counter() DAT_frameCounter

  /*---------------*/
 /* UTIL LOGGER   */
/*---------------*/

/**
 * @brief Initialize the logging system
 * @details Sets up the Neo Geo logging subsystem for debug output on screen.
 *          Must be called before using any logging functions.
 *
 * @note Initializes log cursor to default position (1, 2)
 * @since 3.0.0
 *
 * @see nc_set_position_log(), nc_log_info()
 */
void nc_init_log();

/**
 * @brief Get current horizontal log cursor position
 * @return Current X coordinate of log cursor
 * @since 2.9.0
 */
WORD nc_get_position_x_log();

/**
 * @brief Get current vertical log cursor position
 * @return Current Y coordinate of log cursor
 * @since 2.9.0
 */
WORD nc_get_position_y_log();

/**
 * @brief Set log cursor position
 * @details Moves the log cursor to specified screen coordinates for subsequent log output
 *
 * @param[in] _x Horizontal position (0-39 for 320px width)
 * @param[in] _y Vertical position (0-27 for 224px height)
 *
 * @note Coordinates are in character cells, not pixels
 * @since 2.9.0
 */
void nc_set_position_log(WORD _x, WORD _y);

/**
 * @brief Move log cursor to next line
 * @details Advances log cursor to beginning of next line, handles screen wrapping
 *
 * @note Automatically wraps to top of screen if at bottom
 * @since 3.0.0
 *
 * @see nc_log_info_line()
 */
void nc_log_next_line();

/**
 * @brief Log formatted text without automatic line break
 * @details Prints formatted text at current log cursor position using printf-style formatting.
 *          Does not automatically advance to next line - use nc_log_next_line() manually.
 *
 * @param[in] txt Format string (printf-style)
 * @param[in] ... Variable arguments for format string
 *
 * @return Number of characters in the format string
 *
 * @warning Buffer size limited to 256 characters - longer strings will be truncated
 * @note Use nc_log_info_line() for automatic line breaks
 * @since 2.9.0
 *
 * @see nc_log_info_line(), nc_log_next_line()
 */
WORD nc_log_info(char *txt, ...);

/**
 * @brief Log formatted text with automatic line break
 * @details Prints formatted text at current log cursor position and automatically
 *          advances to next line. Convenient for single-line log messages.
 *
 * @param[in] txt Format string (printf-style)
 * @param[in] ... Variable arguments for format string
 *
 * @return Number of characters in the format string
 *
 * @warning Buffer size limited to 256 characters - longer strings will be truncated
 * @since 3.0.0
 *
 * @see nc_log_info(), nc_log_next_line()
 */
WORD nc_log_info_line(char *txt, ...);

void nc_log_word(WORD value);
void nc_log_int(int value);
void nc_log_dword(DWORD value);
void nc_log_short(short value);
void nc_log_byte(BYTE value);
void nc_log_bool(BOOL value);
void nc_log_spriteInfo(spriteInfo *si);
void nc_log_box(Box *b);
void nc_log_pictureInfo(pictureInfo *pi);
void nc_log_position(Position position);
void nc_log_palette_info(paletteInfo *paletteInfo);
void nc_log_packed_color16(WORD packed_color);
void nc_log_rgb16(RGB16 *color);

  /*---------------*/
 /* SOUND         */
/*---------------*/

void nc_init_adpcm();
void nc_update_adpcm_player();
void nc_push_remaining_frame_adpcm_player(DWORD frame);
Adpcm_player *nc_get_adpcm_player();

  /*---------------*/
 /* UTIL VECTOR   */
/*---------------*/

BOOL nc_vectors_collide(Box *box, Position vec[], BYTE vector_max);
BOOL nc_vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

#endif
