cmake_minimum_required(VERSION 3.16)
project(zenscripter VERSION 0.1.0 LANGUAGES CXX)

find_package(BZip2 REQUIRED)
find_package(SDL2 CONFIG REQUIRED)
find_package(SDL2_image CONFIG REQUIRED)
find_package(SDL2_ttf CONFIG REQUIRED)
find_package(SDL2_mixer CONFIG REQUIRED)

set(
    GUI_SOURCES
    src/ONScripter.cpp
	src/ONScripter_animation.cpp
	src/ONScripter_command.cpp
	src/ONScripter_effect.cpp
	src/ONScripter_effect_breakup.cpp
	src/ONScripter_event.cpp
	src/ONScripter_file.cpp
	src/ONScripter_file2.cpp
	src/ONScripter_image.cpp
	src/ONScripter_lut.cpp
	src/ONScripter_rmenu.cpp
	src/ONScripter_sound.cpp
	src/ONScripter_text.cpp
	src/AnimationInfo.cpp
	src/FontInfo.cpp
	src/DirtyRect.cpp
	src/resize_image.cpp
	src/ONScripter_directdraw.cpp
	src/builtin_dll/layer_snow.cpp
	src/builtin_dll/ONScripter_effect_cascade.cpp
	src/builtin_dll/ONScripter_effect_trig.cpp
	src/builtin_dll/layer_oldmovie.cpp
)

set(
    ZENSCRIPTER_SOURCES
    ${GUI_SOURCES}

    src/coding2utf16.cpp
	src/sjis2utf16.cpp
	src/gbk2utf16.cpp

	src/DirectReader.cpp
	src/SarReader.cpp
	src/NsaReader.cpp

	src/ScriptHandler.cpp
	src/ScriptParser.cpp
	src/ScriptParser_command.cpp
	src/onscripter_main.cpp
)
add_executable(zenscripter ${ZENSCRIPTER_SOURCES})
target_link_libraries(
	zenscripter
	PRIVATE
	$<TARGET_NAME_IF_EXISTS:SDL2::SDL2main>
	$<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static>
	PRIVATE
	$<IF:$<TARGET_EXISTS:SDL2_image::SDL2_image>,SDL2_image::SDL2_image,SDL2_image::SDL2_image-static>
	PRIVATE
	BZip2::BZip2
	PRIVATE
	$<IF:$<TARGET_EXISTS:SDL2_ttf::SDL2_ttf>,SDL2_ttf::SDL2_ttf,SDL2_ttf::SDL2_ttf-static>
	PRIVATE
	$<IF:$<TARGET_EXISTS:SDL2_mixer::SDL2_mixer>,SDL2_mixer::SDL2_mixer,SDL2_mixer::SDL2_mixer-static>
)
target_compile_definitions(
    zenscripter
    PRIVATE "WIN32"
    PRIVATE "UTF8_CAPTION"
    PRIVATE "USE_SDL_RENDERER"
    PRIVATE "_CRT_SECURE_NO_WARNINGS"
    PRIVATE "_CONSOLE"
)