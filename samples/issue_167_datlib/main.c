#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <input.h>
#include <DATlib.h>
#include <neocore.h>
#include "externs.h"

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;


static bool menu() {
  picture menu_anime;
  WORD palette_index = 16;
  WORD sprite_index = 1;

  /* Initialisation comme dans DATdemo */
  clearFixLayer();
  initGfx();
  backgroundColor(0x0001); /* Fond noir */
  LSPCmode=0x1c00;

  /* Charger la palette */
  palJobPut(
    palette_index,
    menu_anime_girl_darker8_img_Palettes.count,
    menu_anime_girl_darker8_img_Palettes.data
  );

  /* Initialiser et afficher la picture */
  pictureInit(
    &menu_anime,
    &menu_anime_girl_darker8_img,
    sprite_index,
    palette_index,
    0,  /* Position X visible */
    0,  /* Position Y visible */
    0
  );

  /* Afficher la picture */
  pictureShow(&menu_anime);

  while (1) {
    SCClose();
    waitVBlank();

    /* Test des inputs pour passer au jeu - comme dans DATdemo */
    if (volMEMBYTE(PS_EDGE) & P1_START) {
      // pictureSetPos(&menu_anime, 0, 240); /* Hors écran */
      pictureHide(&menu_anime);
      clearSprites(1, menu_anime_girl_darker8_img.tileWidth);
      SCClose();
      waitVBlank();
      return true;
    }
  }

  return false;
}

static void game() {
  aSprite player;
  WORD sprite_index = 1;  /* Index de sprite différent du menu */
  WORD palette_index = 40; /* Palette différente du menu */
  short player_x = 100;
  short player_y = 100;

  /* Initialisation comme dans DATdemo */
  clearFixLayer();
  initGfx();
  backgroundColor(0x0001); /* Fond noir */
  LSPCmode=0x1c00;

  /* Charger la palette du player */
  palJobPut(
    palette_index,
    player_sprite_Palettes.count,
    player_sprite_Palettes.data
  );

  /* Initialiser le sprite animé */
  aSpriteInit(
    &player,
    &player_sprite,
    sprite_index,          /* Index de base du sprite */
    palette_index,         /* Index de palette */
    player_x,              /* Position X */
    player_y,              /* Position Y */
    0,                     /* Animation frame */
    FLIP_NONE,             /* Pas de flip */
    AS_FLAGS_DEFAULT       /* Flags par défaut */
  );

  /* APPLIQUER SHRUNK - TEST DE L'ISSUE #167 */
  /* Coefficient de shrink 50% sur X et Y (0x88) */
  {
    WORD shrunk_value = nc_gpu_get_shrunk_proportional_table(150); /* 50% sur les deux axes */
    WORD sprite_width = 4;    /* Largeur typique d'un sprite animé */
    WORD i;

    /* MÉTHODE DATLIB 0.3 (ACTUELLE) - DÉCOMMENTEZ CETTE LIGNE : */
    for (i = 0; i < sprite_width; i++) {
      SC234Put(VRAM_SHRINK_ADDR(sprite_index + i), shrunk_value);
    }

    /* MÉTHODE NEOCORE ANCIENNE - DÉCOMMENTEZ CES LIGNES POUR TESTER : */
    // for (i = 0; i < sprite_width; i++) {
    //   SC234Put(0x8000 + sprite_index + i, shrunk_value);
    // }
  }

  /* Boucle de jeu */
  while(1) {
    /* Mettre à jour l'animation */
    aSpriteAnimate(&player);

    SCClose();
    waitVBlank();

    /* Test pour revenir au menu */
    if (volMEMBYTE(PS_EDGE) & P1_START) {
      aSpriteHide(&player);
      clearSprites(sprite_index, 4); /* 4 sprites pour un sprite animé typique */
      SCClose();
      waitVBlank();
      break;
    }
  }
}

int main(void) {
  while(1) {
    if (menu()) {
      game();
    } else {
      break;
    }
  }
  return 0;
}
