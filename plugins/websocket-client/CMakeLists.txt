project(websocketclient)

#------------------------------------------------------------------------
# Global setup
#
set(CMAKE_CXX_STANDARD 11)

if(WIN32)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4503 /wd4267 /wd4244 /wd4996")
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/restclient-cpp/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/websocketpp)
include_directories(${CMAKE_SOURCE_DIR}/libobs)

#------------------------------------------------------------------------
# JSON
#
set(JSON_BuildTests OFF CACHE INTERNAL "")
# set(JSON_Install OFF CACHE INTERNAL "")
add_subdirectory(nlohmann_json)

#------------------------------------------------------------------------
# OpenSSL
#
find_package(OpenSSL 1.1 REQUIRED)

if(NOT ${OPENSSL_FOUND})
	message(FATAL_ERROR "OpenSSL not found")
endif()

message(STATUS "OPENSSL_INCLUDE_DIR: ${OPENSSL_INCLUDE_DIR}")
message(STATUS "OPENSSL_CRYPTO_LIBRARY: ${OPENSSL_CRYPTO_LIBRARY}")
message(STATUS "OPENSSL_SSL_LIBRARY: ${OPENSSL_SSL_LIBRARY}")
message(STATUS "OPENSSL_VERSION: ${OPENSSL_VERSION}")

include_directories(${OPENSSL_INCLUDE_DIR})

#------------------------------------------------------------------------
# ASIO
#
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/third_party/asio/include)
include_directories(${CURL_INCLUDE_DIR})

#------------------------------------------------------------------------
# WebSocket
#
<<<<<<< HEAD
# NOTE ALEX: to accomodate all vendors who want a branded interface and
# support only their service, we shoul dmake it modular here.
set( websocketclient_SOURCES 
  JanusWebsocketClientImpl.cpp
  WowzaWebsocketClientImpl.cpp
  EvercastWebsocketClientImpl.cpp
  MillicastWebsocketClientImpl.cpp
  WebsocketClient.cpp
  restclient-cpp/source/connection.cc
  restclient-cpp/source/helpers.cc
  restclient-cpp/source/restclient.cc
  )
if( WIN32 )
  set( websocketclient_SOURCES ${websocketclient_SOURCES} dllmain.cpp )
=======
set(websocketclient_SOURCES
	WebsocketClient.cpp
	WowzaWebsocketClientImpl.cpp
	JanusWebsocketClientImpl.cpp
	MillicastWebsocketClientImpl.cpp
	EvercastWebsocketClientImpl.cpp
	restclient-cpp/source/connection.cc
	restclient-cpp/source/helpers.cc
	restclient-cpp/source/restclient.cc)
if(WIN32)
	set(websocketclient_SOURCES ${websocketclient_SOURCES} dllmain.cpp)
>>>>>>> 5ed0dd3c... update to OBS 23.2
endif()

add_definitions(-DWEBSOCKETCLIENT_EXPORTS)

<<<<<<< HEAD
set( websocketclient_HEADERS
  json.hpp
  JanusWebsocketClientImpl.h
  WowzaWebsocketClientImpl.h
  EvercastWebsocketClientImpl.h
  MillicastWebsocketClientImpl.h
  WebsocketClient.h
  )
=======
set(websocketclient_HEADERS
	WebsocketClient.h
	WowzaWebsocketClientImpl.h
	JanusWebsocketClientImpl.h
	MillicastWebsocketClientImpl.h
	EvercastWebsocketClientImpl.h)
>>>>>>> 5ed0dd3c... update to OBS 23.2

add_library(websocketclient SHARED
	${websocketclient_SOURCES}
	${websocketclient_HEADERS})

<<<<<<< HEAD
target_link_libraries( websocketclient
  # NOTE ALEX: this is project specific and not using the standard module
  ${CURL_LIB}
  ${OPENSSL_LIBRARIES}
  libobs
  )
=======
target_link_libraries(websocketclient
	PUBLIC libobs
	PUBLIC ${CURL_LIB}
	PUBLIC ${OPENSSL_LIBRARIES}
	PRIVATE nlohmann_json::nlohmann_json)
>>>>>>> 5ed0dd3c... update to OBS 23.2

install_obs_plugin(websocketclient)
