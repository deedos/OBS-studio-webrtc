# Once done these will be defined:
#
#  LIBOBS_FOUND
#  LIBOBS_INCLUDE_DIRS
#  LIBOBS_LIBRARIES
#
# For use in OBS:
#
#  OBS_INCLUDE_DIR

if("${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}" LESS 2.5)
   message(FATAL_ERROR "CMake >= 2.6.0 required")
endif()
#cmake_policy(PUSH)
#cmake_policy(VERSION 2.6)

#find_package(PkgConfig QUIET)
#if (PKG_CONFIG_FOUND)
#	pkg_check_modules(_SPEEXDSP QUIET speexdsp libspeexdsp)
#endif()

set(OBS_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/libobs)
set(LIBOBS_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/libobs)

if (APPLE)
  set(OBS_LIB ${CMAKE_BINARY_DIR}/libobs/libobs.dylib)
elseif ( UNIX )
  set(OBS_LIB ${CMAKE_BINARY_DIR}/libobs/libobs.a)
elseIf ( WIN32 )
  set(OBS_LIB ${CMAKE_BINARY_DIR}/libobs/libobs.dll) # not sure
endif()

set(LIBOBS_LIBRARIES ${OBS_LIB})

if(NOT TARGET libobs)
  include("${CMAKE_BINARY_DIR}/libobs/LibObsTarget.cmake")
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(LibObs DEFAULT_MSG OBS_LIB OBS_INCLUDE_DIR)

mark_as_advanced(OBS_INCLUDE_DIR OBS_LIB)
