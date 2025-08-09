# NeoCore v2 to v3 Migration Guide

This comprehensive guide will help you migrate your NeoCore v2.x projects to NeoCore v3.0.0. The migration involves both **NeoCore framework changes** and **DATlib library changes**.

## Table of Contents
1. [Migration Overview](#migration-overview)
2. [NeoCore Framework Migration](#neocore-framework-migration)
3. [DATlib Migration](#datlib-migration)
4. [Step-by-Step Migration Process](#step-by-step-migration-process)
5. [Migration Tools and Scripts](#migration-tools-and-scripts)
6. [Testing Your Migration](#testing-your-migration)
7. [Common Issues and Solutions](#common-issues-and-solutions)

## Migration Overview

### What's Changed
- **NeoCore Framework**: Position types, function signatures, logging API
- **DATlib 0.2 → 0.3**: Complete sprite/scroller system redesign, new type system
- **Build System**: Updated toolchain and configuration

### Compatibility Status
- **Binary Compatibility**: ❌ Completely broken - full recompilation required
- **Source Compatibility**: ❌ Heavily broken - extensive code changes required
- **Migration Complexity**: 🔴 High - expect significant development time

## NeoCore Framework Migration

### 1. Type System Changes

#### 1.1 Position Type Replacement

**OLD (v2.x):**
```c
typedef struct Vec2short { short x; short y; } Vec2short;

// Usage
Vec2short player_pos = nc_get_position_gfx_animated_sprite(player);
Vec2short enemies[10];
```

**NEW (v3.0):**
```c
typedef struct Position { short x; short y; } Position;

// Usage
Position player_pos;
nc_get_position_gfx_animated_sprite(&player, &player_pos);
Position enemies[10];
```

**Migration Steps:**
1. **Global Search & Replace**: `Vec2short` → `Position`
2. **Update Box Structure Access**: No change needed (same member names)
3. **Update Array Declarations**: Change array types accordingly

#### 1.2 Function Signature Changes

**CRITICAL**: Position getter functions now use output parameters

**OLD (v2.x):**
```c
Vec2short pos = nc_get_position_gfx_animated_sprite(player);
Vec2short pic_pos = nc_get_position_gfx_picture(picture);
Vec2short scroll_pos = nc_get_position_gfx_scroller(scroller);

if (pos.x > 100 && pos.y < 50) {
    // Do something
}
```

**NEW (v3.0):**
```c
Position pos;
nc_get_position_gfx_animated_sprite(&player, &pos);
Position pic_pos;
nc_get_position_gfx_picture(&picture, &pic_pos);
Position scroll_pos;
nc_get_position_gfx_scroller(&scroller, &scroll_pos);

if (pos.x > 100 && pos.y < 50) {
    // Do something - usage remains the same
}
```

### 2. Logging System Overhaul

#### 2.1 Basic Logging Changes

**OLD (v2.x):**
```c
nc_log("Game started");
nc_log_word("Player HP", player_hp);
nc_log_int("Score", current_score);
nc_log_vec2short("Position", player_pos);
```

**NEW (v3.0):**
```c
nc_log_info_line("Game started");
nc_log_info("Player HP: "); nc_log_word(player_hp); nc_log_next_line();
nc_log_info("Score: "); nc_log_int(current_score); nc_log_next_line();
nc_log_position(player_pos);
```

#### 2.2 Label Removal Pattern

All logging functions with label parameters have been removed:

**Removed Functions:**
- `nc_log_word(char *label, WORD value)` → `nc_log_word(WORD value)`
- `nc_log_int(char *label, int value)` → `nc_log_int(int value)`
- `nc_log_short(char *label, short value)` → `nc_log_short(short value)`
- `nc_log_vec2short(char *label, Vec2short vec)` → `nc_log_position(Position pos)`

#### 2.3 Type Removals

**BREAKING:** Hex color typedefs have been removed

**OLD (v2.x):**
```c
typedef char Hex_Color[3];
typedef char Hex_Packed_Color[5];

// Usage
Hex_Color hex_red = "FF0000";
Hex_Packed_Color hex_packed = "7FFF";
```

**NEW (v3.0):**
```c
// Types no longer available - use direct string literals or char arrays
char hex_red[3] = "FF0000";      // Manual array declaration
char hex_packed[5] = "7FFF";     // Manual array declaration
```

**Migration Required:**
- Replace `Hex_Color` declarations with `char[3]` arrays
- Replace `Hex_Packed_Color` declarations with `char[5]` arrays
- Update function parameters that used these types

### 3. Utility Functions

**OLD (v2.x):**
```c
void nc_update_mask(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max);
BOOL nc_vectors_collide(Box *box, Vec2short vec[], BYTE vector_max);
Vec2short relative = nc_get_relative_position(box, world_coord); // REMOVED
```

**NEW (v3.0):**
```c
void nc_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max);
BOOL nc_vectors_collide(Box *box, Position vec[], BYTE vector_max);
// nc_get_relative_position is no longer available
```

## DATlib Migration

### 1. Type System Overhaul

#### 1.1 Fundamental Type Changes

**OLD (DATlib 0.2):**
```c
// Used WORD, DWORD, BYTE from system headers
typedef struct paletteInfo {
  WORD palCount;
  WORD data[0];
} paletteInfo;
```

**NEW (DATlib 0.3):**
```c
// New type definitions
#define bool unsigned short  // NEW type added

typedef struct paletteInfo {
  ushort count;      // palCount → count
  ushort data[0];    // WORD → ushort
} paletteInfo;
```

**Migration Required:**
- Replace `paletteInfo->palCount` with `paletteInfo->count`
- Update all `WORD` → `ushort`, `DWORD` → `uint`

### 2. Structure Complete Redesigns

#### 2.1 Scroller System (COMPLETE REWRITE REQUIRED)

**OLD (DATlib 0.2):**
```c
typedef struct scrollerInfo {
  WORD colSize;      // column size (words)
  WORD sprHeight;
  WORD mapWidth;
  WORD mapHeight;
  WORD map[0];       // map data
} scrollerInfo;

typedef struct scroller {
  WORD baseSprite;
  WORD basePalette;
  WORD colNumber[21];     // Column configuration
  WORD topBk, botBk;      // Background colors
  WORD scrlPosX, scrlPosY;
  scrollerInfo *info;
  //58 bytes
} scroller;
```

**NEW (DATlib 0.3):**
```c
typedef struct scrollerInfo {
  ushort stripSize;        // column size (BYTES!) - unit changed!
  ushort sprHeight;
  ushort mapWidth;
  ushort mapHeight;
  paletteInfo *palInfo;    // NEW: palette information
  colorStreamInfo *csInfo; // NEW: color stream system
  ushort *strips[0];       // NEW: replaces map array
} scrollerInfo;

typedef struct scroller {
  ushort baseSprite;
  ushort basePalette;
  short scrlPosX, scrlPosY;  // Type changed to short
  scrollerInfo *info;
  ushort config[32];         // NEW: replaces colNumber, topBk, botBk
  //76 bytes - size increased!
} scroller;
```

**Migration Strategy:**
⚠️ **Complete rewrite required** - the scroller system is fundamentally different
1. **Remove all direct access** to `colNumber`, `topBk`, `botBk`
2. **Implement new configuration system** using `config[32]` array
3. **Convert map data** to new strip-based system
4. **Update size calculations** (58 → 76 bytes)

#### 2.2 Animated Sprite System (MAJOR CHANGES)

**CRITICAL**: The `animation` structure has been **completely removed**

**OLD (DATlib 0.2):**
```c
typedef struct animation {
  WORD stepsCount;
  WORD repeats;
  animStep *data;
  struct animation *link;
} animation;

typedef struct aSprite {
  // ... position fields ...
  short currentStepNum;
  short maxStep;
  sprFrame *frames;           // frames bank (unused)
  animation *anims;           // anims bank
  animation *currentAnimation;
  animStep *steps;
  animStep *currentStep;
  DWORD counter;
  WORD repeats;
  // ...
  //50 bytes
} aSprite;
```

**NEW (DATlib 0.3):**
```c
// animation structure REMOVED entirely

typedef struct aSprite {
  // ... position fields ...
  ushort animID;              // Moved position
  ushort currentAnim;         // NEW: replaces currentAnimation
  ushort stepNum;             // Renamed from currentStepNum
  animStep *anims;            // anims bank
  animStep *steps;            // steps bank of current anim
  animStep *currentStep;      // current step
  sprFrame *currentFrame;     // current frame
  uint counter;               // DWORD → uint
  ushort repeats;
  // Removed: maxStep, frames, currentAnimation
  //42 bytes - size decreased!
} aSprite;
```

**Migration Steps:**
1. **Remove all `animation*` references**
2. **Replace `animation` arrays** with direct `animStep**` arrays
3. **Update member access:**
   - `currentStepNum` → `stepNum`
   - `currentAnimation` → use `currentAnim` index
   - Remove `maxStep`, `frames` access
4. **Handle size change** (50 → 42 bytes)

### 3. Job Meter Colors (BREAKING)

**⚠️ CRITICAL**: Almost all job meter color values have changed

**OLD (DATlib 0.2):**
```c
#define JOB_BLACK       0x0000
#define JOB_LIGHTRED    0x7f66
#define JOB_DARKRED     0xc900
#define JOB_GARKGREEN   0xa090  // Typo!
// ... many more
```

**NEW (DATlib 0.3):**
```c
#define JOB_BLACK       0x8000  // ⚠️ CHANGED!
#define JOB_LIGHTRED    0xcf88  // ⚠️ CHANGED!
#define JOB_DARKRED     0x8800  // ⚠️ CHANGED!
#define JOB_DARKGREEN   0x8080  // Fixed typo, changed value
// ⚠️ ALL colors have new values!

// NEW colors added:
#define JOB_LIGHTGREY   0x7bbb
#define JOB_GREY        0x8888
#define JOB_DARKGREY    0x8444
```

**Migration Required:**
⚠️ **Review ALL hardcoded color usage** - values changed significantly

### 4. Function Signature Changes

#### 4.1 Parameter Type Changes

**OLD (DATlib 0.2):**
```c
void pictureInit(picture *p, pictureInfo *pi, WORD baseSprite, BYTE basePalette, short posX, short posY, WORD flip);
void aSpriteInit(aSprite *as, spriteInfo *si, WORD baseSprite, BYTE basePalette, short posX, short posY, WORD anim, WORD flip);
void spritePoolInit(spritePool *sp, WORD baseSprite, WORD size);
```

**NEW (DATlib 0.3):**
```c
void pictureInit(picture *p, const pictureInfo *pi, ushort baseSprite, ushort basePalette, short posX, short posY, ushort flip);
void aSpriteInit(aSprite *as, const spriteInfo *si, ushort baseSprite, ushort basePalette, short posX, short posY, ushort anim, ushort flip, ushort flags);
void spritePoolInit(spritePool *sp, ushort baseSprite, ushort size, bool clearSprites);
```

**Migration Steps:**
1. **Update all function calls** to use `ushort` instead of `WORD`/`BYTE`
2. **Add `const` qualifiers** to info structure parameters
3. **Add new parameters:**
   - `aSpriteInit`: gained `flags` parameter
   - `spritePoolInit`: gained `clearSprites` parameter

### 5. New Features in DATlib 0.3

#### 5.1 Color Streams (NEW)
```c
typedef struct colorStreamInfo { /* advanced color effects */ } colorStreamInfo;
typedef struct colorStream { /* ... */ } colorStream;

void colorStreamInit(colorStream *cs, const colorStreamInfo *csi, ushort basePalette, ushort config);
void colorStreamSetPos(colorStream *cs, ushort pos);
```

#### 5.2 Enhanced Fix Layer Support (NEW)
```c
void clearFixLayer2();
void clearFixLayer3();
// + job-based fix rendering with fixJobPut macro
```

#### 5.3 VRAM Manipulation Macros (NEW)
```c
#define VRAM_SPR_ADDR(s)   ((s)<<6)
#define VRAM_FIX_ADDR(x,y) (0x7000+(((x)<<5)+(y)))
#define VRAM_SHRINK_ADDR(s) (0x8000|(s))
// ... many more VRAM macros
```

## Step-by-Step Migration Process

### Phase 1: Project Setup

#### 1.1 Project Configuration Migration (CRITICAL)

**⚠️ BREAKING:** The `project.xml` structure has significant changes that require manual updates.

**OLD (v2.x):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <name></name>
  <version>1.0.0</version>
  <makefile>Makefile</makefile>
  <gfx>
    <DAT>
      <chardata>
        <setup>
          <starting_tile>256</starting_tile>
        </setup>
        <pict id="logo">
          <file>assets\gfx\logo.png</file>
        </pict>
      </chardata>
    </DAT>
  </gfx>
  <sound>
    <sfx>
      <pcm>assets\sounds\sfx\click.V1</pcm>
      <z80>assets\sounds\sfx\click.M1</z80>
    </sfx>
    <cdda>
      <!-- cdda configuration -->
    </cdda>
  </sound>
  <!-- emulator config unchanged -->
  <neocorePath>..\neocore</neocorePath>
  <buildPath>..\build</buildPath>
  <distPath>..\dist</distPath>
  <compiler>
    <name>gcc</name>
    <version>2.95.2</version>
    <path>{{build}}\gcc\gcc-2.95.2</path>
    <includePath>{{build}}\include</includePath>
    <libraryPath>{{build}}\lib</libraryPath>
    <systemFile>{{build}}\system\neocd.x</systemFile>
  </compiler>
</project>
```

**NEW (v3.0):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <name></name>
  <version>1.0.0</version>
  <platform>cd</platform>                                    <!-- NEW: Platform specification -->
  <makefile>Makefile</makefile>
  <neocorePath>..\neocore</neocorePath>                      <!-- MOVED: Now at top level -->
  <buildPath>{{neocore}}\build</buildPath>                   <!-- CHANGED: Now uses template variables -->
  <distPath>{{neocore}}\dist</distPath>                      <!-- CHANGED: Now uses template variables -->
  <gfx>
    <DAT>
      <chardata>
        <setup>
          <starting_tile>256</starting_tile>
          <charfile>out\char.bin</charfile>                   <!-- NEW: Output file specifications -->
          <mapfile>out\charMaps.s</mapfile>                   <!-- NEW -->
          <palfile>out\charPals.s</palfile>                   <!-- NEW -->
          <incfile>out\charInclude.h</incfile>                <!-- NEW -->
          <incprefix>../</incprefix>                          <!-- NEW -->
        </setup>
        <pict id="logo">
          <file>assets\gfx\logo.png</file>
        </pict>
      </chardata>
      <fixdata>                                               <!-- NEW: Fix data section -->
        <chardata>
          <setup fileType="fix">
            <charfile>out\fix.bin</charfile>
            <palfile>out\fixPals.s</palfile>
            <incfile>out\fixData.h</incfile>
          </setup>
          <import bank="0">
            <file>{{build}}\fix\systemFont.bin</file>
          </import>
        </chardata>
      </fixdata>
    </DAT>
  </gfx>
  <sound>
    <cd>                                                      <!-- NEW: Wrapped in <cd> element -->
      <sfx>                                                   <!-- MOVED: Now under <cd> -->
        <pcm>assets\sounds\sfx\click.V1</pcm>
        <z80>assets\sounds\sfx\click.M1</z80>
      </sfx>
      <cdda>
        <!-- cdda configuration -->
      </cdda>
    </cd>
  </sound>
  <!-- emulator config unchanged -->
  <compiler>
    <name>gcc</name>
    <version>2.95.2</version>
    <path>{{build}}\gcc\gcc-2.95.2</path>
    <includePath>{{neocore}}\src-lib\include</includePath>    <!-- CHANGED: Now points to neocore -->
    <libraryPath>{{build}}\lib</libraryPath>
    <crtPath>{{neocore}}\src-lib\crt</crtPath>                <!-- NEW: CRT path configuration -->
    <systemFile>
      <cd>{{neocore}}\src-lib\system\neocd.x</cd>             <!-- CHANGED: Now nested structure -->
      <cartridge>{{neocore}}\src-lib\system\neocart.x</cartridge> <!-- NEW: Cartridge support -->
    </systemFile>
  </compiler>
</project>
```

**Migration Steps:**

1. **Add new required elements:**
   ```xml
   <platform>cd</platform>  <!-- Add after <version> -->
   ```

2. **Move neocorePath to top level:**
   ```xml
   <!-- Move from bottom of file to after <distPath> -->
   <neocorePath>..\neocore</neocorePath>
   ```

3. **Update path templates:**
   ```xml
   <!-- OLD -->
   <buildPath>..\build</buildPath>
   <distPath>..\dist</distPath>

   <!-- NEW -->
   <buildPath>{{neocore}}\build</buildPath>
   <distPath>{{neocore}}\dist</distPath>
   ```

4. **Add chardata output specifications:**
   ```xml
   <setup>
     <starting_tile>256</starting_tile>
     <!-- ADD THESE -->
     <charfile>out\char.bin</charfile>
     <mapfile>out\charMaps.s</mapfile>
     <palfile>out\charPals.s</palfile>
     <incfile>out\charInclude.h</incfile>
     <incprefix>../</incprefix>
   </setup>
   ```

5. **Add fixdata section (optional but recommended):**
   ```xml
   <gfx>
     <DAT>
       <chardata>...</chardata>
       <!-- ADD THIS SECTION -->
       <fixdata>
         <chardata>
           <setup fileType="fix">
             <charfile>out\fix.bin</charfile>
             <palfile>out\fixPals.s</palfile>
             <incfile>out\fixData.h</incfile>
           </setup>
           <import bank="0">
             <file>{{build}}\fix\systemFont.bin</file>
           </import>
         </chardata>
       </fixdata>
     </DAT>
   </gfx>
   ```

6. **Wrap sound elements in cd:**
   ```xml
   <!-- OLD -->
   <sound>
     <sfx>...</sfx>
     <cdda>...</cdda>
   </sound>

   <!-- NEW -->
   <sound>
     <cd>
       <sfx>...</sfx>
       <cdda>...</cdda>
     </cd>
   </sound>
   ```

7. **Update compiler configuration:**
   ```xml
   <compiler>
     <!-- UPDATE -->
     <includePath>{{neocore}}\src-lib\include</includePath>

     <!-- ADD -->
     <crtPath>{{neocore}}\src-lib\crt</crtPath>

     <!-- CHANGE -->
     <systemFile>
       <cd>{{neocore}}\src-lib\system\neocd.x</cd>
       <cartridge>{{neocore}}\src-lib\system\neocart.x</cartridge>
     </systemFile>
   </compiler>
   ```

#### 1.2 Update NeoCore Version
   - Update project.xml using steps above
   - Update build system references

#### 1.3 Remove Deprecated Files

⚠️ **Important**: The following files are no longer needed in NeoCore v3 and will be automatically removed:

**Files automatically removed:**
- `common_crt0_cd.s` - Deprecated startup file
- `crt0_cd.s` - Deprecated startup file

**Automatic removal by migration script:**
The official migration script (`_upgrade.ps1`) automatically detects and removes these files during migration. You will see log entries like:
```
[SUCCESS] Successfully deleted deprecated file: ...\common_crt0_cd.s
[SUCCESS] Successfully deleted deprecated file: ...\crt0_cd.s
```

**Manual removal (if not using migration script):**
```bash
# Remove from your project directory manually if needed
rm src/common_crt0_cd.s
rm src/crt0_cd.s
```

#### 1.4 Backup Your Project
   ```bash
   git tag pre-neocore-v3-migration
   git commit -am "Pre-migration backup"
   ```

### Phase 2: NeoCore Framework Migration

1. **Type System Migration**
   ```bash
   # Global search and replace (use your IDE)
   Vec2short → Position
   ```

2. **Position Getter Functions**
   ```c
   // Find all instances of:
   Vec2short pos = nc_get_position_*()

   // Replace with:
   Position pos;
   nc_get_position_*(&object, &pos);
   ```

3. **Logging System Migration**
   ```c
   // Replace basic logging:
   nc_log("message") → nc_log_info_line("message")

   // Replace labeled logging:
   nc_log_word("Label", value) → nc_log_info("Label: "); nc_log_word(value); nc_log_next_line()
   ```

4. **Type Removals Migration**
   ```c
   // Replace removed typedefs:
   Hex_Color → char[3] or char*
   Hex_Packed_Color → char[5] or char*

   // Example:
   Hex_Color myColor;     // OLD
   char myColor[3];       // NEW
   ```

### Phase 3: DATlib Migration

1. **Palette Structure Migration**
   ```c
   // Replace all instances:
   paletteInfo->palCount → paletteInfo->count
   ```

2. **Type Migration**
   ```c
   // Global replacements:
   WORD → ushort
   DWORD → uint
   BYTE → uchar (where appropriate)
   ```

3. **Scroller System Rewrite** ⚠️ **CRITICAL**
   - **Complete rewrite required** for all scroller code
   - Remove `colNumber`, `topBk`, `botBk` usage
   - Implement new `config[32]` system
   - Convert to strip-based system

4. **Animated Sprite Migration**
   ```c
   // Remove animation structures:
   animation *myAnims; // REMOVE

   // Update aSprite member access:
   sprite->currentStepNum → sprite->stepNum
   sprite->currentAnimation → use sprite->currentAnim index
   // Remove: maxStep, frames access
   ```

5. **Function Signature Updates**
   ```c
   // Add new parameters:
   aSpriteInit(as, si, baseSprite, basePalette, x, y, anim, flip, flags);
   spritePoolInit(sp, baseSprite, size, clearSprites);
   ```

### Phase 4: Testing and Validation

1. **Compilation Test**
   ```bash
   make clean
   make
   # Fix all compilation errors
   ```

2. **Functionality Testing**
   - Test all sprite animations
   - Test scroller functionality
   - Test logging output
   - Test collision detection
   - Verify color output (job meter colors changed!)

3. **Performance Validation**
   - Check memory usage (structure sizes changed)
   - Verify frame rate performance
   - Test under different load conditions

## Migration Tools and Scripts

### Official Migration Script (Recommended)

NeoCore v3 includes an official migration script that automates many migration tasks:

```powershell
# Location: bootstrap/scripts/project/_upgrade.ps1
# Usage:
.\bootstrap\scripts\project\_upgrade.ps1 -ProjectSrcPath "path\to\your\src" -ProjectNeocorePath "path\to\neocore"
```

**What the script does automatically:**
- ✅ **Project.xml migration**: Automatically updates structure for v3 compatibility
- ✅ **Code analysis**: Scans C files for v2/v3 compatibility issues
- ✅ **Deprecated file cleanup**: Automatically removes obsolete files:
  - `common_crt0_cd.s` (no longer needed)
  - `crt0_cd.s` (no longer needed)
- ✅ **Validation**: Checks .gitignore patterns and project structure
- ✅ **Backup creation**: Creates automatic backup in temp directory
- ✅ **Detailed logging**: Comprehensive migration log for debugging

**Migration process:**
1. Run the script with your project paths
2. Review compatibility warnings for C code
3. Manually update C code based on analysis results
4. Test your migrated project

### Automated Search & Replace Script
```bash
#!/bin/bash
# migration-helper.sh

echo "NeoCore v2 to v3 Migration Helper"

# NeoCore Framework migrations
find . -name "*.c" -o -name "*.h" | xargs sed -i 's/Vec2short/Position/g'
find . -name "*.c" -o -name "*.h" | xargs sed -i 's/nc_log_vec2short/nc_log_position/g'

# DATlib migrations
find . -name "*.c" -o -name "*.h" | xargs sed -i 's/->palCount/->count/g'
find . -name "*.c" -o -name "*.h" | xargs sed -i 's/->colNumber/\/\* MIGRATION NEEDED: colNumber removed \*\//g'
find . -name "*.c" -o -name "*.h" | xargs sed -i 's/->topBk/\/\* MIGRATION NEEDED: topBk removed \*\//g'
find . -name "*.c" -o -name "*.h" | xargs sed -i 's/->botBk/\/\* MIGRATION NEEDED: botBk removed \*\//g'
find . -name "*.c" -o -name "*.h" | xargs sed -i 's/->currentStepNum/->stepNum/g'

echo "Automated replacements completed. Manual review required for:"
echo "- Position getter function calls"
echo "- Logging function calls"
echo "- Scroller system (complete rewrite needed)"
echo "- Animation system (manual updates needed)"
```

### Validation Script
```bash
#!/bin/bash
# validate-migration.sh

echo "Checking for common migration issues..."

# Check for old function patterns
echo "=== Checking for old position getter patterns ==="
grep -r "= nc_get_position_" . --include="*.c" && echo "⚠️  Found old position getter patterns"

# Check for old logging patterns
echo "=== Checking for old logging patterns ==="
grep -r "nc_log(" . --include="*.c" && echo "⚠️  Found old nc_log() calls"

# Check for removed structures
echo "=== Checking for removed structures ==="
grep -r "animation \*" . --include="*.c" --include="*.h" && echo "⚠️  Found animation* usage"

# Check for removed members
echo "=== Checking for removed members ==="
grep -r "->colNumber\|->topBk\|->botBk\|->maxStep\|->currentAnimation" . --include="*.c" && echo "⚠️  Found removed member access"

echo "Validation complete. Review warnings above."
```

## Common Issues and Solutions

### Issue 1: Compilation Errors with Position Getters
**Problem:**
```c
Vec2short pos = nc_get_position_gfx_animated_sprite(player); // Error
```

**Solution:**
```c
Position pos;
nc_get_position_gfx_animated_sprite(&player, &pos);
```

### Issue 2: Job Meter Colors Look Wrong
**Problem:** Colors appear different after migration

**Root Cause:** Job meter color constants have completely different values

**Solution:** Review and update all hardcoded color usage:
```c
// Check if you're using any JOB_* constants
// Verify visually that colors match your expectations
jobMeterColor(JOB_RED); // This is now a different red!
```

### Issue 3: Scroller System Crashes
**Problem:** Scroller code causes crashes or displays incorrectly

**Root Cause:** Scroller structures completely redesigned

**Solution:** Complete rewrite required - the old API is incompatible

### Issue 4: Animation System Not Working
**Problem:** Sprite animations don't play correctly

**Root Cause:** `animation` structure removed, `aSprite` structure changed

**Solution:**
1. Remove all `animation*` references
2. Update `aSprite` member access patterns
3. Use new animation control functions

### Issue 5: Logging Output Missing or Incorrect
**Problem:** Log messages don't appear or format incorrectly

**Solution:**
```c
// OLD
nc_log_word("HP", player_hp);

// NEW
nc_log_info("HP: ");
nc_log_word(player_hp);
nc_log_next_line();
```

## Performance Considerations

### Memory Usage Changes
- **aSprite**: 50 → 42 bytes (16% reduction)
- **scroller**: 58 → 76 bytes (31% increase)
- **Position getters**: No structure copying overhead

### Performance Improvements
- Position functions avoid structure copying
- Better memory layout with consistent types
- Enhanced color streaming capabilities
- More efficient animation system

## Benefits After Migration

### 1. Performance Improvements
- Reduced memory copying overhead
- Better cache performance with consistent types
- More efficient sprite animation system

### 2. Enhanced Capabilities
- **Color Streams**: Advanced color effects system
- **Enhanced Fix Layer**: Multi-layer support with job system
- **VRAM Manipulation**: Direct VRAM access macros
- **Better Logging**: More flexible logging system

### 3. Code Quality
- Consistent type system (`ushort` vs mixed `WORD`/`BYTE`)
- Better const-correctness
- More logical structure layouts
- Improved API design

## Conclusion

The migration from NeoCore v2 to v3 is a significant undertaking that will require substantial code changes. However, the improvements in performance, capabilities, and code quality make this migration worthwhile for ongoing projects.

**Expected Timeline:**
- **Small Projects**: 1-2 days
- **Medium Projects**: 1-2 weeks
- **Large Projects**: 2-4 weeks

**Critical Success Factors:**
1. **Complete backup** before starting
2. **Methodical approach** following this guide
3. **Thorough testing** of migrated functionality
4. **Visual validation** of color and animation changes

**Support Resources:**
- NeoCore v3 documentation
- Community forums
- Migration validation scripts (provided above)

Good luck with your migration!
