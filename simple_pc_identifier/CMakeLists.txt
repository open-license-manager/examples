cmake_minimum_required(VERSION 3.10)

SET(CMAKE_DISABLE_SOURCE_CHANGES ON)
SET(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

project (simple_pc_id CXX)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")

find_package(licensecc 2.0.0 REQUIRED COMPONENTS CIPPA)

message(STATUS "LicenseCC found " ${licensecc_FOUND})

add_executable(example src/example.cpp)
cmake_policy(SET CMP0028 NEW)
target_link_libraries(example licensecc::licensecc_static)