# Known Issues

## NeoCore 3.0.0-rc1 Issues

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
