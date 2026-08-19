cmake_minimum_required(VERSION 3.16)

project (basic_features VERSION 2.1.0 LANGUAGES CXX)

SET(CMAKE_DISABLE_SOURCE_CHANGES ON)
SET(CMAKE_DISABLE_IN_SOURCE_BUILD ON)

IF(NOT LCC_PROJECT_NAME)
		message(STATUS "You should define a variable LCC_PROJECT_NAME containing the name of the software you want to add a license to.\n \
		 A mock project named `DEFAULT` has been added for you.\n \
		 This project name should correspond to an existing project name in licensecc library. use `lcc project create` to create new projects.") 
	set(LCC_PROJECT_NAME "DEFAULT" CACHE STRING "Project name (name of the software for which you want to issue a license)") 
ENDIF(NOT LCC_PROJECT_NAME)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(extern/open-license-manager)

add_executable(hardware_detection src/hardware_detection.cpp)
target_link_libraries(hardware_detection licensecc::licensecc)
set_target_properties(hardware_detection PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/hardware_detection"
)

add_executable(program_features src/program_features.cpp)
target_link_libraries(program_features licensecc::licensecc)
set_target_properties(program_features PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/program_features"
)

#run open-license-manager tests
INCLUDE(CTest)