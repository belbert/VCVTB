# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.0

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/data/generic/EnergyPlus/COMPILED/SOURCE170718

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/data/generic/EnergyPlus/COMPILED/BUILD170718

# Include any dependencies generated for this target.
include src/EnergyPlus/CMakeFiles/energyplusapi.dir/depend.make

# Include the progress variables for this target.
include src/EnergyPlus/CMakeFiles/energyplusapi.dir/progress.make

# Include the compile flags for this target's objects.
include src/EnergyPlus/CMakeFiles/energyplusapi.dir/flags.make

src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o: src/EnergyPlus/CMakeFiles/energyplusapi.dir/flags.make
src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o: /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus/CommandLineInterface.cc
	$(CMAKE_COMMAND) -E cmake_progress_report /home/data/generic/EnergyPlus/COMPILED/BUILD170718/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o"
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o -c /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus/CommandLineInterface.cc

src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.i"
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus/CommandLineInterface.cc > CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.i

src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.s"
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus/CommandLineInterface.cc -o CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.s

src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o.requires:
.PHONY : src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o.requires

src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o.provides: src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o.requires
	$(MAKE) -f src/EnergyPlus/CMakeFiles/energyplusapi.dir/build.make src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o.provides.build
.PHONY : src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o.provides

src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o.provides.build: src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o

src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o: src/EnergyPlus/CMakeFiles/energyplusapi.dir/flags.make
src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o: /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus/EnergyPlusPgm.cc
	$(CMAKE_COMMAND) -E cmake_progress_report /home/data/generic/EnergyPlus/COMPILED/BUILD170718/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o"
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o -c /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus/EnergyPlusPgm.cc

src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.i"
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus/EnergyPlusPgm.cc > CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.i

src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.s"
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus/EnergyPlusPgm.cc -o CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.s

src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o.requires:
.PHONY : src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o.requires

src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o.provides: src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o.requires
	$(MAKE) -f src/EnergyPlus/CMakeFiles/energyplusapi.dir/build.make src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o.provides.build
.PHONY : src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o.provides

src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o.provides.build: src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o

# Object files for target energyplusapi
energyplusapi_OBJECTS = \
"CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o" \
"CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o"

# External object files for target energyplusapi
energyplusapi_EXTERNAL_OBJECTS =

Products/libenergyplusapi.so.8.8.0: src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o
Products/libenergyplusapi.so.8.8.0: src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o
Products/libenergyplusapi.so.8.8.0: src/EnergyPlus/CMakeFiles/energyplusapi.dir/build.make
Products/libenergyplusapi.so.8.8.0: Products/libenergypluslib.a
Products/libenergyplusapi.so.8.8.0: Products/libobjexx.so
Products/libenergyplusapi.so.8.8.0: Products/libsqlite.so
Products/libenergyplusapi.so.8.8.0: Products/libbcvtb.a
Products/libenergyplusapi.so.8.8.0: Products/libepfmiimport.a
Products/libenergyplusapi.so.8.8.0: Products/libepexpat.a
Products/libenergyplusapi.so.8.8.0: Products/libminiziplib.a
Products/libenergyplusapi.so.8.8.0: Products/libre2.so
Products/libenergyplusapi.so.8.8.0: Products/libDElight.a
Products/libenergyplusapi.so.8.8.0: Products/libjsoncpp.a
Products/libenergyplusapi.so.8.8.0: Products/libkiva.a
Products/libenergyplusapi.so.8.8.0: src/EnergyPlus/CMakeFiles/energyplusapi.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX shared library ../../Products/libenergyplusapi.so"
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/energyplusapi.dir/link.txt --verbose=$(VERBOSE)
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && $(CMAKE_COMMAND) -E cmake_symlink_library ../../Products/libenergyplusapi.so.8.8.0 ../../Products/libenergyplusapi.so.8.8.0 ../../Products/libenergyplusapi.so

Products/libenergyplusapi.so: Products/libenergyplusapi.so.8.8.0

# Rule to build all files generated by this target.
src/EnergyPlus/CMakeFiles/energyplusapi.dir/build: Products/libenergyplusapi.so
.PHONY : src/EnergyPlus/CMakeFiles/energyplusapi.dir/build

src/EnergyPlus/CMakeFiles/energyplusapi.dir/requires: src/EnergyPlus/CMakeFiles/energyplusapi.dir/CommandLineInterface.cc.o.requires
src/EnergyPlus/CMakeFiles/energyplusapi.dir/requires: src/EnergyPlus/CMakeFiles/energyplusapi.dir/EnergyPlusPgm.cc.o.requires
.PHONY : src/EnergyPlus/CMakeFiles/energyplusapi.dir/requires

src/EnergyPlus/CMakeFiles/energyplusapi.dir/clean:
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus && $(CMAKE_COMMAND) -P CMakeFiles/energyplusapi.dir/cmake_clean.cmake
.PHONY : src/EnergyPlus/CMakeFiles/energyplusapi.dir/clean

src/EnergyPlus/CMakeFiles/energyplusapi.dir/depend:
	cd /home/data/generic/EnergyPlus/COMPILED/BUILD170718 && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/data/generic/EnergyPlus/COMPILED/SOURCE170718 /home/data/generic/EnergyPlus/COMPILED/SOURCE170718/src/EnergyPlus /home/data/generic/EnergyPlus/COMPILED/BUILD170718 /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus /home/data/generic/EnergyPlus/COMPILED/BUILD170718/src/EnergyPlus/CMakeFiles/energyplusapi.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/EnergyPlus/CMakeFiles/energyplusapi.dir/depend

