# NeoCore Samples Overview

This directory contains various sample applications demonstrating different aspects of the NeoCore library for Neo Geo development.

## 📚 Learning Path

### Beginner Samples
Start with these samples to learn NeoCore basics:

1. **[hello](hello/)** - Basic graphics display and logging
2. **[joypad](joypad/)** - Input handling and controls
3. **[math](math/)** - Mathematical operations and fixed-point arithmetic
4. **[sprite](sprite/)** - Basic sprite animation and movement

### Intermediate Samples
Build upon the basics with these samples:

5. **[collide](collide/)** - Basic collision detection
6. **[bullet](bullet/)** - Modular code organization and projectile systems
7. **[soundFX](soundFX/)** - Audio playback and sound effects
8. **[pal_rgb](pal_rgb/)** - Palette color reading and manipulation

### Advanced Samples
Explore advanced features:

9. **[sprite_id](sprite_id/)** - Advanced sprite management (NeoCore v3.0.0)
10. **[palette_swap](palette_swap/)** - Dynamic palette animation
11. **[collide_complex](collide_complex/)** - Advanced collision scenarios
12. **[collide_multiple](collide_multiple/)** - Multi-object collision detection
13. **[CDDA](CDDA/)** - CD audio playback (Neo Geo CD)

## 🔧 Specialized Samples

### Graphics & Visual Effects
- **[pal_backdrop](pal_backdrop/)** - Background palette effects
- **[pal_rgb_mixer](pal_rgb_mixer/)** - Color mixing techniques
- **[shrunk](shrunk/)** - Sprite scaling and size manipulation
- **[shrunk_centroid](shrunk_centroid/)** - Advanced sprite scaling

### Audio
- **[soundFX](soundFX/)** - Sound effects and ADPCM audio
- **[soundFX_poly](soundFX_poly/)** - Polyphonic sound effects
- **[CDDA](CDDA/)** - CD Digital Audio playback

### Testing & Validation
- **[test_spritemanager](test_spritemanager/)** - Sprite system validation
- **[test_palettemanager](test_palettemanager/)** - Palette system validation
- **[test_copy_palettes](test_copy_palettes/)** - Palette copying validation
- **[test_same_palette](test_same_palette/)** - Palette sharing validation
- **[test_limit](test_limit/)** - System limit testing
- **[test_invalid_dimension_sprite](test_invalid_dimension_sprite/)** - Error handling validation

### Technical Tests
- **[test_gas](test_gas/)**, **[test_gasp](test_gasp/)**, **[test_gp](test_gp/)**, **[test_gpp](test_gpp/)**, **[test_gs](test_gs/)** - Graphics system component testing
- **[test_raine_config_switch](test_raine_config_switch/)** - RAINE emulator configuration testing
- **[issue_80](issue_80/)** - Specific bug fix demonstration
- **[recurse](recurse/)** - Recursive function testing

### Data Management
- **[DATdemo](DATdemo/)** - External data file management

## 🚀 Quick Start

1. **Start with `hello`** to verify your NeoCore setup
2. **Try `joypad`** to test input handling
3. **Explore `sprite`** for basic animation
4. **Check `sprite_id`** for advanced sprite management (v3.0.0 features)

## 🔨 Building Samples

Each sample can be built using the provided Makefile:

```bash
cd samples/[sample_name]
make
```

Or use the global build scripts:
- `build-all-samples.bat` - Build all samples
- `run-all-samples.bat` - Run all samples for testing

## 📋 Sample Categories

| Category | Samples |
|----------|---------|
| **Basics** | hello, joypad, math, sprite |
| **Graphics** | palette_swap, pal_rgb, pal_backdrop, pal_rgb_mixer, shrunk, shrunk_centroid |
| **Physics** | collide, collide_complex, collide_multiple |
| **Audio** | soundFX, soundFX_poly, CDDA |
| **Advanced** | bullet, sprite_id, DATdemo |
| **Testing** | test_* samples, issue_80, recurse |

## 🆕 NeoCore v3.0.0 Features

The **[sprite_id](sprite_id/)** sample demonstrates new features in NeoCore v3.0.0:
- Conditional sprite allocation
- Function return values for sprite indices
- Enhanced sprite management functions
- Dynamic sprite reallocation

## 📖 Documentation

Each sample includes:
- **README.md** - Detailed explanation and learning objectives
- **main.c** - Source code with comments
- **Makefile** - Build configuration
- **externs.h** - External asset declarations (where applicable)

Happy coding with NeoCore! 🎮
