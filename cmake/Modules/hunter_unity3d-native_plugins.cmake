# Copyright (c) 2017, Luc Michalski
# All rights reserved.

include(CMakeParseArguments) # cmake_parse_arguments
include(hunter_internal_error)
include(hunter_status_debug)

# Prepare
include(hunter_unity3d_native_plugins-prepare)

# Build
include(hunter_unity3d_native_plugins-build)

# Profile
include(hunter_unity3d_native_plugins-profile)

# Test
include(hunter_unity3d_native_plugins-test)

# Deploy
include(hunter_unity3d_native_plugins-deploy)

# Run
include(hunter_unity3d_native_plugins-run)

# Package
include(hunter_unity3d_native_plugins-package)
