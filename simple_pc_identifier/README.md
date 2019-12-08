
Compile and install open-license-manager. Let's call `LCC_INSTALLATION_DIR` the place where you installed
open-license-manager, `LCC_SOURCE_DIR` the place where you download open-license-manager.

```
git clone https://github.com/open-license-manager/examples.git
cd examples/simple_pc_identifier
export LCC_INSTALLATION_DIR = ... #folder where you installed open-license-manager <sup>1</sup>
cd build 
cmake .. -DLICENSECC_LOCATION=$LCC_INSTALLATION_DIR
./example

```
the software should report some kind of license error (depending on the configuration of the library.

```
$LCC_INSTALLATION_DIR/bin/lcc license issue -l $(pwd)/example.lic --project-folder  $LCC_SOURCE_DIR/projects/default
``` 
## LicenseCC not found <sup>1</sup> 
Try to use an absolute path for `INSTALLATION_DIR` sometimes relative path doesn't work. You can also point `LICENSECC_LOCATION` to the source folder where you downloaded `open-license-manager` (but then you must be sure to install all the prerequisite libraries. Please follow build instructions for your environment)


## LicenseCC not found and LCC_PROJECT_NAME set
when you define LCC_PROJECT_NAME variable be sure to have a corresponding project in the open-license-manager (this means having compiled open-license-manager with the same setting).

Each project correspond to a software you want to add a license to. It includes a private/public key, and project settings: eg how to find licenses, and a compiled version of the library (that includes the public key).  

If there is no correspondence between the project you declare and the projects in the library CMake can't find the `licensecc` library.

If unsure don't specify `LCC_PROJECT_NAME` at all. CMake scripts will set it right.