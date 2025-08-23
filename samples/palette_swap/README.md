# Palette Swap Sample

![](https://media.giphy.com/media/TdX0FYHgOealFSdvr2/giphy.gif)

## Description

Demonstrates dynamic palette swapping with random color generation, creating animated color effects.

## Features Demonstrated

- **Dynamic Palette Swapping**: Real-time palette modification
- **Random Color Generation**: Using random colors for palette entries
- **Palette Data Manipulation**: Direct palette data modification
- **Animated Color Effects**: Frame-based palette updates

## Key Functions Used

- `nc_init_display_gfx_picture()` - Initialize graphics with palette
- `nc_random()` - Generate random color values
- `nc_bitwise_multiplication_16()` - Fast multiplication by 16 (bit shifting)
- `palJobPut()` - Update palette data in hardware
- `nc_get_frame_counter()` - Get current frame for timing

## Technical Details

### Palette Structure
- **Palette Count**: Copies count from original sprite palette
- **Color Data**: Array of color values (16 colors per palette)
- **Base Palette**: References sprite's base palette for updates

### Animation Timing
- **Update Rate**: Palette changes every 8 frames
- **Frame Check**: `nc_get_frame_counter() % 8 == 0`
- **Continuous Loop**: Creates ongoing animated color effects

### Color Generation
- **Random Colors**: Each palette entry gets random RGB16 value
- **Reserved Entry**: `data[1] = 0x0000` - keeps one entry black (transparency?)
- **Full Range**: Random values use full 16-bit color range (0x0000 to 0xFFFF)

## What You'll See

- Logo sprite displayed at position (50, 100)
- Colors changing every 8 frames (~0.13 seconds at 60 FPS)
- Animated rainbow/disco effect on the sprite
- Continuous color cycling creating dynamic visual effects

## Learning Objectives

This sample teaches:
- How to manipulate palette data dynamically
- Understanding palette structure and organization
- Creating animated color effects without changing graphics
- Using frame timing for animation control
- Working with Neo Geo's palette hardware system

## Creative Applications

This technique can be used for:
- Damage flash effects (red tinting)
- Power-up visual feedback
- Environmental lighting changes
- Special effects and transitions
- Creative visual animations without additional sprites