
This project show how to create a software with multiple functions, and you can enable or disable them differentially
using a license file.

First clone and download submodules:

```console
git submodule init --recursive
git submodule update --recursive
```

Check that the folder `submodule\extern\licensecc` exists. 
Install the prerequisites for [Linux](http://open-license-manager.github.io/licensecc/development/Build-the-library.html) 
or [Windows](http://open-license-manager.github.io/licensecc/development/Build-the-library-windows.html). 

```console
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=.    #in windows you also need to specify -DBOOST_ROOT=`folder where boost is installed`
cmake --build . --target install
```
When the application is compiled try to run the example executable:

```console
./example

> license ERROR :
>    license file not found 
> pc signature is :
>    AAAW-PqgF-zgA=
```

Generate a license for the main application running (remember to use your own hardware id!):

```console
bin/lccgen license issue -p ../projects/DEFAULT/ -s AAAW-PqgF-zgA= -o example.lic
./example

> license for main software OK
> MY_AWESOME_FUNC is NOT licensed
```

Generate a license for the feature:

```console
bin/lccgen license issue -p ../projects/DEFAULT/ -f MY_AWESOME_FUNC -s AAAW-PqgF-zgA= -o example.lic
./example

> license for main software OK
> MY_AWESOME_FUNC is licensed
```