#include "anim.h"
#include "neo.h"
#include "time.h"

LIB8STATIC_ALWAYS_INLINE uint16_t scale16by8( uint16_t i, fract8 scale )
{
    uint16_t result;
    result = (i * (1+((uint16_t)scale))) >> 8;
    return result;
}
void BREATHING(effect_params_t* params) {
    uint16_t g_rgb_timer = get_timer();
    HSV      hsv  = rgb_matrix_config.hsv;
    uint16_t time = scale16by8(g_rgb_timer, rgb_matrix_config.speed / 8);
    hsv.v         = scale8(abs8(sin8(time) - 128) * 2, hsv.v);
    RGB rgb       = rgb_matrix_hsv_to_rgb(hsv);
    for (uint8_t i = led_min; i < led_max; i++) {
        RGB_MATRIX_TEST_LED_FLAGS();
        rgb_matrix_set_color(i, rgb.r, rgb.g, rgb.b);
    }
}