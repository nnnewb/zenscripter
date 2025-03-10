cmake_minimum_required(VERSION 3.16)
project(zenscripter VERSION 0.1.0 LANGUAGES CXX)

find_package(BZip2 REQUIRED)
find_package(SDL2 CONFIG REQUIRED)
find_package(SDL2_image CONFIG REQUIRED)
find_package(SDL2_ttf CONFIG REQUIRED)
find_package(SDL2_mixer CONFIG REQUIRED)

set(
    GUI_SOURCES
    ONScripter.cpp
	ONScripter_animation.cpp
	ONScripter_command.cpp
	ONScripter_effect.cpp
	ONScripter_effect_breakup.cpp
	ONScripter_event.cpp
	ONScripter_file.cpp
	ONScripter_file2.cpp
	ONScripter_image.cpp
	ONScripter_lut.cpp
	ONScripter_rmenu.cpp
	ONScripter_sound.cpp
	ONScripter_text.cpp
	AnimationInfo.cpp
	FontInfo.cpp
	DirtyRect.cpp
	resize_image.cpp
	ONScripter_directdraw.cpp
	builtin_dll/layer_snow.cpp
	builtin_dll/ONScripter_effect_cascade.cpp
	builtin_dll/ONScripter_effect_trig.cpp
	builtin_dll/layer_oldmovie.cpp
)

set(
    ZENSCRIPTER_SOURCES
    ${GUI_SOURCES}

    coding2utf16.cpp
	sjis2utf16.cpp
	gbk2utf16.cpp

	DirectReader.cpp
	SarReader.cpp
	NsaReader.cpp

	onscripter_main.cpp
	ScriptHandler.cpp
	ScriptParser.cpp
	ScriptParser_command.cpp
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