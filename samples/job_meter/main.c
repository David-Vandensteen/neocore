#include <neocore.h>
#include <DATlib.h>
#include "externs.h"

#define MENU_X            2
#define MENU_Y_INPUT      3
#define MENU_Y_SCROLL     MENU_Y_INPUT + 2
#define MENU_Y_ANIM       MENU_Y_SCROLL + 2
#define MENU_Y_VBLANK     MENU_Y_ANIM + 2
#define MENU_Y_VBPOST     MENU_Y_VBLANK + 2

#define CURSOR_X          MENU_X - 2

static GFX_Animated_Sprite player;
static GFX_Scroller background;
static GFX_Picture planet;

static WORD cursor_y = MENU_Y_INPUT;
static WORD input_cycles = 300;
static WORD scroll_cycles = 400;
static WORD anim_cycles = 900;
static WORD vblank_cycles = 100;
static WORD vbpost_cycles = 100;
static void burn_cpu(volatile int cycles) {
  volatile int i;
  for(i = 0; i < cycles; i++);
}

static void display_menu() {
  nc_log_set_position(MENU_X, 1);
  nc_log_info("JOB METER - OVERLOAD CYCLES");
  
  nc_log_set_position(MENU_X, MENU_Y_INPUT);
  nc_log_info("INPUT : %5d", input_cycles);
  
  nc_log_set_position(MENU_X, MENU_Y_SCROLL);
  nc_log_info("SCROLL : %5d", scroll_cycles);
  
  nc_log_set_position(MENU_X, MENU_Y_ANIM);
  nc_log_info("ANIM : %5d", anim_cycles);
  
  nc_log_set_position(MENU_X, MENU_Y_VBLANK);
  nc_log_info("VBLANK : %5d", vblank_cycles);
  
  nc_log_set_position(MENU_X, MENU_Y_VBPOST);
  nc_log_info("VBPOST : %5d", vbpost_cycles);
  
  nc_log_set_position(MENU_X, 16);
  nc_log_info("UP/DOWN: Navigate");
  nc_log_set_position(MENU_X, 18);
  nc_log_info("LEFT/RIGHT: Adjust (+/-100)");
  
  /* Color reference in bottom right */
  nc_log_set_position(14, 20);
  nc_log_info("COLOR REFERENCE:");
  nc_log_set_position(14, 21);
  nc_log_info("CYAN   : Input");
  nc_log_set_position(14, 22);
  nc_log_info("YELLOW : Scroll");
  nc_log_set_position(14, 23);
  nc_log_info("BLUE   : Animation");
  nc_log_set_position(14, 24);
  nc_log_info("GREEN  : Free CPU");
  nc_log_set_position(14, 25);
  nc_log_info("RED    : VBlank updates");
  nc_log_set_position(14, 26);
  nc_log_info("ORANGE : VBlank post");
}

static void display_cursor() {
  nc_log_set_position(CURSOR_X, MENU_Y_INPUT);
  nc_log_info(" ");
  nc_log_set_position(CURSOR_X, MENU_Y_SCROLL);
  nc_log_info(" ");
  nc_log_set_position(CURSOR_X, MENU_Y_ANIM);
  nc_log_info(" ");
  nc_log_set_position(CURSOR_X, MENU_Y_VBLANK);
  nc_log_info(" ");
  nc_log_set_position(CURSOR_X, MENU_Y_VBPOST);
  nc_log_info(" ");
  nc_log_set_position(CURSOR_X, cursor_y);
  nc_log_info(">");
}

static void handle_menu_input() {
  WORD *selectedCycles = NULL;
  
  if (nc_joypad_is_down(0) && cursor_y < MENU_Y_VBPOST) {
    cursor_y += 2;
    display_cursor();
    return;
  }
  
  if (nc_joypad_is_up(0) && cursor_y > MENU_Y_INPUT) {
    cursor_y -= 2;
    display_cursor();
    return;
  }
  
  /* Select the current cycles variable based on cursor position */
  if (cursor_y == MENU_Y_INPUT) {
    selectedCycles = &input_cycles;
  } else if (cursor_y == MENU_Y_SCROLL) {
    selectedCycles = &scroll_cycles;
  } else if (cursor_y == MENU_Y_ANIM) {
    selectedCycles = &anim_cycles;
  } else if (cursor_y == MENU_Y_VBLANK) {
    selectedCycles = &vblank_cycles;
  } else if (cursor_y == MENU_Y_VBPOST) {
    selectedCycles = &vbpost_cycles;
  }
  
  /* Adjust value if a variable is selected */
  if (selectedCycles != NULL) {
    if (nc_joypad_is_right(0)) {
      *selectedCycles += 100;
      display_menu();
      display_cursor();
    } else if (nc_joypad_is_left(0) && *selectedCycles >= 100) {
      *selectedCycles -= 100;
      display_menu();
      display_cursor();
    }
  }
}

int main(void) {
  nc_joypad_set_edge_mode(TRUE);
  nc_log_init();
  display_menu();
  display_cursor();
  
  nc_gfx_init_and_display_scroller(
    &background,
    &background_sprite,
    &background_sprite_Palettes,
    0,
    0
  );

  nc_gfx_init_and_display_picture(
    &planet,
    &planet04_sprite,
    &planet04_sprite_Palettes,
    20,
    100
  );

  nc_gfx_init_and_display_animated_sprite(
    &player,
    &player_sprite,
    &player_sprite_Palettes,
    200,
    100,
    PLAYER_SPRITE_ANIM_IDLE
  );

  /* Initialize and display the job meter */
  /* IMPORTANT: jobMeterSetup() should NOT be the first function called. */
  /* It must be called after sprite/graphics initialization. */
  jobMeterSetup(true);

  while(1) {
    Position position, backgroundPosition;
    
    /* Simulate VBlank updates overload (before actual VBlank) */
    jobMeterColor(JOB_RED);
    burn_cpu(vblank_cycles);
    
    /* Measure CPU time for input handling */
    jobMeterColor(JOB_CYAN);
    nc_gpu_update();
    
    /* Simulate VBlank post overload (after VBlank) */
    jobMeterColor(JOB_ORANGE);
    burn_cpu(vbpost_cycles);
    
    jobMeterColor(JOB_CYAN);
    /* Handle menu adjustments */
    handle_menu_input();
    
    nc_gfx_get_animated_sprite_position(&player, &position);
    burn_cpu(input_cycles);

    /* Measure CPU time for background scrolling */
    jobMeterColor(JOB_YELLOW);
    nc_gfx_move_scroller(&background, 1, 0);
    nc_gfx_get_scroller_position(&background, &backgroundPosition);
    if (backgroundPosition.x > 512) {
      nc_gfx_set_scroller_position(
        &background,
        0,
        backgroundPosition.y
      );
    }
    burn_cpu(scroll_cycles);
    
    /* Measure CPUtime for animation */
    jobMeterColor(JOB_BLUE);
    nc_gfx_update_animated_sprite_animation(&player);
    burn_cpu(anim_cycles);
    
    /* Back to green = free CPU time */
    jobMeterColor(JOB_GREEN);
    if (nc_joypad_is_start(0) & nc_joypad_is_a(0)) {
      nc_gfx_destroy_animated_sprite(&player);
      nc_gfx_destroy_picture(&planet);
      nc_gfx_destroy_scroller(&background);
    }
  }
  return 0;
}
