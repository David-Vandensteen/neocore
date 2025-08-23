# NeoCore Sprite ID Management Test

![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif)

## Description

This sample demonstrates and tests the new sprite ID management features introduced in NeoCore v3.0.0:

## Features Tested

### 1. **Automatic Sprite Allocation with Return Values**
- Tests that `nc_init_display_gfx_*` functions now return the allocated sprite index
- Background and planet use automatic allocation
- Displays the allocated sprite indices on screen

### 2. **Forced Sprite ID Allocation**
- Uses `nc_display_gfx_with_sprite_id(50)` to force the player sprite to use index 50
- Demonstrates how to override automatic allocation for specific sprites

### 3. **Sprite Index Information Functions**
- `nc_get_free_sprite_index()` - Gets the next available sprite index
- `nc_get_max_free_sprite_index()` - Counts total free sprites
- `nc_get_max_sprite_index_used()` - Counts used sprites
- Displays real-time sprite usage statistics

### 4. **Dynamic Sprite Reallocation**
- Press **START** to destroy and recreate the player sprite with a new sprite index
- Tests dynamic sprite management and cleanup

## Controls

- **Arrow Keys**: Move the player sprite
- **UP/DOWN**: Change player animation (UP/DOWN/IDLE)
- **START**: Reallocate player sprite to next free index

## On-Screen Information

The sample displays:
- Initial sprite allocation indices for each graphics object
- Real-time sprite usage statistics (updated every second)
- Dynamic reallocation information when START is pressed

## Technical Details

### Sprite Allocation Flow
1. **Background**: Automatic allocation → displays assigned index
2. **Planet**: Automatic allocation → displays assigned index
3. **Player**: Forced to index 50 → confirms forced allocation
4. **Reallocation**: Uses `nc_get_free_sprite_index()` for dynamic allocation

### Error Handling
- Checks if `nc_get_free_sprite_index()` returns `0xFFFF` (no free sprites)
- Displays appropriate message if sprite reallocation fails

This sample serves as a comprehensive test and demonstration of NeoCore's enhanced sprite management capabilities.