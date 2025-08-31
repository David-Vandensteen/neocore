# Known Issues

## NeoCore 3.0.0-rc1 Issues

### Sprite Residual Artifacts When Using nc_shrunk() with Reused Sprite IDs

**Status**: 🟡 Bug - Sprite Cleanup Issue
**Severity**: Medium
**Affected Version**: NeoCore 3.0.0-rc1
**Date Reported**: August 31, 2025
**GitHub Issue**: [#167](https://github.com/David-Vandensteen/neocore/issues/167)

#### Problem Description

When transitioning between scenes that reuse the same sprite ID and applying `nc_shrunk()` to sprites, residual sprite artifacts from the previous scene remain visible on screen. The sprite cleanup mechanism does not properly clear shrunk sprites when sprite IDs are reused across scene transitions.

#### Symptoms

- Sprite artifacts from previous scene visible in new scene
- Only occurs when `nc_shrunk()` is applied to sprites
- Problem does not occur without shrunk operations
- Affects sprite ID reuse between scenes (e.g., menu → game transition)
- Normal sprite rendering works correctly without shrunk

#### Visual Evidence

- **Menu Scene**: `docs/images/issues/167/menu.png` - Shows original menu scene
- **Without Shrunk**: `docs/images/issues/167/unless_shrunk.png` - Clean transition, no residual sprites
- **With Shrunk**: `docs/images/issues/167/with_shrunk.png` - Shows residual sprite artifacts from previous scene

#### Expected Behavior

When transitioning between scenes with sprite ID reuse, all previous sprite data should be completely cleared regardless of shrunk operations. The new scene should display only the current sprites without any residual artifacts.

#### Actual Behavior

When `nc_shrunk()` is used on sprites and sprite IDs are reused in a new scene, remnants of the previous scene's sprites remain visible, causing visual artifacts and incorrect display.

#### Code Pattern That Triggers the Issue

```c
// Scene 1 (Menu)
menu_sprite_id = nc_init_display_gfx_picture(/*...*/);

// Scene transition
nc_reset();

// Scene 2 (Game) - reuses same sprite ID
player_sprite_id = nc_init_display_gfx_animated_sprite_physic(/*...*/);
nc_shrunk(player_sprite_id, width, shrunk_value); // Triggers residual artifacts
```

#### Root Cause Analysis

The issue appears to be related to incomplete sprite cleanup in the shrunk system:
- `nc_shrunk()` may modify sprite hardware registers that are not properly reset during scene transitions
- Sprite index manager may be reusing IDs without fully clearing shrunk-related hardware state
- The shrunk table or VRAM shrunk addresses may retain data from previous sprites

#### Immediate Impact

- **Visual Quality**: Unwanted sprite artifacts in new scenes
- **Scene Transitions**: Inconsistent visual behavior between shrunk and non-shrunk sprites
- **Sprite ID Reuse**: Limits ability to efficiently reuse sprite indices
- **User Experience**: Visual glitches that affect game presentation

#### Workaround

Avoid using `nc_shrunk()` on sprites that will have their IDs reused in subsequent scenes, or ensure unique sprite IDs are used across scene transitions.

#### Priority

**🟡 MEDIUM** - Affects visual quality but has workarounds. Should be fixed for proper sprite management.

#### Root Cause Analysis

After extensive debugging, the issue appears to be related to hardware-level persistence of shrunk register values:
- `nc_shrunk()` modifies sprite hardware registers that persist between scene transitions
- The Neo Geo hardware maintains shrunk values even after `nc_clear_display()` and `nc_reset()`
- Standard clearing methods (`SC234Put(VRAM_SHRINK_ADDR(i), 0xFFF)` and `nc_shrunk_range()`) do not fully reset the hardware state
- The problem occurs specifically when sprite IDs are reused between scenes with different shrunk requirements

#### Technical Investigation Summary

**Debugging Process Conducted:**

1. **Initial Issue Confirmation**
   - ✅ Confirmed artifacts appear only when `nc_shrunk()` is used
   - ✅ Verified problem does not occur without shrunk operations
   - ✅ Isolated issue to sprite ID reuse between scenes (menu → game transition)

2. **Sprite Index Manager Analysis**
   - 🔧 Fixed bug in `init_sprite_manager_index()` where sprite 0 reservation was overwritten
   - 🔧 Corrected `use_sprite_manager_index()` to return `SPRITE_INDEX_NOT_FOUND` instead of 0
   - 🔧 Added error handling in display functions for failed sprite allocations
   - ✅ Confirmed sprite allocation works correctly after fixes

3. **Shrunk Register Clearing Attempts**
   - ❌ **Single clear**: `SC234Put(VRAM_SHRINK_ADDR(i), 0xFFF)` - Insufficient
   - ❌ **Double clear**: Multiple writes to same address - No improvement
   - ❌ **Triple clear**: Added extra safety writes - Still artifacts present
   - ❌ **VBlank delays**: Added `waitVBlank()` between operations - Caused display issues
   - ❌ **IRQ disable**: Protected clear operations - No change

4. **Address Method Investigation**
   - 🔍 **Discovery**: `VRAM_SHRINK_ADDR(i)` vs `0x8000 + i` addressing inconsistency
   - 🔧 **Test**: Modified `nc_clear_display()` to use `0x8000 + i` method
   - ❌ **Result**: Artifacts persisted with both addressing methods

5. **Timing and Sequence Testing**
   - ❌ **Pre-clear in nc_shrunk()**: Clear before applying new value - Display issues
   - ❌ **Post-clear in nc_reset()**: Additional delays after reset - Display failures
   - ❌ **Allocation-time clear**: Clear during sprite index allocation - No improvement

6. **Hardware Register Scope Testing**
   - ❌ **SCB2 (X position) clear**: `SC234Put(VRAM_POSX_ADDR(i), 0x0000)` - Display problems
   - ❌ **SCB3 (Y position) clear**: `SC234Put(0x8200 + i, 0x01F0)` - Display failures
   - ✅ **SCB4 (Shrunk) only**: Confirmed as the problematic register

7. **Shrunk Application Method Analysis**
   - ✅ **No shrunk**: Complete elimination of `nc_shrunk()` - Artifacts disappear
   - ❌ **Direct application**: Original simple method - Artifacts present
   - ❌ **Range-based clear**: Using `nc_shrunk_range()` for clearing - No improvement

8. **Alternative Approaches Tested**
   - ✅ **Sprite ID offset**: Avoiding reuse by using different ID ranges - Works but limiting
   - ❌ **Delayed application**: Wait frames before shrunk - Still artifacts
   - ❌ **Complete sprite clear**: `nc_clear_sprite_completely()` function - No change

**Technical Findings:**

- **Hardware Persistence**: Neo Geo shrunk registers exhibit persistence behavior not documented
- **Clearing Ineffectiveness**: Standard DATlib clearing methods insufficient for shrunk data
- **Address Independence**: Both `VRAM_SHRINK_ADDR()` and direct `0x8000+` addressing fail
- **Timing Independence**: VBlank synchronization does not resolve the issue
- **Scope Limitation**: Only SCB4 (shrunk) registers are problematic; other registers clear properly

**Confirmed Non-Solutions:**
- Multiple register writes (double/triple clearing)
- VBlank timing synchronization
- IRQ-protected operations
- Alternative addressing methods
- Pre-clearing before shrunk application
- Comprehensive sprite register clearing

#### Workaround Solutions

**Option A: Avoid Sprite ID Reuse with Shrunk**
```c
// Use different sprite ID ranges for different scenes
// Menu: sprites 0-49, Game: sprites 50-99, etc.
```

**Option B: Delay Shrunk Application**
```c
// Apply shrunk several frames after sprite initialization
player_sprite_id = nc_init_display_gfx_animated_sprite_physic(...);
for (int i = 0; i < 5; i++) { nc_update(); } // Wait 5 frames
nc_shrunk(player_sprite_id, ...); // Apply after delay
```

**Option C: Use Non-Shrunk Alternatives**
```c
// Use scaled sprite graphics instead of hardware shrunk when possible
```

#### Related Functions

- `nc_shrunk(WORD base_sprite, WORD max_width, WORD value)`
- `nc_reset()`
- `nc_clear_display()`
- `nc_init_display_gfx_picture()`
- `nc_init_display_gfx_animated_sprite_physic()`
- Sprite index management system

#### Environment Details

- **Platform**: Neo Geo hardware
- **Sprite System**: NeoCore sprite index manager
- **Scene Transition**: Menu to game transition
- **Shrunk Values**: Various shrunk proportional table values

---

### nc_set_position_log(0, 0) Displays Off-Screen

**Status**: 🟡 Bug - Off-Screen Display
**Severity**: Medium
**Affected Version**: NeoCore 3.0.0-rc1
**Date Reported**: August 31, 2025
**GitHub Issue**: [#166](https://github.com/David-Vandensteen/neocore/issues/166)

#### Problem Description

The `nc_set_position_log(0, 0)` function call does not display text at the expected screen position. Instead, the text appears to be rendered off-screen, making it invisible to the user. The function likely has an off-by-one error in coordinate handling, where coordinates should be 1-based instead of 0-based.

#### Symptoms

- `nc_set_position_log(0, 0)` followed by `nc_log_info()` displays nothing visible on screen
- `nc_set_position_log(1, 1)` works correctly and displays text at the top-left corner
- Suggests coordinate system is 1-based rather than 0-based
- No compilation errors or runtime crashes

#### Expected Behavior

`nc_set_position_log(0, 0)` should position the log cursor at the top-left corner of the screen, similar to how `nc_set_position_log(1, 1)` currently behaves.

#### Actual Behavior

Text logged after `nc_set_position_log(0, 0)` is not visible on screen, indicating the text is being rendered at an off-screen location.

#### Code Example

```c
// This displays off-screen (invisible)
nc_set_position_log(0, 0);
nc_log_info("This text is invisible");

// This displays correctly at top-left corner
nc_set_position_log(1, 1);
nc_log_info("This text is visible");
```

#### Root Cause Analysis

The issue appears to be a coordinate system inconsistency where:
- The logging system expects 1-based coordinates (1,1 = top-left)
- But the API suggests 0-based coordinates (0,0 = top-left)
- This likely affects the underlying DATlib `fixPrint`/`fixPrintf` coordinate handling

#### Immediate Impact

- **API Consistency**: Confusing coordinate system for developers
- **Documentation**: Current documentation may be misleading about coordinate system
- **User Experience**: Developers may experience invisible log output when using intuitive (0,0) coordinates

#### Workaround

Use 1-based coordinates instead of 0-based:
- Replace `nc_set_position_log(0, 0)` with `nc_set_position_log(1, 1)`
- Add 1 to both x and y coordinates when positioning logs

#### Priority

**🟡 MEDIUM** - Affects usability but has a simple workaround. Should be fixed for consistency.

#### Related Functions

- `nc_set_position_log(WORD x, WORD y)`
- `nc_log_info(char *text, ...)`
- `nc_log_info_line(char *text, ...)`
- `nc_init_log()`

---

### Bootstrap Scaffolding Compilation Failure

**Status**: 🔴 Critical - Bootstrap System Failure
**Severity**: High
**Affected Version**: NeoCore 3.0.0-rc1
**Date Reported**: August 24, 2025
**GitHub Issue**: [#165](https://github.com/David-Vandensteen/neocore/issues/165)

#### Problem Description

When creating a new project with NeoCore 3.0.0-rc1, the bootstrap scaffolding system generates projects that fail to compile. The main compilation step fails with a segmentation fault, preventing successful builds of newly scaffolded projects.

#### Symptoms

- New project scaffolding completes successfully
- `mak sprite` command works correctly on scaffolded project
- `mak` (main build) fails with segmentation fault on bootstrapped project
- Build process exits with code 2
- Issue affects projects created through bootstrap scaffolding system

#### Error Output

```
Make exit code: 2
Make output:
  ..\build\gcc\gcc-2.95.2/as -m68000 --register-prefix-optional -I..\build\myGame  -o ..\build\myGame/crt0_cd.o ..\build\myGame/crt0_cd.s
  ..\build\gcc\gcc-2.95.2/gcc -IC:\Users\davidv\Documents\github\neocore\samples\neocore_migration_sample_3_0_0-rc1\neocore\src-lib\include -IC:\Users\davidv\Documents\github\neocore\samples\neocore_migration_sample_3_0_0-rc1\neocore\src-lib -I..\build\myGame -m68000 -O3 -Wall -fomit-frame-pointer -ffast-math -fno-builtin -nostartfiles -nodefaultlibs -D__cd__ -c ./main.c -o ..\build\myGame/./main.o
Make messages:
  make: *** [..\build\myGame/./main.o] Segmentation fault (core dumped)
Make failed with exit code 2
Build-Program returned: False
Build-Program failed
Default build failed
Build manager process failed
```

#### Analysis

**Working Steps:**
1. ✅ Assembly step (`as`) completes successfully
2. ✅ `crt0_cd.s` assembles without issues
3. ✅ Sprite compilation works correctly

**Failing Step:**
- ❌ GCC compilation of `main.c` causes segmentation fault
- The crash occurs during the C compilation phase
- Include paths appear to be correctly configured

#### Potential Causes

1. **🎯 Path Length Limitation**: **IDENTIFIED CAUSE** - The include paths exceed Windows/GCC path length limitations (87 characters vs 80 max):
   - `-IC:\Users\davidv\Documents\github\neocore\samples\neocore_migration_sample_3_0_0-rc1\neocore\src-lib\include` (97 chars)
   - `-IC:\Users\davidv\Documents\github\neocore\samples\neocore_migration_sample_3_0_0-rc1\neocore\src-lib` (89 chars)
   - GCC may fail silently or crash when paths exceed system limitations
2. **Bootstrap Template Issues**: Scaffolded project templates may contain incompatible code patterns
3. **GCC Version Compatibility**: gcc-2.95.2 may have compatibility issues with updated headers in scaffolded projects
4. **Header File Issues**: New defines or structures in v3.0.0-rc1 scaffolding templates might trigger compiler bugs
5. **Include Path Configuration**: Bootstrap may generate incorrect include path configurations
6. **Scaffolding System Regression**: Recent changes to bootstrap templates may have introduced breaking changes
6. **New Define Constants**: Recently added defines in scaffolded templates might trigger compiler edge cases:
   - `DISPLAY_GFX_WITH_SPRITE_ID_AUTO`
   - `SPRITE_INDEX_NOT_FOUND`

#### Immediate Impact

- **Bootstrap System**: Completely broken for v3.0.0-rc1
- **New Project Creation**: Cannot create working projects through scaffolding
- **Developer Onboarding**: New developers cannot get started with NeoCore
- **Release Readiness**: Blocks rc1 release validation

#### Workaround

Currently no known workaround available. Manual project setup may be required until bootstrap system is fixed.

#### Investigation Steps

1. **Bootstrap Template Analysis**: Examine scaffolded project templates for compatibility issues
2. **Test with minimal scaffolded main.c**: Create empty main function in bootstrapped project
3. **Header Analysis**: Check if specific headers in scaffolded projects cause the crash
4. **Include Path Testing**: Validate bootstrap-generated include path configurations
5. **Template Comparison**: Compare working manual projects vs. scaffolded projects
6. **GCC Debugging**: Run with debug flags to get more information on scaffolded builds
7. **Bootstrap System Validation**: Test bootstrap system against known working templates

#### Priority

**🔥 CRITICAL** - This issue completely prevents new project creation and must be resolved before any rc1 release.

#### Related Issues

- None currently identified

#### Environment Details

- **Platform**: Windows
- **GCC Version**: gcc-2.95.2
- **Make Version**: Unknown
- **NeoCore Version**: 3.0.0-rc1
- **Project Type**: New project created with standard templates

---

*This issue requires immediate investigation and resolution before v3.0.0-rc1 can be considered stable.*
