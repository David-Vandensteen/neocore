#include "neocore.h"

void test_v2_additional_patterns() {
    // Additional V2 patterns for comprehensive testing

    nc_log("=== Testing additional v2 patterns in hello.c ===");

    // More V2 type usage examples
    Hex_Color colors[3] = {"FF", "00", "AA"};
    Hex_Packed_Color packed_colors[2] = {"FFFF", "0000"};

    // V2 position function calls with different patterns
    Vec2short sprite_pos = nc_get_position_gfx_animated_sprite(1);
    Vec2short picture_pos = nc_get_position_gfx_picture(2);
    Vec2short scroller_pos = nc_get_position_gfx_scroller(3);

    // V2 logging with arrays
    for (int i = 0; i < 3; i++) {
        nc_log_rgb16(colors[i]);
    }

    for (int i = 0; i < 2; i++) {
        nc_log_packed_color16(packed_colors[i]);
    }

    // V2 position logging
    nc_log_vec2short(sprite_pos);
    nc_log_vec2short(picture_pos);
    nc_log_vec2short(scroller_pos);
}

void test_v2_function_signatures() {
    // Test various V2 function call patterns

    // V2 palette functions without required parameters
    void* palette = nc_get_palette(5);
    nc_load_palettes();

    // V2 sprite functions
    nc_load_sprites();

    // V2 sound and ADPCM patterns
    nc_load_sound("background.wav");
    nc_load_sound("effect.adpcm");

    nc_adpcm_load(0, "test.adpcm");
    nc_adpcm_set_volume(0, 128);
    nc_adpcm_is_playing(0);
}

void test_v2_macro_usage() {
    // V2 macro and constant usage

    Vec2short center = VEC2SHORT(CD_WIDTH / 2, CD_HEIGHT / 2);
    Vec2short corner = VEC2SHORT(0, 0);
    Vec2short bottom_right = VEC2SHORT(CD_WIDTH, CD_HEIGHT);

    // Log positions using v2 function
    nc_log_vec2short(center);
    nc_log_vec2short(corner);
    nc_log_vec2short(bottom_right);
}

void test_v2_memory_patterns() {
    // V2 memory management patterns

    // Allocate memory using v2 functions
    char* buffer = (char*)nc_malloc(256);
    Vec2short* positions = (Vec2short*)nc_malloc(sizeof(Vec2short) * 10);
    Hex_Color* color_array = (Hex_Color*)nc_malloc(sizeof(Hex_Color) * 16);

    if (buffer) {
        // Use buffer
        for (int i = 0; i < 10; i++) {
            buffer[i] = 'A' + i;
        }
        nc_free(buffer);
    }

    if (positions) {
        // Initialize positions
        for (int i = 0; i < 10; i++) {
            positions[i] = VEC2SHORT(i * 10, i * 20);
        }
        nc_free(positions);
    }

    if (color_array) {
        nc_free(color_array);
    }
}

void test_v2_patterns() {
    // Original v2 test patterns with comprehensive examples

    nc_log("=== Comprehensive v2 pattern testing ===");

    // These typedefs were removed in v3 - should cause compilation errors
    Hex_Color color = "FF";
    Hex_Packed_Color packedColor = "FFFF";

    // Logging functions that use the removed typedefs
    nc_log_rgb16(color);
    nc_log_packed_color16(packedColor);

    // These should work in both v2 and v3
    nc_log("Test v2 to v3 migration");
    nc_init();

    // Test some basic functionality
    char message[] = "Hello from v2 project!";
    nc_log(message);

    // Run additional pattern tests
    test_v2_additional_patterns();
    test_v2_function_signatures();
    test_v2_macro_usage();
    test_v2_memory_patterns();

    nc_log("=== hello.c v2 pattern testing completed ===");
}

int main() {
    test_v2_patterns();
    return 0;
}
