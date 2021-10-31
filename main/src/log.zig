const std = @import("std");

const esp = @cImport({
    @cInclude("esp_log.h");
});

const COLOR_FORMAT = "\x1b[0;{d}m";
const COLOR_RESET = "\x1b[0m";
const COLOR_GREEN = 32;

pub fn info(comptime tag: [:0]const u8, comptime format: [:0]const u8, args: anytype) void {
    const fmt = std.fmt.comptimePrint(COLOR_FORMAT ++ "I (%u): {s}" ++ COLOR_RESET ++ "\n", .{COLOR_GREEN, format});
    const timestamp = esp.esp_log_timestamp();
    @call(.{}, esp.esp_log_write, .{esp.ESP_LOG_INFO, tag, fmt, timestamp} ++ args);
}
