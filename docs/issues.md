# Known Issues

## NeoCore 3.0.0-rc1 Issues

### Bootstrap Scaffolding Compilation Failure

**Status**: 🔴 Critical - Bootstrap System Failure
**Severity**: High
**Affected Version**: NeoCore 3.0.0-rc1
**Date Reported**: August 24, 2025
**GitHub Issue**: [#85](https://github.com/David-Vandensteen/neocore/issues/85)

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

1. **Bootstrap Template Issues**: Scaffolded project templates may contain incompatible code patterns
2. **GCC Version Compatibility**: gcc-2.95.2 may have compatibility issues with updated headers in scaffolded projects
3. **Header File Issues**: New defines or structures in v3.0.0-rc1 scaffolding templates might trigger compiler bugs
4. **Include Path Configuration**: Bootstrap may generate incorrect include path configurations:
   - `-IC:\Users\davidv\Documents\github\neocore\samples\neocore_migration_sample_3_0_0-rc1\neocore\src-lib\include`
   - `-IC:\Users\davidv\Documents\github\neocore\samples\neocore_migration_sample_3_0_0-rc1\neocore\src-lib`
5. **Scaffolding System Regression**: Recent changes to bootstrap templates may have introduced breaking changes
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
