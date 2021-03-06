## Define here all the build options specific for the board
## along with definitions for the libraries

## Kiso configuration
# MCU configuration for this board
set(KISO_MCU_FAMILY efm32)
set(KISO_MCU_SERIES efm32gg)
# set(KISO_MCU_TYPE   x) # Not applicable for board
set(KISO_MCU_DEVICE EFM32GG390F1024)
# set(KISO_MCU_REVISION x) # Not applicable for board

# GCC portmacro to use in freertos
set(KISO_MCU_CORE ARM_CM3)

# Additional thirdparty libraries for the board
set(KISO_BOARD_LIBS emlib)

## Libs configuration
# Add usb to emlib
set(EMLIB_INCLUDE_USB 1)

## Board definitions
# Compile definitions for all subprojects after this call
add_definitions(
   -DKISO_PACKAGE_ID=0
   -D${KISO_MCU_TYPE}
   -D${KISO_MCU_FAMILY}
   -D${KISO_MCU_DEVICE}
   -DARM_MATH_CM3
)

if(${CMAKE_CROSSCOMPILING} AND "${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
   ## Compiler and linker configuration
   # GCC options common to compiler and linker
   set(BOARD_COMMON_OPTIONS
      -march=armv7-m
      -mtune=cortex-m3
      -mfloat-abi=soft
      -mthumb
   )

   # Enable some warnings, debug symbols and set optimization level
   add_compile_options(
      ${BOARD_COMMON_OPTIONS}
      -ffunction-sections
      -fdata-sections
      -Wall
      -Wextra
      -Wmissing-prototypes
      -Wstrict-prototypes
      -O0
      -g
   )

   # Use board-specific linkerfile and put system libs in their own section
   # CMake 3.13 and up has add_link_options which does the same as this hack
   set(BOARD_LINKER_FLAGS
      ${BOARD_COMMON_OPTIONS}
      -T${CMAKE_CURRENT_LIST_DIR}/efm32gg_new.ld
      --specs=nosys.specs
      -Xlinker
      -Map=out.map
      -Wl,--gc-sections
      -Wl,--start-group
      -lgcc
      -lc
      -lm
      -Wl,--end-group
      -Wl,-u,_printf_float
   )
   # Join the items on the list separated by a space and write the result in CMAKE_EXE_LINKER_FLAGS
   string(REPLACE ";" " " CMAKE_EXE_LINKER_FLAGS "${BOARD_LINKER_FLAGS}")

endif()
