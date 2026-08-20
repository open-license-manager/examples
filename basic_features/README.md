
# Basic Features

Two minimal C++ examples showing the basic `licensecc` features, with the library integrated as a git submodule (the recommended integration method):

- `hardware_detection` — PC-locked licensing: acquire the license and, on failure, print the PC identifier and execution-environment information to issue a single-PC license.
- `program_features` — verify individual 'features' of one application ("program features") in addition to the main program. Useful if you want to enable or disable functions of your software using the license file.

## Prerequisites

We suggest to build and install `licensecc` first, following the library's own build and dependency instructions:

> You can find detailed instructions for [Linux](http://open-license-manager.github.io/licensecc/development/Build-the-library.html) 
> or [Windows](http://open-license-manager.github.io/licensecc/development/Build-the-library-windows.html) in the project web site.

This is to solve most of the dependency/compilation issue you may encounter, in an isolated environment. This will make sure your build environment is sane, and you don't get stuck in a submodule of a submodule compilation issue.

The examples pull `licensecc` as a submodule at `extern/open-license-manager`. If you cloned without `--recursive`:

```console
git submodule update --init --recursive
```

## Build

```console
cd basic_features/build
cmake -S .. -B . -DCMAKE_INSTALL_PREFIX=. -DLCC_PROJECT_NAME=DEFAULT
cmake --build . -j8 --target install
```

- `LCC_PROJECT_NAME` is the name of the project (=the software) you will be itegrating `licensecc` into, You can leave it as `DEFAULT` for now, later you can issue `lcc project create` to get a folder with the right naming, generate a private key, and get a `licensecc_properties.h` where you can customize the library; 

- On Windows, add `-DBOOST_ROOT=<boost install path>` to the configure line.

The executables are produced in `basic_features/build/bin/hardware_detection/` and `basic_features/build/bin/program_features/`.

Without a valid license they both print `license file not found` followed by the PC identifier.

## Examples

### hardware_detection

Acquires the default license with `acquire_license(nullptr, nullptr, &licenseInfo)`. On success it reports whether the license is bound to this PC (`licenseInfo.linked_to_pc`) or is a generic "demo" license. On failure it prints the error and calls `identify_pc(STRATEGY_DEFAULT, pc_identifier, &pc_id_sz, &execEnvInfo)` to output:

- the **PC identifier**, used to issue a machine-locked license with `lccgen license issue -s <pc_identifier>`;
- the **execution environment** (`ExecutionEnvironmentInfo`): virtualization summary, cloud provider, and virtualization detail.

```bash
./bin/hardware_detection/hardware_detection
```

You should see an output similar to this:

```
license ERROR :
    license file not found 
pc signature is :
    AABm-73pY-0R4q

execution environment:
    virtualization summary : Container
    cloud provider         : On-premise
    virtualization detail  : Other virtualization
```

Generate an hardware locked license (change the hardware identifier to the one you get in the previous step)
```bash
./bin/lccgen license issue -s AABm-73pY-0R4q -p ../projects/DEFAULT -o ./bin/hardware_detection/hardware_detection.lic
```

Run it again and you should see:
```bash
./bin/hardware_detection/hardware_detection

[license OK]
```


### program_features

Verifies the main program first (`acquire_license(nullptr, ...)`), then verifies a single feature:

```cpp
CallerInformations callerInfo = {"\0", "MY_AWESOME_FUNC"};
acquire_license(&callerInfo, nullptr, &licenseInfo);
```

The `feature_name` field selects a `[feature_name]` section in the license file; an empty name verifies the project's default feature (it has the same name of the project).

```bash
./bin/program_features/program_features

license ERROR :
    license file not found 
pc signature is :
    AABm-73pY-0R4q
```

Generate a license. For the sake of vairety this time a demo license (no hardware locking, but limited in time).

```bash
./bin/lccgen license issue -e 20301225 -p ../projects/DEFAULT -o ./bin/program_features/program_features.lic
```

```bash
./bin/program_features/program_features

license for main software OK
MY_AWESOME_FUNC is NOT licensed
```

Now license also the feature 'MY_AWESOME_FUNC', note that you can specify different parameters for this license.

```bash
./bin/lccgen license issue -f MY_AWESOME_FUNC -e 20281225 -p ../projects/DEFAULT -o ./bin/program_features/program_features.lic
```

```bash
./bin/program_features/program_features

license for main software OK
MY_AWESOME_FUNC is licensed
```

## Troubleshooting

- Do a clean checkout, or remove `projects/` and the `build/` folder.
- Build `licensecc` standalone first to confirm the build environment.
- Ask on the [forum / discussions](https://github.com/open-license-manager/licensecc/discussions).