# Once done these will be defined:
#
#  LIBWEBRTC_FOUND
#  LIBWEBRTC_ROOT_DIR
#  LIBWEBRTC_INCLUDE_DIRS
#  LIBWEBRTC_LIBRARIES
#
#  WEBRTC_FOUND
#  WEBRTC_ROOT_DIR
#  WEBRTC_INCLUDE_DIRS
#  WEBRTC_LIBRARIES
#
# For use in OBS:
#
#  WEBRTC_INCLUDE_DIRS
#  WEBRTC_LIBRARIES

# set(WEBRTC_ROOT_DIR "" CACHE STRING "Where is the WebRTC root directory located?")

if(libwebrtc_DIR)
	set(LIBWEBRTC_CMAKE_DIR ${libwebrtc_DIR})
	list(APPEND CMAKE_MODULE_PATH ${LIBWEBRTC_CMAKE_DIR})
	list(APPEND CMAKE_PREFIX_PATH ${LIBWEBRTC_CMAKE_DIR})
	add_definitions(-DWEBRTC_LIBRARY_IMPL -DNDEBUG -DNO_TCMALLOC -DABSL_ALLOCATOR_NOTHROW)
	if(APPLE)
		add_definitions(-DWEBRTC_POSIX -DWEBRTC_MAC -DHAVE_PTHREAD)
	elseif(WIN32)
		add_definitions(-DWEBRTC_WIN -DWIN32 -D_WINDOWS -D__STD_C -DWIN32_LEAN_AND_MEAN -DNOMINMAX -D_UNICODE -DUNICODE)
	elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
		add_definitions(-DWEBRTC_LINUX -D_GLIBCXX_USE_CXX11_ABI=0)
	endif()
	find_package(libwebrtc CONFIG REQUIRED)
	return()
endif()

find_package(PkgConfig QUIET)
if (PKG_CONFIG_FOUND)
	pkg_check_modules(_WEBRTC QUIET webrtc libwebrtc webrtc_full libwebrtc_full)
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(_lib_suffix 64)
else()
	set(_lib_suffix 32)
endif()

find_path(WEBRTC_INCLUDE_DIR
	NAMES
		pc/channel.h
		api/peerconnectioninterface.h
		api/peer_connection_interface.h
	HINTS
		ENV WEBRTC_ROOT_DIR${_lib_suffix}
		ENV WEBRTC_ROOT_DIR
		${WEBRTC_ROOT_DIR${_lib_suffix}}
		${WEBRTC_ROOT_DIR}
		ENV DepsPath${_lib_suffix}
		ENV DepsPath
		${DepsPath${_lib_suffix}}
		${DepsPath}
		${_WEBRTC_INCLUDE_DIRS}
		${DepsPath}/webrtc-checkout
		${DepsPath}/../webrtc-checkout
	PATHS
		/sw
		/opt/local
		/opt
		/usr/local
		/usr
	PATH_SUFFIXES
		include${_lib_suffix}
		include
		src
)

find_library(WEBRTC_LIB
	NAMES ${_WEBRTC_LIBRARIES} webrtc libwebrtc webrtc_full libwebrtc_full
	HINTS
		ENV WEBRTC_ROOT_DIR${_lib_suffix}
		ENV WEBRTC_ROOT_DIR
		ENV WEBRTC_ROOT_DIR/src/out
		ENV WEBRTC_ROOT_DIR/src/out/Default
		ENV WEBRTC_ROOT_DIR/src/out/Release
		${WEBRTC_ROOT_DIR${_lib_suffix}}
		${WEBRTC_ROOT_DIR}
		${WEBRTC_ROOT_DIR}/src/out
		${WEBRTC_ROOT_DIR}/src/out/Default
		${WEBRTC_ROOT_DIR}/src/out/Release
		ENV DepsPath${_lib_suffix}
		ENV DepsPath
		${DepsPath${_lib_suffix}}
		${DepsPath}
		${_WEBRTC_LIBRARY_DIRS}
		${DepsPath}/webrtc-checkout
		${DepsPath}/../webrtc-checkout
	PATHS
		/sw
		/opt/local
		/opt
		/usr/local
		/usr
	PATH_SUFFIXES
		lib${_lib_suffix} lib
		libs${_lib_suffix} libs
		bin${_lib_suffix} bin
		../lib${_lib_suffix} ../lib
		../libs${_lib_suffix} ../libs
		../bin${_lib_suffix} ../bin
		obj
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibWebRTC DEFAULT_MSG WEBRTC_LIB WEBRTC_INCLUDE_DIR)
mark_as_advanced(WEBRTC_INCLUDE_DIR WEBRTC_LIB)

if(LIBWEBRTC_CMAKE_DIR)
	set(libwebrtc_DIR LIBWEBRTC_CMAKE_DIR)
	list(APPEND CMAKE_MODULE_PATH ${LIBWEBRTC_CMAKE_DIR})
endif()

#------------------------------------------------------------------------
# Include standard and default libraries
#
# if(MSVC)
# 	# CMAKE_CXX_STANDARD_LIBRARIES must be a string for MSVC
# 	set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} advapi32.lib iphlpapi.lib psapi.lib shell32.lib ws2_32.lib dsound.lib winmm.lib strmiids.lib")
# elseif(MSYS)
# 	set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -lws2_32 -liphlpapi")
# elseif(APPLE)
# 	set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -ldl") # -lm -lz -llibc -lglibc
# elseif(UNIX)
# 	set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -lm -ldl -lrt") # -lz -lrt -lpulse-simple -lpulse -ljack -llibc -lglibc
# endif()

#------------------------------------------------------------------------
# Platform dependencies & preprocessor definitions
#
if(APPLE)
	# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-undefined,dynamic_lookup")
	# set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-undefined,dynamic_lookup")
	# set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,-undefined,dynamic_lookup")

	# add_definitions(-DENABLE_RTC_EVENT_LOG -DV8_DEPRECATION_WARNINGS -DNO_TCMALLOC
	# 	-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL -DCHROMIUM_BUILD
	# 	-DFIELDTRIAL_TESTING_ENABLED -D_LIBCPP_HAS_NO_ALIGNED_ALLOCATION
	# 	-DCR_XCODE_VERSION=0941 -DCR_CLANG_REVISION=\"336424-1\"
	# 	-D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D_FORTIFY_SOURCE=2
	# 	-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORE=0
	# 	-DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
	# 	-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DHAVE_SCTP
	# 	-DUSE_BUILTIN_SW_CODECS -DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
	# 	-DWEBRTC_POSIX -DWEBRTC_MAC -DABSL_ALLOCATOR_NOTHROW=1
	# 	-DGOOGLE_PROTOBUF_NO_RTTI -DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER -DHAVE_PTHREAD
	# 	-DHAVE_WEBRTC_VIDEO -DHAVE_WEBRTC_VOICE
	# ) # webrtc 69 release

	# add_definitions(-DENABLE_RTC_EVENT_LOG -DV8_DEPRECATION_WARNINGS -DNO_TCMALLOC
	# 	-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL -DCHROMIUM_BUILD
	# 	-DFIELDTRIAL_TESTING_ENABLED -D_LIBCPP_HAS_NO_ALIGNED_ALLOCATION
	# 	-DCR_XCODE_VERSION=0941 -DCR_CLANG_REVISION=\"344066-1\"
	# 	-D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D_FORTIFY_SOURCE=2
	# 	-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORE=0
	# 	-DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
	# 	-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DHAVE_SCTP
	# 	-DUSE_BUILTIN_SW_CODECS -DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
	# 	-DWEBRTC_POSIX -DWEBRTC_MAC -DABSL_ALLOCATOR_NOTHROW=1
	# 	-DGOOGLE_PROTOBUF_NO_RTTI -DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER -DHAVE_PTHREAD
	# 	-DHAVE_WEBRTC_VIDEO -DHAVE_WEBRTC_VOICE
	# ) # webrtc 70 release

	# add_definitions(-DENABLE_RTC_EVENT_LOG -DNO_TCMALLOC
	# 	-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL -DCHROMIUM_BUILD
	# 	-D_LIBCPP_HAS_NO_ALIGNED_ALLOCATION
	# 	-DCR_XCODE_VERSION=0941 -DCR_CLANG_REVISION=\"350768-3\"
	# 	-D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D_FORTIFY_SOURCE=2
	# 	-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORE=0
	# 	-DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
	# 	-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE
	# 	-DRTC_ENABLE_VP9 -DHAVE_SCTP -DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
	# 	-DWEBRTC_POSIX -DWEBRTC_MAC -DABSL_ALLOCATOR_NOTHROW=1 -DHAVE_SCTP
	# 	-DGOOGLE_PROTOBUF_NO_RTTI -DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER -DHAVE_PTHREAD
	# 	-DHAVE_WEBRTC_VIDEO -DHAVE_WEBRTC_VOICE
	# 	-D_GLIBCXX_USE_CXX11_ABI=0
	# 	-DJSON_USE_EXCEPTION=0
	# 	-DWEBRTC_USE_H264
	# ) # webrtc 73 release

	# add_definitions(-DENABLE_RTC_EVENT_LOG -DNO_TCMALLOC
	# 	-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL -DCHROMIUM_BUILD
	# 	-D_LIBCPP_HAS_NO_ALIGNED_ALLOCATION
	# 	-DCR_XCODE_VERSION=0941 -DCR_CLANG_REVISION=\"357692-1\"
	# 	-D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D_FORTIFY_SOURCE=2 -D_LIBCPP_ABI_UNSTABLE
	# 	-D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS -D_LIBCXXABI_DISABLE_VISIBILITY_ANNOTATIONS
	# 	-D_LIBCPP_ENABLE_NODISCARD -DCR_LIBCXX_REVISION=358423
	# 	-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORE=0
	# 	-DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
	# 	-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DRTC_ENABLE_VP9 -DHAVE_SCTP
	# 	-DWEBRTC_USE_H264 -DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
	# 	-DWEBRTC_POSIX -DWEBRTC_MAC -DABSL_ALLOCATOR_NOTHROW=1 -DHAVE_SCTP
	# 	-DGOOGLE_PROTOBUF_NO_RTTI -DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER -DHAVE_PTHREAD
	# 	-DHAVE_WEBRTC_VIDEO -DHAVE_WEBRTC_VOICE
	# 	-D_GLIBCXX_USE_CXX11_ABI=0
	# 	-DJSON_USE_EXCEPTION=0
	# ) # webrtc 75 release

	# add_definitions(-DENABLE_RTC_EVENT_LOG -DNO_TCMALLOC
	# 	-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL -DCHROMIUM_BUILD
	# 	-D_LIBCPP_HAS_NO_ALIGNED_ALLOCATION
	# 	-DCR_XCODE_VERSION=0941 -DCR_CLANG_REVISION=\"357692-1\"
	# 	-D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D_FORTIFY_SOURCE=2
	# 	-D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS -D_LIBCXXABI_DISABLE_VISIBILITY_ANNOTATIONS
	# 	-D_LIBCPP_ENABLE_NODISCARD -DCR_LIBCXX_REVISION=358423
	# 	-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORE=0
	# 	-DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
	# 	-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DRTC_ENABLE_VP9 -DHAVE_SCTP
	# 	-DWEBRTC_USE_H264 -DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
	# 	-DWEBRTC_POSIX -DWEBRTC_MAC -DABSL_ALLOCATOR_NOTHROW=1 -DHAVE_SCTP
	# 	-DGOOGLE_PROTOBUF_NO_RTTI -DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER -DHAVE_PTHREAD
	# ) # webrtc 75 release (libcxx_abi_unstable = false)

	add_definitions(-DENABLE_RTC_EVENT_LOG -DNO_TCMALLOC
		-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL -DOFFICIAL_BUILD -DCHROMIUM_BUILD
		-D_LIBCPP_HAS_NO_ALIGNED_ALLOCATION
		-DCR_XCODE_VERSION=0941 -DCR_CLANG_REVISION=\"361212-67510fac-3\"
		-D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D_FORTIFY_SOURCE=2
		-D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS -D_LIBCXXABI_DISABLE_VISIBILITY_ANNOTATIONS
		-D_LIBCPP_ENABLE_NODISCARD -DCR_LIBCXX_REVISION=361348
		-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORE=0
		-DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
		-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DRTC_ENABLE_VP9 -DHAVE_SCTP
		-DWEBRTC_USE_H264 -DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
		-DWEBRTC_POSIX -DWEBRTC_MAC -DABSL_ALLOCATOR_NOTHROW=1 -DHAVE_SCTP
		-DGOOGLE_PROTOBUF_NO_RTTI -DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER -DHAVE_PTHREAD
	) # webrtc 76 release official

	find_library(AUDIOTOOLBOX AudioToolbox)
	find_library(AVFOUNDATION AVFoundation)
	find_library(COCOA Cocoa)
	find_library(COREAUDIO CoreAudio)
	find_library(COREFOUNDATION CoreFoundation)
	find_library(COREGRAPHICS CoreGraphics)
	find_library(COREMEDIA CoreMedia)
	find_library(CORESERVICES CoreServices)
	find_library(COREVIDEO CoreVideo)
	find_library(FOUNDATION_FRAMEWORK Foundation)
	find_library(IOKIT IOKit)
	find_library(IOSURFACE IOSurface)
	find_library(SECURITY_FRAMEWORK Security)
	find_library(SYSTEMCONFIG SystemConfiguration)

	set(LIBWEBRTC_PLATFORM_DEPS
		${AUDIOTOOLBOX}
		${AVFOUNDATION}
		${COCOA}
		${COREAUDIO}
		${COREFOUNDATION}
		${COREGRAPHICS}
		${COREMEDIA}
		${CORESERVICES}
		${COREVIDEO}
		${FOUNDATION_FRAMEWORK}
		${IOKIT}
		${IOSURFACE}
		${SECURITY_FRAMEWORK}
		${SYSTEMCONFIG}
	)
elseif(UNIX)
	add_definitions(-DWEBRTC_POSIX)

	if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
		add_definitions(-DWEBRTC_LINUX -D_GLIBCXX_USE_CXX11_ABI=0)

		set(LIBWEBRTC_PLATFORM_DEPS
			-lrt
			-lX11
			-lGLU
			# -lGL
			# -lm # not sure
			# -ldl # not sure
		)
	endif()
endif()

if(WIN32 AND MSVC)
	# add_definitions(-DENABLE_RTC_EVENT_LOG -DV8_DEPRECATION_WARNINGS -DUSE_AURA=1 -DNO_TCMALLOC
	# 	-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL -DCHROMIUM_BUILD
	# 	-DFIELDTRIAL_TESTING_ENABLED
	# 	-D_HAS_EXCEPTIONS=0 -D__STD_C -D_CRT_RAND_S
	# 	-D_CRT_SECURE_NO_DEPRECATE -D_SCL_SECURE_NO_DEPRECATE -D_ATL_NO_OPENGL
	# 	-D_WINDOWS -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DPSAPI_VERSION=1 -DWIN32 -D_SECURE_ATL
	# 	-D_USING_V110_SDK71_ -DWINAPI_FAMILY=WINAPI_FAMILY_DESKTOP_APP -DWIN32_LEAN_AND_MEAN
	# 	-DNOMINMAX -D_UNICODE -DUNICODE
	# 	-DNTDDI_VERSION=0x0A000002 -D_WIN32_WINNT=0x0A00 -DWINVER=0x0A00
	# 	-DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
	# 	-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DHAVE_SCTP
	# 	-DUSE_BUILTIN_SW_CODECS -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
	# 	-DWEBRTC_WIN -DABSL_ALLOCATOR_NOTHROW=1
	# 	-DGOOGLE_PROTOBUF_NO_RTTI -DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER
	# ) # webrtc 69

	# add_definitions(-DENABLE_RTC_EVENT_LOG -DUSE_AURA=1 -DNO_TCMALLOC
	# 	-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL
	# 	-DCHROMIUM_BUILD "-DCR_CLANG_REVISION=\"350768-3\""
	# 	-D_HAS_EXCEPTIONS=0 -D__STD_C -D_CRT_RAND_S
	# 	-D_CRT_SECURE_NO_DEPRECATE -D_SCL_SECURE_NO_DEPRECATE -D_ATL_NO_OPENGL
	# 	-D_WINDOWS -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DPSAPI_VERSION=2 -DWIN32
	# 	-D_SECURE_ATL -D_USING_V110_SDK71_ -DWINAPI_FAMILY=WINAPI_FAMILY_DESKTOP_APP
	# 	-DWIN32_LEAN_AND_MEAN -DNOMINMAX -D_UNICODE -DUNICODE -DNTDDI_VERSION=0x0A000002
	# 	-D_WIN32_WINNT=0x0A00 -DWINVER=0x0A00 -DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
	# 	-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DRTC_ENABLE_VP9 -DHAVE_SCTP
	# 	-DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
	# 	-DWEBRTC_WIN -DABSL_ALLOCATOR_NOTHROW=1 -DHAVE_SCTP -DGOOGLE_PROTOBUF_NO_RTTI
	# 	-DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER
	# 	-D_HAS_NODISCARD
	# ) # WebRTC 73 Release

	add_definitions(-DENABLE_RTC_EVENT_LOG -DUSE_AURA=1 -DNO_TCMALLOC
		-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL
		-DCHROMIUM_BUILD "-DCR_CLANG_REVISION=\"357692-1\""
		-D_HAS_EXCEPTIONS=0 -D__STD_C -D_CRT_RAND_S
		-D_CRT_SECURE_NO_DEPRECATE -D_SCL_SECURE_NO_DEPRECATE -D_ATL_NO_OPENGL
		-D_WINDOWS -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DPSAPI_VERSION=2 -DWIN32
		-D_SECURE_ATL -D_USING_V110_SDK71_ -DWINAPI_FAMILY=WINAPI_FAMILY_DESKTOP_APP
		-DWIN32_LEAN_AND_MEAN -DNOMINMAX -D_UNICODE -DUNICODE -DNTDDI_VERSION=NTDDI_WIN10_RS2
		-D_WIN32_WINNT=0x0A00 -DWINVER=0x0A00 -DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
		-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DRTC_ENABLE_VP9 -DHAVE_SCTP
		-DWEBRTC_USE_H264 -DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
		-DWEBRTC_WIN -DABSL_ALLOCATOR_NOTHROW=1 -DHAVE_SCTP -DGOOGLE_PROTOBUF_NO_RTTI
		-DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER
		# -D_HAS_NODISCARD
		# -DOFFICIAL_BUILD
	) # WebRTC 75 Release

	# add_definitions(-DENABLE_RTC_EVENT_LOG -DUSE_AURA=1 -DNO_TCMALLOC
	# 	-DFULL_SAFE_BROWSING -DSAFE_BROWSING_CSD -DSAFE_BROWSING_DB_LOCAL
	# 	-DCHROMIUM_BUILD "-DCR_CLANG_REVISION=\"361212-67510fac-3\""
	# 	-D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS
	# 	-D_LIBCPP_NO_AUTO_LINK -D__STD_C -D_CRT_RAND_S
	# 	-D_CRT_SECURE_NO_DEPRECATE -D_SCL_SECURE_NO_DEPRECATE -D_ATL_NO_OPENGL
	# 	-D_WINDOWS -DCERT_CHAIN_PARA_HAS_EXTRA_FIELDS -DPSAPI_VERSION=2 -DWIN32
	# 	-D_SECURE_ATL -D_USING_V110_SDK71_ -DWINAPI_FAMILY=WINAPI_FAMILY_DESKTOP_APP
	# 	-DWIN32_LEAN_AND_MEAN -DNOMINMAX -D_UNICODE -DUNICODE -DNTDDI_VERSION=NTDDI_WIN10_RS2
	# 	-D_WIN32_WINNT=0x0A00 -DWINVER=0x0A00 -DNDEBUG -DNVALGRIND -DDYNAMIC_ANNOTATIONS_ENABLED=0
	# 	-DWEBRTC_ENABLE_PROTOBUF=1 -DWEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE -DRTC_ENABLE_VP9 -DHAVE_SCTP
	# 	-DWEBRTC_USE_H264 -DWEBRTC_LIBRARY_IMPL -DWEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=0
	# 	-DWEBRTC_WIN -DABSL_ALLOCATOR_NOTHROW=1 -DHAVE_SCTP -DGOOGLE_PROTOBUF_NO_RTTI
	# 	-DGOOGLE_PROTOBUF_NO_STATIC_INITIALIZER
	# 	# -D_HAS_NODISCARD -D_LIBCPP_ENABLE_NODISCARD
	# 	# -DOFFICIAL_BUILD 
	# ) # WebRTC 76 Release

	set(LIBWEBRTC_PLATFORM_DEPS
		secur32.lib
		winmm.lib
		msdmo.lib
		dmoguids.lib
		wmcodecdspuuid.lib
		ws2_32.lib
		iphlpapi.lib
		strmiids.lib # not sure
		amstrmid.lib # not sure
		crypt32.lib # not sure
		advapi32.lib # not sure
		# ole32.lib # not sure
		# psapi.lib # not sure
		# shell32.lib # not sure
		# dsound.lib # not sure
	)

	# set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MTd")
	# set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MT")
	# set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
	# set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
endif()

set(WEBRTC_FOUND ${LIBWEBRTC_FOUND})

if(LIBWEBRTC_FOUND)
	get_filename_component(LIBWEBRTC_ROOT_DIR ${WEBRTC_INCLUDE_DIR} DIRECTORY)
	set(WEBRTC_ROOT_DIR ${LIBWEBRTC_ROOT_DIR})

	set(LIBWEBRTC_INCLUDE_DIRS
		${WEBRTC_INCLUDE_DIR}
		${WEBRTC_INCLUDE_DIR}/third_party
		${WEBRTC_INCLUDE_DIR}/third_party/abseil-cpp
		${WEBRTC_INCLUDE_DIR}/third_party/libyuv/include
		${WEBRTC_INCLUDE_DIR}/third_party/boringssl/src/include
	)
	set(WEBRTC_INCLUDE_DIRS ${LIBWEBRTC_INCLUDE_DIRS})

	set(LIBWEBRTC_LIBRARY ${WEBRTC_LIB})
	set(WEBRTC_LIBRARY ${WEBRTC_LIB})

	mark_as_advanced(LIBWEBRTC_LIBRARY WEBRTC_LIBRARY)

	set(LIBWEBRTC_LIBRARIES
		${WEBRTC_LIB}
		${LIBWEBRTC_PLATFORM_DEPS}
	)
	set(WEBRTC_LIBRARIES ${LIBWEBRTC_LIBRARIES})

	message(STATUS "WEBRTC_ROOT_DIR: ${WEBRTC_ROOT_DIR}")
	message(STATUS "WEBRTC_INCLUDE_DIRS:")
	foreach(_dir ${WEBRTC_INCLUDE_DIRS})
		message(STATUS "-- ${_dir}")
	endforeach()
	message(STATUS "WEBRTC_LIBRARY: ${WEBRTC_LIBRARY}")
	message(STATUS "WEBRTC_LIBRARIES:")
	foreach(_lib ${WEBRTC_LIBRARIES})
		message(STATUS "-- ${_lib}")
	endforeach()
endif()
