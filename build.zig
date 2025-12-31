const std = @import("std");

const Compile = std.Build.Step.Compile;
const ResolvedTarget = std.Build.ResolvedTarget;
const OptimizeMode = std.builtin.OptimizeMode;

const include_paths: []const []const u8 = &.{
    "./deps/SDL-1.2.15/include/",
    "./deps/SDL_image-1.2.12/include/",
    "./deps/SDL_mixer-1.2.12/include/",
    "./deps/SDL_ttf-2.0.11/include/",
    "./deps/lua-5.1.5/etc",
    "./deps/lua-5.1.5/src",
    "./deps/bzip2-dev-1.0.6-win-x64/",
};

const library_paths: []const []const u8 = &.{
    "./deps/SDL-1.2.15/lib/x64/",
    "./deps/SDL_image-1.2.12/lib/x64/",
    "./deps/SDL_mixer-1.2.12/lib/x64/",
    "./deps/SDL_ttf-2.0.11/lib/x64/",
    "./deps/lua-5.1.5/src",
    "./deps/bzip2-dev-1.0.6-win-x64/",
};

const link_libraries: []const []const u8 = &.{
    "SDL",
    "SDL_image",
    "SDL_mixer",
    "SDL_ttf",
    "libbz2",
    "lua51",
};

const dll_dependencies: []const []const u8 = &.{
    "./deps/SDL-1.2.15/lib/x64/SDL.dll",
    "./deps/SDL_image-1.2.12/lib/x64/libjpeg-8.dll",
    "./deps/SDL_image-1.2.12/lib/x64/libpng15-15.dll",
    "./deps/SDL_image-1.2.12/lib/x64/libtiff-5.dll",
    "./deps/SDL_image-1.2.12/lib/x64/libwebp-2.dll",
    "./deps/SDL_image-1.2.12/lib/x64/SDL_image.dll",
    "./deps/SDL_image-1.2.12/lib/x64/zlib1.dll",
    "./deps/SDL_mixer-1.2.12/lib/x64/libFLAC-8.dll",
    "./deps/SDL_mixer-1.2.12/lib/x64/libmikmod-2.dll",
    "./deps/SDL_mixer-1.2.12/lib/x64/libogg-0.dll",
    "./deps/SDL_mixer-1.2.12/lib/x64/libvorbis-0.dll",
    "./deps/SDL_mixer-1.2.12/lib/x64/libvorbisfile-3.dll",
    "./deps/SDL_mixer-1.2.12/lib/x64/SDL_mixer.dll",
    "./deps/SDL_mixer-1.2.12/lib/x64/smpeg.dll",
    "./deps/SDL_ttf-2.0.11/lib/x64/libfreetype-6.dll",
    "./deps/SDL_ttf-2.0.11/lib/x64/SDL_ttf.dll",
    "./deps/lua-5.1.5/src/lua51.dll",
    "./deps/bzip2-dev-1.0.6-win-x64/libbz2.dll",
};

const KeyValue = struct {
    key: []const u8,
    value: []const u8,
};

const c_macros: []const KeyValue = &.{
    .{ .key = "_CONSOLE", .value = "" },
    .{ .key = "_CRT_SECURE_NO_WARNINGS", .value = "" },
    .{ .key = "UNICODE", .value = "" },
    .{ .key = "USE_CDROM", .value = "" },
    .{ .key = "USE_LUA", .value = "" },
    .{ .key = "USE_OGG_VORBIS", .value = "" },
    .{ .key = "UTF8_CAPTION", .value = "" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zenscripter",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });

    for (include_paths) |inc| {
        exe.root_module.addIncludePath(b.path(inc));
    }

    for (library_paths) |lib| {
        exe.root_module.addLibraryPath(b.path(lib));
    }

    const linkOptions = std.Build.Module.LinkSystemLibraryOptions{
        .preferred_link_mode = .static,
        .needed = true,
    };

    for (link_libraries) |lib| {
        exe.root_module.linkSystemLibrary(lib, linkOptions);
    }

    for (c_macros) |macro| {
        exe.root_module.addCMacro(macro.key, macro.value);
    }

    b.installArtifact(exe);
    for (dll_dependencies) |dep| {
        b.installBinFile(dep, std.fs.path.basename(dep));
    }
}
