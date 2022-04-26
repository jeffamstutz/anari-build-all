## Copyright 2022 Jefferson Amstutz
## SPDX-License-Identifier: Unlicense

include(get_tbb.cmake)

superbuild_subproject(
  NAME USD
  URL "https://github.com/jeffamstutz/superbuild_usd/archive/refs/heads/main.zip"
  BUILD_ARGS
    -DTBB_ROOT=${TBB_ROOT}
    -DGET_TBB=OFF
  SKIP_INSTALL_COMMAND
  OMIT_FROM_FINAL_INSTALL
)

superbuild_subproject(
  NAME ANARI-USD
  URL "https://github.com/NVIDIA-Omniverse/AnariUsdDevice/archive/refs/heads/main.zip"
  DEPENDS_ON ANARI-SDK USD
  BUILD_ARGS
    -DUSD_DEVICE_USE_OPENVDB=ON
    -DINSTALL_USD_DEPS=ON
    -DINSTALL_ANARI_DEPS=OFF
    -DTBB_ROOT=${TBB_ROOT}
    -DTbb_INCLUDE_DIR=${TBB_ROOT}/include
    -DTbb_tbb_LIBRARY=${TBB_ROOT}/lib/intel64/gcc4.8/libtbb.so
)
