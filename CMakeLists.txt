cmake_minimum_required(VERSION 3.5)

cmake_policy(SET CMP0048 NEW)
project(ArduinoBuild VERSION 0.9.0 LANGUAGES C CXX ASM)

add_subdirectory(arduino)

if (EXISTS "${ARDUINO_AVR_DIR}/platform.txt")
    file(STRINGS "${ARDUINO_AVR_DIR}/platform.txt" VERSION_LINES REGEX "^version=")
    if (VERSION_LINES)
        string(REGEX MATCH "[0-9]+\.[0-9]+\.[0-9]+" ARDUINO_VERSION ${VERSION_LINES})
    endif ()
endif ()

set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_FILE_NAME Arduino-${ARDUINO_VERSION})
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)

include(CPack)
