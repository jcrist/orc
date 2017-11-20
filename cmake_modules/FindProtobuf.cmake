# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# PROTOBUF_HOME environmental variable is used to check for Protobuf headers and static library

# PROTOBUF_FOUND is set if Protobuf is found
# PROTOBUF_INCLUDE_DIR: directory containing headers
# PROTOBUF_LIBS: directory containing Protobuf libraries
# PROTOBUF_STATIC_LIB: location of protobuf.a
# PROTOC_STATIC_LIB: location of protoc.a
# PROTOBUF_EXECUTABLE: location of protoc


if( NOT "${PROTOBUF_HOME}" STREQUAL "")
    file (TO_CMAKE_PATH "${PROTOBUF_HOME}" _protobuf_path)
endif()

message (STATUS "PROTOBUF_HOME: ${PROTOBUF_HOME}")

find_path (PROTOBUF_INCLUDE_DIR google/protobuf/io/zero_copy_stream.h HINTS
  ${_protobuf_path}
  NO_DEFAULT_PATH
  PATH_SUFFIXES "include")

find_path (PROTOBUF_INCLUDE_DIR google/protobuf/io/coded_stream.h HINTS
  ${_protobuf_path}
  NO_DEFAULT_PATH
  PATH_SUFFIXES "include")

find_library (PROTOBUF_LIBRARY NAMES protobuf PATHS
  ${_protobuf_path}
  NO_DEFAULT_PATH
  PATH_SUFFIXES "lib")

find_library (PROTOC_LIBRARY NAMES protoc PATHS
  ${_protobuf_path}
  NO_DEFAULT_PATH
  PATH_SUFFIXES "lib")

find_program(PROTOBUF_EXECUTABLE protoc HINTS
  ${_protobuf_path}
  NO_DEFAULT_PATH
  PATH_SUFFIXES "bin")

if (PROTOBUF_INCLUDE_DIR AND PROTOBUF_LIBRARY AND PROTOC_LIBRARY AND PROTOBUF_EXECUTABLE)
  set (PROTOBUF_FOUND TRUE)
  get_filename_component (PROTOBUF_LIBS ${PROTOBUF_LIBRARY} PATH)
  set (PROTOBUF_LIB_NAME protobuf)
  set (PROTOC_LIB_NAME protoc)
  set (PROTOBUF_STATIC_LIB ${PROTOBUF_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${PROTOBUF_LIB_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX})
  set (PROTOC_STATIC_LIB ${PROTOBUF_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}${PROTOC_LIB_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX})
else ()
  set (PROTOBUF_FOUND FALSE)
endif ()

if (PROTOBUF_FOUND)
  message (STATUS "Found the Protobuf headers: ${PROTOBUF_INCLUDE_DIR}")
  message (STATUS "Found the Protobuf library: ${PROTOBUF_STATIC_LIB}")
  message (STATUS "Found the Protoc library: ${PROTOC_STATIC_LIB}")
  message (STATUS "Found the Protoc executable: ${PROTOBUF_EXECUTABLE}")
else()
  if (_protobuf_path)
    message (STATUS "Could not find Protobuf. Looked in ${_protobuf_path}.")
  else ()
    message (STATUS "Could not find Protobuf in system search paths.")
  endif()
endif()

mark_as_advanced (
  PROTOBUF_INCLUDE_DIR
  PROTOBUF_LIBS
  PROTOBUF_STATIC_LIB
  PROTOC_STATIC_LIB
)