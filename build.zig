const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const vma_dep = b.dependency("vma", .{});
    const vma_path = vma_dep.path("include/vk_mem_alloc.h");
    const vk_headers = b.dependency("vulkan-headers", .{});
    const translate = b.addTranslateC(.{
        .root_source_file = vma_path,
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    const vk_headers_path = vk_headers.path("include");
    translate.addIncludePath(vk_headers_path);
    const vma = translate.addModule("vma-zig");
    vma.addCSourceFile(.{
        .file = vma_path,
        .flags = &.{},
        .language = .c,
    });
    vma.addIncludePath(vk_headers_path);

    if (optimize != .Debug) {
        translate.defineCMacro("NDEBUG", null);
        vma.addCMacro("NDEBUG", "1");
    }
}
