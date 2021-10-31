const std = @import("std");
const log = @import("log.zig");

const c = @cImport({
    @cInclude("stdio.h");
});

const esp = @cImport({
    @cInclude("sdkconfig.h");
    @cInclude("esp_system.h");
    @cInclude("led_strip.h");
});

const freertos = @cImport({
    @cInclude("freertos/FreeRTOS.h");
    @cInclude("freertos/task.h");
});

const BLINK_LED_RMT_CHANNEL = esp.CONFIG_BLINK_LED_RMT_CHANNEL;
const BLINK_GPIO = esp.CONFIG_BLINK_GPIO;

const LedStrip = struct {
    ptr: *esp.led_strip_t,

    const Self = @This();

    pub fn init(channel: u8, gpio: u8, led_num: u16) Self {
        var self = Self { .ptr = esp.led_strip_init(channel, gpio, led_num) };
        self.clear(50) catch unreachable;
        return self;
    }

    pub fn clear(self: Self, timeout: u32) !void {
        return switch (self.ptr.clear.?(self.ptr, timeout)) {
            esp.ESP_ERR_TIMEOUT => {
                _ = c.printf("Clear LEDs failed because of timeout\n");
                return error.Timeout;
            },
            esp.ESP_FAIL => {
                _ = c.printf("Clear LEDs failed because some other error occurred\n");
                return error.Other;
            },
            else => .{},
        };
    }

    pub fn setPixel(self: Self, index: u32, red: u32, green: u32, blue: u32) !void {
        return switch (self.ptr.set_pixel.?(self.ptr, index, red, green, blue)) {
            esp.ESP_ERR_INVALID_ARG => {
                _ = c.printf("Set RGB for a specific pixel failed because of invalid parameters\n");
                return error.InvalidArgument;
            },
            esp.ESP_FAIL => {
                _ = c.printf("Set RGB for a specific pixel failed because other error occurred\n");
                return error.Other;
            },
            else => .{},
        };
    }

    pub fn refresh(self: Self, timeout: u32) !void {
        return switch (self.ptr.refresh.?(self.ptr, timeout)) {
            esp.ESP_ERR_TIMEOUT => {
                _ = c.printf("Refresh failed because of timeout\n");
                return error.Timeout;
            },
            esp.ESP_FAIL => {
                _ = c.printf("Refresh failed because other error occurred\n");
                return error.Other;
            },
            else => .{},
        };
    }

    pub fn enable(self: Self) void {
        self.setPixel(0, 16, 16, 16) catch unreachable;
        self.refresh(100) catch unreachable;
    }

    pub fn disable(self: Self) void {
        self.clear(50) catch unreachable;
    }
};

export fn app_main() void {
    var led_state = false;
    var strip = LedStrip.init(BLINK_LED_RMT_CHANNEL, BLINK_GPIO, 1);

    while (true) {
        log.info("blink", "Toggling the LED %s!", .{@as([:0]const u8, if (led_state) "ON" else "OFF").ptr});
        if (led_state) {
            strip.enable();
        } else {
            strip.disable();
        }
        led_state = !led_state;
        freertos.vTaskDelay(esp.CONFIG_BLINK_PERIOD / freertos.portTICK_PERIOD_MS);
    }
}
