# Once done these will be defined:
#
#  LIBWEBRTC_FOUND
#  LIBWEBRTC_INCLUDE_DIRS
#  LIBWEBRTC_LIBRARIES
#
# For use in OBS:
#
#  WEBRTC_ROOT_DIR
#  WEBRTC_INCLUDE_DIR

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(_lib_suffix 64)
else()
	set(_lib_suffix 32)
endif()

find_path(WEBRTC_INCLUDE_DIR
	NAMES api/peerconnectioninterface.h
	HINTS
		ENV WEBRTC_ROOT_DIR${_lib_suffix}
		ENV WEBRTC_ROOT_DIR
		ENV DepsPath${_lib_suffix}
		ENV DepsPath
		${WEBRTC_ROOT_DIR${_lib_suffix}}
		${WEBRTC_ROOT_DIR}
		${DepsPath${_lib_suffix}}
		${DepsPath}
		${_WEBRTC_INCLUDE_DIRS}
	PATHS
		/usr/include /usr/local/include /opt/local/include /sw/include
	PATH_SUFFIXES
		include)

find_library(WEBRTC_LIB
	NAMES ${_WEBRTC_LIBRARIES} webrtc libwebrtc
	HINTS
		ENV WEBRTC_ROOT_DIR${_lib_suffix}
		ENV WEBRTC_ROOT_DIR
		ENV DepsPath${_lib_suffix}
		ENV DepsPath
		${WEBRTC_ROOT_DIR${_lib_suffix}}
		${WEBRTC_ROOT_DIR}
		${DepsPath${_lib_suffix}}
		${DepsPath}
		${_WEBRTC_LIBRARY_DIRS}
	PATHS
		/usr/lib /usr/local/lib /opt/local/lib /sw/lib
	PATH_SUFFIXES
		lib${_lib_suffix} lib
		libs${_lib_suffix} libs
		bin${_lib_suffix} bin
		../lib${_lib_suffix} ../lib
		../libs${_lib_suffix} ../libs
		../bin${_lib_suffix} ../bin)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibWebRTC DEFAULT_MSG WEBRTC_LIB WEBRTC_INCLUDE_DIR)
mark_as_advanced(WEBRTC_INCLUDE_DIR WEBRTC_LIB)

if(LIBWEBRTC_FOUND)
	set( LIBWEBRTC_INCLUDE_DIRS
    ${WEBRTC_INCLUDE_DIR}
    ${WEBRTC_INCLUDE_DIR}/third_party
    ${WEBRTC_INCLUDE_DIR}/third_party/abseil-cpp
    ${WEBRTC_INCLUDE_DIR}/third_party/libyuv/include
  )
  set(LIBWEBRTC_LIBRARIES ${WEBRTC_LIB})
  set(LIBWEBRTC_ROOT_DIR "${WEBRTC_INCLUDE_DIR}/..")
  set(WEBRTC_INCLUDE_DIRS LIBWEBRTC_INCLUDE_DIRS)
endif()
