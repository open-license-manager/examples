
This project show how to add the library as a git submodule of your project. This is the recommended integration way.
First download all the libraries for your environment. If you didn't checkout with the `--recursive` option you can run

```
git submodule init --recursive
git submodule update --recursive
```

to update submodules. Check that the folder `submodule\extern\open-license-manager` exists. 
Install the prerequisites for linux or windows.

```console
cd build
cmake ..  -DCMAKE_INSTALL_PREFIX=.
make 
make install
./example

>> License not found
```

```
bin/lcc license issue -p ../projects/DEFAULT/ -o example.lic
./example

>> License OK
```

If you want to add a submodule to your project run this command:

```
git submodule add --recursive -b develop https://github.com/open-license-manager/open-license-manager.git extern/open-license-manager
```

the cmake module to easily find LicenseCC is in  `cmake/Findlicensecc.cmake`.