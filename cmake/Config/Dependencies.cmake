# Copyright (c) 2017, Luc Michalski
# All rights reserved.

## #################################################################
## output destinations paths
## #################################################################

MACRO(hunter_build_dependencies subproject_name)

	# This LIST is required for static linking and exported to CaffeConfig.cmake
	SET(${subproject_name}LINKER_LIBS "")

	# ---[ Boost
	hunter_add_package(Boost COMPONENTS system thread filesystem)
	find_package(Boost 1.46 REQUIRED COMPONENTS system thread filesystem)
	LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS Boost::system Boost::filesystem Boost::thread)

	# ---[ Threads
	find_package(Threads REQUIRED)
	LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${CMAKE_THREAD_LIBS_INIT})

	# ---[ Google-glog
	hunter_add_package(glog)
	find_package(glog CONFIG REQUIRED)
	LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS glog)

	# ---[ Google-gflags
	hunter_add_package(gflags)
	find_package(gflags CONFIG REQUIRED)
	LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS gflags-static)

	# ---[ Google-protobuf
	include(cmake/ProtoBuf.cmake)

	# ---[ HDF5
	hunter_add_package(hdf5)
	find_package(ZLIB CONFIG REQUIRED)
	find_package(szip CONFIG REQUIRED)
	find_package(hdf5 CONFIG REQUIRED)
	LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS hdf5 hdf5_hl)

	# ---[ LMDB
	if(USE_LMDB)
	  find_package(LMDB REQUIRED)
	  include_directories(SYSTEM ${LMDB_INCLUDE_DIR})
	  LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${LMDB_LIBRARIES})
	  add_definitions(-DUSE_LMDB)
	  if(ALLOW_LMDB_NOLOCK)
	    add_definitions(-DALLOW_LMDB_NOLOCK)
	  endif()
	endif()

	# ---[ LevelDB
	if(USE_LEVELDB)
	  find_package(LevelDB REQUIRED)
	  include_directories(SYSTEM ${LevelDB_INCLUDE})
	  LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${LevelDB_LIBRARIES})
	  add_definitions(-DUSE_LEVELDB)
	endif()

	# ---[ Snappy
	if(USE_LEVELDB)
	  find_package(Snappy REQUIRED)
	  include_directories(SYSTEM ${Snappy_INCLUDE_DIR})
	  LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${Snappy_LIBRARIES})
	endif()

	# ---[ CUDA
	include(cmake/Cuda.cmake)
	if(NOT HAVE_CUDA)
	  if(CPU_ONLY)
	    message(STATUS "-- CUDA is disabled. Building without it...")
	  else()
	    message(WARNING "-- CUDA is not detected by cmake. Building without it...")
	  endif()

	  # TODO: remove this not cross platform define in future. Use caffe_config.h instead.
	  add_definitions(-DCPU_ONLY)
	endif()

	# ---[ OpenCV
	if(USE_OPENCV)
	  hunter_add_package(OpenCV)

	  find_package(OpenCV REQUIRED)
	  if(OpenCV_VERSION MATCHES "^2\\.")
	    find_package(OpenCV REQUIRED COMPONENTS core highgui imgproc)
	  else()
	    find_package(OpenCV REQUIRED COMPONENTS core highgui imgproc imgcodecs)
	  endif()

	  LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${OpenCV_LIBS})
	  message(STATUS "OpenCV found (${OpenCV_CONFIG_PATH})")
	  add_definitions(-DUSE_OPENCV)
	endif()

	# ---[ BLAS
	if(NOT APPLE)

	  set(BLAS "Atlas" CACHE STRING "Selected BLAS library")
	  set_property(CACHE BLAS PROPERTY STRINGS "Atlas;Open;MKL")

	  if(BLAS STREQUAL "Atlas" OR BLAS STREQUAL "atlas")
	    find_package(Atlas REQUIRED)
	    include_directories(SYSTEM ${Atlas_INCLUDE_DIR})
	    LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${Atlas_LIBRARIES})
	  elseif(BLAS STREQUAL "Open" OR BLAS STREQUAL "open")
	    hunter_add_package(OpenBLAS)
	    find_package(OpenBLAS CONFIG REQUIRED)
	    LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS OpenBLAS::OpenBLAS)
	  elseif(BLAS STREQUAL "MKL" OR BLAS STREQUAL "mkl")
	    find_package(MKL REQUIRED)
	    include_directories(SYSTEM ${MKL_INCLUDE_DIR})
	    LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${MKL_LIBRARIES})
	    add_definitions(-DUSE_MKL)
	  endif()

	elseif(APPLE)
	  find_package(vecLib REQUIRED)
	  include_directories(SYSTEM ${vecLib_INCLUDE_DIR})
	  LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${vecLib_LINKER_LIBS})
	endif()

	# ---[ Python
	if(BUILD_python)
	  if(NOT "${python_version}" VERSION_LESS "3.0.0")
	    # use python3
	    find_package(PythonInterp 3.0)
	    find_package(PythonLibs 3.0)
	    find_package(NumPy 1.7.1)
	    # Find the matching boost python implementation
	    set(version ${PYTHONLIBS_VERSION_STRING})
	    
	    STRING( REGEX REPLACE "[^0-9]" "" boost_py_version ${version} )
	    find_package(Boost 1.46 COMPONENTS "python-py${boost_py_version}")
	    set(Boost_PYTHON_FOUND ${Boost_PYTHON-PY${boost_py_version}_FOUND})
	    
	    while(NOT "${version}" STREQUAL "" AND NOT Boost_PYTHON_FOUND)
	      STRING( REGEX REPLACE "([0-9.]+).[0-9]+" "\\1" version ${version} )
	      
	      STRING( REGEX REPLACE "[^0-9]" "" boost_py_version ${version} )
	      find_package(Boost 1.46 COMPONENTS "python-py${boost_py_version}")
	      set(Boost_PYTHON_FOUND ${Boost_PYTHON-PY${boost_py_version}_FOUND})
	      
	      STRING( REGEX MATCHALL "([0-9.]+).[0-9]+" has_more_version ${version} )
	      if("${has_more_version}" STREQUAL "")
	        break()
	      endif()
	    endwhile()
	    if(NOT Boost_PYTHON_FOUND)
	      find_package(Boost 1.46 COMPONENTS python)
	    endif()
	  else()
	    # disable Python 3 search
	    find_package(PythonInterp 2.7)
	    find_package(PythonLibs 2.7)
	    find_package(NumPy 1.7.1)
	    find_package(Boost 1.46 COMPONENTS python)
	  endif()
	  if(PYTHONLIBS_FOUND AND NUMPY_FOUND AND Boost_PYTHON_FOUND)
	    set(HAVE_PYTHON TRUE)
	    if(BUILD_python_layer)
	      add_definitions(-DWITH_PYTHON_LAYER)
	      include_directories(SYSTEM ${PYTHON_INCLUDE_DIRS} ${NUMPY_INCLUDE_DIR})
	      LIST(APPEND ${SUBPROJECT_NAME}LINKER_LIBS ${PYTHON_LIBRARIES} Boost::system Boost::filesystem Boost::thread)
	    endif()
	  endif()
	endif()

	# ---[ Matlab
	if(BUILD_matlab)
	  find_package(MatlabMex)
	  if(MATLABMEX_FOUND)
	    set(HAVE_MATLAB TRUE)
	  endif()

	  # sudo apt-get install liboctave-dev
	  find_program(Octave_compiler NAMES mkoctfile DOC "Octave C++ compiler")

	  if(HAVE_MATLAB AND Octave_compiler)
	    set(Matlab_build_mex_using "Matlab" CACHE STRING "Select Matlab or Octave if both detected")
	    set_property(CACHE Matlab_build_mex_using PROPERTY STRINGS "Matlab;Octave")
	  endif()
	endif()

	# ---[ Doxygen
	if(BUILD_docs)
	  find_package(Doxygen)
	endif()

ENDMACRO()