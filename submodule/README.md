
This project show how to add the library as a git submodule of your project. This is the recommended integration way.
First download all the libraries for your environment. If you didn't checkout with the `--recursive` option you can run

```console
git submodule init --recursive
git submodule update --recursive
```

to update submodules. Check that the folder `submodule\extern\open-license-manager` exists. 
Install the prerequisites for [Linux](http://open-license-manager.github.io/open-license-manager/development/Build-the-library.html) 
or [Windows](http://open-license-manager.github.io/open-license-manager/development/Build-the-library-windows.html).

```console
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=.    #in windows you also need to specify -DBOOST_ROOT=`folder where boost is installed`
cmake --build . --target install
./example

>> License file not found
```

```console
bin/lccgen license issue -p ../projects/DEFAULT/ -o example.lic
./example

>> License OK
```

### The project doesn't compile

*  try a clean checkout or remove the folder `projects` and clean the `build` folder. 
*  try to compile `licensecc` standalone.
*  be sure to have installed the dependencies at the right version and to be running on a supported platform.
*  ask for help on [user fourum](https://groups.google.com/forum/#!forum/licensecc).

### Integrating into your project
If you want to add a git submodule to your project run this command:

```console
git submodule add --recursive -b develop https://github.com/open-license-manager/open-license-manager.git extern/open-license-manager
```

the cmake module to easily find LicenseCC is in  `cmake/Findlicensecc.cmake`.

Inserting the following lines into you CMakeLists.txt should get things right:

```cmake
find_package(licensecc 2.0.0 REQUIRED)
message(STATUS "LicenseCC found " ${licensecc_FOUND})
add_executable(example src/example.cpp) 
cmake_policy(SET CMP0028 NEW)
target_link_libraries(example licensecc::licensecc_static)
```