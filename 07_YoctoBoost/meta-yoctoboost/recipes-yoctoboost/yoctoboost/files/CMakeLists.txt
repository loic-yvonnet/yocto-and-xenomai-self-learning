cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(yoctoboost VERSION 0.0.1 LANGUAGES CXX)

# C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Additional compile flags
set(GCC_COMPILE_FLAGS "-Wall -Wextra -Werror -Wsuggest-override -Wno-register -Wno-missing-braces -Wno-unknown-pragmas -fdiagnostics-show-option")
if(NOT WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GCC_COMPILE_FLAGS}")
endif()

# All required dependencies 
find_package(Boost REQUIRED COMPONENTS program_options)

# Executable
add_executable(yoctoboost
    src/main.cpp
)
target_link_libraries(yoctoboost
    PRIVATE
        Boost::program_options
)

# Install on the target
install(TARGETS yoctoboost DESTINATION bin)
