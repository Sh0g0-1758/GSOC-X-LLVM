cmake_minimum_required(VERSION 3.20.0)
project(find-decl)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

find_package(Clang REQUIRED CONFIG)
message(STATUS "Found Clang ${Clang_PACKAGE_VERSION}")
message(STATUS "Using ClangConfig.cmake in: ${Clang_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${Clang_INCLUDE_DIRS})

foreach(DIR ${CLANG_INCLUDE_DIRS})
    if(EXISTS ${DIR})
        include_directories(${DIR})
    else()
        message(FATAL_ERROR "Clang include directory ${DIR} not found.")
    endif()
endforeach()

separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})

add_executable(find-decl FindDecl.cpp)

llvm_map_components_to_libnames(llvm_libs support core irreader)

target_link_libraries(find-decl ${llvm_libs})
