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


BYTE p1,p2,ps,p1e,p2e;

void scrollerDemo() {
	int x=FRONT_START_X;
	int y=FRONT_START_Y;
	int carx=320;
	int cary=106;
	int backX;
	int backY;

	scroller backScroll, frontScroll;
	picture car;

	backgroundColor(0x7bbb); //BG color
	LSPCmode=0x1c00;	//autoanim speed
	clearFixLayer();
	initGfx();
	jobMeterSetup(true);

	scrollerInit(&backScroll, &ffbg_a, 1, 16, (((x-8)*141)/299)+BACK_MIN_X, (((y-16)*3)/8)+BACK_MIN_Y);
	palJobPut(16, ffbg_a_Palettes.palCount, ffbg_a_Palettes.data);

	scrollerInit(&frontScroll, &ffbg_b, 22, 16 + ffbg_a_Palettes.palCount, x, y);
	palJobPut(16 + ffbg_a_Palettes.palCount, ffbg_b_Palettes.palCount, ffbg_b_Palettes.data);

	pictureInit(&car, &ffbg_c, 43, 16 + ffbg_a_Palettes.palCount + ffbg_b_Palettes.palCount, carx, cary, FLIP_NONE);
	palJobPut(16 + ffbg_a_Palettes.palCount + ffbg_b_Palettes.palCount, ffbg_c_Palettes.palCount, ffbg_c_Palettes.data);

	fixPrint(2,3,0,0,"1P \x12\x13\x10\x11: scroll");

	SCClose();
	while(1) {
		waitVBlank();

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_PURPLE);

		p1=volMEMBYTE(P1_CURRENT);
		p2=volMEMBYTE(P2_CURRENT);
		ps=volMEMBYTE(PS_CURRENT);
		
		if((ps&P1_START)&&(ps&P2_START)) {
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
	#ifdef POOL_MODE
	spritePool testPool;
	uint *drawTable[16];
	uint *drawTablePtr;
	int sortSize;
		#ifdef LOTS
		aSprite demoSpr4,demoSpr5,demoSpr6,demoSpr7,demoSpr8,demoSpr9,demoSprA;
		#endif
	#endif
	picture ptr,tleft,bright;
	short way1=JOY_UP,way2=JOY_UP;
	short visible=true;


	clearFixLayer();
	backgroundColor(0x7bbb); //BG color
	initGfx();
	jobMeterSetup(true);

	aSpriteInit(&demoSpr,&bmary_spr,1,16,x,y,0,FLIP_NONE);
	aSpriteInit(&demoSpr2,&bmary_spr,5,16,160-16,y,0,FLIP_NONE);
	aSpriteInit(&demoSpr3,&bmary_spr,9,16,160+16,y,0,FLIP_NONE);
	#ifdef POOL_MODE
	#ifdef LOTS
	aSpriteInit(&demoSpr4,&bmary_spr,9,16,160+32,146,0,FLIP_NONE);
	aSpriteInit(&demoSpr5,&bmary_spr,9,16,160-32,156,0,FLIP_NONE);
	aSpriteInit(&demoSpr6,&bmary_spr,9,16,160+48,166,0,FLIP_NONE);
	aSpriteInit(&demoSpr7,&bmary_spr,9,16,160-48,176,0,FLIP_NONE);
	aSpriteInit(&demoSpr8,&bmary_spr,9,16,160+10,186,0,FLIP_NONE);
	aSpriteInit(&demoSpr9,&bmary_spr,9,16,160-10,196,0,FLIP_NONE);
	aSpriteInit(&demoSprA,&bmary_spr,9,16,87,206,0,FLIP_NONE);
	#endif
	#endif

	palJobPut(16,bmary_spr_Palettes.palCount,&bmary_spr_Palettes.data);

	pictureInit(&ptr,&pointer,200,200,0,224,FLIP_NONE);
	palJobPut(200,pointer_Palettes.palCount,&pointer_Palettes.data);

	pictureInit(&tleft,&topleft,201,201,0,224,FLIP_NONE);
	pictureInit(&bright,&topleft,202,201,0,224,FLIP_XY);
	palJobPut(201,topleft_Palettes.palCount,&topleft_Palettes.data);

	fixPrint(2,3,0,0,"1P \x12\x13\x10\x11: move sprite");
	fixPrint(2,4,0,0,"1P AB: set animation");
	fixPrint(2,5,0,0,"1P C: toggle outline");
	fixPrint(2,6,0,0,"2P ABCD: flip mode");

	#ifdef POOL_MODE
	spritePoolInit(&testPool,10,80);	//54 100
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

	sortSprites((aSprite*)&drawTable[1],sortSize);
	spritePoolDrawList(&testPool,&drawTable[1]);
	spritePoolClose(&testPool);
	#else
	aSpriteAnimate(&demoSpr);
	aSpriteAnimate(&demoSpr2);
	aSpriteAnimate(&demoSpr3);
	#endif

	SCClose();
	while(1) {
		waitVBlank();

		p1=volMEMBYTE(P1_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);
		p2=volMEMBYTE(P2_EDGE);
		ps=volMEMBYTE(PS_CURRENT);

		if((ps&P1_START)&&(ps&P2_START)) {
			clearSprites(1, 150);
			clearSprites(200, 3);
			SCClose();
			waitVBlank();
			return;
		}

		if(p1&JOY_UP)	y--;
		if(p1&JOY_DOWN)	y++;
		if(p1&JOY_LEFT)	x--;
		if(p1&JOY_RIGHT)	x++;

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_BLUE);

		if(p1e&JOY_A)	aSpriteSetAnim(&demoSpr,BMARY_SPR_ANIM_IDLE);
		if(p1e&JOY_B)	aSpriteSetAnim(&demoSpr,BMARY_SPR_ANIM_WALK);
		if(p1e&JOY_C) {
			if(showdebug) {
				//move debug stuff offscreen
				pictureSetPos(&ptr,0,224);
				pictureSetPos(&tleft,0,224);
				pictureSetPos(&bright,0,224);
			}
			showdebug^=1;
		}
		if(p2&JOY_A)	aSpriteSetFlip(&demoSpr,FLIP_NONE);
		if(p2&JOY_B)	aSpriteSetFlip(&demoSpr,FLIP_X);
		if(p2&JOY_C)	aSpriteSetFlip(&demoSpr,FLIP_Y);
		if(p2&JOY_D)	aSpriteSetFlip(&demoSpr,FLIP_XY);

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

		if(p1e&JOY_D) {
			if(visible) {
				aSpriteHide(&demoSpr);
				#ifndef POOL_MODE
				clearSprites(demoSpr.baseSprite,demoSpr.tileWidth);
				#endif
			} else {
				aSpriteShow(&demoSpr);
			}
			visible^=1;
		}

		#ifdef POOL_MODE
		//while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		sortSprites(&drawTable[1],sortSize);
		jobMeterColor(JOB_PINK);
		if(testPool.way==WAY_UP)
				spritePoolDrawList(&testPool,&drawTable[1]);
		else	spritePoolDrawList(&testPool,drawTablePtr);
		#else
		aSpriteAnimate(&demoSpr);
		aSpriteAnimate(&demoSpr2);
		aSpriteAnimate(&demoSpr3);
		#endif

		//aSprite debug info
		if(showdebug) {
			jobMeterColor(JOB_BLACK);
			pictureSetPos(&ptr,x,y);
			if(demoSpr.currentFlip&0x0001) relX=x-((demoSpr.currentFrame->tileWidth<<4)+demoSpr.currentStep->shiftX);
				else relX=x+demoSpr.currentStep->shiftX;
			if(demoSpr.currentFlip&0x0002) relY=y-((demoSpr.currentFrame->tileHeight<<4)+demoSpr.currentStep->shiftY);
				else relY=y+demoSpr.currentStep->shiftY;
			pictureSetPos(&tleft,relX,relY);
			pictureSetPos(&bright,relX+((demoSpr.currentFrame->tileWidth-1)<<4),relY+((demoSpr.currentFrame->tileHeight-1)<<4));
		}

		jobMeterColor(JOB_GREEN);
		#ifdef POOL_MODE
		spritePoolClose(&testPool);
		#endif
		jobMeterColor(JOB_GREEN);
		SCClose();
	}
}

const char sinTable[] = {32,34,35,37,38,40,41,43,44,46,47,48,50,51,52,53,
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
	WORD raster=false;
	WORD tableShift=0;
	ushort rasterData0[512];
	ushort rasterData1[512];
	ushort rasterAddr;
	ushort *dataPtr;
	short displayedRasters;

	clearFixLayer();
	backgroundColor(0x7bbb); //BG color
	initGfx();
	jobMeterSetup(true);

	LSPCmode=0x1c00;
	loadTIirq(TI_MODE_SINGLE_DATA);

	pictureInit(&testPict, &terrypict,1, 16, x, y,FLIP_NONE);
	palJobPut(16,terrypict_Palettes.palCount,terrypict_Palettes.data);

	rasterAddr=0x8400+testPict.baseSprite;

	fixPrint(2,3,0,0,"1P \x12\x13\x10\x11: move picture");
	fixPrint(2,4,0,0,"1P ABCD: flip mode");
	fixPrint(2,5,0,0,"2P A: toggle rasters");
	
	SCClose();
	while(1) {
		waitVBlank();

		ps=volMEMBYTE(PS_CURRENT);
		p1=volMEMBYTE(P1_CURRENT);
		p2=volMEMBYTE(P2_CURRENT);
		p1e=volMEMBYTE(P1_EDGE);
		p2e=volMEMBYTE(P2_EDGE);
		
		if((ps&P1_START)&&(ps&P2_START)) {
			clearSprites(1, terrypict.tileWidth);
			TInextTable=0;
			SCClose();
			waitVBlank();
			unloadTIirq();
			return;
		}

		if(p1&JOY_UP)	y--;
		if(p1&JOY_DOWN)	y++;
		if(p1&JOY_LEFT)	x--;
		if(p1&JOY_RIGHT)	x++;
		
		if(p2e&JOY_A)	raster^=1;

		//fixPrintf(2,2,0,0,"%d",DAT_droppedFrames);
		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_BLUE);

		if(p1e&JOY_A)	pictureSetFlip(&testPict,FLIP_NONE);
		if(p1e&JOY_B)	pictureSetFlip(&testPict,FLIP_X);
		if(p1e&JOY_C)	pictureSetFlip(&testPict,FLIP_Y);
		if(p1e&JOY_D)	pictureSetFlip(&testPict,FLIP_XY);

		pictureSetPos(&testPict, x, y);

		if(raster) {
			TInextTable=(TInextTable==rasterData0)?rasterData1:rasterData0;
			dataPtr=TInextTable;
			rasterAddr=0x8400+testPict.baseSprite;

			if(p2&JOY_B) for(i=0;i<50000;i++);	//induce frameskipping

			TIbase=TI_ZERO+(y>0?384*y:0); //timing to first line

			displayedRasters=(testPict.info->tileHeight<<4)-(y>=0?0:0-y);
			if(displayedRasters+y>224) displayedRasters=224-y;
			if(displayedRasters<0) displayedRasters=0;

			i=(y>=0)?0:0-y;
			for(j=0;j<displayedRasters;j++) {
				*dataPtr++=rasterAddr;
				if(!(j&0x1))
					*dataPtr++=(x+(sinTable[(i+tableShift)&0x3f]-32))<<7;
				else	*dataPtr++=(x-(sinTable[(i+1+tableShift)&0x3f]-32))<<7;
				i++;
			}
			SC234Put(rasterAddr,x<<7); //restore pos
			*dataPtr++=0x0000;
			*dataPtr++=0x0000;	//end
		} else {
			SC234Put(rasterAddr,x<<7); //restore position
			TInextTable=0;
		}

		tableShift++;
		jobMeterColor(JOB_GREEN);
		SCClose();
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

	//layers were merged to save up tiles/palettes
	frontLayerInfo.colSize=tf4layers.colSize;
	backLayerInfo.colSize=tf4layers.colSize;
	frontLayerInfo.tileWidth=32;
	backLayerInfo.tileWidth=32;
	frontLayerInfo.tileHeight=tf4layers.tileHeight;
	backLayerInfo.tileHeight=tf4layers.tileHeight;
	//only using first map
	frontLayerInfo.maps[0]=tf4layers.maps[0];
	backLayerInfo.maps[0]=tf4layers.maps[0]+(tf4layers.colSize*32);

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
	palJobPut(16,tf4layers_Palettes.palCount,tf4layers_Palettes.data);

	backgroundColor(0x38db);
	fixPrint(0,1,0,0,"                                       ");
	fixPrint(0,30,0,0,"                                       ");
	SCClose();

	while(1) {
		waitVBlank();

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //line 16
		jobMeterColor(JOB_BLUE);
		
		p1=volMEMBYTE(P1_CURRENT);
		ps=volMEMBYTE(PS_CURRENT);

		if((ps&P1_START)&&(ps&P2_START)) {
			clearSprites(1, 64);
			TInextTable=0;
			SCClose();
			waitVBlank();
			unloadTIirq();
			return;
		}
		if(p1&JOY_UP) if(posY<0) posY++;
		if(p1&JOY_DOWN) if(posY>-288) posY--;

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

		TIbase=TI_ZERO+(384*firstLine); //timing to first raster line
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

void tempTests() {
	int x=0;
	int y=0;

	scroller scroll;

	backgroundColor(0x7bbb); //BG color
	clearFixLayer();
	initGfx();
	jobMeterSetup(true);

	scrollerInit(&scroll, &wohd, 1, 16, x, y);
	palJobPut(16, wohd_Palettes.palCount, wohd_Palettes.data);

	SCClose();
	while(1) {
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
		
		if(p1&JOY_UP)	y--;
		if(p1&JOY_DOWN)	y++;
		if(p1&JOY_LEFT)	x--;
		if(p1&JOY_RIGHT)	x++;

		while((volMEMWORD(0x3c0006)>>7)!=0x120); //wait raster line 16
		jobMeterColor(JOB_BLUE);
		
		if(p1e&JOY_C) scrollerInit(&scroll, &wohd, 1, 16, x, y);
			else	scrollerSetPos(&scroll, x, y);
		
		jobMeterColor(JOB_GREEN);
		fixPrintf(2,4,0,0,"%04d\xff%04d\xff\xff",x,y);
		SCClose();
	}
}


int main(void) {
	//volMEMBYTE(0x10fd80)=0x80;
	while(1) {
		clearFixLayer();

		waitVBlank();
//		if(setup4P())
//			fixPrintf(8,20,0,0,"4P! :)");
//		else fixPrintf(8,20,0,0,"no 4P :(");

		initGfx();
		volMEMWORD(0x400002)=0xffff; //debug text white
		backgroundColor(0x7bbb); //BG color
		
		fixPrintf(8,10,0,0,"A - Picture demo");
		fixPrintf(8,12,0,0,"B - Scroller demo");
		fixPrintf(8,14,0,0,"C - Animated sprite demo");
		fixPrintf(8,16,0,0,"D - Raster scroller demo");
		fixPrintf(8,18,0,0,"P1&P2 START - Return to menu");
		fixPrintf(8,28,0,0,"DATlib tests - {2015 Hpman");

		while(1) {
			p1=volMEMBYTE(P1_EDGE);
			
			if(p1&JOY_A) {
				pictureDemo();
				waitVBlank();
				break;
			}
			if(p1&JOY_B) {
				scrollerDemo();
				break;
			}
			if(p1&JOY_C) {
				aSpriteDemo();
				break;
			}
			if(p1&JOY_D) {
				//tempTests();
				rasterScrollDemo();
				break;
			}
		}
	}
}
