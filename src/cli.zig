const std = @import("std");
const mem = std.mem;
const io = std.io;
const fmt = std.fmt;

pub const AccelerateMode = enum(u8) {
    software,
    hardware,
};

pub const CommandLineOptions = struct {
    acceleration_mode: AccelerateMode = .hardware,
    width: u32 = 0,
    height: u32 = 0,
    cd_audio: bool = false,
    cd_number: ?u8 = null,
    font: ?[]const u8 = null,
    registry: ?[]const u8 = null,
    dll: ?[]const u8 = null,
    root: ?[]const u8 = null,
    fullscreen: bool = false,
    window: bool = false,
    force_button_shortcut: bool = false,
    enable_wheeldown_advance: bool = false,
    disable_rescale: bool = false,
    render_font_outline: bool = false,
    edit: bool = false,
    key_exe: ?[]const u8 = null,
};

pub fn parseCommandLineOptions(iter: *std.process.ArgIterator) !CommandLineOptions {
    var it: ArgIterator(std.process.ArgIterator) = .{
        .inner = iter,
        .nextFn = std.process.ArgIterator.next,
        .skipFn = std.process.ArgIterator.skip,
        .deinitFn = std.process.ArgIterator.deinit,
    };
    return parseCommandLineOptionsInner(&it);
}

fn ArgIterator(comptime T: type) type {
    return struct {
        inner: ?*T,
        nextFn: *const fn (self: *T) ?([:0]const u8),
        skipFn: *const fn (self: *T) bool,
        deinitFn: *const fn (self: *T) void,

        const Self = @This();

        pub fn next(self: *Self) ?([:0]const u8) {
            return self.nextFn(self.inner.?);
        }

        pub fn skip(self: *Self) bool {
            return self.skipFn(self.inner.?);
        }

        pub fn deinit(self: *Self) void {
            self.deinitFn(self.inner.?);
            self.inner = null;
        }
    };
}

fn parseCommandLineOptionsInner(iter: *ArgIterator(std.process.ArgIterator)) !CommandLineOptions {
    var options: CommandLineOptions = .{};
    while (iter.next()) |arg| {
        std.log.debug("arg {s}", .{arg});

        const stdout = io.getStdOut().writer();
        if (mem.eql(u8, arg, "--help") or mem.eql(u8, arg, "-h")) {
            _ = try stdout.write("Usage: onscripter [option ...]\n");
            _ = try stdout.write("      --cdaudio\t\tuse CD audio if available\n");
            _ = try stdout.write("      --cdnumber no\tchoose the CD-ROM drive number\n");
            _ = try stdout.write("  -f, --font file\tset a TTF font file\n");
            _ = try stdout.write("      --registry file\tset a registry file\n");
            _ = try stdout.write("      --dll file\tset a dll file\n");
            _ = try stdout.write("  -r, --root path\tset the root path to the archives\n");
            _ = try stdout.write("      --fullscreen\tstart in fullscreen mode\n");
            _ = try stdout.write("      --window\t\tstart in windowed mode\n");
            _ = try stdout.write("      --force-button-shortcut\tignore useescspc and getenter command\n");
            _ = try stdout.write("      --enable-wheeldown-advance\tadvance the text on mouse wheel down\n");
            _ = try stdout.write("      --disable-rescale\tdo not rescale the images in the archives\n");
            _ = try stdout.write("      --render-font-outline\trender the outline of a text instead of casting a shadow\n");
            _ = try stdout.write("      --edit\t\tenable online modification of the volume and variables when 'z' is pressed\n");
            _ = try stdout.write("      --key-exe file\tset a file (*.EXE) that includes a key table\n");
            _ = try stdout.write("      --enc:sjis\tuse sjis coding script\n");
            _ = try stdout.write("      --debug:1\t\tprint debug info\n");
            _ = try stdout.write("      --fontcache\tcache default font\n");
            _ = try stdout.write("  -SW, -HW\t\tuse software or hardware renderer (software renderer is used by default)\n");
            _ = try stdout.write("  -W,-H\t\toverride window size provided by nscript manually\n");
            _ = try stdout.write("  -h, --help\t\tshow this help and exit\n");
            _ = try stdout.write("  -v, --version\t\tshow the version information and exit\n");
        } else if (mem.eql(u8, arg, "-v") or mem.eql(u8, arg, "--version")) {
            _ = try stdout.write("Written by Ogapee <ogapee@aqua.dti2.ne.jp>\n\n");
            _ = try stdout.write("Copyright (c) 2001-2016 Ogapee.\n(C) 2014-2016 jh10001<jh10001@live.cn>\n");
        } else if (mem.eql(u8, arg, "--HW")) {
            options.acceleration_mode = .hardware;
            std.log.debug("set acceleration mode: hardware", .{});
        } else if (mem.eql(u8, arg, "--SW")) {
            options.acceleration_mode = .software;
            std.log.debug("set acceleration mode: software", .{});
        } else if (mem.eql(u8, arg, "-H")) {
            if (iter.next()) |n| {
                options.height = try fmt.parseInt(u32, n, 0);
                std.log.debug("set height: {d}", .{options.height});
            } else {
                std.log.err("-H option requires a value", .{});
            }
        } else if (mem.eql(u8, arg, "-W")) {
            if (iter.next()) |n| {
                options.width = try fmt.parseInt(u32, n, 0);
                std.log.debug("set width: {d}", .{options.width});
            } else {
                std.log.err("-W option requires a value", .{});
            }
        } else if (mem.eql(u8, arg, "--cdaudio")) {
            options.cd_audio = true;
            std.log.debug("enable cd audio", .{});
        } else if (mem.eql(u8, arg, "--cdnumber")) {
            if (iter.next()) |n| {
                options.cd_number = try fmt.parseInt(u8, n, 0);
                std.log.debug("set cd number: {d}", .{options.width});
            } else {
                std.log.err("--cdnumber option requires a value", .{});
            }
        } else if (mem.eql(u8, arg, "-f") or mem.eql(u8, arg, "--font")) {
            if (iter.next()) |n| {
                options.font = n;
                std.log.debug("set font: {?s}", .{options.font});
            } else {
                std.log.err("-f/--font option requires a value", .{});
            }
        } else if (mem.eql(u8, arg, "--registry")) {
            if (iter.next()) |n| {
                options.registry = n;
                std.log.debug("set registry: {?s}", .{options.registry});
            } else {
                std.log.err("--registry option requires a value", .{});
            }
        } else if (mem.eql(u8, arg, "--dll")) {
            if (iter.next()) |n| {
                options.dll = n;
                std.log.debug("set dll: {?s}", .{options.dll});
            } else {
                std.log.err("--dll option requires a value", .{});
            }
        } else if (mem.eql(u8, arg, "-r") or mem.eql(u8, arg, "--root")) {
            if (iter.next()) |n| {
                options.root = n;
                std.log.debug("set root: {?s}", .{options.root});
            } else {
                std.log.err("-r/--root option requires a value", .{});
            }
        } else if (mem.eql(u8, arg, "--fullscreen")) {
            options.fullscreen = true;
            std.log.debug("enable fullscreen", .{});
        } else if (mem.eql(u8, arg, "--window")) {
            options.window = true;
            std.log.debug("enable windowed mode", .{});
        } else if (mem.eql(u8, arg, "--force-button-shortcut")) {
            options.force_button_shortcut = true;
            std.log.debug("enable force button shortcut", .{});
        } else if (mem.eql(u8, arg, "--enable-wheeldown-advance")) {
            options.enable_wheeldown_advance = true;
            std.log.debug("enable wheeldown advance", .{});
        } else if (mem.eql(u8, arg, "--disable-rescale")) {
            options.disable_rescale = true;
            std.log.debug("disable rescale", .{});
        } else if (mem.eql(u8, arg, "--render-font-outline")) {
            options.render_font_outline = true;
            std.log.debug("enable render font outline", .{});
        } else if (mem.eql(u8, arg, "--edit")) {
            options.edit = true;
            std.log.debug("enable edit mode", .{});
        } else if (mem.eql(u8, arg, "--key-exe")) {
            if (iter.next()) |n| {
                options.key_exe = n;
                std.log.debug("set key exe: {?s}", .{options.key_exe});
            } else {
                std.log.err("--key-exe option requires a value", .{});
            }
        }
    }
    return options;
}

const MockArgIterator = struct {
    args: [*]const []const u8,
    current: usize,

    fn init(args: [*]const []const u8) MockArgIterator {
        return .{
            .args = args,
            .current = 0,
        };
    }
};

test "aaaa" {
    const it = MockArgIterator.init(&[_][]const u8{"hello"});
    _ = it;
}
