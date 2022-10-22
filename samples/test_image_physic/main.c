#include <neocore.h>
#include <math.h>
#include "externs.h"

NEOCORE_INIT

Image_Physic planet04;
Image dot_x, dot_y;

Box planet04_box_origin;

static void _box_shrunk(Box *b, Box *bOrigin, WORD shrunkValue) {
  // todo (minor) - improve precision
  // todo (minor) - consider box offsets
  BYTE shrunk_x = SHRUNK_EXTRACT_X(shrunkValue);
  BYTE pix_step_x = (bOrigin->width DIV16);
  BYTE trim_x = (((15 - shrunk_x) * pix_step_x) DIV2);

  int trim_y;
  FIXED shrunk_y = FIX(SHRUNK_EXTRACT_Y(shrunkValue));
  FIXED pix_step_y = FIX((float)bOrigin->height / (float)256); // todo (minor) - hmmm !!! float
  FIXED shrunk_y_multiplicator = fsub(FIX(255), shrunk_y);
  shrunk_y_multiplicator = fmul(shrunk_y_multiplicator, pix_step_y);
  trim_y = fixtoi(shrunk_y_multiplicator);
  trim_y =  (trim_y DIV2);
  trim_y += 1;

  b->p0.x = bOrigin->p0.x + trim_x - (bOrigin->width DIV2);
  b->p0.y = bOrigin->p0.y + trim_y - (bOrigin->height DIV2);

  b->p1.x = bOrigin->p1.x - trim_x - (bOrigin->width DIV2);
  b->p1.y = bOrigin->p1.y + trim_y - (bOrigin->height DIV2);

  b->p2.x = bOrigin->p2.x - trim_x - (bOrigin->width DIV2);
  b->p2.y = bOrigin->p2.y - trim_y - (bOrigin->height DIV2);

  b->p3.x = bOrigin->p3.x + trim_x - (bOrigin->width DIV2);
  b->p3.y = bOrigin->p3.y - trim_y - (bOrigin->height DIV2);

  b->p4.x = b->p0.x + ((b->p1.x - b->p0.x) DIV2);
  b->p4.y = b->p0.y + ((b->p3.y - b->p0.y) DIV2);
}

static int get_translated_shrunk_x(short x, short width, BYTE shrunk_x) {
  FIXED newX = FIX(x);
  FIXED step_pixels = 0;
  short step_to_trim = 0;

  if (shrunk_x == 0xF) return x;
  if (shrunk_x == 0x0) return x - width;

  step_pixels = FIX(width / 0x0F);
  step_to_trim = 0xF - shrunk_x;
  newX -= step_to_trim * step_pixels;

  return fixtoi(newX);
}

static int get_translated_shrunk_y(short y, short height, WORD shrunk_y) {
  FIXED newY = FIX(y);
  FIXED step_pixels = 0;
  short step_to_trim = 0;

  if (shrunk_y == 0xFF) return y;
  if (shrunk_y == 0x00) return y - height;

  step_pixels = FIX(height / 0xFF);
  step_to_trim = 0xFF - shrunk_y;
  newY -= step_to_trim * step_pixels;

  return fixtoi(newY);
}

static void _image_physic_shrunk(Image_Physic *image_physic, Box *box_origin, WORD shrunk_value) { // todo - neocore dev
  shrunk(image_physic->image.pic.baseSprite, image_physic->image.pic.info->tileWidth, shrunk_value);
  _box_shrunk(&image_physic->box, box_origin, shrunk_value);
}

int main(void) {
  gpu_init();

  image_physic_init(&planet04, &planet04_sprite, &planet04_sprite_Palettes, 128, 128, 0, 0, MANUALBOX);
  box_init(&planet04_box_origin, 128, 128, 0, 0);
  box_init(&planet04.box, 128, 128, 0, 0);

  image_init(&dot_x, &dot_sprite, &dot_sprite_Palettes);
  image_init(&dot_y, &dot_sprite, &dot_sprite_Palettes);

  image_physic_display(&planet04, 100, 50);
  box_update(&planet04.box, 100, 50);
  box_update(&planet04_box_origin, 100, 50);

  image_display(&dot_x, 100, 50);
  image_display(&dot_y, 100 + 128, 50 + 128);


  while(1) {
    wait_vbl();
    logger_init();
    logger_box("BOX : ", &planet04.box);
    logger_short("TRIMED X : ", get_translated_shrunk_x(228, 128, 0xF));
    logger_short("TRIMED Y : ", get_translated_shrunk_y(50 + 128, 128, 0x9));

    _image_physic_shrunk(&planet04, &planet04_box_origin, shrunk_forge(0xF, 0xFF));
    image_set_position(&dot_x, get_translated_shrunk_x(228, 128, 0xF), 50);
    image_set_position(&dot_y, 228, get_translated_shrunk_y(50 + 128, 128, 0x05));

    SCClose();
  };
  SCClose();
  return 0;
}
