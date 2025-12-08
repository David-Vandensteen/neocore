# RGB Palette Sample

## Description

Demonstrates real-time palette color reading and display, showcasing NeoCore's palette manipulation capabilities.

## Features Demonstrated

- **Palette Reading**: Reading RGB values from specific palette entries
- **Real-time Display**: Live color information display
- **RGB Color Format**: Working with RGB16 color format
- **Palette Indexing**: Iterating through palette entries

## Key Functions Used

- `nc_read_palette_rgb16()` - Read RGB color from palette entry
- `nc_init_display_gfx_picture()` - Display graphics with palette
- `nc_joypad_set_edge_mode()` - Enable edge detection for input

## Technical Details

### Palette System
- **Palette Number**: Uses palette 17 for demonstration
- **Color Entries**: Reads all 16 color entries (indices 0-15)
- **RGB16 Format**: Neo Geo's 16-bit RGB color format
- **Real-time Reading**: Continuously reads and displays color values

### Color Information Display
- Shows RGB values for each palette entry
- Updates continuously to reflect any palette changes
- Displays color information in real-time

## What You'll See

- Playfield graphics displayed using specified palette
- Console output showing RGB values for each palette entry:
  - Palette index (0-15)
  - RGB color values in RGB16 format
- Live updates of color information

## Learning Objectives

This sample teaches:
- How to read palette color information
- Understanding Neo Geo's RGB16 color format
- Working with palette indices and color entries
- Real-time palette monitoring and debugging
- Palette system integration with graphics display

## Use Cases

This sample is useful for:
- Debugging palette issues
- Understanding color values in your graphics
- Learning the Neo Geo palette system
- Creating palette editing tools
- Color analysis and optimization
