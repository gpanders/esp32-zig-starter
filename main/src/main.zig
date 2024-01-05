const std = @import("std");
const log = @import("log.zig");

const c = @cImport({
    @cInclude("stdio.h");
});

const esp = @cImport({
    @cInclude("sdkconfig.h");
    @cInclude("esp_system.h");
    @cInclude("driver/gpio.h");
});

const freertos = @cImport({
    @cInclude("freertos/FreeRTOS.h");
    @cInclude("freertos/task.h");
});

const BLINK_GPIO = 5;	// plain old LED

const TAG = "[zig main]";

export fn app_main() void {
    var led_state = false;
    _= esp.gpio_reset_pin(BLINK_GPIO);
    _= esp.gpio_set_direction(BLINK_GPIO, esp.GPIO_MODE_OUTPUT);

    while (true) {
        log.info(TAG, "Toggling the LED %s!", .{@as([:0]const u8, if (led_state) "ON" else "OFF").ptr});
        if (led_state) {
            _ = esp.gpio_set_level(BLINK_GPIO, 1);
        } else {
            _ = esp.gpio_set_level(BLINK_GPIO, 0);
        }
        led_state = !led_state;
        freertos.vTaskDelay(esp.CONFIG_BLINK_PERIOD / freertos.portTICK_PERIOD_MS);
    }
}
