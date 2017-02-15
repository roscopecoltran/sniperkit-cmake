# Copyright (c) 2017, Luc Michalski
# All rights reserved.

## #################################################################
## output destinations paths
## #################################################################

  # need to be reviewd and cleaned
  SET(CURRENT_PROJECT_OUTPUT_PATH_PREFIX      "${CMAKE_CURRENT_SOURCE_DIR}/_output")

  # executables
  SET(CURRENT_PROJECT_OUTPUT_BIN              "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/bin")

  # libraries (static/generated)
  SET(CURRENT_PROJECT_OUTPUT_LIBS             "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/libs")
  SET(CURRENT_PROJECT_OUTPUT_LIBS_SHARED      "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/libs/shared")
  SET(CURRENT_PROJECT_OUTPUT_LIBS_STATIC      "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/libs/static")

  # sources / headers
  SET(CURRENT_PROJECT_OUTPUT_INCLUDES         "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/include") # headers
  SET(CURRENT_PROJECT_OUTPUT_SRCS             "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/src") # sources

  # exports / integration / bundling for 3rd party (eg. Unity 3D Native cpp plugins)
  SET(CURRENT_PROJECT_OUTPUT_LIBS_INCLUDES    "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/export/headers") # export generated headers

  # CMake / Makefile logs
  SET(CURRENT_PROJECT_OUTPUT_LOGS             "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/logs")
  SET(CURRENT_PROJECT_OUTPUT_LOGS_COMBINED    "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/logs/combined")
  SET(CURRENT_PROJECT_OUTPUT_LOGS_ERRORS      "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/logs/errors")
  SET(CURRENT_PROJECT_OUTPUT_LOGS_WARNINGS    "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/logs/warning")

  # reports
  SET(CURRENT_PROJECT_OUTPUT_REPORTS          "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/reports")

  # docs
  SET(CURRENT_PROJECT_OUTPUT_DOCS             "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/docs")
  SET(CURRENT_PROJECT_OUTPUT_DOCS_REFS        "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/docs/refs")
  SET(CURRENT_PROJECT_OUTPUT_DOCS_USAGE       "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/docs/usage")
  SET(CURRENT_PROJECT_OUTPUT_DOCS_INSTALL     "${CURRENT_PROJECT_OUTPUT_PATH_PREFIX}/docs/install")

