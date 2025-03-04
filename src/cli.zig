const std = @import("std");
const mem = std.mem;
const io = std.io;
const fmt = std.fmt;

pub const AccelerateMode = enum(u8) {
    software,
    hardware,
};

pub const CommandLineOptions = struct {
    show_help: bool = false,
    show_version: bool = false,
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
    font_cache: bool = false,
};

pub fn parseCommandLineOptions(iter: *std.process.ArgIterator) !CommandLineOptions {
    var it: ArgIterator(std.process.ArgIterator) = .{
        .inner = iter,
        .nextFn = std.process.ArgIterator.next,
        .skipFn = std.process.ArgIterator.skip,
        .deinitFn = std.process.ArgIterator.deinit,
    };
    return parseCommandLineOptionsInner(std.process.ArgIterator, &it);
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

fn parseCommandLineOptionsInner(comptime T: type, iter: *ArgIterator(T)) !CommandLineOptions {
    var options: CommandLineOptions = .{};
    while (iter.next()) |arg| {
        std.log.debug("arg {s}", .{arg});

        if (mem.eql(u8, arg, "--help") or mem.eql(u8, arg, "-h")) {
            options.show_help = true;
            std.log.debug("show help", .{});
        } else if (mem.eql(u8, arg, "-v") or mem.eql(u8, arg, "--version")) {
            options.show_version = true;
            std.log.debug("show version", .{});
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
        } else if (mem.eql(u8, arg, "--fontcache")) {
            options.font_cache = true;
            std.log.debug("enable font cache", .{});
        }
    }
    return options;
}

const MockArgIterator = struct {
    args: []const [:0]const u8,
    current: usize,

    fn init(args: []const [:0]const u8) MockArgIterator {
        return .{
            .args = args,
            .current = 0,
        };
    }

    pub fn next(self: *MockArgIterator) ?[:0]const u8 {
        if (self.current >= self.args.len) return null;
        defer self.current += 1;
        return self.args[self.current];
    }

    pub fn skip(self: *MockArgIterator) bool {
        if (self.current >= self.args.len) {
            return false;
        }
        defer self.current += 1;
        return true;
    }

    pub fn deinit(self: *MockArgIterator) void {
        _ = self;
    }

    pub fn arg_iterator(self: *MockArgIterator) ArgIterator(MockArgIterator) {
        return .{
            .inner = self,
            .nextFn = MockArgIterator.next,
            .skipFn = MockArgIterator.skip,
            .deinitFn = MockArgIterator.deinit,
        };
    }
};

test "-HW option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--HW",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(.hardware, options.acceleration_mode);
}

test "-SW option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--SW",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(.software, options.acceleration_mode);
}

test "-H option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "-H",
        "1080",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(@as(u32, 1080), options.height);
}

test "-W option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "-W",
        "1920",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(@as(u32, 1920), options.width);
}

test "--fontcache option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--fontcache",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.font_cache);
}

test "--key-exe option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--key-exe",
        "keyfile.exe",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqualStrings("keyfile.exe", options.key_exe.?);
}

test "--edit option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--edit",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.edit);
}

test "--render-font-outline option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--render-font-outline",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.render_font_outline);
}

test "--disable-rescale option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--disable-rescale",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.disable_rescale);
}

test "--enable-wheeldown-advance option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--enable-wheeldown-advance",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.enable_wheeldown_advance);
}

test "--force-button-shortcut option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--force-button-shortcut",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.force_button_shortcut);
}

test "--window option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--window",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.window);
}

test "--fullscreen option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--fullscreen",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.fullscreen);
}

test "-r/--root option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "-r",
        "root/path",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqualStrings("root/path", options.root.?);
}

test "--dll option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--dll",
        "library.dll",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqualStrings("library.dll", options.dll.?);
}

test "--registry option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--registry",
        "registry.reg",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqualStrings("registry.reg", options.registry.?);
}

test "-f/--font option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "-f",
        "font.ttf",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqualStrings("font.ttf", options.font.?);
}

test "--cdnumber option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--cdnumber",
        "1",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(@as(?u8, 1), options.cd_number);
}

test "--cdaudio option" {
    var mock_args = [_][:0]const u8{
        "zenscripter",
        "--cdaudio",
    };
    var mock_it = MockArgIterator.init(&mock_args);
    var it = mock_it.arg_iterator();

    const options = try parseCommandLineOptionsInner(MockArgIterator, &it);
    try std.testing.expectEqual(true, options.cd_audio);
}
