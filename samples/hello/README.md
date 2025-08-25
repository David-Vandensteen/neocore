# Hello World Sample

## Description

Basic "Hello World" sample demonstrating fundamental NeoCore functionality including graphics display and logging system.

## Features Demonstrated

- **Graphics Display**: Display of Neo Geo logo using `nc_init_display_gfx_picture()`
- **Logging System**: Various logging functions and formatting options
- **Frame Counter**: Display of frame counter for timing reference

## Key Functions Used

- `nc_init_display_gfx_picture()` - Display static graphics
- `nc_log_info_line()` - Log text with automatic newline
- `nc_log_info()` - Log text without newline
- `nc_log_int()` / `nc_log_short()` - Log numeric values
- `nc_get_frame_counter()` - Get current frame count

## What You'll See

- Neo Geo logo displayed on screen
- Console output showing:
  - "HELLO NEO GEO !!!" message
  - Current frame counter
  - Examples of integer and short value logging
  - Decimal and hexadecimal number formatting

## Learning Objectives

This sample teaches:
- Basic NeoCore application structure
- How to display static graphics
- Using the logging system for debugging and information display
- Frame counter usage for timing operations
