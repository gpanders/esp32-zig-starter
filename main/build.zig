const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const lib = b.addStaticLibrary("zig", "src/main.zig");
    lib.setBuildMode(mode);
    lib.setTarget(target);

    if (std.os.getenv("INCLUDE_DIRS")) |include_dirs| {
        var it = std.mem.tokenize(u8, include_dirs, ";");
        while (it.next()) |dir| {
            lib.addIncludeDir(dir);
        }
    }

    lib.install();
}
