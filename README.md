# ANARI devices superbuild

This CMake script will pull down the ANARI-SDK and optionally several device
implementations and put them all in `CMAKE_INSTALL_PREFIX`. Please note that
while there isn't anything inherently platform-specific, this has only been
tried on Linux (specifically, Ubuntu 22.04).

Run with:

```bash
git clone https://github.com/jeffamstutz/anari-build-all
cd anari-build-all
mkdir build
cd build
cmake ..
cmake --build .
```

By default, this will build just the ANARI-SDK with the example device. You can
also enable devices by turning any of the following CMake options on:

- `BUILD_DEVICE_OSPRAY`
- `BUILD_DEVICE_VISRTX`
- `BUILD_DEVICE_USD`

By turning these options on, further dependencies will be downloaded to satisfy
each device build. Runtime libraries to use each device are copied into the
install location under `CMAKE_INSTALL_PREFIX`.

Note that VisRTX requires that CUDA is pre-installed and the OptiX 7 SDK is
already on `CMAKE_PREFIX_PATH` so that VisRTX can find them.
