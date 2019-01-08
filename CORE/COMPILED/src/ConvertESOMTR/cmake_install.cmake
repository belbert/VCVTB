# Install script for directory: /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/ConvertESOMTR

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PostProcess/convertESOMTRpgm" TYPE EXECUTABLE FILES "/home/data/generic/EnergyPlus/COMPILED/BUILD170718/Products/convertESOMTR")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/PostProcess/convertESOMTRpgm/convertESOMTR" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/PostProcess/convertESOMTRpgm/convertESOMTR")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/PostProcess/convertESOMTRpgm/convertESOMTR")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  
        include("/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/ConvertESOMTR/../../cmake/ProjectMacros.cmake")
        fixup_executable("${CMAKE_INSTALL_PREFIX}/PostProcess/convertESOMTRpgm//convertESOMTR")
      
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PostProcess/convertESOMTRpgm" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/ConvertESOMTR/convert.txt")
endif()

