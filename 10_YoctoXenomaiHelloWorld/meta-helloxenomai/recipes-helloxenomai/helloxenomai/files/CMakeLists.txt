cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(helloxenomai VERSION 0.0.1 LANGUAGES C)

# Xenomai build flags
execute_process (
    COMMAND bash -c "xeno-config --posix --cflags"
    OUTPUT_VARIABLE XENOMAI_C_FLAGS
)
string(REGEX REPLACE "\n$" "" XENOMAI_C_FLAGS "${XENOMAI_C_FLAGS}")
message(STATUS "XENOMAI_C_FLAGS=${XENOMAI_C_FLAGS}")
set(CMAKE_C_FLAGS "${XENOMAI_C_FLAGS}")

# Xenomai link flags
execute_process (
    COMMAND bash -c "xeno-config --posix --ldflags"
    OUTPUT_VARIABLE XENOMAI_EXE_LINKER_FLAGS
)
string(REGEX REPLACE "\n$" "" XENOMAI_EXE_LINKER_FLAGS "${XENOMAI_EXE_LINKER_FLAGS}")
message(STATUS "XENOMAI_EXE_LINKER_FLAGS=${XENOMAI_EXE_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${XENOMAI_EXE_LINKER_FLAGS}")

# Executable
add_executable(helloxenomai
                    src/main.c
)

