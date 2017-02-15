# Copyright (c) 2017, Luc Michalski
# All rights reserved.

# disabled for now as we might use unity-n-native as dynamic wrapper (see below)
OPTION(HUNTER_UNITY3D_NATIVE_PLUGIN_CXX_WRAPPER 		  "build Unity3d Plugin with custom CXX wrappers" 					OFF)

# ref: https://github.com/shadowmint/unity-n-native/
OPTION(HUNTER_UNITY3D_NATIVE_PLUGIN_NATIVE_N_WRAPPER      "build Unity3d Plugin with unity-n-native as dynamic wrapper" 	ON)

# create a unity project template and copy output 
OPTION(HUNTER_UNITY3D_NATIVE_PLUGIN_DEPLOY                "create a unity project template and copy output" 				ON)

# ┌──────────────────────────────────────────────────────────────────┐
# │  Apple                                                           │
# └──────────────────────────────────────────────────────────────────┘

	# Notes:
	# - cannot be build inside a docker container
	# - requires a MacOSX + Xcode install workstation
	#
	##################################################################################
	######################################### available iOS toolchains (Polly)
	##################################################################################
	#
	############################# ios-nocodesign
	#
	# ios-nocodesign-arm64
	# ios-nocodesign-armv7
	#
	# ios-nocodesign-hid-sections
	# ios-nocodesign-wo-armv7s
	# ios-nocodesign
	#
	############################# ios 10.x
	#
	# ios-10-0-arm64-dep-8-0-hid-sections
	# ios-10-0-arm64
	# ios-10-0-armv7
	# ios-10-0-dep-8-0-hid-sections
	# ios-10-0-wo-armv7s
	# ios-10-0
	#
	# ios-10-1-arm64-dep-8-0-hid-sections
	# ios-10-1-arm64
	# ios-10-1-armv7
	# ios-10-1-dep-8-0-hid-sections
	# ios-10-1-dep-8-0-libcxx-hid-sections
	# ios-10-1-wo-armv7s
	# ios-10-1
	#
	# ios-10-2
	#
	# ios-nocodesign-10-0-arm64
	# ios-nocodesign-10-0-armv7
	# ios-nocodesign-10-0-wo-armv7s
	# ios-nocodesign-10-0
	#
	# ios-nocodesign-10-1-arm64
	# ios-nocodesign-10-1-armv7
	# ios-nocodesign-10-1-wo-armv7s
	# ios-nocodesign-10-1
	#
	############################# ios 9.x
	#
	# ios-9-0-armv7
	# ios-9-0-dep-7-0-armv7
	# ios-9-0-i386-armv7
	# ios-9-0-wo-armv7s
	# ios-9-0
	#
	# ios-9-1-arm64
	# ios-9-1-armv7
	# ios-9-1-dep-7-0-armv7
	# ios-9-1-dep-8-0-hid
	# ios-9-1-hid
	# ios-9-1
	#
	# ios-9-2-arm64
	# ios-9-2-armv7
	# ios-9-2-hid-sections
	# ios-9-2-hid
	# ios-9-2
	#
	# ios-9-3-arm64
	# ios-9-3-armv7
	# ios-9-3-wo-armv7s
	# ios-9-3
	#
	# ios-nocodesign-9-1-arm64
	# ios-nocodesign-9-1-armv7
	# ios-nocodesign-9-1
	#
	# ios-nocodesign-9-2-arm64
	# ios-nocodesign-9-2-armv7
	# ios-nocodesign-9-2
	#
	# ios-nocodesign-9-3-arm64
	# ios-nocodesign-9-3-armv7
	# ios-nocodesign-9-3-device-hid-sections
	# ios-nocodesign-9-3-device
	# ios-nocodesign-9-3-wo-armv7s
	# ios-nocodesign-9-3
	#
	############################# ios 8.x
	#
	# ios-8-0
	# ios-8-1
	#
	# ios-8-2-arm64-hid
	# ios-8-2-arm64
	# ios-8-2-cxx98
	# ios-8-2-i386-arm64
	# ios-8-2
	#
	# ios-8-4-arm64
	# ios-8-4-armv7
	# ios-8-4-armv7s
	# ios-8-4-hid
	# ios-8-4
	#
	# ios-nocodesign-8-4
	#
	############################# ios 7.x
	#
	# ios-7-0
	# ios-7-1
	#
	##################################################################################
	######################################### available OSX toolchains (Polly)
	##################################################################################
	#
	# osx-10-12-cxx98
	# osx-10-12-make
	# osx-10-12-ninja
	# osx-10-12-sanitize-address-hid-sections
	# osx-10-12-sanitize-address
	# osx-10-12
	#
	# osx-10-10-dep-10-7
	# osx-10-10-dep-10-9-make
	# osx-10-10
	#
	# osx-10-11-hid-sections
	# osx-10-11-make
	# osx-10-11-sanitize-address
	# osx-10-11
	#
	# osx-10-7
	# osx-10-8
	# osx-10-9

# ┌──────────────────────────────────────────────────────────────────┐
# │  Android                                                         │
# └──────────────────────────────────────────────────────────────────┘

	# Notes:
	#
	# Available Toolchains (Polly) :
	#
	# android-ndk-r10e-api-16-armeabi-v7a-neon-clang-35-hid-sections
	# android-ndk-r10e-api-16-armeabi-v7a-neon-clang-35-hid
	# android-ndk-r10e-api-16-armeabi-v7a-neon-clang-35
	# android-ndk-r10e-api-16-armeabi-v7a-neon
	# android-ndk-r10e-api-16-x86-hid-sections
	# android-ndk-r10e-api-16-x86-hid
	# android-ndk-r10e-api-16-x86
	#
	# android-ndk-r10e-api-19-armeabi-v7a-neon-hid-sections
	# android-ndk-r10e-api-19-armeabi-v7a-neon
	#
	# android-ndk-r10e-api-21-arm64-v8a-clang-35
	# android-ndk-r10e-api-21-arm64-v8a-gcc-49-hid-sections
	# android-ndk-r10e-api-21-arm64-v8a-gcc-49-hid
	# android-ndk-r10e-api-21-arm64-v8a-gcc-49
	# android-ndk-r10e-api-21-arm64-v8a
	# android-ndk-r10e-api-21-armeabi-v7a-neon-clang-35
	# android-ndk-r10e-api-21-armeabi-v7a-neon-hid-sections
	# android-ndk-r10e-api-21-armeabi-v7a-neon
	# android-ndk-r10e-api-21-armeabi-v7a
	# android-ndk-r10e-api-21-armeabi
	# android-ndk-r10e-api-21-mips
	# android-ndk-r10e-api-21-mips64
	# android-ndk-r10e-api-21-x86-64-hid-sections
	# android-ndk-r10e-api-21-x86-64-hid
	# android-ndk-r10e-api-21-x86-64
	# android-ndk-r10e-api-21-x86
	#
	# android-ndk-r10e-api-8-armeabi-v7a
	#
	# android-ndk-r11c-api-16-armeabi-v7a-neon-clang-35-hid
	# android-ndk-r11c-api-16-armeabi-v7a-neon-clang-35
	# android-ndk-r11c-api-16-armeabi-v7a-neon
	# android-ndk-r11c-api-16-armeabi-v7a
	# android-ndk-r11c-api-16-armeabi
	# android-ndk-r11c-api-16-x86-hid
	# android-ndk-r11c-api-16-x86
	# android-ndk-r11c-api-19-armeabi-v7a-neon
	#
	# android-ndk-r11c-api-21-arm64-v8a-clang-35
	# android-ndk-r11c-api-21-arm64-v8a-gcc-49-hid
	# android-ndk-r11c-api-21-arm64-v8a-gcc-49
	# android-ndk-r11c-api-21-arm64-v8a
	# android-ndk-r11c-api-21-armeabi-v7a-neon-clang-35
	# android-ndk-r11c-api-21-armeabi-v7a-neon
	# android-ndk-r11c-api-21-armeabi-v7a
	# android-ndk-r11c-api-21-armeabi
	# android-ndk-r11c-api-21-mips
	# android-ndk-r11c-api-21-mips64
	# android-ndk-r11c-api-21-x86-64-hid
	# android-ndk-r11c-api-21-x86-64
	# android-ndk-r11c-api-21-x86
	#
	# android-ndk-r11c-api-8-armeabi-v7a
	# android-ndk-r12b-api-19-armeabi-v7a-neon
	#
	# android-ndk-r13b-api-19-armeabi-v7a-neon
	#
	# android-vc-ndk-r10e-api-19-arm-clang-3-6
	# android-vc-ndk-r10e-api-19-arm-gcc-4-9
	#
	# android-vc-ndk-r10e-api-19-x86-clang-3-6
	# android-vc-ndk-r10e-api-21-arm-clang-3-6

	# available containers :

# ┌──────────────────────────────────────────────────────────────────┐
# │  Windows (WSA)                                                   │
# └──────────────────────────────────────────────────────────────────┘

	# Notes:
	# available toolchains (Polly) :
	# available containers :

# ┌──────────────────────────────────────────────────────────────────┐
# │  Linux                                                           │
# └──────────────────────────────────────────────────────────────────┘

	# Notes:
	# available toolchains (Polly) :
	# available containers :


