cmake_minimum_required(VERSION 3.16)
project(zenscripter VERSION 0.1.0 LANGUAGES CXX)

find_package(BZip2 REQUIRED)
find_package(SDL2 CONFIG REQUIRED)
find_package(SDL2_image CONFIG REQUIRED)
find_package(SDL2_ttf CONFIG REQUIRED)
find_package(SDL2_mixer CONFIG REQUIRED)

set(
    sources 
    cpp/ONScripter.cpp 
	cpp/ONScripter_animation.cpp 
	cpp/ONScripter_command.cpp 
	cpp/ONScripter_effect.cpp 
	cpp/ONScripter_effect_breakup.cpp 
	cpp/ONScripter_event.cpp 
	cpp/ONScripter_file.cpp 
	cpp/ONScripter_file2.cpp 
	cpp/ONScripter_image.cpp 
	cpp/ONScripter_lut.cpp 
	cpp/ONScripter_rmenu.cpp 
	cpp/ONScripter_sound.cpp 
	cpp/ONScripter_text.cpp 
	cpp/AnimationInfo.cpp 
	cpp/FontInfo.cpp 
	cpp/DirtyRect.cpp 
	cpp/resize_image.cpp 
	cpp/ONScripter_directdraw.cpp 
	cpp/builtin_dll/layer_snow.cpp 
	cpp/builtin_dll/ONScripter_effect_cascade.cpp 
	cpp/builtin_dll/ONScripter_effect_trig.cpp 
	cpp/builtin_dll/layer_oldmovie.cpp

    cpp/coding2utf16.cpp 
	cpp/sjis2utf16.cpp 
	cpp/gbk2utf16.cpp

	cpp/DirectReader.cpp
	cpp/SarReader.cpp
	cpp/NsaReader.cpp

	cpp/onscripter_main.cpp
	cpp/ScriptHandler.cpp
	cpp/ScriptParser.cpp
	cpp/ScriptParser_command.cpp
)
add_executable(zenscripter ${sources})
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