# Install script for directory: /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PreProcess/IDFVersionUpdater" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd/V7-2-0-Energy+.idd")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PreProcess/IDFVersionUpdater" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd/V8-0-0-Energy+.idd")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PreProcess/IDFVersionUpdater" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd/V8-1-0-Energy+.idd")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PreProcess/IDFVersionUpdater" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd/V8-2-0-Energy+.idd")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PreProcess/IDFVersionUpdater" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd/V8-3-0-Energy+.idd")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PreProcess/IDFVersionUpdater" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd/V8-4-0-Energy+.idd")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PreProcess/IDFVersionUpdater" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd/V8-5-0-Energy+.idd")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/PreProcess/IDFVersionUpdater" TYPE FILE FILES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/idd/V8-6-0-Energy+.idd")
endif()

