#include <neocore.h>

void test_v2_patterns() {
    // V2 patterns that need migration in v3

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
}

int main() {
    test_v2_patterns();
    return 0;
}
