const std = @import("std");
const mem = std.mem;
const io = std.io;
const fmt = std.fmt;
const c = @import("c.zig");
const DirtyRect = @import("DirtyRect.zig");
const cli = @import("cli.zig");

fn sdl3LogWrapper(comptime level: std.log.Level, comptime scope: @Type(.EnumLiteral), comptime format: []const u8, args: anytype) void {
    var buf: [8192:0]u8 = undefined;
    var stream = std.io.fixedBufferStream(&buf);
    std.fmt.format(stream.writer(), format, args) catch return;
    const pos = stream.getPos() catch return;
    buf[pos] = 0;
    c.SDL_Log("[" ++ comptime level.asText() ++ "] " ++ "(" ++ @tagName(scope) ++ "): %s", &buf);
}

pub const std_options: std.Options = .{
    .log_level = .debug,
    .logFn = sdl3LogWrapper,
};

pub fn main() !void {
    var iter = try std.process.argsWithAllocator(std.heap.c_allocator);
    defer iter.deinit();

    const options = try cli.parseCommandLineOptions(&iter);
    _ = options;
}
