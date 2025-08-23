# Sound Effects Sample

## Description

Demonstrates ADPCM sound playback and audio system management in NeoCore.

## Features Demonstrated

- **ADPCM Sound Playback**: Playing compressed audio samples
- **Sound State Management**: Monitoring audio player state
- **Frame-based Audio Timing**: Precise audio timing control
- **Interactive Sound Triggers**: Joypad-triggered sound effects

## Key Functions Used

- `nc_get_adpcm_player()` - Get audio player state information
- `nc_stop_adpcm()` - Stop current audio playback
- `send_sound_command()` - Send sound command to audio system
- `nc_push_remaining_frame_adpcm_player()` - Set audio duration
- `nc_second_to_frame()` - Convert seconds to frame count

## Controls

- **Joypad Inputs**: Trigger sound effects (edge mode enabled)
- **Interactive**: Various inputs trigger different audio responses

## What You'll See

- Audio player state information:
  - "ADPCM SAMPLE IS READY" - When audio system is idle
  - "ADPCM SAMPLE IS PLAYING" - During audio playback
- Remaining frame counter showing audio playback progress
- Real-time audio state monitoring

## Audio System Details

- **State Management**: Audio player has IDLE and PLAYING states
- **Collision Handling**: New sounds only play when previous sound is idle
- **Duration Control**: Sounds are set to play for specific frame durations (1 second)
- **Sample Used**: `ADPCM_MIXKIT_GAME_CLICK_1114` - Game click sound effect

## Technical Details

- Uses edge mode for joypad input to prevent sound spamming
- Audio timing controlled by frame count for precision
- State checking prevents audio overlap and clipping
- Frame-based duration allows precise audio control

## Learning Objectives

This sample teaches:
- How to integrate audio into NeoCore applications
- Managing audio player state and timing
- Using frame-based audio duration control
- Implementing interactive sound effects
- Understanding ADPCM audio system on Neo Geo hardware
