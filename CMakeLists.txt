cmake_policy(SET CMP0048 NEW)
project(Arduino VERSION 1.6.10 LANGUAGES C CXX ASM)
cmake_minimum_required(VERSION 3.5)

add_subdirectory(arduino)

set(CPACK_GENERATOR "ZIP")
set(ARDUINO_VERSION ${Arduino_VERSION_MAJOR}.${Arduino_VERSION_MINOR}.${Arduino_VERSION_PATCH})
set(CPACK_PACKAGE_FILE_NAME Arduino-${ARDUINO_VERSION})
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)

include(CPack)
