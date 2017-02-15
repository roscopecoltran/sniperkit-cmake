# Copyright (c) 2017, Luc Michalski
# All rights reserved.

include(CMakeParseArguments) # cmake_parse_arguments
include(hunter_internal_error)
include(hunter_status_debug)

# create .dll, .bundke,.framework, .so, .a libraries for Unity3D for most popular CMake driven projects
OPTION(HUNTER_UNITY3D_NATIVE_PLUGIN "Bundle and deploy Unity Native Plugins with Hunter" 	ON)

# deploy and copy generated output in a Unity3D compatible skeleton for cross-platfrom native plugins
OPTION(HUNTER_UNITY3D_NATIVE_PLUGIN_DEPLOY "Deploy Unity Native Plugins with CMake" 	    ON)

# Dynamic native library for Unity3D wrapper
# ref: https://github.com/shadowmint/unity-n-native/
OPTION(HUNTER_UNITY3D_NATIVE_PLUGIN_NPP_WRAPPER "" 											ON)

# disabled for now as we might use unity-n-native as dynamic wrapper
OPTION(HUNTER_UNITY3D_NATIVE_PLUGIN_CXX_WRAPPER "" 											OFF)

# copy targets to a blank Unity3D project skeleton
# nb. 
# - Means that the project was not created by Unity3D or is empty of any Unity3D files.  
# - Means that it is only a copy of all wrappers and generated content by CMake in a Unity3D compatible structure folder. 
MACRO(hunter_unity3d_prepare)

	  SET(h_one_value TARGET_NAME TARGET_DEPLOY LIBRARY_TYPE LIBRARY_BUILD_TYPE PLUGIN_NAME PLUGIN_PREFIX_PATH TARGET_PLATFORM TARGET_ARCH)
	  cmake_parse_arguments(h "" "${h_one_value}" "" ${ARGV})
	  IF(h_UNPARSED_ARGUMENTS)
	    hunter_internal_error("unexpected argument: ${h_UNPARSED_ARGUMENTS}")
	  ENDIF()

	  # cmake related target info
	  IF(NOT h_TARGET_NAME)
	    hunter_internal_error("TARGET_NAME can't be empty")
	  ENDIF()

	  IF(NOT h_TARGET_DEPLOY)
	    hunter_internal_error("TARGET_DEPLOY can't be empty")
	  ENDIF()

	  # library profile to deploy
	  IF(NOT h_LIBRARY_TYPE)
	    hunter_internal_error("LIBRARY_TYPE can't be empty")
	  ENDIF()

	  IF(NOT h_LIBRARY_BUILD_TYPE)
	    hunter_internal_error("LIBRARY_BUILD_TYPE can't be empty")
	  ENDIF()

	  # library profile to deploy
	  IF(NOT h_PLUGIN_NAME)
	    hunter_internal_error("PLUGIN_NAME can't be empty")
	  ENDIF()

	  IF(NOT h_PLUGIN_PREFIX_PATH)
	    hunter_internal_error("PLUGIN_PREFIX_PATH can't be empty")
	  ENDIF()	  

	  # target platform for native plugin export
	  IF(NOT h_TARGET_PLATFORM)
	    hunter_internal_error("TARGET_PLATFORM can't be empty")
	  ENDIF()	  

	  IF(NOT h_TARGET_ARCH)
	    hunter_internal_error("TARGET_ARCH can't be empty")
	  ENDIF()	  

	  # update HUNTER_<name>_VERSIONS (list of available versions)
	  SET(h_native_targets "HUNTER_UNITY3D_${PROJECT_NAME}_TARGETS_TO_EXPORT")
	  LIST(APPEND ${h_native_targets} ${h_TARGET_NAME})

	  # 'hunter.cmake' may be loaded several times
	  LIST(REMOVE_DUPLICATES "${h_TARGET_NAME}")

	  SET(${h_TARGET_NAME} ${${h_TARGET_NAME}} PARENT_SCOPE)

ENDMACRO()

MACRO(hunter_unity3d_deploy)

	IF(HUNTER_UNITY3D_NATIVE_PLUGIN_DEPLOY)

		# nm <exe filename> shows the symbols in the file.
		# file <library filename> shows the symbols in the file.

		ADD_CUSTOM_COMMAND(TARGET ${UNITY_PLUGIN_LIBRABRY_NAME}
	        POST_BUILD
	        COMMAND ${CMAKE_COMMAND} -E make_directory ${UNITY_PLUGIN_DEST_DIR}
	        # careful, difference between ${UNITY_PLUGIN_LIBRABRY_NAME} and ${CONFIG_PROJECT_LIBRARY_NAME}
	        COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${UNITY_PLUGIN_LIBRABRY_NAME}>" "${UNITY_PLUGIN_DEST_DIR}/${UNITY_PLUGIN_FILE_NAME}"
	        COMMAND ${CMAKE_COMMAND} -E remove ${UNITY_ASSETS_DIR}/${UNITY_PLUGIN_NAME}/detail/${UNITY_PLUGIN_LIBRABRY_NAME}.cs
	        COMMAND ${CMAKE_COMMAND} -E remove ${UNITY_ASSETS_DIR}/${UNITY_PLUGIN_NAME}/detail/${CONFIG_PROJECT_LIBRARY_NAME}CSHARP_wrap.cxx
	        COMMAND ${CMAKE_COMMAND} -E remove ${UNITY_ASSETS_DIR}/${UNITY_PLUGIN_NAME}/detail${CONFIG_PROJECT_LIBRARY_NAME}CSHARP_wrap.h
	        COMMAND ${CMAKE_STRIP} ${STRIP_ARGS} "${UNITY_PLUGIN_DEST_DIR}/${UNITY_PLUGIN_FILE_NAME}"
	    )

		OPTION(HUNTER_UNITY3D_NATIVE_PLUGIN_PROFILE      "" ON)
		IF(HUNTER_UNITY3D_NATIVE_PLUGIN_PROFILE)

		ENDIF(HUNTER_UNITY3D_NATIVE_PLUGIN_PROFILE)

		# enable c++11 via -std=c++11 when compiler is clang or gcc
		IF( "\"${CMAKE_CXX_COMPILER_ID}\"" MATCHES AppleClang)
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
			#target_compile_features(${CONFIG_PROJECT_LIBRARY_NAME} PRIVATE cxx_nonstatic_member_init)
			#target_compile_features(${UNITY_PLUGIN_LIBRABRY_NAME} PRIVATE cxx_nonstatic_member_init)
		ELSEIF( "\"${CMAKE_CXX_COMPILER_ID}\"" MATCHES Clang)
			target_compile_features(${CONFIG_PROJECT_LIBRARY_NAME} PRIVATE cxx_nonstatic_member_init)
			target_compile_features(${UNITY_PLUGIN_LIBRABRY_NAME} PRIVATE cxx_nonstatic_member_init)
		ELSEIF( "\"${CMAKE_CXX_COMPILER_ID}\"" MATCHES GNU)
			#target_compile_features(${CONFIG_PROJECT_LIBRARY_NAME} PRIVATE cxx_nonstatic_member_init)
			#target_compile_features(${UNITY_PLUGIN_LIBRABRY_NAME} PRIVATE cxx_nonstatic_member_init)
		ELSEIF( "\"${CMAKE_CXX_COMPILER_ID}\"" MATCHES Intel)
			# using Intel C++
		ELSEIF( "\"${CMAKE_CXX_COMPILER_ID}\"" MATCHES MSVC)
			# using Visual Studio C++
		ENDIF()

		# fixes compilation with cmake > 3.2.0
		# http://stackoverflow.com/questions/26841603/arm-linux-androideabi-bin-ld-fatal-error-soname-must-take-a-non-empty-argume
		STRING(REPLACE "<CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG><TARGET_SONAME>" "" CMAKE_CXX_CREATE_SHARED_MODULE "${CMAKE_CXX_CREATE_SHARED_MODULE}")

	ENDIF(HUNTER_UNITY3D_NATIVE_PLUGIN_DEPLOY)

ENDMACRO()

MACRO(hunter_unity3d_native_wrapper wrapper_name)

	# registry of valid unity native code wrappers
    STRING(COMPARE EQUAL "${wrapper_name}" "NativeCXX" 				is_native_cxx)

    # ref: https://github.com/shadowmint/unity-n-native
    STRING(COMPARE EQUAL "${wrapper_name}" "Unity-N-Native" 		is_npp)

    # ref: https://github.com/tritao/MonoManagedToNative
    STRING(COMPARE EQUAL "${wrapper_name}" "MonoManagedToNative" 	is_mono_managed_to_native)

    # ref: https://github.com/mono/CppSharp
    STRING(COMPARE EQUAL "${wrapper_name}" "CppSharp" 				is_cppsharp)

    # ref: https://github.com/mono/embeddinator-4000
    STRING(COMPARE EQUAL "${wrapper_name}" "Embeddinator4000" 		is_embeddinator_4000)

    # ref: https://github.com/tritao/LLDBSharp
    STRING(COMPARE EQUAL "${wrapper_name}" "LLDBSharp" 				is_lldb_csharp)

    MESSAGE(STATUS "Unity3D Native Plugin, bindings wrapper: ${wrapper_name}")

    MESSAGE(STATUS "is_native_cxx?: ${is_native_cxx}")
    MESSAGE(STATUS "is_npp?: ${is_npp}")
    MESSAGE(STATUS "is_mono_managed_to_native?: ${is_mono_managed_to_native}")
    MESSAGE(STATUS "is_cppsharp?: ${is_cppsharp}")
    MESSAGE(STATUS "is_embeddinator_4000?: ${is_embeddinator_4000}")
    MESSAGE(STATUS "is_lldb_csharp?: ${is_lldb_csharp}")

ENDMACRO()	

# internal variables: _hunter_ap_*
macro(hunter_add_package_example)
  string(COMPARE EQUAL "${PROJECT_NAME}" "" _project_name_is_empty)
  if(_project_name_is_empty)
    hunter_fatal_error(
        "Please set hunter_add_package *after* project command"
        WIKI "error.hunteraddpackage.after.project"
    )
  endif()

  if(NOT HUNTER_FINALIZED)
    hunter_finalize()
    set(HUNTER_FINALIZED TRUE)
  endif()

  cmake_parse_arguments(_hunter_ap_arg "" "" COMPONENTS ${ARGV})

  # Get project name
  list(LENGTH _hunter_ap_arg_UNPARSED_ARGUMENTS _hunter_ap_len)
  if(NOT ${_hunter_ap_len} EQUAL 1)
    hunter_internal_error(
        "'hunter_add_package' incorrect usage,"
        " expected one argument before COMPONENTS"
    )
  endif()
  list(GET _hunter_ap_arg_UNPARSED_ARGUMENTS 0 _hunter_ap_project)

  hunter_test_string_not_empty("${HUNTER_SELF}")
  set(
      _hunter_ap_project_dir
      "${HUNTER_SELF}/cmake/projects/${_hunter_ap_project}"
  )
  if(NOT EXISTS "${_hunter_ap_project_dir}")
    hunter_internal_error("Project '${_hunter_ap_project}' not found")
  endif()
  if(NOT IS_DIRECTORY "${_hunter_ap_project_dir}")
    hunter_internal_error("Project '${_hunter_ap_project}' not found")
  endif()

  # Check components
  foreach(_hunter_ap_component ${_hunter_ap_arg_COMPONENTS})
    set(
        _hunter_ap_component_dir
        "${_hunter_ap_project_dir}/${_hunter_ap_component}"
    )
    if(NOT EXISTS "${_hunter_ap_component_dir}")
      hunter_internal_error(
          "Component '${_hunter_ap_component}' not found "
          "in project '${_hunter_ap_project}'"
      )
    endif()
    if(NOT IS_DIRECTORY "${_hunter_ap_component_dir}")
      hunter_internal_error(
          "Component '${_hunter_ap_component}' not found "
          "in project '${_hunter_ap_project}'"
      )
    endif()
  endforeach()

  unset(_hunter_ap_list)
  list(APPEND _hunter_ap_list "${_hunter_ap_project_dir}/hunter.cmake")

  # Load components
  foreach(_hunter_ap_component ${_hunter_ap_arg_COMPONENTS})
    list(
        APPEND
        _hunter_ap_list
        "${_hunter_ap_project_dir}/${_hunter_ap_component}/hunter.cmake"
    )
  endforeach()

  # do not use any variables after this 'foreach', because included files
  # may call 'hunter_add_package' and rewrite it
  foreach(x ${_hunter_ap_list})
    hunter_status_debug("load: ${x}")
    MESSAGE(STATUS "INCLUDE ${x}")
    include("${x}")
    MESSAGE(STATUS "load: ${x} ... end")
    hunter_status_debug("load: ${x} ... end")
  endforeach()

ENDMACRO()

MACRO(hunter_unity3d_profile_generated_libraries unity_native_plugin_name unity_native_plugin_dest_path)

    # .framework
    # lipo -info myFramework.framework/MyFramework
    # iOS - archs=armv7,armv64, extension=*.a
    IF(is_ios)

       # profile generated output
       ADD_CUSTOM_COMMAND(TARGET ${_unity_native_plugin_name}
          POST_BUILD
          # get info about the generated library 
          COMMAND file "${UNITY_PLUGIN_DEST_DIR}/${UNITY_PLUGIN_FILE_NAME}" > "${UNITY_PLUGIN_DEST_DIR}/file_library_info-${UNITY_PLUGIN_LIBRABRY_NAME}.txt"
          # get all symbols from the genrated library
          COMMAND nm "${UNITY_PLUGIN_DEST_DIR}/${UNITY_PLUGIN_FILE_NAME}" > "${UNITY_PLUGIN_DEST_DIR}/nn_library_symbols-${UNITY_PLUGIN_LIBRABRY_NAME}.txt"
          # get info about the generated library 
          COMMAND xcrun -sdk iphoneos lipo -info "${UNITY_PLUGIN_DEST_DIR}/${UNITY_PLUGIN_FILE_NAME}" > "${UNITY_PLUGIN_DEST_DIR}/xcrun_iphoneos_lipo_info-${UNITY_PLUGIN_LIBRABRY_NAME}.txt"
       )

    # MacOSX - archs=i386,x86_64, extension=*.bundle
    ELSEIF(is_osx)

       # profile generated output
       ADD_CUSTOM_COMMAND(TARGET ${UNITY_PLUGIN_LIBRABRY_NAME}
          POST_BUILD
          # get info about the generated library 
          COMMAND file "${UNITY_PLUGIN_DEST_DIR}/${UNITY_PLUGIN_FILE_NAME}" > "${UNITY_PLUGIN_DEST_DIR}/file_library_info-${UNITY_PLUGIN_LIBRABRY_NAME}.txt"
          # get all symbols from the genrated library
          COMMAND nm "${UNITY_PLUGIN_DEST_DIR}/${UNITY_PLUGIN_FILE_NAME}" > "${UNITY_PLUGIN_DEST_DIR}/nn_library_symbols-${UNITY_PLUGIN_LIBRABRY_NAME}.txt"
          # get info about the generated library 
          COMMAND xcrun -sdk macosx lipo -info "${UNITY_PLUGIN_DEST_DIR}/${UNITY_PLUGIN_FILE_NAME}" > "${UNITY_PLUGIN_DEST_DIR}/xcrun_macosx_lipo_info-${UNITY_PLUGIN_LIBRABRY_NAME}.txt"
       )

    # Android - archs=x86,armebi-v7, extension=*.so
    ELSEIF(is_android)

    # Linux - archs=x86,x86_64, extension=*.so
    ELSEIF(is_linux)

    # WSA 32 bits - archs=x86, extension=*.dll
    ELSEIF(is_msvc_32)

    # WSA 64 bits - archs=x86, extension=*.dll
    ELSEIF(is_msvc_64)

    ENDIF(is_ios)

ENDMACRO()

