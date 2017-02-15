# Copyright (c) 2017, Luc Michalski
# All rights reserved.

include(CMakeParseArguments) # cmake_parse_arguments
include(hunter_internal_error)
include(hunter_status_debug)

MACRO(hunter_download_extract)

	SET(h_one_value PREFIX URL DOWNLOAD_DIR EXPECTED_SHA256 TARGET)
	cmake_parse_arguments(h "" "${h_one_value}" "" ${ARGV})

	IF(h_UNPARSED_ARGUMENTS)
		hunter_internal_error("unexpected argument: ${h_UNPARSED_ARGUMENTS}")
	ENDIF()

	# cmake related target info
	IF(NOT h_PREFIX)
		hunter_internal_error("PREFIX can't be empty")
	ENDIF()

	# cmake related target info
	IF(NOT h_URL)
		hunter_internal_error("URL can't be empty")
	ENDIF()

	IF(NOT h_DOWNLOAD_DIR)
		hunter_internal_error("DOWNLOAD_DIR can't be empty")
	ENDIF()

	IF(NOT h_TARGET)
		hunter_internal_error("TARGET can't be empty")
	ENDIF()

	# library profile to deploy
	IF(NOT h_EXPECTED_SHA256)
		hunter_internal_error("EXPECTED_SHA256 can't be empty")
	ENDIF()


	#hunter_status_debug()
	MESSAGE(STATUS "URL: ${h_URL}")
	MESSAGE(STATUS "PREFIX: ${h_PREFIX}")
	MESSAGE(STATUS "DOWNLOAD_DIR: ${h_DOWNLOAD_DIR}")
	MESSAGE(STATUS "PREFIX: ${h_PREFIX}")
	MESSAGE(STATUS "EXPECTED_SHA256: ${h_EXPECTED_SHA256}")

	SET(SRC_DIR ${h_PREFIX}/${h_TARGET})

	# Check whether the source has been downloaded. If true, skip it.
	# Useful for external downloads like homebrew.
	IF(USE_EXISTING_SRC_DIR)
	  IF(EXISTS "${SRC_DIR}" AND IS_DIRECTORY "${SRC_DIR}")
	    FILE(GLOB EXISTED_FILES "${SRC_DIR}/*")
	    IF(EXISTED_FILES)
	      MESSAGE(STATUS "${SRC_DIR} is found and not empty, skipping download and extraction. ")
	      RETURN()
	    ENDIF()
	  ENDIF()
	  MESSAGE(FATAL_ERROR "USE_EXISTING_SRC_DIR set to ON, but '${SRC_DIR}' does not exist or is empty.")
	ENDIF()

	# Taken from ExternalProject_Add.  Let's hope we can drop this one day when
	# ExternalProject_Add allows you to disable SHOW_PROGRESS on the file download.
	IF(h_TIMEOUT)
	  SET(timeout_args h_TIMEOUT ${timeout})
	  SET(timeout_msg "${timeout} seconds")
	ELSE()
	  SET(timeout_args "")
	  SET(timeout_msg "none")
	ENDIF()

	string(REGEX MATCH "[^/\\?]*$" fname "${h_URL}")
	if(NOT "${fname}" MATCHES "(\\.|=)(bz2|tar|tgz|tar\\.gz|zip)$")
	  string(REGEX MATCH "([^/\\?]+(\\.|=)(bz2|tar|tgz|tar\\.gz|zip))/.*$" match_result "${h_URL}")
	  set(fname "${CMAKE_MATCH_1}")
	endif()
	if(NOT "${fname}" MATCHES "(\\.|=)(bz2|tar|tgz|tar\\.gz|zip)$")
	  message(FATAL_ERROR "Could not extract tarball filename from url:\n  ${url}")
	endif()
	string(REPLACE ";" "-" fname "${fname}")

	set(file ${h_DOWNLOAD_DIR}/${fname})
	message(STATUS "file: ${file}")

	message(STATUS "downloading...
	     src='${h_URL}'
	     dst='${file}'
	     timeout='${timeout_msg}'")

	file(DOWNLOAD ${h_URL} ${file}
	  ${timeout_args}
	  ${hash_args}
	  STATUS status
	  LOG log)

	list(GET status 0 status_code)
	list(GET status 1 status_string)

	if(NOT status_code EQUAL 0)
	  message(FATAL_ERROR "error: downloading '${h_URL}' failed
	  status_code: ${status_code}
	  status_string: ${status_string}
	  log: ${log}
	")
	endif()

	set(NULL_SHA256 "0000000000000000000000000000000000000000000000000000000000000000")

	# Allow users to use "SKIP" or "skip" as the sha256 to skip checking the hash.
	# You can still use the all zeros hash too.
	if((h_EXPECTED_SHA256 STREQUAL "SKIP") OR (h_EXPECTED_SHA256 STREQUAL "skip"))
	  set(h_EXPECTED_SHA256 ${NULL_SHA256})
	endif()

	# We could avoid computing the SHA256 entirely if a NULL_SHA256 was given,
	# but we want to warn users of an empty file.
	file(SHA256 ${file} ACTUAL_SHA256)
	if(ACTUAL_SHA256 STREQUAL "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
	  # File was empty.  It's likely due to lack of SSL support.
	  message(FATAL_ERROR
	    "Failed to download ${h_URL}.  The file is empty and likely means CMake "
	    "was built without SSL support.  Please use a version of CMake with "
	    "proper SSL support.  See "
	    "https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites "
	    "for more information.")
	elseif((NOT h_EXPECTED_SHA256 STREQUAL NULL_SHA256) AND
	       (NOT h_EXPECTED_SHA256 STREQUAL ACTUAL_SHA256))
	  # Wasn't a NULL SHA256 and we didn't match, so we fail.
	  message(FATAL_ERROR
	    "Failed to download ${h_URL}.  Expected a SHA256 of "
	    "${h_EXPECTED_SHA256} but got ${ACTUAL_SHA256} instead.")
	endif()

	message(STATUS "downloading... done")

	# Slurped from a generated extract-TARGET.cmake file.
	message(STATUS "extracting...
	     src='${file}'
	     dst='${SRC_DIR}'")

	if(NOT EXISTS "${file}")
	  message(FATAL_ERROR "error: file to extract does not exist: '${file}'")
	endif()

	# Prepare a space for extracting:
	#
	set(i 1234)
	while(EXISTS "${SRC_DIR}/../ex-${h_TARGET}${i}")
	  math(EXPR i "${i} + 1")
	endwhile()
	set(ut_dir "${SRC_DIR}/../ex-${h_TARGET}${i}")
	file(MAKE_DIRECTORY "${ut_dir}")

	# Extract it:
	#
	message(STATUS "extracting... [tar xfz]")
	execute_process(COMMAND ${CMAKE_COMMAND} -E tar xfz ${file}
	  WORKING_DIRECTORY ${ut_dir}
	  RESULT_VARIABLE rv)

	if(NOT rv EQUAL 0)
	  message(STATUS "extracting... [error clean up]")
	  file(REMOVE_RECURSE "${ut_dir}")
	  message(FATAL_ERROR "error: extract of '${file}' failed")
	endif()

	# Analyze what came out of the tar file:
	#
	message(STATUS "extracting... [analysis]")
	file(GLOB contents "${ut_dir}/*")
	list(LENGTH contents n)
	if(NOT n EQUAL 1 OR NOT IS_DIRECTORY "${contents}")
	  set(contents "${ut_dir}")
	endif()

	# Move "the one" directory to the final directory:
	#
	message(STATUS "extracting... [rename]")
	file(REMOVE_RECURSE ${SRC_DIR})
	get_filename_component(contents ${contents} ABSOLUTE)
	file(RENAME ${contents} ${SRC_DIR})

	# Clean up:
	#
	message(STATUS "extracting... [clean up]")
	file(REMOVE_RECURSE "${ut_dir}")

	message(STATUS "extracting... done")

ENDMACRO()