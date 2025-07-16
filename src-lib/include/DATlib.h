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
#define	bool	unsigned short
#define YSHIFT	496

//** flip modes - VALUES ARE CODE BOUND, DO NOT CHANGE
#define FLIP_NONE	0
#define FLIP_X		1
#define FLIP_Y		2
#define FLIP_XY		3
#define FLIP_BOTH	3

//** job meter base colors
#define	JOB_BLACK		0x8000
#define	JOB_WHITE		0x7fff

#define	JOB_LIGHTRED	0xcf88
#define	JOB_RED			0x4f00
#define	JOB_DARKRED		0x8800

#define	JOB_LIGHTGREEN	0xa8f8
#define	JOB_GREEN		0x20f0
#define	JOB_DARKGREEN	0x8080

#define	JOB_LIGHTBLUE	0x988f
#define	JOB_BLUE		0x100f
#define	JOB_DARKBLUE	0x8008

#define	JOB_LIGHTPURPLE	0x7f6f
#define	JOB_PURPLE		0x5f0f
#define	JOB_DARKPURPLE	0xd909

#define	JOB_LIGHTCYAN	0x7bff
#define	JOB_CYAN		0x30ff
#define	JOB_DARKCYAN	0x8088

#define	JOB_LIGHTYELLOW	0x7ffb
#define	JOB_YELLOW		0x6ff0
#define	JOB_DARKYELLOW	0x8880

#define	JOB_LIGHTORANGE	0x6fb0
#define	JOB_ORANGE		0x4f80
#define	JOB_DARKORANGE	0x8840

#define	JOB_LIGHTPINK	0x5fcf
#define	JOB_PINK		0x5f8f
#define	JOB_DARKPINK	0x8808

#define	JOB_LIGHTGREY	0x7bbb
#define	JOB_GREY		0x8888
#define	JOB_DARKGREY	0x8444

//palettes consts

//scrollers consts

//pictures consts

//aSprites consts
#define	AS_FLAGS_DEFAULT		0x0000
#define	AS_FLAG_MOVED			0x0001
#define	AS_FLAG_FLIPPED			0x0002
#define	AS_FLAG_STD_COORDS		0x0000
#define	AS_FLAG_STRICT_COORDS	0x0040
#define	AS_FLAG_DISPLAY			0x0000
#define	AS_FLAG_NODISPLAY		0x0080

#define	AS_MASK_MOVED			0xfffe
#define	AS_MASK_FLIPPED			0xfffd
#define	AS_MASK_MOVED_FLIPPED	0xfffc
#define	AS_MASK_STRICT_COORDS	0xffbf
#define	AS_MASK_NODISPLAY		0xff7f

#define	AS_USE_SPRITEPOOL		0x8000
#define	AS_NOSPRITECLEAR		0x8000

//timer interrupt consts
//384*40 - delay = pixel 0 timing
#define TI_VBL_DELAY			188		//376/2
#define TI_IRQ_DELAY			21		//42/2
#define TI_ZERO					15360-TI_VBL_DELAY-TI_IRQ_DELAY
#define TI_RELOAD				384
#define TI_MODE_SINGLE_DATA		0
#define TI_MODE_DUAL_DATA		1

//sprite pools consts
#define WAY_UP		0
#define WAY_DOWN	1

//fix display
#define	FIX_LINE_WRITE		0x20
#define	FIX_COLUMN_WRITE	0x01

//color streams
#define COLORSTREAM_STARTCONFIG	0
#define COLORSTREAM_ENDCONFIG	1

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
#define fixJobPut(x,y,mod,pal,addr)	{*fixJobsPtr++=(((0x7000+((x)<<5)+(y))<<16)|(((pal)<<12)|(mod)));*fixJobsPtr++=(DWORD)(addr);}

//** aSprite macros
#define aSpriteHide(as)		{(as)->flags|=AS_FLAG_NODISPLAY;}
#define aSpriteShow(as)		{(as)->flags&=AS_MASK_NODISPLAY;(as)->flags|=AS_FLAG_FLIPPED;}

//** misc VRAM macros
#define	SPR_LINK			0x0040
#define SPR_UNLINK			0x0000

#define	VRAM_SPR_ADDR(s)	((s)<<6)
#define	VRAM_FIX_ADDR(x,y)	(0x7000+(((x)<<5)+(y)))
#define	VRAM_SHRINK_ADDR(s)	(0x8000|(s))
#define	VRAM_SHRINK(h,v)	(((h)<<8)|(v))
#define	VRAM_POSY_ADDR(s)	(0x8200|(s))
#define	VRAM_POSY(y,l,h)	(((YSHIFT-(y))<<7)|(l)|(h))
#define	VRAM_POSX_ADDR(s)	(0x8400|(s))
#define	VRAM_POSX(x)		((x)<<7)

/*******************************
	TYPEDEFS
*******************************/
//** palettes
typedef struct paletteInfo {
	ushort	count;
	ushort	data[0];
} paletteInfo;


//** color streams
typedef struct colorStreamInfo {
	ushort	palSlots;
	void	*startConfig;
	void	*endConfig;
	void	*fwData;
	void	*fwDataEnd;
	void	*bwData;
	void	*bwDataEnd;
} colorStreamInfo;

typedef struct colorStreamJob {
	ushort	coord;
	void	*data;
} colorStreamJob;

typedef struct colorStream {
	ushort	basePalette;
	ushort	position;
	colorStreamInfo	*info;
	colorStreamJob	*fwJob;
	colorStreamJob	*bwJob;
} colorStream;


//** scrollers
typedef struct scrollerInfo {
	ushort		stripSize;		//column size (bytes)
	ushort		sprHeight;		//sprite tile height
	ushort		mapWidth;		//map tile width
	ushort		mapHeight;		//map tile height
	paletteInfo	*palInfo;
	colorStreamInfo	*csInfo;
	ushort		*strips[0];		//ptr to strips data
} scrollerInfo;

typedef struct scroller {
	ushort		baseSprite;
	ushort		basePalette;
	short		scrlPosX, scrlPosY;
	scrollerInfo *info;
	ushort		config[32];
} scroller;	//76 bytes


//** pictures
typedef struct pictureInfo {
	ushort		stripSize;		//size of each strip (bytes)
	ushort		tileWidth;
	ushort		tileHeight;
	paletteInfo	*palInfo;
	ushort		*maps[4];		//ptrs to maps (std/flipX/flipY/flipXY)
} pictureInfo;

typedef struct picture {
	ushort		baseSprite;
	ushort		basePalette;
	short		posX, posY;
	ushort		currentFlip;
	pictureInfo *info;
	//14 bytes
} picture;


//** animated sprites
typedef struct sprFrame {
	ushort	tileWidth;
	ushort	tileHeight;
	ushort	stripSize;
	ushort	*maps[4];
} sprFrame;

typedef struct animStep {
	sprFrame	*frame;
	short		shiftX;
	short		shiftY;
	ushort		duration;
} animStep;
// /!\ size is code bound

typedef struct spriteInfo {
	ushort		frameCount;
	ushort		maxWidth;
	paletteInfo	*palInfo;
	animStep	**anims;
	sprFrame	frames[0];
} spriteInfo;

typedef struct aSprite {
	ushort		baseSprite;			//
	ushort		basePalette;		//
	short		posX, posY;			//
	ushort		animID;
	ushort		currentAnim;
	ushort		stepNum;			//current step number
	animStep	*anims;				// anims bank
	animStep	*steps;				// steps bank of current anim (variable)
	animStep	*currentStep;		// current step
	sprFrame	*currentFrame;		// current frame
	uint		counter;			// frame update counter
	ushort		repeats;			// repeats played
	ushort		tileWidth;			//
	ushort		currentFlip;		//
	ushort		flags;				//flags (moved/flipped etc)
	//42 bytes
} aSprite;


//** sprite pools
typedef struct spritePool {
	ushort	poolStart;
	ushort	poolEnd;
	ushort	poolSize;
	ushort	way;
	ushort	currentUp;
	ushort	currentDown;
} spritePool;


/*******************************
	VARIABLES EXPORTS
*******************************/
extern uint	DAT_frameCounter;		// "real" framecounter. (dropped frames won't be added)
extern uint	DAT_droppedFrames;		// dropped frames counter.
extern void	*VBL_callBack;			// VBlank callback function pointer
extern void	*VBL_skipCallBack;		// VBlank callback function pointer (dropped frame)

// draw lists - don't touch this
extern uint		SC1[760];
extern uint		*SC1ptr;
extern ushort	SC234[2280];
extern ushort	*SC234ptr;
extern uint		PALJOBS[514];
extern uint		*palJobsPtr;
extern uint		FIXJOBS[129];
extern uint		*fixJobsPtr;
extern ushort	DAT_drawListReady;

// timer interrupt related
extern ushort	LSPCmode;
extern uint		TIbase;				//base timer
extern uint		TIreload;			//reload timer
extern ushort	*TInextTable;		//ptr to table for next frame

//scratchpads
extern uchar	DAT_scratchpad64[64];	// 64 bytes scratchpad
extern uchar	DAT_scratchpad16[16];	// 16 bytes scratchpad

//data
extern const ushort _fixBlankLine[41]; //a 16bit formatted blank string


/*******************************
	FUNCTIONS EXPORTS
*******************************/
//** base stuff
void enableIRQ();
void disableIRQ();
void initGfx();
void SCClose();
void waitVBlank();

//timer interrupt
void loadTIirq(ushort);
void unloadTIirq();

//** misc
int setup4P();
void jobMeterSetup(bool setDip);
void jobMeterSetup2(bool setDip);
void clearSprites(ushort spr, ushort count);

//** text/fix
void clearFixLayer();
void clearFixLayer2();
void clearFixLayer3();
void fixPrint(ushort x, ushort y, ushort pal, ushort bank, const char *buf);
void fixPrint2(ushort x, ushort y, ushort pal, ushort bank, const char *buf);
void fixPrint3(ushort x, ushort y, ushort pal, const ushort *buf);
void fixPrint4(ushort x, ushort y, ushort pal, const ushort *buf);
void fixPrintf(ushort x, ushort y, ushort pal, ushort bank, const char *fmt, ...);
ushort sprintf2(char*,char*,...);
#define fixPrintf1(x,y,a,b,...)	do{sprintf2(DAT_scratchpad64,__VA_ARGS__);fixPrint((x),(y),(a),(b),DAT_scratchpad64);}while(0)
#define fixPrintf2(x,y,a,b,...)	do{sprintf2(DAT_scratchpad64,__VA_ARGS__);fixPrint2((x),(y),(a),(b),DAT_scratchpad64);}while(0)
ushort sprintf3(ushort,ushort,char*,char*,...);
#define fixPrintf3(x,y,pal,bank,buffer,...)	do{sprintf3(0,bank,(char*)buffer,__VA_ARGS__);fixJobPut((x),(y),FIX_LINE_WRITE,(pal),(buffer));}while(0)

//** pictures
void pictureInit(picture *p, const pictureInfo *pi, ushort baseSprite, ushort basePalette, short posX, short posY, ushort flip);
void pictureSetPos(picture *p, short toX, short toY);
void pictureSetFlip(picture *p, ushort flip);
void pictureMove(picture *p, short shiftX, short shiftY);
void pictureHide(picture *p);
void pictureShow(picture *p);

//** scrollers
void scrollerInit(scroller *s, const scrollerInfo *si, ushort baseSprite, ushort basePalette, short posX, short posY);
void scrollerSetPos(scroller *s, short toX, short toY);

//** animated sprites
void aSpriteInit(aSprite *as, const spriteInfo *si, ushort baseSprite, ushort basePalette, short posX, short posY, ushort anim, ushort flip, ushort flags);
void aSpriteAnimate(aSprite *as);
void aSpriteSetAnim(aSprite *as, ushort anim);
void aSpriteSetAnim2(aSprite *as, ushort anim);
void aSpriteSetStep(aSprite *as, ushort step);
void aSpriteSetStep2(aSprite *as, ushort step);
void aSpriteSetAnimStep(aSprite *as, ushort anim, ushort step);
void aSpriteSetAnimStep2(aSprite *as, ushort anim, ushort step);
void aSpriteSetPos(aSprite *as, short newX, short newY);
void aSpriteMove(aSprite *as, short shiftX, short shiftY);
void aSpriteSetFlip(aSprite *as, ushort flip);

//** sprite pools
void spritePoolInit(spritePool *sp, ushort baseSprite, ushort size, bool clearSprites);
void spritePoolDrawList(spritePool *sp,void *list);
void spritePoolDrawList2(spritePool *sp,void *list);
ushort spritePoolClose(spritePool *sp);

//color streams
void colorStreamInit(colorStream *cs, const colorStreamInfo *csi, ushort basePalette, ushort config);
void colorStreamSetPos(colorStream *cs, ushort pos);


#ifdef __cplusplus
	}
#endif

#endif // __DATLIB_H__
