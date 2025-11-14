# Neocore

<p align="center">
  <img src="docs/images/logo/neocore-logo-crop.png" alt="Neocore Logo" width="400"/>
</p>

![Platform](https://img.shields.io/badge/platform-%20%7C%20windows-lightgrey) ![License: MIT](https://img.shields.io/badge/License-MIT-green.svg) ![GitHub last commit](https://img.shields.io/github/last-commit/David-Vandensteen/neocore) ![GitHub repo size](https://img.shields.io/github/repo-size/David-Vandensteen/neocore) ![NeoGeo-CD](https://img.shields.io/badge/target-NeoGeo%20CD-red) ![Uses Doxygen](https://img.shields.io/badge/docs-Doxygen-blue)

![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif) ![](https://media.giphy.com/media/iFUh5AEPD4XfvpsvJh/giphy.gif) ![](https://media.giphy.com/media/iJObJsdx6ud4zI7cS1/giphy.gif)

## 🎯 Overview<a name="overview"></a>

Neocore is a library and toolchain for developing on Neo Geo CD.

It provides high-level functions over Neo Dev Kit and DATlib 0.3, and includes tools and code that can help with projects on this platform.

### ✨ Key Features
- 🚀 **High abstraction level** for Neo Geo CD development
- 🔧 **Toolchain** with PowerShell scripts
- 🎮 **Compatible** with Windows 11
- 📖 **Documentation** generated with Doxygen
- 🔄 **Hot reload** for rapid development

### 🔗 Quick Links
- [💬 Discord](https://discord.com/channels/1330066799445676093/1330089958798790686)
- [📋 Migration from previous versions](docs/migration_guides/v2tov3/v2tov3.md)
- [📚 API Documentation](http://azertyvortex.free.fr/neocore-doxy/r12/neocore_8h.html)
- [📝 Changelog](CHANGELOG.md)

> ⚠️ **Current Version**: This version includes **breaking changes**. Please check the [migration guide](docs/migration_guides/v2tov3/v2tov3.md) before updating your existing projects.

## 📚 Table of Contents
- [🎯 Overview](#overview)
- [🚀 Quick Start](#quick-start)
  - [📋 Requirements](#requirements)
  - [⚡ Installation](#installation)
- [📦 Project Management](#project-management)
  - [🆕 Create a Project](#create-a-project)
  - [🆙 Upgrade a Project](#upgrade-an-existing-project)
  - [📤 Release a Project](#release-a-project)
- [⚙️ Command Reference](#command-reference)
  - [🔨 Mak Rules](#mak-rules)
  - [🎮 Emulator Profiles](#emulator-profiles)
- [📖 Documentation & Resources](#documentation--resources)
  - [📚 C API Documentation](#documentation-of-neocore-c-lib)
  - [🎨 DATlib Assets](#datlib-assets)
  - [🔄 Migration from Previous Versions](docs/migration_guides/v2tov3/v2tov3.md)
- [🛠️ Advanced Development](#advanced-development)
  - [♻️ Hot Reload](#hot-reload)
  - [🔧 Compile Library](#compiling-the-lib)
  - [🌿 Branches & Versions](#pull-or-checkout-another-branches)
- [🎵 Audio Configuration](#audio-configuration)
- [🤝 Contribution](#contribute)
  - [📅 Roadmap](#roadmap)
  - [🎮 Game Examples & Showcases](#examples)
  - [📚 Dependencies](#dependencies)

---

## Requirements<a name="requirements"></a>
* Up to date Windows 11
* Git [https://git-scm.com/download/win](https://git-scm.com/download/win)
* Windows Terminal with cmd instance (shortcut win + r and type `wt cmd`)

---

## 📅 Roadmap<a name="roadmap"></a>

### 🟡 Soon
- [x] neocore version switcher script for standalone project
- [x] One liner command for project creation to streamline the process and remove the need for multiple manual steps
- [x] Mak lint
- [ ] Integrate city41/mameNeoGeoDevPlugin
  - [ ] Fork it and tweak for Windows compatibility
- [ ] Video recording support - *After analysis, this feature will be deferred to Maybe section*

### 🕓 Later
- [ ] Neocore 4
  - [ ] Remove deprecated functions, macros and structures since Neocore 3.1.1
  - [ ] AES / MVS support (**5% completed**)
- [ ] RGB palette handlers (**60% completed**)
  - Samples: `pal_backdrop`, `pal_rgb`, `pal_rgb_mixer`
- [ ] Joypad 2 support
- [ ] Improve sound FX management
- [ ] Palette bank switcher
- [ ] DRAM asset management (unload/load from CD-ROM)

### 🧐 Maybe
- [ ] Video recording support (MAME MNG format with manual ffmpeg conversion to MP4)
- [ ] XML WYSIWYG editor
- [ ] Memory card support
- [ ] CLI-based asset packager
- [ ] GCC upgrade to version > 2.95.2
- [ ] Raine version selection
- [ ] MAME version selection

---

## 🚀 Quick Start<a name="quick-start"></a>

### ⚡ Installation<a name="installation"></a>

**1. Clone the repository**
```cmd
git clone https://github.com/David-Vandensteen/neocore.git
cd neocore
```

**2. Test the installation**
```cmd
cd samples\hello
.\mak.bat sprite
.\mak.bat
.\mak.bat run:mame
```

**3. Create your first project (One-liner)**

> ⚠️ **Important**: Avoid using spaces in project paths (e.g., use `C:\MyGame` instead of `C:\My Game`). Spaces can cause issues with the build tools.

Create and enter your project directory:
```cmd
md C:\MyGame
cd C:\MyGame
```

Run the creation command:
```cmd
curl -L https://raw.githubusercontent.com/David-Vandensteen/neocore/main/bootstrap/scripts/project/create_from_oneliner.bat -o c.bat && c.bat && del c.bat
```

Then build and run:
```cmd
cd src
.\mak.bat sprite
.\mak.bat
.\mak.bat run:mame
```

🎉 **Congratulations!** You've created and launched your first Neo Geo CD project with a single command!

> 💡 **Next Steps**: See [Project Management](#project-management) section for detailed project creation options and workflows.

---

## ⚙️ Command Reference<a name="command-reference"></a>

### 🔨 Mak Rules<a name="mak-rules"></a>

> ⚠️ **Warning**: The mak script overrides the PATH environment variable during compilation. If you encounter any problems after using it, simply close and restart a new command terminal.

| Command | Description |
|---------|-------------|
| `.\mak.bat` | Build the program |
| `.\mak.bat clean` | Remove built resources |
| `.\mak.bat clean:build` | Remove the entire build folder |
| `.\mak.bat sprite` | Build sprites |
| `.\mak.bat lint` | Validate project (project.xml, .gitignore, legacy code) |
| `.\mak.bat run:raine` | Run with Raine emulator |
| `.\mak.bat run:mame` | Run with MAME emulator |
| `.\mak.bat serve:mame` | Run in hot reload mode |
| `.\mak.bat dist:iso` | Create ISO distribution package |
| `.\mak.bat dist:mame` | Create MAME distribution package |
| `.\mak.bat dist:exe` | Create Windows standalone executable |
| `.\mak.bat framer` | Launch DATlib Framer |
| `.\mak.bat animator` | Launch DATlib Animator |
| `.\mak.bat lib` | Compile Neocore library |
| `.\mak.bat --version` | Display version information |

### 🎮 Custom Emulator Profiles<a name="emulator-profiles"></a>

You can create custom emulator profiles for different testing scenarios.
Neocore comes with default profiles (`default`, `full`, `nosound`, `debug` for MAME), but you can add your own.

**Creating Custom MAME Profiles:**

Add custom profiles to your `project.xml`:
```xml
<project>
  <emulator>
    <mame>
      <profile>
        <!-- Default profiles are already included -->
        <myprofile>-window -skip_gameinfo -throttle neocdz</myprofile>
        <benchmark>-window -skip_gameinfo -nothrottle -bench 60 neocdz</benchmark>
        <record>-window -skip_gameinfo -aviwrite output.avi neocdz</record>
      </profile>
    </mame>
  </emulator>
</project>
```

**Creating Custom Raine Configurations:**

Create custom config files in your project and reference them:
```xml
<project>
  <emulator>
    <raine>
      <config>
        <!-- Default configs are already included -->
        <myconfig>raine\config\myconfig.cfg</myconfig>
        <test>raine\config\test.cfg</test>
      </config>
    </raine>
  </emulator>
</project>
```

**Usage:**
```cmd
# Use your custom MAME profiles
.\mak.bat run:mame:myprofile
.\mak.bat run:mame:benchmark
.\mak.bat run:mame:record

# Use your custom Raine configs
.\mak.bat run:raine:myconfig
.\mak.bat run:raine:test

# Default profiles (included with Neocore)
.\mak.bat run:mame:full      # Fullscreen
.\mak.bat run:mame:debug     # Debug mode
.\mak.bat run:raine:full     # Fullscreen
```


---

## 🔧 Development Workflow

### Build Steps (v3.0.0+)

Starting with version 3.0.0, build steps are now explicit and must be executed manually for better control and performance optimization:

#### Development Workflows

```bash
# Initial development (build everything)
.\mak.bat sprite && .\mak.bat && .\mak.bat run:raine

# Code-only modifications (sprites unchanged)
.\mak.bat && .\mak.bat run:raine  # ⚡ Faster!

# Quick test without recompilation
.\mak.bat run:raine  # 🚀 Instant!
```

#### Build Step Breakdown

| Step | Command | Purpose | When to use |
|------|---------|---------|-------------|
| **1. Sprites** | `.\mak.bat sprite` | Generate sprite data from assets | When assets change |
| **2. Compile** | `.\mak.bat` | Compile C code and link | When code changes |
| **3. Run** | `.\mak.bat run:raine` | Launch in emulator | Always for testing |

#### Performance Benefits

- **🚀 Faster iteration**: Skip sprite generation when only code changes
- **💾 Cache optimization**: Leverage build cache for unchanged components
- **🎯 Granular control**: Build only what you need
- **⏱️ Reduced build time**: Avoid unnecessary regeneration

> **Migration Note**: In versions before 3.0.0, `mak run:raine` or `mak run:mame` automatically executed all build steps.\
This workflow change provides better performance for iterative development.

---

## 📦 Project Management<a name="project-management"></a>

### 🆕 Create a New Project<a name="create-a-project"></a>

#### Method 1: One-liner (Recommended)

The fastest way to create a new project from anywhere.

> ⚠️ **Important**: Avoid using spaces in project paths (e.g., use `C:\MyGame` instead of `C:\My Game`). Spaces can cause issues with the build tools.

Create and enter your project directory:
```cmd
md C:\MyGame
cd C:\MyGame
```

Run the creation command:
```cmd
curl -L https://raw.githubusercontent.com/David-Vandensteen/neocore/main/bootstrap/scripts/project/create_from_oneliner.bat -o c.bat && c.bat && del c.bat
```

This will:
1. Create and enter your project directory
2. Download the creation script from GitHub
3. Prompt you for a project name
4. Set up the complete Neocore project structure
5. Clean up temporary files

**Advantages:**
- ✅ No need to clone the Neocore repository
- ✅ Always uses the latest stable version
- ✅ Single command to copy and paste

#### Method 2: Manual creation (Alternative)

If you have already cloned the Neocore repository:

```cmd
cd <neocore>\bootstrap\scripts\project
.\create.bat -name MyGame -projectPath C:\temp\MyGame
```

**Available options:**
- `-force`: Overwrite existing files
- `-name`: Project name
- `-projectPath`: Destination path

### 🆙 Upgrade an Existing Project<a name="upgrade-an-existing-project"></a>

> ⚠️ **Important**: Backup your project before upgrading. Check the [migration guide](docs/migration_guides/v2tov3/v2tov3.md) for breaking changes.

#### Method 1: Using Version Switcher (NeoCore 3.2.0+)

The version switcher provides a simple way to upgrade or switch between NeoCore versions:

```cmd
# From your project root directory
cd C:\temp\MyGame

# Upgrade to latest stable version
.\neocore-version-switcher.bat master

# Or switch to a specific version
.\neocore-version-switcher.bat 3.2.0

# List all available versions
.\neocore-version-switcher.bat --list
```

> 💡 **Tip**: The version switcher automatically handles the upgrade process and updates itself when switching versions.

#### Method 2: Manual Upgrade Script (NeoCore < 3.2.0)

```cmd
# 1. Remove build folder
rd /S /Q C:\temp\MyGame\build

# 2. Run upgrade script
cd <neocore>\bootstrap\scripts\project
.\upgrade.bat -projectSrcPath C:\temp\MyGame\src -projectNeocorePath C:\temp\MyGame\neocore
```

The upgrade script performs comprehensive validation and updates:

**Automatic validation:**
- 📋 Verifies project structure and required files (including Makefile)
- 🔍 Analyzes C code for breaking changes and deprecated patterns
- �️ Removes deprecated files (common_crt0_cd.s, crt0_cd.s)
- �💾 Creates automatic backup before making changes
- 📝 Generates detailed migration logs

**What gets updated:**
- ✅ Neocore toolchain and C library
- ✅ Build scripts (mak.bat and mak.ps1)
- ✅ Project structure validation
- ✅ Deprecated file cleanup (automatic removal)
- ✅ XML project definition
- ❌ Your source code (manual migration needed - see logs for guidance)
- ❌ Project assets

> 💡 **Tip**: The script generates detailed logs showing breaking changes found in your code. Review these logs to understand what manual changes may be needed.

> 🔒 **Security Note**: Migration logs may contain absolute paths from your system. Review generated logs before sharing them publicly and consider adding `*.log` to your `.gitignore` if needed.

### 📤 Release a Project<a name="release-a-project"></a>

From your project's `src` folder:

```cmd
# ISO distribution
.\mak.bat dist:iso

# MAME distribution
.\mak.bat dist:mame

# Windows standalone executable (game + emulator)
.\mak.bat dist:exe
```

---
## 📖 Documentation & Resources<a name="documentation--resources"></a>

### 📚 C API Documentation<a name="documentation-of-neocore-c-lib"></a>

- **[Doxygen Documentation](http://azertyvortex.free.fr/neocore-doxy/r14/neocore_8h.html)**
- **[Migration Guide](docs/migration_guides/v2tov3/v2tov3.md)** - Breaking changes and migration from previous versions
- **[Changelog](CHANGELOG.md)** - Version history

### 🎨 DATlib Assets<a name="datlib-assets"></a>

**DATlib Documentation:**
- [DATlib Reference (PDF)](http://azertyvortex.free.fr/download/neocore/datlib-0.3-LibraryReference.pdf)

**Configuration in project.xml:**
```xml
<project>
  <gfx>
    <DAT>
      <chardata>
        <!-- DATlib configuration -->
      </chardata>
      <fixdata>
        <!-- DATlib fixdata configuration -->
      </fixdata>
    </DAT>
  </gfx>
</project>
```

**DATlib Tools:**
```cmd
.\mak.bat framer     # Launch DATlib Framer
.\mak.bat animator   # Launch DATlib Animator
```

---

## 🎵 Audio Configuration<a name="audio-configuration"></a>

### CDDA (CD Digital Audio) Configuration

For Neo Geo CD projects, you can configure CDDA tracks in your `project.xml`:

**Configuration structure:**
```xml
<project>
  <sound>
    <cd>
      <cdda>
        <dist>
          <iso>
            <format>mp3</format>  <!-- Distribution format -->
          </iso>
        </dist>
        <tracks>
          <track><!-- track id 1 is reserved for the binary program -->
            <id>2</id>
            <file>assets\sounds\cdda\track02.wav</file>
            <pregap>00:02:00</pregap>
          </track>
          <!-- Add more tracks as needed -->
        </tracks>
      </cdda>
    </cd>
  </sound>
</project>
```

**Key points:**
- Track ID 1 is reserved for the binary program
- Use WAV files for source audio (high quality)
- Distribution format (MP3) optimizes ISO size
- Pregap of `00:02:00` is standard for CD audio
- Mixed source formats supported (WAV, MP3)

**Audio file organization:**
```
assets/
└── sounds/
    └── cdda/
        ├── track02.wav
        ├── track03.wav
        └── track04.mp3
```

---

## 🤝 Contribution<a name="contribute"></a>

### 🎯 How to Contribute

**Developers:**
- 📝 Create tutorials or code examples
- 🐛 Report and fix bugs
- 💡 Propose new features
- 📚 Improve documentation

**Neo-Geo CD Owners:**
- 🧪 Test examples on real hardware
- 🐛 Report hardware compatibility issues
- ✅ Confirm functionality on real hardware

**Financial Support:**
To improve hardware compatibility and project development, any financial contribution is appreciated.

[💰 Make a PayPal donation](https://www.paypal.com/donate/?hosted_button_id=YAHAJGP58TYM4)

### ⚠️ Disclaimers

- This project is under active development
- Mainly tested on Raine and MAME emulators
- **No guarantee of functionality on real Neo-Geo hardware**
- The author is not responsible for any software damage

Any help is welcome! 🙏

---

### 🎮 Game Examples & Showcases<a name="examples"></a>

- **Pong**: https://github.com/David-Vandensteen/neogeo-cd-pong
- **Flamble**:
  - [Twitter Demo](https://twitter.com/i/status/1296434554526478336)
  - [YouTube Video](https://www.youtube.com/embed/YjRmvMAfgbc)
  - [Website](http://azertyvortex.free.fr/flamble)

---

## 🛠️ Advanced Development<a name="advanced-development"></a>

### ♻️ Hot Reload<a name="hot-reload"></a>

Hot reload allows you to automatically recompile and restart your project when making changes:

```cmd
cd <neocore>\samples\hello
.\mak.bat serve:mame
```

1. The emulator launches
2. Edit `main.c`
3. Save the file
4. The project recompiles and restarts automatically

**Current limitations:**
- ⚠️ Not a real watcher (triggers only when folder size changes)
- ⚠️ PATH is not restored when interrupted (close/reopen terminal)

### 🔧 Compile Library<a name="compiling-the-lib"></a>

Necessary if you modify Neocore source code:

```cmd
.\mak.bat clean
.\mak.bat lib
```

### 🌿 Branches & Versions<a name="pull-or-checkout-another-branches"></a>

> ⚠️ **Important**: Remove the `.\neocore\build` folder before compiling after a branch change to avoid cache conflicts.

```cmd
.\mak.bat clean:build
```

---

## 📚 Dependencies<a name="dependencies"></a>

- NeoDev
- DATlib
- DATimage
- NGFX SoundBuilder
- Raine
- Mame
- CHDMAN
- Doxygen
- MSYS2
- Mkisofs
- GCC
- mpg123
- ffmpeg
- NSIS

---

## 📝 [Changelog](CHANGELOG.md)

Complete version history and changes documentation.

---

## 📄 License

Neocore is licensed under the MIT license.
Copyright 2019 by David Vandensteen.
Some graphics by **Grass**.

