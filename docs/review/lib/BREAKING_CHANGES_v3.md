# NeoCore 3.0.0 - Breaking Changes

This document lists all breaking changes from NeoCore v2.x to v3.0.0 that require code modifications.

## 1. Structure Type Changes

### 1.1 Position Structure Replacement

**BREAKING:** `Vec2short` structure replaced with `Position`

```c
// v2.x (OLD)
typedef struct Vec2short { short x; short y; } Vec2short;

// v3.0 (NEW)
typedef struct Position { short x; short y; } Position;
```

**Migration Required:**
- Replace all `Vec2short` declarations with `Position`
- Update function parameters and return types
- Update Box structure member types

### 1.2 Box Structure Member Type Change

**BREAKING:** Box corner points now use `Position` instead of `Vec2short`

```c
// v2.x (OLD)
typedef struct Box {
  Vec2short p0, p1, p2, p3, p4;
  // ... other fields
} Box;

// v3.0 (NEW)
typedef struct Box {
  Position p0, p1, p2, p3, p4;
  // ... other fields
} Box;
```

**Migration Required:**
- Code accessing box corner points remains the same (`.x` and `.y` access)
- Only type declarations need updating

## 2. Function Signature Changes

### 2.1 GFX Position Getter Functions

**BREAKING:** All position getter functions now use output parameters instead of return values

```c
// v2.x (OLD)
Vec2short nc_get_position_gfx_animated_sprite(GFX_Animated_Sprite gfx_animated_sprite);
Vec2short nc_get_position_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic gfx_animated_sprite_physic);
Vec2short nc_get_position_gfx_picture(GFX_Picture gfx_picture);
Vec2short nc_get_position_gfx_picture_physic(GFX_Picture_Physic gfx_picture_physic);
Vec2short nc_get_position_gfx_scroller(GFX_Scroller gfx_scroller);

// v3.0 (NEW)
void nc_get_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, Position *position);
void nc_get_position_gfx_animated_sprite_physic(GFX_Animated_Sprite_Physic *gfx_animated_sprite_physic, Position *position);
void nc_get_position_gfx_picture(GFX_Picture *gfx_picture, Position *position);
void nc_get_position_gfx_picture_physic(GFX_Picture_Physic *gfx_picture_physic, Position *position);
void nc_get_position_gfx_scroller(GFX_Scroller *gfx_scroller, Position *position);
```

**Migration Required:**
```c
// v2.x (OLD)
Vec2short pos = nc_get_position_gfx_animated_sprite(player);
if (pos.x > 100) { /* ... */ }

// v3.0 (NEW)
Position pos;
nc_get_position_gfx_animated_sprite(&player, &pos);
if (pos.x > 100) { /* ... */ }
```

### 2.2 Structure Member Type Changes (const qualifiers)

**BREAKING:** GFX structures now use `const` pointers for data integrity

```c
// v2.x (OLD)
typedef struct GFX_Animated_Sprite {
  aSprite aSpriteDAT;
  spriteInfo *spriteInfoDAT;
  paletteInfo *paletteInfoDAT;
} GFX_Animated_Sprite;

// v3.0 (NEW)
typedef struct GFX_Animated_Sprite {
  aSprite aSpriteDAT;
  const spriteInfo *spriteInfoDAT;
  const paletteInfo *paletteInfoDAT;
} GFX_Animated_Sprite;
```

**Migration Required:**
- Change function parameters to accept `const` pointers where appropriate
- This affects `GFX_Animated_Sprite`, `GFX_Picture`, and `GFX_Scroller`

### 2.3 Logging Functions

**BREAKING:** Several logging functions removed or changed signatures

```c
// v2.x (OLD) - REMOVED
void nc_log(char *message);

// v3.0 (NEW) - Use instead
WORD nc_log_info(char *txt, ...);
WORD nc_log_info_line(char *txt, ...);
```

**BREAKING:** Log functions with label parameters removed

```c
// v2.x (OLD) - WITH LABELS
void nc_log_word(char *label, WORD value);
void nc_log_int(char *label, int value);
void nc_log_short(char *label, short value);
// ... etc

// v3.0 (NEW) - WITHOUT LABELS
void nc_log_word(WORD value);
void nc_log_int(int value);
void nc_log_short(short value);
// ... etc
```

**Migration Required:**
```c
// v2.x (OLD)
nc_log("Player position:");
nc_log_word("X", player_x);
nc_log_word("Y", player_y);

// v3.0 (NEW)
nc_log_info_line("Player position:");
nc_log_info("X: "); nc_log_word(player_x); nc_log_next_line();
nc_log_info("Y: "); nc_log_word(player_y); nc_log_next_line();
```

### 2.4 Function Parameter Changes

**BREAKING:** Functions taking pointer-by-value now require pointer-by-reference

```c
// v2.x (OLD)
Vec2short nc_get_position_gfx_animated_sprite(GFX_Animated_Sprite gfx_animated_sprite);

// v3.0 (NEW)
void nc_get_position_gfx_animated_sprite(GFX_Animated_Sprite *gfx_animated_sprite, Position *position);
```

## 3. Utility Functions

### 3.1 Vector/Position Function Changes

**BREAKING:** Functions using `Vec2short` now use `Position`

```c
// v2.x (OLD)
void nc_update_mask(short x, short y, Vec2short vec[], Vec2short offset[], BYTE vector_max);
BOOL nc_vectors_collide(Box *box, Vec2short vec[], BYTE vector_max);
void nc_log_vec2short(char *label, Vec2short vec2short);

// v3.0 (NEW)
void nc_update_mask(short x, short y, Position vec[], Position offset[], BYTE vector_max);
BOOL nc_vectors_collide(Box *box, Position vec[], BYTE vector_max);
void nc_log_position(Position position);
```

**Migration Required:**
- Update all `Vec2short` array declarations to `Position`
- Update function calls with new parameter types

### 3.2 Removed Utility Function

**BREAKING:** Function removed from public API

```c
// v2.x (OLD) - REMOVED
Vec2short nc_get_relative_position(Box box, Vec2short world_coord);

// v3.0 (NEW) - Function not available (commented out)
// Position nc_get_relative_position(Box box, Position world_coord); // TODO
```

## 4. Macro and Constants

### 4.1 No Breaking Changes in Macros
- All bitwise operation macros remain unchanged
- Math macros (`nc_min`, `nc_max`, `nc_abs`) remain unchanged
- Palette manipulation macros remain unchanged

## 5. Migration Checklist

### 5.1 Global Search & Replace
1. Replace `Vec2short` → `Position` (structure type)
2. Replace `nc_log_vec2short` → `nc_log_position`

### 5.2 Function Call Updates
1. Update all position getter calls to use output parameters:
   - `Vec2short pos = nc_get_position_*()` → `Position pos; nc_get_position_*(&obj, &pos)`
2. Remove labels from logging functions:
   - `nc_log_word("label", value)` → `nc_log_info("label: "); nc_log_word(value)`
3. Replace `nc_log()` calls with `nc_log_info()` or `nc_log_info_line()`

### 5.3 Structure Updates
1. Update Box corner point access (should work unchanged due to same member names)
2. Add `const` qualifiers where needed for GFX structure initialization

### 5.4 Array Declarations
1. Update `Vec2short arrays[]` → `Position arrays[]`
2. Update function parameters accepting position arrays

## 6. Compatibility Notes

### 6.1 Binary Compatibility
- **BROKEN:** v3.0 is not binary compatible with v2.x
- Full recompilation required

### 6.2 Source Compatibility
- **MOSTLY BROKEN:** Significant source changes required
- Automated migration possible for most changes using search & replace
- Manual review required for logging function changes

## 7. Benefits of Changes

### 7.1 Performance Improvements
- Position getter functions avoid structure copying overhead
- Better memory layout with consistent Position type

### 7.2 Code Clarity
- Consistent `Position` type throughout API
- Simplified logging API without redundant labels
- Better const-correctness with data pointers

### 7.3 Memory Safety
- Output parameter pattern prevents accidental structure copying
- Const qualifiers prevent accidental data modification
