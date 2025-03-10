cmake_minimum_required(VERSION 3.16)
project(zenscripter VERSION 0.1.0 LANGUAGES CXX)

find_package(JPEG REQUIRED)
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
	CHARSET_SUPPORT_SOURCES

    src/coding2utf16.cpp
	src/sjis2utf16.cpp
	src/gbk2utf16.cpp
)

set(
	DECODER_SOURCES

	src/DirectReader.cpp
	src/SarReader.cpp
	src/NsaReader.cpp
	${CHARSET_SUPPORT_SOURCES}
)

set(
	SARDEC_SOURCES

	src/sardec.cpp
	src/DirectReader.cpp
	src/SarReader.cpp
	${CHARSET_SUPPORT_SOURCES}
)

set(
	SARCONV_SOURCES

	src/sarconv.cpp
	src/conv_shared.cpp
	src/resize_image.cpp
	src/DirectReader.cpp
	src/SarReader.cpp
	${CHARSET_SUPPORT_SOURCES}
)

set(
	NSADEC_SOURCES

	src/nsadec.cpp
	${DECODER_SOURCES}
)

set(
	NSACONV_SOURCES

	src/nsaconv.cpp
	src/conv_shared.cpp
	src/resize_image.cpp
	${DECODER_SOURCES}
)

set(
    ZENSCRIPTER_SOURCES

	src/ScriptHandler.cpp
	src/ScriptParser.cpp
	src/ScriptParser_command.cpp
	src/onscripter_main.cpp

    ${GUI_SOURCES}
	${DECODER_SOURCES}
)

set(
	DEFS

	"WIN32"
    "UTF8_CAPTION"
    "USE_SDL_RENDERER"
    "_CRT_SECURE_NO_WARNINGS"
    "_CONSOLE"
)

set(
	CFLAGS

	"/EHsc"
	"/W3"
)

add_executable(sardec ${SARDEC_SOURCES})
target_compile_options(sardec PRIVATE ${CFLAGS})
target_compile_definitions(sardec PRIVATE ${DEFS})
target_link_libraries(
	sardec
	PRIVATE
	JPEG::JPEG
	BZip2::BZip2
	$<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static>
	$<IF:$<TARGET_EXISTS:SDL2_image::SDL2_image>,SDL2_image::SDL2_image,SDL2_image::SDL2_image-static>
	$<IF:$<TARGET_EXISTS:SDL2_ttf::SDL2_ttf>,SDL2_ttf::SDL2_ttf,SDL2_ttf::SDL2_ttf-static>
	$<IF:$<TARGET_EXISTS:SDL2_mixer::SDL2_mixer>,SDL2_mixer::SDL2_mixer,SDL2_mixer::SDL2_mixer-static>
)

add_executable(sarconv ${SARCONV_SOURCES})
target_compile_options(sarconv PRIVATE ${CFLAGS})
target_compile_definitions(sarconv PRIVATE ${DEFS})
target_link_libraries(
	sarconv
	PRIVATE
	JPEG::JPEG
	BZip2::BZip2
	$<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static>
	$<IF:$<TARGET_EXISTS:SDL2_image::SDL2_image>,SDL2_image::SDL2_image,SDL2_image::SDL2_image-static>
	$<IF:$<TARGET_EXISTS:SDL2_ttf::SDL2_ttf>,SDL2_ttf::SDL2_ttf,SDL2_ttf::SDL2_ttf-static>
	$<IF:$<TARGET_EXISTS:SDL2_mixer::SDL2_mixer>,SDL2_mixer::SDL2_mixer,SDL2_mixer::SDL2_mixer-static>
)

add_executable(nsadec ${NSADEC_SOURCES})
target_compile_options(nsadec PRIVATE ${CFLAGS})
target_compile_definitions(nsadec PRIVATE ${DEFS})
target_link_libraries(
	nsadec
	PRIVATE
	JPEG::JPEG
	BZip2::BZip2
	$<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static>
	$<IF:$<TARGET_EXISTS:SDL2_image::SDL2_image>,SDL2_image::SDL2_image,SDL2_image::SDL2_image-static>
	$<IF:$<TARGET_EXISTS:SDL2_ttf::SDL2_ttf>,SDL2_ttf::SDL2_ttf,SDL2_ttf::SDL2_ttf-static>
	$<IF:$<TARGET_EXISTS:SDL2_mixer::SDL2_mixer>,SDL2_mixer::SDL2_mixer,SDL2_mixer::SDL2_mixer-static>
)

add_executable(nsaconv ${NSACONV_SOURCES})
target_compile_options(nsaconv PRIVATE ${CFLAGS})
target_compile_definitions(nsaconv PRIVATE ${DEFS})
target_link_libraries(
	nsaconv
	PRIVATE
	JPEG::JPEG
	BZip2::BZip2
	$<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static>
	$<IF:$<TARGET_EXISTS:SDL2_image::SDL2_image>,SDL2_image::SDL2_image,SDL2_image::SDL2_image-static>
	$<IF:$<TARGET_EXISTS:SDL2_ttf::SDL2_ttf>,SDL2_ttf::SDL2_ttf,SDL2_ttf::SDL2_ttf-static>
	$<IF:$<TARGET_EXISTS:SDL2_mixer::SDL2_mixer>,SDL2_mixer::SDL2_mixer,SDL2_mixer::SDL2_mixer-static>
)

add_executable(zenscripter ${ZENSCRIPTER_SOURCES})
target_compile_options(zenscripter PRIVATE ${CFLAGS})
target_compile_definitions(zenscripter PRIVATE ${DEFS})
target_link_libraries(
	zenscripter
	PRIVATE
	BZip2::BZip2
	$<TARGET_NAME_IF_EXISTS:SDL2::SDL2main>
	$<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static>
	$<IF:$<TARGET_EXISTS:SDL2_image::SDL2_image>,SDL2_image::SDL2_image,SDL2_image::SDL2_image-static>
	$<IF:$<TARGET_EXISTS:SDL2_ttf::SDL2_ttf>,SDL2_ttf::SDL2_ttf,SDL2_ttf::SDL2_ttf-static>
	$<IF:$<TARGET_EXISTS:SDL2_mixer::SDL2_mixer>,SDL2_mixer::SDL2_mixer,SDL2_mixer::SDL2_mixer-static>
)
