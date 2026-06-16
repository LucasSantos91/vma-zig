VMA packaged for zig.

Add to your `build.zig.zon` and obtain the module like so:

```zig
const vma_zig = b.dependency("vma-zig", .{
    .target = target,
    .optimize = optimize,
});
const vma_module = vma_zig.module("vma-zig");
```

In your source codes, access the module as:

```zig
const vma = @import("vma-zig");
```

All functions and macros from the reference implementation are included exactly as in the C version.
