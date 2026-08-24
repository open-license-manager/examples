# Simple PC Identifier

This example show how to integrate the licensing system if you already have downloaded, compiled and installed `open-license-manager` externally. This is a good starting point to test the library.

You can find the compilation instructions for [Linux](http://open-license-manager.github.io/open-license-manager/development/Build-the-library.html) 
and [Windows](http://open-license-manager.github.io/open-license-manager/development/Build-the-library-windows.html) on the project website.

## steps

Compile and *install* (`make install`) `licensecc`. Let's call `LCC_INSTALLATION_DIR` the place where you installed licensecc, and `LCC_SOURCE_DIR` the source directory where you downloaded the library source code.

Just to double check: when you configured and compiled licensecc you followed the steps below.

```
cd $LCC_SOURCE_DIR/build
cmake .. -DCMAKE_INSTALL_PREFIX=$LCC_INSTALLATION_DIR       //configure step
cmake --build . --target install
```

Proceed to clone the examples in a new folder of your choice:
```
git clone https://github.com/open-license-manager/examples.git --recurse-submodules
cd examples/simple_pc_identifier/build
export LCC_INSTALLATION_DIR = ... #folder where you installed open-license-manager <sup>1</sup>

cmake .. -DCMAKE_PREFIX_PATH=$LCC_INSTALLATION_DIR
cmake --build .
./example
```

the software should report some kind of license error (depending on the configuration of the library). To generate the missing license:

```
$LCC_INSTALLATION_DIR/bin/lccgen license issue -o example.lic --project-folder $LCC_SOURCE_DIR/projects/DEFAULT
```

### Windows users

The steps above are linux based but you can acheive similar results using windows command line. If you are in widnows remember to set up your build environment, and to use the command prompt.

```
C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat"
```

Building examples for Visual Studio are not covered here (too complex). 

### Troubleshooting

 * If you specified a project name (-DLCC_PROJECT_NAME="XXX") when configuring the library, then you have to specify the same project name when you compile the example (to let cmake find the library). If unsure don't specify `LCC_PROJECT_NAME` at all for this first compilation. CMake scripts will generate a default.
    - Remember to clean the cache every time you configure. `LCC_PROJECT_NAME` is cached.
 * If cmake still doesn't find the library consider setting `licensecc_DIR` (add -Dlicensecc_DIR="$LCC_INSTALLATION_DIR/lib/cmake/licensecc" pointing to a location where the file is located.) Below the directory structure created by when you installed `licensecc`.
 * Try to use `cmake .. -DCMAKE_FIND_DEBUG_MODE=ON` to see where cmake is searching for packages.
 
```
$CMAKE_INSTALL_PATH
├── bin
│   ├── <<PROJECT_NAME>>                        <--- "DEFAULT"
│   │   └── lccinspector
│   ├── lccgen -> lccgen-2.1.0
│   └── lccgen-2.1.0
├── include
│   └── licensecc
│       ├── datatypes.h
│       ├── <<PROJECT_NAME>>
│       │   ├── licensecc_properties.h
│       │   └── public_key.h
│       └── licensecc.h
└── lib
    ├── cmake
    │   └── licensecc                           <--- Point your licensecc_DIR here
    │       ├── licensecc-config.cmake
    │       └── licensecc-config-version.cmake
    └── licensecc
        └── <<PROJECT_NAME>>
            ├── cmake
            │   ├── licensecc.cmake
            │   └── licensecc-debug.cmake
            └── liblicensecc.a
```

