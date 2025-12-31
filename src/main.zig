const std = @import("std");
const c = @import("c.zig");
const onscripter = @import("onscripter.zig");

pub fn main() !void {
    std.debug.print("ONScripter version {s}({d}.{d})\n", .{ c.ONS_VERSION, c.NSC_VERSION / 100, c.NSC_VERSION % 100 });
    var ons = try onscripter.onscripter.open();
    try ons.close();
    return;
}
