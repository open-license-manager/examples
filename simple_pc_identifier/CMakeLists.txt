cmake_minimum_required(VERSION 3.7)

SET(CMAKE_DISABLE_SOURCE_CHANGES ON)
SET(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

IF(NOT LCC_PROJECT_NAME)
		message(STATUS "You should define a variable LCC_PROJECT_NAME matching the choice you made when you compiled licensecc.\n 
		 We're supposing you're using DEFAULT as a project name. Use `lccgen project create` to create new projects.") 
	set(LCC_PROJECT_NAME "DEFAULT" CACHE STRING "Project name (name of the software for which you want to issue a license)") 
ENDIF(NOT LCC_PROJECT_NAME)

project (simple_pc_id CXX)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(licensecc 2.0.0 REQUIRED)

message(STATUS "LicenseCC found: " ${licensecc_DIR})

add_executable(example src/example.cpp)
cmake_policy(SET CMP0028 NEW)
target_link_libraries(example licensecc::licensecc_static)