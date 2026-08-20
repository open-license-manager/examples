
[![Standard](https://img.shields.io/badge/c%2B%2B-11-blue.svg)](https://en.wikipedia.org/wiki/C%2B%2B#Standardization)
[![Linux build](https://github.com/open-license-manager/examples/actions/workflows/linux-standard.yml/badge.svg)](https://github.com/open-license-manager/examples/actions/workflows/linux-standard.yml)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

Examples of integration of `licensecc` in a C++ software.

* [simple pc identifier](https://github.com/open-license-manager/examples/tree/develop/simple_pc_identifier) is good if you've already compiled the library externally (that's a good starting point). 
* [basic features](https://github.com/open-license-manager/examples/tree/develop/basic_features) a set of examples showing the basic features of the library. `licensecc` is compiled as a submodule (the preferred way).
    - [hardware detection](https://github.com/open-license-manager/examples/tree/develop/basic_features#hardware_detection): hardware detection capabilities.
    - [program features](https://github.com/open-license-manager/examples/tree/develop/basic_features#program_features): enable/disable features in your software with a license file. 


## update previous versions
If you have already checked out `examples` project and you want to pull recent commits:

```
git submodule foreach git pull origin develop
``` 