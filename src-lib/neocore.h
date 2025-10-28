/**
 * @file neocore.h
 * @brief Core library for Neo Geo development
 * @details NeoCore is a comprehensive C library providing high-level APIs for Neo Geo game development.
 *          It abstracts complex hardware operations and provides modern, consistent interfaces for
 *          graphics, audio, input, physics, and system management.
 *
 * Key Features:
 * - Graphics: Sprite, picture, and scroller management with physics integration
 * - Audio: CDDA and ADPCM playback support
 * - Input: Joypad handling with edge detection
 * - Physics: Collision detection with bounding boxes
 * - Memory: Sprite and palette managers for automatic resource allocation
 * - Utilities: Math functions, logging, and debugging tools
 *
 * @author David Vandensteen
 * @version 3.1.1
 * @date October 21, 2025
 * @copyright Copyright (c) David Vandensteen. All rights reserved.
 * @since 1.0.0
 *
 * @see https://github.com/David-Vandensteen/neocore
 */

  //--------------------------------------------------------------------------//
 //                             DEFINE                                       //
//--------------------------------------------------------------------------//

#ifndef NEOCORE_H
#define NEOCORE_H

#include <DATlib.h>
#include <math.h>

/**
 * @defgroup Constants Core Constants
 * @brief Fundamental constants used throughout NeoCore library
 * @{
 */

/** @brief Size of the shrunk proportional lookup table
 *  @details Used for sprite scaling calculations in GPU operations
 */
#define SHRUNK_TABLE_PROP_SIZE 0x2fe

/** @brief Manual collision box mode
 *  @details Collision box coordinates are manually calculated and set
 */
#define MANUALBOX 0

/** @brief Automatic collision box mode  
 *  @details Collision box coordinates are automatically calculated from sprite dimensions
 */
#define AUTOBOX 1

/** @brief Automatic sprite ID for display functions
 *  @details Special value indicating sprite ID should be automatically managed
 */
#define DISPLAY_GFX_WITH_SPRITE_ID_AUTO 0xFFFF

/** @brief Return value when sprite index is not found
 *  @details Used by sprite manager functions when no valid index is available
 */
#define SPRITE_INDEX_NOT_FOUND 0xFFFF

/** @} */ // end of Constants group

/**
 * @defgroup Enumerations Core Enumerations
 * @brief Common enumeration types used across NeoCore modules
 * @{
 */

/**
 * @enum Direction
 * @brief Directional movement constants
 * @details Used for joypad input handling and sprite movement operations
 */
enum Direction { 
    NONE,   /**< No direction */
    UP,     /**< Up direction */
    DOWN,   /**< Down direction */
    LEFT,   /**< Left direction */
    RIGHT   /**< Right direction */
};

/**
 * @enum Sound_state
 * @brief Audio playback state enumeration
 * @details Represents the current state of audio playback for ADPCM sounds
 */
enum Sound_state { 
    IDLE,    /**< Audio is not playing */
    PLAYING  /**< Audio is currently playing */
};

/** @} */ // end of Enumerations group

  //--------------------------------------------------------------------------//
 //                          STRUCTURE                                       //
//--------------------------------------------------------------------------//

/**
 * @defgroup Structures Core Data Structures
 * @brief Fundamental data structures used throughout NeoCore library
 * @{
 */

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

//void mask_display(picture pic[], Position vec[], BYTE vector_max); // todo (minor) - rename ? (vectorsDisplay)

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
 * @note Corner points are calculated by nc_physic_update_box() based on position and offsets
 * @warning Manual modification of corner points will be overwritten by nc_physic_update_box()
 * @since 1.0.0
 *
 * @see nc_physic_update_box(), nc_physic_collide_box(), nc_physic_init_box()
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
 * @see nc_gfx_init_animated_sprite(), nc_gfx_display_animated_sprite()
 */
typedef struct GFX_Animated_Sprite {
  aSprite aSpriteDAT;
  const spriteInfo *spriteInfoDAT;
  const paletteInfo *paletteInfoDAT;
} GFX_Animated_Sprite;

/**
 * @brief Static picture graphics object
 * @details Wrapper for DATlib picture with associated palette and dimension information
 *
 * @struct GFX_Picture
 * @var GFX_Picture::pictureDAT DATlib picture data structure
 * @var GFX_Picture::pictureInfoDAT Pointer to picture metadata (dimensions, tile count, etc.)
 * @var GFX_Picture::paletteInfoDAT Pointer to palette information for picture rendering
 * @var GFX_Picture::pixel_height Picture height in pixels (calculated automatically)
 * @var GFX_Picture::pixel_width Picture width in pixels (calculated automatically)
 *
 * @note pixel dimensions are calculated during initialization
 * @since 1.0.0
 *
 * @see nc_gfx_init_picture(), nc_gfx_display_picture()
 */
typedef struct GFX_Picture {
  picture pictureDAT;
  const pictureInfo *pictureInfoDAT;
  const paletteInfo *paletteInfoDAT;
  WORD pixel_height;
  WORD pixel_width;
} GFX_Picture;

/**
 * @brief Physics-enabled animated sprite
 * @details Combines animated sprite with collision detection capabilities
 *
 * @struct GFX_Animated_Physic_Sprite
 * @var GFX_Animated_Physic_Sprite::gfx_animated_sprite Base animated sprite object
 * @var GFX_Animated_Physic_Sprite::box Collision detection bounding box
 * @var GFX_Animated_Physic_Sprite::physic_enabled Whether collision detection is active
 *
 * @note Box coordinates are automatically updated when sprite position changes
 * @since 3.1.1
 *
 * @see nc_gfx_init_animated_physic_sprite(), nc_physic_update_box()
 */
typedef struct GFX_Animated_Physic_Sprite {
  GFX_Animated_Sprite gfx_animated_sprite;
  Box box;
  BOOL physic_enabled;
} GFX_Animated_Physic_Sprite;

/**
 * @brief Physics-enabled picture object
 * @details Combines static picture with collision detection capabilities
 *
 * @struct GFX_Physic_Picture
 * @var GFX_Physic_Picture::gfx_picture Base picture object
 * @var GFX_Physic_Picture::box Collision detection bounding box
 * @var GFX_Physic_Picture::autobox_enabled Whether box dimensions are automatically calculated
 * @var GFX_Physic_Picture::physic_enabled Whether collision detection is active
 *
 * @note When autobox_enabled is true, box dimensions match picture dimensions
 * @since 3.1.1
 *
 * @see nc_gfx_init_physic_picture(), nc_physic_update_box()
 */
typedef struct GFX_Physic_Picture {
  GFX_Picture gfx_picture;
  Box box;
  BOOL autobox_enabled;
  BOOL physic_enabled;
} GFX_Physic_Picture;

/**
 * @brief Scroller graphics object
 * @details Wrapper for DATlib scroller with palette information for background scrolling
 *
 * @struct GFX_Scroller
 * @var GFX_Scroller::scrollerDAT DATlib scroller data structure
 * @var GFX_Scroller::scrollerInfoDAT Pointer to scroller metadata
 * @var GFX_Scroller::paletteInfoDAT Pointer to palette information for scroller rendering
 *
 * @since 1.0.0
 *
 * @see nc_gfx_init_scroller(), nc_gfx_display_scroller()
 */
typedef struct GFX_Scroller {
  scroller scrollerDAT;
  const scrollerInfo *scrollerInfoDAT;
  const paletteInfo *paletteInfoDAT;
} GFX_Scroller;

/**
 * @brief ADPCM audio player state
 * @details Tracks the current state and remaining playback time for ADPCM sound effects
 *
 * @struct Sound_Adpcm_Player
 * @var Sound_Adpcm_Player::state Current playback state (IDLE or PLAYING)
 * @var Sound_Adpcm_Player::remaining_frame Number of frames remaining in current sound
 *
 * @note Frame count is based on 60 FPS Neo Geo timing
 * @since 3.1.1
 *
 * @see nc_sound_get_adpcm_player(), nc_sound_update_adpcm_player()
 */
typedef struct Sound_Adpcm_Player {
  enum Sound_state state;
  DWORD remaining_frame;
} Sound_Adpcm_Player;

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

/** @} */ // end of Structures group

//--------------------------------------------------------------------------//
 //                                   GFX                                   //
//--------------------------------------------------------------------------//

/**
 * @defgroup GFX Graphics Functions
 * @brief High-level graphics operations for sprites, pictures, and scrollers
 * @details This module provides modern, consistent APIs for all graphics operations
 *          including initialization, display, positioning, and animation control.
 * @{
 */

/**
 * @defgroup GFXInit Graphics Initialization
 * @ingroup GFX
 * @brief Functions for initializing graphics objects (New API)
 * @{
 */

/**
 * @brief Initialize an animated sprite graphics object (New API)
 * @details Sets up a GFX_Animated_Sprite structure for rendering animated sprites on Neo Geo hardware.
 *          Automatically handles DATlib integration and prepares the sprite for display.
 *
 * @param[out] gfx_animated_sprite Pointer to GFX_Animated_Sprite structure to initialize
 * @param[in] spriteInfo Pointer to DATlib sprite information (must not be NULL)
 * @param[in] paletteInfo Pointer to DATlib palette information (must not be NULL)
 *
 * @note Calls init_shadow_system() internally to prepare Neo Geo graphics subsystem
 * @warning spriteInfo and paletteInfo must remain valid during object lifetime
 * @since 3.1.1
 *
 * @see nc_gfx_display_animated_sprite(), nc_gfx_destroy_animated_sprite()
 */
void nc_gfx_init_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo
);

/**
 * @brief Initialize an animated sprite with physics (New API)
 * @details Sets up a GFX_Animated_Physic_Sprite structure with collision box for physics-enabled sprites.
 *          Combines sprite initialization with collision detection capabilities.
 *
 * @param[out] gfx_animated_sprite_physic Pointer to physics sprite structure to initialize
 * @param[in] spriteInfo Pointer to DATlib sprite information (must not be NULL)
 * @param[in] paletteInfo Pointer to DATlib palette information (must not be NULL)
 * @param[in] box_witdh Collision box width in pixels
 * @param[in] box_height Collision box height in pixels
 * @param[in] box_width_offset Horizontal offset from sprite origin
 * @param[in] box_height_offset Vertical offset from sprite origin
 *
 * @since 3.1.1
 *
 * @see nc_gfx_display_animated_physic_sprite(), nc_physic_update_box()
 */
void nc_gfx_init_animated_physic_sprite(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
);

/**
 * @brief Initialize a picture graphics object (New API)
 * @details Sets up a GFX_Picture structure for rendering static images on Neo Geo hardware.
 *          Automatically calculates pixel dimensions and prepares for display.
 *
 * @param[out] gfx_picture Pointer to GFX_Picture structure to initialize
 * @param[in] pictureInfo Pointer to DATlib picture information (must not be NULL)
 * @param[in] paletteInfo Pointer to DATlib palette information (must not be NULL)
 *
 * @note Calls init_shadow_system() internally and calculates pixel_width/pixel_height automatically
 * @warning pictureInfo and paletteInfo must remain valid during object lifetime
 * @since 3.1.1
 *
 * @see nc_gfx_display_picture(), nc_gfx_destroy_picture()
 */
void nc_gfx_init_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo
);

/**
 * @brief Initialize a picture with physics collision box
 * 
 * Initializes a graphics picture with an associated physics collision box.
 * The collision box can be automatically calculated or manually specified.
 *
 * @param[out] gfx_picture_physic Pointer to GFX_Physic_Picture structure to initialize
 * @param[in] pi Pointer to DATlib picture information (must not be NULL)
 * @param[in] pali Pointer to DATlib palette information (must not be NULL)
 * @param[in] box_witdh Width of the collision box
 * @param[in] box_height Height of the collision box
 * @param[in] box_width_offset Horizontal offset of the collision box from picture origin
 * @param[in] box_height_offset Vertical offset of the collision box from picture origin
 * @param[in] autobox_enabled If TRUE, automatically calculate collision box from picture dimensions
 *
 * @warning pictureInfo and paletteInfo must remain valid during object lifetime
 * @since 3.1.1
 *
 * @see nc_gfx_display_physic_picture(), nc_gfx_destroy_physic_picture()
 */
void nc_gfx_init_physic_picture(
  GFX_Physic_Picture *gfx_picture_physic,
  const pictureInfo *pi,
  const paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
);

void nc_gfx_init_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo
);

/** @} */ // end of GFXInit group

/**
 * @defgroup GFXDisplay Graphics Display
 * @ingroup GFX
 * @brief Functions for displaying graphics objects (New API)
 * @{
 */

void nc_gfx_display_with_sprite_id(WORD sprite_id);

WORD nc_gfx_display_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x,
  short y,
  WORD anim
);

WORD nc_gfx_display_animated_physic_sprite(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x,
  short y,
  WORD anim
);

/**
 * @brief Display a static picture on screen
 * @details Renders a GFX_Picture object at the specified coordinates.
 *          The picture will be displayed using the initialized palette and graphics data.
 *
 * @param[in] gfx_picture Pointer to initialized GFX_Picture structure
 * @param[in] x X coordinate for display position
 * @param[in] y Y coordinate for display position
 * @return Sprite ID used for the display, or 0 if failed
 *
 * @since 3.1.1
 * @see nc_gfx_init_picture(), nc_gfx_destroy_picture()
 */
WORD nc_gfx_display_picture(GFX_Picture *gfx_picture, short x, short y);

/**
 * @brief Display a picture with physics collision box on screen
 * @details Renders a GFX_Physic_Picture object at the specified coordinates.
 *          The picture and its collision box will be positioned at the given coordinates.
 *
 * @param[in] gfx_picture_physic Pointer to initialized GFX_Physic_Picture structure
 * @param[in] x X coordinate for display position
 * @param[in] y Y coordinate for display position
 * @return Sprite ID used for the display, or 0 if failed
 *
 * @since 3.1.1
 * @see nc_gfx_init_physic_picture(), nc_gfx_destroy_physic_picture()
 */
WORD nc_gfx_display_physic_picture(GFX_Physic_Picture *gfx_picture_physic, short x, short y);

/**
 * @brief Display a scroller (scrolling background) on screen
 * @details Renders a GFX_Scroller object for creating scrolling background effects.
 *
 * @param[in] gfx_scroller Pointer to initialized GFX_Scroller structure
 * @param[in] x X coordinate for display position
 * @param[in] y Y coordinate for display position
 * @return Sprite ID used for the display, or 0 if failed
 *
 * @since 3.1.1
 * @see nc_gfx_init_scroller()
 */
WORD nc_gfx_display_scroller(GFX_Scroller *gfx_scroller, short x, short y);

/** @} */ // end of GFXDisplay group

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
);

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
);

WORD nc_gfx_init_and_display_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
);

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
);

WORD nc_gfx_init_and_display_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
);

  /*------------------*/
 /*  GFX VISIBILITY  */
/*------------------*/

/**
 * @brief Hide an animated sprite from display
 * @param[in] gfx_animated_sprite Pointer to animated sprite object to hide
 * @since 3.1.1
 */
void nc_gfx_hide_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

/**
 * @brief Hide a picture from display
 * @param[in] gfx_picture Pointer to picture object to hide
 * @since 3.1.1
 */
void nc_gfx_hide_picture(GFX_Picture *gfx_picture);

/**
 * @brief Hide a picture with physics from display
 * @param[in] gfx_picture_physic Pointer to picture with physics object to hide
 * @since 3.1.1
 */
void nc_gfx_hide_physic_picture(GFX_Physic_Picture *gfx_picture_physic);

/**
 * @brief Hide an animated sprite with physics from display
 * @param[in] gfx_animated_sprite_physic Pointer to animated sprite with physics object to hide
 * @since 3.1.1
 */
void nc_gfx_hide_animated_physic_sprite(GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic);

/**
 * @brief Show an animated sprite on display
 * @param[in] gfx_animated_sprite Pointer to animated sprite object to show
 * @since 3.1.1
 */
void nc_gfx_show_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

/**
 * @brief Show a picture on display
 * @param[in] gfx_picture Pointer to picture object to show
 * @since 3.1.1
 */
void nc_gfx_show_picture(GFX_Picture *gfx_picture);

/**
 * @brief Show a picture with physics on display
 * @param[in] gfx_picture_physic Pointer to picture with physics object to show
 * @since 3.1.1
 */
void nc_gfx_show_physic_picture(GFX_Physic_Picture *gfx_picture_physic);

/**
 * @brief Show an animated sprite with physics on display
 * @param[in] gfx_animated_sprite_physic Pointer to animated sprite with physics object to show
 * @since 3.1.1
 */
void nc_gfx_show_animated_physic_sprite(GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic);

  /*------------------*/
 /*  GFX POSITION    */
/*------------------*/

/* GFX POSITION GETTER */

void nc_gfx_get_animated_sprite_position(GFX_Animated_Sprite *gfx_animated_sprite, Position *position);
void nc_gfx_get_animated_physic_sprite_position(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  Position *position
);
void nc_gfx_get_picture_position(GFX_Picture *gfx_picture, Position *position);
void nc_gfx_get_physic_picture_position(GFX_Physic_Picture *gfx_picture_physic, Position *position);
void nc_gfx_get_scroller_position(GFX_Scroller *gfx_scroller, Position *position);

/* GFX POSITION SETTER */

void nc_gfx_set_physic_picture_position(GFX_Physic_Picture *gfx_picture_physic, short x, short y);
void nc_gfx_set_animated_physic_sprite_position(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x,
  short y
);

void nc_gfx_set_scroller_position(GFX_Scroller *gfx_scroller, short x, short y);
void nc_gfx_set_animated_sprite_position(GFX_Animated_Sprite *gfx_animated_sprite, short x, short y);
void nc_gfx_set_picture_position(GFX_Picture *gfx_picture, short x, short y);

/* GFX POSITION MOVE*/

void nc_gfx_move_physic_picture(GFX_Physic_Picture *gfx_picture_physic, short x_offset, short y_offset);
void nc_gfx_move_animated_physic_sprite(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x_offset,
  short y_offset
);

void nc_gfx_move_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x_offset,
  short y_offset
);

void nc_gfx_move_picture(GFX_Picture *gfx_picture, short x, short y);
void nc_gfx_move_scroller(GFX_Scroller *gfx_scroller, short x, short y);

  /*-------------------*/
 /*  GFX SHRUNK       */
/*-------------------*/

#define nc_gpu_shrunk_extract_x(value) value >> 8
#define nc_gpu_shrunk_extract_y(value) (BYTE)value


void nc_gpu_shrunk_centroid_gfx_picture(
  GFX_Picture *gfx_picture,
  short center_x,
  short center_y,
  WORD shrunk_value
);

  /*-------------------*/
 /*  GFX ANIMATION    */
/*-------------------*/
void nc_gfx_set_animated_sprite_animation(GFX_Animated_Sprite *gfx_animated_sprite, WORD anim);
void nc_gfx_set_animated_sprite_animation_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  WORD anim
);

void nc_gfx_update_animated_sprite_animation(GFX_Animated_Sprite *gfx_animated_sprite);
void nc_gfx_update_animated_physic_sprite_animation(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic
);

  /*-------------------*/
 /*  GFX DESTROY      */
/*-------------------*/

void nc_gfx_destroy_scroller(GFX_Scroller *gfx_scroller);
void nc_gfx_destroy_picture(GFX_Picture *gfx_picture);
void nc_gfx_destroy_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);
void nc_gfx_destroy_physic_picture(GFX_Physic_Picture *gfx_picture_physic);
void nc_gfx_destroy_animated_physic_sprite(GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic);

/** @} */ // end of GFX group

  //--------------------------------------------------------------------------//
 //                                   GPU                                    //
//--------------------------------------------------------------------------//

/**
 * @defgroup GPU Graphics Processing Unit
 * @brief Low-level GPU control and hardware management functions
 * @details Functions for direct hardware control, VBlank handling, sprite management,
 *          palette operations, and GPU-specific features like sprite scaling.
 * @{
 */

void nc_gpu_init();
void nc_gpu_clear_display();
void nc_gpu_pause(BOOL (*exitFunc)());
void nc_gpu_sleep(DWORD frame);
BOOL nc_gpu_each_frame(DWORD frame);

  /*------------------------------*/
 /* GPU VBL                      */
/*------------------------------*/

void nc_gpu_update();
DWORD nc_gpu_wait_vbl_max(WORD nb);

#define nc_gpu_wait_vbl() waitVBlank()

  /*------------------------------*/
 /* GPU SPRITE INDEX MANAGEMENT  */
/*------------------------------*/

void nc_sprite_manager_clear_table();
WORD nc_sprite_manager_get_max_free_index();
WORD nc_sprite_manager_get_max_used_index();

  /*---------------*/
 /* GPU PALETTE   */
/*---------------*/

void nc_palette_manager_unset_palette_info(const paletteInfo* paletteInfo);
void nc_palette_manager_clear_table();
WORD nc_sprite_manager_get_free_index();
WORD nc_palette_manager_get_max_free_index();
WORD nc_palette_manager_get_max_used_index();
void nc_palette_manager_read_rgb16(BYTE palette_number, BYTE palette_index, RGB16 *rgb_color);
void nc_palette_color16_to_rgb16(WORD packed_color, RGB16 *rgb_color);

#define nc_palette_rgb16_to_packed_color16(color) \
  ((((color.dark) & 0xF) << 12) | (((color.r) & 0xF) << 8) | (((color.g) & 0xF) << 4) | ((color.b) & 0xF))

#define nc_palette_manager_set_packed_color16(palette_number, palette_index, color) \
  do { \
    int address = 0x400000 | ((palette_number) << 5) | ((palette_index) << 1); \
    volMEMWORD(address) = (color); \
  } while (0)

#define nc_palette_manager_set_rgb16(palette_number, palette_index, color) \
  do { \
    WORD packed_color = nc_rgb16_to_packed_color16(color); \
    nc_palette_manager_set_packed_color16(palette_number, palette_index, packed_color); \
  } while (0)

#define nc_palette_manager_get_packed_color16(palette_number, palette_index) \
  ({ \
    int address = 0x400000 | ((palette_number) << 5) | ((palette_index) << 1); \
    volMEMWORD(address); \
  })

#define nc_palette_set_backdrop_packed_color16(packed_color) \
  do { \
    int address = 0x401FFE; \
    volMEMWORD(address) = (packed_color); \
  } while (0)

#define nc_palette_set_backdrop_rgb16(color) \
  do { \
    WORD packed_color = nc_rgb16_to_packed_color16(color); \
    nc_palette_set_backdrop_packed_color16(packed_color); \
  } while (0)

  /*--------------*/
 /* GPU shrunk   */
/*--------------*/

WORD nc_gpu_get_shrunk_proportional_table(WORD index);
int nc_gpu_get_shrunk_centroid_translated_x_position(short centerPosX, WORD tileWidth, BYTE shrunkX);
int nc_gpu_get_shrunk_centroid_translated_y_position(short centerPosY, WORD tileHeight, BYTE shrunkY);
void nc_gpu_shrunk(WORD base_sprite, WORD max_width, WORD value);
WORD nc_gpu_shrunk_forge(BYTE xc, BYTE yc);
void nc_gpu_shrunk_addr(WORD addr, WORD shrunk_value);
WORD nc_gpu_shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

/** @} */ // end of GPU group

  //--------------------------------------------------------------------------//
 //                                MATH                                      //
//--------------------------------------------------------------------------//

/**
 * @defgroup Math Mathematics Utilities
 * @brief Mathematical functions, bit operations, and utility macros
 * @details Provides optimized math operations, bitwise calculations, random number
 *          generation, and common mathematical utilities for game development.
 * @{
 */
#define nc_math_bitwise_division_2(value) (value >> 1)
#define nc_math_bitwise_division_4(value) (value >> 2)
#define nc_math_bitwise_division_8(value) (value >> 3)
#define nc_math_bitwise_division_16(value) (value >> 4)
#define nc_math_bitwise_division_32(value) (value >> 5)
#define nc_math_bitwise_division_64(value) (value >> 6)
#define nc_math_bitwise_division_128(value) (value >> 7)
#define nc_math_bitwise_division_256(value) (value >> 8)

#define nc_math_bitwise_multiplication_2(value) (value << 1)
#define nc_math_bitwise_multiplication_4(value) (value << 2)
#define nc_math_bitwise_multiplication_8(value) (value << 3)
#define nc_math_bitwise_multiplication_16(value) (value << 4)
#define nc_math_bitwise_multiplication_32(value) (value << 5)
#define nc_math_bitwise_multiplication_64(value) (value << 6)
#define nc_math_bitwise_multiplication_128(value) (value << 7)
#define nc_math_bitwise_multiplication_256(value) (value << 8)

#define nc_math_random(range) rand() % range

#define nc_math_min(a,b) ((a) < (b) ? (a) : (b))
#define nc_math_max(a,b) ((a) > (b) ? (a) : (b))

#define nc_math_abs(num) ((num) < 0 ? ~(num) + 1 : (num))
#define nc_math_negative(num) -num

#define nc_math_fix(num) num * 65536
#define nc_math_fix_to_int(num) fixtoi(num)
#define nc_math_int_to_fix(num) itofix(num)
#define nc_math_fix_add(num1, num2) fadd(num1, num2)
#define nc_math_fix_sub(num1, num2) fsub(num1, num2)
#define nc_math_fix_mul(num1, num2) fmul(num1, num2)
#define nc_math_cos(num) fcos(num)
#define nc_math_tan(num) ftan(num)

void nc_math_byte_to_hex(BYTE value, char *hexchar);
void nc_math_word_to_hex(WORD value, char *hexchar);
char nc_math_sin(WORD index);

DWORD nc_math_frame_to_second(DWORD frame);
DWORD nc_math_second_to_frame(DWORD second);

BOOL nc_math_vectors_is_collide(Box *box, Position vec[], BYTE vector_max);
BOOL nc_math_vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

void nc_math_get_relative_position(Position *position, Box box, Position world_coord);

/** @} */ // end of Math group

  //--------------------------------------------------------------------------//
 //                                PHYSIC                                    //
//--------------------------------------------------------------------------//

/**
 * @defgroup Physics Physics & Collision Detection
 * @brief Collision detection and physics simulation functions
 * @details Provides bounding box collision detection, physics calculations,
 *          and spatial relationship management for game objects.
 * @{
 */

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
 * @note Uses nc_physic_collide_box() internally for individual collision tests
 * @since 3.1.1
 *
 * @see nc_physic_collide_box(), NONE
 */
BYTE nc_physic_collide_boxes(Box *box, Box *boxes[], BYTE box_max);

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
 * @since 3.1.1
 *
 * @see nc_physic_collide_boxes(), nc_physic_update_box()
 */
BOOL nc_physic_collide_box(Box *box1, Box *box2);

/**
 * @brief Initialize a bounding box with dimensions and offsets
 * @details Sets up box dimensions and offset values. Corner points are not calculated
 *          until nc_physic_update_box() is called with position coordinates.
 *
 * @param[out] box Pointer to Box structure to initialize (must not be NULL)
 * @param[in] width Box width in pixels
 * @param[in] height Box height in pixels
 * @param[in] widthOffset Horizontal offset from sprite origin
 * @param[in] heightOffset Vertical offset from sprite origin
 *
 * @note Corner points (p0-p4) are not set - call nc_physic_update_box() to calculate positions
 * @warning No NULL pointer validation - caller must ensure valid box pointer
 * @since 3.1.1
 *
 * @see nc_physic_update_box()
 */
void nc_physic_init_box(Box *box, short width, short height, short widthOffset, short heightOffset);

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
 * @since 3.1.1
 *
 * @see nc_physic_init_box(), nc_physic_collide_box()
 */
void nc_physic_update_box(Box *box, short x, short y);

void nc_physic_shrunk_box(Box *box, Box *bOrigin, WORD shrunkValue);
void nc_physic_resize_box(Box *Box, short edge);
void nc_physic_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max);

#define nc_physic_copy_box(box_src, box_dest) memcpy(box_dest, box_src, sizeof(Box))

/** @} */ // end of Physics group

  //--------------------------------------------------------------------------//
 //                                SOUND                                     //
//--------------------------------------------------------------------------//

/**
 * @defgroup Sound Audio & Sound
 * @brief Audio playback and sound management functions
 * @details Functions for CDDA music playback and ADPCM sound effects management.
 * @{
 */

  //---------
 //    CDDA
//-----------
void nc_sound_pause_cdda();
void nc_sound_resume_cdda();
void nc_sound_play_cdda(BYTE track);
#define nc_sound_stop_cdda() nc_sound_pause_cdda()

  //--------
 //  ADPCM
//----------

void nc_sound_stop_adpcm();

/** @} */ // end of Sound group

  //----------------------------------------------------------------------------//
 //                                  JOYPAD                                    //
//----------------------------------------------------------------------------//

/**
 * @defgroup Joypad Input & Controller
 * @brief Joypad input handling and button state management
 * @details Functions for reading Neo Geo controller input with edge detection
 *          support and multi-player capability.
 * @{
 */

void nc_joypad_set_edge_mode(BOOL actived);
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

void nc_joypad_debug(BYTE id);

/** @} */ // end of Joypad group

  //----------------------------------------------------------------------------//
 //                                  UTIL                                      //
//----------------------------------------------------------------------------//

/**
 * @defgroup Utilities System Utilities
 * @brief System management, logging, and utility functions
 * @details Provides system initialization, memory management, logging capabilities,
 *          and various utility functions for development and debugging.
 * @{
 */

  /*---------------*/
 /* SYSTEM        */
/*---------------*/

void nc_system_init();
void nc_system_reset();
WORD nc_system_get_free_ram_info();

  /*---------------*/
 /* UTIL          */
/*---------------*/
#define nc_gpu_get_frame_number() DAT_frameCounter

  /*---------------*/
 /* LOG.          */
/*---------------*/

void nc_log_init();
WORD nc_log_get_x_position();
WORD nc_log_get_y_position();
void nc_log_set_position(WORD _x, WORD _y);

/**
 * @brief Print text at specified coordinates using fix layer
 * @details Displays text at the given x,y coordinates using the Neo Geo's fix layer.
 *          Uses the currently set font bank and palette for rendering.
 *
 * @param[in] x Horizontal position in characters (0-39)
 * @param[in] y Vertical position in characters (0-27) 
 * @param[in] label Text string to display (null-terminated)
 *
 * @note Coordinates are in character positions, not pixels
 * @note Uses font bank and palette set by nc_fix_set_bank() and nc_fix_set_palette_id()
 * @since 3.1.1
 *
 * @see nc_fix_set_bank(), nc_fix_set_palette_id(), nc_log_info()
 */
void nc_log_print(int x, int y, char *label);

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
 * @brief Set font bank for log text display
 * @details Sets the font bank number used by logging functions for text rendering.
 *          Controls which font is used for subsequent log output.
 *
 * @param[in] bank Font bank number (0-15)
 *
 * @note Must be called before nc_log_info() to affect font selection
 * @note Bank 0 = system font (always available)
 * @since 3.1.0
 *
 * @see nc_fix_set_palette_id(), nc_fix_load_palette_info(), nc_log_info(), nc_init_log()
 */
void nc_fix_set_bank(WORD bank);

/**
 * @brief Set palette ID for log text display
 * @details Sets the palette number used by logging functions for text color.
 *          Works with custom palettes loaded via palJobPut() and system palettes.
 *
 * @param[in] palette Palette ID number (0-15)
 *
 * @note Must be called before nc_log_info() to affect text color
 * @note Palette 0 = default system palette (usually white text)
 * @note Works in combination with nc_fix_set_bank() for full text control
 * @since 3.1.0
 *
 * @see nc_fix_set_bank(), nc_fix_load_palette_info(), nc_log_info(), palJobPut(), nc_init_log()
 */
void nc_fix_set_palette_id(WORD palette);

/**
 * @brief Load palette data and return the palette index
 * @details Loads palette data to the specified palette index using palJobPut() and returns
 *          the same palette index. This is a convenience function that combines palette
 *          loading and returns the index for immediate use with other palette functions.
 *
 * @param[in] paletteInfo Pointer to palette information structure containing color data (must not be NULL)
 * @param[in] palette_index Target palette index where the palette will be loaded (0-15)
 *
 * @return The same palette index that was passed as parameter
 * @retval palette_index Echo of the input palette_index parameter
 *
 * @note Typical usage: `nc_fix_set_palette_id(nc_palette_set_info(&my_palette, 5));`
 * @note The returned index can be used with nc_fix_set_palette_id() or other palette functions
 * @warning No validation of palette_index bounds - ensure valid range (0-15)
 * @since 3.1.0
 *
 * @see nc_fix_set_palette_id(), nc_fix_set_bank(), nc_fix_load_palette_info(), palJobPut(), nc_log_info()
 */
WORD nc_palette_set_info(const paletteInfo *paletteInfo, WORD palette_index);

/**
 * @brief Allocate and set palette for fix layer
 * @details Automatically allocates a palette index from the fix layer reserved range (2-16)
 *          and loads the palette data. Uses the palette manager to ensure proper allocation.
 *          Palettes 0-1 are reserved for system use and cannot be allocated.
 *
 * @param palette_info Pointer to palette data structure containing colors and count
 * @return WORD Allocated palette index (2-16), or 0 if allocation failed
 *
 * @code
 * // Allocate palette for fix layer font
 * WORD fix_palette = nc_fix_load_palette_info(&my_font_palette);
 * nc_fix_set_palette_id(fix_palette);
 * @endcode
 *
 * @note This function is specifically for fix layer palettes (indices 2-16)
 * @note Palettes 0-1 are system reserved and never allocated
 * @note Returns 0 if no palette slots available in fix range
 * @since 3.1.0
 *
 * @see nc_palette_set_info(), nc_fix_set_palette_id(), nc_fix_unload_palette_info(), nc_fix_unload_palette_id(), use_palette_manager_index()
 */
WORD nc_fix_load_palette_info(const paletteInfo *palette_info);

/**
 * @brief Unload palette data by palette info for fix layer
 * @details Frees a previously allocated palette in the fix layer range (2-16) by matching
 *          the palette info pointer. This is the counterpart to nc_fix_load_palette_info().
 *
 * @param palette_info Pointer to palette info structure that was used to load the palette
 * @return true if palette was found and freed, false if not found
 *
 * @note Only works with palettes allocated via nc_fix_load_palette_info()
 * @note System reserved palettes (0-1) cannot be unloaded
 * @since 3.1.0
 *
 * @see nc_fix_load_palette_info(), nc_fix_unload_palette_id()
 */
BOOL nc_fix_unload_palette_info(const paletteInfo *palette_info);

/**
 * @brief Unload palette data by palette ID for fix layer
 * @details Frees a palette at the specified index in the fix layer range (2-16).
 *          This is useful when you know the palette ID but don't have the original palette info.
 *
 * @param palette_id Palette index to free (2-16)
 * @return true if palette was freed, false if invalid ID or system reserved palette
 *
 * @note Only works with fix layer palette range (2-16)
 * @note System reserved palettes (0-1) cannot be unloaded
 * @note Will fail if palette_id is outside valid fix range
 * @since 3.1.0
 *
 * @see nc_fix_load_palette_info(), nc_fix_unload_palette_info()
 */
BOOL nc_fix_unload_palette_id(WORD palette_id);

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
void nc_log_palette_info(paletteInfo *paletteInfo);
void nc_log_packed_color16(WORD packed_color);
void nc_log_rgb16(RGB16 *color);

  /*---------------*/
 /* SOUND         */
/*---------------*/

void nc_sound_init_adpcm();
void nc_sound_update_adpcm_player();
void nc_sound_set_adpcm_remaining_frame(DWORD frame);
Sound_Adpcm_Player *nc_sound_get_adpcm_player();



/** @} */ // end of Utilities group

  //--------------------------------------------------------------------------//
 //                                   LEGACY                                 //
//--------------------------------------------------------------------------//

/**
 * @defgroup Legacy Legacy Functions
 * @brief Deprecated functions maintained for backward compatibility
 * @deprecated Use modern API functions instead
 * @{
 */

/**
 * @note LEGACY FUNCTIONS AND MACROS
 * 
 * This section contains deprecated functions and macros maintained for backward compatibility.
 * 
 * New code should use the modern API with consistent naming conventions:
 * - GFX functions: nc_gfx_[action]_[object]() (e.g., nc_gfx_init_picture())
 * - GPU functions: nc_gpu_*() 
 * - Physic functions: nc_physic_*()
 * - Sound functions: nc_sound_*()
 * - Manager functions: nc_[component]_manager_*()
 * 
 * Legacy functions below will be removed in future major versions.
 * Use the toolchain legacy detection script to identify usage in your projects.
 * 
 * @since Legacy functions from versions < 3.1.1
 * @deprecated All functions in this section are deprecated
 */

  /*------------------------------*/
 /* LEGACY TYPES                 */
/*------------------------------*/

/** @deprecated Use GFX_Animated_Physic_Sprite instead */
typedef GFX_Animated_Physic_Sprite GFX_Animated_Sprite_Physic;

/** @deprecated Use GFX_Physic_Picture instead */
typedef GFX_Physic_Picture GFX_Picture_Physic;

/** @deprecated Use Sound_Adpcm_Player instead */
typedef Sound_Adpcm_Player Adpcm_player;

  /*------------------------------*/
 /* LEGACY GFX INIT              */
/*------------------------------*/

/** @deprecated Use nc_gfx_init_animated_sprite() instead */
void nc_init_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo
);

/** @deprecated Use nc_gfx_init_animated_physic_sprite() instead */
void nc_init_gfx_animated_sprite_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset
);

/** @deprecated Use nc_gfx_init_picture() instead */
void nc_init_gfx_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo
);

/** @deprecated Use nc_gfx_init_physic_picture() instead */
void nc_init_gfx_picture_physic(
  GFX_Physic_Picture *gfx_picture_physic,
  const pictureInfo *pi,
  const paletteInfo *pali,
  short box_witdh,
  short box_height,
  short box_width_offset,
  short box_height_offset,
  BOOL autobox_enabled
);

/** @deprecated Use nc_gfx_init_scroller() instead */
void nc_init_gfx_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo
);

  /*------------------------------*/
 /* LEGACY GFX DISPLAY           */
/*------------------------------*/

/** @deprecated Use nc_gfx_display_with_sprite_id() instead */
void nc_display_gfx_with_sprite_id(WORD sprite_id);

/** @deprecated Use nc_gfx_display_animated_sprite() instead */
WORD nc_display_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x,
  short y,
  WORD anim
);

/** @deprecated Use nc_gfx_display_animated_physic_sprite() instead */
WORD nc_display_gfx_animated_sprite_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x,
  short y,
  WORD anim
);

/** @deprecated Use nc_gfx_display_picture() instead */
WORD nc_display_gfx_picture(GFX_Picture *gfx_picture, short x, short y);

/** @deprecated Use nc_gfx_display_physic_picture() instead */
WORD nc_display_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic, short x, short y);

/** @deprecated Use nc_gfx_display_scroller() instead */
WORD nc_display_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);

  /*------------------------------*/
 /* LEGACY GFX INIT DISPLAY      */
/*------------------------------*/

/** @deprecated Use nc_gfx_init_and_display_animated_sprite() instead */
WORD nc_init_display_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  const spriteInfo *spriteInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y,
  WORD anim
);

/** @deprecated Use nc_gfx_init_and_display_animated_physic_sprite() instead */
WORD nc_init_display_gfx_animated_sprite_physic(
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
);

/** @deprecated Use nc_gfx_init_and_display_picture() instead */
WORD nc_init_display_gfx_picture(
  GFX_Picture *gfx_picture,
  const pictureInfo *pictureInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
);

/** @deprecated Use nc_gfx_init_and_display_physic_picture() instead */
WORD nc_init_display_gfx_picture_physic(
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
);

/** @deprecated Use nc_gfx_init_and_display_scroller() instead */
WORD nc_init_display_gfx_scroller(
  GFX_Scroller *gfx_scroller,
  const scrollerInfo *scrollerInfo,
  const paletteInfo *paletteInfo,
  short x,
  short y
);

  /*------------------------------*/
 /* LEGACY GFX VISIBILITY        */
/*------------------------------*/

/** @deprecated Use nc_gfx_hide_animated_sprite() instead */
void nc_hide_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

/** @deprecated Use nc_gfx_hide_picture() instead */
void nc_hide_gfx_picture(GFX_Picture *gfx_picture);

/** @deprecated Use nc_gfx_hide_physic_picture() instead */
void nc_hide_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic);

/** @deprecated Use nc_gfx_hide_animated_physic_sprite() instead */
void nc_hide_gfx_animated_sprite_physic(GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic);

/** @deprecated Use nc_gfx_show_animated_sprite() instead */
void nc_show_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

/** @deprecated Use nc_gfx_show_animated_physic_sprite() instead */
void nc_show_gfx_animated_sprite_physic(GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic);

/** @deprecated Use nc_gfx_show_picture() instead */
void nc_show_gfx_picture(GFX_Picture *gfx_picture);

/** @deprecated Use nc_gfx_show_physic_picture() instead */
void nc_show_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic);

  /*------------------------------*/
 /* LEGACY GFX POSITION          */
/*------------------------------*/

/** @deprecated Use nc_gfx_get_animated_sprite_position() instead */
void nc_get_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, Position *position);

/** @deprecated Use nc_gfx_get_animated_physic_sprite_position() instead */
void nc_get_position_gfx_animated_sprite_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  Position *position
);

/** @deprecated Use nc_gfx_get_picture_position() instead */
void nc_get_position_gfx_picture(GFX_Picture *gfx_picture, Position *position);

/** @deprecated Use nc_gfx_get_physic_picture_position() instead */
void nc_get_position_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic, Position *position);

/** @deprecated Use nc_gfx_get_scroller_position() instead */
void nc_get_position_gfx_scroller(GFX_Scroller *gfx_scroller, Position *position);

/** @deprecated Use nc_gfx_set_physic_picture_position() instead */
void nc_set_position_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic, short x, short y);

/** @deprecated Use nc_gfx_set_animated_physic_sprite_position() instead */
void nc_set_position_gfx_animated_sprite_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x,
  short y
);

/** @deprecated Use nc_gfx_set_scroller_position() instead */
void nc_set_position_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);

/** @deprecated Use nc_gfx_set_animated_sprite_position() instead */
void nc_set_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, short x, short y);

/** @deprecated Use nc_gfx_set_picture_position() instead */
void nc_set_position_gfx_picture(GFX_Picture *gfx_picture, short x, short y);

/** @deprecated Use nc_gfx_move_physic_picture() instead */
void nc_move_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic, short x_offset, short y_offset);

/** @deprecated Use nc_gfx_move_animated_physic_sprite() instead */
void nc_move_gfx_animated_sprite_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  short x_offset,
  short y_offset
);

/** @deprecated Use nc_gfx_move_animated_sprite() instead */
void nc_move_gfx_animated_sprite(
  GFX_Animated_Sprite *gfx_animated_sprite,
  short x_offset,
  short y_offset
);

/** @deprecated Use nc_gfx_move_picture() instead */
void nc_move_gfx_picture(GFX_Picture *gfx_picture, short x, short y);

/** @deprecated Use nc_gfx_move_scroller() instead */
void nc_move_gfx_scroller(GFX_Scroller *gfx_scroller, short x, short y);

  /*------------------------------*/
 /* LEGACY GFX SHRUNK            */
/*------------------------------*/

/** @deprecated Use nc_gpu_shrunk_centroid_gfx_picture() instead */
void nc_shrunk_centroid_gfx_picture(
  GFX_Picture *gfx_picture,
  short center_x,
  short center_y,
  WORD shrunk_value
);

  /*------------------------------*/
 /* LEGACY GFX ANIMATION         */
/*------------------------------*/

/** @deprecated Use nc_gfx_set_animated_sprite_animation() instead */
void nc_set_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, WORD anim);

/** @deprecated Use nc_gfx_set_animated_sprite_animation_physic() instead */
void nc_set_animation_gfx_animated_sprite_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic,
  WORD anim
);

/** @deprecated Use nc_gfx_update_animated_sprite_animation() instead */
void nc_update_animation_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

/** @deprecated Use nc_gfx_update_animated_physic_sprite_animation() instead */
void nc_update_animation_gfx_animated_sprite_physic(
  GFX_Animated_Physic_Sprite *gfx_animated_sprite_physic
);

  /*------------------------------*/
 /* LEGACY GFX DESTROY           */
/*------------------------------*/

/** @deprecated Use nc_gfx_destroy_scroller() instead */
void nc_destroy_gfx_scroller(GFX_Scroller *gfx_scroller);

/** @deprecated Use nc_gfx_destroy_picture() instead */
void nc_destroy_gfx_picture(GFX_Picture *gfx_picture);

/** @deprecated Use nc_gfx_destroy_animated_sprite() instead */
void nc_destroy_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);

/** @deprecated Use nc_gfx_destroy_physic_picture() instead */
void nc_destroy_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic);

/** @deprecated Use nc_gfx_destroy_animated_physic_sprite() instead */
void nc_destroy_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

  /*------------------------------*/
 /* LEGACY GPU                   */
/*------------------------------*/

/** @deprecated Use nc_gpu_update() instead */
void nc_update();

/** @deprecated Use nc_gpu_wait_vbl_max() instead */
DWORD nc_wait_vbl_max(WORD nb);

/** @deprecated Use nc_gpu_init() instead */
#define nc_init_gpu() nc_gpu_init()

/** @deprecated Use nc_sprite_manager_clear_table() instead */
#define nc_clear_sprite_index_table() nc_sprite_manager_clear_table()

/** @deprecated Use nc_sprite_manager_get_max_free_index() instead */
#define nc_get_max_free_sprite_index() nc_sprite_manager_get_max_free_index()

/** @deprecated Use nc_sprite_manager_get_max_used_index() instead */
#define nc_get_max_sprite_index_used() nc_sprite_manager_get_max_used_index()

/** @deprecated Use nc_palette_manager_unset_palette_info() instead */
void nc_destroy_palette(const paletteInfo* paletteInfo);

/** @deprecated Use nc_palette_manager_clear_table() instead */
#define nc_clear_palette_index_table() nc_palette_manager_clear_table()

/** @deprecated Use nc_sprite_manager_get_free_index() instead */
#define nc_get_free_sprite_index() nc_sprite_manager_get_free_index()

/** @deprecated Use nc_palette_manager_get_max_free_index() instead */
#define nc_get_max_free_palette_index() nc_palette_manager_get_max_free_index()

/** @deprecated Use nc_palette_manager_get_max_used_index() instead */
#define nc_get_max_palette_index_used() nc_palette_manager_get_max_used_index()

/** @deprecated Use nc_gpu_wait_vbl() instead */
#define nc_wait_vbl() nc_gpu_wait_vbl()

/** @deprecated Use nc_palette_rgb16_to_packed_color16() instead */
#define nc_rgb16_to_packed_color16(color) \
  ((((color.dark) & 0xF) << 12) | (((color.r) & 0xF) << 8) | (((color.g) & 0xF) << 4) | ((color.b) & 0xF))

/** @deprecated Use nc_palette_manager_set_packed_color16() instead */
#define nc_set_palette_by_packed_color16(palette_number, palette_index, color) \
  do { \
    int address = 0x400000 | ((palette_number) << 5) | ((palette_index) << 1); \
    volMEMWORD(address) = (color); \
  } while (0)

/** @deprecated Use nc_palette_manager_set_rgb16() instead */
#define nc_set_palette_by_rgb16(palette_number, palette_index, color) \
  do { \
    WORD packed_color = nc_rgb16_to_packed_color16(color); \
    nc_set_palette_by_packed_color16(palette_number, palette_index, packed_color); \
  } while (0)

/** @deprecated Use nc_palette_manager_get_packed_color16() instead */
#define nc_get_palette_packed_color16(palette_number, palette_index) \
  ({ \
    int address = 0x400000 | ((palette_number) << 5) | ((palette_index) << 1); \
    volMEMWORD(address); \
  })

/** @deprecated Use nc_palette_manager_read_rgb16() instead */
void nc_palette_manager_read_rgb16(BYTE palette_number, BYTE palette_index, RGB16 *rgb_color);

/** @deprecated Use nc_palette_color16_to_rgb16() instead */
void nc_packet_color16_to_rgb16(WORD packed_color, RGB16 *rgb_color);

  /*------------------------------*/
 /* LEGACY PHYSICS               */
/*------------------------------*/

/** @deprecated Use nc_physic_collide_boxes() instead */
BYTE nc_collide_boxes(Box *box, Box *boxes[], BYTE box_max);

/** @deprecated Use nc_physic_collide_box() instead */
BOOL nc_collide_box(Box *box1, Box *box2);

/** @deprecated Use nc_physic_init_box() instead */
void nc_init_box(Box *box, short width, short height, short widthOffset, short heightOffset);

/** @deprecated Use nc_physic_update_box() instead */
void nc_update_box(Box *box, short x, short y);

/** @deprecated Use nc_physic_shrunk_box() instead */
void nc_shrunk_box(Box *box, Box *bOrigin, WORD shrunkValue);

/** @deprecated Use nc_physic_resize_box() instead */
void nc_resize_box(Box *Box, short edge);

/** @deprecated Use nc_physic_update_mask() instead */
void nc_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max);

  /*------------------------------*/
 /* LEGACY MATH                  */
/*------------------------------*/

/** @deprecated Use nc_palette_set_backdrop_packed_color16() instead */
#define nc_set_palette_backdrop_by_packed_color16(packed_color) \
  do { \
    int address = 0x401FFE; \
    volMEMWORD(address) = (packed_color); \
  } while (0)

/** @deprecated Use nc_palette_set_backdrop_rgb16() instead */
#define nc_set_palette_backdrop_by_rgb16(color) \
  do { \
    WORD _packed = (((color).dark & 0xF) << 12) | (((color).r & 0xF) << 8) | (((color).g & 0xF) << 4) | ((color).b & 0xF); \
    int _address = 0x401FFE; \
    volMEMWORD(_address) = _packed; \
  } while (0)

/** @deprecated Use nc_palette_set_backdrop_packed_color16() instead */
#define nc_palette_manager_set_backdrop_packed_color16(packed_color) \
  nc_palette_set_backdrop_packed_color16(packed_color)

/** @deprecated Use nc_math_bitwise_division_2() instead */
#define nc_bitwise_division_2(value) (value >> 1)
/** @deprecated Use nc_math_bitwise_division_4() instead */
#define nc_bitwise_division_4(value) (value >> 2)
/** @deprecated Use nc_math_bitwise_division_8() instead */
#define nc_bitwise_division_8(value) (value >> 3)
/** @deprecated Use nc_math_bitwise_division_16() instead */
#define nc_bitwise_division_16(value) (value >> 4)
/** @deprecated Use nc_math_bitwise_division_32() instead */
#define nc_bitwise_division_32(value) (value >> 5)
/** @deprecated Use nc_math_bitwise_division_64() instead */
#define nc_bitwise_division_64(value) (value >> 6)
/** @deprecated Use nc_math_bitwise_division_128() instead */
#define nc_bitwise_division_128(value) (value >> 7)
/** @deprecated Use nc_math_bitwise_division_256() instead */
#define nc_bitwise_division_256(value) (value >> 8)

/** @deprecated Use nc_math_bitwise_multiplication_2() instead */
#define nc_bitwise_multiplication_2(value) (value << 1)
/** @deprecated Use nc_math_bitwise_multiplication_4() instead */
#define nc_bitwise_multiplication_4(value) (value << 2)
/** @deprecated Use nc_math_bitwise_multiplication_8() instead */
#define nc_bitwise_multiplication_8(value) (value << 3)
/** @deprecated Use nc_math_bitwise_multiplication_16() instead */
#define nc_bitwise_multiplication_16(value) (value << 4)
/** @deprecated Use nc_math_bitwise_multiplication_32() instead */
#define nc_bitwise_multiplication_32(value) (value << 5)
/** @deprecated Use nc_math_bitwise_multiplication_64() instead */
#define nc_bitwise_multiplication_64(value) (value << 6)
/** @deprecated Use nc_math_bitwise_multiplication_128() instead */
#define nc_bitwise_multiplication_128(value) (value << 7)
/** @deprecated Use nc_math_bitwise_multiplication_256() instead */
#define nc_bitwise_multiplication_256(value) (value << 8)

/** @deprecated Use nc_math_random() instead */
#define nc_random(range) rand() % range

/** @deprecated Use nc_math_min() instead */
#define nc_min(a,b) ((a) < (b) ? (a) : (b))
/** @deprecated Use nc_math_max() instead */
#define nc_max(a,b) ((a) > (b) ? (a) : (b))

/** @deprecated Use nc_math_abs() instead */
#define nc_abs(num) ((num) < 0 ? ~(num) + 1 : (num))
/** @deprecated Use nc_math_negative() instead */
#define nc_negative(num) -num

/** @deprecated Use nc_math_fix() instead */
#define nc_fix(num) num * 65536
/** @deprecated Use nc_math_fix_to_int() instead */
#define nc_fix_to_int(num) fixtoi(num)
/** @deprecated Use nc_math_int_to_fix() instead */
#define nc_int_to_fix(num) itofix(num)
/** @deprecated Use nc_math_fix_add() instead */
#define nc_fix_add(num1, num2) fadd(num1, num2)
/** @deprecated Use nc_math_fix_sub() instead */
#define nc_fix_sub(num1, num2) fsub(num1, num2)
/** @deprecated Use nc_math_fix_mul() instead */
#define nc_fix_mul(num1, num2) fmul(num1, num2)
/** @deprecated Use nc_math_cos() instead */
#define nc_cos(num) fcos(num)
/** @deprecated Use nc_math_tan() instead */
#define nc_tan(num) ftan(num)

/** @deprecated Use nc_physic_copy_box() instead */
#define nc_copy_box(box_src, box_dest) memcpy(box_dest, box_src, sizeof(Box))

/** @deprecated Use nc_math_byte_to_hex() instead */
void nc_byte_to_hex(BYTE value, char *hexchar);

/** @deprecated Use nc_math_word_to_hex() instead */
void nc_word_to_hex(WORD value, char *hexchar);

/** @deprecated Use nc_math_sin() instead */
char nc_sin(WORD index);

/** @deprecated Use nc_math_frame_to_second() instead */
DWORD nc_frame_to_second(DWORD frame);

/** @deprecated Use nc_math_second_to_frame() instead */
DWORD nc_second_to_frame(DWORD second);

/** @deprecated Use nc_math_vectors_is_collide() instead */
BOOL nc_vectors_collide(Box *box, Position vec[], BYTE vector_max);

/** @deprecated Use nc_math_vector_is_left() instead */
BOOL nc_vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

/** @deprecated Use nc_math_get_relative_position() instead */
void nc_get_relative_position(Position *position, Box box, Position world_coord);

  /*------------------------------*/
 /* LEGACY SOUND                 */
/*------------------------------*/

/** @deprecated Use nc_sound_play_cdda() instead */
void nc_play_cdda(BYTE track);

/** @deprecated Use nc_sound_pause_cdda() instead */
#define nc_pause_cdda() nc_sound_pause_cdda()
/** @deprecated Use nc_sound_resume_cdda() instead */
#define nc_resume_cdda() nc_sound_resume_cdda()
/** @deprecated Use nc_sound_stop_cdda() instead */
#define nc_stop_cdda() nc_sound_stop_cdda()

/** @deprecated Use nc_sound_stop_adpcm() instead */
#define nc_stop_adpcm() nc_sound_stop_adpcm()

/** @deprecated Use nc_sound_init_adpcm() instead */
#define nc_init_adpcm() nc_sound_init_adpcm()

/** @deprecated Use nc_sound_update_adpcm_player() instead */
#define nc_update_adpcm_player() nc_sound_update_adpcm_player()

/** @deprecated Use nc_sound_set_adpcm_remaining_frame() instead */
void nc_push_remaining_frame_adpcm_player(DWORD frame);

/** @deprecated Use nc_sound_get_adpcm_player() instead */
Adpcm_player *nc_get_adpcm_player();

  /*------------------------------*/
 /* LEGACY JOYPAD                */
/*------------------------------*/

/** @deprecated Use nc_joypad_set_edge_mode() instead */
void nc_set_joypad_edge_mode(BOOL actived);

/** @deprecated Use nc_joypad_update() instead */
void nc_update_joypad(BYTE id);

/** @deprecated Use nc_joypad_debug() instead */
void nc_debug_joypad(BYTE id);

  /*------------------------------*/
 /* LEGACY SYSTEM                */
/*------------------------------*/

/** @deprecated Use nc_system_reset() instead */
void nc_reset();

/** @deprecated Use nc_system_get_free_ram_info() instead */
WORD nc_free_ram_info();

/** @deprecated Use nc_gpu_get_frame_number() instead */
#define nc_get_frame_counter() DAT_frameCounter

  /*------------------------------*/
 /* LEGACY LOG                   */
/*------------------------------*/

/** @deprecated Use nc_log_init() instead */
#define nc_init_log() nc_log_init()
/** @deprecated Use nc_log_get_x_position() instead */
#define nc_get_position_x_log() nc_log_get_x_position()
/** @deprecated Use nc_log_get_y_position() instead */
#define nc_get_position_y_log() nc_log_get_y_position()

/** @deprecated Use nc_log_set_position() instead */
void nc_set_position_log(WORD _x, WORD _y);

/** @deprecated Use nc_log_print() instead */
void nc_print(int x, int y, char *label);

/** @deprecated Use nc_gpu_pause() instead */
void nc_pause(BOOL (*exitFunc)());

/** @deprecated Use nc_gpu_sleep() instead */
void nc_sleep(DWORD frame);

/** @deprecated Use nc_gpu_each_frame() instead */
BOOL nc_each_frame(DWORD frame);

/** @deprecated Use nc_gfx_shrunk_extract_x() instead */
#define nc_shrunk_extract_x(value) value >> 8

/** @deprecated Use nc_gfx_shrunk_extract_y() instead */
#define nc_shrunk_extract_y(value) (BYTE)value

/** @deprecated Use nc_gpu_get_shrunk_proportional_table() instead */
WORD nc_get_shrunk_proportional_table(WORD index);

/** @deprecated Use nc_gpu_get_shrunk_centroid_translated_x_position() instead */
int nc_shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX);

/** @deprecated Use nc_gpu_get_shrunk_centroid_translated_y_position() instead */
int nc_shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY);

/** @deprecated Use nc_gpu_shrunk() instead */
void nc_shrunk(WORD base_sprite, WORD max_width, WORD value);

/** @deprecated Use nc_gpu_shrunk_forge() instead */
WORD nc_shrunk_forge(BYTE xc, BYTE yc);

/** @deprecated Use nc_gpu_shrunk_addr() instead */
void nc_shrunk_addr(WORD addr, WORD shrunk_value);

/** @deprecated Use nc_gpu_shrunk_range() instead */
WORD nc_shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

  /*------------------------------*/
 /* LEGACY PALETTE               */
/*------------------------------*/

/** @deprecated Use nc_gpu_palette_manager_read_rgb16() instead */
void nc_palette_manager_read_rgb16(BYTE palette_number, BYTE palette_index, RGB16 *rgb_color);
/** @deprecated Use nc_gpu_packet_color16_to_rgb16() instead */
void nc_packet_color16_to_rgb16(WORD packed_color, RGB16 *rgb_color);

/** @deprecated Use nc_gfx_get_shrunk_proportional_table() instead */
WORD nc_get_shrunk_proportional_table(WORD index);

/** @deprecated Use nc_gfx_shrunk_centroid_get_translated_x() instead */
int nc_shrunk_centroid_get_translated_x(short centerPosX, WORD tileWidth, BYTE shrunkX);
/** @deprecated Use nc_gfx_shrunk_centroid_get_translated_y() instead */
int nc_shrunk_centroid_get_translated_y(short centerPosY, WORD tileHeight, BYTE shrunkY);

/** @deprecated Use nc_gfx_shrunk() instead */
void nc_shrunk(WORD base_sprite, WORD max_width, WORD value);
/** @deprecated Use nc_gfx_shrunk_forge() instead */
WORD nc_shrunk_forge(BYTE xc, BYTE yc);
/** @deprecated Use nc_gfx_shrunk_addr() instead */
void nc_shrunk_addr(WORD addr, WORD shrunk_value);
/** @deprecated Use nc_gfx_shrunk_range() instead */
WORD nc_shrunk_range(WORD addr_start, WORD addr_end, WORD shrunk_value);

/** @deprecated Use nc_gfx_destroy_scroller() instead */
void nc_destroy_gfx_scroller(GFX_Scroller *gfx_scroller);
/** @deprecated Use nc_gfx_destroy_picture() instead */
void nc_destroy_gfx_picture(GFX_Picture *gfx_picture);
/** @deprecated Use nc_gfx_destroy_animated_sprite() instead */
void nc_destroy_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite);
/** @deprecated Use nc_gfx_destroy_physic_picture() instead */
void nc_destroy_gfx_picture_physic(GFX_Physic_Picture *gfx_picture_physic);
/** @deprecated Use nc_gfx_destroy_animated_physic_sprite() instead */
void nc_destroy_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic);

/** @deprecated Use nc_math_vectors_is_collide() instead */
BOOL nc_vectors_collide(Box *box, Position vec[], BYTE vector_max);
/** @deprecated Use nc_math_vector_is_left() instead */
BOOL nc_vector_is_left(short x, short y, short v1x, short v1y, short v2x, short v2y);

/** @deprecated Use nc_math_frame_to_second() instead */
DWORD nc_frame_to_second(DWORD frame);
/** @deprecated Use nc_math_second_to_frame() instead */
DWORD nc_second_to_frame(DWORD second);

/** @deprecated Use nc_math_byte_to_hex() instead */
void nc_byte_to_hex(BYTE value, char *hexchar);
/** @deprecated Use nc_math_word_to_hex() instead */
void nc_word_to_hex(WORD value, char *hexchar);
/** @deprecated Use nc_math_sin() instead */
char nc_sin(WORD index);

/** @deprecated Use nc_joypad_set_edge_mode() instead */
void nc_set_joypad_edge_mode(BOOL actived);
/** @deprecated Use nc_joypad_update() instead */
void nc_update_joypad(BYTE id);
/** @deprecated Use nc_joypad_debug() instead */
void nc_debug_joypad(BYTE id);

/** @deprecated Use nc_log_set_position() instead */
void nc_set_position_log(WORD _x, WORD _y);

/** @deprecated Use nc_sound_set_adpcm_remaining_frame() instead */
void nc_push_remaining_frame_adpcm_player(DWORD frame);
/** @deprecated Use nc_sound_get_adpcm_player() instead */
Adpcm_player *nc_get_adpcm_player();

/** @deprecated Use nc_math_get_relative_position() instead */
void nc_get_relative_position(Position *position, Box box, Position world_coord);

/** @deprecated Use nc_system_init() instead */
void nc_init_system();

/** @deprecated Use nc_system_reset() instead */
void nc_reset();

/** @deprecated Use nc_gpu_pause() instead */
void nc_pause(BOOL (*exitFunc)());

/** @deprecated Use nc_gpu_sleep() instead */
void nc_sleep(DWORD frame);

/** @deprecated Use nc_gpu_update() instead */
void nc_update();

/** @deprecated Use nc_gpu_each_frame() instead */
BOOL nc_each_frame(DWORD frame);

/** @deprecated Use nc_system_get_free_ram_info() instead */
WORD nc_free_ram_info();

/** @deprecated Use nc_physic_update_mask() instead */
void nc_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max);

/** @deprecated Use nc_log_print() instead */
void nc_print(int x, int y, char *label);

/** @} */ // end of Legacy group

#endif
