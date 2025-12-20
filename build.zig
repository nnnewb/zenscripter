const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .abi = .msvc,
            .cpu_arch = .x86_64,
            .os_tag = .windows,
        },
    });
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "ONScripter",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });

    exe.root_module.addIncludePath(b.path("./deps/SDL-1.2.15/include/"));
    exe.root_module.addIncludePath(b.path("./deps/SDL_image-1.2.12/include/"));
    exe.root_module.addIncludePath(b.path("./deps/SDL_mixer-1.2.12/include/"));
    exe.root_module.addIncludePath(b.path("./deps/SDL_ttf-2.0.11/include/"));
    exe.root_module.addIncludePath(b.path("./deps/lua-5.1.5/etc"));
    exe.root_module.addIncludePath(b.path("./deps/lua-5.1.5/src"));
    exe.root_module.addIncludePath(b.path("./deps/bzip2-dev-1.0.6-win-x64/"));

    exe.root_module.addLibraryPath(b.path("./deps/SDL-1.2.15/lib/x64/"));
    exe.root_module.addLibraryPath(b.path("./deps/SDL_image-1.2.12/lib/x64/"));
    exe.root_module.addLibraryPath(b.path("./deps/SDL_mixer-1.2.12/lib/x64/"));
    exe.root_module.addLibraryPath(b.path("./deps/SDL_ttf-2.0.11/lib/x64/"));
    exe.root_module.addLibraryPath(b.path("./deps/lua-5.1.5/src"));
    exe.root_module.addLibraryPath(b.path("./deps/bzip2-dev-1.0.6-win-x64/"));

    const linkOptions = std.Build.Module.LinkSystemLibraryOptions{
        .preferred_link_mode = .static,
        .needed = true,
    };

    exe.setVerboseLink(true);
    exe.setVerboseCC(true);

    exe.root_module.linkSystemLibrary("SDL", linkOptions);
    exe.root_module.linkSystemLibrary("SDLmain", linkOptions);
    exe.root_module.linkSystemLibrary("SDL_image", linkOptions);
    exe.root_module.linkSystemLibrary("SDL_mixer", linkOptions);
    exe.root_module.linkSystemLibrary("SDL_ttf", linkOptions);
    exe.root_module.linkSystemLibrary("libbz2", linkOptions);
    exe.root_module.linkSystemLibrary("lua51", linkOptions);
    exe.root_module.linkSystemLibrary("winmm", linkOptions);
    exe.root_module.linkSystemLibrary("dxguid", linkOptions);
    // exe.root_module.linkSystemLibrary("msvcrt", linkOptions);
    exe.root_module.linkSystemLibrary("legacy_stdio_definitions", linkOptions);
    for (exe.root_module.link_objects.items) |item| {
        switch (item) {
            .system_lib => |lib| {
                std.debug.print("link library {s}\n", .{lib.name});
            },
            .static_path => |lib| {
                std.debug.print("link static path {s}", .{lib.getPath(b)});
            },
            else => {},
        }
    }

    exe.root_module.addCMacro("_CONSOLE", "");
    exe.root_module.addCMacro("_CONSOLE", "");
    exe.root_module.addCMacro("_CRT_SECURE_NO_WARNINGS", "");
    exe.root_module.addCMacro("UNICODE", "");
    exe.root_module.addCMacro("USE_CDROM", "");
    exe.root_module.addCMacro("USE_LUA", "");
    exe.root_module.addCMacro("USE_OGG_VORBIS", "");
    exe.root_module.addCMacro("UTF8_CAPTION", "");

    exe.root_module.addCSourceFiles(.{
        .files = &[_][]const u8{
            "AnimationInfo.cpp",
            "DirectReader.cpp",
            "DirtyRect.cpp",
            "Encoding.cpp",
            "FontInfo.cpp",
            "LUAHandler.cpp",
            "NsaReader.cpp",
            "ONScripter.cpp",
            "ONScripter_animation.cpp",
            "ONScripter_command.cpp",
            "ONScripter_effect.cpp",
            "ONScripter_effect_breakup.cpp",
            "ONScripter_effect_cascade.cpp",
            "ONScripter_event.cpp",
            "ONScripter_file.cpp",
            "ONScripter_file2.cpp",
            "ONScripter_image.cpp",
            "ONScripter_lut.cpp",
            "onscripter_main.cpp",
            "ONScripter_rmenu.cpp",
            "ONScripter_sound.cpp",
            "ONScripter_text.cpp",
            "resize_image.cpp",
            "SarReader.cpp",
            "ScriptHandler.cpp",
            "ScriptParser.cpp",
            "ScriptParser_command.cpp",
            "sjis2utf16.cpp",
        },
        .language = .cpp,
    });
    b.installArtifact(exe);
}
