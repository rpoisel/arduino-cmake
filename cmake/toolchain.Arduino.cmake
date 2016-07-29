include(CMakeForceCompiler)

set(CMAKE_SYSTEM_NAME Arduino)
set(CMAKE_SYSTEM_VERSION 1)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/Modules")

if(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")
    set(USER_HOME $ENV{HOME})
    set(HOST_EXECUTABLE_PREFIX "")
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
    set(USER_HOME $ENV{USERPROFILE})
    set(HOST_EXECUTABLE_SUFFIX ".exe")
else()
    message(FATAL_ERROR Unsupported build platform.)
endif()

set(ARDUINO_DIR "/opt/arduino" CACHE PATH "Path to the Arduino IDE installation")
if (ARDUINO_DIR STREQUAL "")
    message(FATAL_ERROR "ARDUINO_DIR has not been set.")
endif ()

#file(GLOB_RECURSE AVR_C_COMPILERS ${ARDUINO_DIR}/hardware/tools/avr FOLLOW_SYMLINKS avr-gcc${HOST_EXECUTABLE_SUFFIX})
#list(GET AVR_C_COMPILERS 0 AVR_C_COMPILER)
set(AVR_C_COMPILER /opt/arduino/hardware/tools/avr/bin/avr-gcc)

#file(GLOB_RECURSE AVR_CXX_COMPILERS ${ARDUINO_DIR}/hardware/tools/avr FOLLOW_SYMLINKS avr-g++${HOST_EXECUTABLE_SUFFIX})
#list(GET AVR_XTENSA_CXX_COMPILERS 0 AVR_CXX_COMPILER)
set(AVR_CXX_COMPILER /opt/arduino/hardware/tools/avr/bin/avr-g++)

set(AVR_AR /opt/arduino/hardware/tools/avr/bin/avr-gcc-ar)

#file(GLOB_RECURSE AVR_OBJCOPIES ${ARDUINO_DIR}/hardware/tools/avr FOLLOW_SYMLINKS avr-objcopy${HOST_EXECUTABLE_NAME})
#list(GET AVR_OBJCOPIES 0 AVR_OBJCOPY)
set(AVR_OBJCOPY /opt/arduino/hardware/tools/avr/bin/avr-objcopy)

message("Using " ${AVR_C_COMPILER} " C compiler.")
message("Using " ${AVR_CXX_COMPILER} " C++ compiler.")

CMAKE_FORCE_C_COMPILER(${AVR_C_COMPILER} GNU_C)
CMAKE_FORCE_CXX_COMPILER(${AVR_CXX_COMPILER} GNU_CXX)
set(CMAKE_ASM_COMPILER ${AVR_C_COMPILER})
set(CMAKE_AR ${AVR_AR} CACHE STRING "ar Library archiver" FORCE)
set(CMAKE_RANLIB "ls" CACHE STRING "ranlib Library archiver" FORCE)

SET(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <OBJECTS>")
SET(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <OBJECTS>")

set(CMAKE_BUILD_TYPE Release CACHE STRING "")

SET(AVR_ASM_FLAGS "-x assembler-with-cpp -flto")
SET(CMAKE_ASM_FLAGS "${CFLAGS} ${AVR_ASM_FLAGS}" )

set(CMAKE_C_FLAGS "-g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p" CACHE STRING "")
#set(CMAKE_C_FLAGS_DEBUG " -Og -ggdb3 -DUSE_GDBSTUB" CACHE STRING "")
#set(CMAKE_C_FLAGS_RELEASE " -Os -g" CACHE STRING "")

set(CMAKE_CXX_FLAGS "-g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -flto -mmcu=atmega328p" CACHE STRING "")
#set(CMAKE_CXX_FLAGS_DEBUG "-Og -ggdb3 -DUSE_GDBSTUB" CACHE STRING "")
#set(CMAKE_CXX_FLAGS_RELEASE "-Os -g" CACHE STRING "")

set(CMAKE_EXE_LINKER_FLAGS "-w -Os -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p")

set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> -o <TARGET> -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -o <TARGET> -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")

