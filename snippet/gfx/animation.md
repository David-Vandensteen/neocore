# code_snippet
## Summary
The code snippet defines four functions related to updating and setting animations for a graphics animated sprite. There are two functions for setting the animation of a `GFX_Animated_Sprite` and a `GFX_Animated_Sprite_Physic` object, and two functions for updating the animation of these objects.

## Example Usage
```c
GFX_Animated_Sprite gfx_sprite;
GFX_Animated_Sprite_Physic gfx_sprite_physic;
WORD animation = 1;

set_animation_gfx_animated_sprite(&gfx_sprite, animation);
set_animation_gfx_animated_sprite_physic(&gfx_sprite_physic, animation);

update_animation_gfx_animated_sprite(&gfx_sprite);
update_animation_gfx_animated_sprite_physic(&gfx_sprite_physic);
```

## Code Analysis
### Inputs
- `gfx_animated_sprite`: A pointer to a `GFX_Animated_Sprite` object.
- `gfx_animated_sprite_physic`: A pointer to a `GFX_Animated_Sprite_Physic` object.
- `anim`: The animation index to set.
___
### Flow
- `set_animation_gfx_animated_sprite`: Sets the animation of the `GFX_Animated_Sprite` object to the specified animation index.
- `set_animation_gfx_animated_sprite_physic`: Sets the animation of the `GFX_Animated_Sprite_Physic` object to the specified animation index.
- `update_animation_gfx_animated_sprite`: Updates the animation of the `GFX_Animated_Sprite` object.
- `update_animation_gfx_animated_sprite_physic`: Updates the animation of the `GFX_Animated_Sprite_Physic` object.
___
### Outputs
- None. The functions modify the state of the `GFX_Animated_Sprite` and `GFX_Animated_Sprite_Physic` objects.
___
