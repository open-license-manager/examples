# Distributed under the OSI-approved BSD 3-Clause License.  

#[=======================================================================[.rst:
#Findlcc
#-------
#
#Find or build the lcc executable.
#
#Imported Targets
#^^^^^^^^^^^^^^^^
#
#This module provides the following imported targets, if found:
#
#``license_generator::lcc``
#  The lcc executable
#
#If lcc is not found this module will try to download it as a submodule
#Git must be installed.
#
#Input variables
#^^^^^^^^^^^^^^^^
#
#``LCC_LOCATION`` Hint for locating the lcc executable
#
#Result Variables
#^^^^^^^^^^^^^^^^
#
#This will define the following variables:
#
#``LCC_FOUND``
#  True if the system has the Foo library.
#``lcc_VERSION``
#
#Cache Variables
#^^^^^^^^^^^^^^^
#
#The following cache variables will also be set:
#
#``LCC_EXECUTABLE``
#  Path to the lcc executable.
#
#]=======================================================================]

find_package(PkgConfig)

if(LICENSECC_LOCATION)
	#maybe it's pointing to the build directory
	if(EXISTS "${LICENSECC_LOCATION}/licensecc.cmake")
		include("${LICENSECC_LOCATION}/licensecc.cmake")
		get_property(COMPILE_DEF TARGET licensecc::licensecc_static PROPERTY INTERFACE_COMPILE_DEFINITIONS)
		if("HAS_OPENSSL" IN_LIST COMPILE_DEF AND NOT OpenSSL_FOUND)
			message(DEBUG "Trying to find openssl (required by the target)")
		    SET ( OPENSSL_USE_STATIC_LIBS ON )
		    find_package(OpenSSL REQUIRED COMPONENTS Crypto)
		endif()
	else()
		if(EXISTS "${LICENSECC_LOCATION}/CMakeLists.txt")
			if(licensecc_FIND_COMPONENTS)
				set(LCC_PROJECT_NAME ${licensecc_FIND_COMPONENTS})
			endif(licensecc_FIND_COMPONENTS)
			add_subdirectory("${LICENSECC_LOCATION}" "${CMAKE_BINARY_DIR}/licensecc")
		else()
			find_package(licensecc HINTS 
					${LICENSECC_LOCATION} ${LICENSECC_LOCATION}/build NO_MODULE)
		endif()
	endif()
ELSE()
	if(licensecc_FIND_COMPONENTS)
		find_package(licensecc COMPONENTS ${licensecc_FIND_COMPONENTS} 
			PATHS ${CMAKE_BINARY_DIR} ${CMAKE_INSTALL_PREFIX} NO_MODULE) 
	else(licensecc_FIND_COMPONENTS)
		find_package(licensecc PATHS ${CMAKE_BINARY_DIR} ${CMAKE_INSTALL_PREFIX} NO_MODULE)
	endif(licensecc_FIND_COMPONENTS)

	IF(NOT licensecc_FOUND) 	
		find_package(Git QUIET)
		if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
		# Update submodules as needed
		    option(GIT_SUBMODULE "Check submodules during build" ON)
		    if(GIT_SUBMODULE)
		        message(STATUS "Submodule update")
		        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
		                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		                        RESULT_VARIABLE GIT_SUBMOD_RESULT)
		        if(NOT GIT_SUBMOD_RESULT EQUAL "0")
		            set(failure_messge  "git submodule update --init failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
		        endif()
		    endif()
		endif()
		if(NOT EXISTS "${PROJECT_SOURCE_DIR}/extern/licensecc/CMakeLists.txt")
		    set(failure_messge "All the options to find licensecc library failed. And i can't compile one from source GIT_SUBMODULE was turned off or failed. Please update submodules and try again.")
		else()
			if(licensecc_FIND_COMPONENTS)
				set(LCC_PROJECT_NAME ${licensecc_FIND_COMPONENTS})
			endif(licensecc_FIND_COMPONENTS)
			add_subdirectory("${PROJECT_SOURCE_DIR}/extern/licensecc")
		endif()
	ENDIF(NOT licensecc_FOUND)
ENDIF()


