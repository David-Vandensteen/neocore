# Custom Fix Layer Sample

## Overview

This sample demonstrates the new **fix layer palette management system** introduced in Neocore 3.1.0. It showcases how to load custom palettes, manage fix layer fonts, and properly clean up palette resources.

## Learning Objectives

- **Palette Management**: Learn to load and unload custom palettes for the fix layer
- **Font Banking**: Understand how to switch between different font banks
- **Resource Cleanup**: Proper palette resource management and cleanup
- **Fix Layer API**: Master the new `nc_fix_*` functions for fix layer control

## Key Features Demonstrated

### 1. Custom Palette Loading
```c
font0_palette_index = nc_fix_load_palette_info(&font0_Palettes);
```
- Automatically allocates palette index from fix layer range (2-16)
- System palettes (0-1) remain protected and reserved

### 2. Font Bank Management
```c
nc_fix_set_bank(3);                    // Custom font bank
nc_fix_set_palette_id(palette_index);  // Custom palette
```
- Switch between system font (bank 0) and custom fonts
- Apply different color palettes to text rendering

### 3. Resource Cleanup
```c
nc_fix_unload_palette_info(&font0_Palettes);
```
- Properly free allocated palette resources
- Returns palette slots to available pool

## API Functions Used

| Function | Purpose |
|----------|---------|
| `nc_fix_load_palette_info()` | Load palette and get allocated index |
| `nc_fix_set_bank()` | Set font bank for text rendering |
| `nc_fix_set_palette_id()` | Set palette for text colors |
| `nc_fix_unload_palette_info()` | Free palette resources |
| `nc_log_info_line()` | Display formatted text with line break |

## Palette Management System

### Reserved Ranges
- **System Reserved (0-1)**: Cannot be allocated or modified
- **Fix Layer (2-16)**: Available for custom fix layer palettes
- **Sprites (17-255)**: Reserved for sprite palette allocation

### Type-Safe Allocation
The palette manager ensures type-safe allocation:
- Fix layer functions only allocate from indices 2-16
- Automatic resource tracking and cleanup
- Protection against system palette corruption

## Expected Output

The sample displays text using different font banks and palettes:

1. **System font** with default palette (white text)
2. **Custom font** with custom palette (colored text)
3. **Mixed rendering** demonstrating palette switching
4. **Formatted output** showing palette index and game data

---

This sample serves as a practical introduction to the enhanced fix layer capabilities in Neocore 3.1.0, emphasizing proper resource management and the new type-safe palette allocation system.