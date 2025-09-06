# Palette Backdrop Sample

## Description

This sample demonstrates how to manipulate the backdrop (background) color of the Neo Geo palette system. It shows a dynamic color transition effect by continuously modifying the backdrop color's blue component.

## Features Demonstrated

- **Backdrop Color Control**: Setting and modifying the backdrop color using RGB values
- **Real-time Color Animation**: Continuously changing color values to create visual effects
- **RGB16 Color Format**: Using the NeoCore RGB16 structure for color representation

## Key Functions Used

- `nc_set_palette_backdrop_by_rgb16()` - Sets the backdrop color using RGB16 format
- `nc_update()` - Main update loop

## What You'll See

- A screen with a backdrop that continuously changes color
- The blue component of the backdrop gradually decreases, creating a color transition effect
- The effect demonstrates real-time palette manipulation capabilities

## Learning Objectives

- Understanding Neo Geo backdrop color control
- Learning how to create animated color effects
- Working with RGB16 color format in NeoCore
- Implementing simple animation loops

## Technical Details

The sample uses a static RGB16 structure initialized with `{0x0, 0x0, 0x0, 0xF}` and continuously decrements the blue component to create a smooth color transition effect.
