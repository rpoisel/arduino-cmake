file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/null.c)

add_executable(firmware
    ${CMAKE_CURRENT_BINARY_DIR}/null.c
)

target_link_libraries(firmware
    user_code
)

set_target_properties(firmware PROPERTIES
    LINKER_LANGUAGE C
)

add_custom_target(
    firmware_eeprom ALL
    COMMAND ${AVR_OBJCOPY} -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $<TARGET_FILE:firmware> $<TARGET_FILE:firmware>.eep
)

add_dependencies(firmware_eeprom firmware)

add_custom_target(
    firmware_hex ALL
    COMMAND ${AVR_OBJCOPY} -O ihex -R .eeprom $<TARGET_FILE:firmware> $<TARGET_FILE:firmware>.hex
)

add_dependencies(firmware_eeprom firmware)
add_dependencies(firmware_hex firmware)

