#ifndef __DATLIB_H__
#define __DATLIB_H__

#ifdef __cplusplus
	extern "C" {
#endif

//#define BIOS_FRAME_COUNTER 0x10fe88

/*******************************
	INCLUDES
*******************************/
#include <stdio.h>
#include <stdlib.h>
#include <stdtypes.h>

/*******************************
	DEFINES
*******************************/
#define true	1
#define false	0
#define null	0
#define uchar	unsigned char
#define ushort	unsigned short
#define uint	unsigned int
#define YSHIFT	496

//** flip modes - VALUES ARE CODE BOUND, DO NOT CHANGE
#define FLIP_NONE	0
#define FLIP_X		1
#define FLIP_Y		2
#define FLIP_XY		3
#define FLIP_BOTH	3

//** job meter base colors
#define	JOB_BLACK		0x0000
#define	JOB_WHITE		0x7fff

#define	JOB_LIGHTRED	0x7f66
#define	JOB_RED			0x4f00
#define	JOB_DARKRED		0xc900

#define	JOB_LIGHTGREEN	0x76f6
#define	JOB_GREEN		0x20f0
#define	JOB_GARKGREEN	0xa090

#define	JOB_LIGHTBLUE	0x766f
#define	JOB_BLUE		0x100f
#define	JOB_DARKBLUE	0x9009

#define	JOB_LIGHTPURPLE	0x7f6f
#define	JOB_PURPLE		0x5f0f
#define	JOB_DARKPURPLE	0xd909

#define	JOB_LIGHTCYAN	0x76ff
#define	JOB_CYAN		0x30ff
#define	JOB_DARKCYAN	0xb099

#define	JOB_LIGHTYELLOW	0x7ff6
#define	JOB_YELLOW		0x6ff0
#define	JOB_DARKYELLOW	0xe990

#define	JOB_LIGHTORANGE	0x7fa6
#define	JOB_ORANGE		0x4f80
#define	JOB_DARKORANGE	0x2960

#define	JOB_LIGHTPINK	0x5fcf
#define	JOB_PINK		0x5f8f
#define	JOB_DARKPINK	0x2969

//palettes consts

//scrollers consts

//pictures consts

//aSprites consts
#define ASPRITE_FRAMES_ADDR 8

//timer interrupt consts
//384*40 - delay = pixel 0 timing
#define TI_VBL_DELAY			188		//376/2
#define TI_IRQ_DELAY			21		//42/2
#define TI_ZERO					15360-TI_VBL_DELAY-TI_IRQ_DELAY
#define TI_RELOAD				384
#define TI_MODE_SINGLE_DATA		0
#define TI_MODE_DUAL_DATA		1

//sprite pools consts
#define WAY_UP 0
#define WAY_DOWN 1

/*******************************
	MACROS
*******************************/
//** memory/hardware registers access macros
#define MEMBYTE(addr)			(*((PBYTE)(addr)))
#define MEMWORD(addr)			(*((PWORD)(addr)))
#define MEMDWORD(addr)			(*((PDWORD)(addr)))
//** volatile defines
#define volMEMBYTE(addr)		(*((volatile BYTE *)(addr)))
#define volMEMWORD(addr)		(*((volatile WORD *)(addr)))
#define volMEMDWORD(addr)		(*((volatile DWORD *)(addr)))

//** job meter
#define JOB_COLOR				0x4001e2
#define jobMeterColor(color)	(*((volatile WORD *)JOB_COLOR))=(color);
#define BACKGROUND_COLOR		0x401ffe
#define backgroundColor(color)	(*((volatile WORD *)BACKGROUND_COLOR))=(color);

//** SC macros
#define SC1Put(addr,size,pal,data)	{*SC1ptr++=((pal)<<24)|((size)<<18)|(addr);*SC1ptr++=(DWORD)(data);}
#define SC1PutQuick(cmd,data)		{*SC1ptr++=(DWORD)(cmd);*SC1ptr++=(DWORD)(data);}
#define SC234Put(addr,data)			{*SC234ptr++=(addr);*SC234ptr++=(data);}
#define palJobPut(num,count,data)	{*palJobsPtr++=(((count)-1)<<16)|((num)<<5);*palJobsPtr++=(DWORD)(data);}

//** aSprite macros
#define aSpriteHide(as)		{(as)->flags|=0x0080;}
#define aSpriteShow(as)		{(as)->flags&=0xff7f;(as)->flags|=0x0002;}


/*******************************
	TYPEDEFS
*******************************/
//** palettes
typedef struct paletteInfo {
	WORD	palCount;
	WORD	data[0];
} paletteInfo;

//** scrollers
typedef struct scrollerInfo {
	WORD	colSize;		//column size (words)
	WORD	sprHeight;		//sprite tile height
	WORD	mapWidth;		//map tile width
	WORD	mapHeight;		//map tile height
	WORD	map[0];			//map data
} scrollerInfo;

typedef struct scroller {
	WORD	baseSprite;
	WORD	basePalette;
	WORD	colNumber[21];
	WORD	topBk, botBk;
	WORD	scrlPosX, scrlPosY;
	scrollerInfo *info;
	//58 bytes
} scroller;

//** pictures
typedef struct pictureInfo {
	WORD	colSize;		//size of each column (words)
	WORD	unused__height;
	WORD	tileWidth;
	WORD	tileHeight;
	WORD	*maps[4];		//ptrs to maps (std/flipX/flipY/flipXY)
} pictureInfo;

typedef struct picture {
	WORD	baseSprite;
	WORD	basePalette;
	short	posX, posY;
	WORD	currentFlip;
	pictureInfo *info;
	//14 bytes
} picture;

//** animated sprites
typedef struct sprFrame {
	WORD	tileWidth;
	WORD	tileHeight;
	WORD	colSize;
	WORD	*maps[4];
} sprFrame;

typedef struct animStep {
	sprFrame	*frame;
	short		shiftX;
	short		shiftY;
	short		duration;
} animStep;
// /!\ size is code bound

typedef struct animation {
	WORD			stepsCount;
	WORD			repeats;
	animStep		*data;
	//animStep *link;
	struct animation *link;
} animation;
// /!\ size is code bound

typedef struct aSprite {
	WORD		baseSprite;			//
	WORD		basePalette;		//
	short		posX, posY;			//
	short		currentStepNum;		//current step number
	short		maxStep;			// max step # of current animation
	sprFrame	*frames;			// frames bank				//unused
	sprFrame	*currentFrame;		// current frame
	animation	*anims;				//	anims bank
	animation	*currentAnimation;	// current one
	animStep	*steps;				// steps bank of current anim (variable)
	animStep	*currentStep;		// current step
	DWORD		counter;			// frame update counter
	WORD		repeats;			// repeats played
	WORD		currentFlip;		//
	WORD		tileWidth;
	WORD		animID;
	WORD		flags;				//flags (moved/flipped etc)
	//50 bytes
} aSprite;

typedef struct spriteInfo {
	WORD		palCount;
	WORD		frameCount;		//
	WORD		maxWidth;
	animation	*anims;
} spriteInfo;

//** sprite pools
typedef struct spritePool {
	WORD poolStart;
	WORD poolEnd;
	WORD poolSize;
	WORD way;
	WORD currentUp;
	WORD currentDown;
} spritePool;

/*******************************
	VARIABLES EXPORTS
*******************************/
extern DWORD	DAT_frameCounter;	// "real" framecounter. dropped frames won't be added
extern DWORD	DAT_droppedFrames;	// dropped frames counter. 

// draw lists - don't touch this
extern DWORD	SC1[760];
extern DWORD	*SC1ptr;
extern WORD		SC234[2280];
extern WORD		*SC234ptr;
extern DWORD	PALJOBS[514];
extern DWORD	*palJobsPtr;
extern WORD		DAT_drawListReady;

// timer interrupt related
extern WORD		LSPCmode;
extern DWORD	TIbase;				//base timer
extern DWORD	TIreload;			//reload timer
extern WORD		*TInextTable;		//ptr to table for next frame

/*******************************
	FUNCTIONS EXPORTS
*******************************/
//** base stuff
void enableIRQ();
void disableIRQ();

//
void initGfx();
void SCClose();
void waitVBlank();

//timer interrupt
void loadTIirq(ushort);
void unloadTIirq();

//** misc
int setup4P();
void clearFixLayer();
void jobMeterSetup(BOOL setDip);
void clearSprites(WORD spr, WORD count);
void fixPrint(int x, int y, int pal, int bank, const char *buf);
void fixPrintf(int x, int y, int pal, int bank, const char *fmt, ...);
void fixPrintf2(int x, int y, int pal, int bank, const char *fmt, ...);

//** pictures
void pictureInit(picture *p, pictureInfo *pi, WORD baseSprite, BYTE basePalette, short posX, short posY, WORD flip);
void pictureSetPos(picture *p, short toX, short toY);
void pictureSetFlip(picture *p, WORD flip);
void pictureMove(picture *p, short shiftX, short shiftY);
void pictureHide(picture *p);
void pictureShow(picture *p);

//** scrollers
void scrollerInit(scroller *s, scrollerInfo *si, WORD baseSprite, BYTE basePalette, short posX, short posY);
void scrollerSetPos(scroller *s, short toX, short toY);

//** animated sprites
void aSpriteInit(aSprite *as, spriteInfo *si, WORD baseSprite, BYTE basePalette, short posX, short posY, WORD anim, WORD flip);
void aSpriteSetAnim(aSprite *as, WORD anim);
void aSpriteAnimate(aSprite *as);
void aSpriteSetPos(aSprite *as, short newX, short newY);
void aSpriteMove(aSprite *as, short shiftX, short shiftY);
void aSpriteSetFlip(aSprite *as, WORD flip);

//** sprite pools
void spritePoolInit(spritePool *sp, WORD baseSprite, WORD size);
void spritePoolDrawList(spritePool *sp,void *list);
int spritePoolClose(spritePool *sp);


#ifdef __cplusplus
	}
#endif

#endif // __DATLIB_H__
