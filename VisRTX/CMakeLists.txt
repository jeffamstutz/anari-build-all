## Copyright 2022 Jefferson Amstutz
## SPDX-License-Identifier: Unlicense

if (${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU" AND
    ${CMAKE_CXX_COMPILER_VERSION} VERSION_GREATER_EQUAL 11.2)
  message(FATAL_ERROR
    "g++ 11.2+ currently cannot build VisRTX, please create a new build with g++ <= 10.x"
  )
endif()

superbuild_subproject(
  NAME VisRTX
  URL "https://github.com/NVIDIA/VisRTX/archive/refs/tags/v0.3.2.zip"
  BUILD_ARGS
    -DCMAKE_CUDA_HOST_COMPILER=${CMAKE_CXX_COMPILER}
    -DVISRTX_BUILD_INTERACTIVE_EXAMPLE=OFF
  DEPENDS_ON ANARI-SDK
)
