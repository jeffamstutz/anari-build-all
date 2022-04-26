## Copyright 2022 Jefferson Amstutz
## SPDX-License-Identifier: Unlicense

set(SUBPROJECT_NAME tbb-2020.3)
set(TBB_VERSION v2020.3)

if (APPLE)
  set(TBB_URL https://github.com/oneapi-src/oneTBB/releases/download/${TBB_VERSION}/${SUBPROJECT_NAME}-mac.tgz)
  set(TBB_LIB_PATH "tbb/lib")
  set(TBB_LIB_DESTINATION "lib")
elseif(WIN32)
  set(TBB_URL https://github.com/oneapi-src/oneTBB/releases/download/${TBB_VERSION}/${SUBPROJECT_NAME}-win.zip)
  set(TBB_LIB_PATH "tbb/bin")
  set(TBB_LIB_DESTINATION "bin")
else()
  set(TBB_URL https://github.com/oneapi-src/oneTBB/releases/download/${TBB_VERSION}/${SUBPROJECT_NAME}-lin.tgz)
  set(TBB_LIB_PATH "tbb/lib/intel64/gcc4.8")
  set(TBB_LIB_DESTINATION "lib")
endif()

ExternalProject_Add(tbb
  PREFIX ${SUBPROJECT_NAME}
  STAMP_DIR ${SUBPROJECT_NAME}/stamp
  SOURCE_DIR ${SUBPROJECT_NAME}/unpacked
  BINARY_DIR ""
  URL ${TBB_URL}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  BUILD_ALWAYS OFF
)

set(TBB_ROOT ${CMAKE_CURRENT_BINARY_DIR}/${SUBPROJECT_NAME}/unpacked/tbb)
superbuild_append_prefix(${TBB_ROOT})
