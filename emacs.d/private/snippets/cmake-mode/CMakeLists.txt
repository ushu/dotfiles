# -*- mode: snippet -*-
#key : ini
#name : Basic CMakeLists.txt
#contributor: Aurélien Noce <aurelien@noce.fr>
# --
cmake_minimum_required(VERSION 3.8)
project($1)

set(CMAKE_CXX_STANDARD 17)

set(SOURCE_FILES $2)
add_executable(cppmap $\{SOURCE_FILES\})
