# Shrunk (Sprite Scaling) Sample

## Description

This sample demonstrates the Neo Geo's sprite scaling capabilities, showing three different types of shrinking effects: horizontal, vertical, and proportional scaling. It provides a comprehensive example of how to manipulate sprite dimensions in real-time.

## Features Demonstrated

- **Horizontal Sprite Shrinking**: Scaling sprites along the X-axis
- **Vertical Sprite Shrinking**: Scaling sprites along the Y-axis
- **Proportional Sprite Shrinking**: Scaling sprites uniformly
- **Real-time Animation**: Dynamic scaling effects with frame-based timing
- **Sprite Management**: Handling multiple scaled sprite instances

## Key Functions Used

- `nc_init_display_gfx_picture()` - Initializes sprite graphics
- `nc_gpu_shrunk_centroid_gfx_picture()` - Applies scaling effects to sprites
- `nc_get_frame_counter()` - Gets current frame count for animation timing
- `nc_log_info()` - Displays descriptive text

## What You'll See

- Three sprite instances demonstrating different scaling effects:
  - **Top sprite**: Horizontal shrinking animation (gets narrower over time)
  - **Middle sprite**: Vertical shrinking animation (gets shorter over time)
  - **Bottom sprite**: Proportional shrinking (gets smaller uniformly)
- Text labels describing each scaling type
- Smooth animation effects with different timing patterns

## Learning Objectives

- Understanding Neo Geo hardware scaling capabilities
- Learning different types of sprite scaling (horizontal, vertical, proportional)
- Implementing frame-based animation timing
- Working with multiple sprite instances
- Using NeoCore's scaling functions effectively

## Technical Details

- Uses `nc_gpu_shrunk_centroid_gfx_picture()` to apply scaling with different X and Y values
- Implements different animation speeds for varied visual effects
- Demonstrates the relationship between frame counters and animation timing
- Shows how to manage multiple scaled sprites simultaneously
