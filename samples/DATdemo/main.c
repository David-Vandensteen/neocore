#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <input.h>
#include <DATlib.h>
#include "externs.h"

#define FRONT_START_X 157
#define FRONT_START_Y 24
#define FRONT_MIN_X 8
#define FRONT_MAX_X 307
#define FRONT_MIN_Y 16
#define FRONT_MAX_Y 24

#define BACK_MIN_X 8
#define BACK_MAX_X 149
#define BACK_MIN_Y 5
#define BACK_MAX_Y 8

typedef struct bkp_ram_info {
	WORD debug_dips;
	BYTE stuff[254];
	//256 bytes
} bkp_ram_info;

bkp_ram_info bkp_data;

extern uint _end;
BYTE p1,p2,ps,p1e,p2e;
uint callBackCounter;

//fix palettes for text
static const ushort fixPalettes[]= {
	0x8000, 0xefb8, 0x0222, 0x5fa7, 0xde85, 0x2c74, 0x2a52, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000,
	0x8000, 0xebea, 0x0041, 0xa9d8, 0x57c7, 0xf6b5, 0x43a4, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000,
	0x8000, 0x014c, 0x9113, 0xb15e, 0x317f, 0x119f, 0x11af, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000,
	0x8000, 0xeb21, 0x0111, 0xee21, 0x6f31, 0x6f51, 0x6f61, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000,
	0x8000, 0xed31, 0xc311, 0xee51, 0x4f81, 0x4fa1, 0x4fc1, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000,
	0x8000, 0xbad3, 0x0111, 0x09c0, 0xe7b0, 0xc580, 0xe250, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000,
	0x8000, 0xefb8, 0x0111, 0xde96, 0x3c75, 0x2950, 0x4720, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000,
	0x8000, 0x8444, 0x0111, 0xf555, 0xf666, 0x7777, 0x8888, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000 };
	
#define CLIPPING 5

void scrollerInitClipped(scroller *s, scrollerInfo *si, ushort baseSprite, ushort basePalette, short posX, short posY, ushort clipping) {
	ushort i,addr,pos;

	scrollerInit(s,si,baseSprite,basePalette,posX,posY);
	addr=VRAM_POSY_ADDR(baseSprite);
	//pos=((YSHIFT-(0-posY))<<7)|(clipping&0x3f);
	pos=VRAM_POSY(-posY,SPR_UNLINK,clipping);
	for(i=0;i<21;i++)
		SC234Put(addr++,pos);
}

void scrollerSetPosClipped(scroller *s, short toX, short toY, ushort clipping) {
	ushort i,addr,pos;

	if(s->scrlPosY!=toY) {	//Y moved ?
		scrollerSetPos(s,toX,toY);
		
		addr=VRAM_POSY_ADDR(s->baseSprite);
		//pos=((YSHIFT-(0-toY))<<7)|(clipping&0x3f);
		pos=VRAM_POSY(-toY,SPR_UNLINK,clipping);
		for(i=0;i<21;i++)
			SC234Put(addr++,pos);
		//s->scrlPosY=toY;
	} else scrollerSetPos(s,toX,toY);
}

void scrollerDemo() {
	int x=FRONT_START_X;
	int y=FRONT_START_Y;
	int carx=320;
	int cary=106;
	int backX;
	int backY;

	scroller backScroll, frontScroll;
	picture car;

	backgroundColor(0x7bbb);
	LSPCmode=0x1c00;	//autoanim speed
	clearFixLayer();
	jobMeterSetup(true);

	scrollerInit(&backScroll, &ffbg_a, 1, 16, (((x-8)*141)/299)+BACK_MIN_X, (((y-16)*3)/8)+BACK_MIN_Y);
	palJobPut(16, ffbg_a.palInfo->count, ffbg_a.palInfo->data);

	scrollerInit(&frontScroll, &ffbg_b, 22, 16 + ffbg_a.palInfo->count, x, y);
	//scrollerInitClipped(&frontScroll, &ffbg_b, 22, 16 + ffbg_a.palInfo->count, x, y, CLIPPING);
	palJobPut(16 + ffbg_a.palInfo->count, ffbg_b.palInfo->count, ffbg_b.palInfo->data);

	pictureInit(&car, &ffbg_c, 43, 16 + ffbg_a.palInfo->count + ffbg_b.palInfo->count, carx, cary, FLIP_NONE);
	palJobPut(16 + ffbg_a.palInfo->count + ffbg_b.palInfo->count, ffbg_c.palInfo->count, ffbg_c.palInfo->data);

	fixPrint(2,3,4,3,"1P \x12\x13\x10\x11: scroll");

	SCClose();
	while(1) {
		waitVBlank();

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_PURPLE);

		p1=volMEMBYTE(P1_CURRENT);
		ps=volMEMBYTE(PS_EDGE);
		
		if(ps&P1_START) {
			clearSprites(1, 42+ffbg_c.tileWidth);
			SCClose();
			waitVBlank();
			return;
		}

		if(p1&JOY_UP)	y--;
		if(p1&JOY_DOWN)	y++;
		if(p1&JOY_LEFT)	x--;
		if(p1&JOY_RIGHT)	x++;

		if(x<FRONT_MIN_X) x=FRONT_MIN_X;
		else if(x>FRONT_MAX_X) x=FRONT_MAX_X;
		if(y<FRONT_MIN_Y) y=FRONT_MIN_Y;
		else if(y>FRONT_MAX_Y) y=FRONT_MAX_Y;

		if(x>161) {
			cary=106+(24-y);
			pictureSetPos(&car,320-(x-161),cary);
		}	else pictureSetPos(&car,320,cary);

		backX=(((x-8)*141)/299)+BACK_MIN_X;
		backY=(((y-16)*3)/8)+BACK_MIN_Y;
		
		jobMeterColor(JOB_BLUE);
		scrollerSetPos(&frontScroll, x, y);
		//scrollerSetPosClipped(&frontScroll, x, y, CLIPPING);
		scrollerSetPos(&backScroll, backX, backY);
		jobMeterColor(JOB_GREEN);
		SCClose();
	}
}

void sortSprites(aSprite *list[], int count) {
	//insertion sort
	int x,y;
	aSprite *tmp;
	
	for(x=1;x<count;x++) {
		y=x;
		while(y>0 && (list[y]->posY < list[y-1]->posY)) {
			tmp=list[y];
			list[y]=list[y-1];
			list[y-1]=tmp;
			y--;
		}
	}
}

#define POOL_MODE
#define LOTS

void aSpriteDemo() {
	int x=87;
	int y=136;
	int relX,relY;
	short showdebug=false;
	aSprite demoSpr,demoSpr2,demoSpr3;
	ushort *data;
	ushort flipMode=0,anim=0;
	#ifdef POOL_MODE
	spritePool testPool;
	uint *drawTable[16];
	uint *drawTablePtr;
	int sortSize;
		#ifdef LOTS
		aSprite demoSpr4,demoSpr5,demoSpr6,demoSpr7,demoSpr8,demoSpr9,demoSprA;
		#endif
	#endif
	short way1=JOY_UP,way2=JOY_UP;

	clearFixLayer();
	backgroundColor(0x7bbb);
	jobMeterSetup(true);

	#ifdef POOL_MODE
	aSpriteInit(&demoSpr,&bmary_spr,AS_USE_SPRITEPOOL,16,x,y,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr2,&bmary_spr,AS_USE_SPRITEPOOL,16,160-16,y,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr3,&bmary_spr,AS_USE_SPRITEPOOL,16,160+16,y,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	#ifdef LOTS
	aSpriteInit(&demoSpr4,&bmary_spr,AS_USE_SPRITEPOOL,16,160+32,146,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr5,&bmary_spr,AS_USE_SPRITEPOOL,16,160-32,156,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr6,&bmary_spr,AS_USE_SPRITEPOOL,16,160+48,166,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr7,&bmary_spr,AS_USE_SPRITEPOOL,16,160-48,176,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr8,&bmary_spr,AS_USE_SPRITEPOOL,16,160+10,186,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr9,&bmary_spr,AS_USE_SPRITEPOOL,16,160-10,196,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSprA,&bmary_spr,AS_USE_SPRITEPOOL,16,87,206,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	#endif
	#else
	aSpriteInit(&demoSpr,&bmary_spr,1,16,x,y,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr2,&bmary_spr,5,16,160-16,y,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	aSpriteInit(&demoSpr3,&bmary_spr,9,16,160+16,y,0,FLIP_NONE,AS_FLAGS_DEFAULT);
	#endif

	palJobPut(16,bmary_spr.palInfo->count,&bmary_spr.palInfo->data);

	data=dbgTags.maps[0];
	palJobPut(200,dbgTags.palInfo->count,&dbgTags.palInfo->data);
	SC234Put(VRAM_POSX_ADDR(200),VRAM_POSX(0));
	SC234Put(VRAM_POSY_ADDR(200),VRAM_POSY(224,SPR_UNLINK,0));
	SC234Put(VRAM_SPR_ADDR(200),data[4<<1]);
	SC234Put(VRAM_SPR_ADDR(200)+1,200<<8);
	SC234Put(VRAM_POSX_ADDR(201),VRAM_POSX(0));
	SC234Put(VRAM_POSY_ADDR(201),VRAM_POSY(224,SPR_UNLINK,0));
	SC234Put(VRAM_SPR_ADDR(201),data[40<<1]);
	SC234Put(VRAM_SPR_ADDR(201)+1,200<<8);
	SC234Put(VRAM_POSX_ADDR(202),VRAM_POSX(0));
	SC234Put(VRAM_POSY_ADDR(202),VRAM_POSY(224,SPR_UNLINK,0));
	SC234Put(VRAM_SPR_ADDR(202),data[40<<1]);
	SC234Put(VRAM_SPR_ADDR(202)+1,(200<<8)|FLIP_X);
	SC234Put(VRAM_POSX_ADDR(203),VRAM_POSX(0));
	SC234Put(VRAM_POSY_ADDR(203),VRAM_POSY(224,SPR_UNLINK,0));
	SC234Put(VRAM_SPR_ADDR(203),data[40<<1]);
	SC234Put(VRAM_SPR_ADDR(203)+1,(200<<8)|FLIP_Y);
	SC234Put(VRAM_POSX_ADDR(204),VRAM_POSX(0));
	SC234Put(VRAM_POSY_ADDR(204),VRAM_POSY(224,SPR_UNLINK,0));
	SC234Put(VRAM_SPR_ADDR(204),data[40<<1]);
	SC234Put(VRAM_SPR_ADDR(204)+1,(200<<8)|FLIP_XY);

	fixPrint(2,3,4,3,"1P \x12\x13\x10\x11: move sprite");
	fixPrint(2,4,4,3,"1P A+\x12\x13\x10\x11: flip mode");
	fixPrint(2,5,4,3,"1P B/C/D: toggle animation");
	fixPrint(12,6,4,3,"/coords mode/debug");

	#ifdef POOL_MODE
	spritePoolInit(&testPool,10,80,true);
	drawTablePtr=(int*)drawTable;
	*drawTablePtr++=0;
	*drawTablePtr++=(uint)&demoSpr;
	*drawTablePtr++=(uint)&demoSpr2;
	*drawTablePtr++=(uint)&demoSpr3;
	sortSize=3;
		#ifdef LOTS
		*drawTablePtr++=(uint)&demoSpr4;
		*drawTablePtr++=(uint)&demoSpr5;
		*drawTablePtr++=(uint)&demoSpr6;
		*drawTablePtr++=(uint)&demoSpr7;
		*drawTablePtr++=(uint)&demoSpr8;
		*drawTablePtr++=(uint)&demoSpr9;
		*drawTablePtr++=(uint)&demoSprA;
		sortSize=10;
		#endif
	*drawTablePtr=0;

	sortSprites((aSprite**)&drawTable[1],sortSize);
	spritePoolDrawList(&testPool,&drawTable[1]);
	spritePoolClose(&testPool);
	#else
	aSpriteAnimate(&demoSpr);
	aSpriteAnimate(&demoSpr2);
	aSpriteAnimate(&demoSpr3);
	#endif

	while(1) {
		SCClose();
		waitVBlank();

		p1=volMEMBYTE(P1_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);
		p2=volMEMBYTE(P2_EDGE);
		ps=volMEMBYTE(PS_CURRENT);

		if(ps&P1_START) {
			clearSprites(1, 150);
			clearSprites(200, 5);
			SCClose();
			waitVBlank();
			return;
		}

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_BLUE);
		
		if(p1&JOY_A) {
			if(p1e&JOY_DOWN)	flipMode|=FLIP_Y;
			if(p1e&JOY_UP)		flipMode&=~FLIP_Y;
			if(p1e&JOY_LEFT)	flipMode|=FLIP_X;
			if(p1e&JOY_RIGHT)	flipMode&=~FLIP_X;
			aSpriteSetFlip(&demoSpr,flipMode);
		} else {
			if(p1&JOY_UP)	y--;
			if(p1&JOY_DOWN)	y++;
			if(p1&JOY_LEFT)	x--;
			if(p1&JOY_RIGHT)x++;
			
			if(p1e&JOY_B)	aSpriteSetAnim(&demoSpr,anim^=1);
			if(p1e&JOY_C)	{demoSpr.flags^=AS_FLAG_STRICT_COORDS;demoSpr.flags|=AS_FLAG_FLIPPED;}
			//if(p1e&JOY_D)	aSpriteSetAnim(&demoSpr,2);
			
			if(p1e&JOY_D) {
				if(showdebug) {
					//move debug stuff offscreen
					SC234Put(VRAM_POSY_ADDR(200),VRAM_POSY(224,SPR_UNLINK,0));
					SC234Put(VRAM_POSY_ADDR(201),VRAM_POSY(224,SPR_UNLINK,0));
					SC234Put(VRAM_POSY_ADDR(202),VRAM_POSY(224,SPR_UNLINK,0));
					SC234Put(VRAM_POSY_ADDR(203),VRAM_POSY(224,SPR_UNLINK,0));
					SC234Put(VRAM_POSY_ADDR(204),VRAM_POSY(224,SPR_UNLINK,0));
					fixJobPut(0,25,FIX_LINE_WRITE,0,_fixBlankLine);
					fixJobPut(0,26,FIX_LINE_WRITE,0,_fixBlankLine);
					fixJobPut(0,27,FIX_LINE_WRITE,0,_fixBlankLine);
					fixJobPut(0,28,FIX_LINE_WRITE,0,_fixBlankLine);
				}
				showdebug^=1;
			}
		}
	
		//	if(p2&JOY_A) aSpriteSetStep(&demoSpr, 3);
		//	if(p2&JOY_B) aSpriteSetStep2(&demoSpr, 3);
		//	if(p2&JOY_C) aSpriteSetAnimStep(&demoSpr, 0, 3);
		//	if(p2&JOY_D) aSpriteSetAnimStep2(&demoSpr, 0, 3);

		aSpriteSetPos(&demoSpr,x,y);

		if(way1==JOY_UP) {
			aSpriteMove(&demoSpr2,0,2);
			if(demoSpr2.posY>220) way1=JOY_DOWN;
		} else {
			aSpriteMove(&demoSpr2,0,-2);
			if(demoSpr2.posY<90) way1=JOY_UP;
		}
		if(way2==JOY_UP) {
			aSpriteMove(&demoSpr3,0,1);
			if(demoSpr3.posY>220) way2=JOY_DOWN;
		} else {
			aSpriteMove(&demoSpr3,0,-1);
			if(demoSpr3.posY<90) way2=JOY_UP;
		}

		#ifdef POOL_MODE
		sortSprites((aSprite**)&drawTable[1],sortSize);
		jobMeterColor(JOB_PINK);

		//if(p1&JOY_A)
		//	spritePoolDrawList2(&testPool,testPool.way==WAY_UP?(void*)&drawTable[1]:(void*)drawTablePtr);
		//else spritePoolDrawList(&testPool,testPool.way==WAY_UP?(void*)&drawTable[1]:(void*)drawTablePtr);
		spritePoolDrawList(&testPool,testPool.way==WAY_UP?(void*)&drawTable[1]:(void*)drawTablePtr);
		
		#else
		aSpriteAnimate(&demoSpr);
		aSpriteAnimate(&demoSpr2);
		aSpriteAnimate(&demoSpr3);
		#endif

		//aSprite debug info
		if(showdebug) {
			jobMeterColor(JOB_BLACK);
			if(!(demoSpr.flags&AS_FLAG_STRICT_COORDS)) {
				if(demoSpr.currentFlip&FLIP_X) relX=x-((demoSpr.currentFrame->tileWidth<<4)+demoSpr.currentStep->shiftX)+1;
					else relX=x+demoSpr.currentStep->shiftX;
				if(demoSpr.currentFlip&FLIP_Y) relY=y-((demoSpr.currentFrame->tileHeight<<4)+demoSpr.currentStep->shiftY)+1;
					else relY=y+demoSpr.currentStep->shiftY;
			} else {
				relX=demoSpr.posX;
				relY=demoSpr.posY;
			}
			SC234Put(VRAM_POSX_ADDR(200),VRAM_POSX(x-3));
			SC234Put(VRAM_POSY_ADDR(200),VRAM_POSY(y-3,SPR_UNLINK,1));
			SC234Put(VRAM_POSX_ADDR(201),VRAM_POSX(relX));
			SC234Put(VRAM_POSY_ADDR(201),VRAM_POSY(relY,SPR_UNLINK,1));
			SC234Put(VRAM_POSX_ADDR(202),VRAM_POSX(relX+((demoSpr.currentFrame->tileWidth-1)<<4)));
			SC234Put(VRAM_POSY_ADDR(202),VRAM_POSY(relY,SPR_UNLINK,1));
			SC234Put(VRAM_POSX_ADDR(203),VRAM_POSX(relX));
			SC234Put(VRAM_POSY_ADDR(203),VRAM_POSY(relY+((demoSpr.currentFrame->tileHeight-1)<<4),SPR_UNLINK,1));
			SC234Put(VRAM_POSX_ADDR(204),VRAM_POSX(relX+((demoSpr.currentFrame->tileWidth-1)<<4)));
			SC234Put(VRAM_POSY_ADDR(204),VRAM_POSY(relY+((demoSpr.currentFrame->tileHeight-1)<<4),SPR_UNLINK,1));
			
			//debug live update prints = 1 frame ahead. meh.
			jobMeterColor(JOB_GREY);
			fixPrintf1(3,25,2,3,"Anim data: A:%02d S:%02d R:%02d   ",demoSpr.currentAnim,demoSpr.stepNum,demoSpr.repeats);
			fixPrintf1(3,26,2,3,"Step data: Frame:0x%06x",bmary_spr.anims[demoSpr.currentAnim][demoSpr.stepNum].frame);
			fixPrintf1(14,27,2,3,"SX:%04d SY:%04d D:%02d",
				bmary_spr.anims[demoSpr.currentAnim][demoSpr.stepNum].shiftX,
				bmary_spr.anims[demoSpr.currentAnim][demoSpr.stepNum].shiftY,
				bmary_spr.anims[demoSpr.currentAnim][demoSpr.stepNum].duration
			);
			fixPrintf1(2,28,2,3,"Frame data: W:%02d H:%02d TMAP:0x%06x",
				((sprFrame*)(bmary_spr.anims[demoSpr.currentAnim][demoSpr.stepNum].frame))->tileWidth,
				((sprFrame*)(bmary_spr.anims[demoSpr.currentAnim][demoSpr.stepNum].frame))->tileHeight,
				((sprFrame*)(bmary_spr.anims[demoSpr.currentAnim][demoSpr.stepNum].frame))->maps[demoSpr.currentFlip]
			);
		}

		#ifdef POOL_MODE
		spritePoolClose(&testPool);
		#endif

		jobMeterColor(JOB_GREEN);
	}
}

const char sinTable[]={	32,34,35,37,38,40,41,43,44,46,47,48,50,51,52,53,
						55,56,57,58,59,59,60,61,62,62,63,63,63,64,64,64,
						64,64,64,64,63,63,63,62,62,61,60,59,59,58,57,56,
						55,53,52,51,50,48,47,46,44,43,41,40,38,37,35,34,
						32,30,29,27,26,24,23,21,20,18,17,16,14,13,12,11,
						9,8,7,6,5,5,4,3,2,2,1,1,1,0,0,0,
						0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,8,
						9,11,12,13,14,16,17,18,20,21,23,24,26,27,29,30};

void pictureDemo() {
	int x=94+48;
	int y=54;
	int i,j;
	picture testPict;
	//Picture gradientPict;
	ushort raster=false;
	ushort tableShift=0;
	ushort rasterData0[512];
	ushort rasterData1[512];
	ushort rasterAddr;
	ushort *dataPtr;
	short displayedRasters;
	ushort flipMode=0;

	clearFixLayer();
	backgroundColor(0x7bbb);
	initGfx();
	jobMeterSetup(true);

	LSPCmode=0x1c00;
	loadTIirq(TI_MODE_SINGLE_DATA);

	pictureInit(&testPict, &terrypict,1, 16, x, y,FLIP_NONE);
	palJobPut(16,terrypict.palInfo->count,terrypict.palInfo->data);

	rasterAddr=0x8400+testPict.baseSprite;

	//pictureInit(&gradientPict, &gradient,64, 32, 32, y,FLIP_NONE);
	//palJobPut(32,gradient_Palettes.count,gradient_Palettes.data);

	fixPrint(2,3,4,3,"1P \x12\x13\x10\x11: move picture");
	fixPrint(2,4,4,3,"1P A+\x12\x13\x10\x11: flip mode");
	fixPrint(2,5,4,3,"1P B: toggle rasters");
	
	while(1) {
		SCClose();
		waitVBlank();

		ps=volMEMBYTE(PS_CURRENT);
		p1=volMEMBYTE(P1_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);
		
		if(ps&P1_START) {
			clearSprites(1, terrypict.tileWidth);
			clearSprites(64, gradient.tileWidth);
			TInextTable=0;
			SCClose();
			waitVBlank();
			unloadTIirq();
			return;
		}

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_BLUE);

		if(p1&JOY_A) {
			if(p1e&JOY_UP)		flipMode|=FLIP_Y;
			if(p1e&JOY_DOWN)	flipMode&=~FLIP_Y;
			if(p1e&JOY_RIGHT)	flipMode|=FLIP_X;
			if(p1e&JOY_LEFT)	flipMode&=~FLIP_X;
		} else {
			if(p1&JOY_UP)		y--;
			if(p1&JOY_DOWN)		y++;
			if(p1&JOY_LEFT)		x--;
			if(p1&JOY_RIGHT)	x++;
		}
		if(p1e&JOY_B)	raster^=1;
		
		pictureSetFlip(&testPict,flipMode);
		pictureSetPos(&testPict, x, y);

		if(raster) {
			TInextTable=(TInextTable==rasterData0)?rasterData1:rasterData0;
			dataPtr=TInextTable;
			rasterAddr=VRAM_POSX_ADDR(testPict.baseSprite);

			if(p1&JOY_C) for(i=0;i<50000;i++);	//induce frameskipping

			TIbase=TI_ZERO+(y>0?384*y:0); //timing to first line

			displayedRasters=(testPict.info->tileHeight<<4)-(y>=0?0:0-y);
			if(displayedRasters+y>224) displayedRasters=224-y;
			if(displayedRasters<0) displayedRasters=0;

			i=(y>=0)?0:0-y;
			for(j=0;j<displayedRasters;j++) {
				*dataPtr++=rasterAddr;
				if(!(j&0x1))
					*dataPtr++=VRAM_POSX(x+(sinTable[(i+tableShift)&0x3f]-32));
				else	*dataPtr++=VRAM_POSX(x-(sinTable[(i+1+tableShift)&0x3f]-32));
				i++;
			}
			SC234Put(rasterAddr,VRAM_POSX(x)); //restore pos
			*dataPtr++=0x0000;
			*dataPtr++=0x0000;	//end
		} else {
			SC234Put(rasterAddr,VRAM_POSX(x)); //restore position
			TInextTable=0;
		}

		tableShift++;
		jobMeterColor(JOB_GREEN);
	}
}

#define SCROLLSPEED 1.06
void rasterScrollDemo() {
	BYTE p1,ps;
	pictureInfo frontLayerInfo, backLayerInfo;
	picture frontLayer, backLayer;
	short posY=-192;
	ushort rasterData0[256],rasterData1[256];
	ushort *rasterData;
	float scrollAcc;
	int scrollPos[34];
	int scrollValues[34];
	ushort backAddr=0x8401;
	ushort frontAddr=0x8421;
	int x,y;
	short frontPosX[13],backPosX[13];
	ushort skipY;
	ushort firstLine;
	ushort zeroval;

	//layers were merged to save up tiles/palettes
	frontLayerInfo.stripSize=tf4layers.stripSize;
	backLayerInfo.stripSize=tf4layers.stripSize;
	frontLayerInfo.tileWidth=32;
	backLayerInfo.tileWidth=32;
	frontLayerInfo.tileHeight=tf4layers.tileHeight;
	backLayerInfo.tileHeight=tf4layers.tileHeight;
	//only using first map
	frontLayerInfo.maps[0]=tf4layers.maps[0];
	backLayerInfo.maps[0]=tf4layers.maps[0]+(tf4layers.stripSize*(32/2)); //bytesize but ushort* declaration, so /2


	clearFixLayer();
	initGfx();
	jobMeterSetup(true);
	loadTIirq(TI_MODE_DUAL_DATA);
	TInextTable=0;

	scrollValues[0]=1024;
	scrollPos[0]=0;
	scrollAcc=1024;
	for(x=1;x<34;x++) {
		scrollAcc*=SCROLLSPEED;
		scrollValues[x]=(int)(scrollAcc+0.5);
		scrollPos[x]=0;
	}

	pictureInit(&backLayer, &backLayerInfo,1,16,0,0,FLIP_NONE);
	pictureInit(&frontLayer, &frontLayerInfo,33,16,0,0,FLIP_NONE);
	palJobPut(16,tf4layers.palInfo->count,tf4layers.palInfo->data);

	backgroundColor(0x38db);
	fixPrint(0,1,0,0,"                                       ");
	fixPrint(0,30,0,0,"                                       ");
	
	fixPrint(2,3,4,3,"1P \x12\x13: Scroll Up/Down");
	fixPrint(2,4,4,3,"1P A+\x12\x13: Adjust timer (line)");
	fixPrint(2,5,4,3,"1P A+\x10\x11: Adjust timer (unit)");
	
	zeroval=TI_ZERO;

	while(1) {
		SCClose();
		waitVBlank();

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //line 16
		jobMeterColor(JOB_BLUE);
		
		p1=volMEMBYTE(P1_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);
		ps=volMEMBYTE(PS_CURRENT);

		if(ps&P1_START) {
			clearSprites(1, 64);
			TInextTable=0;
			SCClose();
			waitVBlank();
			unloadTIirq();
			return;
		}

		fixPrintf2(2,7,5,3,"TIbase: %d (0x%04x)   ",zeroval,zeroval);
		
		if(p1&JOY_A) {
			if(p1e&JOY_UP)		zeroval-=384;
			if(p1e&JOY_DOWN)	zeroval+=384;
			if(p1&JOY_RIGHT)	zeroval++;
			if(p1&JOY_LEFT)		zeroval--;
		} else {
			if(p1&JOY_UP) if(posY<0) posY++;
			if(p1&JOY_DOWN) if(posY>-288) posY--;
		}

		//update scroll values
		for(x=0;x<34;x++) scrollPos[x]+=scrollValues[x];
		frontPosX[0]=								(short)(0-(scrollPos[32]>>3));
		frontPosX[1]=frontPosX[2]=					(short)(0-(scrollPos[24]>>3));
		frontPosX[3]=frontPosX[4]=					(short)(0-(scrollPos[16]>>3));
		frontPosX[5]=								(short)(0-(scrollPos[8]>>3));
		frontPosX[6]=frontPosX[7]=frontPosX[8]=		(short)(0-(scrollPos[0]>>3));
		frontPosX[9]=frontPosX[10]=frontPosX[11]=	(short)(0-(scrollPos[1]>>3));
		frontPosX[12]=								(short)(0-(scrollPos[32]>>3));

		backPosX[0]=								(short)(0-(scrollPos[24]>>3));
		backPosX[1]=backPosX[2]=					(short)(0-(scrollPos[16]>>3));
		backPosX[3]=backPosX[4]=					(short)(0-(scrollPos[8]>>3));
		backPosX[5]=								(short)(0-(scrollPos[0]>>3));
		backPosX[6]=backPosX[7]=backPosX[8]=		(short)(0-(scrollPos[0]>>4));
		backPosX[9]=backPosX[10]=backPosX[11]=		(short)(0-(scrollPos[0]>>3));
		backPosX[12]=								(short)(0-(scrollPos[1]>>3));

		skipY=0-posY;
		x=skipY>>5;
		firstLine=32-(skipY&0x1f);

		//TIbase=TI_ZERO+(384*firstLine); //timing to first raster line
		TIbase=zeroval+(384*firstLine); //timing to first raster line
		TInextTable=(TInextTable==rasterData0)?rasterData1:rasterData0;
		rasterData=TInextTable;

		pictureSetPos(&frontLayer,frontPosX[x]>>7,posY);
		pictureSetPos(&backLayer,backPosX[x]>>7,posY);
		//might need to force the update if base scroll position didn't change
		SC234Put(frontAddr,frontPosX[x]);
		SC234Put(backAddr,backPosX[x]);

		if(skipY<164) { //can we see water?
			TIreload=384*32;	//nope, 32px chunks
			for(x++;x<13;x++) {
				*rasterData++=frontAddr;
				*rasterData++=frontPosX[x];
				*rasterData++=backAddr;
				*rasterData++=backPosX[x];
				firstLine+=32;
				if(firstLine>=224) break;
			}
		} else {
			TIreload=384*4;		//yup, 4px chunks
			for(x++;x<12;x++) {
				for(y=0;y<8;y++) {
					*rasterData++=frontAddr;
					*rasterData++=frontPosX[x];
					*rasterData++=backAddr;
					*rasterData++=backPosX[x];
				}
				firstLine+=32;
			}
			x=1;
			while(firstLine<224) {
				*rasterData++=frontAddr;
				*rasterData++=frontPosX[12];
				*rasterData++=backAddr;
				*rasterData++=0-(scrollPos[x++]>>3);
				firstLine+=4;
			}
		}
		*rasterData++=0x0000;
		*rasterData++=0x0000;
		jobMeterColor(JOB_GREEN);
		SCClose();
	}
}

#define DESERT_POSY	68
static const short heatTable[16]={0,0,0,1,1,1,1,1,0,0,0,-1,-1,-1,-1,-1};

void desertRaster(void) {
	uint fc, ticks=0;
	ushort *dataPtr;
	ushort heatStartIndex=0;
	ushort heatIndex=0;
	ushort rasterAddr,i;
	picture desertHandler;
	ushort rasterData0[64];
	ushort rasterData1[64];
	
	clearFixLayer();
	backgroundColor(0x6bef);
	
	pictureInit(&desertHandler, &desert,1, 16, 8, DESERT_POSY,FLIP_NONE);
	palJobPut(16,desert.palInfo->count,desert.palInfo->data);
	
	LSPCmode=0x0000;
	TIbase=TI_ZERO+DESERT_POSY*384; //timing to first line
	TIreload=384*4; //4 lines intervals
	rasterAddr=VRAM_POSY_ADDR(desertHandler.baseSprite);

	loadTIirq(TI_MODE_SINGLE_DATA);
	
	while(1) {
		fc=DAT_frameCounter;
		SCClose();
		waitVBlank();
		
		ps=volMEMBYTE(PS_EDGE);
		
		if(ps&P1_START) {
			clearSprites(1,desert.tileWidth);
			TInextTable=0;
			SCClose();
			waitVBlank();
			unloadTIirq();
			return;
		}

		ticks=(fc^DAT_frameCounter)&DAT_frameCounter;
		if(ticks&0x04) {
			heatIndex=heatStartIndex++;
			heatStartIndex&=0xf;

			TInextTable=(TInextTable==rasterData0)?rasterData1:rasterData0;
			dataPtr=TInextTable;

			for(i=0;i<20;i++) { //80px pic/4px intervals = 20 iterations
				*dataPtr++=rasterAddr;
				*dataPtr++=VRAM_POSY(DESERT_POSY+heatTable[heatIndex++],SPR_UNLINK,desertHandler.info->tileHeight);
				heatIndex&=0xf;
			}
			//end marker
			*dataPtr++=0;
			*dataPtr++=0;
		}
	}
}

void tempTests() {
	int x=0;
	int y=0;
	int c;
	uint *ptr;
	scroller scroll;

	backgroundColor(0x7bbb);
	clearFixLayer();
	initGfx();
	jobMeterSetup(true);

	scrollerInit(&scroll, &wohd, 1, 16, x, y);
	palJobPut(16, wohd.palInfo->count, wohd.palInfo->data);
	
	//fixPrintf1(2,3,4,3,"0x%06x",&scroll);
	//dbg init
	scroll.config[23+4]=scroll.config[23+5]=scroll.config[23+6]=scroll.config[23+7]=scroll.config[23+8]=0;

	while(1) {
		SCClose();
		waitVBlank();

		p1=volMEMBYTE(P1_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);
		ps=volMEMBYTE(PS_CURRENT);
		
		if((ps&P1_START)&&(ps&P2_START)) {
			clearSprites(1, 21);
			SCClose();
			waitVBlank();
			return;
		}

		if(p1&JOY_UP)		y--;
		if(p1&JOY_DOWN)		y++;
		if(p1&JOY_LEFT)		x--;
		if(p1&JOY_RIGHT)	x++;

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_BLUE);

		if(p1e&JOY_D)
			scrollerInit(&scroll, &wohd, 1, 16, x, y);

		if(p1&JOY_A) scrollerSetPos(&scroll, x, y);

		jobMeterColor(JOB_GREEN);
		fixPrintf2(2,4,4,3,"%04d\xff%04d\xff\xff",x,y);

		fixPrintf2(2,6,2,3,"TileIndex:  %04d ",scroll.config[23+2]);
		fixPrintf2(2,7,2,3,"DataIndex:  %04d ",scroll.config[23+1]);
		fixPrintf2(2,8,2,3,"DataLength: %04d ",scroll.config[23+3]);
		fixPrintf2(2,9,2,3,"DataIndex2: %04d ",scroll.config[23+0]);

		fixPrintf2(2,11,2,3,"TileIndex:  %04d ",scroll.config[23+4]);
		fixPrintf2(2,12,2,3,"DataIndex:  %04d ",scroll.config[23+5]);
		fixPrintf2(2,13,2,3,"DataLength: %04d ",scroll.config[23+6]);
		fixPrintf2(2,14,2,3,"DataIndex2: %04d ",scroll.config[23+7]);
		fixPrintf2(2,15,2,3,"DataLength2:%04d ",scroll.config[23+8]);
		fixPrintf2(2,16,2,3,"RefillSize: %04d ",scroll.config[23+6]+scroll.config[23+8]);

		c=0;
		ptr=SC1;
		while(ptr!=SC1ptr) {
			c+=(*ptr++)&0x3fc0000;
			ptr++;
		}
		c>>=18;
		fixPrintf1(2,18,2,3,"Jobs: %04d/%04d",(SC234ptr-SC234)>>1,c);
	}
}

//misc fix maps
static const ushort fadeData0[15]={0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x03f0,0x0000};
static const ushort fadeData1[15]={0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x03f1,0x0000};
static const ushort fadeData2[15]={0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x03f2,0x0000};
static const ushort fadeData3[15]={0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x03f3,0x0000};
static const ushort fadeData4[15]={0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x03f4,0x0000};
static const ushort fadeData5[15]={0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x03f5,0x0000};
static const ushort fadeData6[15]={0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x03f6,0x0000};
static const ushort fadeData7[15]={0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x03f7,0x0000};
static const ushort fadeData8[15]={0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x03f8,0x0000};
static const ushort fadeData9[15]={0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x03f9,0x0000};
static const ushort fadeDataA[15]={0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x03fa,0x0000};
static const uint fadeData[11]={(uint)fadeData0,(uint)fadeData1,(uint)fadeData2,(uint)fadeData3,(uint)fadeData4,(uint)fadeData5,(uint)fadeData6,(uint)fadeData7,(uint)fadeData8,(uint)fadeData9,(uint)fadeDataA};
static const ushort	logo_95[78]={	0x0500,0x0501,0x0502,0x0503,0x0504,0x0505,0x0506,0x0507,0x0508,0x0509,0x050a,0x050b,0x0000,
									0x0510,0x0511,0x0512,0x0513,0x0514,0x0515,0x0516,0x0517,0x0518,0x0519,0x051a,0x051b,0x0000,
									0x0520,0x0521,0x0522,0x0523,0x0524,0x0525,0x0526,0x0527,0x0528,0x0529,0x052a,0x052b,0x0000,
									0x0530,0x0531,0x0532,0x0533,0x0534,0x0535,0x0536,0x0537,0x0538,0x0539,0x053a,0x053b,0x0000,
									0x0540,0x0541,0x0542,0x0543,0x0544,0x0545,0x0546,0x0547,0x0548,0x0549,0x054a,0x054b,0x0000,
									0x0550,0x0551,0x0552,0x0553,0x0554,0x0555,0x0556,0x0557,0x0558,0x0559,0x055a,0x055b,0x0000 };
static const ushort	logo_96[78]={	0x0560,0x0561,0x0562,0x0563,0x0564,0x0565,0x0566,0x0567,0x0568,0x0569,0x056a,0x056b,0x0000,
									0x0570,0x0571,0x0572,0x0573,0x0574,0x0575,0x0576,0x0577,0x0578,0x0579,0x057a,0x057b,0x0000,
									0x0580,0x0581,0x0582,0x0583,0x0584,0x0585,0x0586,0x0587,0x0588,0x0589,0x058a,0x058b,0x0000,
									0x0590,0x0591,0x0592,0x0593,0x0594,0x0595,0x0596,0x0597,0x0598,0x0599,0x059a,0x059b,0x0000,
									0x05a0,0x05a1,0x05a2,0x05a3,0x05a4,0x05a5,0x05a6,0x05a7,0x05a8,0x05a9,0x05aa,0x05ab,0x0000,
									0x05b0,0x05b1,0x05b2,0x05b3,0x05b4,0x05b5,0x05b6,0x05b7,0x05b8,0x05b9,0x05ba,0x05bb,0x0000 };
static const ushort	logo_97[78]={	0x0600,0x0601,0x0602,0x0603,0x0604,0x0605,0x0606,0x0607,0x0608,0x0609,0x060a,0x060b,0x0000,
									0x0610,0x0611,0x0612,0x0613,0x0614,0x0615,0x0616,0x0617,0x0618,0x0619,0x061a,0x061b,0x0000,
									0x0620,0x0621,0x0622,0x0623,0x0624,0x0625,0x0626,0x0627,0x0628,0x0629,0x062a,0x062b,0x0000,
									0x0630,0x0631,0x0632,0x0633,0x0634,0x0635,0x0636,0x0637,0x0638,0x0639,0x063a,0x063b,0x0000,
									0x0640,0x0641,0x0642,0x0643,0x0644,0x0645,0x0646,0x0647,0x0648,0x0649,0x064a,0x064b,0x0000,
									0x0650,0x0651,0x0652,0x0653,0x0654,0x0655,0x0656,0x0657,0x0658,0x0659,0x065a,0x065b,0x0000 };
static const ushort	logo_98[78]={	0x0660,0x0661,0x0662,0x0663,0x0664,0x0665,0x0666,0x0667,0x0668,0x0669,0x066a,0x066b,0x0000,
									0x0670,0x0671,0x0672,0x0673,0x0674,0x0675,0x0676,0x0677,0x0678,0x0679,0x067a,0x067b,0x0000,
									0x0680,0x0681,0x0682,0x0683,0x0684,0x0685,0x0686,0x0687,0x0688,0x0689,0x068a,0x068b,0x0000,
									0x0690,0x0691,0x0692,0x0693,0x0694,0x0695,0x0696,0x0697,0x0698,0x0699,0x069a,0x069b,0x0000,
									0x06a0,0x06a1,0x06a2,0x06a3,0x06a4,0x06a5,0x06a6,0x06a7,0x06a8,0x06a9,0x06aa,0x06ab,0x0000,
									0x06b0,0x06b1,0x06b2,0x06b3,0x06b4,0x06b5,0x06b6,0x06b7,0x06b8,0x06b9,0x06ba,0x06bb,0x0000 };
									
#define	MAX_HEALTH	192
#define	MAX_POWER	64
/*		/!\ Junk code to demo fix display. /!\				*
 * Made by highly trained monkeys, don't try this at home.	*
 * No, really, it's bad. Don't build strings like this.		*/
void fixDemo() {
	ushort	a,b,c,d;
	short	i;
	
	uint	fc, ticks=0;
	ushort	power=0, logo=4;
	short	time=99, health=MAX_HEALTH, fadeIndex=-1,fadeType=1;
	ushort	powerString[16];
	uchar	healthTmp[20];
	ushort	healthTopString[20], healthBotString[20], counterString[20];

	uchar	fadeDensity[40];
	
	clearFixLayer();
	jobMeterSetup(true);

	palJobPut(14,1,&fix_bars_Palettes.data);
	for(i=0;i<40;i++) fadeDensity[i]=0;

	while(1) {
		fc=DAT_frameCounter;
		SCClose();
		waitVBlank();

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_BLUE);
		
		ps=volMEMBYTE(PS_EDGE);
		if(ps&P1_START) {
			SCClose();
			waitVBlank();
			return;
		}

		ticks=(fc^DAT_frameCounter)&DAT_frameCounter;
		if(ticks&0x2) if(--health<0) health=MAX_HEALTH;
		if(ticks&0x4) if(++power>MAX_POWER) power=0;
		if(ticks&0x20) if(--time<0)time=99;

		fixPrintf3(2,8,(DAT_frameCounter>>5)&0x7,3,counterString,"Frame #0x%08x",DAT_frameCounter);

		//print power bar
		fixPrintf3(2,14,14,3,powerString,"\xe9%c%c%c%c%c%c%c%c\xea",
			0xe0+(power>7?8:power),						0xe0+(power>7+8?8:power<0+8?0:power-8),
			0xe0+(power>7+16?8:power<0+16?0:power-16),	0xe0+(power>7+24?8:power<0+24?0:power-24),
			0xe0+(power>7+32?8:power<0+32?0:power-32),	0xe0+(power>7+40?8:power<0+40?0:power-40),
			0xe0+(power>7+48?8:power<0+48?0:power-48),	0xe0+(power>7+56?8:power<0+56?0:power-56)
		);

		//print health bar & timer
		a=time%10;
		b=time/10;
		c=health>=96?health-96:health;
		d=health>=96?0xd0:0xc0;
		sprintf(healthTmp,"\xc9%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",
			d+(c>7?8:c),				d+(c>7+8?8:c<0+8?0:c-8),	d+(c>7+16?8:c<0+16?0:c-16),
			d+(c>7+24?8:c<0+24?0:c-24),	d+(c>7+32?8:c<0+32?0:c-32),	d+(c>7+40?8:c<0+40?0:c-40),
			d+(c>7+48?8:c<0+48?0:c-48),	d+(c>7+56?8:c<0+56?0:c-56),	d+(c>7+64?8:c<0+64?0:c-64),
			d+(c>7+72?8:c<0+72?0:c-72),	d+(c>7+80?8:c<0+80?0:c-80),	d+(c>7+88?8:c<0+88?0:c-88),
			//timer
			0xa0+b, 0xb0+b, 0xa0+a, 0xb0+a
		);
		fixPrintf3(2,4,14,3,healthTopString,"%s",healthTmp);
		fixPrintf3(2,5,14,4,healthBotString,"%s",healthTmp);	//could also copy data from topString and +1 bank #

		//do fade in / fade out
		if(DAT_frameCounter&0x1) {
			if(fadeIndex<39+27) fadeIndex++;
			i=fadeIndex;
			c=0;
			if(fadeType) {
				a=1;
				do {
					if(i>=39) goto _skip;
					if(fadeDensity[i]!=a) {
						fadeDensity[i]=a;
						fixJobPut(i,16,FIX_COLUMN_WRITE,14,fadeData[a]);
						d++;
					}
					if(a==10) break;
					_skip:
					if(++c>=3) {a=a<10?a+1:a;c=0;}
				} while(--i>=0);
				if(i==38) {fadeType^=1;fadeIndex=-1;}
			} else {
				a=9;
				do {
					if(i>=39) goto _skip2;
					if(fadeDensity[i]!=a) {
						fadeDensity[i]=a;
						fixJobPut(i,16,FIX_COLUMN_WRITE,14,fadeData[a]);
						d++;
					}
					if(a==0) break;
					_skip2:
					if(++c>=3) {a=a>0?a-1:a;c=0;}
				} while(--i>=0);
				if(i==38) {fadeType^=1;fadeIndex=-1;}
			}
		}
		
		//display logo
		a=(DAT_frameCounter>>6)&0x3;
		if(a!=logo) {
			ushort *data;
			logo=a;
			
			switch(logo) {
				case 0:
					data=(ushort*)&logo_95;
					palJobPut(13,1,&logo95_Palettes.data);
				break;
				case 1:
					data=(ushort*)&logo_96;
					palJobPut(13,1,&logo96_Palettes.data);
				break;
				case 2:
					data=(ushort*)&logo_97;
					palJobPut(13,1,&logo97_Palettes.data);
				break;
				default:
					data=(ushort*)&logo_98;
					palJobPut(13,1,&logo98_Palettes.data);
				break;
			}
			fixJobPut(23,6,FIX_LINE_WRITE,13,data);
			fixJobPut(23,7,FIX_LINE_WRITE,13,data+13);
			fixJobPut(23,8,FIX_LINE_WRITE,13,data+26);
			fixJobPut(23,9,FIX_LINE_WRITE,13,data+39);
			fixJobPut(23,10,FIX_LINE_WRITE,13,data+52);
			fixJobPut(23,11,FIX_LINE_WRITE,13,data+65);
		}
		jobMeterColor(JOB_GREEN);
	}
}

void colorStreamDemoA() {
	scroller sc;
	colorStream stream;
	short posX=0;
	short posY=0;
	uint *plj;
	ushort lastJobs=0,jobs=0;
	
	clearFixLayer();
	scrollerInit(&sc,&streamScroll,1,16,0,0);
	colorStreamInit(&stream,&streamScroll_colorStream,16,COLORSTREAM_STARTCONFIG);
	
	fixPrint(2,3,4,3,"1P \x10\x11: scroll");

	while(1) {
		SCClose();
		
		//check palJobs load
		if(jobs!=0)	lastJobs=jobs;
		jobs=0;
		plj=PALJOBS;
		while(*plj!=0xffffffff) {
			jobs+=((*plj++)>>16)+1;
			plj++;
		}
		//fixPrintf1(0,2,3,3,"Jobs:%d (last:%d)   ",jobs,lastJobs);

		waitVBlank();

		p1=volMEMBYTE(P1_CURRENT);
		ps=volMEMBYTE(PS_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);
		
		if(ps&P1_START) {
			clearSprites(1,21);
			SCClose();
			waitVBlank();
			return;
		}
		
		if(p1&JOY_B) {
			if(p1e&JOY_LEFT)	posX-=64;
			if(p1e&JOY_RIGHT)	posX+=64;
		} else {
			if(p1&JOY_LEFT)		posX-=p1&JOY_A?8:1;
			if(p1&JOY_RIGHT)	posX+=p1&JOY_A?8:1;
		}
		if(posX<0) posX=0;
		if(posX>(streamScroll.mapWidth-20)<<4) posX=(streamScroll.mapWidth-20)<<4;
		
		//fixPrintf1(0,1,3,3,"%d    ",posX);
		
		scrollerSetPos(&sc,posX,posY);
		colorStreamSetPos(&stream,posX);
	}
}

void colorStreamDemoB() {
	scroller sc;
	colorStream stream;
	short posX=0;
	short posY=0;
	uint *plj;
	ushort lastJobs=0,jobs=0;

	
	clearFixLayer();
	scrollerInit(&sc,&SNKLogoStrip,1,16,0,0);
	colorStreamInit(&stream,&SNKLogoStrip_colorStream,16,COLORSTREAM_STARTCONFIG);

	fixPrint(2,3,4,3,"1P \x12\x13: scroll");
	fixPrint(2,29,6,3,"(Sequence formatted by MegaShocked)");
	
	while(1) {
		SCClose();
		
		//check palJobs load
		if(jobs!=0)	lastJobs=jobs;
		jobs=0;
		plj=PALJOBS;
		while(*plj!=0xffffffff) {
			jobs+=((*plj++)>>16)+1;
			plj++;
		}
		//fixPrintf1(0,2,3,3,"Jobs:%d (last:%d)   ",jobs,lastJobs);

		waitVBlank();

		p1=volMEMBYTE(P1_CURRENT);
		ps=volMEMBYTE(PS_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);
		
		if(ps&P1_START) {
			clearSprites(1,21);
			SCClose();
			waitVBlank();
			return;
		}
		
		if(p1&JOY_B) {
			if(p1e&JOY_UP)	posY-=224;
			if(p1e&JOY_DOWN)posY+=224;
		} else {
			if(p1&JOY_UP)	posY-=p1&JOY_A?224:1;
			if(p1&JOY_DOWN) posY+=p1&JOY_A?224:1;
		}
		if(posY<0) posY=0;
		if(posY>(SNKLogoStrip.mapHeight-14)<<4) posY=(SNKLogoStrip.mapHeight-14)<<4;
		
		//fixPrintf1(0,1,3,3,"%d    ",posY);
		
		scrollerSetPos(&sc,posX,posY);
		colorStreamSetPos(&stream,posY);
	}
}

void testCallBack() {
	if(volMEMBYTE(P1_EDGE)&JOY_A) 
		callBackCounter++;
}

#define	CURSOR_MAX	7
static const uint demos[]={(uint)pictureDemo,(uint)scrollerDemo,(uint)aSpriteDemo,(uint)fixDemo,(uint)rasterScrollDemo,(uint)desertRaster,(uint)colorStreamDemoA,(uint)colorStreamDemoB};

int main(void) {
	ushort cursor=0;
	void (*demo)();
	
	clearFixLayer();
	initGfx();

	palJobPut(0,8,fixPalettes);

	//if(setup4P())
	//	fixPrint(2,4,7,3,"4P! :)");
	//else fixPrint(2,4,7,3,"no 4P :(");

	backgroundColor(0x7bbb);
	
	//using VBL callbacks to count global A button presses
	callBackCounter=0;
	VBL_callBack=testCallBack;
	VBL_skipCallBack=testCallBack;
	
	fixPrintf1(0,2,1,3,"RAM usage: 0x%04x (%d)",((uint)&_end)-0x100000,((uint)&_end)-0x100000);
	
	while(1) {
		SCClose();
		waitVBlank();

		p1=volMEMBYTE(P1_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);

		if(p1e&JOY_UP)		cursor=cursor>0?cursor-1:CURSOR_MAX;
		if(p1e&JOY_DOWN)	cursor=cursor<CURSOR_MAX?cursor+1:0;
		if(p1e&JOY_A) {
			demo=(void*)demos[cursor];
			demo();
			clearFixLayer();
			volMEMWORD(0x401ffe)=0x7bbb; //restore BG color
		}
		
		//if(p1&JOY_B) {
		//	tempTests();
		//	clearFixLayer();
		//}

		fixPrintf1(0,3,1,3,"CB counter:%d",callBackCounter);
		fixPrint(8,10,cursor==0?2:4,3,"Picture demo");
		fixPrint(8,11,cursor==1?2:4,3,"Scroller demo");
		fixPrint(8,12,cursor==2?2:4,3,"Animated sprite demo");
		fixPrint(8,13,cursor==3?2:4,3,"Fix layer demo");
		fixPrint(8,14,cursor==4?2:4,3,"Raster demo A");
		fixPrint(8,15,cursor==5?2:4,3,"Raster demo B");
		fixPrint(8,16,cursor==6?2:4,3,"Color stream demo A");
		fixPrint(8,17,cursor==7?2:4,3,"Color stream demo B");

		fixPrint(8,20,4,3,"(P1 START - Menu return)");
		fixPrint(8,28,5,3,"DATlib tests - @2018 Hpman");
	}
}
