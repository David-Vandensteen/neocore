# Neo Geo Fix Layer Programming Guide

## Overview

The fix layer on the Neo Geo is a dedicated graphics layer used for displaying text, UI elements, and static graphics. Unlike sprites which can be moved freely, the fix layer provides a fixed character-based display mode, perfect for HUDs, score displays, menus, and other interface elements.

The fix layer operates at a resolution of 40x32 characters (320x256 pixels at 8x8 pixels per character), making it ideal for text display and simple graphics.

## Key Concepts

### Fix Layer Characteristics
- **Resolution**: 40 columns × 32 rows (320×256 pixels)
- **Character Size**: 8×8 pixels per character
- **Color Depth**: 4 bits per pixel (16 colors per character)
- **Palette Support**: Each character can use any of the 256 available palettes
- **Priority**: Fix layer always displays on top of sprite layers

### Memory Layout
The fix layer uses dedicated VRAM areas:
- Fix character data: Character definitions (graphics)
- Fix tilemap: Character placement and attributes on screen

### Character Banks
Fix layer characters are organized into banks, each bank containing 256 characters (8-bit addressing within bank):
- **Bank 0**: Typically reserved for system font (imported from system)
- **Bank 3**: Custom fonts and UI elements
- **Bank 5**: Logos and large graphics
- **Banks 1-15**: Available for custom graphics

Each character is addressed using a bank number (4 bits) plus character index (8 bits).

## Project Configuration

### Setting Up Fix Data in project.xml

The fix layer character data is configured in your `project.xml` file within the `<fixdata>` section:

```xml
<fixdata>
  <chardata>
    <setup fileType="fix">
      <charfile>out\fix.bin</charfile>
      <palfile>out\fixPals.s</palfile>
      <incfile>out\fixData.h</incfile>
    </setup>

    <!-- Import system font into bank 0 -->
    <import bank="0">
      <file>{{build}}\fix\systemFont.bin</file>
    </import>

    <!-- Custom fonts and UI elements in bank 3 -->
    <fix bank="3" id="fix_sfz3font0">
      <file>gfx\fix\font0.png</file>
    </fix>
    <fix bank="3" id="fix_bars">
      <file>gfx\fix\bars.png</file>
    </fix>

    <!-- Logos in bank 5 -->
    <fix bank="5" id="logo95">
      <file>gfx\fix\logo95.png</file>
    </fix>
    <fix bank="5" id="logo96">
      <file>gfx\fix\logo96.png</file>
    </fix>
  </chardata>
</fixdata>
```

### Fix Data Organization

**Bank Assignment Strategy:**
- **Bank 0**: System font (automatically imported)
- **Bank 1-2**: Available for additional system resources
- **Bank 3**: Primary custom fonts and UI elements
- **Bank 4**: Additional UI graphics
- **Bank 5**: Logos and title graphics
- **Bank 6-15**: Available for game-specific graphics

**Generated Files:**
- `fix.bin`: Binary character data for all banks
- `fixPals.s`: Palette data for fix graphics
- `fixData.h`: C header with character definitions and bank references

## Essential Functions

### Clearing the Fix Layer

```c
// Clear the entire fix layer immediately
clearFixLayer();

// IRQ-safe version
clearFixLayer2();

// Vblank-synchronized version (uses command buffer)
clearFixLayer3();
```

**When to use each version:**
- `clearFixLayer()`: Use during normal execution when interrupts are safe
- `clearFixLayer2()`: Use inside interrupt handlers or when IRQ safety is required
- `clearFixLayer3()`: Use when you want the clear to happen during the next vblank

### Text Display Functions

#### Basic Text Display

```c
// Display text at position (x, y) with specified palette and bank
fixPrint(x, y, palette, bank, "Your text here");

// IRQ-safe version
fixPrint2(x, y, palette, bank, "Your text here");
```

**Parameters:**
- `x`: Column position (0-39)
- `y`: Row position (0-31)
- `palette`: Palette number (0-15)
- `bank`: Character bank (character MSB, 4 bits)
- `buf`: String to display

#### Formatted Text Display

```c
// Printf-style formatted text
fixPrintf1(x, y, palette, bank, "Score: %d", playerScore);

// IRQ-safe version
fixPrintf2(x, y, palette, bank, "Lives: %d", playerLives);

// Vblank-synchronized version (recommended)
fixPrintf3(x, y, palette, bank, buffer, "Health: %d%%", health);
```

### Advanced Fix Layer Operations

#### Manual Tilemap Creation

Unlike sprites, fix layer tilemaps must be created manually. Each tilemap entry is a 16-bit value containing character and palette information:

```c
// Manual tilemap structure for fix layer
// Format: (palette << 12) | (bank << 8) | character
typedef struct {
    ushort tile;  // Character definition: PPPPBBBBCCCCCCCC
                  // P = Palette (4 bits)
                  // B = Bank (4 bits)
                  // C = Character (8 bits)
} fixTile;

// Create a tilemap manually
ushort myTilemap[40 * 32];  // Full screen tilemap

// Set a character at position (x,y)
#define FIX_TILE(pal, bank, chr) (((pal) << 12) | ((bank) << 8) | (chr))
myTilemap[y * 40 + x] = FIX_TILE(palette, bank, character);
```

#### Tilemap Helper Macros

```c
// Helper macros for tilemap creation
#define FIX_CHAR(bank, chr) (((bank) << 8) | (chr))
#define FIX_PALETTE(pal) ((pal) << 12)
#define FIX_TILE_FULL(pal, bank, chr) (((pal) << 12) | ((bank) << 8) | (chr))

// Usage examples
ushort letterA = FIX_TILE_FULL(2, 3, 'A');  // Palette 2, Bank 3, character 'A'
ushort space = FIX_TILE_FULL(0, 0, 0x20);   // Space character
```

#### DATdemo Example: Logo Tilemaps

The DATdemo sample shows real-world tilemap creation. Logos are stored as static arrays using only bank and character data (no palette info in the tilemap itself):

```c
// DATdemo logo tilemaps (from samples/DATdemo/main.c)
// Note: These only contain bank+character, palette is applied via fixJobPut
static const ushort logo_95[78] = {
    0x0500,0x0501,0x0502,0x0503,0x0504,0x0505,0x0506,0x0507,0x0508,0x0509,0x050a,0x050b,0x0000,
    0x0510,0x0511,0x0512,0x0513,0x0514,0x0515,0x0516,0x0517,0x0518,0x0519,0x051a,0x051b,0x0000,
    0x0520,0x0521,0x0522,0x0523,0x0524,0x0525,0x0526,0x0527,0x0528,0x0529,0x052a,0x052b,0x0000,
    0x0530,0x0531,0x0532,0x0533,0x0534,0x0535,0x0536,0x0537,0x0538,0x0539,0x053a,0x053b,0x0000,
    0x0540,0x0541,0x0542,0x0543,0x0544,0x0545,0x0546,0x0547,0x0548,0x0549,0x054a,0x054b,0x0000,
    0x0550,0x0551,0x0552,0x0553,0x0554,0x0555,0x0556,0x0557,0x0558,0x0559,0x055a,0x055b,0x0000
};

// Display the logo
ushort *data = (ushort*)&logo_95;
palJobPut(13, 1, &logo95_Palettes.data);  // Load palette first
// Display 6 lines, 13 characters each (with line terminator 0x0000)
fixJobPut(23, 6, FIX_LINE_WRITE, 13, data);         // Line 1
fixJobPut(23, 7, FIX_LINE_WRITE, 13, data + 13);    // Line 2
fixJobPut(23, 8, FIX_LINE_WRITE, 13, data + 26);    // Line 3
fixJobPut(23, 9, FIX_LINE_WRITE, 13, data + 39);    // Line 4
fixJobPut(23, 10, FIX_LINE_WRITE, 13, data + 52);   // Line 5
fixJobPut(23, 11, FIX_LINE_WRITE, 13, data + 65);   // Line 6
```

#### Tilemap Format Analysis

From DATdemo, we can see two approaches:

**1. Bank+Character only (DATdemo logos):**
```c
// Format: 0x0BBB (Bank 5, Characters 0x00-0x0B)
0x0500, 0x0501, 0x0502, ... 0x050b, 0x0000  // Line terminator
```

**2. System-provided blank line:**
```c
// _fixBlankLine is predefined in DATlib (40 characters + terminator)
extern const ushort _fixBlankLine[41];  // All 0x00FF (transparent chars)

// Clear specific lines
fixJobPut(0, 25, FIX_LINE_WRITE, 0, _fixBlankLine);
fixJobPut(0, 26, FIX_LINE_WRITE, 0, _fixBlankLine);
```

#### Loading Custom Tilemaps

```c
// Load a pre-defined tilemap to fix layer
void loadFixTilemap(ushort *tilemap, ushort startX, ushort startY, ushort width, ushort height) {
    ushort x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            if ((startX + x < 40) && (startY + y < 32)) {
                fixJobPut(startX + x, startY + y, FIX_LINE_WRITE, 0,
                         &tilemap[y * width + x]);
            }
        }
    }
}

// Example: Load a 10x5 logo tilemap
ushort logoTilemap[50] = {
    FIX_TILE_FULL(5, 5, 0x01), FIX_TILE_FULL(5, 5, 0x02), /* ... */
    // Define your logo pattern here
};
loadFixTilemap(logoTilemap, 15, 10, 10, 5);
```

#### Using Fix Jobs Buffer

For more control and vblank synchronization, use the fix jobs buffer:

```c
// Add a fix operation to the command buffer
fixJobPut(x, y, modulo, palette, data);
```

**Parameters:**
- `x`: Target X position on fix layer
- `y`: Target Y position on fix layer
- `modulo`: Operation type and character count
  - `FIX_LINE_WRITE`: Write a line of characters (modulo = character count)
  - Other modulo values for different operations
- `palette`: Base palette number to apply to characters
- `data`: Pointer to tilemap data

**Important FIX_LINE_WRITE behavior:**
- When using `FIX_LINE_WRITE`, the `modulo` parameter specifies how many characters to write
- Characters are written horizontally from position (x,y)
- The `palette` parameter is applied to all characters in the line
- Data should be terminated with 0x0000 or specify exact count with modulo

#### DATdemo Line Writing Examples

```c
// Method 1: Using character count (DATdemo approach)
ushort logoLine[13] = {0x0500,0x0501,0x0502,0x0503,0x0504,0x0505,
                       0x0506,0x0507,0x0508,0x0509,0x050a,0x050b,0x0000};
fixJobPut(23, 6, FIX_LINE_WRITE, 13, logoLine);  // Write 13 characters with palette 13

// Method 2: Using _fixBlankLine for clearing
fixJobPut(0, 25, FIX_LINE_WRITE, 0, _fixBlankLine);  // Clear entire line 25

// Method 3: Single character placement
ushort singleChar = 0x0501;  // Bank 5, character 1
fixJobPut(10, 15, FIX_LINE_WRITE, 1, &singleChar);  // Place one character
```
- `data`: Pointer to fix character data

#### Clearing Specific Areas

```c
// Clear specific lines using the fix jobs buffer
fixJobPut(0, 25, FIX_LINE_WRITE, 0, _fixBlankLine);
fixJobPut(0, 26, FIX_LINE_WRITE, 0, _fixBlankLine);
fixJobPut(0, 27, FIX_LINE_WRITE, 0, _fixBlankLine);
```

## Practical Examples

### Example 1: Basic HUD Display

```c
void displayHUD() {
    // Clear the fix layer
    clearFixLayer();

    // Display game title using bank 5 (logo graphics)
    fixPrint(12, 2, 4, 5, "SUPER GAME");

    // Display player info using bank 3 (custom font)
    fixPrint(2, 4, 2, 3, "PLAYER 1");
    fixPrint(2, 6, 2, 3, "SCORE:");
    fixPrintf1(8, 6, 2, 3, "%08d", playerScore);

    // Display lives using system font (bank 0)
    fixPrint(2, 8, 2, 0, "LIVES:");
    fixPrintf1(8, 8, 2, 0, "%d", playerLives);
}
```

### Example 2: DATdemo-Style Logo Display

```c
// Based on DATdemo approach - separate tilemap data from palette
void displayGameLogo(ushort logoNum) {
    ushort *data;

    // Logo tilemaps (bank+character only, no palette)
    static const ushort logo_title[39] = {  // 3 lines x 13 chars each
        0x0500,0x0501,0x0502,0x0503,0x0504,0x0505,0x0506,0x0507,0x0508,0x0509,0x050a,0x050b,0x0000,
        0x0510,0x0511,0x0512,0x0513,0x0514,0x0515,0x0516,0x0517,0x0518,0x0519,0x051a,0x051b,0x0000,
        0x0520,0x0521,0x0522,0x0523,0x0524,0x0525,0x0526,0x0527,0x0528,0x0529,0x052a,0x052b,0x0000
    };

    // Load palette first
    palJobPut(13, 1, &logo95_Palettes.data);

    // Display logo lines using FIX_LINE_WRITE
    data = (ushort*)&logo_title;
    fixJobPut(15, 8, FIX_LINE_WRITE, 13, data);        // Line 1
    fixJobPut(15, 9, FIX_LINE_WRITE, 13, data + 13);   // Line 2
    fixJobPut(15, 10, FIX_LINE_WRITE, 13, data + 26);  // Line 3
}

// Clear debug area (DATdemo style)
void clearDebugArea() {
    fixJobPut(0, 25, FIX_LINE_WRITE, 0, _fixBlankLine);
    fixJobPut(0, 26, FIX_LINE_WRITE, 0, _fixBlankLine);
    fixJobPut(0, 27, FIX_LINE_WRITE, 0, _fixBlankLine);
    fixJobPut(0, 28, FIX_LINE_WRITE, 0, _fixBlankLine);
}
```

### Example 3: Manual Tilemap Creation

```c
// Create a custom status bar using manual tilemap
void createStatusBar() {
    ushort statusTilemap[40];  // One line tilemap
    ushort i;

    // Fill with border characters
    for (i = 0; i < 40; i++) {
        if (i == 0 || i == 39) {
            statusTilemap[i] = FIX_TILE_FULL(3, 3, 0x7C);  // Border character '|'
        } else {
            statusTilemap[i] = FIX_TILE_FULL(3, 3, 0x2D);  // Fill character '-'
        }
    }

    // Write the tilemap to fix layer line 15
    for (i = 0; i < 40; i++) {
        fixJobPut(i, 15, FIX_LINE_WRITE, 0, &statusTilemap[i]);
    }
}

// Create a health bar using tilemap
void createHealthBar(int health, int maxHealth) {
    ushort healthTilemap[20];  // 20 character health bar
    ushort fillChars = (health * 18) / maxHealth;  // 18 fill characters max
    ushort i;

    // Start bracket
    healthTilemap[0] = FIX_TILE_FULL(2, 3, 0x5B);  // '['

    // Fill characters
    for (i = 1; i <= 18; i++) {
        if (i <= fillChars) {
            healthTilemap[i] = FIX_TILE_FULL(1, 3, 0x7C);  // Full bar '|'
        } else {
            healthTilemap[i] = FIX_TILE_FULL(0, 3, 0x20);  // Empty space
        }
    }

    // End bracket
    healthTilemap[19] = FIX_TILE_FULL(2, 3, 0x5D);  // ']'

    // Display at position (10, 5)
    for (i = 0; i < 20; i++) {
        fixJobPut(10 + i, 5, FIX_LINE_WRITE, 0, &healthTilemap[i]);
    }
}
```

### Example 3: Control Instructions

```c
void showControls() {
    clearFixLayer();

    // Display control instructions using bank 3 (custom font)
    // Special characters \x12\x13\x10\x11 represent arrow symbols
    fixPrint(2, 3, 4, 3, "1P \x12\x13\x10\x11: move");
    fixPrint(2, 4, 4, 3, "1P A+\x12\x13\x10\x11: flip mode");
    fixPrint(2, 5, 4, 3, "1P B/C/D: actions");

    // Use different bank for emphasis
    fixPrint(2, 7, 6, 5, "Press START to begin");
}
```

### Example 3: Multi-Bank Display

```c
void displayGameScreen() {
    clearFixLayer();

    // Title using logo bank (bank 5)
    fixPrint(15, 1, 7, 5, "LOGO");

    // UI elements using custom font (bank 3)
    fixPrint(1, 3, 2, 3, "HP:");
    fixPrint(1, 4, 2, 3, "MP:");

    // Status bars using bank 3 graphics
    fixPrint(4, 3, 1, 3, "||||||||    "); // HP bar
    fixPrint(4, 4, 3, 3, "||||||      "); // MP bar

    // Debug text using system font (bank 0)
    fixPrint(1, 30, 1, 0, "Debug: ON");
}
```

### Example 3: Debug Information Display

```c
void displayDebugInfo(aSprite *sprite) {
    if (debugMode) {
        // Clear previous debug info
        fixJobPut(0, 25, FIX_LINE_WRITE, 0, _fixBlankLine);
        fixJobPut(0, 26, FIX_LINE_WRITE, 0, _fixBlankLine);
        fixJobPut(0, 27, FIX_LINE_WRITE, 0, _fixBlankLine);
        fixJobPut(0, 28, FIX_LINE_WRITE, 0, _fixBlankLine);

        // Display sprite debug information
        fixPrintf1(3, 25, 2, 3, "Anim: A:%02d S:%02d R:%02d",
                   sprite->currentAnim, sprite->stepNum, sprite->repeats);
        fixPrintf1(3, 26, 2, 3, "Frame: 0x%06x",
                   sprite->currentFrame);
        fixPrintf1(3, 27, 2, 3, "Pos: X:%03d Y:%03d",
                   sprite->posX, sprite->posY);
    }
}
```

### Example 4: Dynamic Text Updates

```c
void updateGameStatus() {
    // Update timer (assuming it's at position 30, 2)
    fixPrintf1(30, 2, 1, 3, "%02d:%02d", minutes, seconds);

    // Update score (position 25, 4)
    fixPrintf1(25, 4, 1, 3, "%07d", currentScore);

    // Update level indicator (position 2, 29)
    fixPrintf1(2, 29, 3, 3, "LEVEL %d", currentLevel);
}
```

## Best Practices

### Performance Considerations

1. **Use appropriate functions for timing:**
   - Use `fixPrint3()` or `fixPrintf3()` for vblank-synchronized updates
   - Use IRQ-safe versions (`fixPrint2()`, `fixPrintf2()`) in interrupt handlers
   - Use immediate versions (`fixPrint()`, `fixPrintf1()`) for debug or one-time displays

2. **Minimize text updates:**
   - Only update text that has actually changed
   - Cache previous values to avoid unnecessary redraws
   - Use the fix jobs buffer for batch operations

3. **Character bank management:**
   - Organize your character data into logical banks
   - Use consistent palette assignments across your game
   - Bank 0 is typically reserved for system font
   - Banks 3-5 are commonly used for custom graphics
   - Plan your bank usage in advance to avoid conflicts

4. **Manual tilemap considerations:**
   - Pre-calculate tilemap data when possible to avoid runtime computation
   - Use helper macros for consistent tilemap format
   - Cache tilemap data for frequently used elements (borders, bars, etc.)
   - Consider memory usage - full screen tilemap = 40×32×2 = 2560 bytes

### Memory Management

1. **Palette setup:**
   ```c
   // Set up fix layer palettes
   static const ushort fixPalettes[] = {
       0x8000, 0xefb8, 0x0222, 0x5fa7, // Palette 0
       0x8000, 0xebea, 0x0041, 0xa9d8, // Palette 1
       // ... more palettes
   };

   // Load palettes
   palJobPut(16, 8, fixPalettes); // Load 8 palettes starting at palette 16
   ```

2. **Character data organization:**
   - Ensure character 0x0ff is transparent for proper clearing
   - Organize character banks logically (fonts, symbols, UI elements)
   - Import system font in bank 0 for compatibility
   - Use dedicated banks for different graphic types

3. **Generated file integration:**
   ```c
   #include "out/fixData.h"  // Contains character definitions

   // Access generated constants
   extern ushort _fixBlankLine[];  // For clearing operations
   // Bank-specific character references are auto-generated
   ```

### Coordinate System

- **X coordinates**: 0-39 (left to right)
- **Y coordinates**: 0-31 (top to bottom)
- **Screen boundaries**: Always validate coordinates to prevent display corruption

### Common Pitfalls

1. **Coordinate overflow**: Ensure X < 40 and Y < 32
2. **Palette conflicts**: Avoid using palettes already assigned to sprites
3. **IRQ safety**: Use appropriate function versions based on calling context
4. **Character bank conflicts**: Ensure your character data doesn't conflict with system fonts
5. **Manual tilemap errors**:
   - **Bit field confusion**: Remember tilemap format is PPPPBBBBCCCCCCCC
   - **Palette overflow**: Palette values must be 0-15 (4 bits)
   - **Bank overflow**: Bank values must be 0-15 (4 bits)
   - **Character overflow**: Character values must be 0-255 (8 bits)
   - **Memory allocation**: Ensure tilemap arrays are properly sized
   - **Coordinate validation**: Always check bounds when writing tilemaps

### Manual Tilemap Best Practices

1. **Use helper macros**: Always use `FIX_TILE_FULL()` macro for consistency
2. **Validate input**: Check all parameters before creating tilemap entries
3. **Pre-compute**: Calculate complex tilemaps once, store in arrays
4. **Memory efficiency**: Use local arrays for small tilemaps, static for large ones
5. **Error checking**: Validate tilemap data before writing to VRAM

```c
// Safe tilemap creation with validation
ushort createSafeTile(ushort palette, ushort bank, ushort character) {
    // Validate parameters
    if (palette > 15) palette = 15;
    if (bank > 15) bank = 15;
    if (character > 255) character = 255;

    return FIX_TILE_FULL(palette, bank, character);
}
```

## Integration with Game Loop

```c
void gameMainLoop() {
    // Initialize fix layer
    clearFixLayer();
    setupFixPalettes();

    while (gameRunning) {
        // Handle input
        handleInput();

        // Update game logic
        updateGameState();

        // Update fix layer (use vblank-synced versions)
        updateHUD();
        updateDebugInfo();

        // Wait for vblank before next frame
        waitVBlank();
    }
}
```

## Conclusion

The fix layer is an essential component for creating professional-looking Neo Geo games. By understanding its characteristics and using the appropriate functions for different scenarios, you can create responsive, efficient user interfaces that enhance the player experience.

Key takeaways:
- Choose the right function for your timing requirements
- Use vblank-synchronized operations when possible
- Keep coordinate bounds in mind
- Organize your character data and palettes effectively
- Update only what has changed for optimal performance