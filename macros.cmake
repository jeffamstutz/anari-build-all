## Copyright 2022 Jefferson Amstutz
## SPDX-License-Identifier: Unlicense

## CMake Modules ##

include(ExternalProject)
include(GNUInstallDirs)
include(ProcessorCount)
include(CMakePrintHelpers)

## Superbuild helper variables ##

ProcessorCount(SUPERBUILD_PROCESSOR_COUNT)

set(SUPERBUILD_NUM_BUILD_JOBS
  ${SUPERBUILD_PROCESSOR_COUNT} CACHE STRING "Number of build jobs '-j <n>'"
)

set(SUPERBUILD_DEFAULT_BUILD_COMMAND
  ${CMAKE_COMMAND} --build . --config release -j ${SUPERBUILD_NUM_BUILD_JOBS}
)

get_filename_component(SUPERBUILD_INSTALL_DIR_ABSOLUTE
  ${CMAKE_INSTALL_PREFIX} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_BINARY_DIR})

## Helper macros (not intended for direct use) ##

macro(superbuild_append_prefix)
  list(APPEND CMAKE_PREFIX_PATH ${ARGN})
  set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)
endmacro()

macro(superbuild_fix_lists)
  foreach(VAR ${ARGN})
    string(REPLACE ";" "|" ${VAR} "${${VAR}}")
  endforeach()
endmacro()

macro(superbuild_setup_subproject_vars _NAME)
  set(SUBPROJECT_NAME ${_NAME})

  if(BUILD_SUBPROJECT_OMIT_FROM_FINAL_INSTALL)
    set(SUBPROJECT_INSTALL_PATH ${CMAKE_CURRENT_BINARY_DIR}/${SUBPROJECT_NAME}/install)
  else()
    set(SUBPROJECT_INSTALL_PATH ${SUPERBUILD_INSTALL_DIR_ABSOLUTE})
  endif()

  set(SUBPROJECT_SOURCE_PATH ${SUBPROJECT_NAME}/source)
  set(SUBPROJECT_STAMP_PATH ${SUBPROJECT_NAME}/stamp)
  set(SUBPROJECT_BINARY_PATH ${SUBPROJECT_NAME}/build)
endmacro()

## Main superbuild functions ##

function(superbuild_subproject)
  # See cmake_parse_arguments docs to see how args get parsed here:
  #    https://cmake.org/cmake/help/latest/command/cmake_parse_arguments.html
  set(options SKIP_INSTALL_COMMAND OMIT_FROM_FINAL_INSTALL)
  set(oneValueArgs NAME URL SOURCE_ROOT)
  set(multiValueArgs BUILD_ARGS DEPENDS_ON)
  cmake_parse_arguments(BUILD_SUBPROJECT "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})

  if(NOT BUILD_SUBPROJECT_SKIP_INSTALL_COMMAND)
    set(SUBPROJECT_INSTALL_COMMAND ${CMAKE_COMMAND} --build . --config release --target install)
  endif()

  # Setup SUBPROJECT_* variables (containing paths) for this function
  superbuild_setup_subproject_vars(${BUILD_SUBPROJECT_NAME})
  superbuild_fix_lists(CMAKE_PREFIX_PATH)

  # Build the actual subproject
  ExternalProject_Add(${SUBPROJECT_NAME}
    PREFIX ${SUBPROJECT_NAME}
    DOWNLOAD_DIR ${SUBPROJECT_NAME}
    STAMP_DIR ${SUBPROJECT_STAMP_PATH}
    SOURCE_DIR ${SUBPROJECT_SOURCE_PATH}
    BINARY_DIR ${SUBPROJECT_BINARY_PATH}
    URL ${BUILD_SUBPROJECT_URL}
    LIST_SEPARATOR | # Use the alternate list separator
    CMAKE_ARGS
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_INSTALL_PREFIX:PATH=${SUBPROJECT_INSTALL_PATH}
      -DCMAKE_INSTALL_INCLUDEDIR:PATH=${CMAKE_INSTALL_INCLUDEDIR}
      -DCMAKE_INSTALL_LIBDIR:PATH=${CMAKE_INSTALL_LIBDIR}
      -DCMAKE_INSTALL_DOCDIR:PATH=${CMAKE_INSTALL_DOCDIR}
      -DCMAKE_INSTALL_BINDIR:PATH=${CMAKE_INSTALL_BINDIR}
      -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
      ${BUILD_SUBPROJECT_BUILD_ARGS}
    SOURCE_SUBDIR ${BUILD_SUBPROJECT_SOURCE_ROOT}
    BUILD_COMMAND ${SUPERBUILD_DEFAULT_BUILD_COMMAND}
    INSTALL_COMMAND "${SUBPROJECT_INSTALL_COMMAND}"
    BUILD_ALWAYS OFF
  )

  if(BUILD_SUBPROJECT_DEPENDS_ON)
    ExternalProject_Add_StepDependencies(${SUBPROJECT_NAME}
      configure ${BUILD_SUBPROJECT_DEPENDS_ON}
    )
  endif()

  # Place installed component on CMAKE_PREFIX_PATH for downstream consumption
  superbuild_append_prefix(${SUBPROJECT_INSTALL_PATH})
endfunction()

function(superbuild_add_subdirectory SUBDIR ENABLED)
  if (${ENABLED})
    add_subdirectory(${SUBDIR})
  endif()
endfunction()
