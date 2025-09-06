# Polyphonic Sound Effects Sample

## Description

This sample demonstrates polyphonic sound effect playback capabilities, allowing multiple ADPCM sound effects to be played simultaneously. It provides an interactive interface for testing different sound combinations and understanding the Neo Geo's audio capabilities.

## Features Demonstrated

- **Polyphonic Audio Playback**: Playing multiple sound effects simultaneously
- **ADPCM Sound Effects**: Using compressed audio samples
- **Interactive Sound Control**: Joypad-controlled sound triggering
- **Sound Command System**: Direct sound command sending
- **Audio Resource Management**: Proper sound effect organization

## Key Functions Used

- `send_sound_command()` - Sends ADPCM sound commands to the audio system
- `nc_stop_adpcm()` - Stops all currently playing ADPCM sounds
- `nc_set_joypad_edge_mode()` - Enables edge-triggered joypad input
- `nc_joypad_is_*()` - Detects joypad direction inputs
- `nc_debug_joypad()` - Shows joypad input status

## What You'll See

- Interactive instructions for joypad controls
- Real-time joypad input display showing button states
- Multiple sound effects that can be played individually or together
- Visual feedback showing which controls trigger which sounds

## Controls

- **LEFT**: Play Sound Effect 1
- **DOWN**: Play Sound Effect 2
- **RIGHT**: Play Sound Effect 3
- **UP**: Play all sound effects simultaneously (demonstrates polyphonic capability)

## Learning Objectives

- Understanding Neo Geo's polyphonic audio capabilities
- Learning ADPCM sound effect management
- Implementing interactive sound control systems
- Working with sound command protocols
- Managing multiple audio resources effectively

## Technical Details

- Uses external sound definition files (`sfx.h`)
- Demonstrates proper sound stopping before playing multiple effects
- Shows how to organize and trigger different ADPCM samples
- Implements edge-triggered input for precise sound control

## File Organization

- `main.c` - Main sound control logic
- `externs.h` - External asset declarations
- `assets/sounds/fx/sfx.h` - Sound effect definitions
- Various ADPCM sample files
