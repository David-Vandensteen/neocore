# DATlib 0.3.0 - Breaking Changes from 0.2

This document lists all breaking changes from DATlib v0.2 to v0.3 that require code modifications.

## 1. Type Definition Changes

### 1.1 bool Type Added

**NEW:** `bool` type definition added in v0.3

```c
// v0.2 (OLD) - No bool type defined
// Used BOOL from system headers

// v0.3 (NEW)
#define bool unsigned short
```

**Impact:** Potential conflicts if code previously defined `bool` differently

### 1.2 Palette Structure Changes

**BREAKING:** `paletteInfo` structure member name changed

```c
// v0.2 (OLD)
typedef struct paletteInfo {
  WORD palCount;
  WORD data[0];
} paletteInfo;

// v0.3 (NEW)
typedef struct paletteInfo {
  ushort count;     // Changed from palCount
  ushort data[0];   // Type changed from WORD to ushort
} paletteInfo;
```

**Migration Required:**
- Replace `paletteInfo->palCount` with `paletteInfo->count`

## 2. Structure Layout Changes

### 2.1 Scroller Structures Complete Redesign

**BREAKING:** `scrollerInfo` structure completely changed

```c
// v0.2 (OLD)
typedef struct scrollerInfo {
  WORD colSize;      // column size (words)
  WORD sprHeight;    // sprite tile height
  WORD mapWidth;     // map tile width
  WORD mapHeight;    // map tile height
  WORD map[0];       // map data
} scrollerInfo;

// v0.3 (NEW)
typedef struct scrollerInfo {
  ushort stripSize;        // column size (bytes) - different unit!
  ushort sprHeight;        // sprite tile height
  ushort mapWidth;         // map tile width
  ushort mapHeight;        // map tile height
  paletteInfo *palInfo;    // NEW: palette information pointer
  colorStreamInfo *csInfo; // NEW: color stream information
  ushort *strips[0];       // NEW: ptr to strips data (replaces map)
} scrollerInfo;
```

**BREAKING:** `scroller` structure layout changed

```c
// v0.2 (OLD)
typedef struct scroller {
  WORD baseSprite;
  WORD basePalette;
  WORD colNumber[21];     // Column configuration array
  WORD topBk, botBk;      // Background top/bottom
  WORD scrlPosX, scrlPosY;
  scrollerInfo *info;
  //58 bytes
} scroller;

// v0.3 (NEW)
typedef struct scroller {
  ushort baseSprite;
  ushort basePalette;
  short scrlPosX, scrlPosY;  // Type changed from WORD to short
  scrollerInfo *info;
  ushort config[32];         // NEW: Replaced colNumber, topBk, botBk
  //76 bytes - size increased!
} scroller;
```

**Migration Required:**
- Remove access to `colNumber`, `topBk`, `botBk` members
- Use new `config` array for scroller configuration
- Update size calculations (58 → 76 bytes)

### 2.2 Picture Structure Changes

**BREAKING:** `pictureInfo` structure layout changed

```c
// v0.2 (OLD)
typedef struct pictureInfo {
  WORD colSize;              // size of each column (words)
  WORD unused__height;       // Unused field
  WORD tileWidth;
  WORD tileHeight;
  WORD *maps[4];             // ptrs to maps
} pictureInfo;

// v0.3 (NEW)
typedef struct pictureInfo {
  ushort stripSize;          // size of each strip (bytes) - different unit!
  ushort tileWidth;
  ushort tileHeight;
  paletteInfo *palInfo;      // NEW: palette information pointer
  ushort *maps[4];           // Type changed from WORD* to ushort*
} pictureInfo;
```

**Migration Required:**
- Replace `colSize` with `stripSize` (note: units changed from words to bytes!)
- Remove `unused__height` references
- Add palette information handling

### 2.3 Animated Sprite Structures Complete Redesign

**BREAKING:** `sprFrame` structure field name changed

```c
// v0.2 (OLD)
typedef struct sprFrame {
  WORD tileWidth;
  WORD tileHeight;
  WORD colSize;        // Column size
  WORD *maps[4];
} sprFrame;

// v0.3 (NEW)
typedef struct sprFrame {
  ushort tileWidth;
  ushort tileHeight;
  ushort stripSize;    // Changed from colSize
  ushort *maps[4];     // Type changed from WORD* to ushort*
} sprFrame;
```

**BREAKING:** `animStep` structure duration type changed

```c
// v0.2 (OLD)
typedef struct animStep {
  sprFrame *frame;
  short shiftX;
  short shiftY;
  short duration;      // Type: short
} animStep;

// v0.3 (NEW)
typedef struct animStep {
  sprFrame *frame;
  short shiftX;
  short shiftY;
  ushort duration;     // Type changed to ushort
} animStep;
```

**BREAKING:** `spriteInfo` structure completely redesigned

```c
// v0.2 (OLD)
typedef struct spriteInfo {
  WORD palCount;
  WORD frameCount;
  WORD maxWidth;
  animation *anims;    // Pointer to animation structures
} spriteInfo;

// v0.3 (NEW)
typedef struct spriteInfo {
  ushort frameCount;
  ushort maxWidth;
  paletteInfo *palInfo;  // NEW: Direct palette pointer
  animStep **anims;      // Changed: Direct pointer to animStep arrays
  sprFrame frames[0];    // NEW: Embedded frames array
} spriteInfo;
```

**BREAKING:** `aSprite` structure completely redesigned

```c
// v0.2 (OLD) - 50 bytes
typedef struct aSprite {
  WORD baseSprite;
  WORD basePalette;
  short posX, posY;
  short currentStepNum;
  short maxStep;
  sprFrame *frames;           // frames bank (unused)
  sprFrame *currentFrame;
  animation *anims;           // anims bank
  animation *currentAnimation;
  animStep *steps;
  animStep *currentStep;
  DWORD counter;
  WORD repeats;
  WORD currentFlip;
  WORD tileWidth;
  WORD animID;
  WORD flags;
} aSprite;

// v0.3 (NEW) - 42 bytes
typedef struct aSprite {
  ushort baseSprite;
  ushort basePalette;
  short posX, posY;
  ushort animID;              // Moved position
  ushort currentAnim;         // NEW: replaces currentAnimation
  ushort stepNum;             // Renamed from currentStepNum
  animStep *anims;            // anims bank
  animStep *steps;            // steps bank of current anim
  animStep *currentStep;      // current step
  sprFrame *currentFrame;     // current frame
  uint counter;               // Type changed from DWORD to uint
  ushort repeats;             // repeats played
  ushort tileWidth;
  ushort currentFlip;
  ushort flags;
  // Removed: maxStep, frames, currentAnimation
} aSprite;
```

**BREAKING:** `animation` structure removed entirely

```c
// v0.2 (OLD) - REMOVED in v0.3
typedef struct animation {
  WORD stepsCount;
  WORD repeats;
  animStep *data;
  struct animation *link;
} animation;
```

**Migration Required:**
- Remove all `animation` structure usage
- Replace `animation*` with direct `animStep**` arrays
- Update `aSprite` member access:
  - `currentStepNum` → `stepNum`
  - `currentAnimation` → use `currentAnim` index
  - Remove `maxStep`, `frames` member access
- Handle size change (50 → 42 bytes)

## 3. Constants and Defines Changes

### 3.1 Job Meter Colors Updated

**BREAKING:** Most job meter color values changed

```c
// v0.2 (OLD)
#define JOB_BLACK       0x0000
#define JOB_LIGHTRED    0x7f66
#define JOB_DARKRED     0xc900
#define JOB_LIGHTGREEN  0x76f6
#define JOB_GARKGREEN   0xa090  // Typo: GARKGREEN
#define JOB_LIGHTBLUE   0x766f
#define JOB_DARKBLUE    0x9009
// ... many more color changes

// v0.3 (NEW)
#define JOB_BLACK       0x8000  // Changed!
#define JOB_LIGHTRED    0xcf88  // Changed!
#define JOB_DARKRED     0x8800  // Changed!
#define JOB_LIGHTGREEN  0xa8f8  // Changed!
#define JOB_DARKGREEN   0x8080  // Fixed typo, changed value
#define JOB_LIGHTBLUE   0x988f  // Changed!
#define JOB_DARKBLUE    0x8008  // Changed!
// ... all colors updated
```

**NEW:** Additional color constants added in v0.3

```c
// v0.3 (NEW) - Additional colors
#define JOB_LIGHTGREY   0x7bbb
#define JOB_GREY        0x8888
#define JOB_DARKGREY    0x8444
```

**Migration Required:**
- Review all hardcoded color usage - values have changed significantly
- Note typo fix: `JOB_GARKGREEN` → `JOB_DARKGREEN`

### 3.2 Animated Sprite Constants

**BREAKING:** Old constants removed, new flag system added

```c
// v0.2 (OLD) - REMOVED
#define ASPRITE_FRAMES_ADDR 8

// v0.3 (NEW) - Complete flag system added
#define AS_FLAGS_DEFAULT        0x0000
#define AS_FLAG_MOVED          0x0001
#define AS_FLAG_FLIPPED        0x0002
#define AS_FLAG_STD_COORDS     0x0000
#define AS_FLAG_STRICT_COORDS  0x0040
#define AS_FLAG_DISPLAY        0x0000
#define AS_FLAG_NODISPLAY      0x0080

#define AS_MASK_MOVED          0xfffe
#define AS_MASK_FLIPPED        0xfffd
#define AS_MASK_MOVED_FLIPPED  0xfffc
#define AS_MASK_STRICT_COORDS  0xffbf
#define AS_MASK_NODISPLAY      0xff7f

#define AS_USE_SPRITEPOOL      0x8000
#define AS_NOSPRITECLEAR       0x8000
```

### 3.3 New Constants Added

**NEW:** Fix display constants

```c
// v0.3 (NEW)
#define FIX_LINE_WRITE    0x20
#define FIX_COLUMN_WRITE  0x01
```

**NEW:** Color stream constants

```c
// v0.3 (NEW)
#define COLORSTREAM_STARTCONFIG  0
#define COLORSTREAM_ENDCONFIG    1
```

**NEW:** VRAM manipulation macros

```c
// v0.3 (NEW) - Complete VRAM macro set
#define SPR_LINK           0x0040
#define SPR_UNLINK         0x0000
#define VRAM_SPR_ADDR(s)   ((s)<<6)
#define VRAM_FIX_ADDR(x,y) (0x7000+(((x)<<5)+(y)))
#define VRAM_SHRINK_ADDR(s) (0x8000|(s))
#define VRAM_SHRINK(h,v)   (((h)<<8)|(v))
#define VRAM_POSY_ADDR(s)  (0x8200|(s))
#define VRAM_POSY(y,l,h)   (((YSHIFT-(y))<<7)|(l)|(h))
#define VRAM_POSX_ADDR(s)  (0x8400|(s))
#define VRAM_POSX(x)       ((x)<<7)
```

## 4. Macro Changes

### 4.1 Animated Sprite Macros

**BREAKING:** Macro implementations changed to use new flag constants

```c
// v0.2 (OLD)
#define aSpriteHide(as)  {(as)->flags|=0x0080;}
#define aSpriteShow(as)  {(as)->flags&=0xff7f;(as)->flags|=0x0002;}

// v0.3 (NEW)
#define aSpriteHide(as)  {(as)->flags|=AS_FLAG_NODISPLAY;}
#define aSpriteShow(as)  {(as)->flags&=AS_MASK_NODISPLAY;(as)->flags|=AS_FLAG_FLIPPED;}
```

**NEW:** Fix job macro added

```c
// v0.3 (NEW)
#define fixJobPut(x,y,mod,pal,addr) {*fixJobsPtr++=(((0x7000+((x)<<5)+(y))<<16)|(((pal)<<12)|(mod)));*fixJobsPtr++=(DWORD)(addr);}
```

## 5. Function Signature Changes

### 5.1 Parameter Type Changes

**BREAKING:** Many functions changed parameter types from `WORD`/`BYTE` to `ushort`

```c
// v0.2 (OLD)
void pictureInit(picture *p, pictureInfo *pi, WORD baseSprite, BYTE basePalette, short posX, short posY, WORD flip);
void scrollerInit(scroller *s, scrollerInfo *si, WORD baseSprite, BYTE basePalette, short posX, short posY);
void aSpriteInit(aSprite *as, spriteInfo *si, WORD baseSprite, BYTE basePalette, short posX, short posY, WORD anim, WORD flip);

// v0.3 (NEW)
void pictureInit(picture *p, const pictureInfo *pi, ushort baseSprite, ushort basePalette, short posX, short posY, ushort flip);
void scrollerInit(scroller *s, const scrollerInfo *si, ushort baseSprite, ushort basePalette, short posX, short posY);
void aSpriteInit(aSprite *as, const spriteInfo *si, ushort baseSprite, ushort basePalette, short posX, short posY, ushort anim, ushort flip, ushort flags);
```

**Migration Required:**
- Update all function calls to use `ushort` instead of `WORD`/`BYTE` for palette parameters
- Note `const` qualifiers added to info structure parameters
- `aSpriteInit` gained additional `flags` parameter

### 5.2 Text/Fix Functions Extended

**NEW:** Many new text functions added in v0.3

```c
// v0.2 had basic functions:
void fixPrint(int x, int y, int pal, int bank, const char *buf);
void fixPrintf(int x, int y, int pal, int bank, const char *fmt, ...);

// v0.3 (NEW) - Extended with const and type changes + new functions:
void fixPrint(ushort x, ushort y, ushort pal, ushort bank, const char *buf);
void fixPrint2(ushort x, ushort y, ushort pal, ushort bank, const char *buf);
void fixPrint3(ushort x, ushort y, ushort pal, const ushort *buf);
void fixPrint4(ushort x, ushort y, ushort pal, const ushort *buf);
void fixPrintf(ushort x, ushort y, ushort pal, ushort bank, const char *fmt, ...);

// Plus new printf variants and macros
ushort sprintf2(char*,char*,...);
ushort sprintf3(ushort,ushort,char*,char*,...);
// + fixPrintf1, fixPrintf2, fixPrintf3 macros
```

### 5.3 New Animated Sprite Functions

**NEW:** Extended animated sprite control functions

```c
// v0.3 (NEW) - Additional animation control
void aSpriteSetAnim2(aSprite *as, ushort anim);
void aSpriteSetStep(aSprite *as, ushort step);
void aSpriteSetStep2(aSprite *as, ushort step);
void aSpriteSetAnimStep(aSprite *as, ushort anim, ushort step);
void aSpriteSetAnimStep2(aSprite *as, ushort anim, ushort step);
```

### 5.4 Sprite Pool Function Changes

**BREAKING:** `spritePoolInit` signature changed

```c
// v0.2 (OLD)
void spritePoolInit(spritePool *sp, WORD baseSprite, WORD size);

// v0.3 (NEW)
void spritePoolInit(spritePool *sp, ushort baseSprite, ushort size, bool clearSprites);
```

**NEW:** Additional sprite pool functions

```c
// v0.3 (NEW)
void spritePoolDrawList2(spritePool *sp, void *list);
```

**BREAKING:** Return type changed

```c
// v0.2 (OLD)
int spritePoolClose(spritePool *sp);

// v0.3 (NEW)
ushort spritePoolClose(spritePool *sp);
```

## 6. Variable Changes

### 6.1 New Variables Added

**NEW:** VBlank callback pointers

```c
// v0.3 (NEW)
extern void *VBL_callBack;       // VBlank callback function pointer
extern void *VBL_skipCallBack;   // VBlank callback function pointer (dropped frame)
```

**NEW:** Fix jobs support

```c
// v0.3 (NEW)
extern uint FIXJOBS[129];
extern uint *fixJobsPtr;
```

**NEW:** Scratchpad memory

```c
// v0.3 (NEW)
extern uchar DAT_scratchpad64[64];  // 64 bytes scratchpad
extern uchar DAT_scratchpad16[16];  // 16 bytes scratchpad
```

**NEW:** Utility data

```c
// v0.3 (NEW)
extern const ushort _fixBlankLine[41]; //a 16bit formatted blank string
```

### 6.2 Type Changes in Variables

**BREAKING:** Several variables changed types

```c
// v0.2 (OLD)
extern WORD SC234[2280];
extern WORD *SC234ptr;
extern WORD DAT_drawListReady;
extern WORD LSPCmode;
extern WORD *TInextTable;

// v0.3 (NEW)
extern ushort SC234[2280];        // WORD → ushort
extern ushort *SC234ptr;          // WORD* → ushort*
extern ushort DAT_drawListReady;  // WORD → ushort
extern ushort LSPCmode;           // WORD → ushort
extern ushort *TInextTable;       // WORD* → ushort*
```

## 7. New Features in v0.3

### 7.1 Color Streams

**NEW:** Complete color stream system added

```c
// New structures and functions for advanced color effects
typedef struct colorStreamInfo { /* ... */ } colorStreamInfo;
typedef struct colorStreamJob { /* ... */ } colorStreamJob;
typedef struct colorStream { /* ... */ } colorStream;

void colorStreamInit(colorStream *cs, const colorStreamInfo *csi, ushort basePalette, ushort config);
void colorStreamSetPos(colorStream *cs, ushort pos);
```

### 7.2 Enhanced Fix Layer Support

**NEW:** Multiple fix layer functions and job system

```c
void clearFixLayer2();
void clearFixLayer3();
// + job-based fix rendering system
```

### 7.3 Enhanced Job Meter

**NEW:** Additional job meter function

```c
void jobMeterSetup2(bool setDip);
```

## 8. Migration Checklist

### 8.1 Structure Updates (CRITICAL)
1. **paletteInfo**: Replace `palCount` → `count`
2. **scrollerInfo**: Complete redesign - rewrite all scroller code
3. **scroller**: Replace `colNumber`, `topBk`, `botBk` with `config[32]`
4. **pictureInfo**: Remove `unused__height`, handle new `palInfo`
5. **spriteInfo**: Complete redesign - rewrite sprite initialization
6. **aSprite**: Update member names and handle size change
7. **Remove all `animation` structure usage**

### 8.2 Function Updates
1. Add `const` qualifiers to info structure parameters
2. Change `WORD`/`BYTE` → `ushort` in function calls
3. Add `flags` parameter to `aSpriteInit()`
4. Add `clearSprites` parameter to `spritePoolInit()`

### 8.3 Constants Updates
1. **Review all job meter colors** - values changed significantly
2. Replace hardcoded sprite flags with new `AS_FLAG_*` constants
3. Remove `ASPRITE_FRAMES_ADDR` usage

### 8.4 Type Updates
1. Replace `WORD` → `ushort` where applicable
2. Replace `DWORD` → `uint` where applicable
3. Update variable declarations for changed export types

## 9. Compatibility

### 9.1 Binary Compatibility
- **COMPLETELY BROKEN** - structures have different sizes and layouts
- **Full recompilation required**

### 9.2 Source Compatibility
- **HEAVILY BROKEN** - major API redesign
- **Manual migration required** - automated tools insufficient
- **Estimated effort**: High - complete rewrite of sprite and scroller code

## 10. Benefits of DATlib 0.3

### 10.1 Performance Improvements
- More efficient sprite animation system
- Better memory layout
- Enhanced color streaming capabilities

### 10.2 Feature Additions
- Color streams for advanced effects
- Enhanced fix layer support
- Better VRAM manipulation tools
- Improved job meter system

### 10.3 API Consistency
- Consistent use of `ushort` instead of mixed `WORD`/`BYTE`
- Better const-correctness
- More logical structure layouts
