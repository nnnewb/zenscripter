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
    const stdout = std.io.getStdOut();
    if (options.show_help) {
        const w = stdout.writer();
        _ = try w.write("Usage: onscripter [option ...]\n");
        _ = try w.write("      --cdaudio\t\tuse CD audio if available\n");
        _ = try w.write("      --cdnumber no\tchoose the CD-ROM drive number\n");
        _ = try w.write("  -f, --font file\tset a TTF font file\n");
        _ = try w.write("      --registry file\tset a registry file\n");
        _ = try w.write("      --dll file\tset a dll file\n");
        _ = try w.write("  -r, --root path\tset the root path to the archives\n");
        _ = try w.write("      --fullscreen\tstart in fullscreen mode\n");
        _ = try w.write("      --window\t\tstart in windowed mode\n");
        _ = try w.write("      --force-button-shortcut\tignore useescspc and getenter command\n");
        _ = try w.write("      --enable-wheeldown-advance\tadvance the text on mouse wheel down\n");
        _ = try w.write("      --disable-rescale\tdo not rescale the images in the archives\n");
        _ = try w.write("      --render-font-outline\trender the outline of a text instead of casting a shadow\n");
        _ = try w.write("      --edit\t\tenable online modification of the volume and variables when 'z' is pressed\n");
        _ = try w.write("      --key-exe file\tset a file (*.EXE) that includes a key table\n");
        // _ = try w.write("      --enc:sjis\tuse sjis coding script\n");
        // _ = try w.write("      --debug:1\t\tprint debug info\n");
        _ = try w.write("      --fontcache\tcache default font\n");
        _ = try w.write("  -SW, -HW\t\tuse software or hardware renderer (software renderer is used by default)\n");
        _ = try w.write("  -W,-H\t\toverride window size provided by nscript manually\n");
        _ = try w.write("  -h, --help\t\tshow this help and exit\n");
        _ = try w.write("  -v, --version\t\tshow the version information and exit\n");
        std.process.exit(0);
    }

    if (options.show_version) {
        const w = stdout.writer();
        _ = try w.write("Written by Ogapee <ogapee@aqua.dti2.ne.jp>\n\n");
        _ = try w.write("Copyright (c) 2001-2016 Ogapee.\n(C) 2014-2016 jh10001<jh10001@live.cn>\n");
        std.process.exit(0);
    }
}
