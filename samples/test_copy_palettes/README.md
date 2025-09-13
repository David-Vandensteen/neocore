# Test Copy Palettes Sample

## Description

This sample tests the palette copying functionality in NeoCore, specifically validating the ability to duplicate palette data from one memory location to another. It demonstrates proper palette memory management and data copying techniques.

## Features Demonstrated

- **Palette Data Copying**: Safe copying of palette arrays
- **Memory Management**: Proper handling of palette memory structures
- **Data Validation**: Testing palette copying integrity
- **Array Operations**: Low-level array copying functions

## Key Functions Used

- `copy_word_array()` - Custom function for copying WORD arrays
- Palette structure access and manipulation
- Memory copying validation functions

## What You'll See

- Testing interface for palette copying operations
- Visual confirmation of successful palette duplication
- Memory integrity validation results
- Comparative display of original vs copied palettes

## Learning Objectives

- Understanding palette memory structure in Neo Geo
- Learning safe palette copying techniques
- Implementing custom memory copying functions
- Validating data integrity in memory operations
- Working with WORD arrays and palette data structures

## Technical Details

- Uses a static `duplicated_palette[16]` array to store copied data
- Implements custom `copy_word_array()` function for safe copying
- Tests copying of 16-word palette structures
- Validates proper memory allocation and data integrity

## Use Cases

This test is essential for developers who need to:
- Dynamically manipulate palette data
- Create palette backup systems
- Implement palette animation effects
- Validate memory copying operations
