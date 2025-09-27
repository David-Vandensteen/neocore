# Neo Geo Fix Layer Programming Guide for Neocore

## Overview

The fix layer is a specialized graphics layer on the Neo Geo system used for displaying text, UI elements, and static graphics that remain visible over sprites and backgrounds. This guide covers fix layer implementation using the **Neocore framework**, providing practical, tested methods for Neo Geo homebrew development.

## Key Characteristics

- **Resolution**: 40×32 tiles (320×224 pixels)
- **Character size**: 8×8 pixels per tile
- **Memory**: Uses dedicated VRAM separate from sprite data
- **Priority**: Always displays on top of sprites and backgrounds
- **Palettes**: 16 palettes with 16 colors each (palette 0 reserved for transparency)
- **Banks**: 16 character banks (256 characters per bank)

## Neocore Project Setup

### 1. Project Configuration (project.xml)

Your `project.xml` must define fix data resources in the DAT section:

```xml
<gfx>
  <DAT>
    <fixdata>
      <chardata>
        <setup fileType="fix">
          <charfile>out\fix.bin</charfile>
          <palfile>out\fixPals.s</palfile>
          <incfile>out\fixData.h</incfile>
        </setup>

        <!-- System font (always available) -->
        <import bank="0">
          <file>{{build}}\fix\systemFont.bin</file>
        </import>

        <!-- Custom fonts and graphics -->
        <fix bank="3" id="fix_sfz3font0">
          <file>assets\gfx\fix\font0.png</file>
        </fix>
        <fix bank="3" id="fix_bars">
          <file>assets\gfx\fix\bars.png</file>
        </fix>
        <fix bank="5" id="logo95">
          <file>assets\gfx\fix\logo95.png</file>
        </fix>
      </chardata>
    </fixdata>
  </DAT>
</gfx>
```

### 2. Required Includes

```c
#include <neocore.h>    // Neocore framework
#include "externs.h"    // Generated fix data definitions
```

### 3. Generated Files

Neocore's build system automatically generates:
- `out/fix.bin`: Binary fix layer data
- `out/fixPals.s`: Assembly palette data
- `out/fixData.h`: C header with definitions (included via externs.h)

## Neocore Fix Layer Functions

### System Initialization

**CRITICAL**: Always call `nc_update()` first to initialize the Neocore system:

```c
nc_update();  // Must be called before any fix layer operations
```

### Text Display Functions

Neocore provides two functions for displaying text on the fix layer:

#### fixPrint() - Simple Text Display

```c
void fixPrint(int x, int y, int palette, int bank, char* text);
```

Use `fixPrint()` for displaying static text without formatting:

```c
fixPrint(2, 4, 0, 0, "HELLO WORLD");    /* Simple text display */
fixPrint(2, 6, 2, 3, "CUSTOM FONT");    /* Using custom font */
```

#### fixPrintf() - Formatted Text Display

```c
void fixPrintf(int x, int y, int palette, int bank, char* format, ...);
```

Use `fixPrintf()` for displaying text with printf-style formatting:

```c
fixPrintf(2, 4, 0, 0, "SCORE: %d", score);        /* Integer formatting */
fixPrintf(2, 6, 2, 3, "TIME: %02d:%02d", min, sec);  /* Zero-padded numbers */
```

**Parameters for both functions:**
- `x, y`: Tile coordinates (0-39 for X, 0-31 for Y)
- `palette`: Palette number (0-15)
- `bank`: Font bank number (0-15)
- `text`: Null-terminated string

**Font Banks in Neocore:**
- **Bank 0**: System font (always available, no palette loading required)
- **Bank 3**: Custom font0 (requires palette loading)
- **Bank 5**: Custom logos and graphics (requires palette loading)

### Logging Functions vs Fix Display Functions

**Important**: Neocore also provides logging functions (`nc_log_info`, `nc_set_log_bank`, `nc_set_log_palette_id`) with full control:

```c
// Logging functions - FULL palette and bank control
nc_init_log();                          /* Initialize logging system */
nc_set_position_log(x, y);             /* Set position */
nc_set_log_bank(bank);                 /* Set font bank */
nc_set_log_palette_id(palette);        /* Set palette ID (works with palJobPut palettes!) */
nc_log_info("TEXT: %d", value);        /* Display with chosen palette and bank */
```

**Advantages of logging functions:**
- Automatic cursor management and line wrapping
- Consistent API for debug output
- Full control over position, palette, and font bank
- Works with custom palettes loaded via `palJobPut()`

**Recommendation**: Both approaches are now equally powerful:
- Use `fixPrint`/`fixPrintf` for direct, single-call text display
- Use logging functions for complex debug output with automatic formatting

### Palette Management

Custom fonts require their palettes to be loaded using `palJobPut()`:

```c
// Load palette for custom font0 into palette slot 2
palJobPut(2, fix_sfz3font0_Palettes.count, fix_sfz3font0_Palettes.data);

// Load logo palette into palette slot 1
palJobPut(1, logo95_Palettes.count, logo95_Palettes.data);
```


## Complete Working Example

Here's the tested, working example from `samples/custom_fix/main.c`:

```c
#include <neocore.h>
#include "externs.h"

int main(void) {
  /* STEP 1: Initialize Neocore system */
  nc_update();

  /* STEP 2: Load palettes for custom fonts */
  palJobPut(2, fix_sfz3font0_Palettes.count, fix_sfz3font0_Palettes.data);

  /* STEP 3: Display text without formatting */
  fixPrint(2, 4, 0, 0, "HELLO WORLD");              /* System font, no formatting */
  fixPrint(2, 5, 2, 3, "CUSTOM FONT");              /* Custom font0, no formatting */

  /* STEP 4: Display text with formatting */
  fixPrintf(2, 7, 0, 0, "SCORE: %d", 12500);        /* System font with formatting */
  fixPrintf(2, 8, 2, 3, "LIVES: %d", 3);            /* Custom font0 with formatting */
  fixPrintf(2, 9, 0, 0, "TIME: %02d:%02d", 5, 30);  /* System font with time format */
  fixPrintf(2, 10, 2, 3, "LEVEL %d", 7);            /* Custom font0 with level */


  /* Main loop with Neocore updates */
  while(1) {
    nc_update();  /* Keep Neocore system updated */
  }

  return 0;
}
```

## Font and Palette Reference

### Available Font Banks

| Bank | Description | Palette Required | Notes |
|------|-------------|------------------|-------|
| 0    | System font | No              | Always available, white text |
| 3    | font0       | Yes             | Custom character set from PNG |
| 5    | Logos       | Yes             | Custom graphics/logos from PNG |

### Palette Loading Strategy

```c
// Load different palettes for different purposes
palJobPut(1, logo95_Palettes.count, logo95_Palettes.data);        // Logo colors
palJobPut(2, fix_sfz3font0_Palettes.count, fix_sfz3font0_Palettes.data);  // Font colors
palJobPut(3, fix_bars_Palettes.count, fix_bars_Palettes.data);    // UI element colors
```

## Advanced Techniques

### Manual Tilemap Creation

For precise control, create tilemaps manually:

```c
#define FIX_LINE_WRITE 0x20

// Create tilemap for "HELLO"
char myTilemap[] = {0x48, 0x45, 0x4C, 0x4C, 0x4F, 0x00};

// Display using fixJobPut
fixJobPut(x, y, FIX_LINE_WRITE, palette, myTilemap);
```

### Dynamic HUD Updates

For real-time game information:

```c
void updateGameHUD(int score, int lives) {
  char buffer[32];

  // Update score
  sprintf(buffer, "SCORE %08d", score);
  fixPrint(2, 1, 0, 0, buffer);

  // Update lives
  sprintf(buffer, "LIVES %d", lives);
  fixPrint(2, 2, 0, 0, buffer);

}

// Call in main loop
while(1) {
  nc_update();
  updateGameHUD(currentScore, playerLives);
}
```

## Troubleshooting

### Common Issues with Neocore

**Black screen / Nothing displays:**
- Ensure `nc_update()` is called first to initialize Neocore
- Verify palette loading for custom fonts
- Ensure PNG files exist in the specified asset paths

**System font doesn't appear:**
- System font (bank 0) should always work with Neocore
- Use palette 0 with bank 0 for basic white text
- Verify Neocore initialization with `nc_update()`

**Custom font doesn't appear:**
- Verify PNG file exists in `assets/gfx/fix/` directory
- Ensure palette is loaded with `palJobPut()` before display
- Check that bank number matches project.xml definition
- Verify the fix graphic was built properly (check build output)

**Text flickers:**
- Don't call `fixPrint()` repeatedly in the main loop unless needed
- Call `nc_update()` once per frame in main loop

### Debug Steps

1. **Start simple**: Test with system font (bank 0) first
2. **Check build**: Ensure project compiles without errors
3. **Verify assets**: Check PNG files exist and are properly formatted
4. **Test incrementally**: Add one font at a time
5. **Check generated files**: Verify `out/fixData.h` contains expected definitions

## Neocore Best Practices

1. **Always initialize first**: Call `nc_update()` before any fix operations
2. **Load palettes early**: Load all required palettes after initialization
3. **Use system font for basics**: Bank 0 is reliable for simple text
5. **Update in main loop**: Call `nc_update()` once per frame
6. **Test incrementally**: Start with system font, then add custom fonts
7. **Organize assets**: Keep PNG files in `assets/gfx/fix/` directory
8. **Check build output**: Verify fix data generation in build logs

## Coordinate System

- **Origin**: Top-left corner (0,0)
- **X-axis**: 0-39 (left to right, 40 columns total)
- **Y-axis**: 0-31 (top to bottom, 32 rows total)
- **Screen center**: Approximately (20, 16)
- **Bounds checking**: Always ensure coordinates are within valid range

## Conclusion

The fix layer is essential for Neo Geo game interfaces when using the Neocore framework. This guide provides tested, working methods discovered through practical implementation with Neocore's build system and function library.

Key success factors for Neocore development:
- Proper initialization with `nc_update()`
- Correct palette loading for custom fonts
- Understanding Neocore's bank and palette system
- Following Neocore's project structure conventions
