cmake_minimum_required(VERSION 3.10)

project(Calculator)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 17)

# Include the Crow header files
include_directories(/usr/local/include)

# Add your source files
add_executable(calculator calculator.cpp)

