# Copyright (c) 2017, Luc Michalski
# All rights reserved.

include(CMakeParseArguments) # cmake_parse_arguments
include(hunter_internal_error)
include(hunter_status_debug)

# MacOSX
include(hunter_unity3d_compile_flags_xcode-macosx)

# iPhone/iPad
include(hunter_unity3d_compile_flags_xcode-iphoneos)
include(hunter_unity3d_compile_flags_xcode-iphonesimulator)

# TvOS, WatchOS
# not a priority for now

