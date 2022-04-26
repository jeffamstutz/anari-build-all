## Copyright 2022 Jefferson Amstutz
## SPDX-License-Identifier: Unlicense

## CMake setup ##

cmake_minimum_required(VERSION 3.17)

set(CMAKE_BUILD_TYPE_INIT "Release")

if(NOT CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX
      "${CMAKE_BINARY_DIR}/install"
      CACHE STRING "Final install location." FORCE)
endif()

## Main project ##

project(build_anari_devices)

include(macros.cmake)

## Superbuild options ##

option(BUILD_DEVICE_OSPRAY "Build OSPRay device " OFF)
option(BUILD_DEVICE_USD "Build USD device " OFF)
option(BUILD_DEVICE_VISRTX "Build VisRTX device (requires CUDA + OptiX on CMAKE_PREFIX_PATH)" OFF)

## Build projects ##

superbuild_subproject(
  NAME ANARI-SDK
  URL "https://github.com/KhronosGroup/ANARI-SDK/archive/refs/tags/v0.1.2.zip"
  BUILD_ARGS
    -DBUILD_EXAMPLES=ON
    -DBUILD_SHARED_LIBS=ON
    -DBUILD_TESTING=ON
    -DBUILD_VIEWER=OFF
)

superbuild_add_subdirectory(OSPRay BUILD_DEVICE_OSPRAY)
superbuild_add_subdirectory(USD BUILD_DEVICE_USD)
superbuild_add_subdirectory(VisRTX BUILD_DEVICE_VISRTX)
