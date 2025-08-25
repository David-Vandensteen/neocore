# CD Audio (CDDA) Sample

## Description

Demonstrates CD Digital Audio playback functionality with interactive controls and visual feedback.

## Features Demonstrated

- **CD Audio Playback**: Playing CD audio tracks
- **Track Control**: Track selection and navigation
- **Playback Control**: Play, pause, and stop functionality
- **Visual Elements**: Animated graphics synchronized with audio

## Key Functions Used

- `nc_play_cdda()` - Play CD audio track
- `nc_init_gfx_scroller()` - Create scrolling background
- `nc_init_gfx_picture()` - Display static graphics
- `nc_set_joypad_edge_mode()` - Enable edge detection for controls

## Controls

- **Track Navigation**: Change between audio tracks
- **Playback Control**: Play/pause/stop audio
- **Interactive Interface**: Joypad controls for audio functions

## What You'll See

- Cassette tape (k7) graphics representing the audio player
- Animated spectrum/visualization graphics
- Visual feedback for audio playback state
- Track information and controls

## Technical Details

### Audio System
- **Track Management**: Starts with track 2 (`track_num = 2`)
- **Pause State**: Boolean flag for pause/play state management
- **Direction Control**: `k7_direction` for tape direction simulation

### Visual Elements
- **K7 Graphics**: Cassette tape visual representation
- **Spectrum Display**: Scrolling spectrum visualization
- **Synchronized Animation**: Graphics that respond to audio state

## Learning Objectives

This sample teaches:
- How to integrate CD audio into NeoCore applications
- Managing audio playback state and controls
- Creating audio-visual synchronization
- Building interactive media player interfaces
- Understanding Neo Geo CD audio capabilities

## Requirements

This sample requires:
- Neo Geo CD system or compatible emulator
- Audio CD with multiple tracks
- Proper CD audio initialization in the system
