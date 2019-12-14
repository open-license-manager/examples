# Distributed under the OSI-approved BSD 3-Clause License.  

#[=======================================================================[.rst:
Findlicensecc
-------

Find or build the licensecc library.

Imported Targets
^^^^^^^^^^^^^^^^
This module provides the following imported targets, if found:

``licensecc::licensecc_static``
  The licensecc static library

If licensecc is not found this module will try to download it as a submodule
Git must be installed.

Input variables
^^^^^^^^^^^^^^^^
``LICENSECC_LOCATION`` 
   Hint for locating the licenssecc library. It may point to the installation folder or the source folder
   
``LCC_PROJECT_NAME`` 
   or specifying a component name in the component section will cause the script to search for a project (primary key...) named as specified.


Result Variables
^^^^^^^^^^^^^^^^
This will define the following variables:

``licensecc_FOUND``
  True if the system has the licensecc library.
``lcc_VERSION``
  Version of licensecc

Optionally the module will search for OpenSSL (if LicenseCC was compiled with this option).

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables will also be set:


]=======================================================================]

find_package(PkgConfig)

if(LICENSECC_LOCATION)
	#maybe it's pointing to the build directory
	if(EXISTS "${LICENSECC_LOCATION}/licensecc.cmake")
		include("${LICENSECC_LOCATION}/licensecc.cmake")
		get_property(COMPILE_DEF TARGET licensecc::licensecc_static PROPERTY INTERFACE_COMPILE_DEFINITIONS)
		if("HAS_OPENSSL" IN_LIST COMPILE_DEF AND NOT OpenSSL_FOUND)
			message(VERBOSE "Trying to find openssl (required by the target)")
		    SET ( OPENSSL_USE_STATIC_LIBS ON )
		    find_package(OpenSSL REQUIRED COMPONENTS Crypto)
		endif()
	else()
		#pointing to source?
		if(EXISTS "${LICENSECC_LOCATION}/CMakeLists.txt")
			if(licensecc_FIND_COMPONENTS)
				set(LCC_PROJECT_NAME ${licensecc_FIND_COMPONENTS})
			endif(licensecc_FIND_COMPONENTS)
			add_subdirectory("${LICENSECC_LOCATION}" "${CMAKE_BINARY_DIR}/licensecc")
		else()
			#try find as install directory
			find_package(licensecc HINTS 
				${LICENSECC_LOCATION} ${CMAKE_CURRENT_LIST_DIR}/${LICENSECC_LOCATION} CONFIG)
		endif()
	endif()
ELSE(LICENSECC_LOCATION)
	if(licensecc_FIND_COMPONENTS)
		find_package(licensecc COMPONENTS ${licensecc_FIND_COMPONENTS} 
			PATHS ${CMAKE_BINARY_DIR} ${CMAKE_INSTALL_PREFIX} QUIET NO_MODULE) 
	else(licensecc_FIND_COMPONENTS)
		find_package(licensecc PATHS ${CMAKE_BINARY_DIR} ${CMAKE_INSTALL_PREFIX} QUIET NO_MODULE)
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
		if(NOT EXISTS "${PROJECT_SOURCE_DIR}/extern/open-license-manager/CMakeLists.txt")
		    set(failure_messge "All the options to find licensecc library failed. And i can't compile one from source GIT_SUBMODULE was turned off or failed. Please update submodules and try again.")
		else()
			if(licensecc_FIND_COMPONENTS)
				set(LCC_PROJECT_NAME ${licensecc_FIND_COMPONENTS})
			endif(licensecc_FIND_COMPONENTS)
			add_subdirectory("${PROJECT_SOURCE_DIR}/extern/open-license-manager")
			set(licensecc_FOUND TRUE)
		endif()
	ENDIF(NOT licensecc_FOUND)
ENDIF(LICENSECC_LOCATION)


