const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const optimize = .Debug;
    var target = b.standardTargetOptions(.{});
    target.cpu_features_sub = std.Target.riscv.featureSet(&.{.a, .d, .f});

    const lib = b.addStaticLibrary(.{
        .name = "zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    if (std.os.getenv("INCLUDE_DIRS")) |include_dirs| {
        var it = std.mem.tokenize(u8, include_dirs, ";");
        while (it.next()) |dir| {
            lib.addIncludePath(.{.path =  dir});
        }
    }

    b.installArtifact(lib);
}
