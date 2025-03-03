const std = @import("std");

const sdl2_root = "vendor/SDL2-2.32.0/x86_64-w64-mingw32/";
const sdl2_include_dir = sdl2_root ++ "include/SDL2/";
const sdl2_library_dir = sdl2_root ++ "lib/";
const sdl2_binary_dir = sdl2_root ++ "bin/";

const sdl2_image_root = "vendor/SDL2_image-2.8.5/x86_64-w64-mingw32/";
const sdl2_image_include_dir = sdl2_image_root ++ "include/SDL2/";
const sdl2_image_library_dir = sdl2_image_root ++ "lib/";
const sdl2_image_binary_dir = sdl2_image_root ++ "bin/";

const sdl2_ttf_root = "vendor/SDL2_ttf-2.24.0/x86_64-w64-mingw32/";
const sdl2_ttf_include_dir = sdl2_ttf_root ++ "include/SDL2/";
const sdl2_ttf_library_dir = sdl2_ttf_root ++ "lib/";
const sdl2_ttf_binary_dir = sdl2_ttf_root ++ "bin/";

const sdl2_mixer_root = "vendor/SDL2_mixer-2.8.1/x86_64-w64-mingw32/";
const sdl2_mixer_include_dir = sdl2_mixer_root ++ "include/SDL2/";
const sdl2_mixer_library_dir = sdl2_mixer_root ++ "lib/";
const sdl2_mixer_binary_dir = sdl2_mixer_root ++ "bin/";

const bz2_root = "vendor/bzip2-dev-1.0.8.0-win-x64/";
const bz2_include_dir = bz2_root;
const bz2_library_dir = bz2_root;
const bz2_binary_dir = "vendor/bzip2-dll-1.0.8.0-win-x64/";

const iconv_root = "vendor/libiconv-for-Windows_prebuilt/";
const iconv_include_dir = iconv_root;
const iconv_library_dir = iconv_root ++ "x64/Release/";
const iconv_binary_dir = iconv_root ++ "x64/Release/";

pub fn build(b: *std.Build) void {
    const decode_sources = &[_][]const u8{
        "src/DirectReader.cpp",
        "src/SarReader.cpp",
        "src/NsaReader.cpp",
        "src/coding2utf16.cpp",
        "src/sjis2utf16.cpp",
        "src/gbk2utf16.cpp",
    };
    const gui_sources = &[_][]const u8{
        "src/ONScripter.cpp",
        "src/ONScripter_animation.cpp",
        "src/ONScripter_command.cpp",
        "src/ONScripter_effect.cpp",
        "src/ONScripter_effect_breakup.cpp",
        "src/ONScripter_event.cpp",
        "src/ONScripter_file.cpp",
        "src/ONScripter_file2.cpp",
        "src/ONScripter_image.cpp",
        "src/ONScripter_lut.cpp",
        "src/ONScripter_rmenu.cpp",
        "src/ONScripter_sound.cpp",
        "src/ONScripter_text.cpp",
        "src/AnimationInfo.cpp",
        "src/FontInfo.cpp",
        "src/DirtyRect.cpp",
        "src/resize_image.cpp",
        "src/ONScripter_directdraw.cpp",
        "src/builtin_dll/layer_snow.cpp",
        "src/builtin_dll/ONScripter_effect_cascade.cpp",
        "src/builtin_dll/ONScripter_effect_trig.cpp",
        "src/builtin_dll/layer_oldmovie.cpp",
    };

    const sources = &[_][]const u8{
        "src/onscripter_main.cpp",
        "src/ScriptHandler.cpp",
        "src/ScriptParser.cpp",
        "src/ScriptParser_command.cpp",
    };
    const exe = b.addExecutable(.{
        .name = "zenscripter",
        .target = b.standardTargetOptions(.{
            .default_target = .{
                .os_tag = .windows,
                .cpu_arch = .x86_64,
                .abi = .gnu,
            },
        }),
        .optimize = b.standardOptimizeOption(.{}),
    });

    exe.linkLibC();
    exe.linkLibCpp();

    for (decode_sources) |src| {
        exe.addCSourceFile(.{ .file = b.path(src) });
    }
    for (gui_sources) |src| {
        exe.addCSourceFile(.{ .file = b.path(src) });
    }
    for (sources) |src| {
        exe.addCSourceFile(.{ .file = b.path(src) });
    }

    exe.defineCMacro("WIN32", "1");
    exe.defineCMacro("UTF8_CAPTION", "1");
    exe.defineCMacro("USE_SDL_RENDERER", "1");
    exe.defineCMacro("_CRT_SECURE_NO_WARNINGS", "1");
    exe.defineCMacro("_CONSOLE", "1");

    exe.addIncludePath(b.path(sdl2_include_dir));
    exe.addIncludePath(b.path(sdl2_image_include_dir));
    exe.addIncludePath(b.path(sdl2_ttf_include_dir));
    exe.addIncludePath(b.path(sdl2_mixer_include_dir));
    exe.addIncludePath(b.path(bz2_include_dir));
    exe.addIncludePath(b.path(iconv_include_dir));

    exe.addLibraryPath(b.path(sdl2_library_dir));
    exe.addLibraryPath(b.path(sdl2_image_library_dir));
    exe.addLibraryPath(b.path(sdl2_ttf_library_dir));
    exe.addLibraryPath(b.path(sdl2_mixer_library_dir));
    exe.addLibraryPath(b.path(bz2_library_dir));
    exe.addLibraryPath(b.path(iconv_library_dir));

    exe.linkSystemLibrary("SDL2.dll");
    exe.linkSystemLibrary("SDL2main");
    exe.linkSystemLibrary("SDL2_image.dll");
    exe.linkSystemLibrary("SDL2_ttf.dll");
    exe.linkSystemLibrary("SDL2_mixer.dll");
    exe.linkSystemLibrary("libbz2");
    exe.linkSystemLibrary("libiconv");

    b.installBinFile(sdl2_binary_dir ++ "SDL2.dll", "SDL2.dll");
    b.installBinFile(sdl2_image_binary_dir ++ "SDL2_image.dll", "SDL2_image.dll");
    b.installBinFile(sdl2_ttf_binary_dir ++ "SDL2_ttf.dll", "SDL2_ttf.dll");
    b.installBinFile(sdl2_mixer_binary_dir ++ "SDL2_mixer.dll", "SDL2_mixer.dll");
    b.installBinFile(bz2_binary_dir ++ "libbz2.dll", "libbz2.dll");
    b.installBinFile(iconv_binary_dir ++ "libiconv.dll", "libiconv.dll");
    b.installArtifact(exe);
}
