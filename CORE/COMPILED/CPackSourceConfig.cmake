# This file will be configured to contain variables for CPack. These variables
# should be set in the CMake list file of the project before CPack module is
# included. The list of available CPACK_xxx variables and their associated
# documentation may be obtained using
#  cpack --help-variable-list
#
# Some variables are common to all generators (e.g. CPACK_PACKAGE_NAME)
# and some are specific to a generator
# (e.g. CPACK_NSIS_EXTRA_INSTALL_COMMANDS). The generator specific variables
# usually begin with CPACK_<GENNAME>_xxxx.


SET(CPACK_BINARY_BUNDLE "")
SET(CPACK_BINARY_CYGWIN "")
SET(CPACK_BINARY_DEB "OFF")
SET(CPACK_BINARY_DRAGNDROP "")
SET(CPACK_BINARY_NSIS "OFF")
SET(CPACK_BINARY_OSXX11 "")
SET(CPACK_BINARY_PACKAGEMAKER "")
SET(CPACK_BINARY_RPM "OFF")
SET(CPACK_BINARY_STGZ "ON")
SET(CPACK_BINARY_TBZ2 "OFF")
SET(CPACK_BINARY_TGZ "ON")
SET(CPACK_BINARY_TZ "ON")
SET(CPACK_BINARY_WIX "")
SET(CPACK_BINARY_ZIP "")
SET(CPACK_CMAKE_GENERATOR "Unix Makefiles")
SET(CPACK_COMPONENT_UNSPECIFIED_HIDDEN "TRUE")
SET(CPACK_COMPONENT_UNSPECIFIED_REQUIRED "TRUE")
SET(CPACK_GENERATOR "TGZ;TBZ2;TZ")
SET(CPACK_IGNORE_FILES "/CVS/;/\\.svn/;/\\.bzr/;/\\.hg/;/\\.git/;\\.swp$;\\.#;/#")
SET(CPACK_INSTALLED_DIRECTORIES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718;/")
SET(CPACK_INSTALL_CMAKE_PROJECTS "")
SET(CPACK_INSTALL_PREFIX "/usr/local")
SET(CPACK_MODULE_PATH "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/cmake;/home/data/generic/EnergyPlus/COMPILED/BUILD170718/Modules")
SET(CPACK_NSIS_DISPLAY_NAME "EnergyPlus 8.8.0-Unknown")
SET(CPACK_NSIS_INSTALLER_ICON_CODE "")
SET(CPACK_NSIS_INSTALLER_MUI_ICON_CODE "")
SET(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
SET(CPACK_NSIS_PACKAGE_NAME "EnergyPlus 8.8.0-Unknown")
SET(CPACK_OUTPUT_CONFIG_FILE "/home/data/generic/EnergyPlus/COMPILED/BUILD170718/CPackConfig.cmake")
SET(CPACK_PACKAGE_CONTACT "Kyle Benne <Kyle.Benne@nrel.gov>")
SET(CPACK_PACKAGE_DEFAULT_LOCATION "/")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "/usr/share/cmake-3.0/Templates/CPack.GenericDescription.txt")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "EnergyPlus built using CMake")
SET(CPACK_PACKAGE_FILE_NAME "EnergyPlus-8.8.0-Unknown-Source")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "EnergyPlus 8.8.0-Unknown")
SET(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "EnergyPlus 8.8.0-Unknown")
SET(CPACK_PACKAGE_NAME "EnergyPlus")
SET(CPACK_PACKAGE_RELOCATABLE "true")
SET(CPACK_PACKAGE_VENDOR "US Department of Energy")
SET(CPACK_PACKAGE_VERSION "8.8.0-Unknown")
SET(CPACK_PACKAGE_VERSION_BUILD "Unknown")
SET(CPACK_PACKAGE_VERSION_MAJOR "8")
SET(CPACK_PACKAGE_VERSION_MINOR "7")
SET(CPACK_PACKAGE_VERSION_PATCH "0")
SET(CPACK_PACKAGING_INSTALL_PREFIX "/EnergyPlus-8-8-0")
SET(CPACK_PROJECT_CONFIG_FILE "/home/data/generic/EnergyPlus/COMPILED/BUILD170718/CMakeCPackOptions.cmake")
SET(CPACK_RESOURCE_FILE_LICENSE "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718/LICENSE.txt")
SET(CPACK_RESOURCE_FILE_README "/usr/share/cmake-3.0/Templates/CPack.GenericDescription.txt")
SET(CPACK_RESOURCE_FILE_WELCOME "/usr/share/cmake-3.0/Templates/CPack.GenericWelcome.txt")
SET(CPACK_SET_DESTDIR "OFF")
SET(CPACK_SOURCE_CYGWIN "")
SET(CPACK_SOURCE_GENERATOR "TGZ;TBZ2;TZ")
SET(CPACK_SOURCE_IGNORE_FILES "/CVS/;/\\.svn/;/\\.bzr/;/\\.hg/;/\\.git/;\\.swp$;\\.#;/#")
SET(CPACK_SOURCE_INSTALLED_DIRECTORIES "/home/data/generic/EnergyPlus/COMPILED/SOURCE170718;/")
SET(CPACK_SOURCE_OUTPUT_CONFIG_FILE "/home/data/generic/EnergyPlus/COMPILED/BUILD170718/CPackSourceConfig.cmake")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "EnergyPlus-8.8.0-Unknown-Source")
SET(CPACK_SOURCE_TBZ2 "ON")
SET(CPACK_SOURCE_TGZ "ON")
SET(CPACK_SOURCE_TOPLEVEL_TAG "Linux-Source")
SET(CPACK_SOURCE_TZ "ON")
SET(CPACK_SOURCE_ZIP "OFF")
SET(CPACK_STRIP_FILES "")
SET(CPACK_SYSTEM_NAME "Linux")
SET(CPACK_TOPLEVEL_TAG "Linux-Source")
SET(CPACK_WIX_SIZEOF_VOID_P "8")
