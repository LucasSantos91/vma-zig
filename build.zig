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
    if (optimize != .Debug) {
        translate.defineCMacro("NDEBUG", null);
    }
    const vk_headers_path = vk_headers.path("include");
    translate.addIncludePath(vk_headers_path);
    const raw_vma = translate.addModule("raw-vma-zig");
    raw_vma.addIncludePath(vk_headers_path);
    setModule(raw_vma, optimize, vma_path);

    const vma = b.addModule("vma-zig", .{
        .root_source_file = b.path("src/root.zig"),
    });
    setModule(vma, optimize, vma_path);
}

fn setModule(module: *std.Build.Module, optimize: std.builtin.OptimizeMode, vma_path: std.Build.LazyPath) void {
    module.addCSourceFile(.{
        .file = vma_path,
        .flags = &.{},
        .language = .cpp,
    });
    module.addCMacro("VMA_IMPLEMENTATION", "1");
    module.link_libc = true;
    module.link_libcpp = true;

    if (optimize != .Debug) {
        module.addCMacro("NDEBUG", "1");
    }
}
