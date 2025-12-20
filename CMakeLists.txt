cmake_minimum_required(VERSION 3.10)
project(ONScripter)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SOURCES
    AnimationInfo.cpp
    DirectReader.cpp
    DirtyRect.cpp
    Encoding.cpp
    FontInfo.cpp
    LUAHandler.cpp
    NsaReader.cpp
    ONScripter.cpp
    ONScripter_animation.cpp
    ONScripter_command.cpp
    ONScripter_effect.cpp
    ONScripter_effect_breakup.cpp
    ONScripter_effect_cascade.cpp
    ONScripter_event.cpp
    ONScripter_file.cpp
    ONScripter_file2.cpp
    ONScripter_image.cpp
    ONScripter_lut.cpp
    onscripter_main.cpp
    ONScripter_rmenu.cpp
    ONScripter_sound.cpp
    ONScripter_text.cpp
    resize_image.cpp
    SarReader.cpp
    ScriptHandler.cpp
    ScriptParser.cpp
    ScriptParser_command.cpp
    sjis2utf16.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})

set(
    ${PROJECT_NAME}_INCLUDE_DIRS
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL-1.2.15/include/
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_image-1.2.12/include/
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/include/
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_ttf-2.0.11/include/
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/lua-5.1.5/etc
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/lua-5.1.5/src
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/bzip2-dev-1.0.6-win-x64/
)

set(
    ${PROJECT_NAME}_LIBRARY_DIRS
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL-1.2.15/lib/x64/
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_image-1.2.12/lib/x64/
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/lib/x64/
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_ttf-2.0.11/lib/x64/
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/lua-5.1.5/src
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/bzip2-dev-1.0.6-win-x64/
)

foreach(item IN LISTS ${PROJECT_NAME}_INCLUDE_DIRS)
    message(CHECK_START "check ${item}")
    if(NOT EXISTS "${item}")
        message(CHECK_FAIL "not found")
    else()
        message(CHECK_PASS "found")
    endif()
endforeach()

target_include_directories(
    ${PROJECT_NAME}
    PRIVATE
    ${${PROJECT_NAME}_INCLUDE_DIRS}
)

foreach(item IN LISTS ${PROJECT_NAME}_LIBRARY_DIRS)
    message(CHECK_START "check ${item}")
    if(NOT EXISTS "${item}")
        message(CHECK_FAIL "not found")
    else()
        message(CHECK_PASS "found")
    endif()
endforeach()

target_link_directories(
    ${PROJECT_NAME}
    PRIVATE
    ${${PROJECT_NAME}_LIBRARY_DIRS}
)

target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
    SDL
    SDLmain
    SDL_image
    SDL_mixer
    SDL_ttf
    libbz2
    lua51
    winmm
    dxguid
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    WIN32
    _CONSOLE
    _CRT_SECURE_NO_WARNINGS
    UNICODE
    USE_CDROM
    USE_LUA
    USE_OGG_VORBIS
    UTF8_CAPTION
)

# 设置编译选项
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(${PROJECT_NAME} PRIVATE
        /nologo
        /Od
        /Zi
        /W3
        /EHsc
    )
    target_compile_definitions(${PROJECT_NAME} PRIVATE _DEBUG)
    target_link_options(
        ${PROJECT_NAME}
        PRIVATE
        /nologo
        /nodefaultlib:libc
        /nodefaultlib:msvcrt
    )
else()
    target_compile_options(${PROJECT_NAME} PRIVATE
        /nologo
        /O2
        /Ob2
        /W3
        /EHsc
    )
    target_compile_definitions(${PROJECT_NAME} PRIVATE NDEBUG)
    target_link_options(
        ${PROJECT_NAME}
        PRIVATE
        /nologo
        /nodefaultlib:libc
        /nodefaultlib:msvcrt
    )
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set_property(TARGET ${PROJECT_NAME} PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreadedDebug"
    )
else()
    set_property(TARGET ${PROJECT_NAME} PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded"
    )
endif()

set(
    ${PROJECT_NAME}_RUNTIME_DLLS
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL-1.2.15/lib/x64/SDL.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_image-1.2.12/lib/x64/libjpeg-8.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_image-1.2.12/lib/x64/libpng15-15.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_image-1.2.12/lib/x64/libtiff-5.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_image-1.2.12/lib/x64/libwebp-2.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_image-1.2.12/lib/x64/SDL_image.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_image-1.2.12/lib/x64/zlib1.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/lib/x64/libFLAC-8.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/lib/x64/libmikmod-2.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/lib/x64/libogg-0.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/lib/x64/libvorbis-0.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/lib/x64/libvorbisfile-3.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/lib/x64/SDL_mixer.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_mixer-1.2.12/lib/x64/smpeg.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_ttf-2.0.11/lib/x64/libfreetype-6.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/SDL_ttf-2.0.11/lib/x64/SDL_ttf.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/lua-5.1.5/src/lua51.dll
    ${CMAKE_CURRENT_SOURCE_DIR}/deps/bzip2-dev-1.0.6-win-x64/libbz2.dll
)

foreach(item IN LISTS ${PROJECT_NAME}_RUNTIME_DLLS)
    add_custom_command(
        TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy -t "$<TARGET_FILE_DIR:${PROJECT_NAME}>" "${item}"
        COMMENT "Copying ${item} for ${PROJECT_NAME}"
        VERBATIM
    )
endforeach()
