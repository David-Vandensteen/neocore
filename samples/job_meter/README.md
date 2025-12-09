# Job Meter Sample

## Description

This sample demonstrates the use of DATlib's job meter feature for real-time CPU profiling and performance analysis. It provides an interactive interface to adjust artificial CPU loads for different game loop sections, allowing developers to visualize and understand CPU time distribution across rendering, input handling, and game logic.

![Job Meter Screenshot](../../docs/images/samples/job_meter/job_meter.png)

## Features Demonstrated

- **Job Meter Visualization**: Visual CPU profiling with color-coded sections
- **Real-time CPU Load Adjustment**: Interactive controls to modify processing overhead
- **Performance Profiling**: Understanding frame time distribution
- **VBlank Simulation**: Artificial VBlank processing overhead
- **Menu System**: Real-time parameter adjustment interface
- **Multi-section CPU Tracking**: Separate profiling for input, scrolling, and animation

## Key Functions Used

- `jobMeterSetup()` - Initializes the job meter display (should be called after sprite initialization, not as first call)
- `jobMeterColor()` - Sets current job meter color for profiling sections
- `nc_gpu_update()` - Triggers VBlank and frame synchronization
- `nc_joypad_set_edge_mode()` - Enables edge-triggered input
- `nc_gfx_init_and_display_scroller()` - Background scrolling setup
- `nc_gfx_init_and_display_animated_sprite()` - Animated sprite initialization
- `nc_log_set_position()` / `nc_log_info()` - Menu display functions

## What You'll See

- A vertical job meter bar on the right side of the screen showing CPU usage by color:
  - **CYAN**: Input handling time
  - **YELLOW**: Background scrolling time
  - **BLUE**: Animation processing time
  - **GREEN**: Free CPU time (idle)
  - **RED**: VBlank updates (buffer processing)
  - **ORANGE**: VBlank post-processing (SYSTEM_IO)
  
- An interactive menu displaying adjustable cycle counts for each section
- A scrolling background and animated sprite
- Real-time visual feedback as you adjust CPU loads

## Controls

- **UP/DOWN**: Navigate through menu options
- **LEFT/RIGHT**: Decrease/Increase CPU cycle overhead (+/-100 cycles)
- Observe the job meter bar changing as you adjust values

## Learning Objectives

- Understanding CPU time distribution in game loops
- Identifying performance bottlenecks through visual profiling
- Learning optimal frame time management
- Understanding VBlank processing overhead
- Implementing debug profiling tools in your projects

## Technical Details

The job meter uses color changes to visually represent which part of the code is currently executing. By calling `jobMeterColor()` before each major section, developers can see exactly how much frame time each operation consumes. The sample includes artificial CPU burn cycles (via `burn_cpu()`) to simulate various processing loads, making the profiling effects clearly visible.

This technique is invaluable for:
- Optimizing game performance
- Identifying frame drops
- Balancing workload distribution
- Understanding VBlank constraints
- Debug builds only (color changes cause visible artifacts on real hardware)

## Important Notes

⚠️ **Debug Use Only**: Job meter should only be enabled in debug builds. On real hardware, changing colors during active display creates visible pixel artifacts on screen. Remove job meter calls in release builds.

⚠️ **Initialization Order**: `jobMeterSetup()` must not be the first function called. It is recommended to call it after initializing your sprites and graphics elements. In this sample, it's called after all `nc_gfx_init_and_display_*()` functions.

The sample requires DATlib and demonstrates advanced profiling techniques specific to Neo Geo hardware constraints.
