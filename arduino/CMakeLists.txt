set(ARDUINO_AVR_DIR ${ARDUINO_DIR}/hardware/arduino/avr CACHE PATH "Path to the directory containing AVR specific arduino files")
if (ARDUINO_AVR_DIR STREQUAL "")
    message(FATAL_ERROR "ARDUINO_AVR_DIR has not been set.")
endif ()

file(GLOB_RECURSE ARDUINO_SRC
    ${ARDUINO_AVR_DIR}/cores/arduino/*.c
    ${ARDUINO_AVR_DIR}/cores/arduino/*.cpp
)

file(GLOB ARDUINO_SRC_ASM
    ${ARDUINO_AVR_DIR}/cores/arduino/*.S
)

set_source_files_properties(${ARDUINO_SRC_ASM} PROPERTIES
    LANGUAGE ASM
    COMPILE_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG}"
)

add_library(arduino STATIC
    ${ARDUINO_SRC}
    ${ARDUINO_SRC_ASM}
)

target_include_directories(arduino PUBLIC
    $<INSTALL_INTERFACE:h>
    $<INSTALL_INTERFACE:h/variants/standard>
    $<BUILD_INTERFACE:${ARDUINO_AVR_DIR}/cores/arduino>
    $<BUILD_INTERFACE:${ARDUINO_AVR_DIR}/variants/standard>
)

target_compile_definitions(arduino PUBLIC
    -DF_CPU=16000000L
    -DARDUINO=10610
    -DARDUINO_AVR_NANO
    -DARDUINO_ARCH_AVR
)

target_link_libraries(arduino PUBLIC
    m
    gcc
)

install(TARGETS arduino
    EXPORT arduino-targets
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY ${ARDUINO_AVR_DIR}/cores/arduino/
    DESTINATION h
    FILES_MATCHING PATTERN "*.h"
)

install(DIRECTORY ${ARDUINO_AVR_DIR}/variants/standard/
    DESTINATION h/variants/standard
    FILES_MATCHING PATTERN "*.h"
)

install(EXPORT arduino-targets DESTINATION cmake)

configure_file(${CMAKE_CURRENT_LIST_DIR}/cmake/arduino-config-version.cmake.in ${CMAKE_BINARY_DIR}/arduino-config-version.cmake @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/arduino-config-version.cmake DESTINATION cmake)
install(DIRECTORY cmake/ DESTINATION cmake FILES_MATCHING PATTERN "*.cmake")
