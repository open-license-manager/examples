
This example show how to integrate the licensing system if you already have downloaded, compiled and installed `open-license-manager` externally.

You can find the compilation instructions for [Linux](http://open-license-manager.github.io/open-license-manager/development/Build-the-library.html) 
and [Windows](http://open-license-manager.github.io/open-license-manager/development/Build-the-library-windows.html) on the project website.

If you are brave and you want to compile and integrate all in one go refer to the [submodule](https://github.com/open-license-manager/examples/tree/develop/submodule) example.

## steps
Compile and *install* (`make install`) open-license-manager. Let's call `LCC_INSTALLATION_DIR` the place where you installed open-license-manager, `LCC_SOURCE_DIR` the place where you download `open-license-manager`.

```
git clone https://github.com/open-license-manager/examples.git
cd examples/simple_pc_identifier
export LCC_INSTALLATION_DIR = ... #folder where you installed open-license-manager <sup>1</sup>
cd build 
cmake .. -Dlicensecc_DIR=$LCC_INSTALLATION_DIR/lib/cmake/licensecc
make
./example
```
the software should report some kind of license error (depending on the configuration of the library). To generate the missing license:

```
$LCC_INSTALLATION_DIR/bin/lccgen license issue -o example.lic --project-folder $LCC_SOURCE_DIR/projects/DEFAULT
```

## LicenseCC not found <sup>1</sup> 
Try to use an absolute path for `INSTALLATION_DIR` sometimes relative path doesn't work. 

## LicenseCC not found and LCC_PROJECT_NAME set
when you define LCC_PROJECT_NAME variable be sure to have a corresponding project in the open-license-manager (this means having compiled open-license-manager with the same setting).

Each project correspond to a software you want to add a license to. It includes a private/public key, and project settings: eg how to find licenses, and a compiled version of the library (that includes the public key).  

If there is no correspondence between the project you declare and the projects in the library CMake can't find the `licensecc` library.

If unsure don't specify `LCC_PROJECT_NAME` at all. CMake scripts will set it right.