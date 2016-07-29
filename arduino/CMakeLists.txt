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
    ${ARDUINO_AVR_DIR}/cores/arduino
    ${ARDUINO_AVR_DIR}/variants/standard
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
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY ${ARDUINO_AVR_DIR}/cores/arduino/
    DESTINATION h
    FILES_MATCHING PATTERN "*.h"
)

